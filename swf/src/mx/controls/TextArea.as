package mx.controls {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.listClasses.*;
    import flash.system.*;
    import flash.accessibility.*;

    public class TextArea extends ScrollControlBase implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _text:String = "";
        private var _selectable:Boolean = true;
        private var _textWidth:Number;
        private var _restrict:String = null;
        private var htmlTextChanged:Boolean = false;
        private var _maxChars:int = 0;
        private var enabledChanged:Boolean = false;
        private var _condenseWhite:Boolean = false;
        private var accessibilityPropertiesChanged:Boolean = false;
        private var _hScrollPosition:Number;
        private var _textHeight:Number;
        private var displayAsPasswordChanged:Boolean = false;
        private var prevMode:String = "UNKNOWN";
        private var selectableChanged:Boolean = false;
        private var restrictChanged:Boolean = false;
        private var selectionChanged:Boolean = false;
        private var maxCharsChanged:Boolean = false;
        private var _tabIndex:int = -1;
        private var errorCaught:Boolean = false;
        private var _selectionBeginIndex:int = 0;
        private var wordWrapChanged:Boolean = false;
        private var _data:Object;
        private var explicitHTMLText:String = null;
        private var styleSheetChanged:Boolean = false;
        private var tabIndexChanged:Boolean = false;
        private var editableChanged:Boolean = false;
        private var _editable:Boolean = true;
        private var allowScrollEvent:Boolean = true;
        private var _imeMode:String = null;
        private var condenseWhiteChanged:Boolean = false;
        protected var textField:IUITextField;
        private var _listData:BaseListData;
        private var _displayAsPassword:Boolean = false;
        private var _wordWrap:Boolean = true;
        private var _styleSheet:StyleSheet;
        private var textChanged:Boolean = false;
        private var _accessibilityProperties:AccessibilityProperties;
        private var _selectionEndIndex:int = 0;
        private var _htmlText:String = "";
        private var _vScrollPosition:Number;
        private var textSet:Boolean;

        public function TextArea(){
            tabChildren = true;
            _horizontalScrollPolicy = ScrollPolicy.AUTO;
            _verticalScrollPolicy = ScrollPolicy.AUTO;
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = true;
            };
            super.focusOutHandler(_arg1);
            if (((!((_imeMode == null))) && (_editable))){
                if (((!((IME.conversionMode == IMEConversionMode.UNKNOWN))) && (!((prevMode == IMEConversionMode.UNKNOWN))))){
                    IME.conversionMode = prevMode;
                };
                IME.enabled = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
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
            createTextField(-1);
        }
        private function adjustScrollBars():void{
            var _local1:Number = ((textField.bottomScrollV - textField.scrollV) + 1);
            var _local2:Number = textField.numLines;
            setScrollBarProperties((textField.width + textField.maxScrollH), textField.width, textField.numLines, _local1);
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
        private function textField_ioErrorHandler(_arg1:IOErrorEvent):void{
        }
        public function get text():String{
            return (_text);
        }
        public function get styleSheet():StyleSheet{
            return (_styleSheet);
        }
        mx_internal function createTextField(_arg1:int):void{
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.autoSize = TextFieldAutoSize.NONE;
                textField.enabled = enabled;
                textField.ignorePadding = true;
                textField.multiline = true;
                textField.selectable = true;
                textField.styleName = this;
                textField.tabEnabled = true;
                textField.type = TextFieldType.INPUT;
                textField.useRichTextClipboard = true;
                textField.wordWrap = true;
                textField.addEventListener(Event.CHANGE, textField_changeHandler);
                textField.addEventListener(Event.SCROLL, textField_scrollHandler);
                textField.addEventListener(IOErrorEvent.IO_ERROR, textField_ioErrorHandler);
                textField.addEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
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
        public function get selectionBeginIndex():int{
            return (((textField) ? textField.selectionBeginIndex : _selectionBeginIndex));
        }
        public function get selectable():Boolean{
            return (_selectable);
        }
        override public function set verticalScrollPosition(_arg1:Number):void{
            super.verticalScrollPosition = _arg1;
            _vScrollPosition = _arg1;
            if (textField){
                textField.scrollV = (_arg1 + 1);
                textField.background = false;
            } else {
                invalidateProperties();
            };
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
        public function set styleSheet(_arg1:StyleSheet):void{
            _styleSheet = _arg1;
            styleSheetChanged = true;
            htmlTextChanged = true;
            invalidateProperties();
        }
        override protected function measure():void{
            super.measure();
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinHeight = (measuredHeight = (2 * DEFAULT_MEASURED_MIN_HEIGHT));
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        public function get selectionEndIndex():int{
            return (((textField) ? textField.selectionEndIndex : _selectionEndIndex));
        }
        public function get editable():Boolean{
            return (_editable);
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
            };
            if (fm){
                fm.defaultButtonEnabled = false;
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
        public function get listData():BaseListData{
            return (_listData);
        }
        public function get wordWrap():Boolean{
            return (_wordWrap);
        }
        override public function set tabIndex(_arg1:int):void{
            if (_arg1 == _tabIndex){
                return;
            };
            _tabIndex = _arg1;
            tabIndexChanged = true;
            invalidateProperties();
        }
        public function get htmlText():String{
            return (_htmlText);
        }
        override public function set enabled(_arg1:Boolean):void{
            if (_arg1 == enabled){
                return;
            };
            super.enabled = _arg1;
            enabledChanged = true;
            if (verticalScrollBar){
                verticalScrollBar.enabled = _arg1;
            };
            if (horizontalScrollBar){
                horizontalScrollBar.enabled = _arg1;
            };
            invalidateProperties();
            if (((border) && ((border is IInvalidating)))){
                IInvalidating(border).invalidateDisplayList();
            };
        }
        private function textField_textFieldStyleChangeHandler(_arg1:Event):void{
            textFieldChanged(true, false);
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
        override public function get baselinePosition():Number{
            var _local1:String;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local1 = text;
                if (((!(_local1)) || ((_local1 == "")))){
                    _local1 = " ";
                };
                return ((viewMetrics.top + measureText(_local1).ascent));
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((textField.y + textField.baselinePosition));
        }
        private function textField_changeHandler(_arg1:Event):void{
            textFieldChanged(false, false);
            adjustScrollBars();
            textChanged = false;
            htmlTextChanged = false;
            _arg1.stopImmediatePropagation();
            dispatchEvent(new Event(Event.CHANGE));
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
        override public function get horizontalScrollPolicy():String{
            return ((((height <= 40)) ? ScrollPolicy.OFF : _horizontalScrollPolicy));
        }
        public function get data():Object{
            return (_data);
        }
        override public function get maxVerticalScrollPosition():Number{
            return (((textField) ? (textField.maxScrollV - 1) : 0));
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
        public function set selectable(_arg1:Boolean):void{
            if (_arg1 == selectable){
                return;
            };
            _selectable = _arg1;
            selectableChanged = true;
            invalidateProperties();
        }
        override public function set horizontalScrollPosition(_arg1:Number):void{
            super.horizontalScrollPosition = _arg1;
            _hScrollPosition = _arg1;
            if (textField){
                textField.scrollH = _arg1;
                textField.background = false;
            } else {
                invalidateProperties();
            };
        }
        override public function setFocus():void{
            var _local1:int = verticalScrollPosition;
            allowScrollEvent = false;
            textField.setFocus();
            verticalScrollPosition = _local1;
            allowScrollEvent = true;
        }
        public function set selectionBeginIndex(_arg1:int):void{
            _selectionBeginIndex = _arg1;
            selectionChanged = true;
            invalidateProperties();
        }
        public function get restrict():String{
            return (_restrict);
        }
        override protected function scrollHandler(_arg1:Event):void{
            if ((_arg1 is ScrollEvent)){
                if (((!(liveScrolling)) && ((ScrollEvent(_arg1).detail == ScrollEventDetail.THUMB_TRACK)))){
                    return;
                };
                super.scrollHandler(_arg1);
                textField.scrollH = horizontalScrollPosition;
                textField.scrollV = (verticalScrollPosition + 1);
                _vScrollPosition = (textField.scrollV - 1);
                _hScrollPosition = textField.scrollH;
            };
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        mx_internal function removeTextField():void{
            if (textField){
                textField.removeEventListener(Event.CHANGE, textField_changeHandler);
                textField.removeEventListener(Event.SCROLL, textField_scrollHandler);
                textField.removeEventListener(IOErrorEvent.IO_ERROR, textField_ioErrorHandler);
                textField.removeEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
                textField.removeEventListener("textFieldStyleChange", textField_textFieldStyleChangeHandler);
                textField.removeEventListener("textFormatChange", textField_textFormatChangeHandler);
                textField.removeEventListener("textInsert", textField_textModifiedHandler);
                textField.removeEventListener("textReplace", textField_textModifiedHandler);
                removeChild(DisplayObject(textField));
                textField = null;
            };
        }
        public function set selectionEndIndex(_arg1:int):void{
            _selectionEndIndex = _arg1;
            selectionChanged = true;
            invalidateProperties();
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
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                removeTextField();
                createTextField(-1);
                accessibilityPropertiesChanged = true;
                condenseWhiteChanged = true;
                displayAsPasswordChanged = true;
                editableChanged = true;
                enabledChanged = true;
                maxCharsChanged = true;
                restrictChanged = true;
                selectableChanged = true;
                tabIndexChanged = true;
                wordWrapChanged = true;
                textChanged = true;
                selectionChanged = true;
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
            if (editableChanged){
                textField.type = ((((_editable) && (enabled))) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
                editableChanged = false;
            };
            if (enabledChanged){
                textField.enabled = enabled;
                enabledChanged = false;
            };
            if (maxCharsChanged){
                textField.maxChars = _maxChars;
                maxCharsChanged = false;
            };
            if (restrictChanged){
                textField.restrict = _restrict;
                restrictChanged = false;
            };
            if (selectableChanged){
                textField.selectable = _selectable;
                selectableChanged = false;
            };
            if (styleSheetChanged){
                textField.styleSheet = _styleSheet;
                styleSheetChanged = false;
            };
            if (tabIndexChanged){
                textField.tabIndex = _tabIndex;
                tabIndexChanged = false;
            };
            if (wordWrapChanged){
                textField.wordWrap = _wordWrap;
                wordWrapChanged = false;
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
            if (!isNaN(_hScrollPosition)){
                horizontalScrollPosition = _hScrollPosition;
            };
            if (!isNaN(_vScrollPosition)){
                verticalScrollPosition = _vScrollPosition;
            };
        }
        private function get isHTML():Boolean{
            return (!((explicitHTMLText == null)));
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        public function get maxChars():int{
            return (_maxChars);
        }
        override public function get maxHorizontalScrollPosition():Number{
            return (((textField) ? textField.maxScrollH : 0));
        }
        override protected function mouseWheelHandler(_arg1:MouseEvent):void{
            _arg1.stopPropagation();
        }
        private function textField_scrollHandler(_arg1:Event):void{
            var _local2:int;
            var _local3:int;
            var _local4:ScrollEvent;
            if (((initialized) && (allowScrollEvent))){
                _local2 = (textField.scrollH - horizontalScrollPosition);
                _local3 = ((textField.scrollV - 1) - verticalScrollPosition);
                horizontalScrollPosition = textField.scrollH;
                verticalScrollPosition = (textField.scrollV - 1);
                if (_local2){
                    _local4 = new ScrollEvent(ScrollEvent.SCROLL, false, false, null, horizontalScrollPosition, ScrollEventDirection.HORIZONTAL, _local2);
                    dispatchEvent(_local4);
                };
                if (_local3){
                    _local4 = new ScrollEvent(ScrollEvent.SCROLL, false, false, null, verticalScrollPosition, ScrollEventDirection.VERTICAL, _local3);
                    dispatchEvent(_local4);
                };
            };
        }
        public function set wordWrap(_arg1:Boolean):void{
            if (_arg1 == _wordWrap){
                return;
            };
            _wordWrap = _arg1;
            wordWrapChanged = true;
            invalidateProperties();
            invalidateDisplayList();
            dispatchEvent(new Event("wordWrapChanged"));
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
            super.updateDisplayList(_arg1, _arg2);
            var _local3:EdgeMetrics = viewMetrics;
            _local3.left = (_local3.left + getStyle("paddingLeft"));
            _local3.top = (_local3.top + getStyle("paddingTop"));
            _local3.right = (_local3.right + getStyle("paddingRight"));
            _local3.bottom = (_local3.bottom + getStyle("paddingBottom"));
            textField.move(_local3.left, _local3.top);
            var _local4:Number = ((_arg1 - _local3.left) - _local3.right);
            var _local5:Number = ((_arg2 - _local3.top) - _local3.bottom);
            if ((_local3.top + _local3.bottom) > 0){
                _local5++;
            };
            textField.setActualSize(Math.max(4, _local4), Math.max(4, _local5));
            if (!initialized){
                callLater(invalidateDisplayList);
            } else {
                callLater(adjustScrollBars);
            };
            if (isNaN(_hScrollPosition)){
                _hScrollPosition = 0;
            };
            if (isNaN(_vScrollPosition)){
                _vScrollPosition = 0;
            };
            var _local6:Number = Math.min(textField.maxScrollH, _hScrollPosition);
            if (_local6 != textField.scrollH){
                horizontalScrollPosition = _local6;
            };
            _local6 = Math.min((textField.maxScrollV - 1), _vScrollPosition);
            if (_local6 != (textField.scrollV - 1)){
                verticalScrollPosition = _local6;
            };
        }
        public function getLineMetrics(_arg1:int):TextLineMetrics{
            return (((textField) ? textField.getLineMetrics(_arg1) : null));
        }
        override public function get verticalScrollPolicy():String{
            return ((((height <= 40)) ? ScrollPolicy.OFF : _verticalScrollPolicy));
        }
        public function get length():int{
            return (((text)!=null) ? text.length : -1);
        }

    }
}//package mx.controls 
