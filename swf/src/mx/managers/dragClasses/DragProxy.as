package mx.managers.dragClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;

    public class DragProxy extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var $visible:QName = new QName(mx_internal, "$visible");

        public var allowMove:Boolean = true;
        private var cursorClass:Class = null;
        public var action:String;
        private var sandboxRoot:IEventDispatcher;
        public var target:DisplayObject = null;
        public var dragInitiator:IUIComponent;
        public var xOffset:Number;
        public var yOffset:Number;
        public var dragSource:DragSource;
        private var cursorID:int = 0;
        private var lastMouseEvent:MouseEvent;
        public var startX:Number;
        public var startY:Number;
        private var lastKeyEvent:KeyboardEvent;

        public function DragProxy(_arg1:IUIComponent, _arg2:DragSource){
            this.dragInitiator = _arg1;
            this.dragSource = _arg2;
            var _local3:ISystemManager = (_arg1.systemManager.topLevelSystemManager as ISystemManager);
            var _local4:IEventDispatcher = (sandboxRoot = _local3.getSandboxRoot());
            _local4.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
            _local4.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            _local4.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            _local4.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }
        private static function getObjectsUnderPoint(_arg1:DisplayObject, _arg2:Point, _arg3:Array):void{
            var doc:* = null;
            var rc:* = null;
            var n:* = 0;
            var i:* = 0;
            var child:* = null;
            var obj:* = _arg1;
            var pt:* = _arg2;
            var arr:* = _arg3;
            if (!obj.visible){
                return;
            };
            try {
                if (!obj[$visible]){
                    return;
                };
            } catch(e:Error) {
            };
            if (obj.hitTestPoint(pt.x, pt.y, true)){
                if ((((obj is InteractiveObject)) && (InteractiveObject(obj).mouseEnabled))){
                    arr.push(obj);
                };
                if ((obj is DisplayObjectContainer)){
                    doc = (obj as DisplayObjectContainer);
                    if (doc.mouseChildren){
                        if (("rawChildren" in doc)){
                            rc = doc["rawChildren"];
                            n = rc.numChildren;
                            i = 0;
                            while (i < n) {
                                try {
                                    getObjectsUnderPoint(rc.getChildAt(i), pt, arr);
                                } catch(e:Error) {
                                };
                                i = (i + 1);
                            };
                        } else {
                            if (doc.numChildren){
                                n = doc.numChildren;
                                i = 0;
                                while (i < n) {
                                    try {
                                        child = doc.getChildAt(i);
                                        getObjectsUnderPoint(child, pt, arr);
                                    } catch(e:Error) {
                                    };
                                    i = (i + 1);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function mouseUpHandler(_arg1:MouseEvent):void{
            var _local2:DragEvent;
            var _local6:Point;
            var _local7:Move;
            var _local8:Zoom;
            var _local9:Move;
            var _local3:ISystemManager = (dragInitiator.systemManager.topLevelSystemManager as ISystemManager);
            var _local4:IEventDispatcher = sandboxRoot;
            _local4.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
            _local4.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            _local4.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            _local4.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);
            _local4.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            var _local5:Object = automationDelegate;
            if (((target) && (!((action == DragManager.NONE))))){
                _local2 = new DragEvent(DragEvent.DRAG_DROP);
                _local2.dragInitiator = dragInitiator;
                _local2.dragSource = dragSource;
                _local2.action = action;
                _local2.ctrlKey = _arg1.ctrlKey;
                _local2.altKey = _arg1.altKey;
                _local2.shiftKey = _arg1.shiftKey;
                _local6 = new Point();
                _local6.x = lastMouseEvent.localX;
                _local6.y = lastMouseEvent.localY;
                _local6 = DisplayObject(lastMouseEvent.target).localToGlobal(_local6);
                _local6 = DisplayObject(target).globalToLocal(_local6);
                _local2.localX = _local6.x;
                _local2.localY = _local6.y;
                if (_local5){
                    _local5.recordAutomatableDragDrop(target, _local2);
                };
                _dispatchDragEvent(target, _local2);
            } else {
                action = DragManager.NONE;
            };
            if (action == DragManager.NONE){
                _local7 = new Move(this);
                _local7.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                _local7.xFrom = x;
                _local7.yFrom = y;
                _local7.xTo = startX;
                _local7.yTo = startY;
                _local7.duration = 200;
                _local7.play();
            } else {
                _local8 = new Zoom(this);
                new Zoom(this).zoomWidthFrom = (_local8.zoomHeightFrom = 1);
                _local8.zoomWidthTo = (_local8.zoomHeightTo = 0);
                _local8.duration = 200;
                _local8.play();
                _local9 = new Move(this);
                _local9.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                _local9.xFrom = x;
                _local9.yFrom = this.y;
                _local9.xTo = parent.mouseX;
                _local9.yTo = parent.mouseY;
                _local9.duration = 200;
                _local9.play();
            };
            _local2 = new DragEvent(DragEvent.DRAG_COMPLETE);
            _local2.dragInitiator = dragInitiator;
            _local2.dragSource = dragSource;
            _local2.relatedObject = InteractiveObject(target);
            _local2.action = action;
            _local2.ctrlKey = _arg1.ctrlKey;
            _local2.altKey = _arg1.altKey;
            _local2.shiftKey = _arg1.shiftKey;
            dragInitiator.dispatchEvent(_local2);
            if (((_local5) && ((action == DragManager.NONE)))){
                _local5.recordAutomatableDragCancel(dragInitiator, _local2);
            };
            cursorManager.removeCursor(cursorID);
            cursorID = CursorManager.NO_CURSOR;
            this.lastMouseEvent = null;
        }
        private function isSameOrChildApplicationDomain(_arg1:Object):Boolean{
            var _local2:DisplayObject = SystemManager.getSWFRoot(_arg1);
            if (_local2){
                return (true);
            };
            var _local3:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            _local3.name = "hasSWFBridges";
            sandboxRoot.dispatchEvent(_local3);
            if (!_local3.value){
                return (true);
            };
            return (false);
        }
        public function showFeedback():void{
            var _local1:Class = cursorClass;
            var _local2:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
            if (action == DragManager.COPY){
                _local1 = _local2.getStyle("copyCursor");
            } else {
                if (action == DragManager.LINK){
                    _local1 = _local2.getStyle("linkCursor");
                } else {
                    if (action == DragManager.NONE){
                        _local1 = _local2.getStyle("rejectCursor");
                    } else {
                        _local1 = _local2.getStyle("moveCursor");
                    };
                };
            };
            if (_local1 != cursorClass){
                cursorClass = _local1;
                if (cursorID != CursorManager.NO_CURSOR){
                    cursorManager.removeCursor(cursorID);
                };
                cursorID = cursorManager.setCursor(cursorClass, 2, 0, 0);
            };
        }
        override public function initialize():void{
            super.initialize();
            dragInitiator.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);
            if (!getFocus()){
                setFocus();
            };
        }
        public function mouseMoveHandler(_arg1:MouseEvent):void{
            var _local2:DragEvent;
            var _local3:DisplayObject;
            var _local4:int;
            var _local10:Array;
            var _local14:Boolean;
            var _local15:DisplayObject;
            lastMouseEvent = _arg1;
            var _local5:Point = new Point();
            var _local6:Point = new Point(_arg1.localX, _arg1.localY);
            var _local7:Point = DisplayObject(_arg1.target).localToGlobal(_local6);
            _local6 = DisplayObject(sandboxRoot).globalToLocal(_local7);
            var _local8:Number = _local6.x;
            var _local9:Number = _local6.y;
            x = (_local8 - xOffset);
            y = (_local9 - yOffset);
            if (!_arg1){
                return;
            };
            var _local11:IEventDispatcher = systemManager.getTopLevelRoot();
            _local10 = [];
            DragProxy.getObjectsUnderPoint(DisplayObject(sandboxRoot), _local7, _local10);
            var _local12:DisplayObject;
            var _local13:int = (_local10.length - 1);
            while (_local13 >= 0) {
                _local12 = _local10[_local13];
                if (((!((_local12 == this))) && (!(contains(_local12))))){
                    break;
                };
                _local13--;
            };
            if (target){
                _local14 = false;
                _local15 = target;
                _local3 = _local12;
                while (_local3) {
                    if (_local3 == target){
                        dispatchDragEvent(DragEvent.DRAG_OVER, _arg1, _local3);
                        _local14 = true;
                        break;
                    };
                    dispatchDragEvent(DragEvent.DRAG_ENTER, _arg1, _local3);
                    if (target == _local3){
                        _local14 = false;
                        break;
                    };
                    _local3 = _local3.parent;
                };
                if (!_local14){
                    dispatchDragEvent(DragEvent.DRAG_EXIT, _arg1, _local15);
                    if (target == _local15){
                        target = null;
                    };
                };
            };
            if (!target){
                action = DragManager.MOVE;
                _local3 = _local12;
                while (_local3) {
                    if (_local3 != this){
                        dispatchDragEvent(DragEvent.DRAG_ENTER, _arg1, _local3);
                        if (target){
                            break;
                        };
                    };
                    _local3 = _local3.parent;
                };
                if (!target){
                    action = DragManager.NONE;
                };
            };
            showFeedback();
        }
        private function dispatchDragEvent(_arg1:String, _arg2:MouseEvent, _arg3:Object):void{
            var _local4:DragEvent = new DragEvent(_arg1);
            var _local5:Point = new Point();
            _local4.dragInitiator = dragInitiator;
            _local4.dragSource = dragSource;
            _local4.action = action;
            _local4.ctrlKey = _arg2.ctrlKey;
            _local4.altKey = _arg2.altKey;
            _local4.shiftKey = _arg2.shiftKey;
            _local5.x = lastMouseEvent.localX;
            _local5.y = lastMouseEvent.localY;
            _local5 = DisplayObject(lastMouseEvent.target).localToGlobal(_local5);
            _local5 = DisplayObject(_arg3).globalToLocal(_local5);
            _local4.localX = _local5.x;
            _local4.localY = _local5.y;
            _dispatchDragEvent(DisplayObject(_arg3), _local4);
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            checkKeyEvent(_arg1);
        }
        private function effectEndHandler(_arg1:EffectEvent):void{
            var _local2 = DragManager;
            _local2.mx_internal::endDrag();
        }
        public function checkKeyEvent(_arg1:KeyboardEvent):void{
            var _local2:DragEvent;
            var _local3:Point;
            if (target){
                if (((((lastKeyEvent) && ((_arg1.type == lastKeyEvent.type)))) && ((_arg1.keyCode == lastKeyEvent.keyCode)))){
                    return;
                };
                lastKeyEvent = _arg1;
                _local2 = new DragEvent(DragEvent.DRAG_OVER);
                _local2.dragInitiator = dragInitiator;
                _local2.dragSource = dragSource;
                _local2.action = action;
                _local2.ctrlKey = _arg1.ctrlKey;
                _local2.altKey = _arg1.altKey;
                _local2.shiftKey = _arg1.shiftKey;
                _local3 = new Point();
                _local3.x = lastMouseEvent.localX;
                _local3.y = lastMouseEvent.localY;
                _local3 = DisplayObject(lastMouseEvent.target).localToGlobal(_local3);
                _local3 = DisplayObject(target).globalToLocal(_local3);
                _local2.localX = _local3.x;
                _local2.localY = _local3.y;
                _dispatchDragEvent(target, _local2);
                showFeedback();
            };
        }
        public function mouseLeaveHandler(_arg1:Event):void{
            mouseUpHandler(lastMouseEvent);
        }
        private function _dispatchDragEvent(_arg1:DisplayObject, _arg2:DragEvent):void{
            var _local3:InterManagerRequest;
            var _local4:InterDragManagerEvent;
            if (isSameOrChildApplicationDomain(_arg1)){
                _arg1.dispatchEvent(_arg2);
            } else {
                _local3 = new InterManagerRequest(InterManagerRequest.INIT_MANAGER_REQUEST);
                _local3.name = "mx.managers::IDragManager";
                sandboxRoot.dispatchEvent(_local3);
                _local4 = new InterDragManagerEvent(InterDragManagerEvent.DISPATCH_DRAG_EVENT, false, false, _arg2.localX, _arg2.localY, _arg2.relatedObject, _arg2.ctrlKey, _arg2.altKey, _arg2.shiftKey, _arg2.buttonDown, _arg2.delta, _arg1, _arg2.type, _arg2.dragInitiator, _arg2.dragSource, _arg2.action, _arg2.draggedItem);
                sandboxRoot.dispatchEvent(_local4);
            };
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            checkKeyEvent(_arg1);
        }
        public function stage_mouseMoveHandler(_arg1:MouseEvent):void{
            if (_arg1.target != stage){
                return;
            };
            mouseMoveHandler(_arg1);
        }

    }
}//package mx.managers.dragClasses 
