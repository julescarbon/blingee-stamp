package mx.messaging {
    import flash.events.*;
    import mx.resources.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import flash.net.*;

    public class MessageResponder extends Responder {

        private var _channel:Channel;
        private var _agent:MessageAgent;
        private var _requestTimedOut:Boolean;
        private var _message:IMessage;
        private var _requestTimer:Timer;
        private var resourceManager:IResourceManager;

        public function MessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:Channel=null){
            resourceManager = ResourceManager.getInstance();
            super(result, status);
            _agent = _arg1;
            _channel = _arg3;
            _message = _arg2;
            _requestTimedOut = false;
        }
        public function get channel():Channel{
            return (_channel);
        }
        public function get agent():MessageAgent{
            return (_agent);
        }
        protected function requestTimedOut():void{
        }
        final public function startRequestTimeout(_arg1:int):void{
            _requestTimer = new Timer((_arg1 * 1000), 1);
            _requestTimer.addEventListener(TimerEvent.TIMER, timeoutRequest);
            _requestTimer.start();
        }
        public function get message():IMessage{
            return (_message);
        }
        final public function result(_arg1:IMessage):void{
            if (!_requestTimedOut){
                if (_requestTimer != null){
                    releaseTimer();
                };
                resultHandler(_arg1);
            };
        }
        private function releaseTimer():void{
            _requestTimer.stop();
            _requestTimer.removeEventListener(TimerEvent.TIMER, timeoutRequest);
            _requestTimer = null;
        }
        public function set message(_arg1:IMessage):void{
            _message = _arg1;
        }
        protected function createRequestTimeoutErrorMessage():ErrorMessage{
            var _local1:ErrorMessage = new ErrorMessage();
            _local1.correlationId = message.messageId;
            _local1.faultCode = "Client.Error.RequestTimeout";
            _local1.faultString = resourceManager.getString("messaging", "requestTimedOut");
            _local1.faultDetail = resourceManager.getString("messaging", "requestTimedOut.details");
            return (_local1);
        }
        private function timeoutRequest(_arg1:TimerEvent):void{
            _requestTimedOut = true;
            releaseTimer();
            requestTimedOut();
        }
        final public function status(_arg1:IMessage):void{
            if (!_requestTimedOut){
                if (_requestTimer != null){
                    releaseTimer();
                };
                statusHandler(_arg1);
            };
        }
        protected function resultHandler(_arg1:IMessage):void{
        }
        protected function statusHandler(_arg1:IMessage):void{
        }

    }
}//package mx.messaging 
