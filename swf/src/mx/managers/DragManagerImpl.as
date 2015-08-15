package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.managers.dragClasses.*;

    public class DragManagerImpl implements IDragManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:IDragManager;
        private static var sm:ISystemManager;

        private var bDoingDrag:Boolean = false;
        private var sandboxRoot:IEventDispatcher;
        public var dragProxy:DragProxy;
        private var dragInitiator:IUIComponent;
        private var mouseIsDown:Boolean = false;

        public function DragManagerImpl(){
            var _local1:IEventDispatcher;
            super();
            if (instance){
                throw (new Error("Instance already exists."));
            };
            if (!sm.isTopLevelRoot()){
                sandboxRoot = sm.getSandboxRoot();
                sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT, marshalDispatchEventHandler, false, 0, true);
            } else {
                _local1 = sm;
                _local1.addEventListener(MouseEvent.MOUSE_DOWN, sm_mouseDownHandler, false, 0, true);
                _local1.addEventListener(MouseEvent.MOUSE_UP, sm_mouseUpHandler, false, 0, true);
                sandboxRoot = sm;
                sandboxRoot.addEventListener(InterDragManagerEvent.DISPATCH_DRAG_EVENT, marshalDispatchEventHandler, false, 0, true);
            };
            sandboxRoot.addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST, marshalDragManagerHandler, false, 0, true);
            var _local2:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            _local2.name = "update";
            sandboxRoot.dispatchEvent(_local2);
        }
        public static function getInstance():IDragManager{
            if (!instance){
                sm = SystemManagerGlobals.topLevelSystemManagers[0];
                instance = new (DragManagerImpl)();
            };
            return (instance);
        }

        private function marshalDragManagerHandler(_arg1:Event):void{
            var _local3:InterManagerRequest;
            if ((_arg1 is InterManagerRequest)){
                return;
            };
            var _local2:Object = _arg1;
            switch (_local2.name){
                case "isDragging":
                    bDoingDrag = _local2.value;
                    break;
                case "acceptDragDrop":
                    if (dragProxy){
                        dragProxy.target = _local2.value;
                    };
                    break;
                case "showFeedback":
                    if (dragProxy){
                        showFeedback(_local2.value);
                    };
                    break;
                case "getFeedback":
                    if (dragProxy){
                        _local2.value = getFeedback();
                    };
                    break;
                case "endDrag":
                    endDrag();
                    break;
                case "update":
                    if (((dragProxy) && (isDragging))){
                        _local3 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                        _local3.name = "isDragging";
                        _local3.value = true;
                        sandboxRoot.dispatchEvent(_local3);
                    };
            };
        }
        private function sm_mouseUpHandler(_arg1:MouseEvent):void{
            mouseIsDown = false;
        }
        public function get isDragging():Boolean{
            return (bDoingDrag);
        }
        public function doDrag(_arg1:IUIComponent, _arg2:DragSource, _arg3:MouseEvent, _arg4:IFlexDisplayObject=null, _arg5:Number=0, _arg6:Number=0, _arg7:Number=0.5, _arg8:Boolean=true):void{
            var _local9:Number;
            var _local10:Number;
            var _local18:CSSStyleDeclaration;
            var _local19:Class;
            if (bDoingDrag){
                return;
            };
            if (!(((((((_arg3.type == MouseEvent.MOUSE_DOWN)) || ((_arg3.type == MouseEvent.CLICK)))) || (mouseIsDown))) || (_arg3.buttonDown))){
                return;
            };
            bDoingDrag = true;
            var _local11:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            _local11.name = "isDragging";
            _local11.value = true;
            sandboxRoot.dispatchEvent(_local11);
            _local11 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            _local11.name = "mouseShield";
            _local11.value = true;
            sandboxRoot.dispatchEvent(_local11);
            this.dragInitiator = _arg1;
            dragProxy = new DragProxy(_arg1, _arg2);
            sm.addChildToSandboxRoot("popUpChildren", dragProxy);
            if (!_arg4){
                _local18 = StyleManager.getStyleDeclaration("DragManager");
                _local19 = _local18.getStyle("defaultDragImageSkin");
                _arg4 = new (_local19)();
                dragProxy.addChild(DisplayObject(_arg4));
                _local9 = _arg1.width;
                _local10 = _arg1.height;
            } else {
                dragProxy.addChild(DisplayObject(_arg4));
                if ((_arg4 is ILayoutManagerClient)){
                    UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(_arg4), true);
                };
                if ((_arg4 is IUIComponent)){
                    _local9 = (_arg4 as IUIComponent).getExplicitOrMeasuredWidth();
                    _local10 = (_arg4 as IUIComponent).getExplicitOrMeasuredHeight();
                } else {
                    _local9 = _arg4.measuredWidth;
                    _local10 = _arg4.measuredHeight;
                };
            };
            _arg4.setActualSize(_local9, _local10);
            dragProxy.setActualSize(_local9, _local10);
            dragProxy.alpha = _arg7;
            dragProxy.allowMove = _arg8;
            var _local12:Object = _arg3.target;
            if (_local12 == null){
                _local12 = _arg1;
            };
            var _local13:Point = new Point(_arg3.localX, _arg3.localY);
            _local13 = DisplayObject(_local12).localToGlobal(_local13);
            _local13 = DisplayObject(sandboxRoot).globalToLocal(_local13);
            var _local14:Number = _local13.x;
            var _local15:Number = _local13.y;
            var _local16:Point = DisplayObject(_local12).localToGlobal(new Point(_arg3.localX, _arg3.localY));
            _local16 = DisplayObject(_arg1).globalToLocal(_local16);
            dragProxy.xOffset = (_local16.x + _arg5);
            dragProxy.yOffset = (_local16.y + _arg6);
            dragProxy.x = (_local14 - dragProxy.xOffset);
            dragProxy.y = (_local15 - dragProxy.yOffset);
            dragProxy.startX = dragProxy.x;
            dragProxy.startY = dragProxy.y;
            if ((_arg4 is DisplayObject)){
                DisplayObject(_arg4).cacheAsBitmap = true;
            };
            var _local17:Object = dragProxy.automationDelegate;
            if (_local17){
                _local17.recordAutomatableDragStart(_arg1, _arg3);
            };
        }
        private function sm_mouseDownHandler(_arg1:MouseEvent):void{
            mouseIsDown = true;
        }
        public function showFeedback(_arg1:String):void{
            var _local2:InterManagerRequest;
            if (dragProxy){
                if ((((_arg1 == DragManager.MOVE)) && (!(dragProxy.allowMove)))){
                    _arg1 = DragManager.COPY;
                };
                dragProxy.action = _arg1;
            } else {
                if (isDragging){
                    _local2 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                    _local2.name = "showFeedback";
                    _local2.value = _arg1;
                    sandboxRoot.dispatchEvent(_local2);
                };
            };
        }
        public function acceptDragDrop(_arg1:IUIComponent):void{
            var _local2:InterManagerRequest;
            if (dragProxy){
                dragProxy.target = (_arg1 as DisplayObject);
            } else {
                if (isDragging){
                    _local2 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                    _local2.name = "acceptDragDrop";
                    _local2.value = _arg1;
                    sandboxRoot.dispatchEvent(_local2);
                };
            };
        }
        private function marshalDispatchEventHandler(_arg1:Event):void{
            if ((_arg1 is InterDragManagerEvent)){
                return;
            };
            var _local2:Object = _arg1;
            var _local3:DisplayObject = SystemManager.getSWFRoot(_local2.dropTarget);
            if (!_local3){
                return;
            };
            var _local4:DragEvent = new DragEvent(_local2.dragEventType, _local2.bubbles, _local2.cancelable);
            _local4.localX = _local2.localX;
            _local4.localY = _local2.localY;
            _local4.action = _local2.action;
            _local4.ctrlKey = _local2.ctrlKey;
            _local4.altKey = _local2.altKey;
            _local4.shiftKey = _local2.shiftKey;
            _local4.draggedItem = _local2.draggedItem;
            _local4.dragSource = new DragSource();
            var _local5:Array = _local2.dragSource.formats;
            var _local6:int = _local5.length;
            var _local7:int;
            while (_local7 < _local6) {
                _local4.dragSource.addData(_local2.dragSource.dataForFormat(_local5[_local7]), _local5[_local7]);
                _local7++;
            };
            if (!_local2.dropTarget.dispatchEvent(_local4)){
                _arg1.preventDefault();
            };
        }
        public function getFeedback():String{
            var _local1:InterManagerRequest;
            if (((!(dragProxy)) && (isDragging))){
                _local1 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                _local1.name = "getFeedback";
                sandboxRoot.dispatchEvent(_local1);
                return ((_local1.value as String));
            };
            return (((dragProxy) ? dragProxy.action : DragManager.NONE));
        }
        public function endDrag():void{
            var _local1:InterManagerRequest;
            if (dragProxy){
                sm.removeChildFromSandboxRoot("popUpChildren", dragProxy);
                dragProxy.removeChildAt(0);
                dragProxy = null;
            } else {
                if (isDragging){
                    _local1 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
                    _local1.name = "endDrag";
                    sandboxRoot.dispatchEvent(_local1);
                };
            };
            _local1 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            _local1.name = "mouseShield";
            _local1.value = false;
            sandboxRoot.dispatchEvent(_local1);
            dragInitiator = null;
            bDoingDrag = false;
            _local1 = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST);
            _local1.name = "isDragging";
            _local1.value = false;
            sandboxRoot.dispatchEvent(_local1);
        }

    }
}//package mx.managers 
