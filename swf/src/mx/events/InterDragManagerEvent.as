package mx.events {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;

    public class InterDragManagerEvent extends DragEvent {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const DISPATCH_DRAG_EVENT:String = "dispatchDragEvent";

        public var dropTarget:DisplayObject;
        public var dragEventType:String;

        public function InterDragManagerEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Number=NaN, _arg5:Number=NaN, _arg6:InteractiveObject=null, _arg7:Boolean=false, _arg8:Boolean=false, _arg9:Boolean=false, _arg10:Boolean=false, _arg11:int=0, _arg12:DisplayObject=null, _arg13:String=null, _arg14:IUIComponent=null, _arg15:DragSource=null, _arg16:String=null, _arg17:Object=null){
            super(_arg1, false, false, _arg14, _arg15, _arg16, _arg7, _arg8, _arg9);
            this.dropTarget = _arg12;
            this.dragEventType = _arg13;
            this.draggedItem = _arg17;
            this.localX = _arg4;
            this.localY = _arg5;
            this.buttonDown = _arg10;
            this.delta = _arg11;
            this.relatedObject = _arg6;
        }
        override public function clone():Event{
            var _local1:InterDragManagerEvent = new InterDragManagerEvent(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, dropTarget, dragEventType, dragInitiator, dragSource, action, draggedItem);
            return (_local1);
        }

    }
}//package mx.events 
