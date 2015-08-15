package mx.utils {
    import flash.display.*;

    public class LoaderUtil {

        public static function normalizeURL(_arg1:LoaderInfo):String{
            var _local2:String = _arg1.url;
            var _local3:Array = _local2.split("/[[DYNAMIC]]/");
            return (_local3[0]);
        }
        public static function createAbsoluteURL(_arg1:String, _arg2:String):String{
            var _local4:int;
            var _local5:int;
            var _local3:String = _arg2;
            if (!(((((_arg2.indexOf(":") > -1)) || ((_arg2.indexOf("/") == 0)))) || ((_arg2.indexOf("\\") == 0)))){
                if (_arg1){
                    _local4 = Math.max(_arg1.lastIndexOf("\\"), _arg1.lastIndexOf("/"));
                    if (_local4 <= 8){
                        _arg1 = (_arg1 + "/");
                        _local4 = (_arg1.length - 1);
                    };
                    if (_arg2.indexOf("./") == 0){
                        _arg2 = _arg2.substring(2);
                    } else {
                        while (_arg2.indexOf("../") == 0) {
                            _arg2 = _arg2.substring(3);
                            _local5 = Math.max(_arg1.lastIndexOf("\\", (_local4 - 1)), _arg1.lastIndexOf("/", (_local4 - 1)));
                            if (_local5 <= 8){
                                _local5 = _local4;
                            };
                            _local4 = _local5;
                        };
                    };
                    if (_local4 != -1){
                        _local3 = (_arg1.substr(0, (_local4 + 1)) + _arg2);
                    };
                };
            };
            return (_local3);
        }

    }
}//package mx.utils 
