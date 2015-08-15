package mx.messaging.messages {
    import flash.utils.*;

    public class AsyncMessageExt extends AsyncMessage implements IExternalizable {

        private var _message:AsyncMessage;

        public function AsyncMessageExt(_arg1:AsyncMessage=null){
            _message = _arg1;
        }
        override public function get messageId():String{
            if (_message != null){
                return (_message.messageId);
            };
            return (super.messageId);
        }
        override public function writeExternal(_arg1:IDataOutput):void{
            if (_message != null){
                _message.writeExternal(_arg1);
            } else {
                super.writeExternal(_arg1);
            };
        }

    }
}//package mx.messaging.messages 
