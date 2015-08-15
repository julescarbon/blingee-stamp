package mx.messaging {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import mx.logging.*;

    public class AbstractProducer extends MessageAgent {

        private var _currentAttempt:int;
        private var _autoConnect:Boolean = true;
        private var _reconnectTimer:Timer;
        protected var _shouldBeConnected:Boolean;
        private var _connectMsg:CommandMessage;
        private var _defaultHeaders:Object;
        private var _reconnectInterval:int;
        private var _reconnectAttempts:int;
        private var resourceManager:IResourceManager;

        public function AbstractProducer(){
            resourceManager = ResourceManager.getInstance();
            super();
        }
        public function get reconnectAttempts():int{
            return (_reconnectAttempts);
        }
        public function get defaultHeaders():Object{
            return (_defaultHeaders);
        }
        public function set reconnectInterval(_arg1:int):void{
            var _local2:PropertyChangeEvent;
            var _local3:String;
            if (_reconnectInterval != _arg1){
                if (_arg1 < 0){
                    _local3 = resourceManager.getString("messaging", "reconnectIntervalNegative");
                    throw (new ArgumentError(_local3));
                };
                if (_arg1 == 0){
                    stopReconnectTimer();
                } else {
                    if (_reconnectTimer != null){
                        _reconnectTimer.delay = _arg1;
                    };
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnectInterval", _reconnectInterval, _arg1);
                _reconnectInterval = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function set defaultHeaders(_arg1:Object):void{
            var _local2:PropertyChangeEvent;
            if (_defaultHeaders != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "defaultHeaders", _defaultHeaders, _arg1);
                _defaultHeaders = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function get reconnectInterval():int{
            return (_reconnectInterval);
        }
        public function send(_arg1:IMessage):void{
            var _local2:String;
            var _local3:ErrorMessage;
            if (((!(connected)) && (autoConnect))){
                _shouldBeConnected = true;
            };
            if (defaultHeaders != null){
                for (_local2 in defaultHeaders) {
                    if (!_arg1.headers.hasOwnProperty(_local2)){
                        _arg1.headers[_local2] = defaultHeaders[_local2];
                    };
                };
            };
            if (((!(connected)) && (!(autoConnect)))){
                _shouldBeConnected = false;
                _local3 = new ErrorMessage();
                _local3.faultCode = "Client.Error.MessageSend";
                _local3.faultString = resourceManager.getString("messaging", "producerSendError");
                _local3.faultDetail = resourceManager.getString("messaging", "producerSendErrorDetails");
                _local3.correlationId = _arg1.messageId;
                internalFault(_local3, _arg1, false, true);
            } else {
                if (Log.isInfo()){
                    _log.info("'{0}' {1} sending message '{2}'", id, _agentType, _arg1.messageId);
                };
                internalSend(_arg1);
            };
        }
        protected function stopReconnectTimer():void{
            if (_reconnectTimer != null){
                if (Log.isDebug()){
                    _log.debug("'{0}' {1} stopping reconnect timer.", id, _agentType);
                };
                _reconnectTimer.removeEventListener(TimerEvent.TIMER, reconnect);
                _reconnectTimer.reset();
                _reconnectTimer = null;
            };
        }
        override public function channelDisconnectHandler(_arg1:ChannelEvent):void{
            super.channelDisconnectHandler(_arg1);
            if (((_shouldBeConnected) && (!(_arg1.rejected)))){
                startReconnectTimer();
            };
        }
        protected function reconnect(_arg1:TimerEvent):void{
            if (((!((_reconnectAttempts == -1))) && ((_currentAttempt >= _reconnectAttempts)))){
                stopReconnectTimer();
                _shouldBeConnected = false;
                fault(buildConnectErrorMessage(), _connectMsg);
                return;
            };
            if (Log.isDebug()){
                _log.debug("'{0}' {1} trying to reconnect.", id, _agentType);
            };
            _reconnectTimer.delay = _reconnectInterval;
            _currentAttempt++;
            if (_connectMsg == null){
                _connectMsg = buildConnectMessage();
            };
            internalSend(_connectMsg, false);
        }
        private function buildConnectErrorMessage():ErrorMessage{
            var _local1:ErrorMessage = new ErrorMessage();
            _local1.faultCode = "Client.Error.Connect";
            _local1.faultString = resourceManager.getString("messaging", "producerConnectError");
            _local1.faultDetail = resourceManager.getString("messaging", "failedToConnect");
            _local1.correlationId = _connectMsg.messageId;
            return (_local1);
        }
        override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void{
            if (_disconnectBarrier){
                return;
            };
            super.acknowledge(_arg1, _arg2);
            if ((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION)))){
                stopReconnectTimer();
            };
        }
        override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void{
            internalFault(_arg1, _arg2);
        }
        override public function disconnect():void{
            _shouldBeConnected = false;
            stopReconnectTimer();
            super.disconnect();
        }
        mx_internal function internalFault(_arg1:ErrorMessage, _arg2:IMessage, _arg3:Boolean=true, _arg4:Boolean=false):void{
            var _local5:ErrorMessage;
            if (((_disconnectBarrier) && (!(_arg4)))){
                return;
            };
            if ((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION)))){
                if (_reconnectTimer == null){
                    if (((!((_connectMsg == null))) && ((_arg1.correlationId == _connectMsg.messageId)))){
                        _shouldBeConnected = false;
                        _local5 = buildConnectErrorMessage();
                        _local5.rootCause = _arg1.rootCause;
                        super.fault(_local5, _arg2);
                    } else {
                        super.fault(_arg1, _arg2);
                    };
                };
            } else {
                super.fault(_arg1, _arg2);
            };
        }
        public function connect():void{
            if (!connected){
                _shouldBeConnected = true;
                if (_connectMsg == null){
                    _connectMsg = buildConnectMessage();
                };
                internalSend(_connectMsg, false);
            };
        }
        override public function channelFaultHandler(_arg1:ChannelFaultEvent):void{
            super.channelFaultHandler(_arg1);
            if (((((_shouldBeConnected) && (!(_arg1.rejected)))) && (!(_arg1.channel.connected)))){
                startReconnectTimer();
            };
        }
        private function buildConnectMessage():CommandMessage{
            var _local1:CommandMessage = new CommandMessage();
            _local1.operation = CommandMessage.TRIGGER_CONNECT_OPERATION;
            _local1.clientId = clientId;
            _local1.destination = destination;
            return (_local1);
        }
        protected function startReconnectTimer():void{
            if (((_shouldBeConnected) && ((_reconnectTimer == null)))){
                if (((!((_reconnectAttempts == 0))) && ((_reconnectInterval > 0)))){
                    if (Log.isDebug()){
                        _log.debug("'{0}' {1} starting reconnect timer.", id, _agentType);
                    };
                    _reconnectTimer = new Timer(1);
                    _reconnectTimer.addEventListener(TimerEvent.TIMER, reconnect);
                    _reconnectTimer.start();
                    _currentAttempt = 0;
                };
            };
        }
        public function set autoConnect(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_autoConnect != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "autoConnect", _autoConnect, _arg1);
                _autoConnect = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function set reconnectAttempts(_arg1:int):void{
            var _local2:PropertyChangeEvent;
            if (_reconnectAttempts != _arg1){
                if (_arg1 == 0){
                    stopReconnectTimer();
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnectAttempts", _reconnectAttempts, _arg1);
                _reconnectAttempts = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function get autoConnect():Boolean{
            return (_autoConnect);
        }

    }
}//package mx.messaging 
