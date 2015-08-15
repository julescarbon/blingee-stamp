package mx.events {
    import flash.events.*;

    public class DropdownEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";

        public var triggerEvent:Event;

        public function DropdownEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Event=null){
            super(_arg1, _arg2, _arg3);
            this.triggerEvent = _arg4;
        }
        override public function clone():Event{
            return (new DropdownEvent(type, bubbles, cancelable, triggerEvent));
        }

    }
}//package mx.events 
