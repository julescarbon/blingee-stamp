package mx.containers {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import mx.automation.*;
    import flash.events.*;
    import mx.events.*;
    import mx.effects.*;
    import mx.graphics.*;

    public class ViewStack extends Container implements IHistoryManagerClient {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var dispatchChangeEventPending:Boolean = false;
        private var historyManagementEnabledChanged:Boolean = false;
        mx_internal var vsPreferredHeight:Number;
        private var initialSelectedIndex:int = -1;
        private var firstTime:Boolean = true;
        mx_internal var _historyManagementEnabled:Boolean = false;
        private var overlayChild:Container;
        private var overlayTargetArea:RoundedRectangle;
        private var proposedSelectedIndex:int = -1;
        private var needToInstantiateSelectedChild:Boolean = false;
        private var bSaveState:Boolean = false;
        mx_internal var vsMinHeight:Number;
        private var bInLoadState:Boolean = false;
        mx_internal var vsPreferredWidth:Number;
        private var _resizeToContent:Boolean = false;
        mx_internal var vsMinWidth:Number;
        private var lastIndex:int = -1;
        private var _selectedIndex:int = -1;

        public function ViewStack(){
            addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
            addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
        }
        protected function get contentHeight():Number{
            var _local1:EdgeMetrics = viewMetricsAndPadding;
            return (((unscaledHeight - _local1.top) - _local1.bottom));
        }
        public function set selectedChild(_arg1:Container):void{
            var _local2:int = getChildIndex(DisplayObject(_arg1));
            if ((((_local2 >= 0)) && ((_local2 < numChildren)))){
                selectedIndex = _local2;
            };
        }
        override mx_internal function setActualCreationPolicies(_arg1:String):void{
            var _local2:int;
            var _local3:Container;
            super.setActualCreationPolicies(_arg1);
            if ((((_arg1 == ContainerCreationPolicy.ALL)) && ((numChildren > 0)))){
                _local2 = 0;
                while (_local2 < numChildren) {
                    _local3 = (getChildAt(_local2) as Container);
                    if (((_local3) && ((_local3.numChildrenCreated == -1)))){
                        _local3.createComponentsFromDescriptors();
                    };
                    _local2++;
                };
            };
        }
        private function dispatchChangeEvent(_arg1:int, _arg2:int):void{
            var _local3:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
            _local3.oldIndex = _arg1;
            _local3.newIndex = _arg2;
            _local3.relatedObject = getChildAt(_arg2);
            dispatchEvent(_local3);
        }
        protected function get contentY():Number{
            return (getStyle("paddingTop"));
        }
        protected function commitSelectedIndex(_arg1:int):void{
            var _local3:Container;
            var _local4:Effect;
            if (numChildren == 0){
                _selectedIndex = -1;
                return;
            };
            if (_arg1 < 0){
                _arg1 = 0;
            } else {
                if (_arg1 > (numChildren - 1)){
                    _arg1 = (numChildren - 1);
                };
            };
            if (((!((lastIndex == -1))) && ((lastIndex < numChildren)))){
                Container(getChildAt(lastIndex)).endEffectsStarted();
            };
            if (_selectedIndex != -1){
                selectedChild.endEffectsStarted();
            };
            lastIndex = _selectedIndex;
            if (_arg1 == lastIndex){
                return;
            };
            _selectedIndex = _arg1;
            if (initialSelectedIndex == -1){
                initialSelectedIndex = _selectedIndex;
            };
            if (((!((lastIndex == -1))) && (!((_arg1 == -1))))){
                dispatchChangeEventPending = true;
            };
            var _local2:Boolean;
            if (((!((lastIndex == -1))) && ((lastIndex < numChildren)))){
                _local3 = Container(getChildAt(lastIndex));
                _local3.setVisible(false);
                if (_local3.getStyle("hideEffect")){
                    _local4 = EffectManager.lastEffectCreated;
                    if (_local4){
                        _local4.addEventListener(EffectEvent.EFFECT_END, hideEffectEndHandler);
                        _local2 = true;
                    };
                };
            };
            if (!_local2){
                hideEffectEndHandler(null);
            };
        }
        private function instantiateSelectedChild():void{
            if (!selectedChild){
                return;
            };
            if (((selectedChild) && ((selectedChild.numChildrenCreated == -1)))){
                if (initialized){
                    selectedChild.addEventListener(FlexEvent.CREATION_COMPLETE, childCreationCompleteHandler);
                };
                selectedChild.createComponentsFromDescriptors(true);
            };
            if ((selectedChild is IInvalidating)){
                IInvalidating(selectedChild).invalidateSize();
            };
            invalidateSize();
            invalidateDisplayList();
        }
        private function initializeHandler(_arg1:FlexEvent):void{
            overlayChild.removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
            UIComponent(overlayChild).addOverlay(overlayColor, overlayTargetArea);
        }
        public function set historyManagementEnabled(_arg1:Boolean):void{
            if (_arg1 != _historyManagementEnabled){
                _historyManagementEnabled = _arg1;
                historyManagementEnabledChanged = true;
                invalidateProperties();
            };
        }
        override public function get horizontalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        private function childAddHandler(_arg1:ChildExistenceChangedEvent):void{
            var _local4:IUIComponent;
            var _local2:DisplayObject = _arg1.relatedObject;
            var _local3:int = getChildIndex(_local2);
            if ((_local2 is IUIComponent)){
                _local4 = IUIComponent(_local2);
                _local4.visible = false;
            };
            if ((((numChildren == 1)) && ((proposedSelectedIndex == -1)))){
                proposedSelectedIndex = 0;
                invalidateProperties();
            } else {
                if ((((_local3 <= _selectedIndex)) && ((numChildren > 1)))){
                    selectedIndex++;
                };
            };
            if ((_local2 as IAutomationObject)){
            };
            IAutomationObject(_local2).showInAutomationHierarchy = true;
        }
        private function addedToStageHandler(_arg1:Event):void{
            if (historyManagementEnabled){
                HistoryManager.register(this);
            };
        }
        public function get resizeToContent():Boolean{
            return (_resizeToContent);
        }
        public function saveState():Object{
            var _local1:int = (((_selectedIndex == -1)) ? 0 : _selectedIndex);
            return ({selectedIndex:_local1});
        }
        override public function get autoLayout():Boolean{
            return (true);
        }
        override mx_internal function removeOverlay():void{
            if (overlayChild){
                UIComponent(overlayChild).removeOverlay();
                overlayChild = null;
            };
        }
        private function removedFromStageHandler(_arg1:Event):void{
            HistoryManager.unregister(this);
        }
        public function get selectedChild():Container{
            if (selectedIndex == -1){
                return (null);
            };
            return (Container(getChildAt(selectedIndex)));
        }
        private function hideEffectEndHandler(_arg1:EffectEvent):void{
            if (_arg1){
                _arg1.currentTarget.removeEventListener(EffectEvent.EFFECT_END, hideEffectEndHandler);
            };
            needToInstantiateSelectedChild = true;
            invalidateProperties();
            if (bSaveState){
                HistoryManager.save();
                bSaveState = false;
            };
        }
        private function childCreationCompleteHandler(_arg1:FlexEvent):void{
            _arg1.target.removeEventListener(FlexEvent.CREATION_COMPLETE, childCreationCompleteHandler);
            _arg1.target.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
        }
        override public function set horizontalScrollPolicy(_arg1:String):void{
        }
        public function get historyManagementEnabled():Boolean{
            return (_historyManagementEnabled);
        }
        public function loadState(_arg1:Object):void{
            var _local2:int = ((_arg1) ? int(_arg1.selectedIndex) : 0);
            if (_local2 == -1){
                _local2 = initialSelectedIndex;
            };
            if (_local2 == -1){
                _local2 = 0;
            };
            if (_local2 != _selectedIndex){
                bInLoadState = true;
                selectedIndex = _local2;
                bInLoadState = false;
            };
        }
        protected function get contentWidth():Number{
            var _local1:EdgeMetrics = viewMetricsAndPadding;
            return (((unscaledWidth - _local1.left) - _local1.right));
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (historyManagementEnabledChanged){
                if (historyManagementEnabled){
                    HistoryManager.register(this);
                } else {
                    HistoryManager.unregister(this);
                };
                historyManagementEnabledChanged = false;
            };
            if (proposedSelectedIndex != -1){
                commitSelectedIndex(proposedSelectedIndex);
                proposedSelectedIndex = -1;
            };
            if (needToInstantiateSelectedChild){
                instantiateSelectedChild();
                needToInstantiateSelectedChild = false;
            };
            if (dispatchChangeEventPending){
                dispatchChangeEvent(lastIndex, selectedIndex);
                dispatchChangeEventPending = false;
            };
            if (firstTime){
                firstTime = false;
                addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
                addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
            };
        }
        public function set resizeToContent(_arg1:Boolean):void{
            if (_arg1 != _resizeToContent){
                _resizeToContent = _arg1;
                if (_arg1){
                    invalidateSize();
                };
            };
        }
        override public function createComponentsFromDescriptors(_arg1:Boolean=true):void{
            if (actualCreationPolicy == ContainerCreationPolicy.ALL){
                super.createComponentsFromDescriptors();
                return;
            };
            var _local2:int = numChildren;
            var _local3:int = ((childDescriptors) ? childDescriptors.length : 0);
            var _local4:int;
            while (_local4 < _local3) {
                createComponentFromDescriptor(childDescriptors[_local4], false);
                _local4++;
            };
            numChildrenCreated = (numChildren - _local2);
            processedDescriptors = true;
        }
        override protected function measure():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local8:Container;
            super.measure();
            _local1 = 0;
            _local2 = 0;
            _local3 = 0;
            _local4 = 0;
            if (((vsPreferredWidth) && (!(_resizeToContent)))){
                measuredMinWidth = vsMinWidth;
                measuredMinHeight = vsMinHeight;
                measuredWidth = vsPreferredWidth;
                measuredHeight = vsPreferredHeight;
                return;
            };
            if ((((numChildren > 0)) && (!((selectedIndex == -1))))){
                _local8 = Container(getChildAt(selectedIndex));
                _local1 = _local8.minWidth;
                _local3 = _local8.getExplicitOrMeasuredWidth();
                _local2 = _local8.minHeight;
                _local4 = _local8.getExplicitOrMeasuredHeight();
            };
            var _local5:EdgeMetrics = viewMetricsAndPadding;
            var _local6:Number = (_local5.left + _local5.right);
            _local1 = (_local1 + _local6);
            _local3 = (_local3 + _local6);
            var _local7:Number = (_local5.top + _local5.bottom);
            _local2 = (_local2 + _local7);
            _local4 = (_local4 + _local7);
            measuredMinWidth = _local1;
            measuredMinHeight = _local2;
            measuredWidth = _local3;
            measuredHeight = _local4;
            if (((selectedChild) && ((Container(selectedChild).numChildrenCreated == -1)))){
                return;
            };
            if (numChildren == 0){
                return;
            };
            vsMinWidth = _local1;
            vsMinHeight = _local2;
            vsPreferredWidth = _local3;
            vsPreferredHeight = _local4;
        }
        override public function set verticalScrollPolicy(_arg1:String):void{
        }
        public function set selectedIndex(_arg1:int):void{
            if (_arg1 == selectedIndex){
                return;
            };
            proposedSelectedIndex = _arg1;
            invalidateProperties();
            if (((((historyManagementEnabled) && (!((_selectedIndex == -1))))) && (!(bInLoadState)))){
                bSaveState = true;
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        override mx_internal function addOverlay(_arg1:uint, _arg2:RoundedRectangle=null):void{
            if (overlayChild){
                removeOverlay();
            };
            overlayChild = selectedChild;
            if (!overlayChild){
                return;
            };
            overlayColor = _arg1;
            overlayTargetArea = _arg2;
            if (((selectedChild) && ((selectedChild.numChildrenCreated == -1)))){
                selectedChild.addEventListener(FlexEvent.INITIALIZE, initializeHandler);
            } else {
                initializeHandler(null);
            };
        }
        override public function set autoLayout(_arg1:Boolean):void{
        }
        override public function get verticalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        public function get selectedIndex():int{
            return ((((proposedSelectedIndex == -1)) ? _selectedIndex : proposedSelectedIndex));
        }
        private function childRemoveHandler(_arg1:ChildExistenceChangedEvent):void{
            var _local2:DisplayObject = _arg1.relatedObject;
            var _local3:int = getChildIndex(_local2);
            if (_local3 > selectedIndex){
                return;
            };
            var _local4:int = selectedIndex;
            if ((((_local3 < _local4)) || ((_local4 == (numChildren - 1))))){
                if (_local4 == 0){
                    selectedIndex = -1;
                    _selectedIndex = -1;
                } else {
                    selectedIndex--;
                };
            } else {
                if (_local3 == _local4){
                    needToInstantiateSelectedChild = true;
                    invalidateProperties();
                };
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local8:Container;
            var _local9:Number;
            var _local10:Number;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:int = numChildren;
            var _local4:Number = contentWidth;
            var _local5:Number = contentHeight;
            var _local6:Number = contentX;
            var _local7:Number = contentY;
            if (selectedIndex != -1){
                _local8 = Container(getChildAt(selectedIndex));
                _local9 = _local4;
                _local10 = _local5;
                if (!isNaN(_local8.percentWidth)){
                    if (_local9 > _local8.maxWidth){
                        _local9 = _local8.maxWidth;
                    };
                } else {
                    if (_local9 > _local8.explicitWidth){
                        _local9 = _local8.explicitWidth;
                    };
                };
                if (!isNaN(_local8.percentHeight)){
                    if (_local10 > _local8.maxHeight){
                        _local10 = _local8.maxHeight;
                    };
                } else {
                    if (_local10 > _local8.explicitHeight){
                        _local10 = _local8.explicitHeight;
                    };
                };
                if (((!((_local8.width == _local9))) || (!((_local8.height == _local10))))){
                    _local8.setActualSize(_local9, _local10);
                };
                if (((!((_local8.x == _local6))) || (!((_local8.y == _local7))))){
                    _local8.move(_local6, _local7);
                };
                _local8.visible = true;
            };
        }
        protected function get contentX():Number{
            return (getStyle("paddingLeft"));
        }

    }
}//package mx.containers 
