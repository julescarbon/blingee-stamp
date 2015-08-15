package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.controls.scrollClasses.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ScrollArrowSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cache:Object = {};

        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint):Object{
            var _local6:Object;
            var _local5:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3, _arg4);
            if (!cache[_local5]){
                _local6 = (cache[_local5] = {});
                HaloColors.addHaloColors(_local6, _arg1, _arg3, _arg4);
                _local6.borderColorDrk1 = ColorUtil.adjustBrightness2(_arg2, -25);
                _local6.borderColorDrk2 = ColorUtil.adjustBrightness2(_arg2, -50);
            };
            return (cache[_local5]);
        }

        override public function get measuredWidth():Number{
            return (ScrollBar.THICKNESS);
        }
        override public function get measuredHeight():Number{
            return (ScrollBar.THICKNESS);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local13:Array;
            var _local15:Array;
            var _local16:Array;
            var _local17:Array;
            var _local18:Array;
            var _local19:Array;
            var _local20:Array;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("backgroundColor");
            var _local4:uint = getStyle("borderColor");
            var _local5:Array = getStyle("fillAlphas");
            var _local6:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local6);
            var _local7:Array = getStyle("highlightAlphas");
            var _local8:uint = getStyle("themeColor");
            var _local9 = (name.charAt(0) == "u");
            var _local10:uint = getStyle("iconColor");
            var _local11:Object = calcDerivedStyles(_local8, _local4, _local6[0], _local6[1]);
            var _local12:Boolean = ((((parent) && (parent.parent))) && (!((parent.parent.rotation == 0))));
            if (((_local9) && (!(_local12)))){
                _local13 = [_local4, _local11.borderColorDrk1];
            } else {
                _local13 = [_local11.borderColorDrk1, _local11.borderColorDrk2];
            };
            var _local14:Graphics = graphics;
            _local14.clear();
            if (isNaN(_local3)){
                _local3 = 0xFFFFFF;
            };
            if ((((FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)) || ((name.indexOf("Disabled") == -1)))){
                drawRoundRect(0, 0, _arg1, _arg2, 0, _local3, 1);
            };
            switch (name){
                case "upArrowUpSkin":
                    if (!_local12){
                        drawRoundRect(1, (_arg2 - 4), (_arg1 - 2), 8, 0, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], verticalGradientMatrix(1, (_arg2 - 4), (_arg1 - 2), 8), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - 4),
                            w:(_arg1 - 2),
                            h:4,
                            r:0
                        });
                    };
                case "downArrowUpSkin":
                    _local15 = [_local6[0], _local6[1]];
                    _local16 = [_local5[0], _local5[1]];
                    drawRoundRect(0, 0, _arg1, _arg2, 0, _local13, 1, ((_local12) ? horizontalGradientMatrix(0, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:0
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), 0, _local15, _local16, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - (2 / 2)))));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - (2 / 2)), 0, [0xFFFFFF, 0xFFFFFF], _local7, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - (2 / 2)))));
                    break;
                case "upArrowOverSkin":
                    if (!_local12){
                        drawRoundRect(1, (_arg2 - 4), (_arg1 - 2), 8, 0, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], verticalGradientMatrix(1, (_arg2 - 4), (_arg1 - 2), 8), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - 4),
                            w:(_arg1 - 2),
                            h:4,
                            r:0
                        });
                    };
                case "downArrowOverSkin":
                    if (_local6.length > 2){
                        _local17 = [_local6[2], _local6[3]];
                    } else {
                        _local17 = [_local6[0], _local6[1]];
                    };
                    if (_local5.length > 2){
                        _local18 = [_local5[2], _local5[3]];
                    } else {
                        _local18 = [_local5[0], _local5[1]];
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 1);
                    drawRoundRect(0, 0, _arg1, _arg2, 0, [_local8, _local11.themeColDrk1], 1, ((_local12) ? horizontalGradientMatrix(0, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:0
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), 0, _local17, _local18, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2))));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - (2 / 2)), 0, [0xFFFFFF, 0xFFFFFF], _local7, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - (2 / 2)))));
                    break;
                case "upArrowDownSkin":
                    if (!_local12){
                        drawRoundRect(1, (_arg2 - 4), (_arg1 - 2), 8, 0, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], ((_local12) ? horizontalGradientMatrix(1, (_arg2 - 4), (_arg1 - 2), 8) : verticalGradientMatrix(1, (_arg2 - 4), (_arg1 - 2), 8)), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - 4),
                            w:(_arg1 - 2),
                            h:4,
                            r:0
                        });
                    };
                case "downArrowDownSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, 0, [_local8, _local11.themeColDrk1], 1, ((_local12) ? horizontalGradientMatrix(0, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:0
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), 0, [_local11.fillColorPress1, _local11.fillColorPress2], 1, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2))));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - (2 / 2)), 0, [0xFFFFFF, 0xFFFFFF], _local7, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - (2 / 2)))));
                    break;
                case "upArrowDisabledSkin":
                    if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                        if (!_local12){
                            drawRoundRect(1, (_arg2 - 4), (_arg1 - 2), 8, 0, [_local11.borderColorDrk1, _local11.borderColorDrk1], [0.5, 0], verticalGradientMatrix(1, (_arg2 - 4), (_arg1 - 2), 8), GradientType.LINEAR, null, {
                                x:1,
                                y:(_arg2 - 4),
                                w:(_arg1 - 2),
                                h:4,
                                r:0
                            });
                        };
                    };
                case "downArrowDisabledSkin":
                    if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                        _local19 = [_local6[0], _local6[1]];
                        _local20 = [(_local5[0] - 0.15), (_local5[1] - 0.15)];
                        drawRoundRect(0, 0, _arg1, _arg2, 0, _local13, 0.5, ((_local12) ? horizontalGradientMatrix(0, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 2),
                            h:(_arg2 - 2),
                            r:0
                        });
                        drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), 0, _local19, _local20, ((_local12) ? horizontalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - (2 / 2)))));
                        _local10 = getStyle("disabledIconColor");
                    } else {
                        drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 0);
                        return;
                    };
                    break;
                default:
                    drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 0);
                    return;
            };
            _local14.beginFill(_local10);
            if (_local9){
                _local14.moveTo((_arg1 / 2), 6);
                _local14.lineTo((_arg1 - 5), (_arg2 - 6));
                _local14.lineTo(5, (_arg2 - 6));
                _local14.lineTo((_arg1 / 2), 6);
            } else {
                _local14.moveTo((_arg1 / 2), (_arg2 - 6));
                _local14.lineTo((_arg1 - 5), 6);
                _local14.lineTo(5, 6);
                _local14.lineTo((_arg1 / 2), (_arg2 - 6));
            };
            _local14.endFill();
        }

    }
}//package mx.skins.halo 
