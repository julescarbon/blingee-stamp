package mx.messaging.messages {
    import flash.utils.*;
    import mx.utils.*;

    public class AsyncMessage extends AbstractMessage implements ISmallMessage {

        private static const CORRELATION_ID_FLAG:uint = 1;
        private static const CORRELATION_ID_BYTES_FLAG:uint = 2;
        public static const SUBTOPIC_HEADER:String = "DSSubtopic";

        private var _correlationId:String;
        private var correlationIdBytes:ByteArray;

        public function AsyncMessage(_arg1:Object=null, _arg2:Object=null){
            correlationId = "";
            if (_arg1 != null){
                this.body = _arg1;
            };
            if (_arg2 != null){
                this.headers = _arg2;
            };
        }
        override protected function addDebugAttributes(_arg1:Object):void{
            super.addDebugAttributes(_arg1);
            _arg1["correlationId"] = correlationId;
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
                    if ((_local4 & CORRELATION_ID_FLAG) != 0){
                        correlationId = (_arg1.readObject() as String);
                    };
                    if ((_local4 & CORRELATION_ID_BYTES_FLAG) != 0){
                        correlationIdBytes = (_arg1.readObject() as ByteArray);
                        correlationId = RPCUIDUtil.fromByteArray(correlationIdBytes);
                    };
                    _local5 = 2;
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
        public function getSmallMessage():IMessage{
            var _local1:Object = this;
            if (_local1.constructor == AsyncMessage){
                return (new AsyncMessageExt(this));
            };
            return (null);
        }
        override public function writeExternal(_arg1:IDataOutput):void{
            super.writeExternal(_arg1);
            if (correlationIdBytes == null){
                correlationIdBytes = RPCUIDUtil.toByteArray(_correlationId);
            };
            var _local2:uint;
            if (((!((correlationId == null))) && ((correlationIdBytes == null)))){
                _local2 = (_local2 | CORRELATION_ID_FLAG);
            };
            if (correlationIdBytes != null){
                _local2 = (_local2 | CORRELATION_ID_BYTES_FLAG);
            };
            _arg1.writeByte(_local2);
            if (((!((correlationId == null))) && ((correlationIdBytes == null)))){
                _arg1.writeObject(correlationId);
            };
            if (correlationIdBytes != null){
                _arg1.writeObject(correlationIdBytes);
            };
        }
        public function set correlationId(_arg1:String):void{
            _correlationId = _arg1;
            correlationIdBytes = null;
        }
        public function get correlationId():String{
            return (_correlationId);
        }

    }
}//package mx.messaging.messages 
