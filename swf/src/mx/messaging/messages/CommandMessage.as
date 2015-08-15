package mx.messaging.messages {
    import flash.utils.*;

    public class CommandMessage extends AsyncMessage {

        public static const SUBSCRIBE_OPERATION:uint = 0;
        private static const OPERATION_FLAG:uint = 1;
        public static const CLIENT_SYNC_OPERATION:uint = 4;
        public static const POLL_WAIT_HEADER:String = "DSPollWait";
        public static const ADD_SUBSCRIPTIONS:String = "DSAddSub";
        public static const SUBSCRIPTION_INVALIDATE_OPERATION:uint = 10;
        public static const TRIGGER_CONNECT_OPERATION:uint = 13;
        public static const CLIENT_PING_OPERATION:uint = 5;
        public static const UNSUBSCRIBE_OPERATION:uint = 1;
        public static const CREDENTIALS_CHARSET_HEADER:String = "DSCredentialsCharset";
        public static const AUTHENTICATION_MESSAGE_REF_TYPE:String = "flex.messaging.messages.AuthenticationMessage";
        public static const POLL_OPERATION:uint = 2;
        public static const MULTI_SUBSCRIBE_OPERATION:uint = 11;
        public static const LOGIN_OPERATION:uint = 8;
        public static const CLUSTER_REQUEST_OPERATION:uint = 7;
        public static const LOGOUT_OPERATION:uint = 9;
        public static const REMOVE_SUBSCRIPTIONS:String = "DSRemSub";
        public static const MESSAGING_VERSION:String = "DSMessagingVersion";
        public static const NEEDS_CONFIG_HEADER:String = "DSNeedsConfig";
        public static const SELECTOR_HEADER:String = "DSSelector";
        public static const UNKNOWN_OPERATION:uint = 10000;
        public static const PRESERVE_DURABLE_HEADER:String = "DSPreserveDurable";
        public static const NO_OP_POLL_HEADER:String = "DSNoOpPoll";
        public static const SUBTOPIC_SEPARATOR:String = "_;_";
        public static const DISCONNECT_OPERATION:uint = 12;

        private static var operationTexts:Object = null;

        public var operation:uint;

        public function CommandMessage(){
            operation = UNKNOWN_OPERATION;
        }
        public static function getOperationAsString(_arg1:uint):String{
            if (operationTexts == null){
                operationTexts = {};
                operationTexts[SUBSCRIBE_OPERATION] = "subscribe";
                operationTexts[UNSUBSCRIBE_OPERATION] = "unsubscribe";
                operationTexts[POLL_OPERATION] = "poll";
                operationTexts[CLIENT_SYNC_OPERATION] = "client sync";
                operationTexts[CLIENT_PING_OPERATION] = "client ping";
                operationTexts[CLUSTER_REQUEST_OPERATION] = "cluster request";
                operationTexts[LOGIN_OPERATION] = "login";
                operationTexts[LOGOUT_OPERATION] = "logout";
                operationTexts[SUBSCRIPTION_INVALIDATE_OPERATION] = "subscription invalidate";
                operationTexts[MULTI_SUBSCRIBE_OPERATION] = "multi-subscribe";
                operationTexts[DISCONNECT_OPERATION] = "disconnect";
                operationTexts[TRIGGER_CONNECT_OPERATION] = "trigger connect";
                operationTexts[UNKNOWN_OPERATION] = "unknown";
            };
            var _local2:* = operationTexts[_arg1];
            return ((((_local2 == undefined)) ? _arg1.toString() : String(_local2)));
        }

        override public function readExternal(_arg1:IDataInput):void{
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            super.readExternal(_arg1);
            var _local2:Array = readFlags(_arg1);
            var _local3:uint;
            while (_local3 < _local2.length) {
                _local4 = (_local2[_local3] as uint);
                _local5 = 0;
                if (_local3 == 0){
                    if ((_local4 & OPERATION_FLAG) != 0){
                        operation = (_arg1.readObject() as uint);
                    };
                    _local5 = 1;
                };
                if ((_local4 >> _local5) != 0){
                    _local6 = _local5;
                    while (_local6 < 6) {
                        if (((_local4 >> _local6) & 1) != 0){
                            _arg1.readObject();
                        };
                        _local6++;
                    };
                };
                _local3++;
            };
        }
        override protected function addDebugAttributes(_arg1:Object):void{
            super.addDebugAttributes(_arg1);
            _arg1["operation"] = getOperationAsString(operation);
        }
        override public function writeExternal(_arg1:IDataOutput):void{
            super.writeExternal(_arg1);
            var _local2:uint;
            if (operation != 0){
                _local2 = (_local2 | OPERATION_FLAG);
            };
            _arg1.writeByte(_local2);
            if (operation != 0){
                _arg1.writeObject(operation);
            };
        }
        override public function toString():String{
            return (getDebugString());
        }
        override public function getSmallMessage():IMessage{
            if (operation == POLL_OPERATION){
                return (new CommandMessageExt(this));
            };
            return (null);
        }

    }
}//package mx.messaging.messages 
