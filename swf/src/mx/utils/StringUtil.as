package mx.utils {
    import mx.core.*;

    public class StringUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function trim(_arg1:String):String{
            if (_arg1 == null){
                return ("");
            };
            var _local2:int;
            while (isWhitespace(_arg1.charAt(_local2))) {
                _local2++;
            };
            var _local3:int = (_arg1.length - 1);
            while (isWhitespace(_arg1.charAt(_local3))) {
                _local3--;
            };
            if (_local3 >= _local2){
                return (_arg1.slice(_local2, (_local3 + 1)));
            };
            return ("");
        }
        public static function isWhitespace(_arg1:String):Boolean{
            switch (_arg1){
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    return (true);
                default:
                    return (false);
            };
        }
        public static function substitute(_arg1:String, ... _args):String{
            var _local4:Array;
            if (_arg1 == null){
                return ("");
            };
            var _local3:uint = _args.length;
            if ((((_local3 == 1)) && ((_args[0] is Array)))){
                _local4 = (_args[0] as Array);
                _local3 = _local4.length;
            } else {
                _local4 = _args;
            };
            var _local5:int;
            while (_local5 < _local3) {
                _arg1 = _arg1.replace(new RegExp((("\\{" + _local5) + "\\}"), "g"), _local4[_local5]);
                _local5++;
            };
            return (_arg1);
        }
        public static function trimArrayElements(_arg1:String, _arg2:String):String{
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            if (((!((_arg1 == ""))) && (!((_arg1 == null))))){
                _local3 = _arg1.split(_arg2);
                _local4 = _local3.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    _local3[_local5] = StringUtil.trim(_local3[_local5]);
                    _local5++;
                };
                if (_local4 > 0){
                    _arg1 = _local3.join(_arg2);
                };
            };
            return (_arg1);
        }

    }
}//package mx.utils 
