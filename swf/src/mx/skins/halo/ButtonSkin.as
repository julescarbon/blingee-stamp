package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ButtonSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cache:Object = {};

        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint):Object{
            var _local5:Object;
            var _local4:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3);
            if (!cache[_local4]){
                _local5 = (cache[_local4] = {});
                HaloColors.addHaloColors(_local5, _arg1, _arg2, _arg3);
            };
            return (cache[_local4]);
        }

        override public function get measuredWidth():Number{
            return (UIComponent.DEFAULT_MEASURED_MIN_WIDTH);
        }
        override public function get measuredHeight():Number{
            return (UIComponent.DEFAULT_MEASURED_MIN_HEIGHT);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local16:Number;
            var _local17:Array;
            var _local18:Array;
            var _local19:Array;
            var _local20:Array;
            var _local21:Array;
            var _local22:Array;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:uint = getStyle("borderColor");
            var _local4:Number = getStyle("cornerRadius");
            var _local5:Array = getStyle("fillAlphas");
            var _local6:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local6);
            var _local7:Array = getStyle("highlightAlphas");
            var _local8:uint = getStyle("themeColor");
            var _local9:Object = calcDerivedStyles(_local8, _local6[0], _local6[1]);
            var _local10:Number = ColorUtil.adjustBrightness2(_local3, -50);
            var _local11:Number = ColorUtil.adjustBrightness2(_local8, -25);
            var _local12:Boolean;
            if ((parent is IButton)){
                _local12 = IButton(parent).emphasized;
            };
            var _local13:Number = Math.max(0, _local4);
            var _local14:Number = Math.max(0, (_local4 - 1));
            var _local15:Number = Math.max(0, (_local4 - 2));
            graphics.clear();
            switch (name){
                case "selectedUpSkin":
                case "selectedOverSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local14, [_local6[1], _local6[1]], 1, verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    break;
                case "upSkin":
                    _local17 = [_local6[0], _local6[1]];
                    _local18 = [_local5[0], _local5[1]];
                    if (_local12){
                        drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:2,
                            y:2,
                            w:(_arg1 - 4),
                            h:(_arg2 - 4),
                            r:(_local4 - 2)
                        });
                        drawRoundRect(2, 2, (_arg1 - 4), (_arg2 - 4), _local15, _local17, _local18, verticalGradientMatrix(2, 2, (_arg1 - 2), (_arg2 - 2)));
                        drawRoundRect(2, 2, (_arg1 - 4), ((_arg2 - 4) / 2), {
                            tl:_local15,
                            tr:_local15,
                            bl:0,
                            br:0
                        }, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    } else {
                        drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local3, _local10], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 2),
                            h:(_arg2 - 2),
                            r:(_local4 - 1)
                        });
                        drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local14, _local17, _local18, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                        drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), {
                            tl:_local14,
                            tr:_local14,
                            bl:0,
                            br:0
                        }, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    };
                    break;
                case "overSkin":
                    if (_local6.length > 2){
                        _local19 = [_local6[2], _local6[3]];
                    } else {
                        _local19 = [_local6[0], _local6[1]];
                    };
                    if (_local5.length > 2){
                        _local20 = [_local5[2], _local5[3]];
                    } else {
                        _local20 = [_local5[0], _local5[1]];
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:(_local4 - 1)
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local14, _local19, _local20, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), {
                        tl:_local14,
                        tr:_local14,
                        bl:0,
                        br:0
                    }, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    break;
                case "downSkin":
                case "selectedDownSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local14, [_local9.fillColorPress1, _local9.fillColorPress2], 1, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(2, 2, (_arg1 - 4), ((_arg2 - 4) / 2), {
                        tl:_local15,
                        tr:_local15,
                        bl:0,
                        br:0
                    }, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    break;
                case "disabledSkin":
                case "selectedDisabledSkin":
                    _local21 = [_local6[0], _local6[1]];
                    _local22 = [Math.max(0, (_local5[0] - 0.15)), Math.max(0, (_local5[1] - 0.15))];
                    drawRoundRect(0, 0, _arg1, _arg2, _local13, [_local3, _local10], 0.5, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:(_local4 - 1)
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local14, _local21, _local22, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                    break;
            };
        }

    }
}//package mx.skins.halo 
