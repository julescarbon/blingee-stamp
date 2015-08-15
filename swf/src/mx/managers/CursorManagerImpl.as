package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import flash.ui.*;

    public class CursorManagerImpl implements ICursorManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:ICursorManager;

        private var showSystemCursor:Boolean = false;
        private var nextCursorID:int = 1;
        private var systemManager:ISystemManager = null;
        private var cursorList:Array;
        private var _currentCursorYOffset:Number = 0;
        private var cursorHolder:Sprite;
        private var currentCursor:DisplayObject;
        private var sandboxRoot:IEventDispatcher = null;
        private var showCustomCursor:Boolean = false;
        private var listenForContextMenu:Boolean = false;
        private var _currentCursorID:int = 0;
        private var initialized:Boolean = false;
        private var overTextField:Boolean = false;
        private var _currentCursorXOffset:Number = 0;
        private var busyCursorList:Array;
        private var overLink:Boolean = false;
        private var sourceArray:Array;

        public function CursorManagerImpl(_arg1:ISystemManager=null){
            cursorList = [];
            busyCursorList = [];
            sourceArray = [];
            super();
            if (((instance) && (!(_arg1)))){
                throw (new Error("Instance already exists."));
            };
            if (_arg1){
                this.systemManager = (_arg1 as ISystemManager);
            } else {
                this.systemManager = (SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager);
            };
            sandboxRoot = this.systemManager.getSandboxRoot();
            sandboxRoot.addEventListener(InterManagerRequest.CURSOR_MANAGER_REQUEST, marshalCursorManagerHandler, false, 0, true);
            var _local2:InterManagerRequest = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
            _local2.name = "update";
            sandboxRoot.dispatchEvent(_local2);
        }
        public static function getInstance():ICursorManager{
            if (!instance){
                instance = new (CursorManagerImpl)();
            };
            return (instance);
        }

        public function set currentCursorYOffset(_arg1:Number):void{
            var _local2:InterManagerRequest;
            _currentCursorYOffset = _arg1;
            if (!cursorHolder){
                _local2 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local2.name = "currentCursorYOffset";
                _local2.value = currentCursorYOffset;
                sandboxRoot.dispatchEvent(_local2);
            };
        }
        public function get currentCursorXOffset():Number{
            return (_currentCursorXOffset);
        }
        public function removeCursor(_arg1:int):void{
            var _local2:Object;
            var _local3:InterManagerRequest;
            var _local4:CursorQueueItem;
            if (((initialized) && (!(cursorHolder)))){
                _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local3.name = "removeCursor";
                _local3.value = _arg1;
                sandboxRoot.dispatchEvent(_local3);
                return;
            };
            for (_local2 in cursorList) {
                _local4 = cursorList[_local2];
                if (_local4.cursorID == _arg1){
                    cursorList.splice(_local2, 1);
                    showCurrentCursor();
                    break;
                };
            };
        }
        public function get currentCursorID():int{
            return (_currentCursorID);
        }
        private function marshalMouseMoveHandler(_arg1:Event):void{
            var _local2:SWFBridgeRequest;
            var _local3:IEventDispatcher;
            if (cursorHolder.visible){
                cursorHolder.visible = false;
                _local2 = new SWFBridgeRequest(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST);
                if (systemManager.useSWFBridge()){
                    _local3 = systemManager.swfBridgeGroup.parentBridge;
                } else {
                    _local3 = systemManager;
                };
                _local2.requestor = _local3;
                _local3.dispatchEvent(_local2);
                if (_local2.data){
                    Mouse.show();
                };
            };
        }
        public function set currentCursorID(_arg1:int):void{
            var _local2:InterManagerRequest;
            _currentCursorID = _arg1;
            if (!cursorHolder){
                _local2 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local2.name = "currentCursorID";
                _local2.value = currentCursorID;
                sandboxRoot.dispatchEvent(_local2);
            };
        }
        public function removeAllCursors():void{
            var _local1:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local1 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local1.name = "removeAllCursors";
                sandboxRoot.dispatchEvent(_local1);
                return;
            };
            cursorList.splice(0);
            showCurrentCursor();
        }
        private function priorityCompare(_arg1:CursorQueueItem, _arg2:CursorQueueItem):int{
            if (_arg1.priority < _arg2.priority){
                return (-1);
            };
            if (_arg1.priority == _arg2.priority){
                return (0);
            };
            return (1);
        }
        public function setBusyCursor():void{
            var _local3:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local3.name = "setBusyCursor";
                sandboxRoot.dispatchEvent(_local3);
                return;
            };
            var _local1:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CursorManager");
            var _local2:Class = _local1.getStyle("busyCursor");
            busyCursorList.push(setCursor(_local2, CursorManagerPriority.LOW));
        }
        public function showCursor():void{
            var _local1:InterManagerRequest;
            if (cursorHolder){
                cursorHolder.visible = true;
            } else {
                _local1 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local1.name = "showCursor";
                sandboxRoot.dispatchEvent(_local1);
            };
        }
        private function findSource(_arg1:Object):int{
            var _local2:int = sourceArray.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (sourceArray[_local3] === _arg1){
                    return (_local3);
                };
                _local3++;
            };
            return (-1);
        }
        private function showCurrentCursor():void{
            var _local1:InteractiveObject;
            var _local2:InteractiveObject;
            var _local3:CursorQueueItem;
            var _local4:InterManagerRequest;
            var _local5:Point;
            if (cursorList.length > 0){
                if (!initialized){
                    cursorHolder = new FlexSprite();
                    cursorHolder.name = "cursorHolder";
                    cursorHolder.mouseEnabled = false;
                    cursorHolder.mouseChildren = false;
                    systemManager.addChildToSandboxRoot("cursorChildren", cursorHolder);
                    initialized = true;
                    _local4 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                    _local4.name = "initialized";
                    sandboxRoot.dispatchEvent(_local4);
                };
                _local3 = cursorList[0];
                if (currentCursorID == CursorManager.NO_CURSOR){
                    Mouse.hide();
                };
                if (_local3.cursorID != currentCursorID){
                    if (cursorHolder.numChildren > 0){
                        cursorHolder.removeChildAt(0);
                    };
                    currentCursor = new _local3.cursorClass();
                    if (currentCursor){
                        if ((currentCursor is InteractiveObject)){
                            InteractiveObject(currentCursor).mouseEnabled = false;
                        };
                        if ((currentCursor is DisplayObjectContainer)){
                            DisplayObjectContainer(currentCursor).mouseChildren = false;
                        };
                        cursorHolder.addChild(currentCursor);
                        if (!listenForContextMenu){
                            _local1 = (systemManager.document as InteractiveObject);
                            if (((_local1) && (_local1.contextMenu))){
                                _local1.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler);
                                listenForContextMenu = true;
                            };
                            _local2 = (systemManager as InteractiveObject);
                            if (((_local2) && (_local2.contextMenu))){
                                _local2.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler);
                                listenForContextMenu = true;
                            };
                        };
                        if ((systemManager is SystemManager)){
                            _local5 = new Point((SystemManager(systemManager).mouseX + _local3.x), (SystemManager(systemManager).mouseY + _local3.y));
                            _local5 = SystemManager(systemManager).localToGlobal(_local5);
                            _local5 = cursorHolder.parent.globalToLocal(_local5);
                            cursorHolder.x = _local5.x;
                            cursorHolder.y = _local5.y;
                        } else {
                            if ((systemManager is DisplayObject)){
                                _local5 = new Point((DisplayObject(systemManager).mouseX + _local3.x), (DisplayObject(systemManager).mouseY + _local3.y));
                                _local5 = DisplayObject(systemManager).localToGlobal(_local5);
                                _local5 = cursorHolder.parent.globalToLocal(_local5);
                                cursorHolder.x = (DisplayObject(systemManager).mouseX + _local3.x);
                                cursorHolder.y = (DisplayObject(systemManager).mouseY + _local3.y);
                            } else {
                                cursorHolder.x = _local3.x;
                                cursorHolder.y = _local3.y;
                            };
                        };
                        if (systemManager.useSWFBridge()){
                            sandboxRoot.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true, EventPriority.CURSOR_MANAGEMENT);
                        } else {
                            systemManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true, EventPriority.CURSOR_MANAGEMENT);
                        };
                        sandboxRoot.addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, marshalMouseMoveHandler, false, EventPriority.CURSOR_MANAGEMENT);
                    };
                    currentCursorID = _local3.cursorID;
                    currentCursorXOffset = _local3.x;
                    currentCursorYOffset = _local3.y;
                };
            } else {
                if (currentCursorID != CursorManager.NO_CURSOR){
                    currentCursorID = CursorManager.NO_CURSOR;
                    currentCursorXOffset = 0;
                    currentCursorYOffset = 0;
                    if (systemManager.useSWFBridge()){
                        sandboxRoot.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
                    } else {
                        systemManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
                    };
                    sandboxRoot.removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, marshalMouseMoveHandler, false);
                    cursorHolder.removeChild(currentCursor);
                    if (listenForContextMenu){
                        _local1 = (systemManager.document as InteractiveObject);
                        if (((_local1) && (_local1.contextMenu))){
                            _local1.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler);
                        };
                        _local2 = (systemManager as InteractiveObject);
                        if (((_local2) && (_local2.contextMenu))){
                            _local2.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, contextMenu_menuSelectHandler);
                        };
                        listenForContextMenu = false;
                    };
                };
                Mouse.show();
            };
        }
        public function get currentCursorYOffset():Number{
            return (_currentCursorYOffset);
        }
        private function contextMenu_menuSelectHandler(_arg1:ContextMenuEvent):void{
            showCustomCursor = true;
            sandboxRoot.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        }
        public function hideCursor():void{
            var _local1:InterManagerRequest;
            if (cursorHolder){
                cursorHolder.visible = false;
            } else {
                _local1 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local1.name = "hideCursor";
                sandboxRoot.dispatchEvent(_local1);
            };
        }
        private function marshalCursorManagerHandler(_arg1:Event):void{
            var _local3:InterManagerRequest;
            if ((_arg1 is InterManagerRequest)){
                return;
            };
            var _local2:Object = _arg1;
            switch (_local2.name){
                case "initialized":
                    initialized = _local2.value;
                    break;
                case "currentCursorID":
                    _currentCursorID = _local2.value;
                    break;
                case "currentCursorXOffset":
                    _currentCursorXOffset = _local2.value;
                    break;
                case "currentCursorYOffset":
                    _currentCursorYOffset = _local2.value;
                    break;
                case "showCursor":
                    if (cursorHolder){
                        cursorHolder.visible = true;
                    };
                    break;
                case "hideCursor":
                    if (cursorHolder){
                        cursorHolder.visible = false;
                    };
                    break;
                case "setCursor":
                    if (cursorHolder){
                        _local2.value = setCursor.apply(this, _local2.value);
                    };
                    break;
                case "removeCursor":
                    if (cursorHolder){
                        removeCursor.apply(this, [_local2.value]);
                    };
                    break;
                case "removeAllCursors":
                    if (cursorHolder){
                        removeAllCursors();
                    };
                    break;
                case "setBusyCursor":
                    if (cursorHolder){
                        setBusyCursor();
                    };
                    break;
                case "removeBusyCursor":
                    if (cursorHolder){
                        removeBusyCursor();
                    };
                    break;
                case "registerToUseBusyCursor":
                    if (cursorHolder){
                        registerToUseBusyCursor.apply(this, _local2.value);
                    };
                    break;
                case "unRegisterToUseBusyCursor":
                    if (cursorHolder){
                        unRegisterToUseBusyCursor.apply(this, _local2.value);
                    };
                    break;
                case "update":
                    if (cursorHolder){
                        _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                        _local3.name = "initialized";
                        _local3.value = true;
                        sandboxRoot.dispatchEvent(_local3);
                        _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                        _local3.name = "currentCursorID";
                        _local3.value = currentCursorID;
                        sandboxRoot.dispatchEvent(_local3);
                        _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                        _local3.name = "currentCursorXOffset";
                        _local3.value = currentCursorXOffset;
                        sandboxRoot.dispatchEvent(_local3);
                        _local3 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                        _local3.name = "currentCursorYOffset";
                        _local3.value = currentCursorYOffset;
                        sandboxRoot.dispatchEvent(_local3);
                    };
            };
        }
        public function registerToUseBusyCursor(_arg1:Object):void{
            var _local2:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local2 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local2.name = "registerToUseBusyCursor";
                _local2.value = _arg1;
                sandboxRoot.dispatchEvent(_local2);
                return;
            };
            if (((_arg1) && ((_arg1 is EventDispatcher)))){
                _arg1.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                _arg1.addEventListener(Event.COMPLETE, completeHandler);
                _arg1.addEventListener(IOErrorEvent.IO_ERROR, completeHandler);
            };
        }
        private function completeHandler(_arg1:Event):void{
            var _local2:int = findSource(_arg1.target);
            if (_local2 != -1){
                sourceArray.splice(_local2, 1);
                removeBusyCursor();
            };
        }
        public function removeBusyCursor():void{
            var _local1:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local1 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local1.name = "removeBusyCursor";
                sandboxRoot.dispatchEvent(_local1);
                return;
            };
            if (busyCursorList.length > 0){
                removeCursor(int(busyCursorList.pop()));
            };
        }
        public function setCursor(_arg1:Class, _arg2:int=2, _arg3:Number=0, _arg4:Number=0):int{
            var _local7:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local7 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local7.name = "setCursor";
                _local7.value = [_arg1, _arg2, _arg3, _arg4];
                sandboxRoot.dispatchEvent(_local7);
                return ((_local7.value as int));
            };
            var _local5:int = nextCursorID++;
            var _local6:CursorQueueItem = new CursorQueueItem();
            _local6.cursorID = _local5;
            _local6.cursorClass = _arg1;
            _local6.priority = _arg2;
            _local6.x = _arg3;
            _local6.y = _arg4;
            if (systemManager){
                _local6.systemManager = systemManager;
            } else {
                _local6.systemManager = ApplicationGlobals.application.systemManager;
            };
            cursorList.push(_local6);
            cursorList.sort(priorityCompare);
            showCurrentCursor();
            return (_local5);
        }
        private function progressHandler(_arg1:ProgressEvent):void{
            var _local2:int = findSource(_arg1.target);
            if (_local2 == -1){
                sourceArray.push(_arg1.target);
                setBusyCursor();
            };
        }
        private function mouseMoveHandler(_arg1:MouseEvent):void{
            var _local4:SWFBridgeRequest;
            var _local5:IEventDispatcher;
            var _local2:Point = new Point(_arg1.stageX, _arg1.stageY);
            _local2 = cursorHolder.parent.globalToLocal(_local2);
            _local2.x = (_local2.x + currentCursorXOffset);
            _local2.y = (_local2.y + currentCursorYOffset);
            cursorHolder.x = _local2.x;
            cursorHolder.y = _local2.y;
            var _local3:Object = _arg1.target;
            if (((((!(overTextField)) && ((_local3 is TextField)))) && ((_local3.type == TextFieldType.INPUT)))){
                overTextField = true;
                showSystemCursor = true;
            } else {
                if (((overTextField) && (!((((_local3 is TextField)) && ((_local3.type == TextFieldType.INPUT))))))){
                    overTextField = false;
                    showCustomCursor = true;
                } else {
                    showCustomCursor = true;
                };
            };
            if (showSystemCursor){
                showSystemCursor = false;
                cursorHolder.visible = false;
                Mouse.show();
            };
            if (showCustomCursor){
                showCustomCursor = false;
                cursorHolder.visible = true;
                Mouse.hide();
                _local4 = new SWFBridgeRequest(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST);
                if (systemManager.useSWFBridge()){
                    _local5 = systemManager.swfBridgeGroup.parentBridge;
                } else {
                    _local5 = systemManager;
                };
                _local4.requestor = _local5;
                _local5.dispatchEvent(_local4);
            };
        }
        public function unRegisterToUseBusyCursor(_arg1:Object):void{
            var _local2:InterManagerRequest;
            if (((initialized) && (!(cursorHolder)))){
                _local2 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local2.name = "unRegisterToUseBusyCursor";
                _local2.value = _arg1;
                sandboxRoot.dispatchEvent(_local2);
                return;
            };
            if (((_arg1) && ((_arg1 is EventDispatcher)))){
                _arg1.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
                _arg1.removeEventListener(Event.COMPLETE, completeHandler);
                _arg1.removeEventListener(IOErrorEvent.IO_ERROR, completeHandler);
            };
        }
        private function mouseOverHandler(_arg1:MouseEvent):void{
            sandboxRoot.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            mouseMoveHandler(_arg1);
        }
        public function set currentCursorXOffset(_arg1:Number):void{
            var _local2:InterManagerRequest;
            _currentCursorXOffset = _arg1;
            if (!cursorHolder){
                _local2 = new InterManagerRequest(InterManagerRequest.CURSOR_MANAGER_REQUEST);
                _local2.name = "currentCursorXOffset";
                _local2.value = currentCursorXOffset;
                sandboxRoot.dispatchEvent(_local2);
            };
        }

    }
}//package mx.managers 

class CursorQueueItem {

    mx_internal static const VERSION:String = "3.2.0.3958";

    public var priority:int = 2;
    public var cursorClass:Class = null;
    public var cursorID:int = 0;
    public var x:Number;
    public var y:Number;
    public var systemManager:ISystemManager;

    public function CursorQueueItem(){
    }
}
