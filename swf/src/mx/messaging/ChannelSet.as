package mx.messaging {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.rpc.events.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;
    import flash.utils.*;
    import mx.messaging.channels.*;
    import mx.utils.*;
    import mx.messaging.config.*;
    import mx.messaging.errors.*;
    import flash.errors.*;

    public class ChannelSet extends EventDispatcher {

        private var _shouldHunt:Boolean;
        private var _connected:Boolean;
        private var _hasRequestedClusterEndpoints:Boolean;
        private var _clustered:Boolean;
        private var _channels:Array;
        private var _hunting:Boolean;
        private var _authenticated:Boolean;
        private var _pendingMessages:Dictionary;
        private var _authAgent:AuthenticationAgent;
        private var resourceManager:IResourceManager;
        private var _initialDestinationId:String;
        private var _credentials:String;
        private var _reconnectTimer:Timer = null;
        private var _credentialsCharset:String;
        private var _shouldBeConnected:Boolean;
        private var _connecting:Boolean;
        private var _channelIds:Array;
        private var _configured:Boolean;
        private var _currentChannel:Channel;
        private var _currentChannelIndex:int;
        private var _pendingSends:Array;
        private var _messageAgents:Array;
        private var _channelFailoverURIs:Object;

        public function ChannelSet(_arg1:Array=null, _arg2:Boolean=false){
            resourceManager = ResourceManager.getInstance();
            super();
            _clustered = _arg2;
            _connected = false;
            _connecting = false;
            _currentChannelIndex = -1;
            if (_arg1 != null){
                _channelIds = _arg1;
                _channels = new Array(_channelIds.length);
                _configured = true;
            } else {
                _channels = [];
                _configured = false;
            };
            _hasRequestedClusterEndpoints = false;
            _hunting = false;
            _messageAgents = [];
            _pendingMessages = new Dictionary();
            _pendingSends = [];
            _shouldBeConnected = false;
            _shouldHunt = true;
        }
        public function get connected():Boolean{
            return (_connected);
        }
        public function login(_arg1:String, _arg2:String, _arg3:String=null):AsyncToken{
            var _local7:String;
            var _local8:Base64Encoder;
            if (authenticated){
                throw (new IllegalOperationError("ChannelSet is already authenticated."));
            };
            if (((!((_authAgent == null))) && (!((_authAgent.state == AuthenticationAgent.LOGGED_OUT_STATE))))){
                throw (new IllegalOperationError("ChannelSet is in the process of logging in or logging out."));
            };
            if (_arg3 != Base64Encoder.CHARSET_UTF_8){
            };
            _arg3 = null;
            var _local4:String;
            if (((!((_arg1 == null))) && (!((_arg2 == null))))){
                _local7 = ((_arg1 + ":") + _arg2);
                _local8 = new Base64Encoder();
                if (_arg3 == Base64Encoder.CHARSET_UTF_8){
                    _local8.encodeUTFBytes(_local7);
                } else {
                    _local8.encode(_local7);
                };
                _local4 = _local8.drain();
            };
            var _local5:CommandMessage = new CommandMessage();
            _local5.operation = CommandMessage.LOGIN_OPERATION;
            _local5.body = _local4;
            if (_arg3 != null){
                _local5.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = _arg3;
            };
            _local5.destination = "auth";
            var _local6:AsyncToken = new AsyncToken(_local5);
            if (_authAgent == null){
                _authAgent = new AuthenticationAgent(this);
            };
            _authAgent.registerToken(_local6);
            _authAgent.state = AuthenticationAgent.LOGGING_IN_STATE;
            send(_authAgent, _local5);
            return (_local6);
        }
        private function hunt():Boolean{
            var _local1:String;
            if (_channels.length == 0){
                _local1 = resourceManager.getString("messaging", "noAvailableChannels");
                throw (new NoChannelAvailableError(_local1));
            };
            if (++_currentChannelIndex >= _channels.length){
                _currentChannelIndex = -1;
                return (false);
            };
            if (_currentChannelIndex > 0){
                _hunting = true;
            };
            if (configured){
                if (_channels[_currentChannelIndex] != null){
                    _currentChannel = _channels[_currentChannelIndex];
                } else {
                    _currentChannel = ServerConfig.getChannel(_channelIds[_currentChannelIndex], _clustered);
                    _currentChannel.setCredentials(_credentials);
                    _channels[_currentChannelIndex] = _currentChannel;
                };
            } else {
                _currentChannel = _channels[_currentChannelIndex];
            };
            if (((!((_channelFailoverURIs == null))) && (!((_channelFailoverURIs[_currentChannel.id] == null))))){
                _currentChannel.failoverURIs = _channelFailoverURIs[_currentChannel.id];
            };
            return (true);
        }
        public function get clustered():Boolean{
            return (_clustered);
        }
        public function disconnect(_arg1:MessageAgent):void{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:PendingSend;
            if (_arg1 == null){
                _local2 = _messageAgents.slice();
                _local3 = _local2.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local2[_local4].disconnect();
                    _local4++;
                };
                if (_authAgent != null){
                    _authAgent.state = AuthenticationAgent.SHUTDOWN_STATE;
                    _authAgent = null;
                };
            } else {
                _local5 = ((_arg1)!=null) ? _messageAgents.indexOf(_arg1) : -1;
                if (_local5 != -1){
                    _messageAgents.splice(_local5, 1);
                    removeEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                    removeEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                    removeEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
                    if (((connected) || (_connecting))){
                        _arg1.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, _currentChannel, false));
                    } else {
                        _local6 = _pendingSends.length;
                        _local7 = 0;
                        while (_local7 < _local6) {
                            _local8 = PendingSend(_pendingSends[_local7]);
                            if (_local8.agent == _arg1){
                                _pendingSends.splice(_local7, 1);
                                _local7--;
                                _local6--;
                                delete _pendingMessages[_local8.message];
                            };
                            _local7++;
                        };
                    };
                    if (_messageAgents.length == 0){
                        _shouldBeConnected = false;
                        if (connected){
                            disconnectChannel();
                        };
                    };
                    if (_arg1.channelSetMode == MessageAgent.AUTO_CONFIGURED_CHANNELSET){
                        _arg1.internalSetChannelSet(null);
                    };
                };
            };
        }
        public function set channels(_arg1:Array):void{
            var _local5:String;
            var _local6:int;
            var _local7:int;
            if (configured){
                _local5 = resourceManager.getString("messaging", "cannotAddWhenConfigured");
                throw (new IllegalOperationError(_local5));
            };
            var _local2:Array = _channels.slice();
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3) {
                removeChannel(_local2[_local4]);
                _local4++;
            };
            if (((!((_arg1 == null))) && ((_arg1.length > 0)))){
                _local6 = _arg1.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    addChannel(_arg1[_local7]);
                    _local7++;
                };
            };
        }
        public function addChannel(_arg1:Channel):void{
            var _local2:String;
            if (_arg1 == null){
                return;
            };
            if (configured){
                _local2 = resourceManager.getString("messaging", "cannotAddWhenConfigured");
                throw (new IllegalOperationError(_local2));
            };
            if (((clustered) && ((_arg1.id == null)))){
                _local2 = resourceManager.getString("messaging", "cannotAddNullIdChannelWhenClustered");
                throw (new IllegalOperationError(_local2));
            };
            if (_channels.indexOf(_arg1) != -1){
                return;
            };
            _channels.push(_arg1);
            if (_credentials){
                _arg1.setCredentials(_credentials, null, _credentialsCharset);
            };
        }
        public function send(_arg1:MessageAgent, _arg2:IMessage):void{
            var _local3:AcknowledgeMessage;
            var _local4:CommandMessage;
            if (connected){
                if ((((_arg2 is CommandMessage)) && ((CommandMessage(_arg2).operation == CommandMessage.TRIGGER_CONNECT_OPERATION)))){
                    _local3 = new AcknowledgeMessage();
                    _local3.clientId = _arg1.clientId;
                    _local3.correlationId = _arg2.messageId;
                    _arg1.acknowledge(_local3, _arg2);
                    return;
                };
                if (((!(_hasRequestedClusterEndpoints)) && (clustered))){
                    _local4 = new CommandMessage();
                    if ((_arg1 is AuthenticationAgent)){
                        _local4.destination = initialDestinationId;
                    } else {
                        _local4.destination = _arg1.destination;
                    };
                    _local4.operation = CommandMessage.CLUSTER_REQUEST_OPERATION;
                    _currentChannel.sendClusterRequest(new ClusterMessageResponder(_local4, this));
                    _hasRequestedClusterEndpoints = true;
                };
                _currentChannel.send(_arg1, _arg2);
            } else {
                if (_pendingMessages[_arg2] == null){
                    _pendingMessages[_arg2] = true;
                    _pendingSends.push(new PendingSend(_arg1, _arg2));
                };
                if (!_connecting){
                    if ((((_currentChannel == null)) || ((_currentChannelIndex == -1)))){
                        hunt();
                    };
                    if ((_currentChannel is NetConnectionChannel)){
                        if (_reconnectTimer == null){
                            _reconnectTimer = new Timer(1, 1);
                            _reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectChannel);
                            _reconnectTimer.start();
                        };
                    } else {
                        connectChannel();
                    };
                };
            };
        }
        public function logout(_arg1:MessageAgent=null):AsyncToken{
            var _local2:int;
            var _local3:int;
            var _local4:CommandMessage;
            var _local5:AsyncToken;
            var _local6:int;
            var _local7:int;
            _credentials = null;
            if (_arg1 == null){
                if (((!((_authAgent == null))) && ((((_authAgent.state == AuthenticationAgent.LOGGING_OUT_STATE)) || ((_authAgent.state == AuthenticationAgent.LOGGING_IN_STATE)))))){
                    throw (new IllegalOperationError("ChannelSet is in the process of logging in or logging out."));
                };
                _local2 = _messageAgents.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    _messageAgents[_local3].internalSetCredentials(null);
                    _local3++;
                };
                _local2 = _channels.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (_channels[_local3] != null){
                        _channels[_local3].internalSetCredentials(null);
                    };
                    _local3++;
                };
                _local4 = new CommandMessage();
                _local4.operation = CommandMessage.LOGOUT_OPERATION;
                _local4.destination = "auth";
                _local5 = new AsyncToken(_local4);
                if (_authAgent == null){
                    _authAgent = new AuthenticationAgent(this);
                };
                _authAgent.registerToken(_local5);
                _authAgent.state = AuthenticationAgent.LOGGING_OUT_STATE;
                send(_authAgent, _local4);
                return (_local5);
            };
            _local6 = _channels.length;
            _local7 = 0;
            while (_local7 < _local6) {
                if (_channels[_local7] != null){
                    _channels[_local7].logout(_arg1);
                };
                _local7++;
            };
            return (null);
        }
        public function set clustered(_arg1:Boolean):void{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:String;
            if (_clustered != _arg1){
                if (_arg1){
                    _local2 = channelIds;
                    _local3 = _local2.length;
                    _local4 = 0;
                    while (_local4 < _local3) {
                        if (_local2[_local4] == null){
                            _local5 = resourceManager.getString("messaging", "cannotSetClusteredWithdNullChannelIds");
                            throw (new IllegalOperationError(_local5));
                        };
                        _local4++;
                    };
                };
                _clustered = _arg1;
            };
        }
        public function get channelIds():Array{
            var _local1:Array;
            var _local2:int;
            var _local3:int;
            if (_channelIds != null){
                return (_channelIds);
            };
            _local1 = [];
            _local2 = _channels.length;
            _local3 = 0;
            while (_local3 < _local2) {
                if (_channels[_local3] != null){
                    _local1.push(_channels[_local3].id);
                } else {
                    _local1.push(null);
                };
                _local3++;
            };
            return (_local1);
        }
        public function get authenticated():Boolean{
            return (_authenticated);
        }
        private function connectChannel():void{
            if (((!(connected)) && (!(_connecting)))){
                _connecting = true;
                _currentChannel.connect(this);
                _currentChannel.addEventListener(MessageEvent.MESSAGE, messageHandler);
            };
        }
        private function reconnectChannel(_arg1:TimerEvent):void{
            _reconnectTimer.stop();
            _reconnectTimer.removeEventListener(TimerEvent.TIMER, reconnectChannel);
            _reconnectTimer = null;
            connectChannel();
        }
        mx_internal function get channelFailoverURIs():Object{
            return (_channelFailoverURIs);
        }
        mx_internal function get configured():Boolean{
            return (_configured);
        }
        public function setCredentials(_arg1:String, _arg2:MessageAgent, _arg3:String=null):void{
            _credentials = _arg1;
            var _local4:int = _channels.length;
            var _local5:int;
            while (_local5 < _local4) {
                if (_channels[_local5] != null){
                    _channels[_local5].setCredentials(_credentials, _arg2, _arg3);
                };
                _local5++;
            };
        }
        private function messageHandler(_arg1:MessageEvent):void{
            dispatchEvent(_arg1);
        }
        protected function setConnected(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_connected != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "connected", _connected, _arg1);
                _connected = _arg1;
                dispatchEvent(_local2);
                setAuthenticated(((((_arg1) && (currentChannel))) && (currentChannel.authenticated)), _credentials, false);
            };
        }
        public function get currentChannel():Channel{
            return (_currentChannel);
        }
        private function disconnectChannel():void{
            _connecting = false;
            _currentChannel.removeEventListener(MessageEvent.MESSAGE, messageHandler);
            _currentChannel.disconnect(this);
        }
        public function get channels():Array{
            return (_channels);
        }
        public function set initialDestinationId(_arg1:String):void{
            _initialDestinationId = _arg1;
        }
        private function dispatchRPCEvent(_arg1:AbstractEvent):void{
            _arg1.callTokenResponders();
            dispatchEvent(_arg1);
        }
        public function channelDisconnectHandler(_arg1:ChannelEvent):void{
            _connecting = false;
            setConnected(false);
            if (((((_shouldBeConnected) && (!(_arg1.reconnecting)))) && (!(_arg1.rejected)))){
                if (((_shouldHunt) && (hunt()))){
                    _arg1.reconnecting = true;
                    dispatchEvent(_arg1);
                    if ((_currentChannel is NetConnectionChannel)){
                        if (_reconnectTimer == null){
                            _reconnectTimer = new Timer(1, 1);
                            _reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectChannel);
                            _reconnectTimer.start();
                        };
                    } else {
                        connectChannel();
                    };
                } else {
                    dispatchEvent(_arg1);
                    faultPendingSends(_arg1);
                };
            } else {
                dispatchEvent(_arg1);
                if (_arg1.rejected){
                    faultPendingSends(_arg1);
                };
            };
            _shouldHunt = true;
        }
        public function removeChannel(_arg1:Channel):void{
            var _local3:String;
            if (configured){
                _local3 = resourceManager.getString("messaging", "cannotRemoveWhenConfigured");
                throw (new IllegalOperationError(_local3));
            };
            var _local2:int = _channels.indexOf(_arg1);
            if (_local2 > -1){
                _channels.splice(_local2, 1);
                if (((!((_currentChannel == null))) && ((_currentChannel == _arg1)))){
                    if (connected){
                        _shouldHunt = false;
                        disconnectChannel();
                    };
                    _currentChannel = null;
                    _currentChannelIndex = -1;
                };
            };
        }
        public function channelConnectHandler(_arg1:ChannelEvent):void{
            var _local3:PendingSend;
            var _local4:CommandMessage;
            var _local5:AcknowledgeMessage;
            _connecting = false;
            _connected = true;
            while (_pendingSends.length > 0) {
                _local3 = PendingSend(_pendingSends.shift());
                delete _pendingMessages[_local3.message];
                _local4 = (_local3.message as CommandMessage);
                if (_local4 != null){
                    if (_local4.operation == CommandMessage.TRIGGER_CONNECT_OPERATION){
                        _local5 = new AcknowledgeMessage();
                        _local5.clientId = _local3.agent.clientId;
                        _local5.correlationId = _local4.messageId;
                        _local3.agent.acknowledge(_local5, _local4);
                        continue;
                    };
                    if (((((!(_local3.agent.configRequested)) && (_local3.agent.needsConfig))) && ((_local4.operation == CommandMessage.CLIENT_PING_OPERATION)))){
                        _local4.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
                        _local3.agent.configRequested = true;
                    };
                };
                send(_local3.agent, _local3.message);
            };
            if (_hunting){
                _arg1.reconnecting = true;
                _hunting = false;
            };
            dispatchEvent(_arg1);
            var _local2:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "connected", false, true);
            dispatchEvent(_local2);
        }
        public function get initialDestinationId():String{
            return (_initialDestinationId);
        }
        public function connect(_arg1:MessageAgent):void{
            if (((!((_arg1 == null))) && ((_messageAgents.indexOf(_arg1) == -1)))){
                _shouldBeConnected = true;
                _messageAgents.push(_arg1);
                _arg1.internalSetChannelSet(this);
                addEventListener(ChannelEvent.CONNECT, _arg1.channelConnectHandler);
                addEventListener(ChannelEvent.DISCONNECT, _arg1.channelDisconnectHandler);
                addEventListener(ChannelFaultEvent.FAULT, _arg1.channelFaultHandler);
                if (connected){
                    _arg1.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT, _currentChannel, false, false, connected));
                };
            };
        }
        public function channelFaultHandler(_arg1:ChannelFaultEvent):void{
            if (_arg1.channel.connected){
                dispatchEvent(_arg1);
            } else {
                _connecting = false;
                setConnected(false);
                if (((((_shouldBeConnected) && (!(_arg1.reconnecting)))) && (!(_arg1.rejected)))){
                    if (hunt()){
                        _arg1.reconnecting = true;
                        dispatchEvent(_arg1);
                        if ((_currentChannel is NetConnectionChannel)){
                            if (_reconnectTimer == null){
                                _reconnectTimer = new Timer(1, 1);
                                _reconnectTimer.addEventListener(TimerEvent.TIMER, reconnectChannel);
                                _reconnectTimer.start();
                            };
                        } else {
                            connectChannel();
                        };
                    } else {
                        dispatchEvent(_arg1);
                        faultPendingSends(_arg1);
                    };
                } else {
                    dispatchEvent(_arg1);
                    if (_arg1.rejected){
                        faultPendingSends(_arg1);
                    };
                };
            };
        }
        mx_internal function setAuthenticated(_arg1:Boolean, _arg2:String, _arg3:Boolean=true):void{
            var _local4:PropertyChangeEvent;
            var _local5:MessageAgent;
            var _local6:int;
            if (_authenticated != _arg1){
                _local4 = PropertyChangeEvent.createUpdateEvent(this, "authenticated", _authenticated, _arg1);
                _authenticated = _arg1;
                if (_arg3){
                    _local6 = 0;
                    while (_local6 < _messageAgents.length) {
                        _local5 = MessageAgent(_messageAgents[_local6]);
                        _local5.setAuthenticated(_arg1, _arg2);
                        _local6++;
                    };
                };
                dispatchEvent(_local4);
            };
        }
        private function faultPendingSends(_arg1:ChannelEvent):void{
            var _local2:PendingSend;
            var _local3:IMessage;
            var _local4:ErrorMessage;
            var _local5:ChannelFaultEvent;
            while (_pendingSends.length > 0) {
                _local2 = (_pendingSends.shift() as PendingSend);
                _local3 = _local2.message;
                delete _pendingMessages[_local3];
                _local4 = new ErrorMessage();
                _local4.correlationId = _local3.messageId;
                _local4.headers[ErrorMessage.RETRYABLE_HINT_HEADER] = true;
                _local4.faultCode = "Client.Error.MessageSend";
                _local4.faultString = resourceManager.getString("messaging", "sendFailed");
                if ((_arg1 is ChannelFaultEvent)){
                    _local5 = (_arg1 as ChannelFaultEvent);
                    _local4.faultDetail = ((((_local5.faultCode + " ") + _local5.faultString) + " ") + _local5.faultDetail);
                    if (_local5.faultCode == "Channel.Authentication.Error"){
                        _local4.faultCode = _local5.faultCode;
                    };
                } else {
                    _local4.faultDetail = resourceManager.getString("messaging", "cannotConnectToDestination");
                };
                _local4.rootCause = _arg1;
                _local2.agent.fault(_local4, _local3);
            };
        }
        mx_internal function authenticationSuccess(_arg1:AuthenticationAgent, _arg2:AsyncToken, _arg3:AcknowledgeMessage):void{
            var _local8:int;
            var _local9:int;
            var _local4:CommandMessage = CommandMessage(_arg2.message);
            var _local5 = (_local4.operation == CommandMessage.LOGIN_OPERATION);
            var _local6:String = ((_local5) ? String(_local4.body) : null);
            if (_local5){
                _credentials = _local6;
                _local8 = _messageAgents.length;
                _local9 = 0;
                while (_local9 < _local8) {
                    _messageAgents[_local9].internalSetCredentials(_local6);
                    _local9++;
                };
                _local8 = _channels.length;
                _local9 = 0;
                while (_local9 < _local8) {
                    if (_channels[_local9] != null){
                        _channels[_local9].internalSetCredentials(_local6);
                    };
                    _local9++;
                };
                _arg1.state = AuthenticationAgent.LOGGED_IN_STATE;
                currentChannel.setAuthenticated(true);
            } else {
                _arg1.state = AuthenticationAgent.SHUTDOWN_STATE;
                _authAgent = null;
                disconnect(_arg1);
                currentChannel.setAuthenticated(false);
            };
            var _local7:ResultEvent = ResultEvent.createEvent(_arg3.body, _arg2, _arg3);
            dispatchRPCEvent(_local7);
        }
        public function disconnectAll():void{
            disconnect(null);
        }
        public function get messageAgents():Array{
            return (_messageAgents);
        }
        mx_internal function set channelFailoverURIs(_arg1:Object):void{
            var _local4:Channel;
            _channelFailoverURIs = _arg1;
            var _local2:int = _channels.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = _channels[_local3];
                if (_local4 == null){
                    break;
                };
                if (_channelFailoverURIs[_local4.id] != null){
                    _local4.failoverURIs = _channelFailoverURIs[_local4.id];
                };
                _local3++;
            };
        }
        mx_internal function authenticationFailure(_arg1:AuthenticationAgent, _arg2:AsyncToken, _arg3:ErrorMessage):void{
            var _local4:MessageFaultEvent = MessageFaultEvent.createEvent(_arg3);
            var _local5:FaultEvent = FaultEvent.createEventFromMessageFault(_local4, _arg2);
            _arg1.state = AuthenticationAgent.SHUTDOWN_STATE;
            _authAgent = null;
            disconnect(_arg1);
            dispatchRPCEvent(_local5);
        }
        override public function toString():String{
            var _local1 = "[ChannelSet ";
            var _local2:uint;
            while (_local2 < _channels.length) {
                if (_channels[_local2] != null){
                    _local1 = (_local1 + (_channels[_local2].id + " "));
                };
                _local2++;
            };
            _local1 = (_local1 + "]");
            return (_local1);
        }

    }
}//package mx.messaging 

