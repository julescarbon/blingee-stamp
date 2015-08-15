package mx.containers {
    import flash.display.*;
    import mx.core.*;
    import mx.containers.utilityClasses.*;
    import mx.containers.gridClasses.*;

    public class GridRow extends HBox {

        mx_internal static const VERSION:String = "3.2.0.3958";

        var rowIndex:int = 0;
        var columnWidths:Array;
        var rowHeights:Array;
        var numGridItems:int;

        public function GridRow(){
            super.clipContent = false;
        }
        override public function getStyle(_arg1:String){
            return ((((((_arg1 == "horizontalGap")) && (parent))) ? Grid(parent).getStyle("horizontalGap") : super.getStyle(_arg1)));
        }
        override public function invalidateDisplayList():void{
            super.invalidateDisplayList();
            if (parent){
                Grid(parent).invalidateDisplayList();
            };
        }
        override public function get clipContent():Boolean{
            return (false);
        }
        override public function set horizontalScrollPolicy(_arg1:String):void{
        }
        override public function set clipContent(_arg1:Boolean):void{
        }
        function doRowLayout(_arg1:Number, _arg2:Number):void{
            var _local8:GridItem;
            var _local9:int;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            var _local13:int;
            var _local14:GridColumnInfo;
            var _local15:Number;
            var _local16:int;
            var _local17:GridRowInfo;
            var _local18:Number;
            var _local19:Number;
            layoutChrome(_arg1, _arg2);
            var _local3:Number = numChildren;
            if (_local3 == 0){
                return;
            };
            var _local4:Boolean = invalidateSizeFlag;
            var _local5:Boolean = invalidateDisplayListFlag;
            invalidateSizeFlag = true;
            invalidateDisplayListFlag = true;
            if ((((((((((((((((((((((parent.getChildIndex(this) == 0)) || (isNaN(columnWidths[0].x)))) || (!((columnWidths.minWidth == minWidth))))) || (!((columnWidths.maxWidth == maxWidth))))) || (!((columnWidths.preferredWidth == getExplicitOrMeasuredWidth()))))) || (!((columnWidths.percentWidth == percentWidth))))) || (!((columnWidths.width == _arg1))))) || (!((columnWidths.paddingLeft == getStyle("paddingLeft")))))) || (!((columnWidths.paddingRight == getStyle("paddingRight")))))) || (!((columnWidths.horizontalAlign == getStyle("horizontalAlign")))))) || (!((columnWidths.borderStyle == getStyle("borderStyle")))))){
                calculateColumnWidths();
                columnWidths.minWidth = minWidth;
                columnWidths.maxWidth = maxWidth;
                columnWidths.preferredWidth = getExplicitOrMeasuredWidth();
                columnWidths.percentWidth = percentWidth;
                columnWidths.width = _arg1;
                columnWidths.paddingLeft = getStyle("paddingLeft");
                columnWidths.paddingRight = getStyle("paddingRight");
                columnWidths.horizontalAlign = getStyle("horizontalAlign");
                columnWidths.borderStyle = getStyle("borderStyle");
            };
            var _local6:EdgeMetrics = viewMetricsAndPadding;
            var _local7:int;
            while (_local7 < _local3) {
                _local8 = GridItem(getChildAt(_local7));
                _local9 = _local8.colIndex;
                _local10 = columnWidths[_local9].x;
                _local11 = _local6.top;
                _local12 = _local8.percentHeight;
                _local13 = Math.min((_local9 + _local8.colSpan), columnWidths.length);
                _local14 = columnWidths[(_local13 - 1)];
                _local15 = ((_local14.x + _local14.width) - _local10);
                _local16 = Math.min((rowIndex + _local8.rowSpan), rowHeights.length);
                _local17 = rowHeights[(_local16 - 1)];
                _local18 = ((((_local17.y + _local17.height) - rowHeights[rowIndex].y) - _local6.top) - _local6.bottom);
                _local19 = (_local15 - _local8.maxWidth);
                if (_local19 > 0){
                    _local10 = (_local10 + (_local19 * layoutObject.getHorizontalAlignValue()));
                    _local15 = (_local15 - _local19);
                };
                _local19 = (_local18 - _local8.maxHeight);
                if (((_local12) && ((_local12 < 100)))){
                    _local19 = Math.max(_local19, (_local18 * (100 - _local12)));
                };
                if (_local19 > 0){
                    _local11 = (_local19 * layoutObject.getVerticalAlignValue());
                    _local18 = (_local18 - _local19);
                };
                _local15 = Math.ceil(_local15);
                _local18 = Math.ceil(_local18);
                _local8.move(_local10, _local11);
                _local8.setActualSize(_local15, _local18);
                _local7++;
            };
            invalidateSizeFlag = _local4;
            invalidateDisplayListFlag = _local5;
        }
        private function calculateColumnWidths():void{
            var _local5:Number;
            var _local6:GridColumnInfo;
            var _local7:Number;
            var _local8:int;
            var _local11:Number;
            var _local12:Number;
            var _local13:int;
            var _local1:EdgeMetrics = viewMetricsAndPadding;
            var _local2:Number = getStyle("horizontalGap");
            var _local3:int = columnWidths.length;
            var _local4:Number = (((unscaledWidth - _local1.left) - _local1.right) - ((_local3 - 1) * _local2));
            var _local9:Number = 0;
            var _local10:Array = [];
            _local5 = _local4;
            _local8 = 0;
            while (_local8 < _local3) {
                _local6 = columnWidths[_local8];
                _local11 = _local6.percent;
                if (_local11){
                    _local9 = (_local9 + _local11);
                    _local10.push(_local6);
                } else {
                    _local12 = (_local6.width = _local6.preferred);
                    _local5 = (_local5 - _local12);
                };
                _local8++;
            };
            if (_local9){
                _local5 = Flex.flexChildrenProportionally(_local4, _local5, _local9, _local10);
                _local13 = _local10.length;
                _local8 = 0;
                while (_local8 < _local13) {
                    _local6 = _local10[_local8];
                    _local10[_local8].width = _local6.size;
                    _local8++;
                };
            };
            _local7 = (_local1.left + (_local5 * layoutObject.getHorizontalAlignValue()));
            _local8 = 0;
            while (_local8 < _local3) {
                _local6 = columnWidths[_local8];
                _local6.x = _local7;
                _local7 = (_local7 + (_local6.width + _local2));
                _local8++;
            };
        }
        override public function get horizontalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        override public function invalidateSize():void{
            super.invalidateSize();
            if (parent){
                Grid(parent).invalidateSize();
            };
        }
        function updateRowMeasurements():void{
            var _local6:Number;
            var _local8:GridColumnInfo;
            var _local1:Number = columnWidths.length;
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:int;
            while (_local4 < _local1) {
                _local8 = columnWidths[_local4];
                _local2 = (_local2 + _local8.min);
                _local3 = (_local3 + _local8.preferred);
                _local4++;
            };
            var _local5:Number = layoutObject.widthPadding(_local1);
            _local6 = layoutObject.heightPadding(0);
            var _local7:GridRowInfo = rowHeights[rowIndex];
            measuredMinWidth = (_local2 + _local5);
            measuredMinHeight = (_local7.min + _local6);
            measuredWidth = (_local3 + _local5);
            measuredHeight = (_local7.preferred + _local6);
        }
        override public function set verticalScrollPolicy(_arg1:String):void{
        }
        override public function get verticalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
        }
        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            super.setChildIndex(_arg1, _arg2);
            Grid(parent).invalidateSize();
            Grid(parent).invalidateDisplayList();
        }

    }
}//package mx.containers 
