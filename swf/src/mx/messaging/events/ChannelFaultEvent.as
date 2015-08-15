package mx.messaging.events {
    import flash.events.*;
    import mx.messaging.messages.*;
    import mx.messaging.*;

    public class ChannelFaultEvent extends ChannelEvent {

        public static const FAULT:String = "channelFault";

        public var faultString:String;
        public var rootCause:Object;
        public var faultDetail:String;
        public var faultCode:String;

        public function ChannelFaultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Channel=null, _arg5:Boolean=false, _arg6:String=null, _arg7:String=null, _arg8:String=null, _arg9:Boolean=false, _arg10:Boolean=false){
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg9, _arg10);
            faultCode = _arg6;
            faultString = _arg7;
            faultDetail = _arg8;
        }
        public static function createEvent(_arg1:Channel, _arg2:Boolean=false, _arg3:String=null, _arg4:String=null, _arg5:String=null, _arg6:Boolean=false, _arg7:Boolean=false):ChannelFaultEvent{
            return (new ChannelFaultEvent(ChannelFaultEvent.FAULT, false, false, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7));
        }

        override public function clone():Event{
            var _local1:ChannelFaultEvent = new ChannelFaultEvent(type, bubbles, cancelable, channel, reconnecting, faultCode, faultString, faultDetail, rejected, connected);
            _local1.rootCause = rootCause;
            return (_local1);
        }
        public function createErrorMessage():ErrorMessage{
            var _local1:ErrorMessage = new ErrorMessage();
            _local1.faultCode = faultCode;
            _local1.faultString = faultString;
            _local1.faultDetail = faultDetail;
            _local1.rootCause = rootCause;
            return (_local1);
        }
        override public function toString():String{
            return (formatToString("ChannelFaultEvent", "faultCode", "faultString", "faultDetail", "channelId", "type", "bubbles", "cancelable", "eventPhase"));
        }

    }
}//package mx.messaging.events 
