package mx.messaging.config {
    import mx.core.*;

    public class LoaderConfig {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var _url:String = null;
        mx_internal static var _parameters:Object;

        public static function get url():String{
            return (_url);
        }
        public static function get parameters():Object{
            return (_parameters);
        }

    }
}//package mx.messaging.config 
