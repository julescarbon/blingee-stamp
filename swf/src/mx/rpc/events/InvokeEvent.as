package mx.rpc.events {
    import flash.events.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;

    public class InvokeEvent extends AbstractEvent {

        public static const INVOKE:String = "invoke";

        public function InvokeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:AsyncToken=null, _arg5:IMessage=null){
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public static function createEvent(_arg1:AsyncToken=null, _arg2:IMessage=null):InvokeEvent{
            return (new InvokeEvent(InvokeEvent.INVOKE, false, false, _arg1, _arg2));
        }

        override public function toString():String{
            return (formatToString("InvokeEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase"));
        }
        override public function clone():Event{
            return (new InvokeEvent(type, bubbles, cancelable, token, message));
        }

    }
}//package mx.rpc.events 
