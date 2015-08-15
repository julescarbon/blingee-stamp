package mx.managers {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.system.*;
    import flash.ui.*;

    public class FocusManager implements IFocusManager {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const FROM_INDEX_UNSPECIFIED:int = -2;

        private var lastActiveFocusManager:FocusManager;
        private var _showFocusIndicator:Boolean = false;
        private var focusableCandidates:Array;
        private var LARGE_TAB_INDEX:int = 99999;
        private var browserFocusComponent:InteractiveObject;
        private var calculateCandidates:Boolean = true;
        private var _lastFocus:IFocusManagerComponent;
        private var lastAction:String;
        private var focusSetLocally:Boolean;
        private var focusableObjects:Array;
        private var swfBridgeGroup:SWFBridgeGroup;
        private var defButton:IButton;
        private var _form:IFocusManagerContainer;
        private var popup:Boolean;
        private var focusChanged:Boolean;
        private var _defaultButtonEnabled:Boolean = true;
        private var activated:Boolean = false;
        private var _defaultButton:IButton;
        private var fauxFocus:DisplayObject;
        private var _focusPane:Sprite;
        private var skipBridge:IEventDispatcher;
        public var browserMode:Boolean;

        public function FocusManager(_arg1:IFocusManagerContainer, _arg2:Boolean=false){
            var sm:* = null;
            var bridge:* = null;
            var container:* = _arg1;
            var popup:Boolean = _arg2;
            super();
            this.popup = popup;
            browserMode = (((Capabilities.playerType == "ActiveX")) && (!(popup)));
            container.focusManager = this;
            _form = container;
            focusableObjects = [];
            focusPane = new FlexSprite();
            focusPane.name = "focusPane";
            addFocusables(DisplayObject(container));
            container.addEventListener(Event.ADDED, addedHandler);
            container.addEventListener(Event.REMOVED, removedHandler);
            container.addEventListener(FlexEvent.SHOW, showHandler);
            container.addEventListener(FlexEvent.HIDE, hideHandler);
            if ((container.systemManager is SystemManager)){
                if (container != SystemManager(container.systemManager).application){
                    container.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
                };
            };
            try {
                container.systemManager.addFocusManager(container);
                sm = form.systemManager;
                swfBridgeGroup = new SWFBridgeGroup(sm);
                if (!popup){
                    swfBridgeGroup.parentBridge = sm.swfBridgeGroup.parentBridge;
                };
                if (sm.useSWFBridge()){
                    sm.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING, removeFromParentBridge);
                    bridge = swfBridgeGroup.parentBridge;
                    if (bridge){
                        bridge.addEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST, focusRequestMoveHandler);
                        bridge.addEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST, setShowFocusIndicatorRequestHandler);
                    };
                    if (((bridge) && (!((form.systemManager is SystemManagerProxy))))){
                        bridge.addEventListener(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST, focusRequestActivateHandler);
                        bridge.addEventListener(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST, focusRequestDeactivateHandler);
                        bridge.addEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE, bridgeEventActivateHandler);
                    };
                    container.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
                };
            } catch(e:Error) {
            };
        }
        private function dispatchSetShowFocusIndicatorRequest(_arg1:Boolean, _arg2:IEventDispatcher):void{
            var _local3:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST, false, false, null, _arg1);
            dispatchEventFromSWFBridges(_local3, _arg2);
        }
        private function creationCompleteHandler(_arg1:FlexEvent):void{
            if (((DisplayObject(form).visible) && (!(activated)))){
                form.systemManager.activate(form);
            };
        }
        private function addFocusables(_arg1:DisplayObject, _arg2:Boolean=false):void{
            var addToFocusables:* = false;
            var focusable:* = null;
            var doc:* = null;
            var rawChildren:* = null;
            var i:* = 0;
            var o:* = _arg1;
            var skipTopLevel:Boolean = _arg2;
            if ((((o is IFocusManagerComponent)) && (!(skipTopLevel)))){
                addToFocusables = false;
                if ((o is IFocusManagerComponent)){
                    focusable = IFocusManagerComponent(o);
                    if (focusable.focusEnabled){
                        if (((focusable.tabEnabled) && (isTabVisible(o)))){
                            addToFocusables = true;
                        };
                    };
                };
                if (addToFocusables){
                    if (focusableObjects.indexOf(o) == -1){
                        focusableObjects.push(o);
                        calculateCandidates = true;
                    };
                    o.addEventListener("tabEnabledChange", tabEnabledChangeHandler);
                    o.addEventListener("tabIndexChange", tabIndexChangeHandler);
                };
            };
            if ((o is DisplayObjectContainer)){
                doc = DisplayObjectContainer(o);
                o.addEventListener("tabChildrenChange", tabChildrenChangeHandler);
                if (doc.tabChildren){
                    if ((o is IRawChildrenContainer)){
                        rawChildren = IRawChildrenContainer(o).rawChildren;
                        i = 0;
                        while (i < rawChildren.numChildren) {
                            try {
                                addFocusables(rawChildren.getChildAt(i));
                            } catch(error:SecurityError) {
                            };
                            i = (i + 1);
                        };
                    } else {
                        i = 0;
                        while (i < doc.numChildren) {
                            try {
                                addFocusables(doc.getChildAt(i));
                            } catch(error:SecurityError) {
                            };
                            i = (i + 1);
                        };
                    };
                };
            };
        }
        private function tabEnabledChangeHandler(_arg1:Event):void{
            calculateCandidates = true;
            var _local2:InteractiveObject = InteractiveObject(_arg1.target);
            var _local3:int = focusableObjects.length;
            var _local4:int;
            while (_local4 < _local3) {
                if (focusableObjects[_local4] == _local2){
                    break;
                };
                _local4++;
            };
            if (_local2.tabEnabled){
                if ((((_local4 == _local3)) && (isTabVisible(_local2)))){
                    if (focusableObjects.indexOf(_local2) == -1){
                        focusableObjects.push(_local2);
                    };
                };
            } else {
                if (_local4 < _local3){
                    focusableObjects.splice(_local4, 1);
                };
            };
        }
        private function mouseFocusChangeHandler(_arg1:FocusEvent):void{
            var _local2:TextField;
            if ((((((_arg1.relatedObject == null)) && (("isRelatedObjectInaccessible" in _arg1)))) && ((_arg1["isRelatedObjectInaccessible"] == true)))){
                return;
            };
            if ((_arg1.relatedObject is TextField)){
                _local2 = (_arg1.relatedObject as TextField);
                if ((((_local2.type == "input")) || (_local2.selectable))){
                    return;
                };
            };
            _arg1.preventDefault();
        }
        public function addSWFBridge(_arg1:IEventDispatcher, _arg2:DisplayObject):void{
            if (!_arg2){
                return;
            };
            var _local3:ISystemManager = _form.systemManager;
            if (focusableObjects.indexOf(_arg2) == -1){
                focusableObjects.push(_arg2);
                calculateCandidates = true;
            };
            swfBridgeGroup.addChildBridge(_arg1, ISWFBridgeProvider(_arg2));
            _arg1.addEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST, focusRequestMoveHandler);
            _arg1.addEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST, setShowFocusIndicatorRequestHandler);
            _arg1.addEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE, bridgeEventActivateHandler);
        }
        private function getChildIndex(_arg1:DisplayObjectContainer, _arg2:DisplayObject):int{
            var parent:* = _arg1;
            var child:* = _arg2;
            try {
                return (parent.getChildIndex(child));
            } catch(e:Error) {
                if ((parent is IRawChildrenContainer)){
                    return (IRawChildrenContainer(parent).rawChildren.getChildIndex(child));
                };
                throw (e);
            };
            throw (new Error("FocusManager.getChildIndex failed"));
        }
        private function bridgeEventActivateHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeEvent)){
                return;
            };
            lastActiveFocusManager = null;
            _lastFocus = null;
            dispatchActivatedFocusManagerEvent(IEventDispatcher(_arg1.target));
        }
        private function focusOutHandler(_arg1:FocusEvent):void{
            var _local2:InteractiveObject = InteractiveObject(_arg1.target);
        }
        private function isValidFocusCandidate(_arg1:DisplayObject, _arg2:String):Boolean{
            var _local3:IFocusManagerGroup;
            if (!isEnabledAndVisible(_arg1)){
                return (false);
            };
            if ((_arg1 is IFocusManagerGroup)){
                _local3 = IFocusManagerGroup(_arg1);
                if (_arg2 == _local3.groupName){
                    return (false);
                };
            };
            return (true);
        }
        private function removeFocusables(_arg1:DisplayObject, _arg2:Boolean):void{
            var _local3:int;
            if ((_arg1 is DisplayObjectContainer)){
                if (!_arg2){
                    _arg1.removeEventListener("tabChildrenChange", tabChildrenChangeHandler);
                };
                _local3 = 0;
                while (_local3 < focusableObjects.length) {
                    if (isParent(DisplayObjectContainer(_arg1), focusableObjects[_local3])){
                        if (focusableObjects[_local3] == _lastFocus){
                            _lastFocus.drawFocus(false);
                            _lastFocus = null;
                        };
                        focusableObjects[_local3].removeEventListener("tabEnabledChange", tabEnabledChangeHandler);
                        focusableObjects[_local3].removeEventListener("tabIndexChange", tabIndexChangeHandler);
                        focusableObjects.splice(_local3, 1);
                        _local3--;
                        calculateCandidates = true;
                    };
                    _local3++;
                };
            };
        }
        private function addedHandler(_arg1:Event):void{
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            if (_local2.stage){
                addFocusables(DisplayObject(_arg1.target));
            };
        }
        private function tabChildrenChangeHandler(_arg1:Event):void{
            if (_arg1.target != _arg1.currentTarget){
                return;
            };
            calculateCandidates = true;
            var _local2:DisplayObjectContainer = DisplayObjectContainer(_arg1.target);
            if (_local2.tabChildren){
                addFocusables(_local2, true);
            } else {
                removeFocusables(_local2, true);
            };
        }
        private function sortByDepth(_arg1:DisplayObject, _arg2:DisplayObject):Number{
            var _local5:int;
            var _local6:String;
            var _local7:String;
            var _local3 = "";
            var _local4 = "";
            var _local8 = "0000";
            var _local9:DisplayObject = DisplayObject(_arg1);
            var _local10:DisplayObject = DisplayObject(_arg2);
            while (((!((_local9 == DisplayObject(form)))) && (_local9.parent))) {
                _local5 = getChildIndex(_local9.parent, _local9);
                _local6 = _local5.toString(16);
                if (_local6.length < 4){
                    _local7 = (_local8.substring(0, (4 - _local6.length)) + _local6);
                };
                _local3 = (_local7 + _local3);
                _local9 = _local9.parent;
            };
            while (((!((_local10 == DisplayObject(form)))) && (_local10.parent))) {
                _local5 = getChildIndex(_local10.parent, _local10);
                _local6 = _local5.toString(16);
                if (_local6.length < 4){
                    _local7 = (_local8.substring(0, (4 - _local6.length)) + _local6);
                };
                _local4 = (_local7 + _local4);
                _local10 = _local10.parent;
            };
            return ((((_local3 > _local4)) ? 1 : (((_local3 < _local4)) ? -1 : 0)));
        }
        mx_internal function sendDefaultButtonEvent():void{
            defButton.dispatchEvent(new MouseEvent("click"));
        }
        public function getFocus():IFocusManagerComponent{
            var _local1:InteractiveObject = form.systemManager.stage.focus;
            return (findFocusManagerComponent(_local1));
        }
        private function deactivateHandler(_arg1:Event):void{
        }
        private function setFocusToBottom():void{
            setFocusToNextIndex(focusableObjects.length, true);
        }
        private function tabIndexChangeHandler(_arg1:Event):void{
            calculateCandidates = true;
        }
        private function sortFocusableObjects():void{
            var _local3:InteractiveObject;
            focusableCandidates = [];
            var _local1:int = focusableObjects.length;
            var _local2:int;
            while (_local2 < _local1) {
                _local3 = focusableObjects[_local2];
                if (((((_local3.tabIndex) && (!(isNaN(Number(_local3.tabIndex)))))) && ((_local3.tabIndex > 0)))){
                    sortFocusableObjectsTabIndex();
                    return;
                };
                focusableCandidates.push(_local3);
                _local2++;
            };
            focusableCandidates.sort(sortByDepth);
        }
        private function keyFocusChangeHandler(_arg1:FocusEvent):void{
            var _local2:ISystemManager = form.systemManager;
            if (_local2.isDisplayObjectInABridgedApplication(DisplayObject(_arg1.target))){
                return;
            };
            showFocusIndicator = true;
            focusChanged = false;
            if ((((_arg1.keyCode == Keyboard.TAB)) && (!(_arg1.isDefaultPrevented())))){
                if (browserFocusComponent){
                    if (browserFocusComponent.tabIndex == LARGE_TAB_INDEX){
                        browserFocusComponent.tabIndex = -1;
                    };
                    browserFocusComponent = null;
                    if (SystemManager(form.systemManager).useSWFBridge()){
                        moveFocusToParent(_arg1.shiftKey);
                        if (focusChanged){
                            _arg1.preventDefault();
                        };
                    };
                    return;
                };
                setFocusToNextObject(_arg1);
                if (focusChanged){
                    _arg1.preventDefault();
                };
            };
        }
        private function getNextFocusManagerComponent2(_arg1:Boolean=false, _arg2:DisplayObject=null, _arg3:int=-2):FocusInfo{
            var _local10:DisplayObject;
            var _local11:String;
            var _local12:IFocusManagerGroup;
            if (focusableObjects.length == 0){
                return (null);
            };
            if (calculateCandidates){
                sortFocusableObjects();
                calculateCandidates = false;
            };
            var _local4:int = _arg3;
            if (_arg3 == FROM_INDEX_UNSPECIFIED){
                _local10 = _arg2;
                if (!_local10){
                    _local10 = form.systemManager.stage.focus;
                };
                _local10 = DisplayObject(findFocusManagerComponent2(InteractiveObject(_local10)));
                _local11 = "";
                if ((_local10 is IFocusManagerGroup)){
                    _local12 = IFocusManagerGroup(_local10);
                    _local11 = _local12.groupName;
                };
                _local4 = getIndexOfFocusedObject(_local10);
            };
            var _local5:Boolean;
            var _local6:int = _local4;
            if (_local4 == -1){
                if (_arg1){
                    _local4 = focusableCandidates.length;
                };
                _local5 = true;
            };
            var _local7:int = getIndexOfNextObject(_local4, _arg1, _local5, _local11);
            var _local8:Boolean;
            if (_arg1){
                if (_local7 >= _local4){
                    _local8 = true;
                };
            } else {
                if (_local7 <= _local4){
                    _local8 = true;
                };
            };
            var _local9:FocusInfo = new FocusInfo();
            _local9.displayObject = findFocusManagerComponent2(focusableCandidates[_local7]);
            _local9.wrapped = _local8;
            return (_local9);
        }
        private function getIndexOfFocusedObject(_arg1:DisplayObject):int{
            var _local4:IUIComponent;
            if (!_arg1){
                return (-1);
            };
            var _local2:int = focusableCandidates.length;
            var _local3:int;
            _local3 = 0;
            while (_local3 < _local2) {
                if (focusableCandidates[_local3] == _arg1){
                    return (_local3);
                };
                _local3++;
            };
            _local3 = 0;
            while (_local3 < _local2) {
                _local4 = (focusableCandidates[_local3] as IUIComponent);
                if (((_local4) && (_local4.owns(_arg1)))){
                    return (_local3);
                };
                _local3++;
            };
            return (-1);
        }
        private function focusRequestActivateHandler(_arg1:Event):void{
            skipBridge = IEventDispatcher(_arg1.target);
            activate();
            skipBridge = null;
        }
        private function removeFromParentBridge(_arg1:Event):void{
            var _local3:IEventDispatcher;
            var _local2:ISystemManager = form.systemManager;
            if (_local2.useSWFBridge()){
                _local2.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING, removeFromParentBridge);
                _local3 = swfBridgeGroup.parentBridge;
                if (_local3){
                    _local3.removeEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST, focusRequestMoveHandler);
                    _local3.removeEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST, setShowFocusIndicatorRequestHandler);
                };
                if (((_local3) && (!((form.systemManager is SystemManagerProxy))))){
                    _local3.removeEventListener(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST, focusRequestActivateHandler);
                    _local3.removeEventListener(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST, focusRequestDeactivateHandler);
                    _local3.removeEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE, bridgeEventActivateHandler);
                };
            };
        }
        private function getParentBridge():IEventDispatcher{
            if (swfBridgeGroup){
                return (swfBridgeGroup.parentBridge);
            };
            return (null);
        }
        private function setFocusToComponent(_arg1:Object, _arg2:Boolean):void{
            var _local3:SWFBridgeRequest;
            var _local4:IEventDispatcher;
            focusChanged = false;
            if (_arg1){
                if ((((_arg1 is ISWFLoader)) && (ISWFLoader(_arg1).swfBridge))){
                    _local3 = new SWFBridgeRequest(SWFBridgeRequest.MOVE_FOCUS_REQUEST, false, true, null, ((_arg2) ? FocusRequestDirection.BOTTOM : FocusRequestDirection.TOP));
                    _local4 = ISWFLoader(_arg1).swfBridge;
                    if (_local4){
                        _local4.dispatchEvent(_local3);
                        focusChanged = _local3.data;
                    };
                } else {
                    if ((_arg1 is IFocusManagerComplexComponent)){
                        IFocusManagerComplexComponent(_arg1).assignFocus(((_arg2) ? "bottom" : "top"));
                        focusChanged = true;
                    } else {
                        if ((_arg1 is IFocusManagerComponent)){
                            setFocus(IFocusManagerComponent(_arg1));
                            focusChanged = true;
                        };
                    };
                };
            };
        }
        private function focusRequestMoveHandler(_arg1:Event):void{
            var _local3:DisplayObject;
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            focusSetLocally = false;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if ((((_local2.data == FocusRequestDirection.TOP)) || ((_local2.data == FocusRequestDirection.BOTTOM)))){
                if (focusableObjects.length == 0){
                    moveFocusToParent((((_local2.data == FocusRequestDirection.TOP)) ? false : true));
                    _arg1["data"] = focusChanged;
                    return;
                };
                if (_local2.data == FocusRequestDirection.TOP){
                    setFocusToTop();
                } else {
                    setFocusToBottom();
                };
                _arg1["data"] = focusChanged;
            } else {
                _local3 = DisplayObject(_form.systemManager.swfBridgeGroup.getChildBridgeProvider(IEventDispatcher(_arg1.target)));
                moveFocus((_local2.data as String), _local3);
                _arg1["data"] = focusChanged;
            };
            if (focusSetLocally){
                dispatchActivatedFocusManagerEvent(null);
                lastActiveFocusManager = this;
            };
        }
        public function get nextTabIndex():int{
            return ((getMaxTabIndex() + 1));
        }
        private function dispatchActivatedFocusManagerEvent(_arg1:IEventDispatcher=null):void{
            if (lastActiveFocusManager == this){
                return;
            };
            var _local2:SWFBridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE);
            dispatchEventFromSWFBridges(_local2, _arg1);
        }
        private function focusRequestDeactivateHandler(_arg1:Event):void{
            skipBridge = IEventDispatcher(_arg1.target);
            deactivate();
            skipBridge = null;
        }
        public function get focusPane():Sprite{
            return (_focusPane);
        }
        private function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local3:DisplayObject;
            var _local4:String;
            var _local5:int;
            var _local6:int;
            var _local7:IFocusManagerGroup;
            var _local2:ISystemManager = form.systemManager;
            if (_local2.isDisplayObjectInABridgedApplication(DisplayObject(_arg1.target))){
                return;
            };
            if ((_local2 is SystemManager)){
                SystemManager(_local2).idleCounter = 0;
            };
            if (_arg1.keyCode == Keyboard.TAB){
                lastAction = "KEY";
                if (calculateCandidates){
                    sortFocusableObjects();
                    calculateCandidates = false;
                };
            };
            if (browserMode){
                if ((((_arg1.keyCode == Keyboard.TAB)) && ((focusableCandidates.length > 0)))){
                    _local3 = fauxFocus;
                    if (!_local3){
                        _local3 = form.systemManager.stage.focus;
                    };
                    _local3 = DisplayObject(findFocusManagerComponent2(InteractiveObject(_local3)));
                    _local4 = "";
                    if ((_local3 is IFocusManagerGroup)){
                        _local7 = IFocusManagerGroup(_local3);
                        _local4 = _local7.groupName;
                    };
                    _local5 = getIndexOfFocusedObject(_local3);
                    _local6 = getIndexOfNextObject(_local5, _arg1.shiftKey, false, _local4);
                    if (_arg1.shiftKey){
                        if (_local6 >= _local5){
                            browserFocusComponent = getBrowserFocusComponent(_arg1.shiftKey);
                            if (browserFocusComponent.tabIndex == -1){
                                browserFocusComponent.tabIndex = 0;
                            };
                        };
                    } else {
                        if (_local6 <= _local5){
                            browserFocusComponent = getBrowserFocusComponent(_arg1.shiftKey);
                            if (browserFocusComponent.tabIndex == -1){
                                browserFocusComponent.tabIndex = LARGE_TAB_INDEX;
                            };
                        };
                    };
                };
            };
            if (((((((defaultButtonEnabled) && ((_arg1.keyCode == Keyboard.ENTER)))) && (defaultButton))) && (defButton.enabled))){
                defButton.callLater(sendDefaultButtonEvent);
            };
        }
        private function mouseDownHandler(_arg1:MouseEvent):void{
            if (_arg1.isDefaultPrevented()){
                return;
            };
            var _local2:ISystemManager = form.systemManager;
            var _local3:DisplayObject = getTopLevelFocusTarget(InteractiveObject(_arg1.target));
            if (!_local3){
                return;
            };
            showFocusIndicator = false;
            if (((((!((_local3 == _lastFocus))) || ((lastAction == "ACTIVATE")))) && (!((_local3 is TextField))))){
                setFocus(IFocusManagerComponent(_local3));
            } else {
                if (_lastFocus){
                    if (((((!(_lastFocus)) && ((_local3 is IEventDispatcher)))) && (SystemManager(form.systemManager).useSWFBridge()))){
                        IEventDispatcher(_local3).dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
                    };
                };
            };
            lastAction = "MOUSEDOWN";
            dispatchActivatedFocusManagerEvent(null);
            lastActiveFocusManager = this;
        }
        private function focusInHandler(_arg1:FocusEvent):void{
            var _local4:IButton;
            var _local2:InteractiveObject = InteractiveObject(_arg1.target);
            var _local3:ISystemManager = form.systemManager;
            if (_local3.isDisplayObjectInABridgedApplication(DisplayObject(_arg1.target))){
                return;
            };
            if (isParent(DisplayObjectContainer(form), _local2)){
                _lastFocus = findFocusManagerComponent(InteractiveObject(_local2));
                if ((_lastFocus is IButton)){
                    _local4 = (_lastFocus as IButton);
                    if (defButton){
                        defButton.emphasized = false;
                        defButton = _local4;
                        _local4.emphasized = true;
                    };
                } else {
                    if (((defButton) && (!((defButton == _defaultButton))))){
                        defButton.emphasized = false;
                        defButton = _defaultButton;
                        _defaultButton.emphasized = true;
                    };
                };
            };
        }
        public function toString():String{
            return ((Object(form).toString() + ".focusManager"));
        }
        public function deactivate():void{
            var _local1:ISystemManager = form.systemManager;
            if (_local1){
                if (_local1.isTopLevelRoot()){
                    _local1.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
                    _local1.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
                    _local1.stage.removeEventListener(Event.ACTIVATE, activateHandler);
                    _local1.stage.removeEventListener(Event.DEACTIVATE, deactivateHandler);
                } else {
                    _local1.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
                    _local1.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
                    _local1.removeEventListener(Event.ACTIVATE, activateHandler);
                    _local1.removeEventListener(Event.DEACTIVATE, deactivateHandler);
                };
            };
            form.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
            form.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = false;
            dispatchEventFromSWFBridges(new SWFBridgeRequest(SWFBridgeRequest.DEACTIVATE_FOCUS_REQUEST), skipBridge);
        }
        private function findFocusManagerComponent2(_arg1:InteractiveObject):DisplayObject{
            var o:* = _arg1;
            try {
                while (o) {
                    if ((((((o is IFocusManagerComponent)) && (IFocusManagerComponent(o).focusEnabled))) || ((o is ISWFLoader)))){
                        return (o);
                    };
                    o = o.parent;
                };
            } catch(error:SecurityError) {
            };
            return (null);
        }
        private function getIndexOfNextObject(_arg1:int, _arg2:Boolean, _arg3:Boolean, _arg4:String):int{
            var _local7:DisplayObject;
            var _local8:IFocusManagerGroup;
            var _local9:int;
            var _local10:DisplayObject;
            var _local11:IFocusManagerGroup;
            var _local5:int = focusableCandidates.length;
            var _local6:int = _arg1;
            while (true) {
                if (_arg2){
                    _arg1--;
                } else {
                    _arg1++;
                };
                if (_arg3){
                    if (((_arg2) && ((_arg1 < 0)))){
                        break;
                    };
                    if (((!(_arg2)) && ((_arg1 == _local5)))){
                        break;
                    };
                } else {
                    _arg1 = ((_arg1 + _local5) % _local5);
                    if (_local6 == _arg1){
                        break;
                    };
                };
                if (isValidFocusCandidate(focusableCandidates[_arg1], _arg4)){
                    _local7 = DisplayObject(findFocusManagerComponent2(focusableCandidates[_arg1]));
                    if ((_local7 is IFocusManagerGroup)){
                        _local8 = IFocusManagerGroup(_local7);
                        _local9 = 0;
                        while (_local9 < focusableCandidates.length) {
                            _local10 = focusableCandidates[_local9];
                            if ((_local10 is IFocusManagerGroup)){
                                _local11 = IFocusManagerGroup(_local10);
                                if ((((_local11.groupName == _local8.groupName)) && (_local11.selected))){
                                    if (((!((InteractiveObject(_local10).tabIndex == InteractiveObject(_local7).tabIndex))) && (!(_local8.selected)))){
                                        return (getIndexOfNextObject(_arg1, _arg2, _arg3, _arg4));
                                    };
                                    _arg1 = _local9;
                                    break;
                                };
                            };
                            _local9++;
                        };
                    };
                    return (_arg1);
                };
            };
            return (_arg1);
        }
        public function moveFocus(_arg1:String, _arg2:DisplayObject=null):void{
            if (_arg1 == FocusRequestDirection.TOP){
                setFocusToTop();
                return;
            };
            if (_arg1 == FocusRequestDirection.BOTTOM){
                setFocusToBottom();
                return;
            };
            var _local3:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
            _local3.keyCode = Keyboard.TAB;
            _local3.shiftKey = ((_arg1)==FocusRequestDirection.FORWARD) ? false : true;
            fauxFocus = _arg2;
            keyDownHandler(_local3);
            var _local4:FocusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE);
            _local4.keyCode = Keyboard.TAB;
            _local4.shiftKey = ((_arg1)==FocusRequestDirection.FORWARD) ? false : true;
            keyFocusChangeHandler(_local4);
            fauxFocus = null;
        }
        private function getMaxTabIndex():int{
            var _local4:Number;
            var _local1:Number = 0;
            var _local2:int = focusableObjects.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = focusableObjects[_local3].tabIndex;
                if (!isNaN(_local4)){
                    _local1 = Math.max(_local1, _local4);
                };
                _local3++;
            };
            return (_local1);
        }
        private function isParent(_arg1:DisplayObjectContainer, _arg2:DisplayObject):Boolean{
            if ((_arg1 is IRawChildrenContainer)){
                return (IRawChildrenContainer(_arg1).rawChildren.contains(_arg2));
            };
            return (_arg1.contains(_arg2));
        }
        private function showHandler(_arg1:Event):void{
            form.systemManager.activate(form);
        }
        mx_internal function set form(_arg1:IFocusManagerContainer):void{
            _form = _arg1;
        }
        public function setFocus(_arg1:IFocusManagerComponent):void{
            _arg1.setFocus();
            focusSetLocally = true;
        }
        public function findFocusManagerComponent(_arg1:InteractiveObject):IFocusManagerComponent{
            return ((findFocusManagerComponent2(_arg1) as IFocusManagerComponent));
        }
        public function removeSWFBridge(_arg1:IEventDispatcher):void{
            var _local4:int;
            var _local2:ISystemManager = _form.systemManager;
            var _local3:DisplayObject = DisplayObject(swfBridgeGroup.getChildBridgeProvider(_arg1));
            if (_local3){
                _local4 = focusableObjects.indexOf(_local3);
                if (_local4 != -1){
                    focusableObjects.splice(_local4, 1);
                    calculateCandidates = true;
                };
            } else {
                throw (new Error());
            };
            _arg1.removeEventListener(SWFBridgeRequest.MOVE_FOCUS_REQUEST, focusRequestMoveHandler);
            _arg1.removeEventListener(SWFBridgeRequest.SET_SHOW_FOCUS_INDICATOR_REQUEST, setShowFocusIndicatorRequestHandler);
            _arg1.removeEventListener(SWFBridgeEvent.BRIDGE_FOCUS_MANAGER_ACTIVATE, bridgeEventActivateHandler);
            swfBridgeGroup.removeChildBridge(_arg1);
        }
        private function sortFocusableObjectsTabIndex():void{
            var _local3:IFocusManagerComponent;
            focusableCandidates = [];
            var _local1:int = focusableObjects.length;
            var _local2:int;
            while (_local2 < _local1) {
                _local3 = (focusableObjects[_local2] as IFocusManagerComponent);
                if (((((((_local3) && (_local3.tabIndex))) && (!(isNaN(Number(_local3.tabIndex)))))) || ((focusableObjects[_local2] is ISWFLoader)))){
                    focusableCandidates.push(focusableObjects[_local2]);
                };
                _local2++;
            };
            focusableCandidates.sort(sortByTabIndex);
        }
        public function set defaultButton(_arg1:IButton):void{
            var _local2:IButton = ((_arg1) ? IButton(_arg1) : null);
            if (_local2 != _defaultButton){
                if (_defaultButton){
                    _defaultButton.emphasized = false;
                };
                if (defButton){
                    defButton.emphasized = false;
                };
                _defaultButton = _local2;
                defButton = _local2;
                if (_local2){
                    _local2.emphasized = true;
                };
            };
        }
        private function setFocusToNextObject(_arg1:FocusEvent):void{
            focusChanged = false;
            if (focusableObjects.length == 0){
                return;
            };
            var _local2:FocusInfo = getNextFocusManagerComponent2(_arg1.shiftKey, fauxFocus);
            if (((!(popup)) && (_local2.wrapped))){
                if (getParentBridge()){
                    moveFocusToParent(_arg1.shiftKey);
                    return;
                };
            };
            setFocusToComponent(_local2.displayObject, _arg1.shiftKey);
        }
        private function getTopLevelFocusTarget(_arg1:InteractiveObject):InteractiveObject{
            while (_arg1 != InteractiveObject(form)) {
                if ((((((((_arg1 is IFocusManagerComponent)) && (IFocusManagerComponent(_arg1).focusEnabled))) && (IFocusManagerComponent(_arg1).mouseFocusEnabled))) && ((((_arg1 is IUIComponent)) ? IUIComponent(_arg1).enabled : true)))){
                    return (_arg1);
                };
                if ((_arg1.parent is ISWFLoader)){
                    if (ISWFLoader(_arg1.parent).swfBridge){
                        return (null);
                    };
                };
                _arg1 = _arg1.parent;
                if (_arg1 == null){
                    break;
                };
            };
            return (null);
        }
        private function addedToStageHandler(_arg1:Event):void{
            _form.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            if (focusableObjects.length == 0){
                addFocusables(DisplayObject(_form));
                calculateCandidates = true;
            };
        }
        private function hideHandler(_arg1:Event):void{
            form.systemManager.deactivate(form);
        }
        private function isEnabledAndVisible(_arg1:DisplayObject):Boolean{
            var _local2:DisplayObjectContainer = DisplayObject(form).parent;
            while (_arg1 != _local2) {
                if ((_arg1 is IUIComponent)){
                    if (!IUIComponent(_arg1).enabled){
                        return (false);
                    };
                };
                if (!_arg1.visible){
                    return (false);
                };
                _arg1 = _arg1.parent;
            };
            return (true);
        }
        public function hideFocus():void{
            if (showFocusIndicator){
                showFocusIndicator = false;
                if (_lastFocus){
                    _lastFocus.drawFocus(false);
                };
            };
        }
        private function getBrowserFocusComponent(_arg1:Boolean):InteractiveObject{
            var _local3:int;
            var _local2:InteractiveObject = form.systemManager.stage.focus;
            if (!_local2){
                _local3 = ((_arg1) ? 0 : (focusableCandidates.length - 1));
                _local2 = focusableCandidates[_local3];
            };
            return (_local2);
        }
        public function get showFocusIndicator():Boolean{
            return (_showFocusIndicator);
        }
        private function moveFocusToParent(_arg1:Boolean):Boolean{
            var _local2:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.MOVE_FOCUS_REQUEST, false, true, null, ((_arg1) ? FocusRequestDirection.BACKWARD : FocusRequestDirection.FORWARD));
            var _local3:IEventDispatcher = _form.systemManager.swfBridgeGroup.parentBridge;
            _local3.dispatchEvent(_local2);
            focusChanged = _local2.data;
            return (focusChanged);
        }
        public function set focusPane(_arg1:Sprite):void{
            _focusPane = _arg1;
        }
        mx_internal function get form():IFocusManagerContainer{
            return (_form);
        }
        private function removedHandler(_arg1:Event):void{
            var _local2:int;
            var _local3:DisplayObject = DisplayObject(_arg1.target);
            if ((_local3 is IFocusManagerComponent)){
                _local2 = 0;
                while (_local2 < focusableObjects.length) {
                    if (_local3 == focusableObjects[_local2]){
                        if (_local3 == _lastFocus){
                            _lastFocus.drawFocus(false);
                            _lastFocus = null;
                        };
                        _local3.removeEventListener("tabEnabledChange", tabEnabledChangeHandler);
                        _local3.removeEventListener("tabIndexChange", tabIndexChangeHandler);
                        focusableObjects.splice(_local2, 1);
                        calculateCandidates = true;
                        break;
                    };
                    _local2++;
                };
            };
            removeFocusables(_local3, false);
        }
        private function dispatchEventFromSWFBridges(_arg1:Event, _arg2:IEventDispatcher=null):void{
            var _local3:Event;
            var _local7:IEventDispatcher;
            var _local4:ISystemManager = form.systemManager;
            if (!popup){
                _local7 = swfBridgeGroup.parentBridge;
                if (((_local7) && (!((_local7 == _arg2))))){
                    _local3 = _arg1.clone();
                    if ((_local3 is SWFBridgeRequest)){
                        SWFBridgeRequest(_local3).requestor = _local7;
                    };
                    _local7.dispatchEvent(_local3);
                };
            };
            var _local5:Array = swfBridgeGroup.getChildBridges();
            var _local6:int;
            while (_local6 < _local5.length) {
                if (_local5[_local6] != _arg2){
                    _local3 = _arg1.clone();
                    if ((_local3 is SWFBridgeRequest)){
                        SWFBridgeRequest(_local3).requestor = IEventDispatcher(_local5[_local6]);
                    };
                    IEventDispatcher(_local5[_local6]).dispatchEvent(_local3);
                };
                _local6++;
            };
        }
        public function get defaultButton():IButton{
            return (_defaultButton);
        }
        private function activateHandler(_arg1:Event):void{
            if (((_lastFocus) && (!(browserMode)))){
                _lastFocus.setFocus();
            };
            lastAction = "ACTIVATE";
        }
        public function showFocus():void{
            if (!showFocusIndicator){
                showFocusIndicator = true;
                if (_lastFocus){
                    _lastFocus.drawFocus(true);
                };
            };
        }
        public function getNextFocusManagerComponent(_arg1:Boolean=false):IFocusManagerComponent{
            return ((getNextFocusManagerComponent2(false, fauxFocus) as IFocusManagerComponent));
        }
        private function setShowFocusIndicatorRequestHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            _showFocusIndicator = _local2.data;
            dispatchSetShowFocusIndicatorRequest(_showFocusIndicator, IEventDispatcher(_arg1.target));
        }
        private function setFocusToTop():void{
            setFocusToNextIndex(-1, false);
        }
        private function isTabVisible(_arg1:DisplayObject):Boolean{
            var _local2:DisplayObject = DisplayObject(form.systemManager);
            if (!_local2){
                return (false);
            };
            var _local3:DisplayObjectContainer = _arg1.parent;
            while (((_local3) && (!((_local3 == _local2))))) {
                if (!_local3.tabChildren){
                    return (false);
                };
                _local3 = _local3.parent;
            };
            return (true);
        }
        mx_internal function get lastFocus():IFocusManagerComponent{
            return (_lastFocus);
        }
        public function set defaultButtonEnabled(_arg1:Boolean):void{
            _defaultButtonEnabled = _arg1;
        }
        public function get defaultButtonEnabled():Boolean{
            return (_defaultButtonEnabled);
        }
        public function set showFocusIndicator(_arg1:Boolean):void{
            var _local2 = !((_showFocusIndicator == _arg1));
            _showFocusIndicator = _arg1;
            if (((((_local2) && (!(popup)))) && (form.systemManager.swfBridgeGroup))){
                dispatchSetShowFocusIndicatorRequest(_arg1, null);
            };
        }
        private function sortByTabIndex(_arg1:InteractiveObject, _arg2:InteractiveObject):int{
            var _local3:int = _arg1.tabIndex;
            var _local4:int = _arg2.tabIndex;
            if (_local3 == -1){
                _local3 = int.MAX_VALUE;
            };
            if (_local4 == -1){
                _local4 = int.MAX_VALUE;
            };
            return ((((_local3 > _local4)) ? 1 : (((_local3 < _local4)) ? -1 : sortByDepth(DisplayObject(_arg1), DisplayObject(_arg2)))));
        }
        public function activate():void{
            if (activated){
                return;
            };
            var _local1:ISystemManager = form.systemManager;
            if (_local1){
                if (_local1.isTopLevelRoot()){
                    _local1.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
                    _local1.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
                    _local1.stage.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
                    _local1.stage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
                } else {
                    _local1.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler, false, 0, true);
                    _local1.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, 0, true);
                    _local1.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
                    _local1.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
                };
            };
            form.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
            form.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler, true);
            form.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            form.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
            activated = true;
            if (_lastFocus){
                setFocus(_lastFocus);
            };
            dispatchEventFromSWFBridges(new SWFBridgeRequest(SWFBridgeRequest.ACTIVATE_FOCUS_REQUEST), skipBridge);
        }
        private function setFocusToNextIndex(_arg1:int, _arg2:Boolean):void{
            if (focusableObjects.length == 0){
                return;
            };
            if (calculateCandidates){
                sortFocusableObjects();
                calculateCandidates = false;
            };
            var _local3:FocusInfo = getNextFocusManagerComponent2(_arg2, null, _arg1);
            if (((!(popup)) && (_local3.wrapped))){
                if (getParentBridge()){
                    moveFocusToParent(_arg2);
                    return;
                };
            };
            setFocusToComponent(_local3.displayObject, _arg2);
        }

    }
}//package mx.managers 

import flash.display.*;

class FocusInfo {

    public var displayObject:DisplayObject;
    public var wrapped:Boolean;

    public function FocusInfo(){
    }
}
