package mx.controls {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.styles.*;

    public class ToolTip extends UIComponent implements IToolTip, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static var maxWidth:Number = 300;

        private var textChanged:Boolean;
        private var _text:String;
        protected var textField:IUITextField;
        mx_internal var border:IFlexDisplayObject;

        public function ToolTip(){
            mouseEnabled = false;
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        override public function styleChanged(_arg1:String):void{
            super.styleChanged(_arg1);
            if ((((((_arg1 == "borderStyle")) || ((_arg1 == "styleName")))) || ((_arg1 == null)))){
                invalidateDisplayList();
            };
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:TextFormat;
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                _local1 = getChildIndex(DisplayObject(textField));
                removeTextField();
                createTextField(_local1);
                invalidateSize();
                textChanged = true;
            };
            if (textChanged){
                _local2 = textField.getTextFormat();
                _local2.leftMargin = 0;
                _local2.rightMargin = 0;
                textField.defaultTextFormat = _local2;
                textField.text = _text;
                textChanged = false;
            };
        }
        mx_internal function getTextField():IUITextField{
            return (textField);
        }
        override protected function createChildren():void{
            var _local1:Class;
            super.createChildren();
            if (!border){
                _local1 = getStyle("borderSkin");
                border = new (_local1)();
                if ((border is ISimpleStyleClient)){
                    ISimpleStyleClient(border).styleName = this;
                };
                addChild(DisplayObject(border));
            };
            createTextField(-1);
        }
        override protected function measure():void{
            var _local7:Number;
            super.measure();
            var _local1:EdgeMetrics = borderMetrics;
            var _local2:Number = (_local1.left + getStyle("paddingLeft"));
            var _local3:Number = (_local1.top + getStyle("paddingTop"));
            var _local4:Number = (_local1.right + getStyle("paddingRight"));
            var _local5:Number = (_local1.bottom + getStyle("paddingBottom"));
            var _local6:Number = (_local2 + _local4);
            _local7 = (_local3 + _local5);
            textField.wordWrap = false;
            if ((textField.textWidth + _local6) > ToolTip.maxWidth){
                textField.width = (ToolTip.maxWidth - _local6);
                textField.wordWrap = true;
            };
            measuredWidth = (textField.width + _local6);
            measuredHeight = (textField.height + _local7);
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        public function set text(_arg1:String):void{
            _text = _arg1;
            textChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        public function get text():String{
            return (_text);
        }
        mx_internal function removeTextField():void{
            if (textField){
                removeChild(DisplayObject(textField));
                textField = null;
            };
        }
        mx_internal function createTextField(_arg1:int):void{
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.autoSize = TextFieldAutoSize.LEFT;
                textField.mouseEnabled = false;
                textField.multiline = true;
                textField.selectable = false;
                textField.wordWrap = false;
                textField.styleName = this;
                if (_arg1 == -1){
                    addChild(DisplayObject(textField));
                } else {
                    addChildAt(DisplayObject(textField), _arg1);
                };
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:EdgeMetrics = borderMetrics;
            var _local4:Number = (_local3.left + getStyle("paddingLeft"));
            var _local5:Number = (_local3.top + getStyle("paddingTop"));
            var _local6:Number = (_local3.right + getStyle("paddingRight"));
            var _local7:Number = (_local3.bottom + getStyle("paddingBottom"));
            var _local8:Number = (_local4 + _local6);
            var _local9:Number = (_local5 + _local7);
            border.setActualSize(_arg1, _arg2);
            textField.move(_local4, _local5);
            textField.setActualSize((_arg1 - _local8), (_arg2 - _local9));
        }
        private function get borderMetrics():EdgeMetrics{
            if ((border is IRectangularBorder)){
                return (IRectangularBorder(border).borderMetrics);
            };
            return (EdgeMetrics.EMPTY);
        }

    }
}//package mx.controls 
