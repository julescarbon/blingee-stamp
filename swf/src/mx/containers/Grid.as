package mx.containers {
    import mx.core.*;
    import mx.containers.gridClasses.*;

    public class Grid extends Box {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var columnWidths:Array;
        private var rowHeights:Array;
        private var needToRemeasure:Boolean = true;

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local4:int;
            var _local5:GridRow;
            if (needToRemeasure){
                measure();
            };
            super.updateDisplayList(_arg1, _arg2);
            var _local3:int;
            var _local6:Array = [];
            var _local7:int;
            while (_local7 < numChildren) {
                _local5 = GridRow(getChildAt(_local7));
                if (_local5.includeInLayout){
                    _local6.push(_local5);
                    _local3++;
                };
                _local7++;
            };
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = _local6[_local4];
                rowHeights[_local4].y = _local5.y;
                rowHeights[_local4].height = _local5.height;
                _local4++;
            };
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = _local6[_local4];
                _local6[_local4].doRowLayout((_local5.width * _local5.scaleX), (_local5.height * _local5.scaleY));
                _local4++;
            };
        }
        private function distributeItemWidth(_arg1:GridItem, _arg2:int, _arg3:Number, _arg4:Array):void{
            var _local12:int;
            var _local13:GridColumnInfo;
            var _local14:Number;
            var _local15:Number;
            var _local5:Number = _arg1.maxWidth;
            var _local6:Number = _arg1.getExplicitOrMeasuredWidth();
            var _local7:Number = _arg1.minWidth;
            var _local8:int = _arg1.colSpan;
            var _local9:Number = _arg1.percentWidth;
            var _local10:Number = 0;
            var _local11:Boolean;
            _local12 = _arg2;
            while (_local12 < (_arg2 + _local8)) {
                _local13 = _arg4[_local12];
                _local6 = (_local6 - _local13.preferred);
                _local7 = (_local7 - _local13.min);
                _local10 = (_local10 + _local13.flex);
                _local12++;
            };
            if (_local8 > 1){
                _local14 = (_arg3 * (_local8 - 1));
                _local6 = (_local6 - _local14);
                _local7 = (_local7 - _local14);
            };
            if (_local10 == 0){
                _local10 = _local8;
                _local11 = true;
            };
            _local6 = (((_local6 > 0)) ? Math.ceil((_local6 / _local10)) : 0);
            _local7 = (((_local7 > 0)) ? Math.ceil((_local7 / _local10)) : 0);
            _local12 = _arg2;
            while (_local12 < (_arg2 + _local8)) {
                _local13 = _arg4[_local12];
                _local15 = ((_local11) ? 1 : _local13.flex);
                _local13.preferred = (_local13.preferred + (_local6 * _local15));
                _local13.min = (_local13.min + (_local7 * _local15));
                if (_local9){
                    _local13.percent = Math.max(_local13.percent, (_local9 / _local8));
                };
                _local12++;
            };
            if ((((_local8 == 1)) && ((_local5 < _local13.max)))){
                _local13.max = _local5;
            };
        }
        private function distributeItemHeight(_arg1:GridItem, _arg2:Number, _arg3:Number, _arg4:Array):void{
            var _local11:int;
            var _local12:GridRowInfo;
            var _local13:Number;
            var _local14:Number;
            var _local5:Number = _arg1.maxHeight;
            var _local6:Number = _arg1.getExplicitOrMeasuredHeight();
            var _local7:Number = _arg1.minHeight;
            var _local8:int = _arg1.rowSpan;
            var _local9:Number = 0;
            var _local10:Boolean;
            _local11 = _arg2;
            while (_local11 < (_arg2 + _local8)) {
                _local12 = _arg4[_local11];
                _local6 = (_local6 - _local12.preferred);
                _local7 = (_local7 - _local12.min);
                _local9 = (_local9 + _local12.flex);
                _local11++;
            };
            if (_local8 > 1){
                _local13 = (_arg3 * (_local8 - 1));
                _local6 = (_local6 - _local13);
                _local7 = (_local7 - _local13);
            };
            if (_local9 == 0){
                _local9 = _local8;
                _local10 = true;
            };
            _local6 = (((_local6 > 0)) ? Math.ceil((_local6 / _local9)) : 0);
            _local7 = (((_local7 > 0)) ? Math.ceil((_local7 / _local9)) : 0);
            _local11 = _arg2;
            while (_local11 < (_arg2 + _local8)) {
                _local12 = _arg4[_local11];
                _local14 = ((_local10) ? 1 : _local12.flex);
                _local12.preferred = (_local12.preferred + (_local6 * _local14));
                _local12.min = (_local12.min + (_local7 * _local14));
                _local11++;
            };
            if ((((_local8 == 1)) && ((_local5 < _local12.max)))){
                _local12.max = _local5;
            };
        }
        override public function invalidateSize():void{
            if (((!(isNaN(explicitWidth))) && (!(isNaN(explicitHeight))))){
                needToRemeasure = true;
            };
            super.invalidateSize();
        }
        override protected function measure():void{
            var _local4:GridRow;
            var _local5:GridItem;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local12:int;
            var _local19:Number;
            var _local22:GridRow;
            var _local23:EdgeMetrics;
            var _local25:int;
            var _local26:int;
            var _local27:int;
            var _local28:*;
            var _local29:*;
            var _local30:GridRowInfo;
            var _local31:GridColumnInfo;
            var _local32:Number;
            var _local1:int;
            var _local2:int;
            var _local3:Array = [];
            var _local9:Array = [];
            var _local10:int;
            while (_local10 < numChildren) {
                _local4 = GridRow(getChildAt(_local10));
                if (_local4.includeInLayout){
                    _local9.push(_local4);
                    _local1++;
                };
                _local10++;
            };
            _local6 = 0;
            while (_local6 < _local1) {
                _local8 = 0;
                _local4 = _local9[_local6];
                _local9[_local6].numGridItems = _local4.numChildren;
                _local4.rowIndex = _local6;
                _local7 = 0;
                while (_local7 < _local4.numGridItems) {
                    if (_local6 > 0){
                        _local25 = _local3[_local8];
                        while (((!(isNaN(_local25))) && ((_local25 >= _local6)))) {
                            _local8++;
                            _local25 = _local3[_local8];
                        };
                    };
                    _local5 = GridItem(_local4.getChildAt(_local7));
                    _local5.colIndex = _local8;
                    if (_local5.rowSpan > 1){
                        _local26 = ((_local6 + _local5.rowSpan) - 1);
                        _local27 = 0;
                        while (_local27 < _local5.colSpan) {
                            _local3[(_local8 + _local27)] = _local26;
                            _local27++;
                        };
                    };
                    _local8 = (_local8 + _local5.colSpan);
                    _local7++;
                };
                if (_local8 > _local2){
                    _local2 = _local8;
                };
                _local6++;
            };
            rowHeights = new Array(_local1);
            columnWidths = new Array(_local2);
            _local6 = 0;
            while (_local6 < _local1) {
                rowHeights[_local6] = new GridRowInfo();
                _local6++;
            };
            _local6 = 0;
            while (_local6 < _local2) {
                columnWidths[_local6] = new GridColumnInfo();
                _local6++;
            };
            var _local11:int = int.MAX_VALUE;
            var _local13 = 1;
            var _local14:Number = getStyle("horizontalGap");
            var _local15:Number = getStyle("verticalGap");
            do  {
                _local12 = _local13;
                _local13 = _local11;
                _local6 = 0;
                while (_local6 < _local1) {
                    _local4 = _local9[_local6];
                    _local4.columnWidths = columnWidths;
                    _local4.rowHeights = rowHeights;
                    _local7 = 0;
                    while (_local7 < _local4.numGridItems) {
                        _local5 = GridItem(_local4.getChildAt(_local7));
                        _local28 = _local5.rowSpan;
                        _local29 = _local5.colSpan;
                        if (_local28 == _local12){
                            distributeItemHeight(_local5, _local6, _local15, rowHeights);
                        } else {
                            if ((((_local28 > _local12)) && ((_local28 < _local13)))){
                                _local13 = _local28;
                            };
                        };
                        if (_local29 == _local12){
                            distributeItemWidth(_local5, _local5.colIndex, _local14, columnWidths);
                        } else {
                            if ((((_local29 > _local12)) && ((_local29 < _local13)))){
                                _local13 = _local29;
                            };
                        };
                        _local7++;
                    };
                    _local6++;
                };
            } while (_local13 < _local11);
            var _local16:Number = 0;
            var _local17:Number = 0;
            var _local18:Number = 0;
            _local19 = 0;
            _local6 = 0;
            while (_local6 < _local1) {
                _local30 = rowHeights[_local6];
                if (_local30.min > _local30.preferred){
                    _local30.min = _local30.preferred;
                };
                if (_local30.max < _local30.preferred){
                    _local30.max = _local30.preferred;
                };
                _local17 = (_local17 + _local30.min);
                _local19 = (_local19 + _local30.preferred);
                _local6++;
            };
            _local6 = 0;
            while (_local6 < _local2) {
                _local31 = columnWidths[_local6];
                if (_local31.min > _local31.preferred){
                    _local31.min = _local31.preferred;
                };
                if (_local31.max < _local31.preferred){
                    _local31.max = _local31.preferred;
                };
                _local16 = (_local16 + _local31.min);
                _local18 = (_local18 + _local31.preferred);
                _local6++;
            };
            var _local20:EdgeMetrics = viewMetricsAndPadding;
            var _local21:Number = (_local20.left + _local20.right);
            var _local24:Number = 0;
            if (_local2 > 1){
                _local21 = (_local21 + (getStyle("horizontalGap") * (_local2 - 1)));
            };
            _local6 = 0;
            while (_local6 < _local1) {
                _local22 = _local9[_local6];
                _local23 = _local22.viewMetricsAndPadding;
                _local32 = (_local23.left + _local23.right);
                if (_local32 > _local24){
                    _local24 = _local32;
                };
                _local6++;
            };
            _local21 = (_local21 + _local24);
            _local16 = (_local16 + _local21);
            _local18 = (_local18 + _local21);
            _local21 = (_local20.top + _local20.bottom);
            if (_local1 > 1){
                _local21 = (_local21 + (getStyle("verticalGap") * (_local1 - 1)));
            };
            _local6 = 0;
            while (_local6 < _local1) {
                _local22 = _local9[_local6];
                _local23 = _local22.viewMetricsAndPadding;
                _local21 = (_local21 + (_local23.top + _local23.bottom));
                _local6++;
            };
            _local17 = (_local17 + _local21);
            _local19 = (_local19 + _local21);
            _local6 = 0;
            while (_local6 < _local1) {
                _local22 = _local9[_local6];
                _local22.updateRowMeasurements();
                _local6++;
            };
            super.measure();
            measuredMinWidth = Math.max(measuredMinWidth, _local16);
            measuredMinHeight = Math.max(measuredMinHeight, _local17);
            measuredWidth = Math.max(measuredWidth, _local18);
            measuredHeight = Math.max(measuredHeight, _local19);
            needToRemeasure = false;
        }

    }
}//package mx.containers 
