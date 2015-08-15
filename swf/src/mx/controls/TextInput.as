package mx.controls {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.listClasses.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.ui.*;

    public class TextInput extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _text:String = "";
        private var _textWidth:Number;
        private var _restrict:String;
        private var htmlTextChanged:Boolean = false;
        mx_internal var border:IFlexDisplayObject;
        private var enabledChanged:Boolean = false;
        private var _maxChars:int = 0;
        private var _condenseWhite:Boolean = false;
        private var accessibilityPropertiesChanged:Boolean = false;
        private var _textHeight:Number;
        private var displayAsPasswordChanged:Boolean = false;
        private var prevMode:String = "UNKNOWN";
        private var selectableChanged:Boolean = false;
        private var restrictChanged:Boolean = false;
        private var selectionChanged:Boolean = false;
        private var _data:Object;
        private var maxCharsChanged:Boolean = false;
        private var _tabIndex:int = -1;
        private var errorCaught:Boolean = false;
        private var _selectionBeginIndex:int = 0;
        private var explicitHTMLText:String = null;
        private var editableChanged:Boolean = false;
        mx_internal var parentDrawsFocus:Boolean = false;
        private var tabIndexChanged:Boolean = false;
        private var _horizontalScrollPosition:Number = 0;
        private var _editable:Boolean = true;
        private var _imeMode:String = null;
        private var condenseWhiteChanged:Boolean = false;
        protected var textField:IUITextField;
        private var _listData:BaseListData;
        private var _displayAsPassword:Boolean = false;
        private var textChanged:Boolean = false;
        private var _htmlText:String = "";
        private var _accessibilityProperties:AccessibilityProperties;
        private var _selectionEndIndex:int = 0;
        private var textSet:Boolean;
        private var horizontalScrollPositionChanged:Boolean = false;
        private var _selectable:Boolean = true;

        public function TextInput(){
            tabChildren = true;
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            super.focusOutHandler(_arg1);
            if (((!((_imeMode == null))) && (_editable))){
                if (((!((IME.conversionMode == IMEConversionMode.UNKNOWN))) && (!((prevMode == IMEConversionMode.UNKNOWN))))){
                    IME.conversionMode = prevMode;
                };
                IME.enabled = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        override public function drawFocus(_arg1:Boolean):void{
            if (parentDrawsFocus){
                IFocusManagerComponent(parent).drawFocus(_arg1);
                return;
            };
            super.drawFocus(_arg1);
        }
        mx_internal function getTextField():IUITextField{
            return (textField);
        }
        private function textField_textInputHandler(_arg1:TextEvent):void{
            _arg1.stopImmediatePropagation();
            var _local2:TextEvent = new TextEvent(TextEvent.TEXT_INPUT, false, true);
            _local2.text = _arg1.text;
            dispatchEvent(_local2);
            if (_local2.isDefaultPrevented()){
                _arg1.preventDefault();
            };
        }
        override public function get accessibilityProperties():AccessibilityProperties{
            return (_accessibilityProperties);
        }
        override protected function createChildren():void{
            super.createChildren();
            createBorder();
            createTextField(-1);
        }
        private function textFieldChanged(_arg1:Boolean, _arg2:Boolean):void{
            var _local3:Boolean;
            var _local4:Boolean;
            if (!_arg1){
                _local3 = !((_text == textField.text));
                _text = textField.text;
            };
            _local4 = !((_htmlText == textField.htmlText));
            _htmlText = textField.htmlText;
            if (_local3){
                dispatchEvent(new Event("textChanged"));
                if (_arg2){
                    dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                };
            };
            if (_local4){
                dispatchEvent(new Event("htmlTextChanged"));
            };
            _textWidth = textField.textWidth;
            _textHeight = textField.textHeight;
        }
        public function get text():String{
            return (_text);
        }
        mx_internal function createTextField(_arg1:int):void{
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.autoSize = TextFieldAutoSize.NONE;
                textField.enabled = enabled;
                textField.ignorePadding = false;
                textField.multiline = false;
                textField.tabEnabled = true;
                textField.wordWrap = false;
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    textField.styleName = this;
                };
                textField.addEventListener(Event.CHANGE, textField_changeHandler);
                textField.addEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
                textField.addEventListener(Event.SCROLL, textField_scrollHandler);
                textField.addEventListener("textFieldStyleChange", textField_textFieldStyleChangeHandler);
                textField.addEventListener("textFormatChange", textField_textFormatChangeHandler);
                textField.addEventListener("textInsert", textField_textModifiedHandler);
                textField.addEventListener("textReplace", textField_textModifiedHandler);
                if (_arg1 == -1){
                    addChild(DisplayObject(textField));
                } else {
                    addChildAt(DisplayObject(textField), _arg1);
                };
            };
        }
        override public function get tabIndex():int{
            return (_tabIndex);
        }
        override public function set accessibilityProperties(_arg1:AccessibilityProperties):void{
            if (_arg1 == _accessibilityProperties){
                return;
            };
            _accessibilityProperties = _arg1;
            accessibilityPropertiesChanged = true;
            invalidateProperties();
        }
        public function setSelection(_arg1:int, _arg2:int):void{
            _selectionBeginIndex = _arg1;
            _selectionEndIndex = _arg2;
            selectionChanged = true;
            invalidateProperties();
        }
        public function get condenseWhite():Boolean{
            return (_condenseWhite);
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == textField)) || (super.isOurFocus(_arg1))));
        }
        public function get displayAsPassword():Boolean{
            return (_displayAsPassword);
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
        public function get selectionBeginIndex():int{
            return (((textField) ? textField.selectionBeginIndex : _selectionBeginIndex));
        }
        mx_internal function get selectable():Boolean{
            return (_selectable);
        }
        protected function createBorder():void{
            var _local1:Class;
            if (!border){
                _local1 = getStyle("borderSkin");
                if (_local1 != null){
                    border = new (_local1)();
                    if ((border is ISimpleStyleClient)){
                        ISimpleStyleClient(border).styleName = this;
                    };
                    addChildAt(DisplayObject(border), 0);
                    invalidateDisplayList();
                };
            };
        }
        public function get horizontalScrollPosition():Number{
            return (_horizontalScrollPosition);
        }
        override protected function measure():void{
            var _local2:Number;
            var _local3:Number;
            var _local4:TextLineMetrics;
            super.measure();
            var _local1:EdgeMetrics = ((((border) && ((border is IRectangularBorder)))) ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY);
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            if (maxChars){
                measuredWidth = Math.min(measuredWidth, ((((measureText("W").width * maxChars) + _local1.left) + _local1.right) + 8));
            };
            if (((!(text)) || ((text == "")))){
                _local2 = DEFAULT_MEASURED_MIN_WIDTH;
                _local3 = (((measureText(" ").height + _local1.top) + _local1.bottom) + UITextField.TEXT_HEIGHT_PADDING);
                if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                    _local3 = (_local3 + (getStyle("paddingTop") + getStyle("paddingBottom")));
                };
            } else {
                _local4 = measureText(text);
                _local2 = (((_local4.width + _local1.left) + _local1.right) + 8);
                _local3 = (((_local4.height + _local1.top) + _local1.bottom) + UITextField.TEXT_HEIGHT_PADDING);
                if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                    _local2 = (_local2 + (getStyle("paddingLeft") + getStyle("paddingRight")));
                    _local3 = (_local3 + (getStyle("paddingTop") + getStyle("paddingBottom")));
                };
            };
            measuredWidth = Math.max(_local2, measuredWidth);
            measuredHeight = Math.max(_local3, DEFAULT_MEASURED_HEIGHT);
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
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
            dispatchEvent(new Event("textChanged"));
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        public function get selectionEndIndex():int{
            return (((textField) ? textField.selectionEndIndex : _selectionEndIndex));
        }
        public function get editable():Boolean{
            return (_editable);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            switch (_arg1.keyCode){
                case Keyboard.ENTER:
                    dispatchEvent(new FlexEvent(FlexEvent.ENTER));
                    break;
            };
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            var message:* = null;
            var event:* = _arg1;
            if (event.target == this){
                systemManager.stage.focus = TextField(textField);
            };
            var fm:* = focusManager;
            if (((editable) && (fm))){
                fm.showFocusIndicator = true;
                if (((textField.selectable) && ((_selectionBeginIndex == _selectionEndIndex)))){
                    textField.setSelection(0, textField.length);
                };
            };
            super.focusInHandler(event);
            if (((!((_imeMode == null))) && (_editable))){
                IME.enabled = true;
                prevMode = IME.conversionMode;
                try {
                    if (((!(errorCaught)) && (!((IME.conversionMode == IMEConversionMode.UNKNOWN))))){
                        IME.conversionMode = _imeMode;
                    };
                    errorCaught = false;
                } catch(e:Error) {
                    errorCaught = true;
                    message = resourceManager.getString("controls", "unsupportedMode", [_imeMode]);
                    throw (new Error(message));
                };
            };
        }
        public function get htmlText():String{
            return (_htmlText);
        }
        override public function set tabIndex(_arg1:int):void{
            if (_arg1 == _tabIndex){
                return;
            };
            _tabIndex = _arg1;
            tabIndexChanged = true;
            invalidateProperties();
        }
        public function set restrict(_arg1:String):void{
            if (_arg1 == _restrict){
                return;
            };
            _restrict = _arg1;
            restrictChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("restrictChanged"));
        }
        private function textField_textFieldStyleChangeHandler(_arg1:Event):void{
            textFieldChanged(true, false);
        }
        private function textField_changeHandler(_arg1:Event):void{
            textFieldChanged(false, false);
            textChanged = false;
            htmlTextChanged = false;
            _arg1.stopImmediatePropagation();
            dispatchEvent(new Event(Event.CHANGE));
        }
        override public function set enabled(_arg1:Boolean):void{
            if (_arg1 == enabled){
                return;
            };
            super.enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
            if (((border) && ((border is IInvalidating)))){
                IInvalidating(border).invalidateDisplayList();
            };
        }
        override public function get baselinePosition():Number{
            var _local1:String;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local1 = text;
                if (_local1 == ""){
                    _local1 = " ";
                };
                return ((((((border) && ((border is IRectangularBorder)))) ? IRectangularBorder(border).borderMetrics.top : 0) + measureText(_local1).ascent));
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
        public function set displayAsPassword(_arg1:Boolean):void{
            if (_arg1 == _displayAsPassword){
                return;
            };
            _displayAsPassword = _arg1;
            displayAsPasswordChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("displayAsPasswordChanged"));
        }
        mx_internal function removeTextField():void{
            if (textField){
                textField.removeEventListener(Event.CHANGE, textField_changeHandler);
                textField.removeEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
                textField.removeEventListener(Event.SCROLL, textField_scrollHandler);
                textField.removeEventListener("textFieldStyleChange", textField_textFieldStyleChangeHandler);
                textField.removeEventListener("textFormatChange", textField_textFormatChangeHandler);
                textField.removeEventListener("textInsert", textField_textModifiedHandler);
                textField.removeEventListener("textReplace", textField_textModifiedHandler);
                removeChild(DisplayObject(textField));
                textField = null;
            };
        }
        public function get data():Object{
            return (_data);
        }
        public function set maxChars(_arg1:int):void{
            if (_arg1 == _maxChars){
                return;
            };
            _maxChars = _arg1;
            maxCharsChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("maxCharsChanged"));
        }
        public function set horizontalScrollPosition(_arg1:Number):void{
            if (_arg1 == _horizontalScrollPosition){
                return;
            };
            _horizontalScrollPosition = _arg1;
            horizontalScrollPositionChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("horizontalScrollPositionChanged"));
        }
        override public function setFocus():void{
            textField.setFocus();
        }
        public function get restrict():String{
            return (_restrict);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        public function set selectionBeginIndex(_arg1:int):void{
            _selectionBeginIndex = _arg1;
            selectionChanged = true;
            invalidateProperties();
        }
        public function set selectionEndIndex(_arg1:int):void{
            _selectionEndIndex = _arg1;
            selectionChanged = true;
            invalidateProperties();
        }
        private function textField_scrollHandler(_arg1:Event):void{
            _horizontalScrollPosition = textField.scrollH;
        }
        public function get textHeight():Number{
            return (_textHeight);
        }
        public function set editable(_arg1:Boolean):void{
            if (_arg1 == _editable){
                return;
            };
            _editable = _arg1;
            editableChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("editableChanged"));
        }
        override protected function commitProperties():void{
            var _local1:int;
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                _local1 = getChildIndex(DisplayObject(textField));
                removeTextField();
                createTextField(_local1);
                accessibilityPropertiesChanged = true;
                condenseWhiteChanged = true;
                displayAsPasswordChanged = true;
                enabledChanged = true;
                maxCharsChanged = true;
                restrictChanged = true;
                tabIndexChanged = true;
                textChanged = true;
                selectionChanged = true;
                horizontalScrollPositionChanged = true;
            };
            if (accessibilityPropertiesChanged){
                textField.accessibilityProperties = _accessibilityProperties;
                accessibilityPropertiesChanged = false;
            };
            if (condenseWhiteChanged){
                textField.condenseWhite = _condenseWhite;
                condenseWhiteChanged = false;
            };
            if (displayAsPasswordChanged){
                textField.displayAsPassword = _displayAsPassword;
                displayAsPasswordChanged = false;
            };
            if (((enabledChanged) || (editableChanged))){
                textField.type = ((((enabled) && (_editable))) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
                if (enabledChanged){
                    if (textField.enabled != enabled){
                        textField.enabled = enabled;
                    };
                    enabledChanged = false;
                };
                selectableChanged = true;
                editableChanged = false;
            };
            if (selectableChanged){
                if (_editable){
                    textField.selectable = enabled;
                } else {
                    textField.selectable = ((enabled) && (_selectable));
                };
                selectableChanged = false;
            };
            if (maxCharsChanged){
                textField.maxChars = _maxChars;
                maxCharsChanged = false;
            };
            if (restrictChanged){
                textField.restrict = _restrict;
                restrictChanged = false;
            };
            if (tabIndexChanged){
                textField.tabIndex = _tabIndex;
                tabIndexChanged = false;
            };
            if (((textChanged) || (htmlTextChanged))){
                if (isHTML){
                    textField.htmlText = explicitHTMLText;
                } else {
                    textField.text = _text;
                };
                textFieldChanged(false, true);
                textChanged = false;
                htmlTextChanged = false;
            };
            if (selectionChanged){
                textField.setSelection(_selectionBeginIndex, _selectionEndIndex);
                selectionChanged = false;
            };
            if (horizontalScrollPositionChanged){
                textField.scrollH = _horizontalScrollPosition;
                horizontalScrollPositionChanged = false;
            };
        }
        override public function styleChanged(_arg1:String):void{
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if (((_local2) || ((_arg1 == "borderSkin")))){
                if (border){
                    removeChild(DisplayObject(border));
                    border = null;
                    createBorder();
                };
            };
        }
        private function get isHTML():Boolean{
            return (!((explicitHTMLText == null)));
        }
        public function get maxChars():int{
            return (_maxChars);
        }
        public function get maxHorizontalScrollPosition():Number{
            return (((textField) ? textField.maxScrollH : 0));
        }
        mx_internal function set selectable(_arg1:Boolean):void{
            if (_selectable == _arg1){
                return;
            };
            _selectable = _arg1;
            selectableChanged = true;
            invalidateProperties();
        }
        public function get length():int{
            return (((text)!=null) ? text.length : -1);
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        private function textField_textModifiedHandler(_arg1:Event):void{
            textFieldChanged(false, true);
        }
        private function textField_textFormatChangeHandler(_arg1:Event):void{
            textFieldChanged(true, false);
        }
        public function set htmlText(_arg1:String):void{
            textSet = true;
            if (!_arg1){
                _arg1 = "";
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
            var _local3:EdgeMetrics;
            super.updateDisplayList(_arg1, _arg2);
            if (border){
                border.setActualSize(_arg1, _arg2);
                _local3 = (((border is IRectangularBorder)) ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY);
            } else {
                _local3 = EdgeMetrics.EMPTY;
            };
            var _local4:Number = getStyle("paddingLeft");
            var _local5:Number = getStyle("paddingRight");
            var _local6:Number = getStyle("paddingTop");
            var _local7:Number = getStyle("paddingBottom");
            var _local8:Number = (_local3.left + _local3.right);
            var _local9:Number = ((_local3.top + _local3.bottom) + 1);
            textField.x = _local3.left;
            textField.y = _local3.top;
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                textField.x = (textField.x + _local4);
                textField.y = (textField.y + _local6);
                _local8 = (_local8 + (_local4 + _local5));
                _local9 = (_local9 + (_local6 + _local7));
            };
            textField.width = Math.max(0, (_arg1 - _local8));
            textField.height = Math.max(0, (_arg2 - _local9));
        }
        public function getLineMetrics(_arg1:int):TextLineMetrics{
            return (((textField) ? textField.getLineMetrics(_arg1) : null));
        }

    }
}//package mx.controls 
