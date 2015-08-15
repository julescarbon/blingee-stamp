package mx.utils {

    public class ArrayUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function getItemIndex(_arg1:Object, _arg2:Array):int{
            var _local3:int = _arg2.length;
            var _local4:int;
            while (_local4 < _local3) {
                if (_arg2[_local4] === _arg1){
                    return (_local4);
                };
                _local4++;
            };
            return (-1);
        }
        public static function toArray(_arg1:Object):Array{
            if (!_arg1){
                return ([]);
            };
            if ((_arg1 is Array)){
                return ((_arg1 as Array));
            };
            return ([_arg1]);
        }

    }
}//package mx.utils 
