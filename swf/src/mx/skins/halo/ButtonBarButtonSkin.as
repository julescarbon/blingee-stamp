package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.containers.*;
    import flash.utils.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ButtonBarButtonSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var bbars:Object = {};
        private static var cache:Object = {};

        private static function isButtonBar(_arg1:Object):Boolean{
            var s:* = null;
            var x:* = null;
            var parent:* = _arg1;
            s = getQualifiedClassName(parent);
            if (bbars[s] == 1){
                return (true);
            };
            if (bbars[s] == 0){
                return (false);
            };
            if (s == "mx.controls::ButtonBar"){
                (bbars[s] == 1);
                return (true);
            };
            x = describeType(parent);
            var xmllist:* = x.extendsClass.(@type == "mx.controls::ButtonBar");
            if (xmllist.length() == 0){
                bbars[s] = 0;
                return (false);
            };
            bbars[s] = 1;
            return (true);
        }
        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint):Object{
            var _local5:Object;
            var _local4:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3);
            if (!cache[_local4]){
                _local5 = (cache[_local4] = {});
                HaloColors.addHaloColors(_local5, _arg1, _arg2, _arg3);
                _local5.innerEdgeColor1 = ColorUtil.adjustBrightness2(_arg2, -10);
                _local5.innerEdgeColor2 = ColorUtil.adjustBrightness2(_arg3, -25);
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
            var _local13:Number;
            var _local22:int;
            var _local23:Array;
            var _local24:Array;
            var _local25:Array;
            var _local26:Array;
            var _local27:Array;
            var _local28:Array;
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
                _local12 = (parent as IButton).emphasized;
            };
            var _local14:Object = ((((((parent) && (parent.parent))) && (isButtonBar(parent.parent)))) ? parent.parent : null);
            var _local15:Boolean;
            var _local16:int;
            if (_local14){
                if (_local14.direction == BoxDirection.VERTICAL){
                    _local15 = false;
                };
                _local22 = _local14.getChildIndex(parent);
                _local16 = (((_local22 == 0)) ? -1 : (((_local22 == (_local14.numChildren - 1))) ? 1 : 0));
            };
            var _local17:Object = getCornerRadius(_local16, _local15, _local4);
            var _local18:Object = getCornerRadius(_local16, _local15, _local4);
            var _local19:Object = getCornerRadius(_local16, _local15, (_local4 - 1));
            var _local20:Object = getCornerRadius(_local16, _local15, (_local4 - 2));
            var _local21:Object = getCornerRadius(_local16, _local15, (_local4 - 3));
            graphics.clear();
            switch (name){
                case "selectedUpSkin":
                case "selectedOverSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:2,
                        y:2,
                        w:(_arg1 - 4),
                        h:(_arg2 - 4),
                        r:_local20
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local19, [_local6[1], _local6[1]], [_local5[0], _local5[1]], verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    break;
                case "upSkin":
                    _local23 = [_local6[0], _local6[1]];
                    _local24 = [_local5[0], _local5[1]];
                    if (_local12){
                        drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local8, _local11], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:2,
                            y:2,
                            w:(_arg1 - 4),
                            h:(_arg2 - 4),
                            r:_local20
                        });
                        drawRoundRect(2, 2, (_arg1 - 4), (_arg2 - 4), _local20, _local23, _local24, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                        if (!(_local17 is Number)){
                            _local17.bl = (_local17.br = 0);
                        };
                        drawRoundRect(2, 2, (_arg1 - 4), ((_arg2 - 4) / 2), _local17, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(2, 2, (_arg1 - 2), ((_arg2 - 4) / 2)));
                    } else {
                        drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local3, _local10], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                            x:1,
                            y:1,
                            w:(_arg1 - 2),
                            h:(_arg2 - 2),
                            r:_local19
                        });
                        drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local19, _local23, _local24, verticalGradientMatrix(1, 1, (_arg1 - 2), (_arg2 - 2)));
                        if (!(_local17 is Number)){
                            _local17.bl = (_local17.br = 0);
                        };
                        drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), _local17, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    };
                    break;
                case "overSkin":
                    if (_local6.length > 2){
                        _local25 = [_local6[2], _local6[3]];
                    } else {
                        _local25 = [_local6[0], _local6[1]];
                    };
                    if (_local5.length > 2){
                        _local26 = [_local5[2], _local5[3]];
                    } else {
                        _local26 = [_local5[0], _local5[1]];
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local8, _local9.themeColDrk1], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local19
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local19, _local25, _local26, verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    if (!(_local17 is Number)){
                        _local17.bl = (_local17.br = 0);
                    };
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), _local17, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    break;
                case "downSkin":
                case "selectedDownSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local8, _local9.themeColDrk1], 1, verticalGradientMatrix(0, 0, _arg1, _arg2));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local19, [_local9.fillColorPress1, _local9.fillColorPress2], 1, verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    if (!(_local17 is Number)){
                        _local17.bl = (_local17.br = 0);
                    };
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), _local17, [0xFFFFFF, 0xFFFFFF], _local7, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    break;
                case "disabledSkin":
                case "selectedDisabledSkin":
                    _local27 = [_local6[0], _local6[1]];
                    _local28 = [Math.max(0, (_local5[0] - 0.15)), Math.max(0, (_local5[1] - 0.15))];
                    drawRoundRect(0, 0, _arg1, _arg2, _local18, [_local3, _local10], 0.5, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local19
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local19, _local27, _local28, verticalGradientMatrix(0, 0, (_arg1 - 2), (_arg2 - 2)));
                    break;
            };
        }
        private function getCornerRadius(_arg1:int, _arg2:Boolean, _arg3:Number):Object{
            if (_arg1 == 0){
                return (0);
            };
            _arg3 = Math.max(0, _arg3);
            if (_arg2){
                if (_arg1 == -1){
                    return ({
                        tl:_arg3,
                        tr:0,
                        bl:_arg3,
                        br:0
                    });
                };
                return ({
                    tl:0,
                    tr:_arg3,
                    bl:0,
                    br:_arg3
                });
            };
            if (_arg1 == -1){
                return ({
                    tl:_arg3,
                    tr:_arg3,
                    bl:0,
                    br:0
                });
            };
            return ({
                tl:0,
                tr:0,
                bl:_arg3,
                br:_arg3
            });
        }

    }
}//package mx.skins.halo 
