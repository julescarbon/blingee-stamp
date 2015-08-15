package mx.containers.utilityClasses {
    import mx.core.*;

    public class ApplicationLayout extends BoxLayout {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override public function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:int;
            var _local9:int;
            var _local10:IFlexDisplayObject;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Container = super.target;
            if (((((_local3.horizontalScrollBar) && ((getHorizontalAlignValue() > 0)))) || (((_local3.verticalScrollBar) && ((getVerticalAlignValue() > 0)))))){
                _local4 = _local3.getStyle("paddingLeft");
                _local5 = _local3.getStyle("paddingTop");
                _local6 = 0;
                _local7 = 0;
                _local8 = _local3.numChildren;
                _local9 = 0;
                while (_local9 < _local8) {
                    _local10 = IFlexDisplayObject(_local3.getChildAt(_local9));
                    if (_local10.x < _local4){
                        _local6 = Math.max(_local6, (_local4 - _local10.x));
                    };
                    if (_local10.y < _local5){
                        _local7 = Math.max(_local7, (_local5 - _local10.y));
                    };
                    _local9++;
                };
                if (((!((_local6 == 0))) || (!((_local7 == 0))))){
                    _local9 = 0;
                    while (_local9 < _local8) {
                        _local10 = IFlexDisplayObject(_local3.getChildAt(_local9));
                        IFlexDisplayObject(_local3.getChildAt(_local9)).move((_local10.x + _local6), (_local10.y + _local7));
                        _local9++;
                    };
                };
            };
        }

    }
}//package mx.containers.utilityClasses 
