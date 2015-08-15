package mx.utils {
    import mx.messaging.config.*;

    public class URLUtil {

        public static const SERVER_NAME_TOKEN:String = "{server.name}";
        private static const SERVER_PORT_REGEX:RegExp = new RegExp("\\{server.port\\}", "g");
        private static const SERVER_NAME_REGEX:RegExp = new RegExp("\\{server.name\\}", "g");
        public static const SERVER_PORT_TOKEN:String = "{server.port}";

        public static function hasUnresolvableTokens():Boolean{
            return (!((LoaderConfig.url == null)));
        }
        public static function getServerName(_arg1:String):String{
            var _local2:String = getServerNameWithPort(_arg1);
            var _local3:int = _local2.indexOf("]");
            _local3 = ((_local3)>-1) ? _local2.indexOf(":", _local3) : _local2.indexOf(":");
            if (_local3 > 0){
                _local2 = _local2.substring(0, _local3);
            };
            return (_local2);
        }
        public static function isHttpsURL(_arg1:String):Boolean{
            return (((!((_arg1 == null))) && ((_arg1.indexOf("https://") == 0))));
        }
        private static function internalObjectToString(_arg1:Object, _arg2:String, _arg3:String, _arg4:Boolean):String{
            var _local7:String;
            var _local8:Object;
            var _local9:String;
            var _local5 = "";
            var _local6:Boolean;
            for (_local7 in _arg1) {
                if (_local6){
                    _local6 = false;
                } else {
                    _local5 = (_local5 + _arg2);
                };
                _local8 = _arg1[_local7];
                _local9 = ((_arg3) ? ((_arg3 + ".") + _local7) : _local7);
                if (_arg4){
                    _local9 = encodeURIComponent(_local9);
                };
                if ((_local8 is String)){
                    _local5 = (_local5 + ((_local9 + "=") + ((_arg4) ? encodeURIComponent((_local8 as String)) : _local8)));
                } else {
                    if ((_local8 is Number)){
                        _local8 = _local8.toString();
                        if (_arg4){
                            _local8 = encodeURIComponent((_local8 as String));
                        };
                        _local5 = (_local5 + ((_local9 + "=") + _local8));
                    } else {
                        if ((_local8 is Boolean)){
                            _local5 = (_local5 + ((_local9 + "=") + ((_local8) ? "true" : "false")));
                        } else {
                            if ((_local8 is Array)){
                                _local5 = (_local5 + internalArrayToString((_local8 as Array), _arg2, _local9, _arg4));
                            } else {
                                _local5 = (_local5 + internalObjectToString(_local8, _arg2, _local9, _arg4));
                            };
                        };
                    };
                };
            };
            return (_local5);
        }
        public static function getFullURL(_arg1:String, _arg2:String):String{
            var _local3:Number;
            if (((!((_arg2 == null))) && (!(URLUtil.isHttpURL(_arg2))))){
                if (_arg2.indexOf("./") == 0){
                    _arg2 = _arg2.substring(2);
                };
                if (URLUtil.isHttpURL(_arg1)){
                    if (_arg2.charAt(0) == "/"){
                        _local3 = _arg1.indexOf("/", 8);
                        if (_local3 == -1){
                            _local3 = _arg1.length;
                        };
                    } else {
                        _local3 = (_arg1.lastIndexOf("/") + 1);
                        if (_local3 <= 8){
                            _arg1 = (_arg1 + "/");
                            _local3 = _arg1.length;
                        };
                    };
                    if (_local3 > 0){
                        _arg2 = (_arg1.substring(0, _local3) + _arg2);
                    };
                };
            };
            return (_arg2);
        }
        public static function getServerNameWithPort(_arg1:String):String{
            var _local2:int = (_arg1.indexOf("/") + 2);
            var _local3:int = _arg1.indexOf("/", _local2);
            return ((((_local3 == -1)) ? _arg1.substring(_local2) : _arg1.substring(_local2, _local3)));
        }
        public static function replaceProtocol(_arg1:String, _arg2:String):String{
            return (_arg1.replace(getProtocol(_arg1), _arg2));
        }
        public static function urisEqual(_arg1:String, _arg2:String):Boolean{
            if (((!((_arg1 == null))) && (!((_arg2 == null))))){
                _arg1 = StringUtil.trim(_arg1).toLowerCase();
                _arg2 = StringUtil.trim(_arg2).toLowerCase();
                if (_arg1.charAt((_arg1.length - 1)) != "/"){
                    _arg1 = (_arg1 + "/");
                };
                if (_arg2.charAt((_arg2.length - 1)) != "/"){
                    _arg2 = (_arg2 + "/");
                };
            };
            return ((_arg1 == _arg2));
        }
        public static function getProtocol(_arg1:String):String{
            var _local2:int = _arg1.indexOf("/");
            var _local3:int = _arg1.indexOf(":/");
            if ((((_local3 > -1)) && ((_local3 < _local2)))){
                return (_arg1.substring(0, _local3));
            };
            _local3 = _arg1.indexOf("::");
            if ((((_local3 > -1)) && ((_local3 < _local2)))){
                return (_arg1.substring(0, _local3));
            };
            return ("");
        }
        private static function internalArrayToString(_arg1:Array, _arg2:String, _arg3:String, _arg4:Boolean):String{
            var _local9:Object;
            var _local10:String;
            var _local5 = "";
            var _local6:Boolean;
            var _local7:int = _arg1.length;
            var _local8:int;
            while (_local8 < _local7) {
                if (_local6){
                    _local6 = false;
                } else {
                    _local5 = (_local5 + _arg2);
                };
                _local9 = _arg1[_local8];
                _local10 = ((_arg3 + ".") + _local8);
                if (_arg4){
                    _local10 = encodeURIComponent(_local10);
                };
                if ((_local9 is String)){
                    _local5 = (_local5 + ((_local10 + "=") + ((_arg4) ? encodeURIComponent((_local9 as String)) : _local9)));
                } else {
                    if ((_local9 is Number)){
                        _local9 = _local9.toString();
                        if (_arg4){
                            _local9 = encodeURIComponent((_local9 as String));
                        };
                        _local5 = (_local5 + ((_local10 + "=") + _local9));
                    } else {
                        if ((_local9 is Boolean)){
                            _local5 = (_local5 + ((_local10 + "=") + ((_local9) ? "true" : "false")));
                        } else {
                            if ((_local9 is Array)){
                                _local5 = (_local5 + internalArrayToString((_local9 as Array), _arg2, _local10, _arg4));
                            } else {
                                _local5 = (_local5 + internalObjectToString(_local9, _arg2, _local10, _arg4));
                            };
                        };
                    };
                };
                _local8++;
            };
            return (_local5);
        }
        public static function objectToString(_arg1:Object, _arg2:String=";", _arg3:Boolean=true):String{
            var _local4:String = internalObjectToString(_arg1, _arg2, null, _arg3);
            return (_local4);
        }
        public static function replaceTokens(_arg1:String):String{
            var _local4:String;
            var _local5:String;
            var _local6:uint;
            var _local2:String = (((LoaderConfig.url == null)) ? "" : LoaderConfig.url);
            if (_arg1.indexOf(SERVER_NAME_TOKEN) > 0){
                _local4 = URLUtil.getProtocol(_local2);
                _local5 = "localhost";
                if (_local4.toLowerCase() != "file"){
                    _local5 = URLUtil.getServerName(_local2);
                };
                _arg1 = _arg1.replace(SERVER_NAME_REGEX, _local5);
            };
            var _local3:int = _arg1.indexOf(SERVER_PORT_TOKEN);
            if (_local3 > 0){
                _local6 = URLUtil.getPort(_local2);
                if (_local6 > 0){
                    _arg1 = _arg1.replace(SERVER_PORT_REGEX, _local6);
                } else {
                    if (_arg1.charAt((_local3 - 1)) == ":"){
                        _arg1 = (_arg1.substring(0, (_local3 - 1)) + _arg1.substring(_local3));
                    };
                    _arg1 = _arg1.replace(SERVER_PORT_REGEX, "");
                };
            };
            return (_arg1);
        }
        public static function getPort(_arg1:String):uint{
            var _local5:Number;
            var _local2:String = getServerNameWithPort(_arg1);
            var _local3:int = _local2.indexOf("]");
            _local3 = ((_local3)>-1) ? _local2.indexOf(":", _local3) : _local2.indexOf(":");
            var _local4:uint;
            if (_local3 > 0){
                _local5 = Number(_local2.substring((_local3 + 1)));
                if (!isNaN(_local5)){
                    _local4 = int(_local5);
                };
            };
            return (_local4);
        }
        public static function stringToObject(_arg1:String, _arg2:String=";", _arg3:Boolean=true):Object{
            var _local8:Array;
            var _local9:String;
            var _local10:Object;
            var _local11:Object;
            var _local12:int;
            var _local13:int;
            var _local14:Object;
            var _local15:String;
            var _local16:String;
            var _local17:Object;
            var _local4:Object = {};
            var _local5:Array = _arg1.split(_arg2);
            var _local6:int = _local5.length;
            var _local7:int;
            while (_local7 < _local6) {
                _local8 = _local5[_local7].split("=");
                _local9 = _local8[0];
                if (_arg3){
                    _local9 = decodeURIComponent(_local9);
                };
                _local10 = _local8[1];
                if (_arg3){
                    _local10 = decodeURIComponent((_local10 as String));
                };
                if (_local10 == "true"){
                    _local10 = true;
                } else {
                    if (_local10 == "false"){
                        _local10 = false;
                    } else {
                        _local14 = int(_local10);
                        if (_local14.toString() == _local10){
                            _local10 = _local14;
                        } else {
                            _local14 = Number(_local10);
                            if (_local14.toString() == _local10){
                                _local10 = _local14;
                            };
                        };
                    };
                };
                _local11 = _local4;
                _local8 = _local9.split(".");
                _local12 = _local8.length;
                _local13 = 0;
                while (_local13 < (_local12 - 1)) {
                    _local15 = _local8[_local13];
                    if ((((_local11[_local15] == null)) && ((_local13 < (_local12 - 1))))){
                        _local16 = _local8[(_local13 + 1)];
                        _local17 = int(_local16);
                        if (_local17.toString() == _local16){
                            _local11[_local15] = [];
                        } else {
                            _local11[_local15] = {};
                        };
                    };
                    _local11 = _local11[_local15];
                    _local13++;
                };
                _local11[_local8[_local13]] = _local10;
                _local7++;
            };
            return (_local4);
        }
        public static function replacePort(_arg1:String, _arg2:uint):String{
            var _local6:int;
            var _local3 = "";
            var _local4:int = _arg1.indexOf("]");
            if (_local4 == -1){
                _local4 = _arg1.indexOf(":");
            };
            var _local5:int = _arg1.indexOf(":", (_local4 + 1));
            if (_local5 > -1){
                _local5++;
                _local6 = _arg1.indexOf("/", _local5);
                _local3 = ((_arg1.substring(0, _local5) + _arg2.toString()) + _arg1.substring(_local6, _arg1.length));
            } else {
                _local6 = _arg1.indexOf("/", _local4);
                if (_local6 > -1){
                    if (_arg1.charAt((_local6 + 1)) == "/"){
                        _local6 = _arg1.indexOf("/", (_local6 + 2));
                    };
                    if (_local6 > 0){
                        _local3 = (((_arg1.substring(0, _local6) + ":") + _arg2.toString()) + _arg1.substring(_local6, _arg1.length));
                    } else {
                        _local3 = ((_arg1 + ":") + _arg2.toString());
                    };
                } else {
                    _local3 = ((_arg1 + ":") + _arg2.toString());
                };
            };
            return (_local3);
        }
        public static function isHttpURL(_arg1:String):Boolean{
            return (((!((_arg1 == null))) && ((((_arg1.indexOf("http://") == 0)) || ((_arg1.indexOf("https://") == 0))))));
        }

    }
}//package mx.utils 
