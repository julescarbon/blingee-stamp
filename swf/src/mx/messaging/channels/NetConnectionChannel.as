package mx.messaging.channels {
    import flash.events.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import mx.messaging.*;
    import mx.logging.*;
    import flash.net.*;

    public class NetConnectionChannel extends PollingChannel {

        mx_internal var _appendToURL:String;
        protected var _nc:NetConnection;

        public function NetConnectionChannel(_arg1:String=null, _arg2:String=null){
            super(_arg1, _arg2);
            _nc = new NetConnection();
            _nc.objectEncoding = ObjectEncoding.AMF3;
            _nc.client = this;
        }
        public function AppendToGatewayUrl(_arg1:String):void{
            if (((((!((_arg1 == null))) && (!((_arg1 == ""))))) && (!((_arg1 == _appendToURL))))){
                if (Log.isDebug()){
                    _log.debug("'{0}' channel will disconnect and reconnect with with its session identifier '{1}' appended to its endpoint url \n", id, _arg1);
                };
                _appendToURL = _arg1;
            };
        }
        public function receive(_arg1:IMessage, ... _args):void{
            var mpiutil:* = null;
            var msg:* = _arg1;
            var rest:* = _args;
            if (Log.isDebug()){
                _log.debug("'{0}' channel got message\n{1}\n", id, msg.toString());
                if (this.mpiEnabled){
                    try {
                        mpiutil = new MessagePerformanceUtils(msg);
                        _log.debug(mpiutil.prettyPrint());
                    } catch(e:Error) {
                        _log.debug(("Could not get message performance information for: " + msg.toString()));
                    };
                };
            };
            dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, msg));
        }
        override protected function internalSend(_arg1:MessageResponder):void{
            var _local3:MessagePerformanceInfo;
            var _local4:IMessage;
            setFlexClientIdOnMessage(_arg1.message);
            if (mpiEnabled){
                _local3 = new MessagePerformanceInfo();
                if (recordMessageTimes){
                    _local3.sendTime = new Date().getTime();
                };
                _arg1.message.headers[MessagePerformanceUtils.MPI_HEADER_IN] = _local3;
            };
            var _local2:IMessage = _arg1.message;
            if (((useSmallMessages) && ((_local2 is ISmallMessage)))){
                _local4 = ISmallMessage(_local2).getSmallMessage();
                if (_local4 != null){
                    _local2 = _local4;
                };
            };
            _nc.call(null, _arg1, _local2);
        }
        override protected function getDefaultMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder{
            return (new NetConnectionMessageResponder(_arg1, _arg2, this));
        }
        protected function securityErrorHandler(_arg1:SecurityErrorEvent):void{
            defaultErrorHandler("Channel.Security.Error", _arg1);
        }
        private function defaultErrorHandler(_arg1:String, _arg2:ErrorEvent):void{
            var _local3:ChannelFaultEvent = ChannelFaultEvent.createEvent(this, false, _arg1, "error", (((_arg2.text + " url: '") + endpoint) + "'"));
            _local3.rootCause = _arg2;
            if (_connecting){
                connectFailed(_local3);
            } else {
                dispatchEvent(_local3);
            };
        }
        override protected function getPollSyncMessageResponder(_arg1:MessageAgent, _arg2:CommandMessage):MessageResponder{
            return (new PollSyncMessageResponder(_arg1, _arg2, this));
        }
        override public function get useSmallMessages():Boolean{
            return (((((super.useSmallMessages) && (!((_nc == null))))) && ((_nc.objectEncoding >= ObjectEncoding.AMF3))));
        }
        override protected function internalConnect():void{
            var url:* = null;
            var i:* = 0;
            var temp:* = null;
            var j:* = 0;
            super.internalConnect();
            url = endpoint;
            if (_appendToURL != null){
                i = url.indexOf("wsrp-url=");
                if (i != -1){
                    temp = url.substr((i + 9), url.length);
                    j = temp.indexOf("&");
                    if (j != -1){
                        temp = temp.substr(0, j);
                    };
                    url = url.replace(temp, (temp + _appendToURL));
                } else {
                    url = (url + _appendToURL);
                };
            };
            if (((((!((_nc.uri == null))) && ((_nc.uri.length > 0)))) && (_nc.connected))){
                _nc.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                _nc.close();
            };
            _nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            _nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            try {
                _nc.connect(url);
            } catch(e:Error) {
                e.message = (e.message + (("  url: '" + url) + "'"));
                throw (e);
            };
        }
        protected function ioErrorHandler(_arg1:IOErrorEvent):void{
            defaultErrorHandler("Channel.IO.Error", _arg1);
        }
        protected function statusHandler(_arg1:NetStatusEvent):void{
        }
        override protected function internalDisconnect(_arg1:Boolean=false):void{
            super.internalDisconnect(_arg1);
            shutdownNetConnection();
            disconnectSuccess(_arg1);
        }
        override protected function connectTimeoutHandler(_arg1:TimerEvent):void{
            shutdownNetConnection();
            super.connectTimeoutHandler(_arg1);
        }
        public function get netConnection():NetConnection{
            return (_nc);
        }
        protected function shutdownNetConnection():void{
            _nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _nc.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _nc.removeEventListener(NetStatusEvent.NET_STATUS, statusHandler);
            _nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            _nc.close();
        }
        protected function asyncErrorHandler(_arg1:AsyncErrorEvent):void{
            defaultErrorHandler("Channel.Async.Error", _arg1);
        }

    }
}//package mx.messaging.channels 

