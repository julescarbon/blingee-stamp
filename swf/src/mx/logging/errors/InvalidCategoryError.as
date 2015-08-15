package mx.logging.errors {

    public class InvalidCategoryError extends Error {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function InvalidCategoryError(_arg1:String){
            super(_arg1);
        }
        public function toString():String{
            return (String(message));
        }

    }
}//package mx.logging.errors 
