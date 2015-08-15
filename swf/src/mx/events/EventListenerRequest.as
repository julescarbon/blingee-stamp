package mx.events {
    import mx.core.*;
    import flash.events.*;

    public class EventListenerRequest extends SWFBridgeRequest {

        public static const REMOVE_EVENT_LISTENER_REQUEST:String = "removeEventListenerRequest";
        public static const ADD_EVENT_LISTENER_REQUEST:String = "addEventListenerRequest";
        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _priority:int;
        private var _useWeakReference:Boolean;
        private var _eventType:String;
        private var _useCapture:Boolean;

        public function EventListenerRequest(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:String=null, _arg5:Boolean=false, _arg6:int=0, _arg7:Boolean=false){
            super(_arg1, false, false);
            _eventType = _arg4;
            _useCapture = _arg5;
            _priority = _arg6;
            _useWeakReference = _arg7;
        }
        public static function marshal(_arg1:Event):EventListenerRequest{
            var _local2:Object = _arg1;
            return (new EventListenerRequest(_local2.type, _local2.bubbles, _local2.cancelable, _local2.eventType, _local2.useCapture, _local2.priority, _local2.useWeakReference));
        }

        public function get priority():int{
            return (_priority);
        }
        public function get useWeakReference():Boolean{
            return (_useWeakReference);
        }
        public function get eventType():String{
            return (_eventType);
        }
        override public function clone():Event{
            return (new EventListenerRequest(type, bubbles, cancelable, eventType, useCapture, priority, useWeakReference));
        }
        public function get useCapture():Boolean{
            return (_useCapture);
        }

    }
}//package mx.events 
