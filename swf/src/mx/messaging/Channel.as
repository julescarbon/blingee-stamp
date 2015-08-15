package mx.messaging {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.collections.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.utils.*;
    import mx.messaging.config.*;
    import mx.messaging.errors.*;
    import flash.errors.*;

    public class Channel extends EventDispatcher implements IMXMLObject {

        public static const SMALL_MESSAGES_FEATURE:String = "small_messages";
        private static const dep:ArrayCollection = null;

        private var _failoverIndex:int;
        private var _ownsWaitGuard:Boolean = false;
        protected var _recordMessageTimes:Boolean = false;
        private var _reconnecting:Boolean = false;
        private var _authenticated:Boolean = false;
        protected var messagingVersion:Number = 1;
        private var _channelSets:Array;
        private var _connectTimeout:int = -1;
        mx_internal var authenticating:Boolean;
        protected var _connecting:Boolean;
        private var _connectTimer:Timer;
        protected var _recordMessageSizes:Boolean = false;
        private var _failoverURIs:Array;
        protected var _log:ILogger;
        private var _connected:Boolean = false;
        private var _smallMessagesSupported:Boolean;
        private var _primaryURI:String;
        public var enableSmallMessages:Boolean = true;
        private var _id:String;
        private var resourceManager:IResourceManager;
        private var _uri:String;
        protected var _loginAfterDisconnect:Boolean = false;
        private var _isEndpointCalculated:Boolean = false;
        private var _shouldBeConnected:Boolean;
        private var _requestTimeout:int = -1;
        private var _endpoint:String;
        protected var credentials:String;

        public function Channel(_arg1:String=null, _arg2:String=null){
            resourceManager = ResourceManager.getInstance();
            _channelSets = [];
            super();
            _log = Log.getLogger("mx.messaging.Channel");
            _connecting = false;
            _failoverIndex = -1;
            this.id = _arg1;
            _primaryURI = _arg2;
            _shouldBeConnected = false;
            this.uri = _arg2;
            authenticating = false;
        }
        private function shutdownConnectTimer():void{
            if (_connectTimer != null){
                _connectTimer.stop();
                _connectTimer = null;
            };
        }
        public function get connected():Boolean{
            return (_connected);
        }
        public function get connectTimeout():int{
            return (_connectTimeout);
        }
        public function get id():String{
            return (_id);
        }
        private function calculateEndpoint():void{
            var _local3:String;
            if (uri == null){
                _local3 = resourceManager.getString("messaging", "noURLSpecified");
                throw (new InvalidChannelError(_local3));
            };
            var _local1:String = uri;
            var _local2:String = URLUtil.getProtocol(_local1);
            if (_local2.length == 0){
                _local1 = URLUtil.getFullURL(LoaderConfig.url, _local1);
            };
            if (!URLUtil.hasUnresolvableTokens()){
                _isEndpointCalculated = false;
                return;
            };
            _local1 = URLUtil.replaceTokens(_local1);
            _local2 = URLUtil.getProtocol(_local1);
            if (_local2.length > 0){
                _endpoint = URLUtil.replaceProtocol(_local1, protocol);
            } else {
                _endpoint = ((protocol + ":") + _local1);
            };
            _isEndpointCalculated = true;
            if (Log.isInfo()){
                _log.info("'{0}' channel endpoint set to {1}", id, _endpoint);
            };
        }
        public function get reconnecting():Boolean{
            return (_reconnecting);
        }
        public function get useSmallMessages():Boolean{
            return (((_smallMessagesSupported) && (enableSmallMessages)));
        }
        public function set connectTimeout(_arg1:int):void{
            _connectTimeout = _arg1;
        }
        public function get authenticated():Boolean{
            return (_authenticated);
        }
        protected function getMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder{
            throw (new IllegalOperationError(("Channel subclasses must override " + " getMessageResponder().")));
        }
        public function set failoverURIs(_arg1:Array):void{
            if (_arg1 != null){
                _failoverURIs = _arg1;
                _failoverIndex = -1;
            };
        }
        protected function internalDisconnect(_arg1:Boolean=false):void{
        }
        public function setCredentials(_arg1:String, _arg2:MessageAgent=null, _arg3:String=null):void{
            var _local5:CommandMessage;
            var _local4 = !((this.credentials === _arg1));
            if (((authenticating) && (_local4))){
                throw (new IllegalOperationError("Credentials cannot be set while authenticating or logging out."));
            };
            if (((authenticated) && (_local4))){
                throw (new IllegalOperationError("Credentials cannot be set when already authenticated. Logout must be performed before changing credentials."));
            };
            this.credentials = _arg1;
            if (((((connected) && (_local4))) && (!((_arg1 == null))))){
                authenticating = true;
                _local5 = new CommandMessage();
                _local5.operation = CommandMessage.LOGIN_OPERATION;
                _local5.body = _arg1;
                if (_arg3 != null){
                    _local5.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = _arg3;
                };
                internalSend(new AuthenticationMessageResponder(_arg2, _local5, this, _log));
            };
        }
        public function get mpiEnabled():Boolean{
            return (((_recordMessageSizes) || (_recordMessageTimes)));
        }
        public function set id(_arg1:String):void{
            if (_id != _arg1){
                _id = _arg1;
            };
        }
        protected function connectTimeoutHandler(_arg1:TimerEvent):void{
            var _local2:String;
            var _local3:ChannelFaultEvent;
            shutdownConnectTimer();
            if (!connected){
                _shouldBeConnected = false;
                _local2 = resourceManager.getString("messaging", "connectTimedOut");
                _local3 = ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", "error", _local2);
                connectFailed(_local3);
            };
        }
        protected function setFlexClientIdOnMessage(_arg1:IMessage):void{
            var _local2:String = FlexClient.getInstance().id;
            _arg1.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] = ((_local2)!=null) ? _local2 : FlexClient.NULL_FLEXCLIENT_ID;
        }
        protected function flexClientWaitHandler(_arg1:PropertyChangeEvent):void{
            var _local2:FlexClient;
            if (_arg1.property == "waitForFlexClientId"){
                _local2 = (_arg1.source as FlexClient);
                if (_local2.waitForFlexClientId == false){
                    _local2.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, flexClientWaitHandler);
                    _local2.waitForFlexClientId = true;
                    _ownsWaitGuard = true;
                    internalConnect();
                };
            };
        }
        public function set useSmallMessages(_arg1:Boolean):void{
            _smallMessagesSupported = _arg1;
        }
        mx_internal function internalSetCredentials(_arg1:String):void{
            this.credentials = _arg1;
        }
        private function reconnect(_arg1:TimerEvent):void{
            internalConnect();
        }
        mx_internal function get realtime():Boolean{
            return (false);
        }
        protected function internalConnect():void{
        }
        public function get url():String{
            return (uri);
        }
        public function get recordMessageTimes():Boolean{
            return (_recordMessageTimes);
        }
        public function get uri():String{
            return (_uri);
        }
        private function initializeRequestTimeout(_arg1:MessageResponder):void{
            var _local2:IMessage = _arg1.message;
            if (_local2.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] != null){
                _arg1.startRequestTimeout(_local2.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER]);
            } else {
                if (requestTimeout > 0){
                    _arg1.startRequestTimeout(requestTimeout);
                };
            };
        }
        public function send(_arg1:MessageAgent, _arg2:IMessage):void{
            var _local4:String;
            if (_arg2.destination.length == 0){
                if (_arg1.destination.length == 0){
                    _local4 = resourceManager.getString("messaging", "noDestinationSpecified");
                    throw (new InvalidDestinationError(_local4));
                };
                _arg2.destination = _arg1.destination;
            };
            if (Log.isDebug()){
                _log.debug("'{0}' channel sending message:\n{1}", id, _arg2.toString());
            };
            _arg2.headers[AbstractMessage.ENDPOINT_HEADER] = id;
            var _local3:MessageResponder = getMessageResponder(_arg1, _arg2);
            initializeRequestTimeout(_local3);
            internalSend(_local3);
        }
        public function logout(_arg1:MessageAgent):void{
            var _local2:CommandMessage;
            if (((((((connected) && (authenticated))) && (credentials))) || (((authenticating) && (credentials))))){
                _local2 = new CommandMessage();
                _local2.operation = CommandMessage.LOGOUT_OPERATION;
                internalSend(new AuthenticationMessageResponder(_arg1, _local2, this, _log));
                authenticating = true;
            };
            credentials = null;
        }
        public function get endpoint():String{
            if (!_isEndpointCalculated){
                calculateEndpoint();
            };
            return (_endpoint);
        }
        public function get protocol():String{
            throw (new IllegalOperationError((("Channel subclasses must override " + "the get function for 'protocol' to return the proper protocol ") + "string.")));
        }
        public function get failoverURIs():Array{
            return (((_failoverURIs)!=null) ? _failoverURIs : []);
        }
        final public function disconnect(_arg1:ChannelSet):void{
            if (_ownsWaitGuard){
                _ownsWaitGuard = false;
                FlexClient.getInstance().waitForFlexClientId = false;
            };
            var _local2:int = ((_arg1)!=null) ? _channelSets.indexOf(_arg1) : -1;
            if (_local2 != -1){
                _channelSets.splice(_local2, 1);
                removeEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler, false);
                removeEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler, false);
                removeEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler, false);
                if (connected){
                    _arg1.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, false));
                };
                if (_channelSets.length == 0){
                    _shouldBeConnected = false;
                    if (connected){
                        internalDisconnect();
                    };
                };
            };
        }
        public function set requestTimeout(_arg1:int):void{
            _requestTimeout = _arg1;
        }
        private function shouldAttemptFailover():Boolean{
            return (((((_shouldBeConnected) && (!((_failoverURIs == null))))) && ((_failoverURIs.length > 0))));
        }
        private function setReconnecting(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_reconnecting != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "reconnecting", _reconnecting, _arg1);
                _reconnecting = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function applySettings(_arg1:XML):void{
            var _local2:XML;
            var _local3:XMLList;
            if (Log.isInfo()){
                _log.info("'{0}' channel settings are:\n{1}", id, _arg1);
            };
            if (_arg1.properties.length()){
                _local2 = _arg1.properties[0];
                if (_local2["connect-timeout-seconds"].length()){
                    connectTimeout = _local2["connect-timeout-seconds"].toString();
                };
                if (_local2["record-message-times"].length()){
                    _recordMessageTimes = (_local2["record-message-times"].toString() == "true");
                };
                if (_local2["record-message-sizes"].length()){
                    _recordMessageSizes = (_local2["record-message-sizes"].toString() == "true");
                };
                _local3 = _local2["serialization"];
                if (_local3.length() > 0){
                    if (_local3["enable-small-messages"].toString() == "false"){
                        enableSmallMessages = false;
                    };
                };
            };
        }
        protected function connectSuccess():void{
            var _local1:int;
            var _local2:Array;
            var _local3:int;
            if (_ownsWaitGuard){
                _ownsWaitGuard = false;
                FlexClient.getInstance().waitForFlexClientId = false;
            };
            shutdownConnectTimer();
            _connecting = false;
            if (ServerConfig.fetchedConfig(endpoint)){
                _local1 = 0;
                while (_local1 < channelSets.length) {
                    _local2 = ChannelSet(channelSets[_local1]).messageAgents;
                    _local3 = 0;
                    while (_local3 < _local2.length) {
                        _local2[_local3].needsConfig = false;
                        _local3++;
                    };
                    _local1++;
                };
            };
            setConnected(true);
            _failoverIndex = -1;
            if (Log.isInfo()){
                _log.info("'{0}' channel is connected.", id);
            };
            dispatchEvent(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, reconnecting));
            setReconnecting(false);
        }
        public function get recordMessageSizes():Boolean{
            return (_recordMessageSizes);
        }
        protected function disconnectSuccess(_arg1:Boolean=false):void{
            setConnected(false);
            if (Log.isInfo()){
                _log.info("'{0}' channel disconnected.", id);
            };
            if (((!(_arg1)) && (shouldAttemptFailover()))){
                _connecting = true;
                failover();
            } else {
                _connecting = false;
            };
            dispatchEvent(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, reconnecting, _arg1));
        }
        protected function setConnected(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_connected != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "connected", _connected, _arg1);
                _connected = _arg1;
                dispatchEvent(_local2);
                if (!_arg1){
                    setAuthenticated(false);
                };
            };
        }
        public function get requestTimeout():int{
            return (_requestTimeout);
        }
        protected function connectFailed(_arg1:ChannelFaultEvent):void{
            shutdownConnectTimer();
            setConnected(false);
            if (Log.isError()){
                _log.error("'{0}' channel connect failed.", id);
            };
            if (((!(_arg1.rejected)) && (shouldAttemptFailover()))){
                _connecting = true;
                failover();
            } else {
                if (_ownsWaitGuard){
                    _ownsWaitGuard = false;
                    FlexClient.getInstance().waitForFlexClientId = false;
                };
                _connecting = false;
            };
            if (reconnecting){
                _arg1.reconnecting = true;
            };
            dispatchEvent(_arg1);
        }
        public function set uri(_arg1:String):void{
            if (_arg1 != null){
                _uri = _arg1;
                calculateEndpoint();
            };
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            this.id = _arg2;
        }
        mx_internal function sendClusterRequest(_arg1:MessageResponder):void{
            internalSend(_arg1);
        }
        public function set url(_arg1:String):void{
            uri = _arg1;
        }
        protected function handleServerMessagingVersion(_arg1:Number):void{
            useSmallMessages = (_arg1 >= messagingVersion);
        }
        protected function internalSend(_arg1:MessageResponder):void{
        }
        final public function connect(_arg1:ChannelSet):void{
            var _local5:FlexClient;
            var _local2:Boolean;
            var _local3:int = _channelSets.length;
            var _local4:int;
            while (_local4 < _channelSets.length) {
                if (_channelSets[_local4] == _arg1){
                    _local2 = true;
                    break;
                };
                _local4++;
            };
            _shouldBeConnected = true;
            if (!_local2){
                _channelSets.push(_arg1);
                addEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                addEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                addEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
            };
            if (connected){
                _arg1.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, false, false, connected));
            } else {
                if (!_connecting){
                    _connecting = true;
                    if (connectTimeout > 0){
                        _connectTimer = new Timer((connectTimeout * 1000), 1);
                        _connectTimer.addEventListener(TimerEvent.TIMER, connectTimeoutHandler);
                        _connectTimer.start();
                    };
                    if (FlexClient.getInstance().id == null){
                        _local5 = FlexClient.getInstance();
                        if (!_local5.waitForFlexClientId){
                            _local5.waitForFlexClientId = true;
                            _ownsWaitGuard = true;
                            internalConnect();
                        } else {
                            _local5.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, flexClientWaitHandler);
                        };
                    } else {
                        internalConnect();
                    };
                };
            };
        }
        private function resetToPrimaryURI():void{
            _connecting = false;
            setReconnecting(false);
            uri = _primaryURI;
            _failoverIndex = -1;
        }
        mx_internal function setAuthenticated(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            var _local3:ChannelSet;
            var _local4:int;
            if (_arg1 != _authenticated){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", _authenticated, _arg1);
                _authenticated = _arg1;
                _local4 = 0;
                while (_local4 < _channelSets.length) {
                    _local3 = ChannelSet(_channelSets[_local4]);
                    _local3.setAuthenticated(authenticated, credentials);
                    _local4++;
                };
                dispatchEvent(_local2);
            };
        }
        mx_internal function get loginAfterDisconnect():Boolean{
            return (_loginAfterDisconnect);
        }
        private function failover():void{
            var _local1:Timer;
            _failoverIndex++;
            if ((_failoverIndex + 1) <= failoverURIs.length){
                setReconnecting(true);
                uri = failoverURIs[_failoverIndex];
                if (Log.isInfo()){
                    _log.info("'{0}' channel attempting to connect to {1}.", id, endpoint);
                };
                _local1 = new Timer(1, 1);
                _local1.addEventListener(TimerEvent.TIMER, reconnect);
                _local1.start();
            } else {
                if (Log.isInfo()){
                    _log.info("'{0}' channel has exhausted failover options and has reset to its primary endpoint.", id);
                };
                resetToPrimaryURI();
            };
        }
        public function get channelSets():Array{
            return (_channelSets);
        }
        protected function disconnectFailed(_arg1:ChannelFaultEvent):void{
            _connecting = false;
            setConnected(false);
            if (Log.isError()){
                _log.error("'{0}' channel disconnect failed.", id);
            };
            if (reconnecting){
                resetToPrimaryURI();
                _arg1.reconnecting = false;
            };
            dispatchEvent(_arg1);
        }

    }
}//package mx.messaging 

