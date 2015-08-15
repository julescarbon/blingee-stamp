package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.graphics.*;
    import mx.utils.*;
    import mx.skins.*;

    public class HaloBorder extends RectangularBorder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var BORDER_WIDTHS:Object = {
            none:0,
            solid:1,
            inset:2,
            outset:2,
            alert:3,
            dropdown:2,
            menuBorder:1,
            comboNonEdit:2
        };

        mx_internal var radiusObj:Object;
        mx_internal var backgroundHole:Object;
        mx_internal var radius:Number;
        mx_internal var bRoundedCorners:Boolean;
        mx_internal var backgroundColor:Object;
        private var dropShadow:RectangularDropShadow;
        protected var _borderMetrics:EdgeMetrics;
        mx_internal var backgroundAlphaName:String;

        public function HaloBorder(){
            BORDER_WIDTHS["default"] = 3;
        }
        override public function styleChanged(_arg1:String):void{
            if ((((((((((_arg1 == null)) || ((_arg1 == "styleName")))) || ((_arg1 == "borderStyle")))) || ((_arg1 == "borderThickness")))) || ((_arg1 == "borderSides")))){
                _borderMetrics = null;
            };
            invalidateDisplayList();
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            if (((isNaN(_arg1)) || (isNaN(_arg2)))){
                return;
            };
            super.updateDisplayList(_arg1, _arg2);
            backgroundColor = getBackgroundColor();
            bRoundedCorners = false;
            backgroundAlphaName = "backgroundAlpha";
            backgroundHole = null;
            radius = 0;
            radiusObj = null;
            drawBorder(_arg1, _arg2);
            drawBackground(_arg1, _arg2);
        }
        mx_internal function drawBorder(_arg1:Number, _arg2:Number):void{
            var _local5:Number;
            var _local6:uint;
            var _local7:uint;
            var _local8:String;
            var _local9:Number;
            var _local10:uint;
            var _local11:Boolean;
            var _local12:uint;
            var _local13:Array;
            var _local14:Array;
            var _local15:uint;
            var _local16:uint;
            var _local17:uint;
            var _local18:uint;
            var _local19:Boolean;
            var _local20:Object;
            var _local22:Number;
            var _local23:Number;
            var _local24:Number;
            var _local25:Object;
            var _local27:Number;
            var _local28:Number;
            var _local29:IContainer;
            var _local30:EdgeMetrics;
            var _local31:Boolean;
            var _local32:Number;
            var _local33:Array;
            var _local34:uint;
            var _local35:Boolean;
            var _local36:Number;
            var _local3:String = getStyle("borderStyle");
            var _local4:Array = getStyle("highlightAlphas");
            var _local21:Boolean;
            var _local26:Graphics = graphics;
            _local26.clear();
            if (_local3){
                switch (_local3){
                    case "none":
                        break;
                    case "inset":
                        _local7 = getStyle("borderColor");
                        _local22 = ColorUtil.adjustBrightness2(_local7, -40);
                        _local23 = ColorUtil.adjustBrightness2(_local7, 25);
                        _local24 = ColorUtil.adjustBrightness2(_local7, 40);
                        _local25 = backgroundColor;
                        if ((((_local25 === null)) || ((_local25 === "")))){
                            _local25 = _local7;
                        };
                        draw3dBorder(_local23, _local22, _local24, Number(_local25), Number(_local25), Number(_local25));
                        break;
                    case "outset":
                        _local7 = getStyle("borderColor");
                        _local22 = ColorUtil.adjustBrightness2(_local7, -40);
                        _local23 = ColorUtil.adjustBrightness2(_local7, -25);
                        _local24 = ColorUtil.adjustBrightness2(_local7, 40);
                        _local25 = backgroundColor;
                        if ((((_local25 === null)) || ((_local25 === "")))){
                            _local25 = _local7;
                        };
                        draw3dBorder(_local23, _local24, _local22, Number(_local25), Number(_local25), Number(_local25));
                        break;
                    case "alert":
                    case "default":
                        if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                            _local27 = getStyle("backgroundAlpha");
                            _local5 = getStyle("borderAlpha");
                            backgroundAlphaName = "borderAlpha";
                            radius = getStyle("cornerRadius");
                            bRoundedCorners = (getStyle("roundedBottomCorners").toString().toLowerCase() == "true");
                            _local28 = ((bRoundedCorners) ? radius : 0);
                            drawDropShadow(0, 0, _arg1, _arg2, radius, radius, _local28, _local28);
                            if (!bRoundedCorners){
                                radiusObj = {};
                            };
                            _local29 = (parent as IContainer);
                            if (_local29){
                                _local30 = _local29.viewMetrics;
                                backgroundHole = {
                                    x:_local30.left,
                                    y:_local30.top,
                                    w:Math.max(0, ((_arg1 - _local30.left) - _local30.right)),
                                    h:Math.max(0, ((_arg2 - _local30.top) - _local30.bottom)),
                                    r:0
                                };
                                if ((((backgroundHole.w > 0)) && ((backgroundHole.h > 0)))){
                                    if (_local27 != _local5){
                                        drawDropShadow(backgroundHole.x, backgroundHole.y, backgroundHole.w, backgroundHole.h, 0, 0, 0, 0);
                                    };
                                    _local26.beginFill(Number(backgroundColor), _local27);
                                    _local26.drawRect(backgroundHole.x, backgroundHole.y, backgroundHole.w, backgroundHole.h);
                                    _local26.endFill();
                                };
                            };
                            backgroundColor = getStyle("borderColor");
                        };
                        break;
                    case "dropdown":
                        _local12 = getStyle("dropdownBorderColor");
                        drawDropShadow(0, 0, _arg1, _arg2, 4, 0, 0, 4);
                        drawRoundRect(0, 0, _arg1, _arg2, {
                            tl:4,
                            tr:0,
                            br:0,
                            bl:4
                        }, 5068126, 1);
                        drawRoundRect(0, 0, _arg1, _arg2, {
                            tl:4,
                            tr:0,
                            br:0,
                            bl:4
                        }, [0xFFFFFF, 0xFFFFFF], [0.7, 0], verticalGradientMatrix(0, 0, _arg1, _arg2));
                        drawRoundRect(1, 1, (_arg1 - 1), (_arg2 - 2), {
                            tl:3,
                            tr:0,
                            br:0,
                            bl:3
                        }, 0xFFFFFF, 1);
                        drawRoundRect(1, 2, (_arg1 - 1), (_arg2 - 3), {
                            tl:3,
                            tr:0,
                            br:0,
                            bl:3
                        }, [0xEEEEEE, 0xFFFFFF], 1, verticalGradientMatrix(0, 0, (_arg1 - 1), (_arg2 - 3)));
                        if (!isNaN(_local12)){
                            drawRoundRect(0, 0, (_arg1 + 1), _arg2, {
                                tl:4,
                                tr:0,
                                br:0,
                                bl:4
                            }, _local12, 0.5);
                            drawRoundRect(1, 1, (_arg1 - 1), (_arg2 - 2), {
                                tl:3,
                                tr:0,
                                br:0,
                                bl:3
                            }, 0xFFFFFF, 1);
                            drawRoundRect(1, 2, (_arg1 - 1), (_arg2 - 3), {
                                tl:3,
                                tr:0,
                                br:0,
                                bl:3
                            }, [0xEEEEEE, 0xFFFFFF], 1, verticalGradientMatrix(0, 0, (_arg1 - 1), (_arg2 - 3)));
                        };
                        backgroundColor = null;
                        break;
                    case "menuBorder":
                        _local7 = getStyle("borderColor");
                        drawRoundRect(0, 0, _arg1, _arg2, 0, _local7, 1);
                        drawDropShadow(1, 1, (_arg1 - 2), (_arg2 - 2), 0, 0, 0, 0);
                        break;
                    case "comboNonEdit":
                        break;
                    case "controlBar":
                        if ((((_arg1 == 0)) || ((_arg2 == 0)))){
                            backgroundColor = null;
                            break;
                        };
                        _local14 = getStyle("footerColors");
                        _local31 = !((_local14 == null));
                        _local32 = getStyle("borderAlpha");
                        if (_local31){
                            _local26.lineStyle(0, (((_local14.length > 0)) ? _local14[1] : _local14[0]), _local32);
                            _local26.moveTo(0, 0);
                            _local26.lineTo(_arg1, 0);
                            _local26.lineStyle(0, 0, 0);
                            if (((((parent) && (parent.parent))) && ((parent.parent is IStyleClient)))){
                                radius = IStyleClient(parent.parent).getStyle("cornerRadius");
                                _local32 = IStyleClient(parent.parent).getStyle("borderAlpha");
                            };
                            if (isNaN(radius)){
                                radius = 0;
                            };
                            if (IStyleClient(parent.parent).getStyle("roundedBottomCorners").toString().toLowerCase() != "true"){
                                radius = 0;
                            };
                            drawRoundRect(0, 1, _arg1, (_arg2 - 1), {
                                tl:0,
                                tr:0,
                                bl:radius,
                                br:radius
                            }, _local14, _local32, verticalGradientMatrix(0, 0, _arg1, _arg2));
                            if ((((_local14.length > 1)) && (!((_local14[0] == _local14[1]))))){
                                drawRoundRect(0, 1, _arg1, (_arg2 - 1), {
                                    tl:0,
                                    tr:0,
                                    bl:radius,
                                    br:radius
                                }, [0xFFFFFF, 0xFFFFFF], _local4, verticalGradientMatrix(0, 0, _arg1, _arg2));
                                drawRoundRect(1, 2, (_arg1 - 2), (_arg2 - 3), {
                                    tl:0,
                                    tr:0,
                                    bl:(radius - 1),
                                    br:(radius - 1)
                                }, _local14, _local32, verticalGradientMatrix(0, 0, _arg1, _arg2));
                            };
                        };
                        backgroundColor = null;
                        break;
                    case "applicationControlBar":
                        _local13 = getStyle("fillColors");
                        _local5 = getStyle("backgroundAlpha");
                        _local4 = getStyle("highlightAlphas");
                        _local33 = getStyle("fillAlphas");
                        _local11 = getStyle("docked");
                        _local34 = uint(backgroundColor);
                        radius = getStyle("cornerRadius");
                        if (!radius){
                            radius = 0;
                        };
                        drawDropShadow(0, 1, _arg1, (_arg2 - 1), radius, radius, radius, radius);
                        if (((!((backgroundColor === null))) && (StyleManager.isValidStyleValue(backgroundColor)))){
                            drawRoundRect(0, 1, _arg1, (_arg2 - 1), radius, _local34, _local5, verticalGradientMatrix(0, 0, _arg1, _arg2));
                        };
                        drawRoundRect(0, 1, _arg1, (_arg2 - 1), radius, _local13, _local33, verticalGradientMatrix(0, 0, _arg1, _arg2));
                        drawRoundRect(0, 1, _arg1, ((_arg2 / 2) - 1), {
                            tl:radius,
                            tr:radius,
                            bl:0,
                            br:0
                        }, [0xFFFFFF, 0xFFFFFF], _local4, verticalGradientMatrix(0, 0, _arg1, ((_arg2 / 2) - 1)));
                        drawRoundRect(0, 1, _arg1, (_arg2 - 1), {
                            tl:radius,
                            tr:radius,
                            bl:0,
                            br:0
                        }, 0xFFFFFF, 0.3, null, GradientType.LINEAR, null, {
                            x:0,
                            y:2,
                            w:_arg1,
                            h:(_arg2 - 2),
                            r:{
                                tl:radius,
                                tr:radius,
                                bl:0,
                                br:0
                            }
                        });
                        backgroundColor = null;
                        break;
                    default:
                        _local7 = getStyle("borderColor");
                        _local9 = getStyle("borderThickness");
                        _local8 = getStyle("borderSides");
                        _local35 = true;
                        radius = getStyle("cornerRadius");
                        bRoundedCorners = (getStyle("roundedBottomCorners").toString().toLowerCase() == "true");
                        _local36 = Math.max((radius - _local9), 0);
                        _local20 = {
                            x:_local9,
                            y:_local9,
                            w:(_arg1 - (_local9 * 2)),
                            h:(_arg2 - (_local9 * 2)),
                            r:_local36
                        };
                        if (!bRoundedCorners){
                            radiusObj = {
                                tl:radius,
                                tr:radius,
                                bl:0,
                                br:0
                            };
                            _local20.r = {
                                tl:_local36,
                                tr:_local36,
                                bl:0,
                                br:0
                            };
                        };
                        if (_local8 != "left top right bottom"){
                            _local20.r = {
                                tl:_local36,
                                tr:_local36,
                                bl:((bRoundedCorners) ? _local36 : 0),
                                br:((bRoundedCorners) ? _local36 : 0)
                            };
                            radiusObj = {
                                tl:radius,
                                tr:radius,
                                bl:((bRoundedCorners) ? radius : 0),
                                br:((bRoundedCorners) ? radius : 0)
                            };
                            _local8 = _local8.toLowerCase();
                            if (_local8.indexOf("left") == -1){
                                _local20.x = 0;
                                _local20.w = (_local20.w + _local9);
                                _local20.r.tl = 0;
                                _local20.r.bl = 0;
                                radiusObj.tl = 0;
                                radiusObj.bl = 0;
                                _local35 = false;
                            };
                            if (_local8.indexOf("top") == -1){
                                _local20.y = 0;
                                _local20.h = (_local20.h + _local9);
                                _local20.r.tl = 0;
                                _local20.r.tr = 0;
                                radiusObj.tl = 0;
                                radiusObj.tr = 0;
                                _local35 = false;
                            };
                            if (_local8.indexOf("right") == -1){
                                _local20.w = (_local20.w + _local9);
                                _local20.r.tr = 0;
                                _local20.r.br = 0;
                                radiusObj.tr = 0;
                                radiusObj.br = 0;
                                _local35 = false;
                            };
                            if (_local8.indexOf("bottom") == -1){
                                _local20.h = (_local20.h + _local9);
                                _local20.r.bl = 0;
                                _local20.r.br = 0;
                                radiusObj.bl = 0;
                                radiusObj.br = 0;
                                _local35 = false;
                            };
                        };
                        if ((((radius == 0)) && (_local35))){
                            drawDropShadow(0, 0, _arg1, _arg2, 0, 0, 0, 0);
                            _local26.beginFill(_local7);
                            _local26.drawRect(0, 0, _arg1, _arg2);
                            _local26.drawRect(_local9, _local9, (_arg1 - (2 * _local9)), (_arg2 - (2 * _local9)));
                            _local26.endFill();
                        } else {
                            if (radiusObj){
                                drawDropShadow(0, 0, _arg1, _arg2, radiusObj.tl, radiusObj.tr, radiusObj.br, radiusObj.bl);
                                drawRoundRect(0, 0, _arg1, _arg2, radiusObj, _local7, 1, null, null, null, _local20);
                                radiusObj.tl = Math.max((radius - _local9), 0);
                                radiusObj.tr = Math.max((radius - _local9), 0);
                                radiusObj.bl = ((bRoundedCorners) ? Math.max((radius - _local9), 0) : 0);
                                radiusObj.br = ((bRoundedCorners) ? Math.max((radius - _local9), 0) : 0);
                            } else {
                                drawDropShadow(0, 0, _arg1, _arg2, radius, radius, radius, radius);
                                drawRoundRect(0, 0, _arg1, _arg2, radius, _local7, 1, null, null, null, _local20);
                                radius = Math.max((getStyle("cornerRadius") - _local9), 0);
                            };
                        };
                };
            };
        }
        mx_internal function drawBackground(_arg1:Number, _arg2:Number):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:EdgeMetrics;
            var _local7:Graphics;
            var _local8:Number;
            var _local9:Number;
            var _local10:Array;
            var _local11:Number;
            if (((((((!((backgroundColor === null))) && (!((backgroundColor === ""))))) || (getStyle("mouseShield")))) || (getStyle("mouseShieldChildren")))){
                _local4 = Number(backgroundColor);
                _local5 = 1;
                _local6 = getBackgroundColorMetrics();
                _local7 = graphics;
                if (((((isNaN(_local4)) || ((backgroundColor === "")))) || ((backgroundColor === null)))){
                    _local5 = 0;
                    _local4 = 0xFFFFFF;
                } else {
                    _local5 = getStyle(backgroundAlphaName);
                };
                if (((!((radius == 0))) || (backgroundHole))){
                    _local8 = _local6.bottom;
                    if (radiusObj){
                        _local9 = ((bRoundedCorners) ? radius : 0);
                        radiusObj = {
                            tl:radius,
                            tr:radius,
                            bl:_local9,
                            br:_local9
                        };
                        drawRoundRect(_local6.left, _local6.top, (width - (_local6.left + _local6.right)), (height - (_local6.top + _local8)), radiusObj, _local4, _local5, null, GradientType.LINEAR, null, backgroundHole);
                    } else {
                        drawRoundRect(_local6.left, _local6.top, (width - (_local6.left + _local6.right)), (height - (_local6.top + _local8)), radius, _local4, _local5, null, GradientType.LINEAR, null, backgroundHole);
                    };
                } else {
                    _local7.beginFill(_local4, _local5);
                    _local7.drawRect(_local6.left, _local6.top, ((_arg1 - _local6.right) - _local6.left), ((_arg2 - _local6.bottom) - _local6.top));
                    _local7.endFill();
                };
            };
            var _local3:String = getStyle("borderStyle");
            if ((((((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) && ((((_local3 == "alert")) || ((_local3 == "default")))))) && ((getStyle("headerColors") == null)))){
                _local10 = getStyle("highlightAlphas");
                _local11 = ((_local10) ? _local10[0] : 0.3);
                drawRoundRect(0, 0, _arg1, _arg2, {
                    tl:radius,
                    tr:radius,
                    bl:0,
                    br:0
                }, 0xFFFFFF, _local11, null, GradientType.LINEAR, null, {
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
        mx_internal function drawDropShadow(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:Number):void{
            var _local11:Number;
            var _local12:Boolean;
            if ((((((((getStyle("dropShadowEnabled") == false)) || ((getStyle("dropShadowEnabled") == "false")))) || ((_arg3 == 0)))) || ((_arg4 == 0)))){
                return;
            };
            var _local9:Number = getStyle("shadowDistance");
            var _local10:String = getStyle("shadowDirection");
            if (getStyle("borderStyle") == "applicationControlBar"){
                _local12 = getStyle("docked");
                _local11 = ((_local12) ? 90 : getDropShadowAngle(_local9, _local10));
                _local9 = Math.abs(_local9);
            } else {
                _local11 = getDropShadowAngle(_local9, _local10);
                _local9 = (Math.abs(_local9) + 2);
            };
            if (!dropShadow){
                dropShadow = new RectangularDropShadow();
            };
            dropShadow.distance = _local9;
            dropShadow.angle = _local11;
            dropShadow.color = getStyle("dropShadowColor");
            dropShadow.alpha = 0.4;
            dropShadow.tlRadius = _arg5;
            dropShadow.trRadius = _arg6;
            dropShadow.blRadius = _arg8;
            dropShadow.brRadius = _arg7;
            dropShadow.drawShadow(graphics, _arg1, _arg2, _arg3, _arg4);
        }
        mx_internal function getBackgroundColor():Object{
            var _local2:Object;
            var _local1:IUIComponent = (parent as IUIComponent);
            if (((_local1) && (!(_local1.enabled)))){
                _local2 = getStyle("backgroundDisabledColor");
                if (((!((_local2 === null))) && (StyleManager.isValidStyleValue(_local2)))){
                    return (_local2);
                };
            };
            return (getStyle("backgroundColor"));
        }
        mx_internal function draw3dBorder(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number):void{
            var _local7:Number = width;
            var _local8:Number = height;
            drawDropShadow(0, 0, width, height, 0, 0, 0, 0);
            var _local9:Graphics = graphics;
            _local9.beginFill(_arg1);
            _local9.drawRect(0, 0, _local7, _local8);
            _local9.drawRect(1, 0, (_local7 - 2), _local8);
            _local9.endFill();
            _local9.beginFill(_arg2);
            _local9.drawRect(1, 0, (_local7 - 2), 1);
            _local9.endFill();
            _local9.beginFill(_arg3);
            _local9.drawRect(1, (_local8 - 1), (_local7 - 2), 1);
            _local9.endFill();
            _local9.beginFill(_arg4);
            _local9.drawRect(1, 1, (_local7 - 2), 1);
            _local9.endFill();
            _local9.beginFill(_arg5);
            _local9.drawRect(1, (_local8 - 2), (_local7 - 2), 1);
            _local9.endFill();
            _local9.beginFill(_arg6);
            _local9.drawRect(1, 2, (_local7 - 2), (_local8 - 4));
            _local9.drawRect(2, 2, (_local7 - 4), (_local8 - 4));
            _local9.endFill();
        }
        mx_internal function getBackgroundColorMetrics():EdgeMetrics{
            return (borderMetrics);
        }
        mx_internal function getDropShadowAngle(_arg1:Number, _arg2:String):Number{
            if (_arg2 == "left"){
                return ((((_arg1 >= 0)) ? 135 : 225));
            };
            if (_arg2 == "right"){
                return ((((_arg1 >= 0)) ? 45 : 315));
            };
            return ((((_arg1 >= 0)) ? 90 : 270));
        }
        override public function get borderMetrics():EdgeMetrics{
            var _local1:Number;
            var _local3:String;
            if (_borderMetrics){
                return (_borderMetrics);
            };
            var _local2:String = getStyle("borderStyle");
            if ((((_local2 == "default")) || ((_local2 == "alert")))){
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    _borderMetrics = new EdgeMetrics(0, 0, 0, 0);
                } else {
                    return (EdgeMetrics.EMPTY);
                };
            } else {
                if ((((_local2 == "controlBar")) || ((_local2 == "applicationControlBar")))){
                    _borderMetrics = new EdgeMetrics(1, 1, 1, 1);
                } else {
                    if (_local2 == "solid"){
                        _local1 = getStyle("borderThickness");
                        if (isNaN(_local1)){
                            _local1 = 0;
                        };
                        _borderMetrics = new EdgeMetrics(_local1, _local1, _local1, _local1);
                        _local3 = getStyle("borderSides");
                        if (_local3 != "left top right bottom"){
                            if (_local3.indexOf("left") == -1){
                                _borderMetrics.left = 0;
                            };
                            if (_local3.indexOf("top") == -1){
                                _borderMetrics.top = 0;
                            };
                            if (_local3.indexOf("right") == -1){
                                _borderMetrics.right = 0;
                            };
                            if (_local3.indexOf("bottom") == -1){
                                _borderMetrics.bottom = 0;
                            };
                        };
                    } else {
                        _local1 = BORDER_WIDTHS[_local2];
                        if (isNaN(_local1)){
                            _local1 = 0;
                        };
                        _borderMetrics = new EdgeMetrics(_local1, _local1, _local1, _local1);
                    };
                };
            };
            return (_borderMetrics);
        }

    }
}//package mx.skins.halo 
