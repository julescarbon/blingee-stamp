package mx.messaging {
    import mx.messaging.events.*;
    import flash.utils.*;
    import mx.logging.*;

    public class ConsumerMessageDispatcher {

        private static var _instance:ConsumerMessageDispatcher;

        private const _consumerDuplicateMessageBarrier:Object;
        private const _channelSetRefCounts:Dictionary;
        private const _consumers:Object;

        public function ConsumerMessageDispatcher(){
            _consumers = {};
            _channelSetRefCounts = new Dictionary();
            _consumerDuplicateMessageBarrier = {};
            super();
        }
        public static function getInstance():ConsumerMessageDispatcher{
            if (!_instance){
                _instance = new (ConsumerMessageDispatcher)();
            };
            return (_instance);
        }

        public function registerSubscription(_arg1:AbstractConsumer):void{
            _consumers[_arg1.clientId] = _arg1;
            if (_channelSetRefCounts[_arg1.channelSet] == null){
                _arg1.channelSet.addEventListener(MessageEvent.MESSAGE, messageHandler);
                _channelSetRefCounts[_arg1.channelSet] = 1;
            } else {
                var _local2 = _channelSetRefCounts;
                var _local3 = _arg1.channelSet;
                var _local4 = (_local2[_local3] + 1);
                _local2[_local3] = _local4;
            };
        }
        private function messageHandler(_arg1:MessageEvent):void{
            var _local3:String;
            var _local4:String;
            var _local2:AbstractConsumer = _consumers[_arg1.message.clientId];
            if (_local2 == null){
                if (Log.isDebug()){
                    Log.getLogger("mx.messaging.Consumer").debug("'{0}' received pushed message for consumer but no longer subscribed: {1}", _arg1.message.clientId, _arg1.message);
                };
                return;
            };
            if (_arg1.target.currentChannel.channelSets.length > 1){
                _local3 = _local2.id;
                if (_consumerDuplicateMessageBarrier[_local3] == null){
                    _consumerDuplicateMessageBarrier[_local3] = {};
                };
                _local4 = _arg1.target.currentChannel.id;
                if (_consumerDuplicateMessageBarrier[_local3][_local4] != _arg1.messageId){
                    _consumerDuplicateMessageBarrier[_local3][_local4] = _arg1.messageId;
                    _local2.messageHandler(_arg1);
                };
            } else {
                _local2.messageHandler(_arg1);
            };
        }
        public function unregisterSubscription(_arg1:AbstractConsumer):void{
            delete _consumers[_arg1.clientId];
            var _local2:int = _channelSetRefCounts[_arg1.channelSet];
            --_local2;
            if (_local2 == 0){
                _arg1.channelSet.removeEventListener(MessageEvent.MESSAGE, messageHandler);
                _channelSetRefCounts[_arg1.channelSet] = null;
                if (_consumerDuplicateMessageBarrier[_arg1.id] != null){
                    delete _consumerDuplicateMessageBarrier[_arg1.id];
                };
            } else {
                _channelSetRefCounts[_arg1.channelSet] = _local2;
            };
        }
        public function isChannelUsedForSubscriptions(_arg1:Channel):Boolean{
            var _local2:Array = _arg1.channelSets;
            var _local3:ChannelSet;
            var _local4:int = _local2.length;
            var _local5:int;
            while (_local5 < _local4) {
                _local3 = _local2[_local5];
                if (((!((_channelSetRefCounts[_local3] == null))) && ((_local3.currentChannel == _arg1)))){
                    return (true);
                };
                _local5++;
            };
            return (false);
        }

    }
}//package mx.messaging 
