package src {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;
    import mx.skins.halo.*;

    public class VerticalTabSkin extends Border {

        private static var cache:Object = {};

        private var _borderMetrics:EdgeMetrics;

        public function VerticalTabSkin(){
            _borderMetrics = new EdgeMetrics(1, 1, 1, 1);
            super();
        }
        private static function calcDerivedStyles(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:uint, _arg6:uint):Object{
            var _local8:Object;
            var _local7:String = HaloColors.getCacheKey(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6);
            if (!cache[_local7]){
                _local8 = (cache[_local7] = {});
                HaloColors.addHaloColors(_local8, _arg1, _arg5, _arg6);
                _local8.borderColorDrk1 = ColorUtil.adjustBrightness2(_arg2, 10);
                _local8.falseFillColorBright1 = ColorUtil.adjustBrightness(_arg3, 15);
                _local8.falseFillColorBright2 = ColorUtil.adjustBrightness(_arg4, 15);
            };
            return (cache[_local7]);
        }

        override public function get measuredWidth():Number{
            return (UIComponent.DEFAULT_MEASURED_MIN_WIDTH);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local17:Array;
            var _local18:Array;
            var _local19:Array;
            var _local20:Array;
            var _local21:Array;
            var _local22:Array;
            var _local23:DisplayObjectContainer;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("backgroundAlpha");
            var _local4:Number = getStyle("backgroundColor");
            var _local5:uint = getStyle("borderColor");
            var _local6:Number = getStyle("cornerRadius");
            var _local7:Array = getStyle("fillAlphas");
            var _local8:Array = getStyle("fillColors");
            StyleManager.getColorNames(_local8);
            var _local9:Array = getStyle("highlightAlphas");
            var _local10:uint = getStyle("themeColor");
            var _local11:Array = [];
            _local11[0] = ColorUtil.adjustBrightness2(_local8[0], -5);
            _local11[1] = ColorUtil.adjustBrightness2(_local8[1], -5);
            var _local12:Object = calcDerivedStyles(_local10, _local5, _local11[0], _local11[1], _local8[0], _local8[1]);
            var _local13 = !((parent == null));
            var _local14:Number = Math.max((_local6 - 2), 0);
            var _local15:Object = {
                tl:_local6,
                tr:_local6,
                bl:0,
                br:0
            };
            var _local16:Object = {
                tl:_local14,
                tr:_local14,
                bl:0,
                br:0
            };
            graphics.clear();
            switch (name){
                case "upSkin":
                    _local17 = [_local11[0], _local11[1]];
                    _local18 = [_local7[0], _local7[1]];
                    drawRoundRect(0, 0, _arg1, (_arg2 - 1), _local15, [_local12.borderColorDrk1, _local5], 1, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local17, _local18, verticalGradientMatrix(0, 2, (_arg1 - 2), (_arg2 - 6)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), _local16, [0xFFFFFF, 0xFFFFFF], _local9, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    if (_local13){
                        drawRoundRect(0, (_arg2 - 1), _arg1, 1, 0, _local5, _local7[1]);
                    };
                    drawRoundRect(0, (_arg2 - 2), _arg1, 1, 0, 0, 0.09);
                    drawRoundRect(0, (_arg2 - 3), _arg1, 1, 0, 0, 0.03);
                    break;
                case "overSkin":
                    if (_local8.length > 2){
                        _local19 = [_local8[2], _local8[3]];
                    } else {
                        _local19 = [_local8[0], _local8[1]];
                    };
                    if (_local7.length > 2){
                        _local20 = [_local7[2], _local7[3]];
                    } else {
                        _local20 = [_local7[0], _local7[1]];
                    };
                    drawRoundRect(0, 0, _arg1, (_arg2 - 1), _local15, [_local10, _local12.themeColDrk2], 1, verticalGradientMatrix(0, 0, _arg1, (_arg2 - 6)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, [_local12.falseFillColorBright1, _local12.falseFillColorBright2], _local20, verticalGradientMatrix(2, 2, (_arg1 - 2), (_arg2 - 2)));
                    drawRoundRect(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2), _local16, [0xFFFFFF, 0xFFFFFF], _local9, verticalGradientMatrix(1, 1, (_arg1 - 2), ((_arg2 - 2) / 2)));
                    if (_local13){
                        drawRoundRect(0, (_arg2 - 1), _arg1, 1, 0, _local5, _local7[1]);
                    };
                    drawRoundRect(0, (_arg2 - 2), _arg1, 1, 0, 0, 0.09);
                    drawRoundRect(0, (_arg2 - 3), _arg1, 1, 0, 0, 0.03);
                    break;
                case "disabledSkin":
                    _local21 = [_local8[0], _local8[1]];
                    _local22 = [Math.max(0, (_local7[0] - 0.15)), Math.max(0, (_local7[1] - 0.15))];
                    drawRoundRect(0, 0, _arg1, (_arg2 - 1), _local15, [_local12.borderColorDrk1, _local5], 0.5, verticalGradientMatrix(0, 0, _arg1, (_arg2 - 6)));
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local21, _local22, verticalGradientMatrix(0, 2, (_arg1 - 2), (_arg2 - 2)));
                    if (_local13){
                        drawRoundRect(0, (_arg2 - 1), _arg1, 1, 0, _local5, _local7[1]);
                    };
                    drawRoundRect(0, (_arg2 - 2), _arg1, 1, 0, 0, 0.09);
                    drawRoundRect(0, (_arg2 - 3), _arg1, 1, 0, 0, 0.03);
                    break;
                case "downSkin":
                case "selectedUpSkin":
                case "selectedDownSkin":
                case "selectedOverSkin":
                case "selectedDisabledSkin":
                    if (isNaN(_local4)){
                        _local23 = parent;
                        while (_local23) {
                            if ((_local23 is IStyleClient)){
                                _local4 = IStyleClient(_local23).getStyle("backgroundColor");
                            };
                            if (!isNaN(_local4)){
                                break;
                            };
                            _local23 = _local23.parent;
                        };
                        if (isNaN(_local4)){
                            _local4 = 0xFFFFFF;
                        };
                    };
                    drawRoundRect(0, 0, _arg1, _arg2, _local15, [_local12.borderColorDrk1, _local5], 1, verticalGradientMatrix(0, 0, _arg1, (_arg2 - 2)), GradientType.LINEAR, null, {
                        x:1,
                        y:1,
                        w:(_arg1 - 2),
                        h:(_arg2 - 2),
                        r:_local16
                    });
                    drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), _local16, _local4, _local3);
                    if (_local13){
                        drawRoundRect((_arg1 - 1), 1, 1, (_arg2 - 2), 0, _local4, _local3);
                    };
                    break;
            };
        }
        override public function get measuredHeight():Number{
            return (UIComponent.DEFAULT_MEASURED_MIN_HEIGHT);
        }
        override public function get borderMetrics():EdgeMetrics{
            return (_borderMetrics);
        }

    }
}//package src 
