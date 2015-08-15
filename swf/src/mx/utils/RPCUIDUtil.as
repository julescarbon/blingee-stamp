package mx.utils {
    import flash.utils.*;

    public class RPCUIDUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const ALPHA_CHAR_CODES:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

        public static function createUID():String{
            var _local3:int;
            var _local4:int;
            var _local1:Array = new Array(36);
            var _local2:int;
            _local3 = 0;
            while (_local3 < 8) {
                var _temp1 = _local2;
                _local2 = (_local2 + 1);
                var _local7 = _temp1;
                _local1[_local7] = ALPHA_CHAR_CODES[Math.floor((Math.random() * 16))];
                _local3++;
            };
            _local3 = 0;
            while (_local3 < 3) {
                var _temp2 = _local2;
                _local2 = (_local2 + 1);
                _local7 = _temp2;
                _local1[_local7] = 45;
                _local4 = 0;
                while (_local4 < 4) {
                    var _temp3 = _local2;
                    _local2 = (_local2 + 1);
                    var _local8 = _temp3;
                    _local1[_local8] = ALPHA_CHAR_CODES[Math.floor((Math.random() * 16))];
                    _local4++;
                };
                _local3++;
            };
            var _temp4 = _local2;
            _local2 = (_local2 + 1);
            _local7 = _temp4;
            _local1[_local7] = 45;
            var _local5:Number = new Date().getTime();
            var _local6:String = ("0000000" + _local5.toString(16).toUpperCase()).substr(-8);
            _local3 = 0;
            while (_local3 < 8) {
                var _temp5 = _local2;
                _local2 = (_local2 + 1);
                _local8 = _temp5;
                _local1[_local8] = _local6.charCodeAt(_local3);
                _local3++;
            };
            _local3 = 0;
            while (_local3 < 4) {
                var _temp6 = _local2;
                _local2 = (_local2 + 1);
                _local8 = _temp6;
                _local1[_local8] = ALPHA_CHAR_CODES[Math.floor((Math.random() * 16))];
                _local3++;
            };
            return (String.fromCharCode.apply(null, _local1));
        }
        public static function isUID(_arg1:String):Boolean{
            var _local2:uint;
            var _local3:Number;
            if (((!((_arg1 == null))) && ((_arg1.length == 36)))){
                _local2 = 0;
                while (_local2 < 36) {
                    _local3 = _arg1.charCodeAt(_local2);
                    if ((((((((_local2 == 8)) || ((_local2 == 13)))) || ((_local2 == 18)))) || ((_local2 == 23)))){
                        if (_local3 != 45){
                            return (false);
                        };
                    } else {
                        if ((((((_local3 < 48)) || ((_local3 > 70)))) || ((((_local3 > 57)) && ((_local3 < 65)))))){
                            return (false);
                        };
                    };
                    _local2++;
                };
                return (true);
            };
            return (false);
        }
        public static function fromByteArray(_arg1:ByteArray):String{
            var _local2:Array;
            var _local3:uint;
            var _local4:uint;
            var _local5:int;
            if (((((!((_arg1 == null))) && ((_arg1.length >= 16)))) && ((_arg1.bytesAvailable >= 16)))){
                _local2 = new Array(36);
                _local3 = 0;
                _local4 = 0;
                while (_local4 < 16) {
                    if ((((((((_local4 == 4)) || ((_local4 == 6)))) || ((_local4 == 8)))) || ((_local4 == 10)))){
                        var _temp1 = _local3;
                        _local3 = (_local3 + 1);
                        var _local6 = _temp1;
                        _local2[_local6] = 45;
                    };
                    _local5 = _arg1.readByte();
                    var _temp2 = _local3;
                    _local3 = (_local3 + 1);
                    _local6 = _temp2;
                    _local2[_local6] = ALPHA_CHAR_CODES[((_local5 & 240) >>> 4)];
                    var _temp3 = _local3;
                    _local3 = (_local3 + 1);
                    var _local7 = _temp3;
                    _local2[_local7] = ALPHA_CHAR_CODES[(_local5 & 15)];
                    _local4++;
                };
                return (String.fromCharCode.apply(null, _local2));
            };
            return (null);
        }
        public static function toByteArray(_arg1:String):ByteArray{
            var _local2:ByteArray;
            var _local3:uint;
            var _local4:String;
            var _local5:uint;
            var _local6:uint;
            if (isUID(_arg1)){
                _local2 = new ByteArray();
                _local3 = 0;
                while (_local3 < _arg1.length) {
                    _local4 = _arg1.charAt(_local3);
                    if (_local4 == "-"){
                    } else {
                        _local5 = getDigit(_local4);
                        _local3++;
                        _local6 = getDigit(_arg1.charAt(_local3));
                        _local2.writeByte((((_local5 << 4) | _local6) & 0xFF));
                    };
                    _local3++;
                };
                _local2.position = 0;
                return (_local2);
            };
            return (null);
        }
        private static function getDigit(_arg1:String):uint{
            switch (_arg1){
                case "A":
                case "a":
                    return (10);
                case "B":
                case "b":
                    return (11);
                case "C":
                case "c":
                    return (12);
                case "D":
                case "d":
                    return (13);
                case "E":
                case "e":
                    return (14);
                case "F":
                case "f":
                    return (15);
                default:
                    return (new uint(_arg1));
            };
        }

    }
}//package mx.utils 
