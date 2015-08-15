package mx.messaging {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import mx.logging.*;
    import mx.utils.*;
    import mx.messaging.config.*;
    import mx.messaging.errors.*;

    public class MessageAgent extends EventDispatcher implements IMXMLObject {

        mx_internal static const AUTO_CONFIGURED_CHANNELSET:int = 0;
        mx_internal static const MANUALLY_ASSIGNED_CHANNELSET:int = 1;

        private var _needsConfig:Boolean;
        protected var _disconnectBarrier:Boolean;
        protected var _log:ILogger;
        private var _connected:Boolean = false;
        private var _clientId:String;
        private var _sendRemoteCredentials:Boolean;
        private var _authenticated:Boolean;
        protected var _ignoreFault:Boolean = false;
        private var _id:String;
        protected var _credentials:String;
        private var resourceManager:IResourceManager;
        private var _channelSetMode:int = 0;
        mx_internal var configRequested:Boolean = false;
        private var _pendingConnectEvent:ChannelEvent;
        protected var _credentialsCharset:String;
        private var _remoteCredentials:String = "";
        private var _destination:String = "";
        protected var _agentType:String;
        private var _requestTimeout:int = -1;
        private var _remoteCredentialsCharset:String;
        private var _clientIdWaitQueue:Array;
        private var _channelSet:ChannelSet;

        public function MessageAgent(){
            resourceManager = ResourceManager.getInstance();
            _id = UIDUtil.createUID();
            super();
        }
        public function get connected():Boolean{
            return (_connected);
        }
        public function get destination():String{
            return (_destination);
        }
        protected function initChannelSet(_arg1:IMessage):void{
            if (_channelSet == null){
                _channelSetMode = AUTO_CONFIGURED_CHANNELSET;
                internalSetChannelSet(ServerConfig.getChannelSet(destination));
            };
            if (((((_channelSet.connected) && (needsConfig))) && (!(configRequested)))){
                _arg1.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                configRequested = true;
            };
            _channelSet.connect(this);
            if (_credentials != null){
                channelSet.setCredentials(_credentials, this, _credentialsCharset);
            };
        }
        mx_internal function set needsConfig(_arg1:Boolean):void{
            var cs:* = null;
            var value:* = _arg1;
            if (_needsConfig != value){
                _needsConfig = value;
                if (_needsConfig){
                    cs = channelSet;
                    try {
                        disconnect();
                    } finally {
                        internalSetChannelSet(cs);
                    };
                };
            };
        }
        public function logout():void{
            _credentials = null;
            if (channelSet){
                channelSet.logout(this);
            };
        }
        public function get id():String{
            return (_id);
        }
        public function set destination(_arg1:String):void{
            var _local2:String;
            var _local3:PropertyChangeEvent;
            if ((((_arg1 == null)) || ((_arg1.length == 0)))){
                _local2 = resourceManager.getString("messaging", "emptyDestinationName", [_arg1]);
                throw (new InvalidDestinationError(_local2));
            };
            if (_destination != _arg1){
                if ((((_channelSetMode == AUTO_CONFIGURED_CHANNELSET)) && (!((channelSet == null))))){
                    channelSet.disconnect(this);
                    channelSet = null;
                };
                _local3 = PropertyChangeEvent.createUpdateEvent(this, "destination", _destination, _arg1);
                _destination = _arg1;
                dispatchEvent(_local3);
                if (Log.isInfo()){
                    _log.info("'{0}' {2} set destination to '{1}'.", id, _destination, _agentType);
                };
            };
        }
        mx_internal function get channelSetMode():int{
            return (_channelSetMode);
        }
        public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void{
            var mpiutil:* = null;
            var ackMsg:* = _arg1;
            var msg:* = _arg2;
            if (Log.isInfo()){
                _log.info("'{0}' {2} acknowledge of '{1}'.", id, msg.messageId, _agentType);
            };
            if (((((((Log.isDebug()) && (!((channelSet == null))))) && (!((channelSet.currentChannel == null))))) && (channelSet.currentChannel.mpiEnabled))){
                try {
                    mpiutil = new MessagePerformanceUtils(ackMsg);
                    _log.debug(mpiutil.prettyPrint());
                } catch(e:Error) {
                    _log.debug(("Could not get message performance information for: " + msg.toString()));
                };
            };
            if (ackMsg.headers[AcknowledgeMessage.ERROR_HINT_HEADER]){
                delete ackMsg.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
            };
            if (configRequested){
                configRequested = false;
                ServerConfig.updateServerConfigData((ackMsg.body as ConfigMap));
                needsConfig = false;
                if (_pendingConnectEvent){
                    channelConnectHandler(_pendingConnectEvent);
                };
                _pendingConnectEvent = null;
            };
            if (clientId == null){
                if (ackMsg.clientId != null){
                    setClientId(ackMsg.clientId);
                } else {
                    flushClientIdWaitQueue();
                };
            };
            dispatchEvent(MessageAckEvent.createEvent(ackMsg, msg));
        }
        mx_internal function internalSetChannelSet(_arg1:ChannelSet):void{
            var _local2:PropertyChangeEvent;
            if (_channelSet != _arg1){
                if (_channelSet != null){
                    _channelSet.disconnect(this);
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "channelSet", _channelSet, _arg1);
                _channelSet = _arg1;
                if (_channelSet != null){
                    if (_credentials){
                        _channelSet.setCredentials(_credentials, this, _credentialsCharset);
                    };
                    _channelSet.connect(this);
                };
                dispatchEvent(_local2);
            };
        }
        public function fault(_arg1:ErrorMessage, _arg2:IMessage):void{
            if (Log.isError()){
                _log.error("'{0}' {2} fault for '{1}'.", id, _arg2.messageId, _agentType);
            };
            _ignoreFault = false;
            configRequested = false;
            if (_arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER]){
                delete _arg1.headers[ErrorMessage.RETRYABLE_HINT_HEADER];
            };
            if (clientId == null){
                if (_arg1.clientId != null){
                    setClientId(_arg1.clientId);
                } else {
                    flushClientIdWaitQueue();
                };
            };
            dispatchEvent(MessageFaultEvent.createEvent(_arg1));
            if ((((((((_arg1.faultCode == "Client.Authentication")) && (authenticated))) && (!((channelSet == null))))) && (!((channelSet.currentChannel == null))))){
                channelSet.currentChannel.setAuthenticated(false);
                if (channelSet.currentChannel.loginAfterDisconnect){
                    reAuthorize(_arg2);
                    _ignoreFault = true;
                };
            };
        }
        public function set requestTimeout(_arg1:int):void{
            var _local2:PropertyChangeEvent;
            if (_requestTimeout != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "requestTimeout", _requestTimeout, _arg1);
                _requestTimeout = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function disconnect():void{
            if (!_disconnectBarrier){
                _disconnectBarrier = true;
                if (_channelSetMode == AUTO_CONFIGURED_CHANNELSET){
                    internalSetChannelSet(null);
                } else {
                    if (_channelSet != null){
                        _channelSet.disconnect(this);
                    };
                };
            };
        }
        public function set id(_arg1:String):void{
            var _local2:PropertyChangeEvent;
            if (_id != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "id", _id, _arg1);
                _id = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function set channelSet(_arg1:ChannelSet):void{
            internalSetChannelSet(_arg1);
            _channelSetMode = MANUALLY_ASSIGNED_CHANNELSET;
        }
        public function get clientId():String{
            return (_clientId);
        }
        protected function setConnected(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_connected != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "connected", _connected, _arg1);
                _connected = _arg1;
                dispatchEvent(_local2);
                setAuthenticated(((((_arg1) && (channelSet))) && (channelSet.authenticated)), _credentials);
            };
        }
        mx_internal function setClientId(_arg1:String):void{
            var _local2:PropertyChangeEvent;
            if (_clientId != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "clientId", _clientId, _arg1);
                _clientId = _arg1;
                flushClientIdWaitQueue();
                dispatchEvent(_local2);
            };
        }
        public function setCredentials(_arg1:String, _arg2:String, _arg3:String=null):void{
            var _local4:String;
            var _local5:Base64Encoder;
            if ((((_arg1 == null)) && ((_arg2 == null)))){
                _credentials = null;
                _credentialsCharset = null;
            } else {
                _local4 = ((_arg1 + ":") + _arg2);
                _local5 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8){
                    _local5.encodeUTFBytes(_local4);
                } else {
                    _local5.encode(_local4);
                };
                _credentials = _local5.drain();
                _credentialsCharset = _arg3;
            };
            if (channelSet != null){
                channelSet.setCredentials(_credentials, this, _credentialsCharset);
            };
        }
        public function channelDisconnectHandler(_arg1:ChannelEvent):void{
            if (Log.isWarn()){
                _log.warn("'{0}' {1} channel disconnected.", id, _agentType);
            };
            setConnected(false);
            if (_remoteCredentials != null){
                _sendRemoteCredentials = true;
            };
            dispatchEvent(_arg1);
        }
        public function setRemoteCredentials(_arg1:String, _arg2:String, _arg3:String=null):void{
            var _local4:String;
            var _local5:Base64Encoder;
            if ((((_arg1 == null)) && ((_arg2 == null)))){
                _remoteCredentials = "";
                _remoteCredentialsCharset = null;
            } else {
                _local4 = ((_arg1 + ":") + _arg2);
                _local5 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8){
                    _local5.encodeUTFBytes(_local4);
                } else {
                    _local5.encode(_local4);
                };
                _remoteCredentials = _local5.drain();
                _remoteCredentialsCharset = _arg3;
            };
            _sendRemoteCredentials = true;
        }
        mx_internal function get needsConfig():Boolean{
            return (_needsConfig);
        }
        public function hasPendingRequestForMessage(_arg1:IMessage):Boolean{
            return (false);
        }
        public function get authenticated():Boolean{
            return (_authenticated);
        }
        public function get requestTimeout():int{
            return (_requestTimeout);
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            this.id = _arg2;
        }
        final protected function flushClientIdWaitQueue():void{
            if (_clientIdWaitQueue != null){
                if (clientId != null){
                    while (_clientIdWaitQueue.length > 0) {
                        internalSend((_clientIdWaitQueue.shift() as IMessage));
                    };
                };
                if (_clientIdWaitQueue.length > 0){
                    internalSend((_clientIdWaitQueue.shift() as IMessage));
                } else {
                    _clientIdWaitQueue = null;
                };
            };
        }
        final protected function assertCredentials(_arg1:String):void{
            var _local2:ErrorMessage;
            if (((!((_credentials == null))) && (!((_credentials == _arg1))))){
                _local2 = new ErrorMessage();
                _local2.faultCode = "Client.Authentication.Error";
                _local2.faultString = "Credentials specified do not match those used on underlying connection.";
                _local2.faultDetail = "Channel was authenticated with a different set of credentials than those used for this agent.";
                dispatchEvent(MessageFaultEvent.createEvent(_local2));
            };
        }
        public function get channelSet():ChannelSet{
            return (_channelSet);
        }
        public function channelConnectHandler(_arg1:ChannelEvent):void{
            _disconnectBarrier = false;
            if (needsConfig){
                if (Log.isInfo()){
                    _log.info("'{0}' {1} waiting for configuration information.", id, _agentType);
                };
                _pendingConnectEvent = _arg1;
            } else {
                if (Log.isInfo()){
                    _log.info("'{0}' {1} connected.", id, _agentType);
                };
                setConnected(true);
                dispatchEvent(_arg1);
            };
        }
        mx_internal function internalSetCredentials(_arg1:String):void{
            _credentials = _arg1;
        }
        public function channelFaultHandler(_arg1:ChannelFaultEvent):void{
            if (Log.isWarn()){
                _log.warn("'{0}' {1} channel faulted with {2} {3}", id, _agentType, _arg1.faultCode, _arg1.faultDetail);
            };
            if (!_arg1.channel.connected){
                setConnected(false);
                if (_remoteCredentials != null){
                    _sendRemoteCredentials = true;
                };
            };
            dispatchEvent(_arg1);
        }
        protected function internalSend(_arg1:IMessage, _arg2:Boolean=true):void{
            var _local3:String;
            if ((((((_arg1.clientId == null)) && (_arg2))) && ((clientId == null)))){
                if (_clientIdWaitQueue == null){
                    _clientIdWaitQueue = [];
                } else {
                    _clientIdWaitQueue.push(_arg1);
                    return;
                };
            };
            if (_arg1.clientId == null){
                _arg1.clientId = clientId;
            };
            if (requestTimeout > 0){
                _arg1.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] = requestTimeout;
            };
            if (_sendRemoteCredentials){
                if (!(((_arg1 is CommandMessage)) && ((CommandMessage(_arg1).operation == CommandMessage.TRIGGER_CONNECT_OPERATION)))){
                    _arg1.headers[AbstractMessage.REMOTE_CREDENTIALS_HEADER] = _remoteCredentials;
                    _arg1.headers[AbstractMessage.REMOTE_CREDENTIALS_CHARSET_HEADER] = _remoteCredentialsCharset;
                    _sendRemoteCredentials = false;
                };
            };
            if (channelSet != null){
                if (((!(connected)) && ((_channelSetMode == MANUALLY_ASSIGNED_CHANNELSET)))){
                    _channelSet.connect(this);
                };
                if (((((channelSet.connected) && (needsConfig))) && (!(configRequested)))){
                    _arg1.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                    configRequested = true;
                };
                channelSet.send(this, _arg1);
            } else {
                if (destination.length > 0){
                    initChannelSet(_arg1);
                    if (channelSet != null){
                        channelSet.send(this, _arg1);
                    };
                } else {
                    _local3 = resourceManager.getString("messaging", "destinationNotSet");
                    throw (new InvalidDestinationError(_local3));
                };
            };
        }
        mx_internal function setAuthenticated(_arg1:Boolean, _arg2:String):void{
            var _local3:PropertyChangeEvent;
            if (_authenticated != _arg1){
                _local3 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", _authenticated, _arg1);
                _authenticated = _arg1;
                dispatchEvent(_local3);
                if (_arg1){
                    assertCredentials(_arg2);
                };
            };
        }
        protected function reAuthorize(_arg1:IMessage):void{
            disconnect();
            internalSend(_arg1);
        }

    }
}//package mx.messaging 
