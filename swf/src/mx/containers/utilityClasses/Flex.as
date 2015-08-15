package mx.containers.utilityClasses {
    import mx.core.*;

    public class Flex {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function flexChildWidthsProportionally(_arg1:Container, _arg2:Number, _arg3:Number):Number{
            var _local6:Array;
            var _local7:FlexChildInfo;
            var _local8:IUIComponent;
            var _local9:int;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local4:Number = _arg2;
            var _local5:Number = 0;
            _local6 = [];
            var _local10:int = _arg1.numChildren;
            _local9 = 0;
            while (_local9 < _local10) {
                _local8 = IUIComponent(_arg1.getChildAt(_local9));
                _local11 = _local8.percentWidth;
                _local12 = _local8.percentHeight;
                if (((!(isNaN(_local12))) && (_local8.includeInLayout))){
                    _local13 = Math.max(_local8.minHeight, Math.min(_local8.maxHeight, ((_local12)>=100) ? _arg3 : ((_arg3 * _local12) / 100)));
                } else {
                    _local13 = _local8.getExplicitOrMeasuredHeight();
                };
                if (((!(isNaN(_local11))) && (_local8.includeInLayout))){
                    _local5 = (_local5 + _local11);
                    _local7 = new FlexChildInfo();
                    _local7.percent = _local11;
                    _local7.min = _local8.minWidth;
                    _local7.max = _local8.maxWidth;
                    _local7.height = _local13;
                    _local7.child = _local8;
                    _local6.push(_local7);
                } else {
                    _local14 = _local8.getExplicitOrMeasuredWidth();
                    if ((((_local8.scaleX == 1)) && ((_local8.scaleY == 1)))){
                        _local8.setActualSize(Math.floor(_local14), Math.floor(_local13));
                    } else {
                        _local8.setActualSize(_local14, _local13);
                    };
                    if (_local8.includeInLayout){
                        _local4 = (_local4 - _local8.width);
                    };
                };
                _local9++;
            };
            if (_local5){
                _local4 = flexChildrenProportionally(_arg2, _local4, _local5, _local6);
                _local10 = _local6.length;
                _local9 = 0;
                while (_local9 < _local10) {
                    _local7 = _local6[_local9];
                    _local8 = _local7.child;
                    if ((((_local8.scaleX == 1)) && ((_local8.scaleY == 1)))){
                        _local8.setActualSize(Math.floor(_local7.size), Math.floor(_local7.height));
                    } else {
                        _local8.setActualSize(_local7.size, _local7.height);
                    };
                    _local9++;
                };
                if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                    distributeExtraWidth(_arg1, _arg2);
                };
            };
            return (_local4);
        }
        public static function distributeExtraHeight(_arg1:Container, _arg2:Number):void{
            var _local5:int;
            var _local6:Number;
            var _local9:IUIComponent;
            var _local10:Number;
            var _local11:Number;
            var _local3:int = _arg1.numChildren;
            var _local4:Boolean;
            var _local7:Number = _arg2;
            var _local8:Number = 0;
            _local5 = 0;
            while (_local5 < _local3) {
                _local9 = IUIComponent(_arg1.getChildAt(_local5));
                if (!_local9.includeInLayout){
                } else {
                    _local10 = _local9.height;
                    _local6 = _local9.percentHeight;
                    _local8 = (_local8 + _local10);
                    if (!isNaN(_local6)){
                        _local11 = Math.ceil(((_local6 / 100) * _arg2));
                        if (_local11 > _local10){
                            _local4 = true;
                        };
                    };
                };
                _local5++;
            };
            if (!_local4){
                return;
            };
            _local7 = (_local7 - _local8);
            var _local12:Boolean;
            while (((_local12) && ((_local7 > 0)))) {
                _local12 = false;
                _local5 = 0;
                while (_local5 < _local3) {
                    _local9 = IUIComponent(_arg1.getChildAt(_local5));
                    _local10 = _local9.height;
                    _local6 = _local9.percentHeight;
                    if (((((!(isNaN(_local6))) && (_local9.includeInLayout))) && ((_local10 < _local9.maxHeight)))){
                        _local11 = Math.ceil(((_local6 / 100) * _arg2));
                        if (_local11 > _local10){
                            _local9.setActualSize(_local9.width, (_local10 + 1));
                            _local7--;
                            _local12 = true;
                            if (_local7 == 0){
                                return;
                            };
                        };
                    };
                    _local5++;
                };
            };
        }
        public static function distributeExtraWidth(_arg1:Container, _arg2:Number):void{
            var _local5:int;
            var _local6:Number;
            var _local9:IUIComponent;
            var _local10:Number;
            var _local11:Number;
            var _local3:int = _arg1.numChildren;
            var _local4:Boolean;
            var _local7:Number = _arg2;
            var _local8:Number = 0;
            _local5 = 0;
            while (_local5 < _local3) {
                _local9 = IUIComponent(_arg1.getChildAt(_local5));
                if (!_local9.includeInLayout){
                } else {
                    _local10 = _local9.width;
                    _local6 = _local9.percentWidth;
                    _local8 = (_local8 + _local10);
                    if (!isNaN(_local6)){
                        _local11 = Math.ceil(((_local6 / 100) * _arg2));
                        if (_local11 > _local10){
                            _local4 = true;
                        };
                    };
                };
                _local5++;
            };
            if (!_local4){
                return;
            };
            _local7 = (_local7 - _local8);
            var _local12:Boolean;
            while (((_local12) && ((_local7 > 0)))) {
                _local12 = false;
                _local5 = 0;
                while (_local5 < _local3) {
                    _local9 = IUIComponent(_arg1.getChildAt(_local5));
                    _local10 = _local9.width;
                    _local6 = _local9.percentWidth;
                    if (((((!(isNaN(_local6))) && (_local9.includeInLayout))) && ((_local10 < _local9.maxWidth)))){
                        _local11 = Math.ceil(((_local6 / 100) * _arg2));
                        if (_local11 > _local10){
                            _local9.setActualSize((_local10 + 1), _local9.height);
                            _local7--;
                            _local12 = true;
                            if (_local7 == 0){
                                return;
                            };
                        };
                    };
                    _local5++;
                };
            };
        }
        public static function flexChildrenProportionally(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Array):Number{
            var _local6:Number;
            var _local7:Boolean;
            var _local9:*;
            var _local10:*;
            var _local11:*;
            var _local12:*;
            var _local13:*;
            var _local14:*;
            var _local5:int = _arg4.length;
            var _local8:Number = (_arg2 - ((_arg1 * _arg3) / 100));
            if (_local8 > 0){
                _arg2 = (_arg2 - _local8);
            };
            do  {
                _local6 = 0;
                _local7 = true;
                _local9 = (_arg2 / _arg3);
                _local10 = 0;
                while (_local10 < _local5) {
                    _local11 = _arg4[_local10];
                    _local12 = (_local11.percent * _local9);
                    if (_local12 < _local11.min){
                        _local13 = _local11.min;
                        _local11.size = _local13;
                        --_local5;
                        _arg4[_local10] = _arg4[_local5];
                        _arg4[_local5] = _local11;
                        _arg3 = (_arg3 - _local11.percent);
                        _arg2 = (_arg2 - _local13);
                        _local7 = false;
                        break;
                    };
                    if (_local12 > _local11.max){
                        _local14 = _local11.max;
                        _local11.size = _local14;
                        --_local5;
                        _arg4[_local10] = _arg4[_local5];
                        _arg4[_local5] = _local11;
                        _arg3 = (_arg3 - _local11.percent);
                        _arg2 = (_arg2 - _local14);
                        _local7 = false;
                        break;
                    };
                    _local11.size = _local12;
                    _local6 = (_local6 + _local12);
                    _local10++;
                };
            } while (!(_local7));
            return (Math.max(0, Math.floor((_arg2 - _local6))));
        }
        public static function flexChildHeightsProportionally(_arg1:Container, _arg2:Number, _arg3:Number):Number{
            var _local7:FlexChildInfo;
            var _local8:IUIComponent;
            var _local9:int;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local4:Number = _arg2;
            var _local5:Number = 0;
            var _local6:Array = [];
            var _local10:int = _arg1.numChildren;
            _local9 = 0;
            while (_local9 < _local10) {
                _local8 = IUIComponent(_arg1.getChildAt(_local9));
                _local11 = _local8.percentWidth;
                _local12 = _local8.percentHeight;
                if (((!(isNaN(_local11))) && (_local8.includeInLayout))){
                    _local13 = Math.max(_local8.minWidth, Math.min(_local8.maxWidth, ((_local11)>=100) ? _arg3 : ((_arg3 * _local11) / 100)));
                } else {
                    _local13 = _local8.getExplicitOrMeasuredWidth();
                };
                if (((!(isNaN(_local12))) && (_local8.includeInLayout))){
                    _local5 = (_local5 + _local12);
                    _local7 = new FlexChildInfo();
                    _local7.percent = _local12;
                    _local7.min = _local8.minHeight;
                    _local7.max = _local8.maxHeight;
                    _local7.width = _local13;
                    _local7.child = _local8;
                    _local6.push(_local7);
                } else {
                    _local14 = _local8.getExplicitOrMeasuredHeight();
                    if ((((_local8.scaleX == 1)) && ((_local8.scaleY == 1)))){
                        _local8.setActualSize(Math.floor(_local13), Math.floor(_local14));
                    } else {
                        _local8.setActualSize(_local13, _local14);
                    };
                    if (_local8.includeInLayout){
                        _local4 = (_local4 - _local8.height);
                    };
                };
                _local9++;
            };
            if (_local5){
                _local4 = flexChildrenProportionally(_arg2, _local4, _local5, _local6);
                _local10 = _local6.length;
                _local9 = 0;
                while (_local9 < _local10) {
                    _local7 = _local6[_local9];
                    _local8 = _local7.child;
                    if ((((_local8.scaleX == 1)) && ((_local8.scaleY == 1)))){
                        _local8.setActualSize(Math.floor(_local7.width), Math.floor(_local7.size));
                    } else {
                        _local8.setActualSize(_local7.width, _local7.size);
                    };
                    _local9++;
                };
                if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                    distributeExtraHeight(_arg1, _arg2);
                };
            };
            return (_local4);
        }

    }
}//package mx.containers.utilityClasses 