import mx.messaging.messages.*;
import mx.rpc.*;
import mx.logging.*;

class AuthenticationAgent extends MessageAgent {

    public static const LOGGING_OUT_STATE:int = 3;
    public static const LOGGED_OUT_STATE:int = 0;
    public static const LOGGED_IN_STATE:int = 2;
    public static const LOGGING_IN_STATE:int = 1;
    public static const SHUTDOWN_STATE:int = 4;

    private var _state:int = 0;
    private var tokens:Object;

    public function AuthenticationAgent(_arg1:ChannelSet){
        tokens = {};
        super();
        _log = Log.getLogger("ChannelSet.AuthenticationAgent");
        _agentType = "authentication agent";
        this.channelSet = _arg1;
    }
    public function get state():int{
        return (_state);
    }
    public function registerToken(_arg1:AsyncToken):void{
        tokens[_arg1.message.messageId] = _arg1;
    }
    public function set state(_arg1:int):void{
        _state = _arg1;
        if (_arg1 == SHUTDOWN_STATE){
            tokens = null;
        };
    }
    override public function acknowledge(_arg1:AcknowledgeMessage, _arg2:IMessage):void{
        var _local4:AsyncToken;
        if (state == SHUTDOWN_STATE){
            return;
        };
        var _local3:Boolean = _arg1.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
        super.acknowledge(_arg1, _arg2);
        if (!_local3){
            _local4 = tokens[_arg2.messageId];
            delete tokens[_arg2.messageId];
            channelSet.authenticationSuccess(this, _local4, (_arg1 as AcknowledgeMessage));
        };
    }
    override public function fault(_arg1:ErrorMessage, _arg2:IMessage):void{
        if (state == SHUTDOWN_STATE){
            return;
        };
        super.fault(_arg1, _arg2);
        var _local3:AsyncToken = tokens[_arg2.messageId];
        delete tokens[_arg2.messageId];
        channelSet.authenticationFailure(this, _local3, (_arg1 as ErrorMessage));
    }

}
class PendingSend {

    public var agent:MessageAgent;
    public var message:IMessage;

    public function PendingSend(_arg1:MessageAgent, _arg2:IMessage){
        this.agent = _arg1;
        this.message = _arg2;
    }
}
class ClusterMessageResponder extends MessageResponder {

    private var _channelSet:ChannelSet;

    public function ClusterMessageResponder(_arg1:IMessage, _arg2:ChannelSet){
        super(null, _arg1);
        _channelSet = _arg2;
    }
    override protected function resultHandler(_arg1:IMessage):void{
        var _local2:Object;
        var _local3:Array;
        var _local4:int;
        var _local5:int;
        var _local6:Object;
        var _local7:Object;
        if (((!((_arg1.body == null))) && ((_arg1.body is Array)))){
            _local2 = {};
            _local3 = (_arg1.body as Array);
            _local4 = _local3.length;
            _local5 = 0;
            while (_local5 < _local4) {
                _local6 = _local3[_local5];
                for (_local7 in _local6) {
                    if (_local2[_local7] == null){
                        _local2[_local7] = [];
                    };
                    _local2[_local7].push(_local6[_local7]);
                };
                _local5++;
            };
            _channelSet.channelFailoverURIs = _local2;
        };
    }

}
