package mx.events {
    import flash.display.*;
    import flash.events.*;

    public class ChildExistenceChangedEvent extends Event {

        public static const CHILD_REMOVE:String = "childRemove";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const OVERLAY_CREATED:String = "overlayCreated";
        public static const CHILD_ADD:String = "childAdd";

        public var relatedObject:DisplayObject;

        public function ChildExistenceChangedEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:DisplayObject=null){
            super(_arg1, _arg2, _arg3);
            this.relatedObject = _arg4;
        }
        override public function clone():Event{
            return (new ChildExistenceChangedEvent(type, bubbles, cancelable, relatedObject));
        }

    }
}//package mx.events 
