package mx.controls {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.listClasses.*;
    import flash.ui.*;

    public class NumericStepper extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IIMESupport, IListItemRenderer {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var _inputFieldStyleFilters:Object = {
            backgroundAlpha:"backgroundAlpha",
            backgroundColor:"backgroundColor",
            backgroundImage:"backgroundImage",
            backgroundDisabledColor:"backgroundDisabledColor",
            backgroundSize:"backgroundSize",
            borderAlpha:"borderAlpha",
            borderColor:"borderColor",
            borderSides:"borderSides",
            borderSkin:"borderSkin",
            borderStyle:"borderStyle",
            borderThickness:"borderThickness",
            dropShadowColor:"dropShadowColor",
            dropShadowEnabled:"dropShadowEnabled",
            embedFonts:"embedFonts",
            focusAlpha:"focusAlpha",
            focusBlendMode:"focusBlendMode",
            focusRoundedCorners:"focusRoundedCorners",
            focusThickness:"focusThickness",
            paddingLeft:"paddingLeft",
            paddingRight:"paddingRight",
            shadowDirection:"shadowDirection",
            shadowDistance:"shadowDistance",
            textDecoration:"textDecoration"
        };
        private static var _downArrowStyleFilters:Object = {
            cornerRadius:"cornerRadius",
            highlightAlphas:"highlightAlphas",
            downArrowUpSkin:"downArrowUpSkin",
            downArrowOverSkin:"downArrowOverSkin",
            downArrowDownSkin:"downArrowDownSkin",
            downArrowDisabledSkin:"downArrowDisabledSkin",
            downArrowSkin:"downArrowSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };
        private static var _upArrowStyleFilters:Object = {
            cornerRadius:"cornerRadius",
            highlightAlphas:"highlightAlphas",
            upArrowUpSkin:"upArrowUpSkin",
            upArrowOverSkin:"upArrowOverSkin",
            upArrowDownSkin:"upArrowDownSkin",
            upArrowDisabledSkin:"upArrowDisabledSkin",
            upArrowSkin:"upArrowSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        private var valueChanged:Boolean = false;
        mx_internal var nextButton:Button;
        private var valueSet:Boolean;
        private var enabledChanged:Boolean = false;
        mx_internal var prevButton:Button;
        private var _maxChars:int = 0;
        private var _stepSize:Number = 1;
        mx_internal var inputField:TextInput;
        private var _value:Number = 0;
        private var lastValue:Number = 0;
        private var _data:Object;
        private var maxCharsChanged:Boolean = false;
        private var _tabIndex:int = -1;
        private var proposedValue:Number = 0;
        private var tabIndexChanged:Boolean = false;
        private var _previousValue:Number = 0;
        private var _nextValue:Number = 0;
        private var _imeMode:String = null;
        private var _listData:BaseListData;
        private var _minimum:Number = 0;
        private var _maximum:Number = 10;

        public function NumericStepper(){
            tabChildren = true;
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
            if (inputField){
                inputField.imeMode = _imeMode;
            };
        }
        public function get minimum():Number{
            return (_minimum);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = true;
            };
            super.focusOutHandler(_arg1);
            takeValueFromTextField(_arg1);
        }
        private function checkRange(_arg1:Number):Boolean{
            return ((((_arg1 >= minimum)) && ((_arg1 <= maximum))));
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!inputField){
                inputField = new TextInput();
                inputField.styleName = new StyleProxy(this, inputFieldStyleFilters);
                inputField.focusEnabled = false;
                inputField.restrict = "0-9\\-\\.\\,";
                inputField.maxChars = _maxChars;
                inputField.text = String(_value);
                inputField.parentDrawsFocus = true;
                inputField.imeMode = _imeMode;
                inputField.addEventListener(FocusEvent.FOCUS_IN, inputField_focusInHandler);
                inputField.addEventListener(FocusEvent.FOCUS_OUT, inputField_focusOutHandler);
                inputField.addEventListener(KeyboardEvent.KEY_DOWN, inputField_keyDownHandler);
                inputField.addEventListener(Event.CHANGE, inputField_changeHandler);
                addChild(inputField);
            };
            if (!nextButton){
                nextButton = new Button();
                nextButton.styleName = new StyleProxy(this, upArrowStyleFilters);
                nextButton.upSkinName = "upArrowUpSkin";
                nextButton.overSkinName = "upArrowOverSkin";
                nextButton.downSkinName = "upArrowDownSkin";
                nextButton.disabledSkinName = "upArrowDisabledSkin";
                nextButton.skinName = "upArrowSkin";
                nextButton.upIconName = "";
                nextButton.overIconName = "";
                nextButton.downIconName = "";
                nextButton.disabledIconName = "";
                nextButton.focusEnabled = false;
                nextButton.autoRepeat = true;
                nextButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
                nextButton.addEventListener(FlexEvent.BUTTON_DOWN, buttonDownHandler);
                addChild(nextButton);
            };
            if (!prevButton){
                prevButton = new Button();
                prevButton.styleName = new StyleProxy(this, downArrowStyleFilters);
                prevButton.upSkinName = "downArrowUpSkin";
                prevButton.overSkinName = "downArrowOverSkin";
                prevButton.downSkinName = "downArrowDownSkin";
                prevButton.disabledSkinName = "downArrowDisabledSkin";
                prevButton.skinName = "downArrowSkin";
                prevButton.upIconName = "";
                prevButton.overIconName = "";
                prevButton.downIconName = "";
                prevButton.disabledIconName = "";
                prevButton.focusEnabled = false;
                prevButton.autoRepeat = true;
                prevButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
                prevButton.addEventListener(FlexEvent.BUTTON_DOWN, buttonDownHandler);
                addChild(prevButton);
            };
        }
        public function set minimum(_arg1:Number):void{
            _minimum = _arg1;
            if (!valueChanged){
                this.value = this.value;
                valueSet = false;
            };
            dispatchEvent(new Event("minimumChanged"));
        }
        public function get maximum():Number{
            return (_maximum);
        }
        private function inputField_focusOutHandler(_arg1:FocusEvent):void{
            focusOutHandler(_arg1);
            dispatchEvent(new FocusEvent(_arg1.type, false, false, _arg1.relatedObject, _arg1.shiftKey, _arg1.keyCode));
        }
        private function setValue(_arg1:Number, _arg2:Boolean=true, _arg3:Event=null):void{
            var _local5:NumericStepperEvent;
            var _local4:Number = checkValidValue(_arg1);
            if (_local4 == lastValue){
                return;
            };
            lastValue = (_value = _local4);
            inputField.text = _local4.toString();
            if (_arg2){
                _local5 = new NumericStepperEvent(NumericStepperEvent.CHANGE);
                _local5.value = _value;
                _local5.triggerEvent = _arg3;
                dispatchEvent(_local5);
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        protected function get downArrowStyleFilters():Object{
            return (_downArrowStyleFilters);
        }
        private function takeValueFromTextField(_arg1:Event=null):void{
            var _local3:Number;
            var _local2:Number = Number(inputField.text);
            if (((((!((_local2 == lastValue))) && ((((Math.abs((_local2 - lastValue)) >= 1E-6)) || (isNaN(_local2)))))) || ((inputField.text == "")))){
                _local3 = checkValidValue(Number(inputField.text));
                inputField.text = _local3.toString();
                setValue(_local3, !((_arg1 == null)), _arg1);
            };
        }
        private function inputField_focusInHandler(_arg1:FocusEvent):void{
            focusInHandler(_arg1);
            dispatchEvent(new FocusEvent(_arg1.type, false, false, _arg1.relatedObject, _arg1.shiftKey, _arg1.keyCode));
        }
        override public function get tabIndex():int{
            return (_tabIndex);
        }
        public function get nextValue():Number{
            if (checkRange((value + stepSize))){
                _nextValue = (value + stepSize);
            };
            return (_nextValue);
        }
        public function set maximum(_arg1:Number):void{
            _maximum = _arg1;
            if (!valueChanged){
                this.value = this.value;
                valueSet = false;
            };
            dispatchEvent(new Event("maximumChanged"));
        }
        override public function get enabled():Boolean{
            return (super.enabled);
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == inputField)) || (super.isOurFocus(_arg1))));
        }
        private function buttonPress(_arg1:Button, _arg2:Event=null):void{
            var _local3:Number;
            if (enabled){
                takeValueFromTextField();
                _local3 = lastValue;
                setValue((((_arg1 == nextButton)) ? (lastValue + stepSize) : (lastValue - stepSize)), true, _arg2);
                if (_local3 != lastValue){
                    inputField.getTextField().setSelection(0, 0);
                };
            };
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            if (!valueSet){
                this.value = ((_listData) ? parseFloat(_listData.label) : Number(_data));
                valueSet = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        protected function get upArrowStyleFilters():Object{
            return (_upArrowStyleFilters);
        }
        private function inputField_keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            switch (_arg1.keyCode){
                case Keyboard.DOWN:
                    _local2 = (value - stepSize);
                    setValue(_local2, true);
                    break;
                case Keyboard.UP:
                    _local2 = (stepSize + value);
                    setValue(_local2, true);
                    break;
                case Keyboard.HOME:
                    inputField.text = minimum.toString();
                    setValue(minimum, true);
                    break;
                case Keyboard.END:
                    inputField.text = maximum.toString();
                    setValue(maximum, true);
                    break;
                case Keyboard.ENTER:
                case Keyboard.TAB:
                    _local3 = Number(inputField.text);
                    if (((!((_local3 == lastValue))) && ((((Math.abs((_local3 - lastValue)) >= 1E-6)) || (isNaN(_local3)))))){
                        _local4 = checkValidValue(Number(inputField.text));
                        inputField.text = _local4.toString();
                        setValue(_local4, true);
                    };
                    _arg1.stopImmediatePropagation();
                    break;
            };
            dispatchEvent(_arg1);
        }
        override protected function measure():void{
            var _local5:Number;
            var _local8:Number;
            super.measure();
            var _local1:Number = (((minimum.toString().length > maximum.toString().length)) ? minimum : maximum);
            _local1 = (_local1 + stepSize);
            var _local2:TextLineMetrics = measureText(checkValidValue(_local1).toString());
            var _local3:Number = inputField.getExplicitOrMeasuredHeight();
            var _local4:Number = (prevButton.getExplicitOrMeasuredHeight() + nextButton.getExplicitOrMeasuredHeight());
            _local5 = Math.max(_local3, _local4);
            _local5 = Math.max(DEFAULT_MEASURED_MIN_HEIGHT, _local5);
            var _local6:Number = (_local2.width + UITextField.TEXT_WIDTH_PADDING);
            var _local7:Number = Math.max(prevButton.getExplicitOrMeasuredWidth(), nextButton.getExplicitOrMeasuredWidth());
            _local8 = ((_local6 + _local7) + 20);
            _local8 = Math.max(DEFAULT_MEASURED_MIN_WIDTH, _local8);
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
            measuredWidth = _local8;
            measuredHeight = _local5;
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            super.focusInHandler(_arg1);
            var _local2:IFocusManager = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = false;
            };
        }
        public function get value():Number{
            return (((valueChanged) ? proposedValue : _value));
        }
        protected function get inputFieldStyleFilters():Object{
            return (_inputFieldStyleFilters);
        }
        override public function set tabIndex(_arg1:int):void{
            if (_arg1 == _tabIndex){
                return;
            };
            _tabIndex = _arg1;
            tabIndexChanged = true;
            invalidateProperties();
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (((inputField) ? inputField.baselinePosition : NaN));
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((inputField.y + inputField.baselinePosition));
        }
        override public function setFocus():void{
            if (stage){
                stage.focus = TextField(inputField.getTextField());
            };
        }
        public function get data():Object{
            if (!_listData){
                data = this.value;
            };
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
        private function buttonDownHandler(_arg1:FlexEvent):void{
            buttonPress(Button(_arg1.currentTarget), _arg1);
        }
        public function get previousValue():Number{
            if (checkRange((_value - stepSize))){
                _previousValue = (value - stepSize);
            };
            return (_previousValue);
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (maxCharsChanged){
                maxCharsChanged = false;
                inputField.maxChars = _maxChars;
            };
            if (valueChanged){
                valueChanged = false;
                setValue(((isNaN(proposedValue)) ? 0 : proposedValue), false);
            };
            if (enabledChanged){
                enabledChanged = false;
                prevButton.enabled = enabled;
                nextButton.enabled = enabled;
                inputField.enabled = enabled;
            };
            if (tabIndexChanged){
                inputField.tabIndex = _tabIndex;
                tabIndexChanged = false;
            };
        }
        private function inputField_changeHandler(_arg1:Event):void{
            _arg1.stopImmediatePropagation();
            var _local2:Number = Number(inputField.text);
            if (((((!((_local2 == value))) && ((((Math.abs((_local2 - value)) >= 1E-6)) || (isNaN(_local2)))))) || ((inputField.text == "")))){
                _value = checkValidValue(_local2);
            };
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        public function get maxChars():int{
            return (_maxChars);
        }
        public function set stepSize(_arg1:Number):void{
            _stepSize = _arg1;
            if (!valueChanged){
                this.value = this.value;
                valueSet = false;
            };
            dispatchEvent(new Event("stepSizeChanged"));
        }
        public function set value(_arg1:Number):void{
            valueSet = true;
            proposedValue = _arg1;
            valueChanged = true;
            invalidateProperties();
            invalidateSize();
        }
        public function get stepSize():Number{
            return (_stepSize);
        }
        private function buttonClickHandler(_arg1:MouseEvent):void{
            inputField.setFocus();
            inputField.getTextField().setSelection(0, 0);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = nextButton.getExplicitOrMeasuredWidth();
            var _local4:Number = Math.round((_arg2 / 2));
            var _local5:Number = (_arg2 - _local4);
            nextButton.x = (_arg1 - _local3);
            nextButton.y = 0;
            nextButton.setActualSize(_local3, _local5);
            prevButton.x = (_arg1 - _local3);
            prevButton.y = (_arg2 - _local4);
            prevButton.setActualSize(_local3, _local4);
            inputField.setActualSize((_arg1 - _local3), _arg2);
        }
        private function checkValidValue(_arg1:Number):Number{
            var _local4:Number;
            if (isNaN(_arg1)){
                return (this.value);
            };
            var _local2:Number = (stepSize * Math.round((_arg1 / stepSize)));
            var _local3:Array = new String((1 + stepSize)).split(".");
            if (_local3.length == 2){
                _local4 = Math.pow(10, _local3[1].length);
                _local2 = (Math.round((_local2 * _local4)) / _local4);
            };
            if (_local2 > maximum){
                return (maximum);
            };
            if (_local2 < minimum){
                return (minimum);
            };
            return (_local2);
        }

    }
}//package mx.controls 