import mx.resources.*;
import mx.messaging.events.*;
import mx.messaging.messages.*;
import mx.messaging.*;

class NetConnectionMessageResponder extends MessageResponder {

    private var resourceManager:IResourceManager;

    public function NetConnectionMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:NetConnectionChannel){
        resourceManager = ResourceManager.getInstance();
        super(_arg1, _arg2, _arg3);
        _arg3.addEventListener(ChannelEvent.DISCONNECT, channelDisconnectHandler);
        _arg3.addEventListener(ChannelFaultEvent.FAULT, channelFaultHandler);
    }
    protected function channelFaultHandler(_arg1:ChannelFaultEvent):void{
        disconnect();
        var _local2:ErrorMessage = _arg1.createErrorMessage();
        _local2.correlationId = message.messageId;
        if (!_arg1.channel.connected){
            _local2.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
        };
        agent.fault(_local2, message);
    }
    override protected function requestTimedOut():void{
        disconnect();
        statusHandler(createRequestTimeoutErrorMessage());
    }
    override protected function statusHandler(_arg1:IMessage):void{
        var _local2:AcknowledgeMessage;
        var _local3:ErrorMessage;
        disconnect();
        if ((_arg1 is AsyncMessage)){
            if (AsyncMessage(_arg1).correlationId == message.messageId){
                _local2 = new AcknowledgeMessage();
                _local2.correlationId = AsyncMessage(_arg1).correlationId;
                _local2.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
                agent.acknowledge(_local2, message);
                agent.fault((_arg1 as ErrorMessage), message);
            } else {
                if ((_arg1 is ErrorMessage)){
                    agent.fault((_arg1 as ErrorMessage), message);
                } else {
                    _local3 = new ErrorMessage();
                    _local3.faultCode = "Server.Acknowledge.Failed";
                    _local3.faultString = resourceManager.getString("messaging", "noErrorForMessage");
                    _local3.faultDetail = resourceManager.getString("messaging", "noErrorForMessage.details", [message.messageId, AsyncMessage(_arg1).correlationId]);
                    _local3.correlationId = message.messageId;
                    agent.fault(_local3, message);
                };
            };
        } else {
            _local3 = new ErrorMessage();
            _local3.faultCode = "Server.Acknowledge.Failed";
            _local3.faultString = resourceManager.getString("messaging", "noAckMessage");
            _local3.faultDetail = resourceManager.getString("messaging", "noAckMessage.details", [((_arg1) ? _arg1.toString() : "null")]);
            _local3.correlationId = message.messageId;
            agent.fault(_local3, message);
        };
    }
    protected function channelDisconnectHandler(_arg1:ChannelEvent):void{
        disconnect();
        var _local2:ErrorMessage = new ErrorMessage();
        _local2.correlationId = message.messageId;
        _local2.faultString = resourceManager.getString("messaging", "deliveryInDoubt");
        _local2.faultDetail = resourceManager.getString("messaging", "deliveryInDoubt.details");
        _local2.faultCode = ErrorMessage.MESSAGE_DELIVERY_IN_DOUBT;
        agent.fault(_local2, message);
    }
    private function disconnect():void{
        channel.removeEventListener(ChannelEvent.DISCONNECT, channelDisconnectHandler);
        channel.removeEventListener(ChannelFaultEvent.FAULT, channelFaultHandler);
    }
    override protected function resultHandler(_arg1:IMessage):void{
        var _local2:ErrorMessage;
        disconnect();
        if ((_arg1 is AsyncMessage)){
            if (AsyncMessage(_arg1).correlationId == message.messageId){
                agent.acknowledge((_arg1 as AcknowledgeMessage), message);
            } else {
                _local2 = new ErrorMessage();
                _local2.faultCode = "Server.Acknowledge.Failed";
                _local2.faultString = resourceManager.getString("messaging", "ackFailed");
                _local2.faultDetail = resourceManager.getString("messaging", "ackFailed.details", [message.messageId, AsyncMessage(_arg1).correlationId]);
                _local2.correlationId = message.messageId;
                agent.fault(_local2, message);
            };
        } else {
            _local2 = new ErrorMessage();
            _local2.faultCode = "Server.Acknowledge.Failed";
            _local2.faultString = resourceManager.getString("messaging", "noAckMessage");
            _local2.faultDetail = resourceManager.getString("messaging", "noAckMessage.details", [((_arg1) ? _arg1.toString() : "null")]);
            _local2.correlationId = message.messageId;
            agent.fault(_local2, message);
        };
    }

}
class PollSyncMessageResponder extends NetConnectionMessageResponder {

    public function PollSyncMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:NetConnectionChannel){
        super(_arg1, _arg2, _arg3);
    }
    override protected function channelFaultHandler(_arg1:ChannelFaultEvent):void{
    }
    override protected function channelDisconnectHandler(_arg1:ChannelEvent):void{
    }
    override protected function resultHandler(_arg1:IMessage):void{
        var _local2:CommandMessage;
        super.resultHandler(_arg1);
        if ((((_arg1 is AsyncMessage)) && ((AsyncMessage(_arg1).correlationId == message.messageId)))){
            _local2 = CommandMessage(message);
            switch (_local2.operation){
                case CommandMessage.SUBSCRIBE_OPERATION:
                    NetConnectionChannel(channel).enablePolling();
                    break;
                case CommandMessage.UNSUBSCRIBE_OPERATION:
                    NetConnectionChannel(channel).disablePolling();
                    break;
            };
        };
    }

}
