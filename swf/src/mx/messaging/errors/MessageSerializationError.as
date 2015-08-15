package mx.messaging.errors {
    import mx.messaging.messages.*;

    public class MessageSerializationError extends MessagingError {

        public var fault:ErrorMessage;

        public function MessageSerializationError(_arg1:String, _arg2:ErrorMessage){
            super(_arg1);
            this.fault = _arg2;
        }
    }
}//package mx.messaging.errors 
