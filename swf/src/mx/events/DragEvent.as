package mx.events {
    import mx.core.*;
    import flash.events.*;

    public class DragEvent extends MouseEvent {

        public static const DRAG_DROP:String = "dragDrop";
        public static const DRAG_COMPLETE:String = "dragComplete";
        public static const DRAG_EXIT:String = "dragExit";
        public static const DRAG_ENTER:String = "dragEnter";
        public static const DRAG_START:String = "dragStart";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const DRAG_OVER:String = "dragOver";

        public var draggedItem:Object;
        public var action:String;
        public var dragInitiator:IUIComponent;
        public var dragSource:DragSource;

        public function DragEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:IUIComponent=null, _arg5:DragSource=null, _arg6:String=null, _arg7:Boolean=false, _arg8:Boolean=false, _arg9:Boolean=false){
            super(_arg1, _arg2, _arg3);
            this.dragInitiator = _arg4;
            this.dragSource = _arg5;
            this.action = _arg6;
            this.ctrlKey = _arg7;
            this.altKey = _arg8;
            this.shiftKey = _arg9;
        }
        override public function clone():Event{
            var _local1:DragEvent = new DragEvent(type, bubbles, cancelable, dragInitiator, dragSource, action, ctrlKey, altKey, shiftKey);
            _local1.relatedObject = this.relatedObject;
            _local1.localX = this.localX;
            _local1.localY = this.localY;
            return (_local1);
        }

    }
}//package mx.events 
