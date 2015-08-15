package mx.messaging.messages {
    import flash.utils.*;

    public class AcknowledgeMessage extends AsyncMessage implements ISmallMessage {

        public static const ERROR_HINT_HEADER:String = "DSErrorHint";

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
        override public function writeExternal(_arg1:IDataOutput):void{
            super.writeExternal(_arg1);
            var _local2:uint;
            _arg1.writeByte(_local2);
        }
        override public function getSmallMessage():IMessage{
            var _local1:Object = this;
            if (_local1.constructor == AcknowledgeMessage){
                return (new AcknowledgeMessageExt(this));
            };
            return (null);
        }

    }
}//package mx.messaging.messages 
