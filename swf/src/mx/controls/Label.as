package mx.controls {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.listClasses.*;

    public class Label extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _selectable:Boolean = false;
        private var _text:String = "";
        private var _data:Object;
        mx_internal var htmlTextChanged:Boolean = false;
        private var _tabIndex:int = -1;
        private var _textWidth:Number;
        private var explicitHTMLText:String = null;
        private var enabledChanged:Boolean = false;
        private var condenseWhiteChanged:Boolean = false;
        private var _listData:BaseListData;
        private var _textHeight:Number;
        protected var textField:IUITextField;
        private var _htmlText:String = "";
        private var _condenseWhite:Boolean = false;
        mx_internal var textChanged:Boolean = false;
        public var truncateToFit:Boolean = true;
        private var textSet:Boolean;
        private var selectableChanged:Boolean;
        private var toolTipSet:Boolean = false;

        public function Label(){
            tabChildren = true;
        }
        override public function set enabled(_arg1:Boolean):void{
            if (_arg1 == enabled){
                return;
            };
            super.enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
        }
        private function textField_textFieldStyleChangeHandler(_arg1:Event):void{
            textFieldChanged(true);
        }
        override public function get baselinePosition():Number{
            var _local1:String;
            var _local2:TextLineMetrics;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                if (!textField){
                    return (NaN);
                };
                validateNow();
                _local1 = ((isHTML) ? explicitHTMLText : text);
                if (_local1 == ""){
                    _local1 = " ";
                };
                _local2 = ((isHTML) ? measureHTMLText(_local1) : measureText(_local1));
                return ((textField.y + _local2.ascent));
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((textField.y + textField.baselinePosition));
        }
        public function set condenseWhite(_arg1:Boolean):void{
            if (_arg1 == _condenseWhite){
                return;
            };
            _condenseWhite = _arg1;
            condenseWhiteChanged = true;
            if (isHTML){
                htmlTextChanged = true;
            };
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("condenseWhiteChanged"));
        }
        public function get textWidth():Number{
            return (_textWidth);
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!textField){
                createTextField(-1);
            };
        }
        mx_internal function getTextField():IUITextField{
            return (textField);
        }
        private function measureTextFieldBounds(_arg1:String):Rectangle{
            var _local2:TextLineMetrics = ((isHTML) ? measureHTMLText(_arg1) : measureText(_arg1));
            return (new Rectangle(0, 0, (_local2.width + UITextField.TEXT_WIDTH_PADDING), (_local2.height + UITextField.TEXT_HEIGHT_PADDING)));
        }
        mx_internal function getMinimumText(_arg1:String):String{
            if (((!(_arg1)) || ((_arg1.length < 2)))){
                _arg1 = "Wj";
            };
            return (_arg1);
        }
        private function textFieldChanged(_arg1:Boolean):void{
            var _local2:Boolean;
            var _local3:Boolean;
            if (!_arg1){
                _local2 = !((_text == textField.text));
                _text = textField.text;
            };
            _local3 = !((_htmlText == textField.htmlText));
            _htmlText = textField.htmlText;
            if (_local2){
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            };
            if (_local3){
                dispatchEvent(new Event("htmlTextChanged"));
            };
            _textWidth = textField.textWidth;
            _textHeight = textField.textHeight;
        }
        public function get data():Object{
            return (_data);
        }
        public function get text():String{
            return (_text);
        }
        mx_internal function removeTextField():void{
            if (textField){
                textField.removeEventListener("textFieldStyleChange", textField_textFieldStyleChangeHandler);
                textField.removeEventListener("textInsert", textField_textModifiedHandler);
                textField.removeEventListener("textReplace", textField_textModifiedHandler);
                removeChild(DisplayObject(textField));
                textField = null;
            };
        }
        public function get textHeight():Number{
            return (_textHeight);
        }
        mx_internal function get styleSheet():StyleSheet{
            return (textField.styleSheet);
        }
        public function set selectable(_arg1:Boolean):void{
            if (_arg1 == selectable){
                return;
            };
            _selectable = _arg1;
            selectableChanged = true;
            invalidateProperties();
        }
        override public function get tabIndex():int{
            return (_tabIndex);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        override public function set toolTip(_arg1:String):void{
            super.toolTip = _arg1;
            toolTipSet = !((_arg1 == null));
        }
        mx_internal function createTextField(_arg1:int):void{
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.enabled = enabled;
                textField.ignorePadding = true;
                textField.selectable = selectable;
                textField.styleName = this;
                textField.addEventListener("textFieldStyleChange", textField_textFieldStyleChangeHandler);
                textField.addEventListener("textInsert", textField_textModifiedHandler);
                textField.addEventListener("textReplace", textField_textModifiedHandler);
                if (_arg1 == -1){
                    addChild(DisplayObject(textField));
                } else {
                    addChildAt(DisplayObject(textField), _arg1);
                };
            };
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                removeTextField();
                condenseWhiteChanged = true;
                enabledChanged = true;
                selectableChanged = true;
                textChanged = true;
            };
            if (!textField){
                createTextField(-1);
            };
            if (condenseWhiteChanged){
                textField.condenseWhite = _condenseWhite;
                condenseWhiteChanged = false;
            };
            textField.tabIndex = tabIndex;
            if (enabledChanged){
                textField.enabled = enabled;
                enabledChanged = false;
            };
            if (selectableChanged){
                textField.selectable = _selectable;
                selectableChanged = false;
            };
            if (((textChanged) || (htmlTextChanged))){
                if (isHTML){
                    textField.htmlText = explicitHTMLText;
                } else {
                    textField.text = _text;
                };
                textFieldChanged(false);
                textChanged = false;
                htmlTextChanged = false;
            };
        }
        public function get condenseWhite():Boolean{
            return (_condenseWhite);
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        private function get isHTML():Boolean{
            return (!((explicitHTMLText == null)));
        }
        public function get selectable():Boolean{
            return (_selectable);
        }
        public function set text(_arg1:String):void{
            textSet = true;
            if (!_arg1){
                _arg1 = "";
            };
            if (((!(isHTML)) && ((_arg1 == _text)))){
                return;
            };
            _text = _arg1;
            textChanged = true;
            _htmlText = null;
            explicitHTMLText = null;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        public function set data(_arg1:Object):void{
            var _local2:*;
            _data = _arg1;
            if (_listData){
                _local2 = _listData.label;
            } else {
                if (_data != null){
                    if ((_data is String)){
                        _local2 = String(_data);
                    } else {
                        _local2 = _data.toString();
                    };
                };
            };
            if (((!((_local2 === undefined))) && (!(textSet)))){
                text = _local2;
                textSet = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        override protected function measure():void{
            super.measure();
            var _local1:String = ((isHTML) ? explicitHTMLText : text);
            _local1 = getMinimumText(_local1);
            var _local2:Rectangle = measureTextFieldBounds(_local1);
            measuredMinWidth = (measuredWidth = ((_local2.width + getStyle("paddingLeft")) + getStyle("paddingRight")));
            measuredMinHeight = (measuredHeight = ((_local2.height + getStyle("paddingTop")) + getStyle("paddingBottom")));
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        private function textField_textModifiedHandler(_arg1:Event):void{
            textFieldChanged(false);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        mx_internal function set styleSheet(_arg1:StyleSheet):void{
            textField.styleSheet = _arg1;
        }
        public function set htmlText(_arg1:String):void{
            textSet = true;
            if (!_arg1){
                _arg1 = "";
            };
            if (((isHTML) && ((_arg1 == explicitHTMLText)))){
                return;
            };
            _htmlText = _arg1;
            htmlTextChanged = true;
            _text = null;
            explicitHTMLText = _arg1;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("htmlTextChanged"));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local9:Boolean;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("paddingLeft");
            var _local4:Number = getStyle("paddingTop");
            var _local5:Number = getStyle("paddingRight");
            var _local6:Number = getStyle("paddingBottom");
            textField.setActualSize(((_arg1 - _local3) - _local5), ((_arg2 - _local4) - _local6));
            textField.x = _local3;
            textField.y = _local4;
            var _local7:String = ((isHTML) ? explicitHTMLText : text);
            var _local8:Rectangle = measureTextFieldBounds(_local7);
            if (truncateToFit){
                if (isHTML){
                    _local9 = (_local8.width > textField.width);
                } else {
                    textField.text = _text;
                    _local9 = textField.truncateToFit();
                };
                if (!toolTipSet){
                    super.toolTip = ((_local9) ? text : null);
                };
            };
        }
        public function get htmlText():String{
            return (_htmlText);
        }
        public function getLineMetrics(_arg1:int):TextLineMetrics{
            return (((textField) ? textField.getLineMetrics(_arg1) : null));
        }
        override public function set tabIndex(_arg1:int):void{
            _tabIndex = _arg1;
            invalidateProperties();
        }

    }
}//package mx.controls 
