package mx.graphics {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.utils.*;
    import flash.filters.*;

    public class RectangularDropShadow {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var leftShadow:BitmapData;
        private var _tlRadius:Number = 0;
        private var _trRadius:Number = 0;
        private var _angle:Number = 45;
        private var topShadow:BitmapData;
        private var _distance:Number = 4;
        private var rightShadow:BitmapData;
        private var _alpha:Number = 0.4;
        private var shadow:BitmapData;
        private var _brRadius:Number = 0;
        private var _blRadius:Number = 0;
        private var _color:int = 0;
        private var bottomShadow:BitmapData;
        private var changed:Boolean = true;

        public function get blRadius():Number{
            return (_blRadius);
        }
        public function set brRadius(_arg1:Number):void{
            if (_brRadius != _arg1){
                _brRadius = _arg1;
                changed = true;
            };
        }
        public function set color(_arg1:int):void{
            if (_color != _arg1){
                _color = _arg1;
                changed = true;
            };
        }
        public function drawShadow(_arg1:Graphics, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number):void{
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            var _local18:Number;
            var _local19:Number;
            var _local20:Number;
            var _local21:Number;
            var _local22:Number;
            if (changed){
                createShadowBitmaps();
                changed = false;
            };
            _arg4 = Math.ceil(_arg4);
            _arg5 = Math.ceil(_arg5);
            var _local6:int = ((leftShadow) ? leftShadow.width : 0);
            var _local7:int = ((rightShadow) ? rightShadow.width : 0);
            var _local8:int = ((topShadow) ? topShadow.height : 0);
            var _local9:int = ((bottomShadow) ? bottomShadow.height : 0);
            var _local10:int = (_local6 + _local7);
            var _local11:int = (_local8 + _local9);
            var _local12:Number = ((_arg5 + _local11) / 2);
            var _local13:Number = ((_arg4 + _local10) / 2);
            var _local14:Matrix = new Matrix();
            if (((leftShadow) || (topShadow))){
                _local15 = Math.min((tlRadius + _local10), _local13);
                _local16 = Math.min((tlRadius + _local11), _local12);
                _local14.tx = (_arg2 - _local6);
                _local14.ty = (_arg3 - _local8);
                _arg1.beginBitmapFill(shadow, _local14);
                _arg1.drawRect((_arg2 - _local6), (_arg3 - _local8), _local15, _local16);
                _arg1.endFill();
            };
            if (((rightShadow) || (topShadow))){
                _local17 = Math.min((trRadius + _local10), _local13);
                _local18 = Math.min((trRadius + _local11), _local12);
                _local14.tx = (((_arg2 + _arg4) + _local7) - shadow.width);
                _local14.ty = (_arg3 - _local8);
                _arg1.beginBitmapFill(shadow, _local14);
                _arg1.drawRect((((_arg2 + _arg4) + _local7) - _local17), (_arg3 - _local8), _local17, _local18);
                _arg1.endFill();
            };
            if (((leftShadow) || (bottomShadow))){
                _local19 = Math.min((blRadius + _local10), _local13);
                _local20 = Math.min((blRadius + _local11), _local12);
                _local14.tx = (_arg2 - _local6);
                _local14.ty = (((_arg3 + _arg5) + _local9) - shadow.height);
                _arg1.beginBitmapFill(shadow, _local14);
                _arg1.drawRect((_arg2 - _local6), (((_arg3 + _arg5) + _local9) - _local20), _local19, _local20);
                _arg1.endFill();
            };
            if (((rightShadow) || (bottomShadow))){
                _local21 = Math.min((brRadius + _local10), _local13);
                _local22 = Math.min((brRadius + _local11), _local12);
                _local14.tx = (((_arg2 + _arg4) + _local7) - shadow.width);
                _local14.ty = (((_arg3 + _arg5) + _local9) - shadow.height);
                _arg1.beginBitmapFill(shadow, _local14);
                _arg1.drawRect((((_arg2 + _arg4) + _local7) - _local21), (((_arg3 + _arg5) + _local9) - _local22), _local21, _local22);
                _arg1.endFill();
            };
            if (leftShadow){
                _local14.tx = (_arg2 - _local6);
                _local14.ty = 0;
                _arg1.beginBitmapFill(leftShadow, _local14);
                _arg1.drawRect((_arg2 - _local6), ((_arg3 - _local8) + _local16), _local6, ((((_arg5 + _local8) + _local9) - _local16) - _local20));
                _arg1.endFill();
            };
            if (rightShadow){
                _local14.tx = (_arg2 + _arg4);
                _local14.ty = 0;
                _arg1.beginBitmapFill(rightShadow, _local14);
                _arg1.drawRect((_arg2 + _arg4), ((_arg3 - _local8) + _local18), _local7, ((((_arg5 + _local8) + _local9) - _local18) - _local22));
                _arg1.endFill();
            };
            if (topShadow){
                _local14.tx = 0;
                _local14.ty = (_arg3 - _local8);
                _arg1.beginBitmapFill(topShadow, _local14);
                _arg1.drawRect(((_arg2 - _local6) + _local15), (_arg3 - _local8), ((((_arg4 + _local6) + _local7) - _local15) - _local17), _local8);
                _arg1.endFill();
            };
            if (bottomShadow){
                _local14.tx = 0;
                _local14.ty = (_arg3 + _arg5);
                _arg1.beginBitmapFill(bottomShadow, _local14);
                _arg1.drawRect(((_arg2 - _local6) + _local19), (_arg3 + _arg5), ((((_arg4 + _local6) + _local7) - _local19) - _local21), _local9);
                _arg1.endFill();
            };
        }
        public function get brRadius():Number{
            return (_brRadius);
        }
        public function get angle():Number{
            return (_angle);
        }
        private function createShadowBitmaps():void{
            var _local1:Number = ((Math.max(tlRadius, blRadius) + (2 * distance)) + Math.max(trRadius, brRadius));
            var _local2:Number = ((Math.max(tlRadius, trRadius) + (2 * distance)) + Math.max(blRadius, brRadius));
            if ((((_local1 < 0)) || ((_local2 < 0)))){
                return;
            };
            var _local3:Shape = new FlexShape();
            var _local4:Graphics = _local3.graphics;
            _local4.beginFill(0xFFFFFF);
            GraphicsUtil.drawRoundRectComplex(_local4, 0, 0, _local1, _local2, tlRadius, trRadius, blRadius, brRadius);
            _local4.endFill();
            var _local5:BitmapData = new BitmapData(_local1, _local2, true, 0);
            _local5.draw(_local3, new Matrix());
            var _local6:DropShadowFilter = new DropShadowFilter(distance, angle, color, alpha);
            _local6.knockout = true;
            var _local7:Rectangle = new Rectangle(0, 0, _local1, _local2);
            var _local8:Rectangle = _local5.generateFilterRect(_local7, _local6);
            var _local9:Number = (_local7.left - _local8.left);
            var _local10:Number = (_local8.right - _local7.right);
            var _local11:Number = (_local7.top - _local8.top);
            var _local12:Number = (_local8.bottom - _local7.bottom);
            shadow = new BitmapData(_local8.width, _local8.height);
            shadow.applyFilter(_local5, _local7, new Point(_local9, _local11), _local6);
            var _local13:Point = new Point(0, 0);
            var _local14:Rectangle = new Rectangle();
            if (_local9 > 0){
                _local14.x = 0;
                _local14.y = ((tlRadius + _local11) + _local12);
                _local14.width = _local9;
                _local14.height = 1;
                leftShadow = new BitmapData(_local9, 1);
                leftShadow.copyPixels(shadow, _local14, _local13);
            } else {
                leftShadow = null;
            };
            if (_local10 > 0){
                _local14.x = (shadow.width - _local10);
                _local14.y = ((trRadius + _local11) + _local12);
                _local14.width = _local10;
                _local14.height = 1;
                rightShadow = new BitmapData(_local10, 1);
                rightShadow.copyPixels(shadow, _local14, _local13);
            } else {
                rightShadow = null;
            };
            if (_local11 > 0){
                _local14.x = ((tlRadius + _local9) + _local10);
                _local14.y = 0;
                _local14.width = 1;
                _local14.height = _local11;
                topShadow = new BitmapData(1, _local11);
                topShadow.copyPixels(shadow, _local14, _local13);
            } else {
                topShadow = null;
            };
            if (_local12 > 0){
                _local14.x = ((blRadius + _local9) + _local10);
                _local14.y = (shadow.height - _local12);
                _local14.width = 1;
                _local14.height = _local12;
                bottomShadow = new BitmapData(1, _local12);
                bottomShadow.copyPixels(shadow, _local14, _local13);
            } else {
                bottomShadow = null;
            };
        }
        public function get alpha():Number{
            return (_alpha);
        }
        public function get color():int{
            return (_color);
        }
        public function set angle(_arg1:Number):void{
            if (_angle != _arg1){
                _angle = _arg1;
                changed = true;
            };
        }
        public function set trRadius(_arg1:Number):void{
            if (_trRadius != _arg1){
                _trRadius = _arg1;
                changed = true;
            };
        }
        public function set tlRadius(_arg1:Number):void{
            if (_tlRadius != _arg1){
                _tlRadius = _arg1;
                changed = true;
            };
        }
        public function get trRadius():Number{
            return (_trRadius);
        }
        public function set distance(_arg1:Number):void{
            if (_distance != _arg1){
                _distance = _arg1;
                changed = true;
            };
        }
        public function get distance():Number{
            return (_distance);
        }
        public function get tlRadius():Number{
            return (_tlRadius);
        }
        public function set alpha(_arg1:Number):void{
            if (_alpha != _arg1){
                _alpha = _arg1;
                changed = true;
            };
        }
        public function set blRadius(_arg1:Number):void{
            if (_blRadius != _arg1){
                _blRadius = _arg1;
                changed = true;
            };
        }

    }
}//package mx.graphics 
