package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.collections.*;
    import mx.utils.*;

    public class ComboBase extends UIComponent implements IIMESupport, IFocusManagerComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;
        private static var _textInputStyleFilters:Object = {
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
            leading:"leading",
            paddingLeft:"paddingLeft",
            paddingRight:"paddingRight",
            shadowDirection:"shadowDirection",
            shadowDistance:"shadowDistance",
            textDecoration:"textDecoration"
        };

        private var _enabled:Boolean = false;
        mx_internal var useFullDropdownSkin:Boolean = false;
        mx_internal var selectedItemChanged:Boolean = false;
        mx_internal var selectionChanged:Boolean = false;
        mx_internal var downArrowButton:Button;
        private var _restrict:String;
        protected var collection:ICollectionView;
        private var _text:String = "";
        mx_internal var border:IFlexDisplayObject;
        private var _selectedItem:Object;
        mx_internal var editableChanged:Boolean = true;
        private var enabledChanged:Boolean = false;
        private var selectedUID:String;
        mx_internal var selectedIndexChanged:Boolean = false;
        mx_internal var oldBorderStyle:String;
        protected var textInput:TextInput;
        private var _editable:Boolean = false;
        mx_internal var collectionIterator:IViewCursor;
        mx_internal var textChanged:Boolean;
        private var _imeMode:String = null;
        protected var iterator:IViewCursor;
        mx_internal var wrapDownArrowButton:Boolean = true;
        private var _selectedIndex:int = -1;

        public function ComboBase(){
            tabEnabled = true;
        }
        protected function collectionChangeHandler(_arg1:Event):void{
            var _local2:Boolean;
            var _local3:Number;
            var _local4:Object;
            var _local5:CollectionEvent;
            var _local6:int;
            var _local7:String;
            if ((_arg1 is CollectionEvent)){
                _local2 = false;
                _local5 = CollectionEvent(_arg1);
                if (_local5.kind == CollectionEventKind.ADD){
                    if (selectedIndex >= _local5.location){
                        _selectedIndex++;
                    };
                };
                if (_local5.kind == CollectionEventKind.REMOVE){
                    _local6 = 0;
                    while (_local6 < _local5.items.length) {
                        _local7 = itemToUID(_local5.items[_local6]);
                        if (selectedUID == _local7){
                            selectionChanged = true;
                        };
                        _local6++;
                    };
                    if (selectionChanged){
                        if (_selectedIndex >= collection.length){
                            _selectedIndex = (collection.length - 1);
                        };
                        selectedIndexChanged = true;
                        _local2 = true;
                        invalidateDisplayList();
                    } else {
                        if (selectedIndex >= _local5.location){
                            _selectedIndex--;
                            selectedIndexChanged = true;
                            _local2 = true;
                            invalidateDisplayList();
                        };
                    };
                };
                if (_local5.kind == CollectionEventKind.REFRESH){
                    selectedItemChanged = true;
                    _local2 = true;
                };
                invalidateDisplayList();
                if (_local2){
                    dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                };
            };
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            _enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            super.focusOutHandler(_arg1);
            var _local2:IFocusManager = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = true;
            };
            if (_editable){
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            };
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return ((textInput.y + textInput.baselinePosition));
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((textInput.y + textInput.baselinePosition));
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
            if (textInput){
                textInput.imeMode = _imeMode;
            };
        }
        protected function itemToUID(_arg1:Object):String{
            if (!_arg1){
                return ("null");
            };
            return (UIDUtil.getUID(_arg1));
        }
        protected function downArrowButton_buttonDownHandler(_arg1:FlexEvent):void{
        }
        override protected function createChildren():void{
            var _local1:Class;
            var _local2:Object;
            super.createChildren();
            if (!border){
                _local1 = getStyle("borderSkin");
                if (_local1){
                    border = new (_local1)();
                    if ((border is IFocusManagerComponent)){
                        IFocusManagerComponent(border).focusEnabled = false;
                    };
                    if ((border is ISimpleStyleClient)){
                        ISimpleStyleClient(border).styleName = this;
                    };
                    addChild(DisplayObject(border));
                };
            };
            if (!downArrowButton){
                downArrowButton = new Button();
                downArrowButton.styleName = new StyleProxy(this, arrowButtonStyleFilters);
                downArrowButton.focusEnabled = false;
                addChild(downArrowButton);
                downArrowButton.addEventListener(FlexEvent.BUTTON_DOWN, downArrowButton_buttonDownHandler);
            };
            if (!textInput){
                _local2 = getStyle("textInputStyleName");
                if (!_local2){
                    _local2 = new StyleProxy(this, textInputStyleFilters);
                };
                textInput = new TextInput();
                textInput.editable = _editable;
                editableChanged = true;
                textInput.restrict = "^\x1B";
                textInput.focusEnabled = false;
                textInput.imeMode = _imeMode;
                textInput.styleName = _local2;
                textInput.addEventListener(Event.CHANGE, textInput_changeHandler);
                textInput.addEventListener(FlexEvent.ENTER, textInput_enterHandler);
                textInput.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
                textInput.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
                textInput.addEventListener(FlexEvent.VALUE_COMMIT, textInput_valueCommitHandler);
                addChild(textInput);
                textInput.move(0, 0);
                textInput.parentDrawsFocus = true;
            };
        }
        public function set selectedItem(_arg1:Object):void{
            setSelectedItem(_arg1);
        }
        override protected function initializeAccessibility():void{
            if (ComboBase.createAccessibilityImplementation != null){
                ComboBase.createAccessibilityImplementation(this);
            };
        }
        private function textInput_enterHandler(_arg1:FlexEvent):void{
            dispatchEvent(_arg1);
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        protected function calculatePreferredSizeFromData(_arg1:int):Object{
            return (null);
        }
        override public function setFocus():void{
            if (((textInput) && (_editable))){
                textInput.setFocus();
            } else {
                super.setFocus();
            };
        }
        private function textInput_valueCommitHandler(_arg1:FlexEvent):void{
            _text = textInput.text;
            dispatchEvent(_arg1);
        }
        public function get text():String{
            return (_text);
        }
        public function get dataProvider():Object{
            return (collection);
        }
        protected function get arrowButtonStyleFilters():Object{
            return (null);
        }
        public function set editable(_arg1:Boolean):void{
            _editable = _arg1;
            editableChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("editableChanged"));
        }
        override public function styleChanged(_arg1:String):void{
            if (downArrowButton){
                downArrowButton.styleChanged(_arg1);
            };
            if (textInput){
                textInput.styleChanged(_arg1);
            };
            if (((border) && ((border is ISimpleStyleClient)))){
                ISimpleStyleClient(border).styleChanged(_arg1);
            };
            super.styleChanged(_arg1);
        }
        public function get restrict():String{
            return (_restrict);
        }
        public function get selectedItem():Object{
            return (_selectedItem);
        }
        mx_internal function get ComboDownArrowButton():Button{
            return (downArrowButton);
        }
        private function setSelectedItem(_arg1:Object, _arg2:Boolean=true):void{
            if (((!(collection)) || ((collection.length == 0)))){
                _selectedItem = value;
                selectedItemChanged = true;
                invalidateDisplayList();
                return;
            };
            var _local3:Boolean;
            var _local4:IViewCursor = collection.createCursor();
            var _local5:int;
            do  {
                if (_arg1 == _local4.current){
                    _selectedIndex = _local5;
                    _selectedItem = _arg1;
                    selectedUID = itemToUID(_arg1);
                    selectionChanged = true;
                    _local3 = true;
                    break;
                };
                _local5++;
            } while (_local4.moveNext());
            if (!_local3){
                selectedIndex = -1;
                _selectedItem = null;
                selectedUID = null;
            };
            invalidateDisplayList();
        }
        override protected function commitProperties():void{
            var _local1:Boolean;
            super.commitProperties();
            textInput.restrict = _restrict;
            if (textChanged){
                textInput.text = _text;
                textChanged = false;
            };
            if (enabledChanged){
                textInput.enabled = _enabled;
                editableChanged = true;
                downArrowButton.enabled = _enabled;
                enabledChanged = false;
            };
            if (editableChanged){
                editableChanged = false;
                _local1 = _editable;
                if (wrapDownArrowButton == false){
                    if (_local1){
                        if (oldBorderStyle){
                            setStyle("borderStyle", oldBorderStyle);
                        };
                    } else {
                        oldBorderStyle = getStyle("borderStyle");
                        setStyle("borderStyle", "comboNonEdit");
                    };
                };
                if (useFullDropdownSkin){
                    downArrowButton.upSkinName = ((_local1) ? "editableUpSkin" : "upSkin");
                    downArrowButton.overSkinName = ((_local1) ? "editableOverSkin" : "overSkin");
                    downArrowButton.downSkinName = ((_local1) ? "editableDownSkin" : "downSkin");
                    downArrowButton.disabledSkinName = ((_local1) ? "editableDisabledSkin" : "disabledSkin");
                    downArrowButton.changeSkins();
                    downArrowButton.invalidateDisplayList();
                };
                if (textInput){
                    textInput.editable = _local1;
                    textInput.selectable = _local1;
                    if (_local1){
                        textInput.removeEventListener(MouseEvent.MOUSE_DOWN, textInput_mouseEventHandler);
                        textInput.removeEventListener(MouseEvent.MOUSE_UP, textInput_mouseEventHandler);
                        textInput.removeEventListener(MouseEvent.ROLL_OVER, textInput_mouseEventHandler);
                        textInput.removeEventListener(MouseEvent.ROLL_OUT, textInput_mouseEventHandler);
                        textInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    } else {
                        textInput.addEventListener(MouseEvent.MOUSE_DOWN, textInput_mouseEventHandler);
                        textInput.addEventListener(MouseEvent.MOUSE_UP, textInput_mouseEventHandler);
                        textInput.addEventListener(MouseEvent.ROLL_OVER, textInput_mouseEventHandler);
                        textInput.addEventListener(MouseEvent.ROLL_OUT, textInput_mouseEventHandler);
                        textInput.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    };
                };
            };
        }
        protected function get textInputStyleFilters():Object{
            return (_textInputStyleFilters);
        }
        public function set text(_arg1:String):void{
            _text = _arg1;
            textChanged = true;
            invalidateProperties();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        override protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((((_arg1 == textInput)) || (super.isOurFocus(_arg1))));
        }
        public function get editable():Boolean{
            return (_editable);
        }
        override protected function measure():void{
            var _local3:Object;
            var _local4:EdgeMetrics;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            super.measure();
            var _local1:Number = getStyle("arrowButtonWidth");
            var _local2:Number = downArrowButton.getExplicitOrMeasuredHeight();
            if (((collection) && ((collection.length > 0)))){
                _local3 = calculatePreferredSizeFromData(collection.length);
                _local4 = borderMetrics;
                _local5 = (((_local3.width + _local4.left) + _local4.right) + 8);
                _local6 = (((_local3.height + _local4.top) + _local4.bottom) + UITextField.TEXT_HEIGHT_PADDING);
                measuredMinWidth = (measuredWidth = (_local5 + _local1));
                measuredMinHeight = (measuredHeight = Math.max(_local6, _local2));
            } else {
                measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
                measuredWidth = DEFAULT_MEASURED_WIDTH;
                measuredMinHeight = DEFAULT_MEASURED_MIN_HEIGHT;
                measuredHeight = DEFAULT_MEASURED_HEIGHT;
            };
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                _local7 = (getStyle("paddingTop") + getStyle("paddingBottom"));
                measuredMinHeight = (measuredMinHeight + _local7);
                measuredHeight = (measuredHeight + _local7);
            };
        }
        protected function textInput_changeHandler(_arg1:Event):void{
            _text = textInput.text;
            if (_selectedIndex != -1){
                _selectedIndex = -1;
                _selectedItem = null;
                selectedUID = null;
            };
        }
        mx_internal function getTextInput():TextInput{
            return (textInput);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            super.focusInHandler(_arg1);
            var _local2:IFocusManager = focusManager;
            if (_local2){
                _local2.defaultButtonEnabled = false;
            };
        }
        public function get value():Object{
            if (_editable){
                return (text);
            };
            var _local1:Object = selectedItem;
            if ((((_local1 == null)) || (!((typeof(_local1) == "object"))))){
                return (_local1);
            };
            return (((_local1.data)!=null) ? _local1.data : _local1.label);
        }
        private function textInput_mouseEventHandler(_arg1:Event):void{
            downArrowButton.dispatchEvent(_arg1);
        }
        public function set selectedIndex(_arg1:int):void{
            var _local2:CursorBookmark;
            var _local3:int;
            var _local4:Object;
            var _local5:String;
            _selectedIndex = _arg1;
            if (_arg1 == -1){
                _selectedItem = null;
                selectedUID = null;
            };
            if (((!(collection)) || ((collection.length == 0)))){
                selectedIndexChanged = true;
            } else {
                if (_arg1 != -1){
                    _arg1 = Math.min(_arg1, (collection.length - 1));
                    _local2 = iterator.bookmark;
                    _local3 = _arg1;
                    iterator.seek(CursorBookmark.FIRST, _local3);
                    _local4 = iterator.current;
                    _local5 = itemToUID(_local4);
                    iterator.seek(_local2, 0);
                    _selectedIndex = _arg1;
                    _selectedItem = _local4;
                    selectedUID = _local5;
                };
            };
            selectionChanged = true;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        public function set dataProvider(_arg1:Object):void{
            var _local3:Array;
            if ((_arg1 is Array)){
                collection = new ArrayCollection((_arg1 as Array));
            } else {
                if ((_arg1 is ICollectionView)){
                    collection = ICollectionView(_arg1);
                } else {
                    if ((_arg1 is IList)){
                        collection = new ListCollectionView(IList(_arg1));
                    } else {
                        if ((_arg1 is XMLList)){
                            collection = new XMLListCollection((_arg1 as XMLList));
                        } else {
                            _local3 = [_arg1];
                            collection = new ArrayCollection(_local3);
                        };
                    };
                };
            };
            iterator = collection.createCursor();
            collectionIterator = collection.createCursor();
            collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
            var _local2:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _local2.kind = CollectionEventKind.RESET;
            collectionChangeHandler(_local2);
            dispatchEvent(_local2);
            invalidateSize();
            invalidateDisplayList();
        }
        protected function get borderMetrics():EdgeMetrics{
            if (((border) && ((border is IRectangularBorder)))){
                return (IRectangularBorder(border).borderMetrics);
            };
            return (EdgeMetrics.EMPTY);
        }
        public function set restrict(_arg1:String):void{
            _restrict = _arg1;
            invalidateProperties();
            dispatchEvent(new Event("restrictChanged"));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local7:EdgeMetrics;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = _arg1;
            var _local4:Number = _arg2;
            var _local5:Number = getStyle("arrowButtonWidth");
            var _local6:Number = textInput.getExplicitOrMeasuredHeight();
            if (isNaN(_local5)){
                _local5 = 0;
            };
            if (wrapDownArrowButton){
                _local7 = borderMetrics;
                _local8 = ((_local4 - _local7.top) - _local7.bottom);
                downArrowButton.setActualSize(_local8, _local8);
                downArrowButton.move(((_local3 - _local5) - _local7.right), _local7.top);
                border.setActualSize(_local3, _local4);
                textInput.setActualSize((_local3 - _local5), _local6);
            } else {
                if (((!(_editable)) && (useFullDropdownSkin))){
                    _local9 = getStyle("paddingTop");
                    _local10 = getStyle("paddingBottom");
                    downArrowButton.move(0, 0);
                    border.setActualSize(_local3, _local4);
                    textInput.setActualSize((_local3 - _local5), _local6);
                    textInput.border.visible = false;
                    if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                        textInput.move(textInput.x, (((((_local4 - _local6) - _local9) - _local10) / 2) + _local9));
                    };
                    downArrowButton.setActualSize(_arg1, _arg2);
                } else {
                    downArrowButton.move((_local3 - _local5), 0);
                    border.setActualSize((_local3 - _local5), _local4);
                    textInput.setActualSize((_local3 - _local5), _local4);
                    downArrowButton.setActualSize(_local5, _arg2);
                    textInput.border.visible = true;
                };
            };
            if (selectedIndexChanged){
                selectedIndex = selectedIndex;
                selectedIndexChanged = false;
            };
            if (selectedItemChanged){
                selectedItem = selectedItem;
                selectedItemChanged = false;
            };
        }
        public function get selectedIndex():int{
            return (_selectedIndex);
        }

    }
}//package mx.controls 
