package mx.utils {
    import flash.display.*;
    import mx.core.*;

    public class GraphicsUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function drawRoundRectComplex(_arg1:Graphics, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:Number, _arg9:Number):void{
            var _local10:Number = (_arg2 + _arg4);
            var _local11:Number = (_arg3 + _arg5);
            var _local12:Number = (((_arg4 < _arg5)) ? (_arg4 * 2) : (_arg5 * 2));
            _arg6 = (((_arg6 < _local12)) ? _arg6 : _local12);
            _arg7 = (((_arg7 < _local12)) ? _arg7 : _local12);
            _arg8 = (((_arg8 < _local12)) ? _arg8 : _local12);
            _arg9 = (((_arg9 < _local12)) ? _arg9 : _local12);
            var _local13:Number = (_arg9 * 0.292893218813453);
            var _local14:Number = (_arg9 * 0.585786437626905);
            _arg1.moveTo(_local10, (_local11 - _arg9));
            _arg1.curveTo(_local10, (_local11 - _local14), (_local10 - _local13), (_local11 - _local13));
            _arg1.curveTo((_local10 - _local14), _local11, (_local10 - _arg9), _local11);
            _local13 = (_arg8 * 0.292893218813453);
            _local14 = (_arg8 * 0.585786437626905);
            _arg1.lineTo((_arg2 + _arg8), _local11);
            _arg1.curveTo((_arg2 + _local14), _local11, (_arg2 + _local13), (_local11 - _local13));
            _arg1.curveTo(_arg2, (_local11 - _local14), _arg2, (_local11 - _arg8));
            _local13 = (_arg6 * 0.292893218813453);
            _local14 = (_arg6 * 0.585786437626905);
            _arg1.lineTo(_arg2, (_arg3 + _arg6));
            _arg1.curveTo(_arg2, (_arg3 + _local14), (_arg2 + _local13), (_arg3 + _local13));
            _arg1.curveTo((_arg2 + _local14), _arg3, (_arg2 + _arg6), _arg3);
            _local13 = (_arg7 * 0.292893218813453);
            _local14 = (_arg7 * 0.585786437626905);
            _arg1.lineTo((_local10 - _arg7), _arg3);
            _arg1.curveTo((_local10 - _local14), _arg3, (_local10 - _local13), (_arg3 + _local13));
            _arg1.curveTo(_local10, (_arg3 + _local14), _local10, (_arg3 + _arg7));
            _arg1.lineTo(_local10, (_local11 - _arg9));
        }

    }
}//package mx.utils 
