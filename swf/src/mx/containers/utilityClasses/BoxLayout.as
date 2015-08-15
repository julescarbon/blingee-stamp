package mx.containers.utilityClasses {
    import mx.core.*;
    import mx.controls.scrollClasses.*;
    import mx.containers.*;

    public class BoxLayout extends Layout {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var direction:String = "vertical";

        private function isVertical():Boolean{
            return (!((direction == BoxDirection.HORIZONTAL)));
        }
        mx_internal function getHorizontalAlignValue():Number{
            var _local1:String = target.getStyle("horizontalAlign");
            if (_local1 == "center"){
                return (0.5);
            };
            if (_local1 == "right"){
                return (1);
            };
            return (0);
        }
        override public function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local16:Number;
            var _local17:int;
            var _local18:Number;
            var _local19:Number;
            var _local20:Number;
            var _local21:int;
            var _local22:IUIComponent;
            var _local23:IUIComponent;
            var _local24:Number;
            var _local25:Number;
            var _local26:Number;
            var _local27:Number;
            var _local3:Container = super.target;
            var _local4:int = _local3.numChildren;
            if (_local4 == 0){
                return;
            };
            var _local5:EdgeMetrics = _local3.viewMetricsAndPadding;
            var _local6:Number = _local3.getStyle("paddingLeft");
            var _local7:Number = _local3.getStyle("paddingTop");
            var _local8:Number = getHorizontalAlignValue();
            var _local9:Number = getVerticalAlignValue();
            var _local10:Number = (((((_local3.scaleX > 0)) && (!((_local3.scaleX == 1))))) ? (_local3.minWidth / Math.abs(_local3.scaleX)) : _local3.minWidth);
            var _local11:Number = (((((_local3.scaleY > 0)) && (!((_local3.scaleY == 1))))) ? (_local3.minHeight / Math.abs(_local3.scaleY)) : _local3.minHeight);
            var _local12:Number = ((Math.max(_arg1, _local10) - _local5.right) - _local5.left);
            var _local13:Number = ((Math.max(_arg2, _local11) - _local5.bottom) - _local5.top);
            var _local14:ScrollBar = _local3.horizontalScrollBar;
            var _local15:ScrollBar = _local3.verticalScrollBar;
            if (_local4 == 1){
                _local23 = IUIComponent(_local3.getChildAt(0));
                _local24 = _local23.percentWidth;
                _local25 = _local23.percentHeight;
                if (_local24){
                    _local26 = Math.max(_local23.minWidth, Math.min(_local23.maxWidth, ((_local24)>=100) ? _local12 : ((_local12 * _local24) / 100)));
                } else {
                    _local26 = _local23.getExplicitOrMeasuredWidth();
                };
                if (_local25){
                    _local27 = Math.max(_local23.minHeight, Math.min(_local23.maxHeight, ((_local25)>=100) ? _local13 : ((_local13 * _local25) / 100)));
                } else {
                    _local27 = _local23.getExplicitOrMeasuredHeight();
                };
                if ((((_local23.scaleX == 1)) && ((_local23.scaleY == 1)))){
                    _local23.setActualSize(Math.floor(_local26), Math.floor(_local27));
                } else {
                    _local23.setActualSize(_local26, _local27);
                };
                if (((!((_local15 == null))) && ((_local3.verticalScrollPolicy == ScrollPolicy.AUTO)))){
                    _local12 = (_local12 + _local15.minWidth);
                };
                if (((!((_local14 == null))) && ((_local3.horizontalScrollPolicy == ScrollPolicy.AUTO)))){
                    _local13 = (_local13 + _local14.minHeight);
                };
                _local20 = (((_local12 - _local23.width) * _local8) + _local6);
                _local19 = (((_local13 - _local23.height) * _local9) + _local7);
                _local23.move(Math.floor(_local20), Math.floor(_local19));
            } else {
                if (isVertical()){
                    _local16 = _local3.getStyle("verticalGap");
                    _local17 = _local4;
                    _local21 = 0;
                    while (_local21 < _local4) {
                        if (!IUIComponent(_local3.getChildAt(_local21)).includeInLayout){
                            _local17--;
                        };
                        _local21++;
                    };
                    _local18 = Flex.flexChildHeightsProportionally(_local3, (_local13 - ((_local17 - 1) * _local16)), _local12);
                    if (((!((_local14 == null))) && ((_local3.horizontalScrollPolicy == ScrollPolicy.AUTO)))){
                        _local18 = (_local18 + _local14.minHeight);
                    };
                    if (((!((_local15 == null))) && ((_local3.verticalScrollPolicy == ScrollPolicy.AUTO)))){
                        _local12 = (_local12 + _local15.minWidth);
                    };
                    _local19 = (_local7 + (_local18 * _local9));
                    _local21 = 0;
                    while (_local21 < _local4) {
                        _local22 = IUIComponent(_local3.getChildAt(_local21));
                        _local20 = (((_local12 - _local22.width) * _local8) + _local6);
                        _local22.move(Math.floor(_local20), Math.floor(_local19));
                        if (_local22.includeInLayout){
                            _local19 = (_local19 + (_local22.height + _local16));
                        };
                        _local21++;
                    };
                } else {
                    _local16 = _local3.getStyle("horizontalGap");
                    _local17 = _local4;
                    _local21 = 0;
                    while (_local21 < _local4) {
                        if (!IUIComponent(_local3.getChildAt(_local21)).includeInLayout){
                            _local17--;
                        };
                        _local21++;
                    };
                    _local18 = Flex.flexChildWidthsProportionally(_local3, (_local12 - ((_local17 - 1) * _local16)), _local13);
                    if (((!((_local14 == null))) && ((_local3.horizontalScrollPolicy == ScrollPolicy.AUTO)))){
                        _local13 = (_local13 + _local14.minHeight);
                    };
                    if (((!((_local15 == null))) && ((_local3.verticalScrollPolicy == ScrollPolicy.AUTO)))){
                        _local18 = (_local18 + _local15.minWidth);
                    };
                    _local20 = (_local6 + (_local18 * _local8));
                    _local21 = 0;
                    while (_local21 < _local4) {
                        _local22 = IUIComponent(_local3.getChildAt(_local21));
                        _local19 = (((_local13 - _local22.height) * _local9) + _local7);
                        _local22.move(Math.floor(_local20), Math.floor(_local19));
                        if (_local22.includeInLayout){
                            _local20 = (_local20 + (_local22.width + _local16));
                        };
                        _local21++;
                    };
                };
            };
        }
        mx_internal function getVerticalAlignValue():Number{
            var _local1:String = target.getStyle("verticalAlign");
            if (_local1 == "middle"){
                return (0.5);
            };
            if (_local1 == "bottom"){
                return (1);
            };
            return (0);
        }
        mx_internal function heightPadding(_arg1:Number):Number{
            var _local2:EdgeMetrics = target.viewMetricsAndPadding;
            var _local3:Number = (_local2.top + _local2.bottom);
            if ((((_arg1 > 1)) && (isVertical()))){
                _local3 = (_local3 + (target.getStyle("verticalGap") * (_arg1 - 1)));
            };
            return (_local3);
        }
        mx_internal function widthPadding(_arg1:Number):Number{
            var _local2:EdgeMetrics = target.viewMetricsAndPadding;
            var _local3:Number = (_local2.left + _local2.right);
            if ((((_arg1 > 1)) && ((isVertical() == false)))){
                _local3 = (_local3 + (target.getStyle("horizontalGap") * (_arg1 - 1)));
            };
            return (_local3);
        }
        override public function measure():void{
            var _local1:Container;
            var _local10:Number;
            var _local11:Number;
            var _local12:IUIComponent;
            var _local13:Number;
            var _local14:Number;
            _local1 = super.target;
            var _local2:Boolean = isVertical();
            var _local3:Number = 0;
            var _local4:Number = 0;
            var _local5:Number = 0;
            var _local6:Number = 0;
            var _local7:int = _local1.numChildren;
            var _local8:int = _local7;
            var _local9:int;
            while (_local9 < _local7) {
                _local12 = IUIComponent(_local1.getChildAt(_local9));
                if (!_local12.includeInLayout){
                    _local8--;
                } else {
                    _local13 = _local12.getExplicitOrMeasuredWidth();
                    _local14 = _local12.getExplicitOrMeasuredHeight();
                    if (_local2){
                        _local3 = Math.max(((isNaN(_local12.percentWidth)) ? _local13 : _local12.minWidth), _local3);
                        _local5 = Math.max(_local13, _local5);
                        _local4 = (_local4 + ((isNaN(_local12.percentHeight)) ? _local14 : _local12.minHeight));
                        _local6 = (_local6 + _local14);
                    } else {
                        _local3 = (_local3 + ((isNaN(_local12.percentWidth)) ? _local13 : _local12.minWidth));
                        _local5 = (_local5 + _local13);
                        _local4 = Math.max(((isNaN(_local12.percentHeight)) ? _local14 : _local12.minHeight), _local4);
                        _local6 = Math.max(_local14, _local6);
                    };
                };
                _local9++;
            };
            _local10 = widthPadding(_local8);
            _local11 = heightPadding(_local8);
            _local1.measuredMinWidth = (_local3 + _local10);
            _local1.measuredMinHeight = (_local4 + _local11);
            _local1.measuredWidth = (_local5 + _local10);
            _local1.measuredHeight = (_local6 + _local11);
        }

    }
}//package mx.containers.utilityClasses 
