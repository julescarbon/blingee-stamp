package mx.rpc.events {
    import flash.events.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;

    public class ResultEvent extends AbstractEvent {

        public static const RESULT:String = "result";

        private var _headers:Object;
        private var _result:Object;
        private var _statusCode:int;

        public function ResultEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:Object=null, _arg5:AsyncToken=null, _arg6:IMessage=null){
            super(_arg1, _arg2, _arg3, _arg5, _arg6);
            if (((!((_arg6 == null))) && (!((_arg6.headers == null))))){
                _statusCode = (_arg6.headers[AbstractMessage.STATUS_CODE_HEADER] as int);
            };
            _result = _arg4;
        }
        public static function createEvent(_arg1:Object=null, _arg2:AsyncToken=null, _arg3:IMessage=null):ResultEvent{
            return (new ResultEvent(ResultEvent.RESULT, false, true, _arg1, _arg2, _arg3));
        }

        override public function clone():Event{
            return (new ResultEvent(type, bubbles, cancelable, result, token, message));
        }
        public function get headers():Object{
            return (_headers);
        }
        override public function toString():String{
            return (formatToString("ResultEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase"));
        }
        override mx_internal function callTokenResponders():void{
            if (token != null){
                token.applyResult(this);
            };
        }
        public function set headers(_arg1:Object):void{
            _headers = _arg1;
        }
        public function get result():Object{
            return (_result);
        }
        public function get statusCode():int{
            return (_statusCode);
        }

    }
}//package mx.rpc.events 