import mx.messaging.events.*;
import mx.messaging.messages.*;
import mx.logging.*;

class AuthenticationMessageResponder extends MessageResponder {

    private var _log:ILogger;

    public function AuthenticationMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:Channel, _arg4:ILogger){
        super(_arg1, _arg2, _arg3);
        _log = _arg4;
    }
    override protected function statusHandler(_arg1:IMessage):void{
        var _local3:ErrorMessage;
        var _local4:ChannelFaultEvent;
        var _local2:CommandMessage = CommandMessage(message);
        if (Log.isDebug()){
            _log.debug("{1} failure: {0}", _arg1.toString(), (((_local2.operation == CommandMessage.LOGIN_OPERATION)) ? "Login" : "Logout"));
        };
        channel.authenticating = false;
        channel.setAuthenticated(false);
        if (((!((agent == null))) && (agent.hasPendingRequestForMessage(message)))){
            agent.fault(ErrorMessage(_arg1), message);
        } else {
            _local3 = ErrorMessage(_arg1);
            _local4 = ChannelFaultEvent.createEvent(channel, false, "Channel.Authentication.Error", "warn", _local3.faultString);
            _local4.rootCause = _local3;
            channel.dispatchEvent(_local4);
        };
    }
    override protected function resultHandler(_arg1:IMessage):void{
        var _local2:CommandMessage = (message as CommandMessage);
        channel.authenticating = false;
        if (_local2.operation == CommandMessage.LOGIN_OPERATION){
            if (Log.isDebug()){
                _log.debug("Login successful");
            };
            channel.setAuthenticated(true);
        } else {
            if (Log.isDebug()){
                _log.debug("Logout successful");
            };
            channel.setAuthenticated(false);
        };
    }

}
