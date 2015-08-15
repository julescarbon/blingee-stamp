package mx.messaging.events {
    import flash.events.*;
    import mx.messaging.messages.*;

    public class MessageFaultEvent extends Event {

        public static const FAULT:String = "fault";

        public var message:ErrorMessage;

        public function MessageFaultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:ErrorMessage=null){
            super(_arg1, _arg2, _arg3);
            this.message = _arg4;
        }
        public static function createEvent(_arg1:ErrorMessage):MessageFaultEvent{
            return (new MessageFaultEvent(MessageFaultEvent.FAULT, false, false, _arg1));
        }

        public function get faultString():String{
            return (message.faultString);
        }
        public function get faultDetail():String{
            return (message.faultDetail);
        }
        public function get rootCause():Object{
            return (message.rootCause);
        }
        override public function toString():String{
            return (formatToString("MessageFaultEvent", "faultCode", "faultDetail", "faultString", "rootCause", "type", "bubbles", "cancelable", "eventPhase"));
        }
        override public function clone():Event{
            return (new MessageFaultEvent(type, bubbles, cancelable, message));
        }
        public function get faultCode():String{
            return (message.faultCode);
        }

    }
}//package mx.messaging.events 
