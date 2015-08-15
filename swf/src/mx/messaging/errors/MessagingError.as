package mx.messaging.errors {

    public class MessagingError extends Error {

        public function MessagingError(_arg1:String){
            super(_arg1);
        }
        public function toString():String{
            var _local1 = "[MessagingError";
            if (message != null){
                _local1 = (_local1 + ((" message='" + message) + "']"));
            } else {
                _local1 = (_local1 + "]");
            };
            return (_local1);
        }

    }
}//package mx.messaging.errors 
