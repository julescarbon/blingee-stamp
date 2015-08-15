package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ScrollThumbSkin extends Border {

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
            return (16);
        }
        override public function get measuredHeight():Number{
            return (10);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local17:Array;
            var _local18:Array;
            var _local19:Array;
            var _local20:Array;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("backgroundColor");
            var _local4:uint = getStyle("borderColor");
            var _local5:Number = getStyle("cornerRadius");
            var _local6:Array = getStyle("fillAlphas");
            var _local7:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local7);
            var _local8:Array = getStyle("highlightAlphas");
            var _local9:uint = getStyle("themeColor");
            var _local10:uint = 7305079;
            var _local11:Object = calcDerivedStyles(_local9, _local4, _local7[0], _local7[1]);
            var _local12:Number = Math.max((_local5 - 1), 0);
            var _local13:Object = {
                tl:0,
                tr:_local12,
                bl:0,
                br:_local12
            };
            _local12 = Math.max((_local12 - 1), 0);
            var _local14:Object = {
                tl:0,
                tr:_local12,
                bl:0,
                br:_local12
            };
            var _local15:Boolean = ((((parent) && (parent.parent))) && (!((parent.parent.rotation == 0))));
            if (isNaN(_local3)){
                _local3 = 0xFFFFFF;
            };
            graphics.clear();
            drawRoundRect(1, 0, (_arg1 - 3), _arg2, _local13, _local3, 1);
            switch (name){
                case "thumbUpSkin":
                default:
                    _local17 = [_local7[0], _local7[1]];
                    _local18 = [_local6[0], _local6[1]];
                    drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 0);
                    if (_local15){
                        drawRoundRect(1, 0, (_arg1 - 2), _arg2, _local5, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], horizontalGradientMatrix(2, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 4),
                            h:(_arg2 - 2),
                            r:_local14
                        });
                    } else {
                        drawRoundRect(1, (_arg2 - _local12), (_arg1 - 3), (_local12 + 4), {
                            tl:0,
                            tr:0,
                            bl:0,
                            br:_local12
                        }, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], ((_local15) ? horizontalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8) : verticalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8)), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - _local12),
                            w:(_arg1 - 4),
                            h:_local12,
                            r:{
                                tl:0,
                                tr:0,
                                bl:0,
                                br:(_local12 - 1)
                            }
                        });
                    };
                    drawRoundRect(1, 0, (_arg1 - 3), _arg2, _local13, [_local4, _local11.borderColorDrk1], 1, ((_local15) ? horizontalGradientMatrix(0, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 4),
                        h:(_arg2 - 2),
                        r:_local14
                    });
                    drawRoundRect(1, 1, (_arg1 - 4), (_arg2 - 2), _local14, _local17, _local18, ((_local15) ? horizontalGradientMatrix(1, 0, (_arg1 - 2), (_arg2 - 2)) : verticalGradientMatrix(1, 0, (_arg1 - 2), (_arg2 - 2))));
                    if (_local15){
                        drawRoundRect(1, 0, ((_arg1 - 4) / 2), (_arg2 - 2), 0, [0xFFFFFF, 0xFFFFFF], _local8, horizontalGradientMatrix(1, 1, (_arg1 - 4), ((_arg2 - 2) / 2)));
                    } else {
                        drawRoundRect(1, 1, (_arg1 - 4), ((_arg2 - 2) / 2), _local14, [0xFFFFFF, 0xFFFFFF], _local8, ((_local15) ? horizontalGradientMatrix(1, 0, ((_arg1 - 4) / 2), (_arg2 - 2)) : verticalGradientMatrix(1, 1, (_arg1 - 4), ((_arg2 - 2) / 2))));
                    };
                    break;
                case "thumbOverSkin":
                    if (_local7.length > 2){
                        _local19 = [_local7[2], _local7[3]];
                    } else {
                        _local19 = [_local7[0], _local7[1]];
                    };
                    if (_local6.length > 2){
                        _local20 = [_local6[2], _local6[3]];
                    } else {
                        _local20 = [_local6[0], _local6[1]];
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 0);
                    if (_local15){
                        drawRoundRect(1, 0, (_arg1 - 2), _arg2, _local5, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], horizontalGradientMatrix(2, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 4),
                            h:(_arg2 - 2),
                            r:_local14
                        });
                    } else {
                        drawRoundRect(1, (_arg2 - _local12), (_arg1 - 3), (_local12 + 4), {
                            tl:0,
                            tr:0,
                            bl:0,
                            br:_local12
                        }, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], ((_local15) ? horizontalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8) : verticalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8)), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - _local12),
                            w:(_arg1 - 4),
                            h:_local12,
                            r:{
                                tl:0,
                                tr:0,
                                bl:0,
                                br:(_local12 - 1)
                            }
                        });
                    };
                    drawRoundRect(1, 0, (_arg1 - 3), _arg2, _local13, [_local9, _local11.themeColDrk1], 1, ((_local15) ? horizontalGradientMatrix(1, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 4),
                        h:(_arg2 - 2),
                        r:_local14
                    });
                    drawRoundRect(1, 1, (_arg1 - 4), (_arg2 - 2), _local14, _local19, _local20, ((_local15) ? horizontalGradientMatrix(1, 0, _arg1, _arg2) : verticalGradientMatrix(1, 0, _arg1, _arg2)));
                    break;
                case "thumbDownSkin":
                    if (_local15){
                        drawRoundRect(1, 0, (_arg1 - 2), _arg2, _local13, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], horizontalGradientMatrix(2, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 4),
                            h:(_arg2 - 2),
                            r:_local14
                        });
                    } else {
                        drawRoundRect(1, (_arg2 - _local12), (_arg1 - 3), (_local12 + 4), {
                            tl:0,
                            tr:0,
                            bl:0,
                            br:_local12
                        }, [_local11.borderColorDrk1, _local11.borderColorDrk1], [1, 0], ((_local15) ? horizontalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8) : verticalGradientMatrix(0, (_arg2 - 4), (_arg1 - 3), 8)), GradientType.LINEAR, null, {
                            x:1,
                            y:(_arg2 - _local12),
                            w:(_arg1 - 4),
                            h:_local12,
                            r:{
                                tl:0,
                                tr:0,
                                bl:0,
                                br:(_local12 - 1)
                            }
                        });
                    };
                    drawRoundRect(1, 0, (_arg1 - 3), _arg2, _local13, [_local9, _local11.themeColDrk2], 1, ((_local15) ? horizontalGradientMatrix(1, 0, _arg1, _arg2) : verticalGradientMatrix(0, 0, _arg1, _arg2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 4),
                        h:(_arg2 - 2),
                        r:_local14
                    });
                    drawRoundRect(1, 1, (_arg1 - 4), (_arg2 - 2), _local14, [_local11.fillColorPress1, _local11.fillColorPress2], 1, ((_local15) ? horizontalGradientMatrix(1, 0, _arg1, _arg2) : verticalGradientMatrix(1, 0, _arg1, _arg2)));
                    break;
                case "thumbDisabledSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, 0, 0xFFFFFF, 0);
                    drawRoundRect(1, 0, (_arg1 - 3), _arg2, _local13, 0x999999, 0.5);
                    drawRoundRect(1, 1, (_arg1 - 4), (_arg2 - 2), _local14, 0xFFFFFF, 0.5);
            };
            var _local16:Number = Math.floor(((_arg1 / 2) - 4));
            drawRoundRect(_local16, Math.floor(((_arg2 / 2) - 4)), 5, 1, 0, 0, 0.4);
            drawRoundRect(_local16, Math.floor(((_arg2 / 2) - 2)), 5, 1, 0, 0, 0.4);
            drawRoundRect(_local16, Math.floor((_arg2 / 2)), 5, 1, 0, 0, 0.4);
            drawRoundRect(_local16, Math.floor(((_arg2 / 2) + 2)), 5, 1, 0, 0, 0.4);
            drawRoundRect(_local16, Math.floor(((_arg2 / 2) + 4)), 5, 1, 0, 0, 0.4);
        }

    }
}//package mx.skins.halo 
