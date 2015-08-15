package mx.events {
    import flash.events.*;

    public class ValidationResultEvent extends Event {

        public static const INVALID:String = "invalid";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const VALID:String = "valid";

        public var results:Array;
        public var field:String;

        public function ValidationResultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Array=null){
            super(_arg1, _arg2, _arg3);
            this.field = _arg4;
            this.results = _arg5;
        }
        public function get message():String{
            var _local1 = "";
            var _local2:int = results.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (results[_local3].isError){
                    _local1 = (_local1 + (((_local1 == "")) ? "" : "\n"));
                    _local1 = (_local1 + results[_local3].errorMessage);
                };
                _local3++;
            };
            return (_local1);
        }
        override public function clone():Event{
            return (new ValidationResultEvent(type, bubbles, cancelable, field, results));
        }

    }
}//package mx.events 
