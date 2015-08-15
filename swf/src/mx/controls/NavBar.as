package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.containers.*;
    import mx.collections.*;

    public class NavBar extends Box {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _labelField:String = "label";
        private var _iconField:String = "icon";
        private var _dataProvider:IList;
        private var measurementHasBeenCalled:Boolean = false;
        private var _toolTipField:String = "toolTip";
        mx_internal var navItemFactory:IFactory;
        private var pendingTargetStack:Object;
        private var lastToolTip:String = null;
        private var _labelFunction:Function;
        mx_internal var targetStack:ViewStack;
        private var _selectedIndex:int = -1;
        private var dataProviderChanged:Boolean = false;

        public function NavBar(){
            navItemFactory = new ClassFactory(Button);
            super();
            direction = BoxDirection.HORIZONTAL;
            showInAutomationHierarchy = true;
        }
        public function get iconField():String{
            return (_iconField);
        }
        override public function set enabled(_arg1:Boolean):void{
            var _local2:int;
            var _local3:int;
            if (_arg1 != enabled){
                super.enabled = _arg1;
                _local2 = numChildren;
                _local3 = 0;
                while (_local3 < _local2) {
                    if (targetStack){
                        Button(getChildAt(_local3)).enabled = ((_arg1) && (Container(targetStack.getChildAt(_local3)).enabled));
                    } else {
                        Button(getChildAt(_local3)).enabled = _arg1;
                    };
                    _local3++;
                };
            };
        }
        protected function updateNavItemIcon(_arg1:int, _arg2:Class):void{
            var _local3:Button = Button(getChildAt(_arg1));
            _local3.setStyle("icon", _arg2);
        }
        private function childIndexChangeHandler(_arg1:IndexChangedEvent):void{
            if (_arg1.target == this){
                return;
            };
            setChildIndex(getChildAt(_arg1.oldIndex), _arg1.newIndex);
            resetNavItems();
        }
        protected function hiliteSelectedNavItem(_arg1:int):void{
        }
        private function checkPendingTargetStack():void{
            if (pendingTargetStack){
                _setTargetViewStack(pendingTargetStack);
                pendingTargetStack = null;
            };
        }
        private function setTargetViewStack(_arg1:Object):void{
            if (((!(measurementHasBeenCalled)) && (_arg1))){
                pendingTargetStack = _arg1;
                invalidateProperties();
            } else {
                _setTargetViewStack(_arg1);
            };
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (super.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            if (numChildren == 0){
                return (super.baselinePosition);
            };
            var _local1:Button = Button(getChildAt(0));
            validateNow();
            return ((_local1.y + _local1.baselinePosition));
        }
        private function enabledChangedHandler(_arg1:Event):void{
            var _local2:int = targetStack.getChildIndex(DisplayObject(_arg1.target));
            Button(getChildAt(_local2)).enabled = ((enabled) && (_arg1.target.enabled));
        }
        private function labelChangedHandler(_arg1:Event):void{
            var _local2:int = targetStack.getChildIndex(DisplayObject(_arg1.target));
            updateNavItemLabel(_local2, Container(_arg1.target).label);
        }
        override protected function createChildren():void{
            super.createChildren();
            if (dataProviderChanged){
                createNavChildren();
                dataProviderChanged = false;
            };
        }
        override public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            super.notifyStyleChangeInChildren(_arg1, true);
        }
        protected function clickHandler(_arg1:MouseEvent):void{
            var _local2:int = getChildIndex(DisplayObject(_arg1.currentTarget));
            if (targetStack){
                targetStack.selectedIndex = _local2;
            };
            _selectedIndex = _local2;
            var _local3:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
            _local3.label = Button(_arg1.currentTarget).label;
            _local3.index = _local2;
            _local3.relatedObject = InteractiveObject(_arg1.currentTarget);
            _local3.item = ((_dataProvider) ? _dataProvider.getItemAt(_local2) : null);
            dispatchEvent(_local3);
            _arg1.stopImmediatePropagation();
        }
        override public function get horizontalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        public function set iconField(_arg1:String):void{
            _iconField = _arg1;
            if (_dataProvider){
                dataProvider = _dataProvider;
            };
            dispatchEvent(new Event("iconFieldChanged"));
        }
        private function childAddHandler(_arg1:ChildExistenceChangedEvent):void{
            if (_arg1.target == this){
                return;
            };
            if (_arg1.relatedObject.parent != targetStack){
                return;
            };
            var _local2:Container = Container(_arg1.relatedObject);
            var _local3:Button = Button(createNavItem(itemToLabel(_local2), _local2.icon));
            var _local4:int = _local2.parent.getChildIndex(DisplayObject(_local2));
            setChildIndex(_local3, _local4);
            if (_local2.toolTip){
                _local3.toolTip = _local2.toolTip;
                _local2.toolTip = null;
            };
            _local2.addEventListener("labelChanged", labelChangedHandler);
            _local2.addEventListener("iconChanged", iconChangedHandler);
            _local2.addEventListener("enabledChanged", enabledChangedHandler);
            _local2.addEventListener("toolTipChanged", toolTipChangedHandler);
            _local3.enabled = ((enabled) && (_local2.enabled));
        }
        public function itemToLabel(_arg1:Object):String{
            var data:* = _arg1;
            if (data == null){
                return ("");
            };
            if (labelFunction != null){
                return (labelFunction(data));
            };
            if ((data is XML)){
                try {
                    if (data[labelField].length() != 0){
                        data = data[labelField];
                    };
                } catch(e:Error) {
                };
            } else {
                if ((data is Object)){
                    try {
                        if (data[labelField] != null){
                            data = data[labelField];
                        };
                    } catch(e:Error) {
                    };
                };
            };
            if ((data is String)){
                return (String(data));
            };
            if ((data is Number)){
                return (data.toString());
            };
            return ("");
        }
        private function createNavChildren():void{
            var item:* = null;
            var navItem:* = null;
            var label:* = null;
            var iconValue:* = null;
            var icon:* = null;
            if (!_dataProvider){
                return;
            };
            var n:* = _dataProvider.length;
            var i:* = 0;
            while (i < n) {
                item = _dataProvider.getItemAt(i);
                if ((item is String)){
                    navItem = Button(createNavItem(String(item)));
                } else {
                    label = itemToLabel(item);
                    if (iconField){
                        iconValue = null;
                        try {
                            iconValue = item[iconField];
                        } catch(e:Error) {
                        };
                        icon = (((iconValue is String)) ? Class(systemManager.getDefinitionByName(String(iconValue))) : Class(iconValue));
                        navItem = Button(createNavItem(label, icon));
                    } else {
                        navItem = Button(createNavItem(label, null));
                    };
                    if (toolTipField){
                        try {
                            navItem.toolTip = (((item[toolTipField] === undefined)) ? null : item[toolTipField]);
                        } catch(e:Error) {
                        };
                    };
                };
                navItem.enabled = enabled;
                i = (i + 1);
            };
        }
        public function set toolTipField(_arg1:String):void{
            _toolTipField = _arg1;
            if (_dataProvider){
                dataProvider = _dataProvider;
            };
            dispatchEvent(new Event("toolTipFieldChanged"));
        }
        private function _setTargetViewStack(_arg1:Object):void{
            var _local2:ViewStack;
            var _local6:Container;
            var _local7:Button;
            if ((_arg1 is ViewStack)){
                _local2 = ViewStack(_arg1);
            } else {
                if (_arg1){
                    _local2 = parentDocument[_arg1];
                } else {
                    _local2 = null;
                };
            };
            if (targetStack){
                targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
                targetStack.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
                targetStack.removeEventListener(Event.CHANGE, changeHandler);
                targetStack.removeEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE, childIndexChangeHandler);
            };
            removeAllChildren();
            _selectedIndex = -1;
            targetStack = _local2;
            if (!targetStack){
                return;
            };
            targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
            targetStack.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
            targetStack.addEventListener(Event.CHANGE, changeHandler);
            targetStack.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE, childIndexChangeHandler);
            var _local3:int = targetStack.numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local6 = Container(targetStack.getChildAt(_local4));
                _local7 = Button(createNavItem(itemToLabel(_local6), _local6.icon));
                if (_local6.toolTip){
                    _local7.toolTip = _local6.toolTip;
                    _local6.toolTip = null;
                };
                _local6.addEventListener("labelChanged", labelChangedHandler);
                _local6.addEventListener("iconChanged", iconChangedHandler);
                _local6.addEventListener("enabledChanged", enabledChangedHandler);
                _local6.addEventListener("toolTipChanged", toolTipChangedHandler);
                _local7.enabled = ((enabled) && (_local6.enabled));
                _local4++;
            };
            var _local5:int = targetStack.selectedIndex;
            if ((((_local5 == -1)) && ((targetStack.numChildren > 0)))){
                _local5 = 0;
            };
            if (_local5 != -1){
                hiliteSelectedNavItem(_local5);
            };
            invalidateDisplayList();
        }
        private function toolTipChangedHandler(_arg1:Event):void{
            var _local2:int = targetStack.getChildIndex(DisplayObject(_arg1.target));
            var _local3:UIComponent = UIComponent(getChildAt(_local2));
            if (UIComponent(_arg1.target).toolTip){
                _local3.toolTip = UIComponent(_arg1.target).toolTip;
                lastToolTip = UIComponent(_arg1.target).toolTip;
                UIComponent(_arg1.target).toolTip = null;
            } else {
                if (!lastToolTip){
                    _local3.toolTip = UIComponent(_arg1.target).toolTip;
                    lastToolTip = "placeholder";
                    UIComponent(_arg1.target).toolTip = null;
                } else {
                    lastToolTip = null;
                };
            };
        }
        protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            return (null);
        }
        public function get dataProvider():Object{
            return (((targetStack) ? targetStack : _dataProvider));
        }
        protected function updateNavItemLabel(_arg1:int, _arg2:String):void{
            var _local3:Button = Button(getChildAt(_arg1));
            _local3.label = _arg2;
        }
        override public function set horizontalScrollPolicy(_arg1:String):void{
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (!measurementHasBeenCalled){
                checkPendingTargetStack();
                measurementHasBeenCalled = true;
            };
            if (dataProviderChanged){
                dataProviderChanged = false;
                createNavChildren();
            };
            if (blocker){
                blocker.visible = false;
            };
        }
        public function set labelField(_arg1:String):void{
            _labelField = _arg1;
            if (_dataProvider){
                dataProvider = _dataProvider;
            };
            dispatchEvent(new Event("labelFieldChanged"));
        }
        private function iconChangedHandler(_arg1:Event):void{
            var _local2:int = targetStack.getChildIndex(DisplayObject(_arg1.target));
            updateNavItemIcon(_local2, Container(_arg1.target).icon);
        }
        protected function resetNavItems():void{
        }
        public function get toolTipField():String{
            return (_toolTipField);
        }
        public function set labelFunction(_arg1:Function):void{
            _labelFunction = _arg1;
            invalidateDisplayList();
            dispatchEvent(new Event("labelFunctionChanged"));
        }
        public function get labelField():String{
            return (_labelField);
        }
        override public function set verticalScrollPolicy(_arg1:String):void{
        }
        private function childRemoveHandler(_arg1:ChildExistenceChangedEvent):void{
            if (_arg1.target == this){
                return;
            };
            var _local2:ViewStack = ViewStack(_arg1.target);
            removeChildAt(_local2.getChildIndex(_arg1.relatedObject));
            callLater(resetNavItems);
        }
        public function get labelFunction():Function{
            return (_labelFunction);
        }
        override public function get verticalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        public function set dataProvider(_arg1:Object):void{
            var _local2:String;
            var _local3:String;
            if (((((((((_arg1) && (!((_arg1 is String))))) && (!((_arg1 is ViewStack))))) && (!((_arg1 is Array))))) && (!((_arg1 is IList))))){
                _local2 = resourceManager.getString("controls", "errWrongContainer", [id]);
                throw (new Error(_local2));
            };
            if ((((_arg1 is String)) && (((document) && (document[_arg1]))))){
                _arg1 = document[_arg1];
            };
            if ((((_arg1 is String)) || ((_arg1 is ViewStack)))){
                setTargetViewStack(_arg1);
                return;
            };
            if ((((((((_arg1 is IList)) && ((IList(_arg1).length > 0)))) && ((IList(_arg1).getItemAt(0) is DisplayObject)))) || ((((((_arg1 is Array)) && (((_arg1 as Array).length > 0)))) && ((_arg1[0] is DisplayObject)))))){
                _local3 = ((id) ? (((className + " '") + id) + "'") : ("a " + className));
                _local2 = resourceManager.getString("controls", "errWrongType", [_local3]);
                throw (new Error(_local2));
            };
            setTargetViewStack(null);
            removeAllChildren();
            if ((_arg1 is IList)){
                _dataProvider = IList(_arg1);
            } else {
                if ((_arg1 is Array)){
                    _dataProvider = new ArrayCollection((_arg1 as Array));
                } else {
                    _dataProvider = null;
                };
            };
            dataProviderChanged = true;
            invalidateProperties();
            if (_dataProvider){
                _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
            };
            if (inheritingStyles == UIComponent.STYLE_UNINITIALIZED){
                return;
            };
            dispatchEvent(new Event("collectionChange"));
        }
        private function changeHandler(_arg1:Event):void{
            if (_arg1.target == dataProvider){
                hiliteSelectedNavItem(Object(_arg1.target).selectedIndex);
            };
        }
        private function collectionChangeHandler(_arg1:Event):void{
            dataProvider = dataProvider;
        }
        public function set selectedIndex(_arg1:int):void{
            _selectedIndex = _arg1;
            if (targetStack){
                targetStack.selectedIndex = _arg1;
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        public function get selectedIndex():int{
            return (_selectedIndex);
        }

    }
}//package mx.controls 
