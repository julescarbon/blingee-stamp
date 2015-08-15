package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ComboBoxArrowSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cache:Object = {};

        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):Object{
            var _local6:Object;
            var _local5:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3, _arg4);
            if (!cache[_local5]){
                _local6 = (cache[_local5] = {});
                HaloColors.addHaloColors(_local6, _arg1, _arg3, _arg4);
            };
            return (cache[_local5]);
        }

        override public function get measuredWidth():Number{
            return (22);
        }
        override public function get measuredHeight():Number{
            return (22);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local19:Array;
            var _local20:Array;
            var _local21:Array;
            var _local22:Array;
            var _local23:Array;
            var _local24:Array;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:uint = getStyle("iconColor");
            var _local4:uint = getStyle("borderColor");
            var _local5:Number = getStyle("cornerRadius");
            var _local6:Number = getStyle("dropdownBorderColor");
            var _local7:Array = getStyle("fillAlphas");
            var _local8:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local8);
            var _local9:Array = getStyle("highlightAlphas");
            var _local10:uint = getStyle("themeColor");
            if (!isNaN(_local6)){
                _local4 = _local6;
            };
            var _local11:Object = calcDerivedStyles(_local10, _local4, _local8[0], _local8[1]);
            var _local12:Number = ColorUtil.adjustBrightness2(_local4, -50);
            var _local13:Number = ColorUtil.adjustBrightness2(_local10, -25);
            var _local14:Number = Math.max((_local5 - 1), 0);
            var _local15:Object = {
                tl:0,
                tr:_local5,
                bl:0,
                br:_local5
            };
            var _local16:Object = {
                tl:0,
                tr:_local14,
                bl:0,
                br:_local14
            };
            var _local17:Boolean;
            if (name.indexOf("editable") < 0){
                _local17 = false;
                _local15.tl = (_local15.bl = _local5);
                _local16.tl = (_local16.bl = _local14);
            };
            var _local18:Graphics = graphics;
            _local18.clear();
            switch (name){
                case "upSkin":
                case "editableUpSkin":
                    _local19 = [_local8[0], _local8[1]];
                    _local20 = [_local7[0], _local7[1]];
                    drawRoundRect(0, 0, _arg1, _arg2, _local15, [_local4, _local12], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local19, _local20, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), {
                        tl:_local14,
                        tr:_local14,
                        bl:0,
                        br:0
                    }, [0xFFFFFF, 0xFFFFFF], _local9, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    if (!_local17){
                        drawRoundRect((_arg1 - 22), 4, 1, (_arg2 - 8), 0, _local4, 1);
                        drawRoundRect((_arg1 - 21), 4, 1, (_arg2 - 8), 0, 0xFFFFFF, 0.2);
                    };
                    break;
                case "overSkin":
                case "editableOverSkin":
                    if (_local8.length > 2){
                        _local21 = [_local8[2], _local8[3]];
                    } else {
                        _local21 = [_local8[0], _local8[1]];
                    };
                    if (_local7.length > 2){
                        _local22 = [_local7[2], _local7[3]];
                    } else {
                        _local22 = [_local7[0], _local7[1]];
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, _local15, [_local10, _local13], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local21, _local22, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), {
                        tl:_local14,
                        tr:_local14,
                        bl:0,
                        br:0
                    }, [0xFFFFFF, 0xFFFFFF], _local9, verticalGradientMatrix(0, 0, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    if (!_local17){
                        drawRoundRect((_arg1 - 22), 4, 1, (_arg2 - 8), 0, _local11.themeColDrk2, 1);
                        drawRoundRect((_arg1 - 21), 4, 1, (_arg2 - 8), 0, 0xFFFFFF, 0.2);
                    };
                    break;
                case "downSkin":
                case "editableDownSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local15, [_local10, _local13], 1, verticalGradientMatrix(0, 0, _arg1, _arg2));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, [_local11.fillColorPress1, _local11.fillColorPress2], 1, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), {
                        tl:_local14,
                        tr:_local14,
                        bl:0,
                        br:0
                    }, [0xFFFFFF, 0xFFFFFF], _local9, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    if (!_local17){
                        drawRoundRect((_arg1 - 22), 4, 1, (_arg2 - 8), 0, _local13, 1);
                        drawRoundRect((_arg1 - 21), 4, 1, (_arg2 - 8), 0, 0xFFFFFF, 0.2);
                    };
                    break;
                case "disabledSkin":
                case "editableDisabledSkin":
                    _local23 = [_local8[0], _local8[1]];
                    _local24 = [Math.max(0, (_local7[0] - 0.15)), Math.max(0, (_local7[1] - 0.15))];
                    drawRoundRect(0, 0, _arg1, _arg2, _local15, [_local4, _local12], 0.5, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local23, _local24, verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    if (!_local17){
                        drawRoundRect((_arg1 - 22), 4, 1, (_arg2 - 8), 0, 0x999999, 0.5);
                    };
                    _local3 = getStyle("disabledIconColor");
                    break;
            };
            _local18.beginFill(_local3);
            _local18.moveTo((_arg1 - 11.5), ((_arg2 / 2) + 3));
            _local18.lineTo((_arg1 - 15), ((_arg2 / 2) - 2));
            _local18.lineTo((_arg1 - 8), ((_arg2 / 2) - 2));
            _local18.lineTo((_arg1 - 11.5), ((_arg2 / 2) + 3));
            _local18.endFill();
        }

    }
}//package mx.skins.halo 
