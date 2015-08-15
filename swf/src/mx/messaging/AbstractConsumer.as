package mx.messaging {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.messaging.channels.*;

    public class AbstractConsumer extends MessageAgent {

        private var _currentAttempt:int;
        private var _timestamp:Number = -1;
        private var _resubscribeInterval:int = 5000;
        private var _resubscribeAttempts:int = 5;
        private var _resubscribeTimer:Timer;
        protected var _shouldBeSubscribed:Boolean;
        private var _subscribeMsg:CommandMessage;
        private var _subscribed:Boolean;
        private var resourceManager:IResourceManager;

        public function AbstractConsumer(){
            resourceManager = ResourceManager.getInstance();
            super();
            _log = Log.getLogger("mx.messaging.Consumer");
            _agentType = "consumer";
        }
        override public function channelFaultHandler(_arg1:ChannelFaultEvent):void{
            if (!_arg1.channel.connected){
                setSubscribed(false);
            };
            super.channelFaultHandler(_arg1);
            if (((((_shouldBeSubscribed) && (!(_arg1.rejected)))) && (!(_arg1.channel.connected)))){
                startResubscribeTimer();
            };
        }
        protected function buildUnsubscribeMessage(_arg1:Boolean):CommandMessage{
            var _local2:CommandMessage = new CommandMessage();
            _local2.operation = CommandMessage.UNSUBSCRIBE_OPERATION;
            _local2.clientId = clientId;
            _local2.destination = destination;
            if (_arg1){
                _local2.headers[CommandMessage.PRESERVE_DURABLE_HEADER] = _arg1;
            };
            return (_local2);
        }
        public function receive(_arg1:Number=0):void{
            var _local2:CommandMessage;
            if (clientId != null){
                _local2 = new CommandMessage();
                _local2.operation = CommandMessage.POLL_OPERATION;
                _local2.destination = destination;
                internalSend(_local2);
            };
        }
        override mx_internal function setClientId(_arg1:String):void{
            var _local2:Boolean;
            if (super.clientId != _arg1){
                _local2 = false;
                if (subscribed){
                    unsubscribe();
                    _local2 = true;
                };
                super.setClientId(_arg1);
                if (_local2){
                    subscribe(_arg1);
                };
            };
        }
        override public function disconnect():void{
            _shouldBeSubscribed = false;
            stopResubscribeTimer();
            setSubscribed(false);
            super.disconnect();
        }
        public function subscribe(_arg1:String=null):void{
            var _local2:Boolean = ((((!((_arg1 == null))) && (!((super.clientId == _arg1))))) ? true : false);
            if (((subscribed) && (_local2))){
                unsubscribe();
            };
            stopResubscribeTimer();
            _shouldBeSubscribed = true;
            if (_local2){
                super.setClientId(_arg1);
            };
            if (Log.isInfo()){
                _log.info("'{0}' {1} subscribe.", id, _agentType);
            };
            _subscribeMsg = buildSubscribeMessage();
            internalSend(_subscribeMsg);
        }
        override public function channelDisconnectHandler(_arg1:ChannelEvent):void{
            setSubscribed(false);
            super.channelDisconnectHandler(_arg1);
            if (((_shouldBeSubscribed) && (!(_arg1.rejected)))){
                startResubscribeTimer();
            };
        }
        protected function buildSubscribeMessage():CommandMessage{
            var _local1:CommandMessage = new CommandMessage();
            _local1.operation = CommandMessage.SUBSCRIBE_OPERATION;
            _local1.clientId = clientId;
            _local1.destination = destination;
            return (_local1);
        }
        protected function startResubscribeTimer():void{
            if (((_shouldBeSubscribed) && ((_resubscribeTimer == null)))){
                if (((!((_resubscribeAttempts == 0))) && ((_resubscribeInterval > 0)))){
                    if (Log.isDebug()){
                        _log.debug("'{0}' {1} starting resubscribe timer.", id, _agentType);
                    };
                    _resubscribeTimer = new Timer(1);
                    _resubscribeTimer.addEventListener(TimerEvent.TIMER, resubscribe);
                    _resubscribeTimer.start();
                    _currentAttempt = 0;
                };
            };
        }
        public function unsubscribe(_arg1:Boolean=false):void{
            _shouldBeSubscribed = false;
            if (subscribed){
                if (channelSet != null){
                    channelSet.removeEventListener(destination, messageHandler);
                };
                if (Log.isInfo()){
                    _log.info("'{0}' {1} unsubscribe.", id, _agentType);
                };
                internalSend(buildUnsubscribeMessage(_arg1));
            } else {
                stopResubscribeTimer();
            };
        }
        mx_internal function messageHandler(_arg1:MessageEvent):void{
            var _local3:CommandMessage;
            var _local2:IMessage = _arg1.message;
            if ((_local2 is CommandMessage)){
                _local3 = (_local2 as CommandMessage);
                switch (_local3.operation){
                    case CommandMessage.SUBSCRIPTION_INVALIDATE_OPERATION:
                        if ((channelSet.currentChannel is PollingChannel)){
                            PollingChannel(channelSet.currentChannel).disablePolling();
                        };
                        setSubscribed(false);
                        break;
                    default:
                        if (Log.isWarn()){
                            _log.warn("'{0}' received a CommandMessage '{1}' that could not be handled.", id, CommandMessage.getOperationAsString(_local3.operation));
                        };
                };
                return;
            };
            if (_local2.timestamp > _timestamp){
                _timestamp = _local2.timestamp;
            };
            if ((_local2 is ErrorMessage)){
                dispatchEvent(MessageFaultEvent.createEvent(ErrorMessage(_local2)));
            } else {
                dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, _local2));
            };
        }
        public function get timestamp():Number{
            return (_timestamp);
        }
        public function get resubscribeInterval():int{
            return (_resubscribeInterval);
        }
        public function get subscribed():Boolean{
            return (_subscribed);
        }
        override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void{
            if (_disconnectBarrier){
                return;
            };
            if (((!((_subscribeMsg == null))) && ((_arg1.correlationId == _subscribeMsg.messageId)))){
                _shouldBeSubscribed = false;
            };
            if (((!(_arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER])) || ((_resubscribeTimer == null)))){
                stopResubscribeTimer();
                super.fault(_arg1, _arg2);
            };
        }
        protected function setSubscribed(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_subscribed != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "subscribed", _subscribed, _arg1);
                _subscribed = _arg1;
                if (_subscribed){
                    ConsumerMessageDispatcher.getInstance().registerSubscription(this);
                    if (((((!((channelSet == null))) && (!((channelSet.currentChannel == null))))) && ((channelSet.currentChannel is PollingChannel)))){
                        PollingChannel(channelSet.currentChannel).enablePolling();
                    };
                } else {
                    ConsumerMessageDispatcher.getInstance().unregisterSubscription(this);
                    if (((((!((channelSet == null))) && (!((channelSet.currentChannel == null))))) && ((channelSet.currentChannel is PollingChannel)))){
                        PollingChannel(channelSet.currentChannel).disablePolling();
                    };
                };
                dispatchEvent(_local2);
            };
        }
        public function get resubscribeAttempts():int{
            return (_resubscribeAttempts);
        }
        override public function channelConnectHandler(_arg1:ChannelEvent):void{
            super.channelConnectHandler(_arg1);
            if (((((((((connected) && (!((channelSet == null))))) && (!((channelSet.currentChannel == null))))) && (!(channelSet.currentChannel.realtime)))) && (Log.isWarn()))){
                _log.warn(("'{0}' {1} connected over a non-realtime channel '{2}'" + " which means channel is not automatically receiving updates via polling or server push."), id, _agentType, channelSet.currentChannel.id);
            };
        }
        override public function set destination(_arg1:String):void{
            var _local2:Boolean;
            if (destination != _arg1){
                _local2 = false;
                if (subscribed){
                    unsubscribe();
                    _local2 = true;
                };
                super.destination = _arg1;
                if (_local2){
                    subscribe();
                };
            };
        }
        protected function stopResubscribeTimer():void{
            if (_resubscribeTimer != null){
                if (Log.isDebug()){
                    _log.debug("'{0}' {1} stopping resubscribe timer.", id, _agentType);
                };
                _resubscribeTimer.removeEventListener(TimerEvent.TIMER, resubscribe);
                _resubscribeTimer.reset();
                _resubscribeTimer = null;
            };
        }
        override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void{
            var _local3:CommandMessage;
            var _local4:int;
            var _local5:Array;
            var _local6:IMessage;
            if (_disconnectBarrier){
                return;
            };
            if (((!(_arg1.headers[AcknowledgeMessage.ERROR_HINT_HEADER])) && ((_arg2 is CommandMessage)))){
                _local3 = (_arg2 as CommandMessage);
                _local4 = _local3.operation;
                if (_local4 == CommandMessage.MULTI_SUBSCRIBE_OPERATION){
                    if (_arg2.headers.DSlastUnsub != null){
                        _local4 = CommandMessage.UNSUBSCRIBE_OPERATION;
                    } else {
                        _local4 = CommandMessage.SUBSCRIBE_OPERATION;
                    };
                };
                switch (_local4){
                    case CommandMessage.UNSUBSCRIBE_OPERATION:
                        if (Log.isInfo()){
                            _log.info("'{0}' {1} acknowledge for unsubscribe.", id, _agentType);
                        };
                        super.setClientId(null);
                        setSubscribed(false);
                        _arg1.clientId = null;
                        super.acknowledge(_arg1, _arg2);
                        break;
                    case CommandMessage.SUBSCRIBE_OPERATION:
                        stopResubscribeTimer();
                        if (_arg1.timestamp > _timestamp){
                            _timestamp = (_arg1.timestamp - 1);
                        };
                        if (Log.isInfo()){
                            _log.info("'{0}' {1} acknowledge for subscribe. Client id '{2}' new timestamp {3}", id, _agentType, _arg1.clientId, _timestamp);
                        };
                        super.setClientId(_arg1.clientId);
                        setSubscribed(true);
                        super.acknowledge(_arg1, _arg2);
                        break;
                    case CommandMessage.POLL_OPERATION:
                        if (((!((_arg1.body == null))) && ((_arg1.body is Array)))){
                            _local5 = (_arg1.body as Array);
                            for each (_local6 in _local5) {
                                messageHandler(MessageEvent.createEvent(MessageEvent.MESSAGE, _local6));
                            };
                        };
                        super.acknowledge(_arg1, _arg2);
                        break;
                };
            } else {
                super.acknowledge(_arg1, _arg2);
            };
        }
        protected function resubscribe(_arg1:TimerEvent):void{
            var _local2:ErrorMessage;
            if (((!((_resubscribeAttempts == -1))) && ((_currentAttempt >= _resubscribeAttempts)))){
                stopResubscribeTimer();
                _shouldBeSubscribed = false;
                _local2 = new ErrorMessage();
                _local2.faultCode = "Client.Error.Subscribe";
                _local2.faultString = resourceManager.getString("messaging", "consumerSubscribeError");
                _local2.faultDetail = resourceManager.getString("messaging", "failedToSubscribe");
                _local2.correlationId = _subscribeMsg.messageId;
                fault(_local2, _subscribeMsg);
                return;
            };
            if (Log.isDebug()){
                _log.debug("'{0}' {1} trying to resubscribe.", id, _agentType);
            };
            _resubscribeTimer.delay = _resubscribeInterval;
            _currentAttempt++;
            internalSend(_subscribeMsg, false);
        }
        public function set resubscribeInterval(_arg1:int):void{
            var _local2:PropertyChangeEvent;
            var _local3:String;
            if (_resubscribeInterval != _arg1){
                if (_arg1 < 0){
                    _local3 = resourceManager.getString("messaging", "resubscribeIntervalNegative");
                    throw (new ArgumentError(_local3));
                };
                if (_arg1 == 0){
                    stopResubscribeTimer();
                } else {
                    if (_resubscribeTimer != null){
                        _resubscribeTimer.delay = _arg1;
                    };
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "resubscribeInterval", _resubscribeInterval, _arg1);
                _resubscribeInterval = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function set resubscribeAttempts(_arg1:int):void{
            var _local2:PropertyChangeEvent;
            if (_resubscribeAttempts != _arg1){
                if (_arg1 == 0){
                    stopResubscribeTimer();
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "resubscribeAttempts", _resubscribeAttempts, _arg1);
                _resubscribeAttempts = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function set timestamp(_arg1:Number):void{
            var _local2:PropertyChangeEvent;
            if (_timestamp != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "timestamp", _timestamp, _arg1);
                _timestamp = _arg1;
                dispatchEvent(_local2);
            };
        }

    }
}//package mx.messaging 
