package mx.controls {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;
    import mx.controls.listClasses.*;
    import mx.collections.*;
    import flash.ui.*;
    import mx.controls.dataGridClasses.*;

    public class ComboBox extends ComboBase implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;

        private var _labelField:String = "label";
        private var dropdownBorderStyle:String = "solid";
        private var implicitSelectedIndex:Boolean = false;
        private var _selectedIndexOnDropdown:int = -1;
        private var preferredDropdownWidth:Number;
        private var collectionChanged:Boolean = false;
        private var labelFunctionChanged:Boolean;
        private var selectedItemSet:Boolean;
        private var _dropdownWidth:Number = 100;
        private var inTween:Boolean = false;
        private var _oldIndex:int;
        private var tweenUp:Boolean = false;
        private var tween:Tween = null;
        private var labelFieldChanged:Boolean;
        private var _dropdown:ListBase;
        private var _dropdownFactory:IFactory;
        private var explicitText:Boolean;
        private var _prompt:String;
        private var _data:Object;
        private var bInKeyDown:Boolean = false;
        private var promptChanged:Boolean = false;
        private var _rowCount:int = 5;
        private var bRemoveDropdown:Boolean = false;
        private var _showingDropdown:Boolean = false;
        private var triggerEvent:Event;
        private var _listData:BaseListData;
        private var _itemRenderer:IFactory;
        private var _labelFunction:Function;

        public function ComboBox(){
            _dropdownFactory = new ClassFactory(List);
            super();
            dataProvider = new ArrayCollection();
            useFullDropdownSkin = true;
            wrapDownArrowButton = false;
            addEventListener("unload", unloadHandler);
            addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        }
        override protected function calculatePreferredSizeFromData(_arg1:int):Object{
            var _local6:TextLineMetrics;
            var _local8:Object;
            var _local9:String;
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:CursorBookmark = ((iterator) ? iterator.bookmark : null);
            iterator.seek(CursorBookmark.FIRST, 0);
            var _local5 = !((iterator == null));
            var _local7:int;
            while (_local7 < _arg1) {
                if (_local5){
                    _local8 = ((iterator) ? iterator.current : null);
                } else {
                    _local8 = null;
                };
                _local9 = itemToLabel(_local8);
                _local6 = measureText(_local9);
                _local2 = Math.max(_local2, _local6.width);
                _local3 = Math.max(_local3, _local6.height);
                if (iterator){
                    iterator.moveNext();
                };
                _local7++;
            };
            if (prompt){
                _local6 = measureText(prompt);
                _local2 = Math.max(_local2, _local6.width);
                _local3 = Math.max(_local3, _local6.height);
            };
            _local2 = (_local2 + (getStyle("paddingLeft") + getStyle("paddingRight")));
            if (iterator){
                iterator.seek(_local4, 0);
            };
            return ({
                width:_local2,
                height:_local3
            });
        }
        private function dropdown_scrollHandler(_arg1:Event):void{
            var _local2:ScrollEvent;
            if ((_arg1 is ScrollEvent)){
                _local2 = ScrollEvent(_arg1);
                if ((((((((_local2.detail == ScrollEventDetail.THUMB_TRACK)) || ((_local2.detail == ScrollEventDetail.THUMB_POSITION)))) || ((_local2.detail == ScrollEventDetail.LINE_UP)))) || ((_local2.detail == ScrollEventDetail.LINE_DOWN)))){
                    dispatchEvent(_local2);
                };
            };
        }
        public function get dropdown():ListBase{
            return (getDropdown());
        }
        public function get selectedLabel():String{
            var _local1:Object = selectedItem;
            return (itemToLabel(_local1));
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            if (((_showingDropdown) && (_dropdown))){
                if (((!(_arg1.relatedObject)) || (!(_dropdown.contains(_arg1.relatedObject))))){
                    close();
                };
            };
            super.focusOutHandler(_arg1);
        }
        private function popup_moveHandler(_arg1:Event):void{
            destroyDropdown();
        }
        private function destroyDropdown():void{
            if (((_dropdown) && (!(_showingDropdown)))){
                if (inTween){
                    tween.endTween();
                } else {
                    PopUpManager.removePopUp(_dropdown);
                    _dropdown = null;
                };
            };
        }
        public function get dropdownWidth():Number{
            return (_dropdownWidth);
        }
        private function unloadHandler(_arg1:Event):void{
            if (inTween){
                UIComponent.resumeBackgroundProcessing();
                inTween = false;
            };
            if (_dropdown){
                _dropdown.parent.removeChild(_dropdown);
            };
        }
        public function open():void{
            displayDropdown(true);
        }
        public function set data(_arg1:Object):void{
            var _local2:*;
            _data = _arg1;
            if (((_listData) && ((_listData is DataGridListData)))){
                _local2 = _data[DataGridListData(_listData).dataField];
            } else {
                if ((((_listData is ListData)) && ((ListData(_listData).labelField in _data)))){
                    _local2 = _data[ListData(_listData).labelField];
                } else {
                    _local2 = _data;
                };
            };
            if (((!((_local2 === undefined))) && (!(selectedItemSet)))){
                selectedItem = _local2;
                selectedItemSet = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        public function get rowCount():int{
            return (Math.max(1, Math.min(collection.length, _rowCount)));
        }
        override protected function textInput_changeHandler(_arg1:Event):void{
            super.textInput_changeHandler(_arg1);
            dispatchChangeEvent(_arg1, -1, -2);
        }
        private function dropdown_itemRollOutHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        override protected function measure():void{
            super.measure();
            measuredMinWidth = Math.max(measuredWidth, DEFAULT_MEASURED_MIN_WIDTH);
            var _local1:Number = (measureText("M").height + 6);
            var _local2:EdgeMetrics = borderMetrics;
            measuredMinHeight = (measuredHeight = Math.max(((_local1 + _local2.top) + _local2.bottom), DEFAULT_MEASURED_MIN_HEIGHT));
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                measuredMinHeight = (measuredHeight = (measuredHeight + (getStyle("paddingTop") + getStyle("paddingBottom"))));
            };
        }
        private function dropdown_itemRollOverHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        public function get prompt():String{
            return (_prompt);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:int;
            if (!enabled){
                return;
            };
            if (_arg1.target == textInput){
                return;
            };
            if (((_arg1.ctrlKey) && ((_arg1.keyCode == Keyboard.DOWN)))){
                displayDropdown(true, _arg1);
                _arg1.stopPropagation();
            } else {
                if (((_arg1.ctrlKey) && ((_arg1.keyCode == Keyboard.UP)))){
                    close(_arg1);
                    _arg1.stopPropagation();
                } else {
                    if (_arg1.keyCode == Keyboard.ESCAPE){
                        if (_showingDropdown){
                            if (_oldIndex != _dropdown.selectedIndex){
                                selectedIndex = _oldIndex;
                            };
                            displayDropdown(false);
                            _arg1.stopPropagation();
                        };
                    } else {
                        if (_arg1.keyCode == Keyboard.ENTER){
                            if (_showingDropdown){
                                close();
                                _arg1.stopPropagation();
                            };
                        } else {
                            if (((((((((!(editable)) || ((_arg1.keyCode == Keyboard.UP)))) || ((_arg1.keyCode == Keyboard.DOWN)))) || ((_arg1.keyCode == Keyboard.PAGE_UP)))) || ((_arg1.keyCode == Keyboard.PAGE_DOWN)))){
                                _local2 = selectedIndex;
                                bInKeyDown = _showingDropdown;
                                dropdown.dispatchEvent(_arg1.clone());
                                _arg1.stopPropagation();
                                bInKeyDown = false;
                            };
                        };
                    };
                };
            };
        }
        public function set dropdownWidth(_arg1:Number):void{
            _dropdownWidth = _arg1;
            preferredDropdownWidth = _arg1;
            if (_dropdown){
                _dropdown.setActualSize(_arg1, _dropdown.height);
            };
            dispatchEvent(new Event("dropdownWidthChanged"));
        }
        public function get labelField():String{
            return (_labelField);
        }
        public function set dropdownFactory(_arg1:IFactory):void{
            _dropdownFactory = _arg1;
            dispatchEvent(new Event("dropdownFactoryChanged"));
        }
        override public function set dataProvider(_arg1:Object):void{
            selectionChanged = true;
            super.dataProvider = _arg1;
            destroyDropdown();
            _showingDropdown = false;
            invalidateProperties();
            invalidateSize();
        }
        mx_internal function get isShowingDropdown():Boolean{
            return (_showingDropdown);
        }
        override protected function collectionChangeHandler(_arg1:Event):void{
            var _local3:CollectionEvent;
            var _local2:int = selectedIndex;
            super.collectionChangeHandler(_arg1);
            if ((_arg1 is CollectionEvent)){
                _local3 = CollectionEvent(_arg1);
                if (collection.length == 0){
                    if (((!(selectedIndexChanged)) && (!(selectedItemChanged)))){
                        if (super.selectedIndex != -1){
                            super.selectedIndex = -1;
                        };
                        implicitSelectedIndex = true;
                        invalidateDisplayList();
                    };
                    if (((textInput) && (!(editable)))){
                        textInput.text = "";
                    };
                } else {
                    if (_local3.kind == CollectionEventKind.ADD){
                        if (collection.length == _local3.items.length){
                            if ((((selectedIndex == -1)) && ((_prompt == null)))){
                                selectedIndex = 0;
                            };
                        } else {
                            return;
                        };
                    } else {
                        if (_local3.kind == CollectionEventKind.UPDATE){
                            if ((((_local3.location == selectedIndex)) || ((_local3.items[0].source == selectedItem)))){
                                selectionChanged = true;
                            };
                        } else {
                            if (_local3.kind == CollectionEventKind.REPLACE){
                                return;
                            };
                            if (_local3.kind == CollectionEventKind.RESET){
                                collectionChanged = true;
                                if (((!(selectedIndexChanged)) && (!(selectedItemChanged)))){
                                    selectedIndex = ((prompt) ? -1 : 0);
                                };
                                invalidateProperties();
                            };
                        };
                    };
                };
                invalidateDisplayList();
                destroyDropdown();
                _showingDropdown = false;
            };
        }
        mx_internal function onTweenEnd(_arg1:Number):void{
            if (_dropdown){
                _dropdown.scrollRect = null;
                inTween = false;
                _dropdown.enabled = true;
                _dropdown.visible = _showingDropdown;
            };
            if (bRemoveDropdown){
                _dropdown.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, dropdown_mouseOutsideHandler);
                _dropdown.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, dropdown_mouseOutsideHandler);
                _dropdown.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, dropdown_mouseOutsideHandler);
                _dropdown.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, dropdown_mouseOutsideHandler);
                PopUpManager.removePopUp(_dropdown);
                _dropdown = null;
                bRemoveDropdown = false;
            };
            UIComponent.resumeBackgroundProcessing();
            var _local2:DropdownEvent = new DropdownEvent(((_showingDropdown) ? DropdownEvent.OPEN : DropdownEvent.CLOSE));
            _local2.triggerEvent = triggerEvent;
            dispatchEvent(_local2);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        private function getDropdown():ListBase{
            var _local1:String;
            var _local2:CSSStyleDeclaration;
            if (!initialized){
                return (null);
            };
            if (!hasDropdown()){
                _local1 = getStyle("dropDownStyleName");
                if (_local1 == null){
                    _local1 = getStyle("dropdownStyleName");
                };
                _dropdown = dropdownFactory.newInstance();
                _dropdown.visible = false;
                _dropdown.focusEnabled = false;
                _dropdown.owner = this;
                if (itemRenderer){
                    _dropdown.itemRenderer = itemRenderer;
                };
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    _dropdown.styleName = this;
                };
                if (_local1){
                    if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                        _local2 = StyleManager.getStyleDeclaration(("." + _local1));
                        if (_local2){
                            _dropdown.styleDeclaration = _local2;
                        };
                    } else {
                        _dropdown.styleName = _local1;
                    };
                } else {
                    if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                        _dropdown.setStyle("cornerRadius", 0);
                    };
                };
                PopUpManager.addPopUp(_dropdown, this);
                _dropdown.setStyle("selectionDuration", 0);
                if ((((((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) && (dropdownBorderStyle))) && (!((dropdownBorderStyle == ""))))){
                    _dropdown.setStyle("borderStyle", dropdownBorderStyle);
                };
                if (!dataProvider){
                    dataProvider = new ArrayCollection();
                };
                _dropdown.dataProvider = dataProvider;
                _dropdown.rowCount = rowCount;
                _dropdown.width = _dropdownWidth;
                _dropdown.selectedIndex = selectedIndex;
                _oldIndex = selectedIndex;
                _dropdown.verticalScrollPolicy = ScrollPolicy.AUTO;
                _dropdown.labelField = _labelField;
                _dropdown.labelFunction = _labelFunction;
                _dropdown.allowDragSelection = true;
                _dropdown.addEventListener("change", dropdown_changeHandler);
                _dropdown.addEventListener(ScrollEvent.SCROLL, dropdown_scrollHandler);
                _dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER, dropdown_itemRollOverHandler);
                _dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT, dropdown_itemRollOutHandler);
                _dropdown.addEventListener(ListEvent.ITEM_CLICK, dropdown_itemClickHandler);
                UIComponentGlobals.layoutManager.validateClient(_dropdown, true);
                _dropdown.setActualSize(_dropdownWidth, _dropdown.getExplicitOrMeasuredHeight());
                _dropdown.validateDisplayList();
                _dropdown.cacheAsBitmap = true;
                systemManager.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
            };
            _dropdown.scaleX = scaleX;
            _dropdown.scaleY = scaleY;
            return (_dropdown);
        }
        private function stage_resizeHandler(_arg1:Event):void{
            if (_dropdown){
                _dropdown.$visible = false;
                _showingDropdown = false;
            };
        }
        override protected function downArrowButton_buttonDownHandler(_arg1:FlexEvent):void{
            if (_showingDropdown){
                close(_arg1);
            } else {
                displayDropdown(true, _arg1);
            };
        }
        override public function set selectedItem(_arg1:Object):void{
            selectedItemSet = true;
            super.selectedItem = _arg1;
        }
        override protected function initializeAccessibility():void{
            if (ComboBox.createAccessibilityImplementation != null){
                ComboBox.createAccessibilityImplementation(this);
            };
        }
        public function itemToLabel(_arg1:Object):String{
            var item:* = _arg1;
            if (item == null){
                return ("");
            };
            if (labelFunction != null){
                return (labelFunction(item));
            };
            if (typeof(item) == "object"){
                try {
                    if (item[labelField] != null){
                        item = item[labelField];
                    };
                } catch(e:Error) {
                };
            } else {
                if (typeof(item) == "xml"){
                    try {
                        if (item[labelField].length() != 0){
                            item = item[labelField];
                        };
                    } catch(e:Error) {
                    };
                };
            };
            if (typeof(item) == "string"){
                return (String(item));
            };
            try {
                return (item.toString());
            } catch(e:Error) {
            };
            return (" ");
        }
        public function get data():Object{
            return (_data);
        }
        mx_internal function onTweenUpdate(_arg1:Number):void{
            if (_dropdown){
                _dropdown.scrollRect = new Rectangle(0, _arg1, _dropdown.width, _dropdown.height);
            };
        }
        private function removedFromStageHandler(_arg1:Event):void{
            destroyDropdown();
        }
        private function dropdown_mouseOutsideHandler(_arg1:Event):void{
            var _local2:MouseEvent;
            if ((_arg1 is MouseEvent)){
                _local2 = MouseEvent(_arg1);
                if (_local2.target != _dropdown){
                    return;
                };
                if (!hitTestPoint(_local2.stageX, _local2.stageY, true)){
                    close(_arg1);
                };
            } else {
                if ((_arg1 is SandboxMouseEvent)){
                    close(_arg1);
                };
            };
        }
        public function get dropdownFactory():IFactory{
            return (_dropdownFactory);
        }
        override public function styleChanged(_arg1:String):void{
            destroyDropdown();
            super.styleChanged(_arg1);
        }
        public function set prompt(_arg1:String):void{
            _prompt = _arg1;
            promptChanged = true;
            invalidateProperties();
        }
        override protected function commitProperties():void{
            explicitText = textChanged;
            super.commitProperties();
            if (collectionChanged){
                if ((((((selectedIndex == -1)) && (implicitSelectedIndex))) && ((_prompt == null)))){
                    selectedIndex = 0;
                };
                selectedIndexChanged = true;
                collectionChanged = false;
            };
            if (((((promptChanged) && (!((prompt == null))))) && ((selectedIndex == -1)))){
                promptChanged = false;
                textInput.text = prompt;
            };
        }
        mx_internal function hasDropdown():Boolean{
            return (!((_dropdown == null)));
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        public function set labelField(_arg1:String):void{
            _labelField = _arg1;
            labelFieldChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("labelFieldChanged"));
        }
        public function set labelFunction(_arg1:Function):void{
            _labelFunction = _arg1;
            labelFunctionChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("labelFunctionChanged"));
        }
        protected function get dropDownStyleFilters():Object{
            return (null);
        }
        public function set rowCount(_arg1:int):void{
            _rowCount = _arg1;
            if (_dropdown){
                _dropdown.rowCount = _arg1;
            };
        }
        private function dropdown_changeHandler(_arg1:Event):void{
            var _local2:int = selectedIndex;
            if (_dropdown){
                selectedIndex = _dropdown.selectedIndex;
            };
            if (!_showingDropdown){
                dispatchChangeEvent(_arg1, _local2, selectedIndex);
            } else {
                if (!bInKeyDown){
                    close();
                };
            };
        }
        private function dropdown_itemClickHandler(_arg1:ListEvent):void{
            if (_showingDropdown){
                close();
            };
        }
        public function get labelFunction():Function{
            return (_labelFunction);
        }
        override public function set selectedIndex(_arg1:int):void{
            super.selectedIndex = _arg1;
            if (_arg1 >= 0){
                selectionChanged = true;
            };
            implicitSelectedIndex = false;
            invalidateDisplayList();
            if (((((textInput) && (!(textChanged)))) && ((_arg1 >= 0)))){
                textInput.text = selectedLabel;
            } else {
                if (((textInput) && (prompt))){
                    textInput.text = prompt;
                };
            };
        }
        private function dispatchChangeEvent(_arg1:Event, _arg2:int, _arg3:int):void{
            var _local4:Event;
            if (_arg2 != _arg3){
                _local4 = (((_arg1 is ListEvent)) ? _arg1 : new ListEvent("change"));
                dispatchEvent(_local4);
            };
        }
        private function displayDropdown(_arg1:Boolean, _arg2:Event=null):void{
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Function;
            var _local10:Rectangle;
            var _local11:InterManagerRequest;
            var _local12:int;
            var _local13:Number;
            if (((!(initialized)) || ((_arg1 == _showingDropdown)))){
                return;
            };
            var _local7:Point = new Point(0, unscaledHeight);
            _local7 = localToGlobal(_local7);
            var _local8:ISystemManager = systemManager.topLevelSystemManager;
            var _local9:DisplayObject = _local8.getSandboxRoot();
            if (_local8 != _local9){
                _local11 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "getVisibleApplicationRect");
                _local9.dispatchEvent(_local11);
                _local10 = Rectangle(_local11.value);
            } else {
                _local10 = _local8.getVisibleApplicationRect();
            };
            if (_arg1){
                _selectedIndexOnDropdown = selectedIndex;
                getDropdown();
                _dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, dropdown_mouseOutsideHandler);
                _dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, dropdown_mouseOutsideHandler);
                _dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, dropdown_mouseOutsideHandler);
                _dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, dropdown_mouseOutsideHandler);
                if (_dropdown.parent == null){
                    PopUpManager.addPopUp(_dropdown, this);
                } else {
                    PopUpManager.bringToFront(_dropdown);
                };
                if (((((_local7.y + _dropdown.height) > _local10.bottom)) && ((_local7.y > (_local10.top + _dropdown.height))))){
                    _local7.y = (_local7.y - (unscaledHeight + _dropdown.height));
                    _local3 = -(_dropdown.height);
                    tweenUp = true;
                } else {
                    _local3 = _dropdown.height;
                    tweenUp = false;
                };
                _local7 = _dropdown.parent.globalToLocal(_local7);
                _local12 = _dropdown.selectedIndex;
                if (_local12 == -1){
                    _local12 = 0;
                };
                _local13 = _dropdown.verticalScrollPosition;
                _local13 = (_local12 - 1);
                _local13 = Math.min(Math.max(_local13, 0), _dropdown.maxVerticalScrollPosition);
                _dropdown.verticalScrollPosition = _local13;
                if (((!((_dropdown.x == _local7.x))) || (!((_dropdown.y == _local7.y))))){
                    _dropdown.move(_local7.x, _local7.y);
                };
                _dropdown.scrollRect = new Rectangle(0, _local3, _dropdown.width, _dropdown.height);
                if (!_dropdown.visible){
                    _dropdown.visible = true;
                };
                bRemoveDropdown = false;
                _showingDropdown = _arg1;
                _local5 = getStyle("openDuration");
                _local4 = 0;
                _local6 = (getStyle("openEasingFunction") as Function);
            } else {
                if (_dropdown){
                    _local4 = ((((((_local7.y + _dropdown.height) > _local10.bottom)) || (tweenUp))) ? -(_dropdown.height) : _dropdown.height);
                    _showingDropdown = _arg1;
                    _local3 = 0;
                    _local5 = getStyle("closeDuration");
                    _local6 = (getStyle("closeEasingFunction") as Function);
                    _dropdown.resetDragScrolling();
                };
            };
            inTween = true;
            UIComponentGlobals.layoutManager.validateNow();
            UIComponent.suspendBackgroundProcessing();
            if (_dropdown){
                _dropdown.enabled = false;
            };
            _local5 = Math.max(1, _local5);
            tween = new Tween(this, _local3, _local4, _local5);
            if (((!((_local6 == null))) && (tween))){
                tween.easingFunction = _local6;
            };
            triggerEvent = _arg2;
        }
        public function get itemRenderer():IFactory{
            return (_itemRenderer);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            if (((_dropdown) && (!(inTween)))){
                destroyDropdown();
            } else {
                if (((!(_showingDropdown)) && (inTween))){
                    bRemoveDropdown = true;
                };
            };
            var _local3:Number = preferredDropdownWidth;
            if (isNaN(_local3)){
                _local3 = (_dropdownWidth = _arg1);
            };
            if (labelFieldChanged){
                if (_dropdown){
                    _dropdown.labelField = _labelField;
                };
                selectionChanged = true;
                if (!explicitText){
                    textInput.text = selectedLabel;
                };
                labelFieldChanged = false;
            };
            if (labelFunctionChanged){
                if (_dropdown){
                    _dropdown.labelFunction = _labelFunction;
                };
                selectionChanged = true;
                if (!explicitText){
                    textInput.text = selectedLabel;
                };
                labelFunctionChanged = false;
            };
            if (selectionChanged){
                if (!textChanged){
                    if ((((selectedIndex == -1)) && (prompt))){
                        textInput.text = prompt;
                    } else {
                        if (!explicitText){
                            textInput.text = selectedLabel;
                        };
                    };
                };
                textInput.invalidateDisplayList();
                textInput.validateNow();
                if (editable){
                    textInput.getTextField().setSelection(0, textInput.text.length);
                    textInput.getTextField().scrollH = 0;
                };
                if (_dropdown){
                    _dropdown.selectedIndex = selectedIndex;
                };
                selectionChanged = false;
            };
            if (((_dropdown) && (!((_dropdown.rowCount == rowCount))))){
                _dropdown.rowCount = rowCount;
            };
        }
        public function close(_arg1:Event=null):void{
            if (_showingDropdown){
                if (((_dropdown) && (!((selectedIndex == _dropdown.selectedIndex))))){
                    selectedIndex = _dropdown.selectedIndex;
                };
                displayDropdown(false, _arg1);
                dispatchChangeEvent(new Event("dummy"), _selectedIndexOnDropdown, selectedIndex);
            };
        }
        public function set itemRenderer(_arg1:IFactory):void{
            _itemRenderer = _arg1;
            if (_dropdown){
                _dropdown.itemRenderer = _arg1;
            };
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("itemRendererChanged"));
        }
        override public function set showInAutomationHierarchy(_arg1:Boolean):void{
        }

    }
}//package mx.controls 
