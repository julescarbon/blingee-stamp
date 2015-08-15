package mx.messaging.channels {
    import flash.events.*;
    import mx.resources.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import mx.messaging.*;
    import mx.logging.*;

    public class PollingChannel extends Channel {

        private static const DEFAULT_POLLING_INTERVAL:int = 3000;

        mx_internal var _timer:Timer;
        private var _pollingEnabled:Boolean;
        private var _piggybackingEnabled:Boolean;
        mx_internal var _pollingInterval:int;
        mx_internal var pollOutstanding:Boolean;
        private var _pollingRef:int = -1;
        mx_internal var _shouldPoll:Boolean;
        private var resourceManager:IResourceManager;

        public function PollingChannel(_arg1:String=null, _arg2:String=null){
            resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
            _pollingEnabled = true;
            _shouldPoll = false;
            if (timerRequired()){
                _pollingInterval = DEFAULT_POLLING_INTERVAL;
                _timer = new Timer(_pollingInterval, 1);
                _timer.addEventListener(TimerEvent.TIMER, internalPoll);
            };
        }
        public function enablePolling():void{
            _pollingRef++;
            if (_pollingRef == 0){
                startPolling();
            };
        }
        protected function timerRequired():Boolean{
            return (true);
        }
        override protected function connectFailed(_arg1:ChannelFaultEvent):void{
            stopPolling();
            super.connectFailed(_arg1);
        }
        override public function send(_arg1:MessageAgent, _arg2:IMessage):void{
            var consumerDispatcher:* = null;
            var msg:* = null;
            var agent:* = _arg1;
            var message:* = _arg2;
            var piggyback:* = false;
            if (((((!(pollOutstanding)) && (_piggybackingEnabled))) && (!((message is CommandMessage))))){
                if (_shouldPoll){
                    piggyback = true;
                } else {
                    consumerDispatcher = ConsumerMessageDispatcher.getInstance();
                    if (consumerDispatcher.isChannelUsedForSubscriptions(this)){
                        piggyback = true;
                    };
                };
            };
            if (piggyback){
                internalPoll();
            };
            super.send(agent, message);
            if (piggyback){
                msg = new CommandMessage();
                msg.operation = CommandMessage.POLL_OPERATION;
                if (Log.isDebug()){
                    _log.debug("'{0}' channel sending poll message\n{1}\n", id, msg.toString());
                };
                try {
                    internalSend(new PollCommandMessageResponder(null, msg, this, _log));
                } catch(e:Error) {
                    stopPolling();
                    throw (e);
                };
            };
        }
        protected function getPollSyncMessageResponder(_arg1:MessageAgent, _arg2:CommandMessage):MessageResponder{
            return (null);
        }
        protected function applyPollingSettings(_arg1:XML):void{
            var _local2:XML;
            if (_arg1.properties.length()){
                _local2 = _arg1.properties[0];
                if (_local2["polling-enabled"].length()){
                    internalPollingEnabled = (_local2["polling-enabled"].toString() == "true");
                };
                if (_local2["polling-interval-millis"].length()){
                    internalPollingInterval = parseInt(_local2["polling-interval-millis"].toString());
                } else {
                    if (_local2["polling-interval-seconds"].length()){
                        internalPollingInterval = (parseInt(_local2["polling-interval-seconds"].toString()) * 1000);
                    };
                };
                if (_local2["piggybacking-enabled"].length()){
                    internalPiggybackingEnabled = (_local2["piggybacking-enabled"].toString() == "true");
                };
                if (_local2["login-after-disconnect"].length()){
                    _loginAfterDisconnect = (_local2["login-after-disconnect"].toString() == "true");
                };
            };
        }
        mx_internal function set internalPollingInterval(_arg1:Number):void{
            var _local2:String;
            if (_arg1 == 0){
                _pollingInterval = _arg1;
                if (_timer != null){
                    _timer.stop();
                };
                if (_shouldPoll){
                    startPolling();
                };
            } else {
                if (_arg1 > 0){
                    if (_timer != null){
                        _timer.delay = (_pollingInterval = _arg1);
                        if (((!(timerRunning)) && (_shouldPoll))){
                            startPolling();
                        };
                    };
                } else {
                    _local2 = resourceManager.getString("messaging", "pollingIntervalNonPositive");
                    throw (new ArgumentError(_local2));
                };
            };
        }
        public function poll():void{
            internalPoll();
        }
        protected function set internalPiggybackingEnabled(_arg1:Boolean):void{
            _piggybackingEnabled = _arg1;
        }
        protected function get internalPollingEnabled():Boolean{
            return (_pollingEnabled);
        }
        mx_internal function pollFailed(_arg1:Boolean=false):void{
            internalDisconnect(_arg1);
        }
        mx_internal function stopPolling():void{
            if (Log.isInfo()){
                _log.info("'{0}' channel polling stopped.", id);
            };
            if (_timer != null){
                _timer.stop();
            };
            _pollingRef = -1;
            _shouldPoll = false;
            pollOutstanding = false;
        }
        protected function internalPoll(_arg1:Event=null):void{
            var msg:* = null;
            var event = _arg1;
            if (!pollOutstanding){
                if (Log.isInfo()){
                    _log.info("'{0}' channel requesting queued messages.", id);
                };
                if (timerRunning){
                    _timer.stop();
                };
                msg = new CommandMessage();
                msg.operation = CommandMessage.POLL_OPERATION;
                if (Log.isDebug()){
                    _log.debug("'{0}' channel sending poll message\n{1}\n", id, msg.toString());
                };
                try {
                    internalSend(new PollCommandMessageResponder(null, msg, this, _log));
                    pollOutstanding = true;
                } catch(e:Error) {
                    stopPolling();
                    throw (e);
                };
            } else {
                if (Log.isInfo()){
                    _log.info("'{0}' channel waiting for poll response.", id);
                };
            };
        }
        protected function getDefaultMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder{
            return (super.getMessageResponder(_arg1, _arg2));
        }
        mx_internal function get internalPollingInterval():Number{
            return (((_timer)==null) ? 0 : _pollingInterval);
        }
        protected function startPolling():void{
            if (_pollingEnabled){
                if (Log.isInfo()){
                    _log.info("'{0}' channel polling started.", id);
                };
                _shouldPoll = true;
                poll();
            };
        }
        protected function get internalPiggybackingEnabled():Boolean{
            return (_piggybackingEnabled);
        }
        override mx_internal function get realtime():Boolean{
            return (_pollingEnabled);
        }
        final override protected function getMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder{
            var _local4:CommandMessage;
            var _local3:MessageResponder;
            if ((_arg2 is CommandMessage)){
                _local4 = CommandMessage(_arg2);
                if ((((_local4.operation == CommandMessage.SUBSCRIBE_OPERATION)) || ((_local4.operation == CommandMessage.UNSUBSCRIBE_OPERATION)))){
                    _local3 = getPollSyncMessageResponder(_arg1, _local4);
                } else {
                    if (_local4.operation == CommandMessage.POLL_OPERATION){
                        _local3 = new PollCommandMessageResponder(_arg1, _arg2, this, _log);
                    };
                };
            };
            return ((((_local3 == null)) ? getDefaultMessageResponder(_arg1, _arg2) : _local3));
        }
        override protected function internalDisconnect(_arg1:Boolean=false):void{
            stopPolling();
            super.internalDisconnect(_arg1);
        }
        mx_internal function get timerRunning():Boolean{
            return (((!((_timer == null))) && (_timer.running)));
        }
        public function disablePolling():void{
            _pollingRef--;
            if (_pollingRef < 0){
                stopPolling();
            };
        }
        protected function set internalPollingEnabled(_arg1:Boolean):void{
            _pollingEnabled = _arg1;
            if (((!(_arg1)) && (((timerRunning) || (((!(timerRunning)) && ((_pollingInterval == 0)))))))){
                stopPolling();
            } else {
                if (((((_arg1) && (_shouldPoll))) && (!(timerRunning)))){
                    startPolling();
                };
            };
        }

    }
}//package mx.messaging.channels 

