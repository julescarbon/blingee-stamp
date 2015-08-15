package src {
    import mx.core.*;
    import mx.controls.*;
    import mx.containers.*;
    import flexlib.controls.*;

    public class SuperTabBarEx extends SuperTabBar {

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:Boolean;
            var _local15:int;
            var _local16:Button;
            var _local17:SuperTabEx;
            super.updateDisplayList(_arg1, _arg2);
            _local3 = (direction == BoxDirection.HORIZONTAL);
            var _local4 = !(_local3);
            var _local5:EdgeMetrics = viewMetricsAndPadding;
            var _local6:int = numChildren;
            var _local7:Number = getStyle("horizontalGap");
            var _local8:Number = getStyle("verticalGap");
            var _local9:Number = ((((_local3) && ((numChildren > 0)))) ? (_local7 * (_local6 - 1)) : 0);
            var _local10:Number = ((((_local4) && ((numChildren > 0)))) ? (_local8 * (_local6 - 1)) : 0);
            var _local11:Number = (((_arg1 - _local5.left) - _local5.right) - _local9);
            var _local12:Number = (((_arg2 - _local5.top) - _local5.bottom) - _local10);
            if (!_local3){
                return;
            };
            var _local13:Number = 0;
            var _local14:Number = 0;
            _local15 = 0;
            while (_local15 < _local6) {
                _local16 = Button(this.getChildAt(_local15));
                if ((((_local16 is SuperTabEx)) && ((SuperTabEx(_local16).explicitPercentWidth > 0)))){
                    _local14 = (_local14 + SuperTabEx(_local16).explicitPercentWidth);
                } else {
                    _local13 = (_local13 + _local16.width);
                };
                _local15++;
            };
            _local15 = 0;
            while (_local15 < _local6) {
                _local16 = Button(this.getChildAt(_local15));
                if ((_local16 is SuperTabEx)){
                    _local17 = (_local16 as SuperTabEx);
                    if (_local17.explicitPercentWidth > 0){
                        _local17.width = (((_local11 - _local13) * _local17.explicitPercentWidth) / _local14);
                    };
                };
                _local15++;
            };
        }

    }
}//package src 
