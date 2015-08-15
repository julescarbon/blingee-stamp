package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class SliderThumbSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cache:Object = {};

        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):Object{
            var _local6:Object;
            var _local5:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3, _arg4);
            if (!cache[_local5]){
                _local6 = (cache[_local5] = {});
                HaloColors.addHaloColors(_local6, _arg1, _arg3, _arg4);
                _local6.borderColorDrk1 = ColorUtil.adjustBrightness2(_arg2, -50);
            };
            return (cache[_local5]);
        }

        override public function get measuredWidth():Number{
            return (12);
        }
        override public function get measuredHeight():Number{
            return (12);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local9:Array;
            var _local10:Array;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:uint = getStyle("borderColor");
            var _local4:Array = getStyle("fillAlphas");
            var _local5:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local5);
            var _local6:uint = getStyle("themeColor");
            var _local7:Object = calcDerivedStyles(_local6, _local3, _local5[0], _local5[1]);
            var _local8:Graphics = graphics;
            _local8.clear();
            switch (name){
                case "thumbUpSkin":
                    drawThumbState(_arg1, _arg2, [_local3, _local7.borderColorDrk1], [_local5[0], _local5[1]], [_local4[0], _local4[1]], true, true);
                    break;
                case "thumbOverSkin":
                    if (_local5.length > 2){
                        _local9 = [_local5[2], _local5[3]];
                    } else {
                        _local9 = [_local5[0], _local5[1]];
                    };
                    if (_local4.length > 2){
                        _local10 = [_local4[2], _local4[3]];
                    } else {
                        _local10 = [_local4[0], _local4[1]];
                    };
                    drawThumbState(_arg1, _arg2, [_local7.themeColDrk2, _local7.themeColDrk1], _local9, _local10, true, true);
                    break;
                case "thumbDownSkin":
                    drawThumbState(_arg1, _arg2, [_local7.themeColDrk2, _local7.themeColDrk1], [_local7.fillColorPress1, _local7.fillColorPress2], [1, 1], true, false);
                    break;
                case "thumbDisabledSkin":
                    drawThumbState(_arg1, _arg2, [_local3, _local7.borderColorDrk1], [_local5[0], _local5[1]], [Math.max(0, (_local4[0] - 0.15)), Math.max(0, (_local4[1] - 0.15))], false, false);
                    break;
            };
        }
        protected function drawThumbState(_arg1:Number, _arg2:Number, _arg3:Array, _arg4:Array, _arg5:Array, _arg6:Boolean, _arg7:Boolean):void{
            var _local8:Graphics = graphics;
            var _local9:Boolean = getStyle("invertThumbDirection");
            var _local10:Number = ((_local9) ? _arg2 : 0);
            var _local11:Number = ((_local9) ? (_arg2 - 1) : 1);
            var _local12:Number = ((_local9) ? (_arg2 - 2) : 2);
            var _local13:Number = ((_local9) ? 2 : (_arg2 - 2));
            var _local14:Number = ((_local9) ? 1 : (_arg2 - 1));
            var _local15:Number = ((_local9) ? 0 : _arg2);
            if (_local9){
                _arg3 = [_arg3[1], _arg3[0]];
                _arg4 = [_arg4[1], _arg4[0]];
                _arg5 = [_arg5[1], _arg5[0]];
            };
            if (_arg6){
                _local8.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [0.6, 0.6], [0, 0xFF], verticalGradientMatrix(0, 0, _arg1, _arg2));
                _local8.moveTo((_arg1 / 2), _local10);
                _local8.curveTo((_arg1 / 2), _local10, ((_arg1 / 2) - 2), _local12);
                _local8.lineTo(0, _local13);
                _local8.curveTo(0, _local13, 2, _local15);
                _local8.lineTo((_arg1 - 2), _local15);
                _local8.curveTo((_arg1 - 2), _local15, _arg1, _local13);
                _local8.lineTo(((_arg1 / 2) + 2), _local12);
                _local8.curveTo(((_arg1 / 2) + 2), _local12, (_arg1 / 2), _local10);
                _local8.endFill();
            };
            _local8.beginGradientFill(GradientType.LINEAR, _arg3, [1, 1], [0, 0xFF], verticalGradientMatrix(0, 0, _arg1, _arg2));
            _local8.moveTo((_arg1 / 2), _local10);
            _local8.curveTo((_arg1 / 2), _local10, ((_arg1 / 2) - 2), _local12);
            _local8.lineTo(0, _local13);
            _local8.curveTo(0, _local13, 2, _local15);
            _local8.lineTo((_arg1 - 2), _local15);
            _local8.curveTo((_arg1 - 2), _local15, _arg1, _local13);
            _local8.lineTo(((_arg1 / 2) + 2), _local12);
            _local8.curveTo(((_arg1 / 2) + 2), _local12, (_arg1 / 2), _local10);
            if (_arg7){
                _local8.moveTo((_arg1 / 2), _local11);
                _local8.curveTo((_arg1 / 2), _local10, ((_arg1 / 2) - 1), _local12);
                _local8.lineTo(1, _local14);
                _local8.curveTo(1, _local14, 1, _local14);
                _local8.lineTo((_arg1 - 1), _local14);
                _local8.curveTo((_arg1 - 1), _local14, (_arg1 - 1), _local13);
                _local8.lineTo(((_arg1 / 2) + 1), _local12);
                _local8.curveTo(((_arg1 / 2) + 1), _local12, (_arg1 / 2), _local11);
                _local8.endFill();
            };
            _local8.beginGradientFill(GradientType.LINEAR, _arg4, _arg5, [0, 0xFF], verticalGradientMatrix(0, 0, _arg1, _arg2));
            _local8.moveTo((_arg1 / 2), _local11);
            _local8.curveTo((_arg1 / 2), _local10, ((_arg1 / 2) - 1), _local12);
            _local8.lineTo(1, _local14);
            _local8.curveTo(1, _local14, 1, _local14);
            _local8.lineTo((_arg1 - 1), _local14);
            _local8.curveTo((_arg1 - 1), _local14, (_arg1 - 1), _local13);
            _local8.lineTo(((_arg1 / 2) + 1), _local12);
            _local8.curveTo(((_arg1 / 2) + 1), _local12, (_arg1 / 2), _local11);
            _local8.endFill();
        }

    }
}//package mx.skins.halo 
