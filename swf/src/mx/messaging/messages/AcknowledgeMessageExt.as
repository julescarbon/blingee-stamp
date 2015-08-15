package mx.messaging.messages {
    import flash.utils.*;

    public class AcknowledgeMessageExt extends AcknowledgeMessage implements IExternalizable {

        private var _message:AcknowledgeMessage;

        public function AcknowledgeMessageExt(_arg1:AcknowledgeMessage=null){
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
