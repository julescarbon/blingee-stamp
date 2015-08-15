package mx.utils {

    public class ColorUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function adjustBrightness2(_arg1:uint, _arg2:Number):uint{
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            if (_arg2 == 0){
                return (_arg1);
            };
            if (_arg2 < 0){
                _arg2 = ((100 + _arg2) / 100);
                _local3 = (((_arg1 >> 16) & 0xFF) * _arg2);
                _local4 = (((_arg1 >> 8) & 0xFF) * _arg2);
                _local5 = ((_arg1 & 0xFF) * _arg2);
            } else {
                _arg2 = (_arg2 / 100);
                _local3 = ((_arg1 >> 16) & 0xFF);
                _local4 = ((_arg1 >> 8) & 0xFF);
                _local5 = (_arg1 & 0xFF);
                _local3 = (_local3 + ((0xFF - _local3) * _arg2));
                _local4 = (_local4 + ((0xFF - _local4) * _arg2));
                _local5 = (_local5 + ((0xFF - _local5) * _arg2));
                _local3 = Math.min(_local3, 0xFF);
                _local4 = Math.min(_local4, 0xFF);
                _local5 = Math.min(_local5, 0xFF);
            };
            return ((((_local3 << 16) | (_local4 << 8)) | _local5));
        }
        public static function rgbMultiply(_arg1:uint, _arg2:uint):uint{
            var _local3:Number = ((_arg1 >> 16) & 0xFF);
            var _local4:Number = ((_arg1 >> 8) & 0xFF);
            var _local5:Number = (_arg1 & 0xFF);
            var _local6:Number = ((_arg2 >> 16) & 0xFF);
            var _local7:Number = ((_arg2 >> 8) & 0xFF);
            var _local8:Number = (_arg2 & 0xFF);
            return ((((((_local3 * _local6) / 0xFF) << 16) | (((_local4 * _local7) / 0xFF) << 8)) | ((_local5 * _local8) / 0xFF)));
        }
        public static function adjustBrightness(_arg1:uint, _arg2:Number):uint{
            var _local3:Number = Math.max(Math.min((((_arg1 >> 16) & 0xFF) + _arg2), 0xFF), 0);
            var _local4:Number = Math.max(Math.min((((_arg1 >> 8) & 0xFF) + _arg2), 0xFF), 0);
            var _local5:Number = Math.max(Math.min(((_arg1 & 0xFF) + _arg2), 0xFF), 0);
            return ((((_local3 << 16) | (_local4 << 8)) | _local5));
        }

    }
}//package mx.utils 