import mx.resources.*;
import mx.messaging.events.*;
import mx.messaging.messages.*;
import mx.messaging.*;
import mx.logging.*;

class PollCommandMessageResponder extends MessageResponder {

    private var _log:ILogger;
    private var resourceManager:IResourceManager;

    public function PollCommandMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:PollingChannel, _arg4:ILogger){
        resourceManager = ResourceManager.getInstance();
        super(_arg1, _arg2, _arg3);
        _log = _arg4;
    }
    override protected function statusHandler(_arg1:IMessage):void{
        var _local2:PollingChannel = PollingChannel(channel);
        _local2.stopPolling();
        var _local3:ErrorMessage = (_arg1 as ErrorMessage);
        var _local4:String = ((_local3)!=null) ? _local3.faultDetail : "";
        var _local5:ChannelFaultEvent = ChannelFaultEvent.createEvent(_local2, false, "Channel.Polling.Error", "error", _local4);
        _local5.rootCause = _arg1;
        _local2.dispatchEvent(_local5);
        if (((!((_local3 == null))) && ((_local3.faultCode == "Server.PollNotSupported")))){
            _local2.pollFailed(true);
        } else {
            _local2.pollFailed(false);
        };
    }
    override protected function resultHandler(_arg1:IMessage):void{
        var messageList:* = null;
        var message:* = null;
        var mpiutil:* = null;
        var errMsg:* = null;
        var adaptivePollWait:* = 0;
        var msg:* = _arg1;
        PollingChannel(channel).pollOutstanding = false;
        if ((msg is CommandMessage)){
            if (msg.headers[CommandMessage.NO_OP_POLL_HEADER] == true){
                return;
            };
            if (msg.body != null){
                messageList = (msg.body as Array);
                for each (message in messageList) {
                    if (Log.isDebug()){
                        _log.debug("'{0}' channel got message\n{1}\n", channel.id, message.toString());
                        if (channel.mpiEnabled){
                            try {
                                mpiutil = new MessagePerformanceUtils(message);
                                _log.debug(mpiutil.prettyPrint());
                            } catch(e:Error) {
                                _log.debug(("Could not get message performance information for: " + msg.toString()));
                            };
                        };
                    };
                    channel.dispatchEvent(MessageEvent.createEvent(MessageEvent.MESSAGE, message));
                };
            };
        } else {
            if ((msg is AcknowledgeMessage)){
            } else {
                errMsg = new ErrorMessage();
                errMsg.faultDetail = resourceManager.getString("messaging", "receivedNull");
                status(errMsg);
                return;
            };
        };
        var pollingChannel:* = PollingChannel(channel);
        if (((pollingChannel.connected) && (pollingChannel._shouldPoll))){
            adaptivePollWait = 0;
            if (msg.headers[CommandMessage.POLL_WAIT_HEADER] != null){
                adaptivePollWait = msg.headers[CommandMessage.POLL_WAIT_HEADER];
            };
            if (adaptivePollWait == 0){
                if (pollingChannel.internalPollingInterval == 0){
                    pollingChannel.poll();
                } else {
                    if (!pollingChannel.timerRunning){
                        pollingChannel._timer.delay = pollingChannel._pollingInterval;
                        pollingChannel._timer.start();
                    };
                };
            } else {
                pollingChannel._timer.delay = adaptivePollWait;
                pollingChannel._timer.start();
            };
        };
    }

}
