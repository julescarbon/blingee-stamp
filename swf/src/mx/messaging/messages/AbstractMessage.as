package mx.messaging.messages {
    import flash.utils.*;
    import mx.utils.*;

    public class AbstractMessage implements IMessage {

        public static const FLEX_CLIENT_ID_HEADER:String = "DSId";
        private static const MESSAGE_ID_FLAG:uint = 16;
        private static const TIME_TO_LIVE_FLAG:uint = 64;
        private static const CLIENT_ID_BYTES_FLAG:uint = 1;
        private static const TIMESTAMP_FLAG:uint = 32;
        public static const REQUEST_TIMEOUT_HEADER:String = "DSRequestTimeout";
        private static const DESTINATION_FLAG:uint = 4;
        public static const STATUS_CODE_HEADER:String = "DSStatusCode";
        private static const CLIENT_ID_FLAG:uint = 2;
        private static const HEADERS_FLAG:uint = 8;
        public static const REMOTE_CREDENTIALS_HEADER:String = "DSRemoteCredentials";
        public static const REMOTE_CREDENTIALS_CHARSET_HEADER:String = "DSRemoteCredentialsCharset";
        private static const MESSAGE_ID_BYTES_FLAG:uint = 2;
        public static const DESTINATION_CLIENT_ID_HEADER:String = "DSDstClientId";
        private static const BODY_FLAG:uint = 1;
        private static const HAS_NEXT_FLAG:uint = 128;
        public static const ENDPOINT_HEADER:String = "DSEndpoint";

        private var _body:Object;
        private var _messageId:String;
        private var messageIdBytes:ByteArray;
        private var _timestamp:Number = 0;
        private var _clientId:String;
        private var clientIdBytes:ByteArray;
        private var _headers:Object;
        private var _destination:String = "";
        private var _timeToLive:Number = 0;

        public function AbstractMessage(){
            _body = {};
            super();
        }
        public function set messageId(_arg1:String):void{
            _messageId = _arg1;
            messageIdBytes = null;
        }
        public function get headers():Object{
            if (_headers == null){
                _headers = {};
            };
            return (_headers);
        }
        public function readExternal(_arg1:IDataInput):void{
            var _local4:uint;
            var _local5:uint;
            var _local6:uint;
            var _local2:Array = readFlags(_arg1);
            var _local3:uint;
            while (_local3 < _local2.length) {
                _local4 = (_local2[_local3] as uint);
                _local5 = 0;
                if (_local3 == 0){
                    if ((_local4 & BODY_FLAG) != 0){
                        body = _arg1.readObject();
                    } else {
                        body = null;
                    };
                    if ((_local4 & CLIENT_ID_FLAG) != 0){
                        clientId = _arg1.readObject();
                    };
                    if ((_local4 & DESTINATION_FLAG) != 0){
                        destination = (_arg1.readObject() as String);
                    };
                    if ((_local4 & HEADERS_FLAG) != 0){
                        headers = _arg1.readObject();
                    };
                    if ((_local4 & MESSAGE_ID_FLAG) != 0){
                        messageId = (_arg1.readObject() as String);
                    };
                    if ((_local4 & TIMESTAMP_FLAG) != 0){
                        timestamp = (_arg1.readObject() as Number);
                    };
                    if ((_local4 & TIME_TO_LIVE_FLAG) != 0){
                        timeToLive = (_arg1.readObject() as Number);
                    };
                    _local5 = 7;
                } else {
                    if (_local3 == 1){
                        if ((_local4 & CLIENT_ID_BYTES_FLAG) != 0){
                            clientIdBytes = (_arg1.readObject() as ByteArray);
                            clientId = RPCUIDUtil.fromByteArray(clientIdBytes);
                        };
                        if ((_local4 & MESSAGE_ID_BYTES_FLAG) != 0){
                            messageIdBytes = (_arg1.readObject() as ByteArray);
                            messageId = RPCUIDUtil.fromByteArray(messageIdBytes);
                        };
                        _local5 = 2;
                    };
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
        public function get messageId():String{
            if (_messageId == null){
                _messageId = RPCUIDUtil.createUID();
            };
            return (_messageId);
        }
        public function set clientId(_arg1:String):void{
            _clientId = _arg1;
            clientIdBytes = null;
        }
        public function get destination():String{
            return (_destination);
        }
        public function get timestamp():Number{
            return (_timestamp);
        }
        protected function readFlags(_arg1:IDataInput):Array{
            var _local4:uint;
            var _local2:Boolean;
            var _local3:Array = [];
            while (((_local2) && ((_arg1.bytesAvailable > 0)))) {
                _local4 = _arg1.readUnsignedByte();
                _local3.push(_local4);
                if ((_local4 & HAS_NEXT_FLAG) != 0){
                    _local2 = true;
                } else {
                    _local2 = false;
                };
            };
            return (_local3);
        }
        public function set headers(_arg1:Object):void{
            _headers = _arg1;
        }
        public function get body():Object{
            return (_body);
        }
        public function set destination(_arg1:String):void{
            _destination = _arg1;
        }
        public function set timestamp(_arg1:Number):void{
            _timestamp = _arg1;
        }
        protected function addDebugAttributes(_arg1:Object):void{
            _arg1["body"] = body;
            _arg1["clientId"] = clientId;
            _arg1["destination"] = destination;
            _arg1["headers"] = headers;
            _arg1["messageId"] = messageId;
            _arg1["timestamp"] = timestamp;
            _arg1["timeToLive"] = timeToLive;
        }
        public function get timeToLive():Number{
            return (_timeToLive);
        }
        public function set body(_arg1:Object):void{
            _body = _arg1;
        }
        public function get clientId():String{
            return (_clientId);
        }
        public function writeExternal(_arg1:IDataOutput):void{
            var _local2:uint;
            var _local3:String = messageId;
            if (clientIdBytes == null){
                clientIdBytes = RPCUIDUtil.toByteArray(_clientId);
            };
            if (messageIdBytes == null){
                messageIdBytes = RPCUIDUtil.toByteArray(_messageId);
            };
            if (body != null){
                _local2 = (_local2 | BODY_FLAG);
            };
            if (((!((clientId == null))) && ((clientIdBytes == null)))){
                _local2 = (_local2 | CLIENT_ID_FLAG);
            };
            if (destination != null){
                _local2 = (_local2 | DESTINATION_FLAG);
            };
            if (headers != null){
                _local2 = (_local2 | HEADERS_FLAG);
            };
            if (((!((messageId == null))) && ((messageIdBytes == null)))){
                _local2 = (_local2 | MESSAGE_ID_FLAG);
            };
            if (timestamp != 0){
                _local2 = (_local2 | TIMESTAMP_FLAG);
            };
            if (timeToLive != 0){
                _local2 = (_local2 | TIME_TO_LIVE_FLAG);
            };
            if (((!((clientIdBytes == null))) || (!((messageIdBytes == null))))){
                _local2 = (_local2 | HAS_NEXT_FLAG);
            };
            _arg1.writeByte(_local2);
            _local2 = 0;
            if (clientIdBytes != null){
                _local2 = (_local2 | CLIENT_ID_BYTES_FLAG);
            };
            if (messageIdBytes != null){
                _local2 = (_local2 | MESSAGE_ID_BYTES_FLAG);
            };
            if (_local2 != 0){
                _arg1.writeByte(_local2);
            };
            if (body != null){
                _arg1.writeObject(body);
            };
            if (((!((clientId == null))) && ((clientIdBytes == null)))){
                _arg1.writeObject(clientId);
            };
            if (destination != null){
                _arg1.writeObject(destination);
            };
            if (headers != null){
                _arg1.writeObject(headers);
            };
            if (((!((messageId == null))) && ((messageIdBytes == null)))){
                _arg1.writeObject(messageId);
            };
            if (timestamp != 0){
                _arg1.writeObject(timestamp);
            };
            if (timeToLive != 0){
                _arg1.writeObject(timeToLive);
            };
            if (clientIdBytes != null){
                _arg1.writeObject(clientIdBytes);
            };
            if (messageIdBytes != null){
                _arg1.writeObject(messageIdBytes);
            };
        }
        final protected function getDebugString():String{
            var _local4:String;
            var _local5:uint;
            var _local6:String;
            var _local7:String;
            var _local1 = (("(" + getQualifiedClassName(this)) + ")");
            var _local2:Object = {};
            addDebugAttributes(_local2);
            var _local3:Array = [];
            for (_local4 in _local2) {
                _local3.push(_local4);
            };
            _local3.sort();
            _local5 = 0;
            while (_local5 < _local3.length) {
                _local6 = String(_local3[_local5]);
                _local7 = RPCObjectUtil.toString(_local2[_local6]);
                _local1 = (_local1 + RPCStringUtil.substitute("\n  {0}={1}", _local6, _local7));
                _local5++;
            };
            return (_local1);
        }
        public function toString():String{
            return (RPCObjectUtil.toString(this));
        }
        public function set timeToLive(_arg1:Number):void{
            _timeToLive = _arg1;
        }

    }
}//package mx.messaging.messages 
