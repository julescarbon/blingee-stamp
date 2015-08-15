package mx.controls {
    import mx.core.*;
    import mx.events.*;

    public class Text extends Label {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var widthChanged:Boolean = true;
        private var lastUnscaledWidth:Number = NaN;

        public function Text(){
            selectable = true;
            truncateToFit = false;
            addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler);
        }
        private function measureUsingWidth(_arg1:Number):void{
            var _local2:Number;
            var _local3:Number;
            var _local5:Number;
            var _local6:Boolean;
            _local2 = getStyle("paddingLeft");
            _local3 = getStyle("paddingTop");
            var _local4:Number = getStyle("paddingRight");
            _local5 = getStyle("paddingBottom");
            textField.validateNow();
            textField.autoSize = "left";
            if (!isNaN(_arg1)){
                textField.width = ((_arg1 - _local2) - _local4);
                measuredWidth = (Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING);
                measuredHeight = (Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING);
            } else {
                _local6 = textField.wordWrap;
                textField.wordWrap = false;
                measuredWidth = (Math.ceil(textField.textWidth) + UITextField.TEXT_WIDTH_PADDING);
                measuredHeight = (Math.ceil(textField.textHeight) + UITextField.TEXT_HEIGHT_PADDING);
                textField.wordWrap = _local6;
            };
            textField.autoSize = "none";
            measuredWidth = (measuredWidth + (_local2 + _local4));
            measuredHeight = (measuredHeight + (_local3 + _local5));
            if (isNaN(explicitWidth)){
                measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
                measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
            } else {
                measuredMinWidth = measuredWidth;
                measuredMinHeight = measuredHeight;
            };
        }
        override public function set percentWidth(_arg1:Number):void{
            if (_arg1 != percentWidth){
                widthChanged = true;
                invalidateProperties();
                invalidateSize();
            };
            super.percentWidth = _arg1;
        }
        override public function set explicitWidth(_arg1:Number):void{
            if (_arg1 != explicitWidth){
                widthChanged = true;
                invalidateProperties();
                invalidateSize();
            };
            super.explicitWidth = _arg1;
        }
        private function updateCompleteHandler(_arg1:FlexEvent):void{
            lastUnscaledWidth = NaN;
        }
        override protected function childrenCreated():void{
            super.childrenCreated();
            textField.wordWrap = true;
            textField.multiline = true;
            textField.mouseWheelEnabled = false;
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (widthChanged){
                textField.wordWrap = ((!(isNaN(percentWidth))) || (!(isNaN(explicitWidth))));
                widthChanged = false;
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local7:Boolean;
            if (isSpecialCase()){
                _local7 = ((isNaN(lastUnscaledWidth)) || (!((lastUnscaledWidth == _arg1))));
                lastUnscaledWidth = _arg1;
                if (_local7){
                    invalidateSize();
                    return;
                };
            };
            var _local3:Number = getStyle("paddingLeft");
            var _local4:Number = getStyle("paddingTop");
            var _local5:Number = getStyle("paddingRight");
            var _local6:Number = getStyle("paddingBottom");
            textField.setActualSize(((_arg1 - _local3) - _local5), ((_arg2 - _local4) - _local6));
            textField.x = _local3;
            textField.y = _local4;
            if (Math.floor(width) < Math.floor(measuredWidth)){
                textField.wordWrap = true;
            };
        }
        override protected function measure():void{
            if (isSpecialCase()){
                if (!isNaN(lastUnscaledWidth)){
                    measureUsingWidth(lastUnscaledWidth);
                } else {
                    measuredWidth = 0;
                    measuredHeight = 0;
                };
                return;
            };
            measureUsingWidth(explicitWidth);
        }
        private function isSpecialCase():Boolean{
            var _local1:Number = getStyle("left");
            var _local2:Number = getStyle("right");
            return (((((((!(isNaN(percentWidth))) || (((!(isNaN(_local1))) && (!(isNaN(_local2))))))) && (isNaN(explicitHeight)))) && (isNaN(percentHeight))));
        }

    }
}//package mx.controls 
