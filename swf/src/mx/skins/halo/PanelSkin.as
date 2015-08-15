package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import flash.utils.*;

    public class PanelSkin extends HaloBorder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var panels:Object = {};

        private var oldControlBarHeight:Number;
        protected var _panelBorderMetrics:EdgeMetrics;
        private var oldHeaderHeight:Number;

        private static function isPanel(_arg1:Object):Boolean{
            var s:* = null;
            var x:* = null;
            var parent:* = _arg1;
            s = getQualifiedClassName(parent);
            if (panels[s] == 1){
                return (true);
            };
            if (panels[s] == 0){
                return (false);
            };
            if (s == "mx.containers::Panel"){
                (panels[s] == 1);
                return (true);
            };
            x = describeType(parent);
            var xmllist:* = x.extendsClass.(@type == "mx.containers::Panel");
            if (xmllist.length() == 0){
                panels[s] = 0;
                return (false);
            };
            panels[s] = 1;
            return (true);
        }

        override public function styleChanged(_arg1:String):void{
            super.styleChanged(_arg1);
            if ((((((((((((((((((_arg1 == null)) || ((_arg1 == "styleName")))) || ((_arg1 == "borderStyle")))) || ((_arg1 == "borderThickness")))) || ((_arg1 == "borderThicknessTop")))) || ((_arg1 == "borderThicknessBottom")))) || ((_arg1 == "borderThicknessLeft")))) || ((_arg1 == "borderThicknessRight")))) || ((_arg1 == "borderSides")))){
                _panelBorderMetrics = null;
            };
            invalidateDisplayList();
        }
        override mx_internal function drawBorder(_arg1:Number, _arg2:Number):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Graphics;
            var _local8:IContainer;
            var _local9:EdgeMetrics;
            super.drawBorder(_arg1, _arg2);
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return;
            };
            var _local3:String = getStyle("borderStyle");
            if (_local3 == "default"){
                _local4 = getStyle("backgroundAlpha");
                _local5 = getStyle("borderAlpha");
                backgroundAlphaName = "borderAlpha";
                radiusObj = null;
                radius = getStyle("cornerRadius");
                bRoundedCorners = (getStyle("roundedBottomCorners").toString().toLowerCase() == "true");
                _local6 = ((bRoundedCorners) ? radius : 0);
                _local7 = graphics;
                drawDropShadow(0, 0, _arg1, _arg2, radius, radius, _local6, _local6);
                if (!bRoundedCorners){
                    radiusObj = {};
                };
                _local8 = (parent as IContainer);
                if (_local8){
                    _local9 = _local8.viewMetrics;
                    backgroundHole = {
                        x:_local9.left,
                        y:_local9.top,
                        w:Math.max(0, ((_arg1 - _local9.left) - _local9.right)),
                        h:Math.max(0, ((_arg2 - _local9.top) - _local9.bottom)),
                        r:0
                    };
                    if ((((backgroundHole.w > 0)) && ((backgroundHole.h > 0)))){
                        if (_local4 != _local5){
                            drawDropShadow(backgroundHole.x, backgroundHole.y, backgroundHole.w, backgroundHole.h, 0, 0, 0, 0);
                        };
                        _local7.beginFill(Number(backgroundColor), _local4);
                        _local7.drawRect(backgroundHole.x, backgroundHole.y, backgroundHole.w, backgroundHole.h);
                        _local7.endFill();
                    };
                };
                backgroundColor = getStyle("borderColor");
            };
        }
        override public function get borderMetrics():EdgeMetrics{
            var _local4:Number;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (super.borderMetrics);
            };
            var _local1:Boolean = isPanel(parent);
            var _local2:IUIComponent = ((_local1) ? Object(parent)._controlBar : null);
            var _local3:Number = ((_local1) ? Object(parent).getHeaderHeightProxy() : NaN);
            if (((_local2) && (_local2.includeInLayout))){
                _local4 = _local2.getExplicitOrMeasuredHeight();
            };
            if (((!((_local4 == oldControlBarHeight))) && (!(((isNaN(oldControlBarHeight)) && (isNaN(_local4))))))){
                _panelBorderMetrics = null;
            };
            if (((!((_local3 == oldHeaderHeight))) && (!(((isNaN(_local3)) && (isNaN(oldHeaderHeight))))))){
                _panelBorderMetrics = null;
            };
            if (_panelBorderMetrics){
                return (_panelBorderMetrics);
            };
            var _local5:EdgeMetrics = super.borderMetrics;
            var _local6:EdgeMetrics = new EdgeMetrics(0, 0, 0, 0);
            var _local7:Number = getStyle("borderThickness");
            var _local8:Number = getStyle("borderThicknessLeft");
            var _local9:Number = getStyle("borderThicknessTop");
            var _local10:Number = getStyle("borderThicknessRight");
            var _local11:Number = getStyle("borderThicknessBottom");
            _local6.left = (_local5.left + ((isNaN(_local8)) ? _local7 : _local8));
            _local6.top = (_local5.top + ((isNaN(_local9)) ? _local7 : _local9));
            _local6.right = (_local5.bottom + ((isNaN(_local10)) ? _local7 : _local10));
            _local6.bottom = (_local5.bottom + ((isNaN(_local11)) ? ((((_local2) && (!(isNaN(_local9))))) ? _local9 : ((isNaN(_local8)) ? _local7 : _local8)) : _local11));
            oldHeaderHeight = _local3;
            if (!isNaN(_local3)){
                _local6.top = (_local6.top + _local3);
            };
            oldControlBarHeight = _local4;
            if (!isNaN(_local4)){
                _local6.bottom = (_local6.bottom + _local4);
            };
            _panelBorderMetrics = _local6;
            return (_panelBorderMetrics);
        }
        override mx_internal function drawBackground(_arg1:Number, _arg2:Number):void{
            var _local3:Array;
            var _local4:Number;
            super.drawBackground(_arg1, _arg2);
            if ((((getStyle("headerColors") == null)) && ((getStyle("borderStyle") == "default")))){
                _local3 = getStyle("highlightAlphas");
                _local4 = ((_local3) ? _local3[0] : 0.3);
                drawRoundRect(0, 0, _arg1, _arg2, {
                    tl:radius,
                    tr:radius,
                    bl:0,
                    br:0
                }, 0xFFFFFF, _local4, null, GradientType.LINEAR, null, {
                    x:0,
                    y:1,
                    w:_arg1,
                    h:(_arg2 - 1),
                    r:{
                        tl:radius,
                        tr:radius,
                        bl:0,
                        br:0
                    }
                });
            };
        }
        override mx_internal function getBackgroundColorMetrics():EdgeMetrics{
            if (getStyle("borderStyle") == "default"){
                return (EdgeMetrics.EMPTY);
            };
            return (super.borderMetrics);
        }

    }
}//package mx.skins.halo 
