package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class HaloFocusRect extends ProgrammaticSkin implements IStyleClient {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _focusColor:Number;

        public function get inheritingStyles():Object{
            return (styleName.inheritingStyles);
        }
        public function set inheritingStyles(_arg1:Object):void{
        }
        public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
        }
        public function registerEffects(_arg1:Array):void{
        }
        public function regenerateStyleCache(_arg1:Boolean):void{
        }
        public function get styleDeclaration():CSSStyleDeclaration{
            return (CSSStyleDeclaration(styleName));
        }
        public function getClassStyleDeclarations():Array{
            return ([]);
        }
        public function get className():String{
            return ("HaloFocusRect");
        }
        public function clearStyle(_arg1:String):void{
            if (_arg1 == "focusColor"){
                _focusColor = NaN;
            };
        }
        public function setStyle(_arg1:String, _arg2):void{
            if (_arg1 == "focusColor"){
                _focusColor = _arg2;
            };
        }
        public function set nonInheritingStyles(_arg1:Object):void{
        }
        public function get nonInheritingStyles():Object{
            return (styleName.nonInheritingStyles);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:String = getStyle("focusBlendMode");
            var _local4:Number = getStyle("focusAlpha");
            var _local5:Number = getStyle("focusColor");
            var _local6:Number = getStyle("cornerRadius");
            var _local7:Number = getStyle("focusThickness");
            var _local8:String = getStyle("focusRoundedCorners");
            var _local9:Number = getStyle("themeColor");
            var _local10:Number = _local5;
            if (isNaN(_local10)){
                _local10 = _local9;
            };
            var _local11:Graphics = graphics;
            _local11.clear();
            blendMode = _local3;
            if (((!((_local8 == "tl tr bl br"))) && ((_local6 > 0)))){
                _local12 = 0;
                _local13 = 0;
                _local14 = 0;
                _local15 = 0;
                _local16 = (_local6 + _local7);
                if (_local8.indexOf("tl") >= 0){
                    _local12 = _local16;
                };
                if (_local8.indexOf("tr") >= 0){
                    _local14 = _local16;
                };
                if (_local8.indexOf("bl") >= 0){
                    _local13 = _local16;
                };
                if (_local8.indexOf("br") >= 0){
                    _local15 = _local16;
                };
                _local11.beginFill(_local10, _local4);
                GraphicsUtil.drawRoundRectComplex(_local11, 0, 0, _arg1, _arg2, _local12, _local14, _local13, _local15);
                _local12 = ((_local12) ? _local6 : 0);
                _local14 = ((_local14) ? _local6 : 0);
                _local13 = ((_local13) ? _local6 : 0);
                _local15 = ((_local15) ? _local6 : 0);
                GraphicsUtil.drawRoundRectComplex(_local11, _local7, _local7, (_arg1 - (2 * _local7)), (_arg2 - (2 * _local7)), _local12, _local14, _local13, _local15);
                _local11.endFill();
                _local16 = (_local6 + (_local7 / 2));
                _local12 = ((_local12) ? _local16 : 0);
                _local14 = ((_local14) ? _local16 : 0);
                _local13 = ((_local13) ? _local16 : 0);
                _local15 = ((_local15) ? _local16 : 0);
                _local11.beginFill(_local10, _local4);
                GraphicsUtil.drawRoundRectComplex(_local11, (_local7 / 2), (_local7 / 2), (_arg1 - _local7), (_arg2 - _local7), _local12, _local14, _local13, _local15);
                _local12 = ((_local12) ? _local6 : 0);
                _local14 = ((_local14) ? _local6 : 0);
                _local13 = ((_local13) ? _local6 : 0);
                _local15 = ((_local15) ? _local6 : 0);
                GraphicsUtil.drawRoundRectComplex(_local11, _local7, _local7, (_arg1 - (2 * _local7)), (_arg2 - (2 * _local7)), _local12, _local14, _local13, _local15);
                _local11.endFill();
            } else {
                _local11.beginFill(_local10, _local4);
                _local17 = ((((_local6 > 0)) ? (_local6 + _local7) : 0) * 2);
                _local11.drawRoundRect(0, 0, _arg1, _arg2, _local17, _local17);
                _local17 = (_local6 * 2);
                _local11.drawRoundRect(_local7, _local7, (_arg1 - (2 * _local7)), (_arg2 - (2 * _local7)), _local17, _local17);
                _local11.endFill();
                _local11.beginFill(_local10, _local4);
                _local17 = ((((_local6 > 0)) ? (_local6 + (_local7 / 2)) : 0) * 2);
                _local11.drawRoundRect((_local7 / 2), (_local7 / 2), (_arg1 - _local7), (_arg2 - _local7), _local17, _local17);
                _local17 = (_local6 * 2);
                _local11.drawRoundRect(_local7, _local7, (_arg1 - (2 * _local7)), (_arg2 - (2 * _local7)), _local17, _local17);
                _local11.endFill();
            };
        }
        override public function getStyle(_arg1:String){
            return ((((_arg1 == "focusColor")) ? _focusColor : super.getStyle(_arg1)));
        }
        public function set styleDeclaration(_arg1:CSSStyleDeclaration):void{
        }

    }
}//package mx.skins.halo 
