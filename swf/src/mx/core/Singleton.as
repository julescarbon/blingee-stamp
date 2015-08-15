package mx.core {

    public class Singleton {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var classMap:Object = {};

        public static function registerClass(_arg1:String, _arg2:Class):void{
            var _local3:Class = classMap[_arg1];
            if (!_local3){
                classMap[_arg1] = _arg2;
            };
        }
        public static function getClass(_arg1:String):Class{
            return (classMap[_arg1]);
        }
        public static function getInstance(_arg1:String):Object{
            var _local2:Class = classMap[_arg1];
            if (!_local2){
                throw (new Error((("No class registered for interface '" + _arg1) + "'.")));
            };
            return (_local2["getInstance"]());
        }

    }
}//package mx.core 
