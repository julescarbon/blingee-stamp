package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.text.*;
    import flash.events.*;
    import mx.managers.systemClasses.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.resources.*;
    import flash.system.*;
    import mx.preloaders.*;
    import flash.utils.*;
    import mx.messaging.config.*;
    import mx.utils.*;

    public class SystemManager extends MovieClip implements IChildList, IFlexDisplayObject, IFlexModuleFactory, ISystemManager, ISWFBridgeProvider {

        private static const IDLE_THRESHOLD:Number = 1000;
        private static const IDLE_INTERVAL:Number = 100;
        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var lastSystemManager:SystemManager;
        mx_internal static var allSystemManagers:Dictionary = new Dictionary(true);

        private var _stage:Stage;
        mx_internal var nestLevel:int = 0;
        private var currentSandboxEvent:Event;
        private var forms:Array;
        private var mouseCatcher:Sprite;
        private var _height:Number;
        private var dispatchingToSystemManagers:Boolean = false;
        private var preloader:Preloader;
        private var lastFrame:int;
        private var _document:Object;
        private var strongReferenceProxies:Dictionary;
        private var _rawChildren:SystemRawChildrenList;
        private var _topLevelSystemManager:ISystemManager;
        private var _toolTipIndex:int = 0;
        private var _explicitHeight:Number;
        private var idToPlaceholder:Object;
        private var _swfBridgeGroup:ISWFBridgeGroup;
        private var _toolTipChildren:SystemChildrenList;
        private var form:Object;
        private var _width:Number;
        private var initialized:Boolean = false;
        private var _focusPane:Sprite;
        private var _fontList:Object = null;
        private var isStageRoot:Boolean = true;
        private var _popUpChildren:SystemChildrenList;
        private var rslSizes:Array = null;
        private var _topMostIndex:int = 0;
        private var nextFrameTimer:Timer = null;
        mx_internal var topLevel:Boolean = true;
        private var weakReferenceProxies:Dictionary;
        private var _cursorIndex:int = 0;
        private var isBootstrapRoot:Boolean = false;
        mx_internal var _mouseY;
        private var _numModalWindows:int = 0;
        mx_internal var _mouseX;
        private var _screen:Rectangle;
        mx_internal var idleCounter:int = 0;
        private var _cursorChildren:SystemChildrenList;
        private var initCallbackFunctions:Array;
        private var bridgeToFocusManager:Dictionary;
        private var _noTopMostIndex:int = 0;
        private var _applicationIndex:int = 1;
        private var isDispatchingResizeEvent:Boolean;
        private var idleTimer:Timer;
        private var doneExecutingInitCallbacks:Boolean = false;
        private var _explicitWidth:Number;
        private var eventProxy:EventProxy;
        mx_internal var topLevelWindow:IUIComponent;

        public function SystemManager(){
            initCallbackFunctions = [];
            forms = [];
            weakReferenceProxies = new Dictionary(true);
            strongReferenceProxies = new Dictionary(false);
            super();
            if (stage){
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;
            };
            if ((((SystemManagerGlobals.topLevelSystemManagers.length > 0)) && (!(stage)))){
                topLevel = false;
            };
            if (!stage){
                isStageRoot = false;
            };
            if (topLevel){
                SystemManagerGlobals.topLevelSystemManagers.push(this);
            };
            lastSystemManager = this;
            var _local1:Array = info()["compiledLocales"];
            ResourceBundle.locale = ((((!((_local1 == null))) && ((_local1.length > 0)))) ? _local1[0] : "en_US");
            executeCallbacks();
            stop();
            if (((topLevel) && (!((currentFrame == 1))))){
                throw (new Error((("The SystemManager constructor was called when the currentFrame was at " + currentFrame) + " Please add this SWF to bug 129782.")));
            };
            if (((root) && (root.loaderInfo))){
                root.loaderInfo.addEventListener(Event.INIT, initHandler);
            };
        }
        public static function getSWFRoot(_arg1:Object):DisplayObject{
            var p:* = undefined;
            var sm:* = null;
            var domain:* = null;
            var cls:* = null;
            var object:* = _arg1;
            var className:* = getQualifiedClassName(object);
            for (p in allSystemManagers) {
                sm = (p as ISystemManager);
                domain = sm.loaderInfo.applicationDomain;
                try {
                    cls = Class(domain.getDefinition(className));
                    if ((object is cls)){
                        return ((sm as DisplayObject));
                    };
                } catch(e:Error) {
                };
            };
            return (null);
        }
        private static function areRemotePopUpsEqual(_arg1:Object, _arg2:Object):Boolean{
            if (!(_arg1 is RemotePopUp)){
                return (false);
            };
            if (!(_arg2 is RemotePopUp)){
                return (false);
            };
            var _local3:RemotePopUp = RemotePopUp(_arg1);
            var _local4:RemotePopUp = RemotePopUp(_arg2);
            if ((((((_local3.window == _local4.window)) && (_local3.bridge))) && (_local4.bridge))){
                return (true);
            };
            return (false);
        }
        private static function getChildListIndex(_arg1:IChildList, _arg2:Object):int{
            var childList:* = _arg1;
            var f:* = _arg2;
            var index:* = -1;
            try {
                index = childList.getChildIndex(DisplayObject(f));
            } catch(e:ArgumentError) {
            };
            return (index);
        }
        mx_internal static function registerInitCallback(_arg1:Function):void{
            if (((!(allSystemManagers)) || (!(lastSystemManager)))){
                return;
            };
            var _local2:SystemManager = lastSystemManager;
            if (_local2.doneExecutingInitCallbacks){
                _arg1(_local2);
            } else {
                _local2.initCallbackFunctions.push(_arg1);
            };
        }
        private static function isRemotePopUp(_arg1:Object):Boolean{
            return (!((_arg1 is IFocusManagerContainer)));
        }

        private function removeEventListenerFromSandboxes(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:IEventDispatcher=null):void{
            var _local8:int;
            if (!swfBridgeGroup){
                return;
            };
            var _local5:EventListenerRequest = new EventListenerRequest(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST, false, false, _arg1, _arg3);
            var _local6:IEventDispatcher = swfBridgeGroup.parentBridge;
            if (((_local6) && (!((_local6 == _arg4))))){
                _local6.removeEventListener(_arg1, _arg2, _arg3);
            };
            var _local7:Array = swfBridgeGroup.getChildBridges();
            while (_local8 < _local7.length) {
                if (_local7[_local8] != _arg4){
                    IEventDispatcher(_local7[_local8]).removeEventListener(_arg1, _arg2, _arg3);
                };
                _local8++;
            };
            dispatchEventFromSWFBridges(_local5, _arg4);
        }
        mx_internal function addingChild(_arg1:DisplayObject):void{
            var _local4:DisplayObjectContainer;
            var _local2 = 1;
            if (((!(topLevel)) && (parent))){
                _local4 = parent.parent;
                while (_local4) {
                    if ((_local4 is ILayoutManagerClient)){
                        _local2 = (ILayoutManagerClient(_local4).nestLevel + 1);
                        break;
                    };
                    _local4 = _local4.parent;
                };
            };
            nestLevel = _local2;
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).systemManager = this;
            };
            var _local3:Class = Class(getDefinitionByName("mx.core.UIComponent"));
            if ((((_arg1 is IUIComponent)) && (!(IUIComponent(_arg1).document)))){
                IUIComponent(_arg1).document = document;
            };
            if ((_arg1 is ILayoutManagerClient)){
                ILayoutManagerClient(_arg1).nestLevel = (nestLevel + 1);
            };
            if ((_arg1 is InteractiveObject)){
                if (doubleClickEnabled){
                    InteractiveObject(_arg1).doubleClickEnabled = true;
                };
            };
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).parentChanged(this);
            };
            if ((_arg1 is IStyleClient)){
                IStyleClient(_arg1).regenerateStyleCache(true);
            };
            if ((_arg1 is ISimpleStyleClient)){
                ISimpleStyleClient(_arg1).styleChanged(null);
            };
            if ((_arg1 is IStyleClient)){
                IStyleClient(_arg1).notifyStyleChangeInChildren(null, true);
            };
            if (((_local3) && ((_arg1 is _local3)))){
                _local3(_arg1).initThemeColor();
            };
            if (((_local3) && ((_arg1 is _local3)))){
                _local3(_arg1).stylesInitialized();
            };
        }
        private function dispatchEventToOtherSystemManagers(_arg1:Event):void{
            dispatchingToSystemManagers = true;
            var _local2:Array = SystemManagerGlobals.topLevelSystemManagers;
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3) {
                if (_local2[_local4] != this){
                    _local2[_local4].dispatchEvent(_arg1);
                };
                _local4++;
            };
            dispatchingToSystemManagers = false;
        }
        private function idleTimer_timerHandler(_arg1:TimerEvent):void{
            idleCounter++;
            if ((idleCounter * IDLE_INTERVAL) > IDLE_THRESHOLD){
                dispatchEvent(new FlexEvent(FlexEvent.IDLE));
            };
        }
        private function initManagerHandler(_arg1:Event):void{
            var event:* = _arg1;
            if (!dispatchingToSystemManagers){
                dispatchEventToOtherSystemManagers(event);
            };
            if ((event is InterManagerRequest)){
                return;
            };
            var name:* = event["name"];
            try {
                Singleton.getInstance(name);
            } catch(e:Error) {
            };
        }
        private function getSizeRequestHandler(_arg1:Event):void{
            var _local2:Object = Object(_arg1);
            _local2.data = {
                width:measuredWidth,
                height:measuredHeight
            };
        }
        private function beforeUnloadHandler(_arg1:Event):void{
            var _local2:DisplayObject;
            if (((topLevel) && (stage))){
                _local2 = getSandboxRoot();
                if (_local2 != this){
                    _local2.removeEventListener(Event.RESIZE, Stage_resizeHandler);
                };
            };
            removeParentBridgeListeners();
            dispatchEvent(_arg1);
        }
        public function getExplicitOrMeasuredHeight():Number{
            return (((isNaN(explicitHeight)) ? measuredHeight : explicitHeight));
        }
        private function getVisibleRectRequestHandler(_arg1:Event):void{
            var _local5:Rectangle;
            var _local7:Point;
            var _local8:IEventDispatcher;
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            var _local3:Rectangle = Rectangle(_local2.data);
            var _local4:DisplayObject = DisplayObject(swfBridgeGroup.getChildBridgeProvider(_local2.requestor));
            var _local6:Boolean;
            if (!DisplayObjectContainer(document).contains(_local4)){
                _local6 = false;
            };
            if ((_local4 is ISWFLoader)){
                _local5 = ISWFLoader(_local4).getVisibleApplicationRect();
            } else {
                _local5 = _local4.getBounds(this);
                _local7 = localToGlobal(_local5.topLeft);
                _local5.x = _local7.x;
                _local5.y = _local7.y;
            };
            _local3 = _local3.intersection(_local5);
            _local2.data = _local3;
            if (((_local6) && (useSWFBridge()))){
                _local8 = swfBridgeGroup.parentBridge;
                _local2.requestor = _local8;
                _local8.dispatchEvent(_local2);
            };
            Object(_arg1).data = _local2.data;
        }
        mx_internal function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            var _local6:IStyleClient;
            var _local3:Boolean;
            var _local4:int = rawChildren.numChildren;
            var _local5:int;
            while (_local5 < _local4) {
                _local6 = (rawChildren.getChildAt(_local5) as IStyleClient);
                if (_local6){
                    _local6.styleChanged(_arg1);
                    _local6.notifyStyleChangeInChildren(_arg1, _arg2);
                };
                if (isTopLevelWindow(DisplayObject(_local6))){
                    _local3 = true;
                };
                _local4 = rawChildren.numChildren;
                _local5++;
            };
            if (((!(_local3)) && ((topLevelWindow is IStyleClient)))){
                IStyleClient(topLevelWindow).styleChanged(_arg1);
                IStyleClient(topLevelWindow).notifyStyleChangeInChildren(_arg1, _arg2);
            };
        }
        mx_internal function rawChildren_getObjectsUnderPoint(_arg1:Point):Array{
            return (super.getObjectsUnderPoint(_arg1));
        }
        private function initHandler(_arg1:Event):void{
            var bridgeEvent:* = null;
            var event:* = _arg1;
            if (!isStageRoot){
                if (root.loaderInfo.parentAllowsChild){
                    try {
                        if (!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true))){
                            isBootstrapRoot = true;
                        };
                    } catch(e:Error) {
                    };
                };
            };
            allSystemManagers[this] = this.loaderInfo.url;
            root.loaderInfo.removeEventListener(Event.INIT, initHandler);
            if (useSWFBridge()){
                swfBridgeGroup = new SWFBridgeGroup(this);
                swfBridgeGroup.parentBridge = loaderInfo.sharedEvents;
                addParentBridgeListeners();
                bridgeEvent = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_NEW_APPLICATION);
                bridgeEvent.data = swfBridgeGroup.parentBridge;
                swfBridgeGroup.parentBridge.dispatchEvent(bridgeEvent);
                addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, addPlaceholderPopupRequestHandler);
                root.loaderInfo.addEventListener(Event.UNLOAD, unloadHandler, false, 0, true);
            };
            getSandboxRoot().addEventListener(InterManagerRequest.INIT_MANAGER_REQUEST, initManagerHandler, false, 0, true);
            if (getSandboxRoot() == this){
                addEventListener(InterManagerRequest.SYSTEM_MANAGER_REQUEST, systemManagerHandler);
                addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST, multiWindowRedispatcher);
                addEventListener("dispatchDragEvent", multiWindowRedispatcher);
                addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST, addPopupRequestHandler);
                addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST, removePopupRequestHandler);
                addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, addPlaceholderPopupRequestHandler);
                addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST, removePlaceholderPopupRequestHandler);
                addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE, activateFormSandboxEventHandler);
                addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE, deactivateFormSandboxEventHandler);
                addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST, hideMouseCursorRequestHandler);
                addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST, showMouseCursorRequestHandler);
                addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST, resetMouseCursorRequestHandler);
            };
            var docFrame:* = ((totalFrames)==1) ? 0 : 1;
            addEventListener(Event.ENTER_FRAME, docFrameListener);
            initialize();
        }
        mx_internal function findFocusManagerContainer(_arg1:SystemManagerProxy):IFocusManagerContainer{
            var _local5:DisplayObject;
            var _local2:IChildList = _arg1.rawChildren;
            var _local3:int = _local2.numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = _local2.getChildAt(_local4);
                if ((_local5 is IFocusManagerContainer)){
                    return (IFocusManagerContainer(_local5));
                };
                _local4++;
            };
            return (null);
        }
        private function addPlaceholderPopupRequestHandler(_arg1:Event):void{
            var _local3:RemotePopUp;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (((!((_arg1.target == this))) && ((_arg1 is SWFBridgeRequest)))){
                return;
            };
            if (!forwardPlaceholderRequest(_local2, true)){
                _local3 = new RemotePopUp(_local2.data.placeHolderId, _local2.requestor);
                forms.push(_local3);
            };
        }
        override public function contains(_arg1:DisplayObject):Boolean{
            var _local2:int;
            var _local3:int;
            var _local4:DisplayObject;
            if (super.contains(_arg1)){
                if (_arg1.parent == this){
                    _local2 = super.getChildIndex(_arg1);
                    if (_local2 < noTopMostIndex){
                        return (true);
                    };
                } else {
                    _local3 = 0;
                    while (_local3 < noTopMostIndex) {
                        _local4 = super.getChildAt(_local3);
                        if ((_local4 is IRawChildrenContainer)){
                            if (IRawChildrenContainer(_local4).rawChildren.contains(_arg1)){
                                return (true);
                            };
                        };
                        if ((_local4 is DisplayObjectContainer)){
                            if (DisplayObjectContainer(_local4).contains(_arg1)){
                                return (true);
                            };
                        };
                        _local3++;
                    };
                };
            };
            return (false);
        }
        private function modalWindowRequestHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (!preProcessModalWindowRequest(_local2, getSandboxRoot())){
                return;
            };
            Singleton.getInstance("mx.managers::IPopUpManager");
            dispatchEvent(_local2);
        }
        private function activateApplicationSandboxEventHandler(_arg1:Event):void{
            if (!isTopLevelRoot()){
                swfBridgeGroup.parentBridge.dispatchEvent(_arg1);
                return;
            };
            activateForm(document);
        }
        public function getDefinitionByName(_arg1:String):Object{
            var _local3:Object;
            var _local2:ApplicationDomain = ((((!(topLevel)) && ((parent is Loader)))) ? Loader(parent).contentLoaderInfo.applicationDomain : (info()["currentDomain"] as ApplicationDomain));
            if (_local2.hasDefinition(_arg1)){
                _local3 = _local2.getDefinition(_arg1);
            };
            return (_local3);
        }
        public function removeChildFromSandboxRoot(_arg1:String, _arg2:DisplayObject):void{
            var _local3:InterManagerRequest;
            if (getSandboxRoot() == this){
                this[_arg1].removeChild(_arg2);
            } else {
                removingChild(_arg2);
                _local3 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
                _local3.name = (_arg1 + ".removeChild");
                _local3.value = _arg2;
                getSandboxRoot().dispatchEvent(_local3);
                childRemoved(_arg2);
            };
        }
        private function removeEventListenerFromOtherSystemManagers(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            var _local4:Array = SystemManagerGlobals.topLevelSystemManagers;
            if (_local4.length < 2){
                return;
            };
            SystemManagerGlobals.changingListenersInOtherSystemManagers = true;
            var _local5:int = _local4.length;
            var _local6:int;
            while (_local6 < _local5) {
                if (_local4[_local6] != this){
                    _local4[_local6].removeEventListener(_arg1, _arg2, _arg3);
                };
                _local6++;
            };
            SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
        }
        private function addEventListenerToOtherSystemManagers(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            var _local6:Array = SystemManagerGlobals.topLevelSystemManagers;
            if (_local6.length < 2){
                return;
            };
            SystemManagerGlobals.changingListenersInOtherSystemManagers = true;
            var _local7:int = _local6.length;
            var _local8:int;
            while (_local8 < _local7) {
                if (_local6[_local8] != this){
                    _local6[_local8].addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
                };
                _local8++;
            };
            SystemManagerGlobals.changingListenersInOtherSystemManagers = false;
        }
        public function get embeddedFontList():Object{
            var _local1:Object;
            var _local2:String;
            var _local3:Object;
            if (_fontList == null){
                _fontList = {};
                _local1 = info()["fonts"];
                for (_local2 in _local1) {
                    _fontList[_local2] = _local1[_local2];
                };
                if (((!(topLevel)) && (_topLevelSystemManager))){
                    _local3 = _topLevelSystemManager.embeddedFontList;
                    for (_local2 in _local3) {
                        _fontList[_local2] = _local3[_local2];
                    };
                };
            };
            return (_fontList);
        }
        mx_internal function set cursorIndex(_arg1:int):void{
            var _local2:int = (_arg1 - _cursorIndex);
            _cursorIndex = _arg1;
        }
        mx_internal function addChildBridgeListeners(_arg1:IEventDispatcher):void{
            if (((!(topLevel)) && (topLevelSystemManager))){
                SystemManager(topLevelSystemManager).addChildBridgeListeners(_arg1);
                return;
            };
            _arg1.addEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST, addPopupRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST, removePopupRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, addPlaceholderPopupRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST, removePlaceholderPopupRequestHandler);
            _arg1.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE, activateFormSandboxEventHandler);
            _arg1.addEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE, deactivateFormSandboxEventHandler);
            _arg1.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE, activateApplicationSandboxEventHandler);
            _arg1.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST, eventListenerRequestHandler, false, 0, true);
            _arg1.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST, eventListenerRequestHandler, false, 0, true);
            _arg1.addEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST, getVisibleRectRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST, hideMouseCursorRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST, showMouseCursorRequestHandler);
            _arg1.addEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST, resetMouseCursorRequestHandler);
        }
        public function set document(_arg1:Object):void{
            _document = _arg1;
        }
        override public function getChildAt(_arg1:int):DisplayObject{
            return (super.getChildAt((applicationIndex + _arg1)));
        }
        public function get rawChildren():IChildList{
            if (!_rawChildren){
                _rawChildren = new SystemRawChildrenList(this);
            };
            return (_rawChildren);
        }
        private function findLastActiveForm(_arg1:Object):Object{
            var _local2:int = forms.length;
            var _local3:int = (forms.length - 1);
            while (_local3 >= 0) {
                if (((!((forms[_local3] == _arg1))) && (canActivatePopUp(forms[_local3])))){
                    return (forms[_local3]);
                };
                _local3--;
            };
            return (null);
        }
        private function multiWindowRedispatcher(_arg1:Event):void{
            if (!dispatchingToSystemManagers){
                dispatchEventToOtherSystemManagers(_arg1);
            };
        }
        public function deployMouseShields(_arg1:Boolean):void{
            var _local2:InterManagerRequest = new InterManagerRequest(InterManagerRequest.DRAG_MANAGER_REQUEST, false, false, "mouseShield", _arg1);
            getSandboxRoot().dispatchEvent(_local2);
        }
        override public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            var newListener:* = null;
            var actualType:* = null;
            var type:* = _arg1;
            var listener:* = _arg2;
            var useCapture:Boolean = _arg3;
            var priority:int = _arg4;
            var useWeakReference:Boolean = _arg5;
            if ((((type == FlexEvent.RENDER)) || ((type == FlexEvent.ENTER_FRAME)))){
                if (type == FlexEvent.RENDER){
                    type = Event.RENDER;
                } else {
                    type = Event.ENTER_FRAME;
                };
                try {
                    if (stage){
                        stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
                    } else {
                        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
                    };
                } catch(error:SecurityError) {
                    super.addEventListener(type, listener, useCapture, priority, useWeakReference);
                };
                if (((stage) && ((type == Event.RENDER)))){
                    stage.invalidate();
                };
                return;
            };
            if ((((((((((type == MouseEvent.MOUSE_MOVE)) || ((type == MouseEvent.MOUSE_UP)))) || ((type == MouseEvent.MOUSE_DOWN)))) || ((type == Event.ACTIVATE)))) || ((type == Event.DEACTIVATE)))){
                try {
                    if (stage){
                        newListener = new StageEventProxy(listener);
                        stage.addEventListener(type, newListener.stageListener, false, priority, useWeakReference);
                        if (useWeakReference){
                            weakReferenceProxies[listener] = newListener;
                        } else {
                            strongReferenceProxies[listener] = newListener;
                        };
                    };
                } catch(error:SecurityError) {
                };
            };
            if (((hasSWFBridges()) || ((SystemManagerGlobals.topLevelSystemManagers.length > 1)))){
                if (!eventProxy){
                    eventProxy = new EventProxy(this);
                };
                actualType = EventUtil.sandboxMouseEventMap[type];
                if (actualType){
                    if (isTopLevelRoot()){
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, resetMouseCursorTracking, true, (EventPriority.CURSOR_MANAGEMENT + 1), true);
                        addEventListenerToSandboxes(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE, resetMouseCursorTracking, true, (EventPriority.CURSOR_MANAGEMENT + 1), true);
                    } else {
                        super.addEventListener(MouseEvent.MOUSE_MOVE, resetMouseCursorTracking, true, (EventPriority.CURSOR_MANAGEMENT + 1), true);
                    };
                    addEventListenerToSandboxes(type, sandboxMouseListener, useCapture, priority, useWeakReference);
                    if (!SystemManagerGlobals.changingListenersInOtherSystemManagers){
                        addEventListenerToOtherSystemManagers(type, otherSystemManagerMouseListener, useCapture, priority, useWeakReference);
                    };
                    if (getSandboxRoot() == this){
                        super.addEventListener(actualType, eventProxy.marshalListener, useCapture, priority, useWeakReference);
                    };
                    super.addEventListener(type, listener, false, priority, useWeakReference);
                    return;
                };
            };
            if ((((type == FlexEvent.IDLE)) && (!(idleTimer)))){
                idleTimer = new Timer(IDLE_INTERVAL);
                idleTimer.addEventListener(TimerEvent.TIMER, idleTimer_timerHandler);
                idleTimer.start();
                addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
                addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            };
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        private function activateForm(_arg1:Object):void{
            var _local2:IFocusManagerContainer;
            if (form){
                if (((!((form == _arg1))) && ((forms.length > 1)))){
                    if (isRemotePopUp(form)){
                        if (!areRemotePopUpsEqual(form, _arg1)){
                            deactivateRemotePopUp(form);
                        };
                    } else {
                        _local2 = IFocusManagerContainer(form);
                        _local2.focusManager.deactivate();
                    };
                };
            };
            form = _arg1;
            if (isRemotePopUp(_arg1)){
                activateRemotePopUp(_arg1);
            } else {
                if (_arg1.focusManager){
                    _arg1.focusManager.activate();
                };
            };
            updateLastActiveForm();
        }
        public function removeFocusManager(_arg1:IFocusManagerContainer):void{
            var _local2:int = forms.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (forms[_local3] == _arg1){
                    if (form == _arg1){
                        deactivate(_arg1);
                    };
                    dispatchDeactivatedWindowEvent(DisplayObject(_arg1));
                    forms.splice(_local3, 1);
                    return;
                };
                _local3++;
            };
        }
        private function mouseMoveHandler(_arg1:MouseEvent):void{
            idleCounter = 0;
        }
        private function getSandboxScreen():Rectangle{
            var _local2:Rectangle;
            var _local3:DisplayObject;
            var _local4:InterManagerRequest;
            var _local1:DisplayObject = getSandboxRoot();
            if (_local1 == this){
                _local2 = new Rectangle(0, 0, width, height);
            } else {
                if (_local1 == topLevelSystemManager){
                    _local3 = DisplayObject(topLevelSystemManager);
                    _local2 = new Rectangle(0, 0, _local3.width, _local3.height);
                } else {
                    _local4 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "screen");
                    _local1.dispatchEvent(_local4);
                    _local2 = Rectangle(_local4.value);
                };
            };
            return (_local2);
        }
        public function get focusPane():Sprite{
            return (_focusPane);
        }
        override public function get mouseX():Number{
            if (_mouseX === undefined){
                return (super.mouseX);
            };
            return (_mouseX);
        }
        private function mouseDownHandler(_arg1:MouseEvent):void{
            var _local3:int;
            var _local4:DisplayObject;
            var _local5:Boolean;
            var _local6:int;
            var _local7:Object;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:IChildList;
            var _local12:DisplayObject;
            var _local13:Boolean;
            var _local14:int;
            idleCounter = 0;
            var _local2:IEventDispatcher = getSWFBridgeOfDisplayObject((_arg1.target as DisplayObject));
            if (((_local2) && ((bridgeToFocusManager[_local2] == document.focusManager)))){
                if (isTopLevelRoot()){
                    activateForm(document);
                } else {
                    dispatchActivatedApplicationEvent();
                };
                return;
            };
            if (numModalWindows == 0){
                if (((!(isTopLevelRoot())) || ((forms.length > 1)))){
                    _local3 = forms.length;
                    _local4 = DisplayObject(_arg1.target);
                    _local5 = document.rawChildren.contains(_local4);
                    while (_local4) {
                        _local6 = 0;
                        while (_local6 < _local3) {
                            _local7 = ((isRemotePopUp(forms[_local6])) ? forms[_local6].window : forms[_local6]);
                            if (_local7 == _local4){
                                _local8 = 0;
                                if (((((!((_local4 == form))) && ((_local4 is IFocusManagerContainer)))) || (((!(isTopLevelRoot())) && ((_local4 == form)))))){
                                    if (isTopLevelRoot()){
                                        activate(IFocusManagerContainer(_local4));
                                    };
                                    if (_local4 == document){
                                        dispatchActivatedApplicationEvent();
                                    } else {
                                        if ((_local4 is DisplayObject)){
                                            dispatchActivatedWindowEvent(DisplayObject(_local4));
                                        };
                                    };
                                };
                                if (popUpChildren.contains(_local4)){
                                    _local11 = popUpChildren;
                                } else {
                                    _local11 = this;
                                };
                                _local9 = _local11.getChildIndex(_local4);
                                _local10 = _local9;
                                _local3 = forms.length;
                                _local8 = 0;
                                for (;_local8 < _local3;_local8++) {
                                    _local13 = isRemotePopUp(forms[_local8]);
                                    if (_local13){
                                        if ((forms[_local8].window is String)){
                                            continue;
                                        };
                                        _local12 = forms[_local8].window;
                                    } else {
                                        _local12 = forms[_local8];
                                    };
                                    if (_local13){
                                        _local14 = getChildListIndex(_local11, _local12);
                                        if (_local14 > _local9){
                                            _local10 = Math.max(_local14, _local10);
                                        };
                                    } else {
                                        if (_local11.contains(_local12)){
                                            if (_local11.getChildIndex(_local12) > _local9){
                                                _local10 = Math.max(_local11.getChildIndex(_local12), _local10);
                                            };
                                        };
                                    };
                                };
                                if ((((_local10 > _local9)) && (!(_local5)))){
                                    _local11.setChildIndex(_local4, _local10);
                                };
                                return;
                            };
                            _local6++;
                        };
                        _local4 = _local4.parent;
                    };
                } else {
                    dispatchActivatedApplicationEvent();
                };
            };
        }
        private function removePopupRequestHandler(_arg1:Event):void{
            var _local3:SWFBridgeRequest;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (((swfBridgeGroup.parentBridge) && (SecurityUtil.hasMutualTrustBetweenParentAndChild(this)))){
                _local2.requestor = swfBridgeGroup.parentBridge;
                getSandboxRoot().dispatchEvent(_local2);
                return;
            };
            if (popUpChildren.contains(_local2.data.window)){
                popUpChildren.removeChild(_local2.data.window);
            } else {
                removeChild(DisplayObject(_local2.data.window));
            };
            if (_local2.data.modal){
                numModalWindows--;
            };
            removeRemotePopUp(new RemotePopUp(_local2.data.window, _local2.requestor));
            if (((!(isTopLevelRoot())) && (swfBridgeGroup))){
                _local3 = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST, false, false, _local2.requestor, {placeHolderId:NameUtil.displayObjectToString(_local2.data.window)});
                dispatchEvent(_local3);
            };
        }
        public function addChildBridge(_arg1:IEventDispatcher, _arg2:DisplayObject):void{
            var _local3:IFocusManager;
            var _local4:DisplayObject = _arg2;
            while (_local4) {
                if ((_local4 is IFocusManagerContainer)){
                    _local3 = IFocusManagerContainer(_local4).focusManager;
                    break;
                };
                _local4 = _local4.parent;
            };
            if (!_local3){
                return;
            };
            if (!swfBridgeGroup){
                swfBridgeGroup = new SWFBridgeGroup(this);
            };
            swfBridgeGroup.addChildBridge(_arg1, ISWFBridgeProvider(_arg2));
            _local3.addSWFBridge(_arg1, _arg2);
            if (!bridgeToFocusManager){
                bridgeToFocusManager = new Dictionary();
            };
            bridgeToFocusManager[_arg1] = _local3;
            addChildBridgeListeners(_arg1);
        }
        public function get screen():Rectangle{
            if (!_screen){
                Stage_resizeHandler();
            };
            if (!isStageRoot){
                Stage_resizeHandler();
            };
            return (_screen);
        }
        private function resetMouseCursorRequestHandler(_arg1:Event):void{
            var _local3:IEventDispatcher;
            if (((!(isTopLevelRoot())) && ((_arg1 is SWFBridgeRequest)))){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (!isTopLevelRoot()){
                _local3 = swfBridgeGroup.parentBridge;
                _local2.requestor = _local3;
                _local3.dispatchEvent(_local2);
            } else {
                if (eventProxy){
                    SystemManagerGlobals.showMouseCursor = true;
                };
            };
        }
        mx_internal function set topMostIndex(_arg1:int):void{
            var _local2:int = (_arg1 - _topMostIndex);
            _topMostIndex = _arg1;
            toolTipIndex = (toolTipIndex + _local2);
        }
        mx_internal function docFrameHandler(_arg1:Event=null):void{
            var _local2:TextFieldFactory;
            var _local4:int;
            var _local5:int;
            var _local6:Class;
            Singleton.registerClass("mx.managers::IBrowserManager", Class(getDefinitionByName("mx.managers::BrowserManagerImpl")));
            Singleton.registerClass("mx.managers::ICursorManager", Class(getDefinitionByName("mx.managers::CursorManagerImpl")));
            Singleton.registerClass("mx.managers::IHistoryManager", Class(getDefinitionByName("mx.managers::HistoryManagerImpl")));
            Singleton.registerClass("mx.managers::ILayoutManager", Class(getDefinitionByName("mx.managers::LayoutManager")));
            Singleton.registerClass("mx.managers::IPopUpManager", Class(getDefinitionByName("mx.managers::PopUpManagerImpl")));
            Singleton.registerClass("mx.managers::IToolTipManager2", Class(getDefinitionByName("mx.managers::ToolTipManagerImpl")));
            if (Capabilities.playerType == "Desktop"){
                Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::NativeDragManagerImpl")));
                if (Singleton.getClass("mx.managers::IDragManager") == null){
                    Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::DragManagerImpl")));
                };
            } else {
                Singleton.registerClass("mx.managers::IDragManager", Class(getDefinitionByName("mx.managers::DragManagerImpl")));
            };
            Singleton.registerClass("mx.core::ITextFieldFactory", Class(getDefinitionByName("mx.core::TextFieldFactory")));
            executeCallbacks();
            doneExecutingInitCallbacks = true;
            var _local3:Array = info()["mixins"];
            if (((_local3) && ((_local3.length > 0)))){
                _local4 = _local3.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    _local6 = Class(getDefinitionByName(_local3[_local5]));
                    var _local7 = _local6;
                    _local7["init"](this);
                    _local5++;
                };
            };
            installCompiledResourceBundles();
            initializeTopLevelWindow(null);
            deferredNextFrame();
        }
        public function get explicitHeight():Number{
            return (_explicitHeight);
        }
        public function get preloaderBackgroundSize():String{
            return (info()["backgroundSize"]);
        }
        public function isTopLevel():Boolean{
            return (topLevel);
        }
        override public function get mouseY():Number{
            if (_mouseY === undefined){
                return (super.mouseY);
            };
            return (_mouseY);
        }
        public function getExplicitOrMeasuredWidth():Number{
            return (((isNaN(explicitWidth)) ? measuredWidth : explicitWidth));
        }
        public function deactivate(_arg1:IFocusManagerContainer):void{
            deactivateForm(Object(_arg1));
        }
        private function preProcessModalWindowRequest(_arg1:SWFBridgeRequest, _arg2:DisplayObject):Boolean{
            var _local3:IEventDispatcher;
            var _local4:ISWFLoader;
            var _local5:Rectangle;
            if (_arg1.data.skip){
                _arg1.data.skip = false;
                if (useSWFBridge()){
                    _local3 = swfBridgeGroup.parentBridge;
                    _arg1.requestor = _local3;
                    _local3.dispatchEvent(_arg1);
                };
                return (false);
            };
            if (this != _arg2){
                if ((((_arg1.type == SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST)) || ((_arg1.type == SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST)))){
                    _local4 = (swfBridgeGroup.getChildBridgeProvider(_arg1.requestor) as ISWFLoader);
                    if (_local4){
                        _local5 = ISWFLoader(_local4).getVisibleApplicationRect();
                        _arg1.data.excludeRect = _local5;
                        if (!DisplayObjectContainer(document).contains(DisplayObject(_local4))){
                            _arg1.data.useExclude = false;
                        };
                    };
                };
                _local3 = swfBridgeGroup.parentBridge;
                _arg1.requestor = _local3;
                if (_arg1.type == SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST){
                    _arg2.dispatchEvent(_arg1);
                } else {
                    _local3.dispatchEvent(_arg1);
                };
                return (false);
            };
            _arg1.data.skip = false;
            return (true);
        }
        private function resetMouseCursorTracking(_arg1:Event):void{
            var _local2:SWFBridgeRequest;
            var _local3:IEventDispatcher;
            if (isTopLevelRoot()){
                SystemManagerGlobals.showMouseCursor = true;
            } else {
                if (swfBridgeGroup.parentBridge){
                    _local2 = new SWFBridgeRequest(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST);
                    _local3 = swfBridgeGroup.parentBridge;
                    _local2.requestor = _local3;
                    _local3.dispatchEvent(_local2);
                };
            };
        }
        mx_internal function addParentBridgeListeners():void{
            if (((!(topLevel)) && (topLevelSystemManager))){
                SystemManager(topLevelSystemManager).addParentBridgeListeners();
                return;
            };
            var _local1:IEventDispatcher = swfBridgeGroup.parentBridge;
            _local1.addEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST, setActualSizeRequestHandler);
            _local1.addEventListener(SWFBridgeRequest.GET_SIZE_REQUEST, getSizeRequestHandler);
            _local1.addEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST, activateRequestHandler);
            _local1.addEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST, deactivateRequestHandler);
            _local1.addEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST, isBridgeChildHandler);
            _local1.addEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _local1.addEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _local1.addEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST, canActivateHandler);
            _local1.addEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING, beforeUnloadHandler);
        }
        public function get swfBridgeGroup():ISWFBridgeGroup{
            if (topLevel){
                return (_swfBridgeGroup);
            };
            if (topLevelSystemManager){
                return (topLevelSystemManager.swfBridgeGroup);
            };
            return (null);
        }
        override public function getChildByName(_arg1:String):DisplayObject{
            return (super.getChildByName(_arg1));
        }
        public function get measuredWidth():Number{
            return (((topLevelWindow) ? topLevelWindow.getExplicitOrMeasuredWidth() : loaderInfo.width));
        }
        public function removeChildBridge(_arg1:IEventDispatcher):void{
            var _local2:IFocusManager = IFocusManager(bridgeToFocusManager[_arg1]);
            _local2.removeSWFBridge(_arg1);
            swfBridgeGroup.removeChildBridge(_arg1);
            delete bridgeToFocusManager[_arg1];
            removeChildBridgeListeners(_arg1);
        }
        mx_internal function removeChildBridgeListeners(_arg1:IEventDispatcher):void{
            if (((!(topLevel)) && (topLevelSystemManager))){
                SystemManager(topLevelSystemManager).removeChildBridgeListeners(_arg1);
                return;
            };
            _arg1.removeEventListener(SWFBridgeRequest.ADD_POP_UP_REQUEST, addPopupRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_REQUEST, removePopupRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, addPlaceholderPopupRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST, removePlaceholderPopupRequestHandler);
            _arg1.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE, activateFormSandboxEventHandler);
            _arg1.removeEventListener(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE, deactivateFormSandboxEventHandler);
            _arg1.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE, activateApplicationSandboxEventHandler);
            _arg1.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _arg1.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST, modalWindowRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST, getVisibleRectRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.HIDE_MOUSE_CURSOR_REQUEST, hideMouseCursorRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.SHOW_MOUSE_CURSOR_REQUEST, showMouseCursorRequestHandler);
            _arg1.removeEventListener(SWFBridgeRequest.RESET_MOUSE_CURSOR_REQUEST, resetMouseCursorRequestHandler);
        }
        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            noTopMostIndex++;
            return (rawChildren_addChildAt(_arg1, (applicationIndex + _arg2)));
        }
        private function Stage_resizeHandler(_arg1:Event=null):void{
            var m:* = NaN;
            var n:* = NaN;
            var sandboxScreen:* = null;
            var event = _arg1;
            if (isDispatchingResizeEvent){
                return;
            };
            var w:* = 0;
            var h:* = 0;
            try {
                m = loaderInfo.width;
                n = loaderInfo.height;
            } catch(error:Error) {
                return;
            };
            var align:* = StageAlign.TOP_LEFT;
            try {
                if (stage){
                    w = stage.stageWidth;
                    h = stage.stageHeight;
                    align = stage.align;
                };
            } catch(error:SecurityError) {
                sandboxScreen = getSandboxScreen();
                w = sandboxScreen.width;
                h = sandboxScreen.height;
            };
            var x:* = ((m - w) / 2);
            var y:* = ((n - h) / 2);
            if (align == StageAlign.TOP){
                y = 0;
            } else {
                if (align == StageAlign.BOTTOM){
                    y = (n - h);
                } else {
                    if (align == StageAlign.LEFT){
                        x = 0;
                    } else {
                        if (align == StageAlign.RIGHT){
                            x = (m - w);
                        } else {
                            if ((((align == StageAlign.TOP_LEFT)) || ((align == "LT")))){
                                y = 0;
                                x = 0;
                            } else {
                                if (align == StageAlign.TOP_RIGHT){
                                    y = 0;
                                    x = (m - w);
                                } else {
                                    if (align == StageAlign.BOTTOM_LEFT){
                                        y = (n - h);
                                        x = 0;
                                    } else {
                                        if (align == StageAlign.BOTTOM_RIGHT){
                                            y = (n - h);
                                            x = (m - w);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            if (!_screen){
                _screen = new Rectangle();
            };
            _screen.x = x;
            _screen.y = y;
            _screen.width = w;
            _screen.height = h;
            if (isStageRoot){
                _width = stage.stageWidth;
                _height = stage.stageHeight;
            };
            if (event){
                resizeMouseCatcher();
                isDispatchingResizeEvent = true;
                dispatchEvent(event);
                isDispatchingResizeEvent = false;
            };
        }
        public function get swfBridge():IEventDispatcher{
            if (swfBridgeGroup){
                return (swfBridgeGroup.parentBridge);
            };
            return (null);
        }
        private function findRemotePopUp(_arg1:Object, _arg2:IEventDispatcher):RemotePopUp{
            var _local5:RemotePopUp;
            var _local3:int = forms.length;
            var _local4:int;
            while (_local4 < _local3) {
                if (isRemotePopUp(forms[_local4])){
                    _local5 = RemotePopUp(forms[_local4]);
                    if ((((_local5.window == _arg1)) && ((_local5.bridge == _arg2)))){
                        return (_local5);
                    };
                };
                _local4++;
            };
            return (null);
        }
        public function info():Object{
            return ({});
        }
        mx_internal function get toolTipIndex():int{
            return (_toolTipIndex);
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            if (isStageRoot){
                return;
            };
            _width = _arg1;
            _height = _arg2;
            if (mouseCatcher){
                mouseCatcher.width = _arg1;
                mouseCatcher.height = _arg2;
            };
            dispatchEvent(new Event(Event.RESIZE));
        }
        private function removePlaceholderPopupRequestHandler(_arg1:Event):void{
            var _local3:int;
            var _local4:int;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (!forwardPlaceholderRequest(_local2, false)){
                _local3 = forms.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    if (isRemotePopUp(forms[_local4])){
                        if ((((forms[_local4].window == _local2.data.placeHolderId)) && ((forms[_local4].bridge == _local2.requestor)))){
                            forms.splice(_local4, 1);
                            break;
                        };
                    };
                    _local4++;
                };
            };
        }
        public function set focusPane(_arg1:Sprite):void{
            if (_arg1){
                addChild(_arg1);
                _arg1.x = 0;
                _arg1.y = 0;
                _arg1.scrollRect = null;
                _focusPane = _arg1;
            } else {
                removeChild(_focusPane);
                _focusPane = null;
            };
        }
        mx_internal function removeParentBridgeListeners():void{
            if (((!(topLevel)) && (topLevelSystemManager))){
                SystemManager(topLevelSystemManager).removeParentBridgeListeners();
                return;
            };
            var _local1:IEventDispatcher = swfBridgeGroup.parentBridge;
            _local1.removeEventListener(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST, setActualSizeRequestHandler);
            _local1.removeEventListener(SWFBridgeRequest.GET_SIZE_REQUEST, getSizeRequestHandler);
            _local1.removeEventListener(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST, activateRequestHandler);
            _local1.removeEventListener(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST, deactivateRequestHandler);
            _local1.removeEventListener(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST, isBridgeChildHandler);
            _local1.removeEventListener(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _local1.removeEventListener(EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST, eventListenerRequestHandler);
            _local1.removeEventListener(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST, canActivateHandler);
            _local1.removeEventListener(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING, beforeUnloadHandler);
        }
        override public function get parent():DisplayObjectContainer{
            try {
                return (super.parent);
            } catch(e:SecurityError) {
            };
            return (null);
        }
        private function eventListenerRequestHandler(_arg1:Event):void{
            var _local2:String;
            if ((_arg1 is EventListenerRequest)){
                return;
            };
            var _local3:EventListenerRequest = EventListenerRequest.marshal(_arg1);
            if (_arg1.type == EventListenerRequest.ADD_EVENT_LISTENER_REQUEST){
                if (!eventProxy){
                    eventProxy = new EventProxy(this);
                };
                _local2 = EventUtil.sandboxMouseEventMap[_local3.eventType];
                if (_local2){
                    if (isTopLevelRoot()){
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, resetMouseCursorTracking, true, (EventPriority.CURSOR_MANAGEMENT + 1), true);
                    } else {
                        super.addEventListener(MouseEvent.MOUSE_MOVE, resetMouseCursorTracking, true, (EventPriority.CURSOR_MANAGEMENT + 1), true);
                    };
                    addEventListenerToSandboxes(_local3.eventType, sandboxMouseListener, true, _local3.priority, _local3.useWeakReference, (_arg1.target as IEventDispatcher));
                    addEventListenerToOtherSystemManagers(_local3.eventType, otherSystemManagerMouseListener, true, _local3.priority, _local3.useWeakReference);
                    if (getSandboxRoot() == this){
                        if (((isTopLevelRoot()) && ((((_local2 == MouseEvent.MOUSE_UP)) || ((_local2 == MouseEvent.MOUSE_MOVE)))))){
                            stage.addEventListener(_local2, eventProxy.marshalListener, false, _local3.priority, _local3.useWeakReference);
                        };
                        super.addEventListener(_local2, eventProxy.marshalListener, true, _local3.priority, _local3.useWeakReference);
                    };
                };
            } else {
                if (_arg1.type == EventListenerRequest.REMOVE_EVENT_LISTENER_REQUEST){
                    _local2 = EventUtil.sandboxMouseEventMap[_local3.eventType];
                    if (_local2){
                        removeEventListenerFromOtherSystemManagers(_local3.eventType, otherSystemManagerMouseListener, true);
                        removeEventListenerFromSandboxes(_local3.eventType, sandboxMouseListener, true, (_arg1.target as IEventDispatcher));
                        if (getSandboxRoot() == this){
                            if (((isTopLevelRoot()) && ((((_local2 == MouseEvent.MOUSE_UP)) || ((_local2 == MouseEvent.MOUSE_MOVE)))))){
                                stage.removeEventListener(_local2, eventProxy.marshalListener);
                            };
                            super.removeEventListener(_local2, eventProxy.marshalListener, true);
                        };
                    };
                };
            };
        }
        mx_internal function set applicationIndex(_arg1:int):void{
            _applicationIndex = _arg1;
        }
        private function showMouseCursorRequestHandler(_arg1:Event):void{
            var _local3:IEventDispatcher;
            if (((!(isTopLevelRoot())) && ((_arg1 is SWFBridgeRequest)))){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (!isTopLevelRoot()){
                _local3 = swfBridgeGroup.parentBridge;
                _local2.requestor = _local3;
                _local3.dispatchEvent(_local2);
                Object(_arg1).data = _local2.data;
            } else {
                if (eventProxy){
                    Object(_arg1).data = SystemManagerGlobals.showMouseCursor;
                };
            };
        }
        public function get childAllowsParent():Boolean{
            try {
                return (loaderInfo.childAllowsParent);
            } catch(error:Error) {
            };
            return (false);
        }
        public function dispatchEventFromSWFBridges(_arg1:Event, _arg2:IEventDispatcher=null, _arg3:Boolean=false, _arg4:Boolean=false):void{
            var _local5:Event;
            if (_arg4){
                dispatchEventToOtherSystemManagers(_arg1);
            };
            if (!swfBridgeGroup){
                return;
            };
            _local5 = _arg1.clone();
            if (_arg3){
                currentSandboxEvent = _local5;
            };
            var _local6:IEventDispatcher = swfBridgeGroup.parentBridge;
            if (((_local6) && (!((_local6 == _arg2))))){
                if ((_local5 is SWFBridgeRequest)){
                    SWFBridgeRequest(_local5).requestor = _local6;
                };
                _local6.dispatchEvent(_local5);
            };
            var _local7:Array = swfBridgeGroup.getChildBridges();
            var _local8:int;
            while (_local8 < _local7.length) {
                if (_local7[_local8] != _arg2){
                    _local5 = _arg1.clone();
                    if (_arg3){
                        currentSandboxEvent = _local5;
                    };
                    if ((_local5 is SWFBridgeRequest)){
                        SWFBridgeRequest(_local5).requestor = IEventDispatcher(_local7[_local8]);
                    };
                    IEventDispatcher(_local7[_local8]).dispatchEvent(_local5);
                };
                _local8++;
            };
            currentSandboxEvent = null;
        }
        private function setActualSizeRequestHandler(_arg1:Event):void{
            var _local2:Object = Object(_arg1);
            setActualSize(_local2.data.width, _local2.data.height);
        }
        private function executeCallbacks():void{
            var _local1:Function;
            if (((!(parent)) && (parentAllowsChild))){
                return;
            };
            while (initCallbackFunctions.length > 0) {
                _local1 = initCallbackFunctions.shift();
                _local1(this);
            };
        }
        private function addPlaceholderId(_arg1:String, _arg2:String, _arg3:IEventDispatcher, _arg4:Object):void{
            if (!_arg3){
                throw (new Error());
            };
            if (!idToPlaceholder){
                idToPlaceholder = [];
            };
            idToPlaceholder[_arg1] = new PlaceholderData(_arg2, _arg3, _arg4);
        }
        private function canActivateHandler(_arg1:Event):void{
            var _local3:SWFBridgeRequest;
            var _local6:PlaceholderData;
            var _local7:RemotePopUp;
            var _local8:SystemManagerProxy;
            var _local9:IFocusManagerContainer;
            var _local10:IEventDispatcher;
            var _local2:Object = Object(_arg1);
            var _local4:Object = _local2.data;
            var _local5:String;
            if ((_local2.data is String)){
                _local6 = idToPlaceholder[_local2.data];
                _local4 = _local6.data;
                _local5 = _local6.id;
                if (_local5 == null){
                    _local7 = findRemotePopUp(_local4, _local6.bridge);
                    if (_local7){
                        _local3 = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST, false, false, IEventDispatcher(_local7.bridge), _local7.window);
                        if (_local7.bridge){
                            _local7.bridge.dispatchEvent(_local3);
                            _local2.data = _local3.data;
                        };
                        return;
                    };
                };
            };
            if ((_local4 is SystemManagerProxy)){
                _local8 = SystemManagerProxy(_local4);
                _local9 = findFocusManagerContainer(_local8);
                _local2.data = ((((_local8) && (_local9))) && (canActivateLocalComponent(_local9)));
            } else {
                if ((_local4 is IFocusManagerContainer)){
                    _local2.data = canActivateLocalComponent(_local4);
                } else {
                    if ((_local4 is IEventDispatcher)){
                        _local10 = IEventDispatcher(_local4);
                        _local3 = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST, false, false, _local10, _local5);
                        if (_local10){
                            _local10.dispatchEvent(_local3);
                            _local2.data = _local3.data;
                        };
                    } else {
                        throw (new Error());
                    };
                };
            };
        }
        private function docFrameListener(_arg1:Event):void{
            if (currentFrame == 2){
                removeEventListener(Event.ENTER_FRAME, docFrameListener);
                if (totalFrames > 2){
                    addEventListener(Event.ENTER_FRAME, extraFrameListener);
                };
                docFrameHandler();
            };
        }
        public function get popUpChildren():IChildList{
            if (!topLevel){
                return (_topLevelSystemManager.popUpChildren);
            };
            if (!_popUpChildren){
                _popUpChildren = new SystemChildrenList(this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));
            };
            return (_popUpChildren);
        }
        private function addEventListenerToSandboxes(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false, _arg6:IEventDispatcher=null):void{
            var _local10:int;
            var _local11:IEventDispatcher;
            if (!swfBridgeGroup){
                return;
            };
            var _local7:EventListenerRequest = new EventListenerRequest(EventListenerRequest.ADD_EVENT_LISTENER_REQUEST, false, false, _arg1, _arg3, _arg4, _arg5);
            var _local8:IEventDispatcher = swfBridgeGroup.parentBridge;
            if (((_local8) && (!((_local8 == _arg6))))){
                _local8.addEventListener(_arg1, _arg2, false, _arg4, _arg5);
            };
            var _local9:Array = swfBridgeGroup.getChildBridges();
            while (_local10 < _local9.length) {
                _local11 = IEventDispatcher(_local9[_local10]);
                if (_local11 != _arg6){
                    _local11.addEventListener(_arg1, _arg2, false, _arg4, _arg5);
                };
                _local10++;
            };
            dispatchEventFromSWFBridges(_local7, _arg6);
        }
        private function forwardFormEvent(_arg1:SWFBridgeEvent):Boolean{
            var _local3:DisplayObject;
            if (isTopLevelRoot()){
                return (false);
            };
            var _local2:IEventDispatcher = swfBridgeGroup.parentBridge;
            if (_local2){
                _local3 = getSandboxRoot();
                _arg1.data.notifier = _local2;
                if (_local3 == this){
                    if (!(_arg1.data.window is String)){
                        _arg1.data.window = NameUtil.displayObjectToString(DisplayObject(_arg1.data.window));
                    } else {
                        _arg1.data.window = ((NameUtil.displayObjectToString(DisplayObject(this)) + ".") + _arg1.data.window);
                    };
                    _local2.dispatchEvent(_arg1);
                } else {
                    if ((_arg1.data.window is String)){
                        _arg1.data.window = ((NameUtil.displayObjectToString(DisplayObject(this)) + ".") + _arg1.data.window);
                    };
                    _local3.dispatchEvent(_arg1);
                };
            };
            return (true);
        }
        public function set explicitHeight(_arg1:Number):void{
            _explicitHeight = _arg1;
        }
        override public function removeChild(_arg1:DisplayObject):DisplayObject{
            noTopMostIndex--;
            return (rawChildren_removeChild(_arg1));
        }
        mx_internal function rawChildren_removeChild(_arg1:DisplayObject):DisplayObject{
            removingChild(_arg1);
            super.removeChild(_arg1);
            childRemoved(_arg1);
            return (_arg1);
        }
        final mx_internal function get $numChildren():int{
            return (super.numChildren);
        }
        public function get toolTipChildren():IChildList{
            if (!topLevel){
                return (_topLevelSystemManager.toolTipChildren);
            };
            if (!_toolTipChildren){
                _toolTipChildren = new SystemChildrenList(this, new QName(mx_internal, "topMostIndex"), new QName(mx_internal, "toolTipIndex"));
            };
            return (_toolTipChildren);
        }
        public function create(... _args):Object{
            var _local4:String;
            var _local5:int;
            var _local6:int;
            var _local2:String = info()["mainClassName"];
            if (_local2 == null){
                _local4 = loaderInfo.loaderURL;
                _local5 = _local4.lastIndexOf(".");
                _local6 = _local4.lastIndexOf("/");
                _local2 = _local4.substring((_local6 + 1), _local5);
            };
            var _local3:Class = Class(getDefinitionByName(_local2));
            return (((_local3) ? new (_local3)() : null));
        }
        override public function get stage():Stage{
            var _local2:DisplayObject;
            if (_stage){
                return (_stage);
            };
            var _local1:Stage = super.stage;
            if (_local1){
                _stage = _local1;
                return (_local1);
            };
            if (((!(topLevel)) && (_topLevelSystemManager))){
                _stage = _topLevelSystemManager.stage;
                return (_stage);
            };
            if (((!(isStageRoot)) && (topLevel))){
                _local2 = getTopLevelRoot();
                if (_local2){
                    _stage = _local2.stage;
                    return (_stage);
                };
            };
            return (null);
        }
        override public function addChild(_arg1:DisplayObject):DisplayObject{
            noTopMostIndex++;
            return (rawChildren_addChildAt(_arg1, (noTopMostIndex - 1)));
        }
        private function removeRemotePopUp(_arg1:RemotePopUp):void{
            var _local2:int = forms.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (isRemotePopUp(forms[_local3])){
                    if ((((forms[_local3].window == _arg1.window)) && ((forms[_local3].bridge == _arg1.bridge)))){
                        if (forms[_local3] == _arg1){
                            deactivateForm(_arg1);
                        };
                        forms.splice(_local3, 1);
                        break;
                    };
                };
                _local3++;
            };
        }
        private function deactivateRemotePopUp(_arg1:Object):void{
            var _local2:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.DEACTIVATE_POP_UP_REQUEST, false, false, _arg1.bridge, _arg1.window);
            var _local3:Object = _arg1.bridge;
            if (_local3){
                _local3.dispatchEvent(_local2);
            };
        }
        override public function getChildIndex(_arg1:DisplayObject):int{
            return ((super.getChildIndex(_arg1) - applicationIndex));
        }
        mx_internal function rawChildren_getChildIndex(_arg1:DisplayObject):int{
            return (super.getChildIndex(_arg1));
        }
        public function activate(_arg1:IFocusManagerContainer):void{
            activateForm(_arg1);
        }
        public function getSandboxRoot():DisplayObject{
            var parent:* = null;
            var lastParent:* = null;
            var loader:* = null;
            var loaderInfo:* = null;
            var sm:* = this;
            try {
                if (sm.topLevelSystemManager){
                    sm = sm.topLevelSystemManager;
                };
                parent = DisplayObject(sm).parent;
                if ((parent is Stage)){
                    return (DisplayObject(sm));
                };
                if (((parent) && (!(parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true)))))){
                    return (this);
                };
                lastParent = parent;
                while (parent) {
                    if ((parent is Stage)){
                        return (lastParent);
                    };
                    if (!parent.dispatchEvent(new Event("mx.managers.SystemManager.isBootstrapRoot", false, true))){
                        return (lastParent);
                    };
                    if ((parent is Loader)){
                        loader = Loader(parent);
                        loaderInfo = loader.contentLoaderInfo;
                        if (!loaderInfo.childAllowsParent){
                            return (loaderInfo.content);
                        };
                    };
                    lastParent = parent;
                    parent = parent.parent;
                };
            } catch(error:SecurityError) {
            };
            return (((lastParent)!=null) ? lastParent : DisplayObject(sm));
        }
        private function deferredNextFrame():void{
            if ((currentFrame + 1) > totalFrames){
                return;
            };
            if ((currentFrame + 1) <= framesLoaded){
                nextFrame();
            } else {
                nextFrameTimer = new Timer(100);
                nextFrameTimer.addEventListener(TimerEvent.TIMER, nextFrameTimerHandler);
                nextFrameTimer.start();
            };
        }
        mx_internal function get cursorIndex():int{
            return (_cursorIndex);
        }
        mx_internal function rawChildren_contains(_arg1:DisplayObject):Boolean{
            return (super.contains(_arg1));
        }
        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            super.setChildIndex(_arg1, (applicationIndex + _arg2));
        }
        public function get document():Object{
            return (_document);
        }
        private function resizeMouseCatcher():void{
            var g:* = null;
            var s:* = null;
            if (mouseCatcher){
                try {
                    g = mouseCatcher.graphics;
                    s = screen;
                    g.clear();
                    g.beginFill(0, 0);
                    g.drawRect(0, 0, s.width, s.height);
                    g.endFill();
                } catch(e:SecurityError) {
                };
            };
        }
        private function extraFrameListener(_arg1:Event):void{
            if (lastFrame == currentFrame){
                return;
            };
            lastFrame = currentFrame;
            if ((currentFrame + 1) > totalFrames){
                removeEventListener(Event.ENTER_FRAME, extraFrameListener);
            };
            extraFrameHandler();
        }
        private function addPopupRequestHandler(_arg1:Event):void{
            var _local3:Boolean;
            var _local4:IChildList;
            var _local6:ISWFBridgeProvider;
            var _local7:SWFBridgeRequest;
            if (((!((_arg1.target == this))) && ((_arg1 is SWFBridgeRequest)))){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (_arg1.target != this){
                _local6 = swfBridgeGroup.getChildBridgeProvider(IEventDispatcher(_arg1.target));
                if (!SecurityUtil.hasMutualTrustBetweenParentAndChild(_local6)){
                    return;
                };
            };
            if (((swfBridgeGroup.parentBridge) && (SecurityUtil.hasMutualTrustBetweenParentAndChild(this)))){
                _local2.requestor = swfBridgeGroup.parentBridge;
                getSandboxRoot().dispatchEvent(_local2);
                return;
            };
            if (((!(_local2.data.childList)) || ((_local2.data.childList == PopUpManagerChildList.PARENT)))){
                _local3 = ((_local2.data.parent) && (popUpChildren.contains(_local2.data.parent)));
            } else {
                _local3 = (_local2.data.childList == PopUpManagerChildList.POPUP);
            };
            _local4 = ((_local3) ? popUpChildren : this);
            _local4.addChild(DisplayObject(_local2.data.window));
            if (_local2.data.modal){
                numModalWindows++;
            };
            var _local5:RemotePopUp = new RemotePopUp(_local2.data.window, _local2.requestor);
            forms.push(_local5);
            if (((!(isTopLevelRoot())) && (swfBridgeGroup))){
                _local7 = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, false, false, _local2.requestor, {window:_local2.data.window});
                _local7.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(_local2.data.window));
                dispatchEvent(_local7);
            };
        }
        override public function get height():Number{
            return (_height);
        }
        mx_internal function rawChildren_getChildAt(_arg1:int):DisplayObject{
            return (super.getChildAt(_arg1));
        }
        private function systemManagerHandler(_arg1:Event):void{
            if (_arg1["name"] == "sameSandbox"){
                _arg1["value"] = (currentSandboxEvent == _arg1["value"]);
                return;
            };
            if (_arg1["name"] == "hasSWFBridges"){
                _arg1["value"] = hasSWFBridges();
                return;
            };
            if ((_arg1 is InterManagerRequest)){
                return;
            };
            var _local2:String = _arg1["name"];
            switch (_local2){
                case "popUpChildren.addChild":
                    popUpChildren.addChild(_arg1["value"]);
                    break;
                case "popUpChildren.removeChild":
                    popUpChildren.removeChild(_arg1["value"]);
                    break;
                case "cursorChildren.addChild":
                    cursorChildren.addChild(_arg1["value"]);
                    break;
                case "cursorChildren.removeChild":
                    cursorChildren.removeChild(_arg1["value"]);
                    break;
                case "toolTipChildren.addChild":
                    toolTipChildren.addChild(_arg1["value"]);
                    break;
                case "toolTipChildren.removeChild":
                    toolTipChildren.removeChild(_arg1["value"]);
                    break;
                case "screen":
                    _arg1["value"] = screen;
                    break;
                case "application":
                    _arg1["value"] = application;
                    break;
                case "isTopLevelRoot":
                    _arg1["value"] = isTopLevelRoot();
                    break;
                case "getVisibleApplicationRect":
                    _arg1["value"] = getVisibleApplicationRect();
                    break;
                case "bringToFront":
                    if (_arg1["value"].topMost){
                        popUpChildren.setChildIndex(DisplayObject(_arg1["value"].popUp), (popUpChildren.numChildren - 1));
                    } else {
                        setChildIndex(DisplayObject(_arg1["value"].popUp), (numChildren - 1));
                    };
                    break;
            };
        }
        private function activateRemotePopUp(_arg1:Object):void{
            var _local2:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.ACTIVATE_POP_UP_REQUEST, false, false, _arg1.bridge, _arg1.window);
            var _local3:Object = _arg1.bridge;
            if (_local3){
                _local3.dispatchEvent(_local2);
            };
        }
        mx_internal function set noTopMostIndex(_arg1:int):void{
            var _local2:int = (_arg1 - _noTopMostIndex);
            _noTopMostIndex = _arg1;
            topMostIndex = (topMostIndex + _local2);
        }
        override public function getObjectsUnderPoint(_arg1:Point):Array{
            var _local5:DisplayObject;
            var _local6:Array;
            var _local2:Array = [];
            var _local3:int = topMostIndex;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = super.getChildAt(_local4);
                if ((_local5 is DisplayObjectContainer)){
                    _local6 = DisplayObjectContainer(_local5).getObjectsUnderPoint(_arg1);
                    if (_local6){
                        _local2 = _local2.concat(_local6);
                    };
                };
                _local4++;
            };
            return (_local2);
        }
        mx_internal function get topMostIndex():int{
            return (_topMostIndex);
        }
        mx_internal function regenerateStyleCache(_arg1:Boolean):void{
            var _local5:IStyleClient;
            var _local2:Boolean;
            var _local3:int = rawChildren.numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = (rawChildren.getChildAt(_local4) as IStyleClient);
                if (_local5){
                    _local5.regenerateStyleCache(_arg1);
                };
                if (isTopLevelWindow(DisplayObject(_local5))){
                    _local2 = true;
                };
                _local3 = rawChildren.numChildren;
                _local4++;
            };
            if (((!(_local2)) && ((topLevelWindow is IStyleClient)))){
                IStyleClient(topLevelWindow).regenerateStyleCache(_arg1);
            };
        }
        public function addFocusManager(_arg1:IFocusManagerContainer):void{
            forms.push(_arg1);
        }
        private function deactivateFormSandboxEventHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:SWFBridgeEvent = SWFBridgeEvent.marshal(_arg1);
            if (!forwardFormEvent(_local2)){
                if (((((isRemotePopUp(form)) && ((RemotePopUp(form).window == _local2.data.window)))) && ((RemotePopUp(form).bridge == _local2.data.notifier)))){
                    deactivateForm(form);
                };
            };
        }
        public function set swfBridgeGroup(_arg1:ISWFBridgeGroup):void{
            if (topLevel){
                _swfBridgeGroup = _arg1;
            } else {
                if (topLevelSystemManager){
                    SystemManager(topLevelSystemManager).swfBridgeGroup = _arg1;
                };
            };
        }
        mx_internal function rawChildren_setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            super.setChildIndex(_arg1, _arg2);
        }
        private function mouseUpHandler(_arg1:MouseEvent):void{
            idleCounter = 0;
        }
        mx_internal function childAdded(_arg1:DisplayObject):void{
            _arg1.dispatchEvent(new FlexEvent(FlexEvent.ADD));
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).initialize();
            };
        }
        public function isFontFaceEmbedded(_arg1:TextFormat):Boolean{
            var _local6:Font;
            var _local7:String;
            var _local2:String = _arg1.font;
            var _local3:Array = Font.enumerateFonts();
            var _local4:int;
            while (_local4 < _local3.length) {
                _local6 = Font(_local3[_local4]);
                if (_local6.fontName == _local2){
                    _local7 = "regular";
                    if (((_arg1.bold) && (_arg1.italic))){
                        _local7 = "boldItalic";
                    } else {
                        if (_arg1.bold){
                            _local7 = "bold";
                        } else {
                            if (_arg1.italic){
                                _local7 = "italic";
                            };
                        };
                    };
                    if (_local6.fontStyle == _local7){
                        return (true);
                    };
                };
                _local4++;
            };
            if (((((!(_local2)) || (!(embeddedFontList)))) || (!(embeddedFontList[_local2])))){
                return (false);
            };
            var _local5:Object = embeddedFontList[_local2];
            return (!(((((((_arg1.bold) && (!(_local5.bold)))) || (((_arg1.italic) && (!(_local5.italic)))))) || (((((!(_arg1.bold)) && (!(_arg1.italic)))) && (!(_local5.regular)))))));
        }
        private function forwardPlaceholderRequest(_arg1:SWFBridgeRequest, _arg2:Boolean):Boolean{
            if (isTopLevelRoot()){
                return (false);
            };
            var _local3:Object;
            var _local4:String;
            if (_arg1.data.window){
                _local3 = _arg1.data.window;
                _arg1.data.window = null;
            } else {
                _local3 = _arg1.requestor;
                _local4 = _arg1.data.placeHolderId;
                _arg1.data.placeHolderId = ((NameUtil.displayObjectToString(this) + ".") + _arg1.data.placeHolderId);
            };
            if (_arg2){
                addPlaceholderId(_arg1.data.placeHolderId, _local4, _arg1.requestor, _local3);
            } else {
                removePlaceholderId(_arg1.data.placeHolderId);
            };
            var _local5:DisplayObject = getSandboxRoot();
            var _local6:IEventDispatcher = swfBridgeGroup.parentBridge;
            _arg1.requestor = _local6;
            if (_local5 == this){
                _local6.dispatchEvent(_arg1);
            } else {
                _local5.dispatchEvent(_arg1);
            };
            return (true);
        }
        public function getTopLevelRoot():DisplayObject{
            var sm:* = null;
            var parent:* = null;
            var lastParent:* = null;
            try {
                sm = this;
                if (sm.topLevelSystemManager){
                    sm = sm.topLevelSystemManager;
                };
                parent = DisplayObject(sm).parent;
                lastParent = parent;
                while (parent) {
                    if ((parent is Stage)){
                        return (lastParent);
                    };
                    lastParent = parent;
                    parent = parent.parent;
                };
            } catch(error:SecurityError) {
            };
            return (null);
        }
        override public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            var newListener:* = null;
            var actualType:* = null;
            var type:* = _arg1;
            var listener:* = _arg2;
            var useCapture:Boolean = _arg3;
            if ((((type == FlexEvent.RENDER)) || ((type == FlexEvent.ENTER_FRAME)))){
                if (type == FlexEvent.RENDER){
                    type = Event.RENDER;
                } else {
                    type = Event.ENTER_FRAME;
                };
                try {
                    if (stage){
                        stage.removeEventListener(type, listener, useCapture);
                    };
                    super.removeEventListener(type, listener, useCapture);
                } catch(error:SecurityError) {
                    super.removeEventListener(type, listener, useCapture);
                };
                return;
            };
            if ((((((((((type == MouseEvent.MOUSE_MOVE)) || ((type == MouseEvent.MOUSE_UP)))) || ((type == MouseEvent.MOUSE_DOWN)))) || ((type == Event.ACTIVATE)))) || ((type == Event.DEACTIVATE)))){
                try {
                    if (stage){
                        newListener = weakReferenceProxies[listener];
                        if (!newListener){
                            newListener = strongReferenceProxies[listener];
                            if (newListener){
                                delete strongReferenceProxies[listener];
                            };
                        };
                        if (newListener){
                            stage.removeEventListener(type, newListener.stageListener, false);
                        };
                    };
                } catch(error:SecurityError) {
                };
            };
            if (((hasSWFBridges()) || ((SystemManagerGlobals.topLevelSystemManagers.length > 1)))){
                actualType = EventUtil.sandboxMouseEventMap[type];
                if (actualType){
                    if ((((getSandboxRoot() == this)) && (eventProxy))){
                        super.removeEventListener(actualType, eventProxy.marshalListener, useCapture);
                    };
                    if (!SystemManagerGlobals.changingListenersInOtherSystemManagers){
                        removeEventListenerFromOtherSystemManagers(type, otherSystemManagerMouseListener, useCapture);
                    };
                    removeEventListenerFromSandboxes(type, sandboxMouseListener, useCapture);
                    super.removeEventListener(type, listener, false);
                    return;
                };
            };
            if (type == FlexEvent.IDLE){
                super.removeEventListener(type, listener, useCapture);
                if (((!(hasEventListener(FlexEvent.IDLE))) && (idleTimer))){
                    idleTimer.stop();
                    idleTimer = null;
                    removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
                    removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
                };
            } else {
                super.removeEventListener(type, listener, useCapture);
            };
        }
        private function extraFrameHandler(_arg1:Event=null):void{
            var _local3:Class;
            var _local2:Object = info()["frames"];
            if (((_local2) && (_local2[currentLabel]))){
                _local3 = Class(getDefinitionByName(_local2[currentLabel]));
                var _local4 = _local3;
                _local4["frame"](this);
            };
            deferredNextFrame();
        }
        public function isTopLevelRoot():Boolean{
            return (((isStageRoot) || (isBootstrapRoot)));
        }
        public function get application():IUIComponent{
            return (IUIComponent(_document));
        }
        override public function removeChildAt(_arg1:int):DisplayObject{
            noTopMostIndex--;
            return (rawChildren_removeChildAt((applicationIndex + _arg1)));
        }
        mx_internal function rawChildren_removeChildAt(_arg1:int):DisplayObject{
            var _local2:DisplayObject = super.getChildAt(_arg1);
            removingChild(_local2);
            super.removeChildAt(_arg1);
            childRemoved(_local2);
            return (_local2);
        }
        private function getSWFBridgeOfDisplayObject(_arg1:DisplayObject):IEventDispatcher{
            var _local2:SWFBridgeRequest;
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            var _local6:IEventDispatcher;
            var _local7:ISWFBridgeProvider;
            if (swfBridgeGroup){
                _local2 = new SWFBridgeRequest(SWFBridgeRequest.IS_BRIDGE_CHILD_REQUEST, false, false, null, _arg1);
                _local3 = swfBridgeGroup.getChildBridges();
                _local4 = _local3.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    _local6 = IEventDispatcher(_local3[_local5]);
                    _local7 = swfBridgeGroup.getChildBridgeProvider(_local6);
                    if (SecurityUtil.hasMutualTrustBetweenParentAndChild(_local7)){
                        _local6.dispatchEvent(_local2);
                        if (_local2.data == true){
                            return (_local6);
                        };
                        _local2.data = _arg1;
                    };
                    _local5++;
                };
            };
            return (null);
        }
        private function deactivateRequestHandler(_arg1:Event):void{
            var _local5:PlaceholderData;
            var _local6:RemotePopUp;
            var _local7:SystemManagerProxy;
            var _local8:IFocusManagerContainer;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            var _local3:Object = _local2.data;
            var _local4:String;
            if ((_local2.data is String)){
                _local5 = idToPlaceholder[_local2.data];
                _local3 = _local5.data;
                _local4 = _local5.id;
                if (_local4 == null){
                    _local6 = findRemotePopUp(_local3, _local5.bridge);
                    if (_local6){
                        deactivateRemotePopUp(_local6);
                        return;
                    };
                };
            };
            if ((_local3 is SystemManagerProxy)){
                _local7 = SystemManagerProxy(_local3);
                _local8 = findFocusManagerContainer(_local7);
                if (((_local7) && (_local8))){
                    _local7.deactivateByProxy(_local8);
                };
            } else {
                if ((_local3 is IFocusManagerContainer)){
                    IFocusManagerContainer(_local3).focusManager.deactivate();
                } else {
                    if ((_local3 is IEventDispatcher)){
                        _local2.data = _local4;
                        _local2.requestor = IEventDispatcher(_local3);
                        IEventDispatcher(_local3).dispatchEvent(_local2);
                        return;
                    };
                    throw (new Error());
                };
            };
        }
        private function installCompiledResourceBundles():void{
            var _local1:Object = this.info();
            var _local2:ApplicationDomain = ((((!(topLevel)) && ((parent is Loader)))) ? Loader(parent).contentLoaderInfo.applicationDomain : _local1["currentDomain"]);
            var _local3:Array = _local1["compiledLocales"];
            var _local4:Array = _local1["compiledResourceBundleNames"];
            var _local5:IResourceManager = ResourceManager.getInstance();
            _local5.installCompiledResourceBundles(_local2, _local3, _local4);
            if (!_local5.localeChain){
                _local5.initializeLocaleChain(_local3);
            };
        }
        private function deactivateForm(_arg1:Object):void{
            if (form){
                if ((((form == _arg1)) && ((forms.length > 1)))){
                    if (isRemotePopUp(form)){
                        deactivateRemotePopUp(form);
                    } else {
                        form.focusManager.deactivate();
                    };
                    form = findLastActiveForm(_arg1);
                    if (form){
                        if (isRemotePopUp(form)){
                            activateRemotePopUp(form);
                        } else {
                            form.focusManager.activate();
                        };
                    };
                };
            };
        }
        private function unloadHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        mx_internal function removingChild(_arg1:DisplayObject):void{
            _arg1.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
        }
        mx_internal function get applicationIndex():int{
            return (_applicationIndex);
        }
        mx_internal function set toolTipIndex(_arg1:int):void{
            var _local2:int = (_arg1 - _toolTipIndex);
            _toolTipIndex = _arg1;
            cursorIndex = (cursorIndex + _local2);
        }
        private function hasSWFBridges():Boolean{
            if (swfBridgeGroup){
                return (true);
            };
            return (false);
        }
        private function updateLastActiveForm():void{
            var _local1:int = forms.length;
            if (_local1 < 2){
                return;
            };
            var _local2 = -1;
            var _local3:int;
            while (_local3 < _local1) {
                if (areFormsEqual(form, forms[_local3])){
                    _local2 = _local3;
                    break;
                };
                _local3++;
            };
            if (_local2 >= 0){
                forms.splice(_local2, 1);
                forms.push(form);
            } else {
                throw (new Error());
            };
        }
        public function get cursorChildren():IChildList{
            if (!topLevel){
                return (_topLevelSystemManager.cursorChildren);
            };
            if (!_cursorChildren){
                _cursorChildren = new SystemChildrenList(this, new QName(mx_internal, "toolTipIndex"), new QName(mx_internal, "cursorIndex"));
            };
            return (_cursorChildren);
        }
        private function sandboxMouseListener(_arg1:Event):void{
            if ((_arg1 is SandboxMouseEvent)){
                return;
            };
            var _local2:Event = SandboxMouseEvent.marshal(_arg1);
            dispatchEventFromSWFBridges(_local2, (_arg1.target as IEventDispatcher));
            var _local3:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            _local3.name = "sameSandbox";
            _local3.value = _arg1;
            getSandboxRoot().dispatchEvent(_local3);
            if (!_local3.value){
                dispatchEvent(_local2);
            };
        }
        public function get preloaderBackgroundImage():Object{
            return (info()["backgroundImage"]);
        }
        public function set numModalWindows(_arg1:int):void{
            _numModalWindows = _arg1;
        }
        public function get preloaderBackgroundAlpha():Number{
            return (info()["backgroundAlpha"]);
        }
        mx_internal function rawChildren_getChildByName(_arg1:String):DisplayObject{
            return (super.getChildByName(_arg1));
        }
        private function dispatchInvalidateRequest():void{
            var _local1:IEventDispatcher = swfBridgeGroup.parentBridge;
            var _local2:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.INVALIDATE_REQUEST, false, false, _local1, (InvalidateRequestData.SIZE | InvalidateRequestData.DISPLAY_LIST));
            _local1.dispatchEvent(_local2);
        }
        public function get preloaderBackgroundColor():uint{
            var _local1:* = info()["backgroundColor"];
            if (_local1 == undefined){
                return (StyleManager.NOT_A_COLOR);
            };
            return (StyleManager.getColorName(_local1));
        }
        public function getVisibleApplicationRect(_arg1:Rectangle=null):Rectangle{
            var _local2:Rectangle;
            var _local3:Point;
            var _local4:IEventDispatcher;
            var _local5:SWFBridgeRequest;
            if (!_arg1){
                _arg1 = getBounds(DisplayObject(this));
                _local2 = screen;
                _local3 = new Point(Math.max(0, _arg1.x), Math.max(0, _arg1.y));
                _local3 = localToGlobal(_local3);
                _arg1.x = _local3.x;
                _arg1.y = _local3.y;
                _arg1.width = _local2.width;
                _arg1.height = _local2.height;
            };
            if (useSWFBridge()){
                _local4 = swfBridgeGroup.parentBridge;
                _local5 = new SWFBridgeRequest(SWFBridgeRequest.GET_VISIBLE_RECT_REQUEST, false, false, _local4, _arg1);
                _local4.dispatchEvent(_local5);
                _arg1 = Rectangle(_local5.data);
            };
            return (_arg1);
        }
        public function get topLevelSystemManager():ISystemManager{
            if (topLevel){
                return (this);
            };
            return (_topLevelSystemManager);
        }
        private function appCreationCompleteHandler(_arg1:FlexEvent):void{
            var _local2:DisplayObjectContainer;
            if (((!(topLevel)) && (parent))){
                _local2 = parent.parent;
                while (_local2) {
                    if ((_local2 is IInvalidating)){
                        IInvalidating(_local2).invalidateSize();
                        IInvalidating(_local2).invalidateDisplayList();
                        return;
                    };
                    _local2 = _local2.parent;
                };
            };
            if (((topLevel) && (useSWFBridge()))){
                dispatchInvalidateRequest();
            };
        }
        public function addChildToSandboxRoot(_arg1:String, _arg2:DisplayObject):void{
            var _local3:InterManagerRequest;
            if (getSandboxRoot() == this){
                this[_arg1].addChild(_arg2);
            } else {
                addingChild(_arg2);
                _local3 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
                _local3.name = (_arg1 + ".addChild");
                _local3.value = _arg2;
                getSandboxRoot().dispatchEvent(_local3);
                childAdded(_arg2);
            };
        }
        private function dispatchDeactivatedWindowEvent(_arg1:DisplayObject):void{
            var _local3:DisplayObject;
            var _local4:Boolean;
            var _local5:SWFBridgeEvent;
            var _local2:IEventDispatcher = ((swfBridgeGroup) ? swfBridgeGroup.parentBridge : null);
            if (_local2){
                _local3 = getSandboxRoot();
                _local4 = !((_local3 == this));
                _local5 = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE, false, false, {
                    notifier:_local2,
                    window:((_local4) ? _arg1 : NameUtil.displayObjectToString(_arg1))
                });
                if (_local4){
                    _local3.dispatchEvent(_local5);
                } else {
                    _local2.dispatchEvent(_local5);
                };
            };
        }
        private function isBridgeChildHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:Object = Object(_arg1);
            _local2.data = ((_local2.data) && (rawChildren.contains((_local2.data as DisplayObject))));
        }
        public function get measuredHeight():Number{
            return (((topLevelWindow) ? topLevelWindow.getExplicitOrMeasuredHeight() : loaderInfo.height));
        }
        private function activateRequestHandler(_arg1:Event):void{
            var _local5:PlaceholderData;
            var _local6:RemotePopUp;
            var _local7:SystemManagerProxy;
            var _local8:IFocusManagerContainer;
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            var _local3:Object = _local2.data;
            var _local4:String;
            if ((_local2.data is String)){
                _local5 = idToPlaceholder[_local2.data];
                _local3 = _local5.data;
                _local4 = _local5.id;
                if (_local4 == null){
                    _local6 = findRemotePopUp(_local3, _local5.bridge);
                    if (_local6){
                        activateRemotePopUp(_local6);
                        return;
                    };
                };
            };
            if ((_local3 is SystemManagerProxy)){
                _local7 = SystemManagerProxy(_local3);
                _local8 = findFocusManagerContainer(_local7);
                if (((_local7) && (_local8))){
                    _local7.activateByProxy(_local8);
                };
            } else {
                if ((_local3 is IFocusManagerContainer)){
                    IFocusManagerContainer(_local3).focusManager.activate();
                } else {
                    if ((_local3 is IEventDispatcher)){
                        _local2.data = _local4;
                        _local2.requestor = IEventDispatcher(_local3);
                        IEventDispatcher(_local3).dispatchEvent(_local2);
                    } else {
                        throw (new Error());
                    };
                };
            };
        }
        mx_internal function rawChildren_addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            addingChild(_arg1);
            super.addChildAt(_arg1, _arg2);
            childAdded(_arg1);
            return (_arg1);
        }
        mx_internal function initialize():void{
            var _local6:int;
            var _local7:int;
            var _local9:EmbeddedFontRegistry;
            var _local13:Class;
            var _local14:Object;
            var _local15:RSLItem;
            if (isStageRoot){
                _width = stage.stageWidth;
                _height = stage.stageHeight;
            } else {
                _width = loaderInfo.width;
                _height = loaderInfo.height;
            };
            preloader = new Preloader();
            preloader.addEventListener(FlexEvent.INIT_PROGRESS, preloader_initProgressHandler);
            preloader.addEventListener(FlexEvent.PRELOADER_DONE, preloader_preloaderDoneHandler);
            if (!_popUpChildren){
                _popUpChildren = new SystemChildrenList(this, new QName(mx_internal, "noTopMostIndex"), new QName(mx_internal, "topMostIndex"));
            };
            _popUpChildren.addChild(preloader);
            var _local1:Array = info()["rsls"];
            var _local2:Array = info()["cdRsls"];
            var _local3:Boolean;
            if (info()["usePreloader"] != undefined){
                _local3 = info()["usePreloader"];
            };
            var _local4:Class = (info()["preloader"] as Class);
            if (((_local3) && (!(_local4)))){
                _local4 = DownloadProgressBar;
            };
            var _local5:Array = [];
            if (((_local2) && ((_local2.length > 0)))){
                _local13 = Class(getDefinitionByName("mx.core::CrossDomainRSLItem"));
                _local6 = _local2.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local14 = new _local13(_local2[_local7]["rsls"], _local2[_local7]["policyFiles"], _local2[_local7]["digests"], _local2[_local7]["types"], _local2[_local7]["isSigned"], this.loaderInfo.url);
                    _local5.push(_local14);
                    _local7++;
                };
            };
            if (((!((_local1 == null))) && ((_local1.length > 0)))){
                _local6 = _local1.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local15 = new RSLItem(_local1[_local7].url, this.loaderInfo.url);
                    _local5.push(_local15);
                    _local7++;
                };
            };
            Singleton.registerClass("mx.resources::IResourceManager", Class(getDefinitionByName("mx.resources::ResourceManagerImpl")));
            var _local8:IResourceManager = ResourceManager.getInstance();
            Singleton.registerClass("mx.core::IEmbeddedFontRegistry", Class(getDefinitionByName("mx.core::EmbeddedFontRegistry")));
            Singleton.registerClass("mx.styles::IStyleManager", Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
            Singleton.registerClass("mx.styles::IStyleManager2", Class(getDefinitionByName("mx.styles::StyleManagerImpl")));
            var _local10:String = loaderInfo.parameters["localeChain"];
            if (((!((_local10 == null))) && (!((_local10 == ""))))){
                _local8.localeChain = _local10.split(",");
            };
            var _local11:String = loaderInfo.parameters["resourceModuleURLs"];
            var _local12:Array = ((_local11) ? _local11.split(",") : null);
            preloader.initialize(_local3, _local4, preloaderBackgroundColor, preloaderBackgroundAlpha, preloaderBackgroundImage, preloaderBackgroundSize, ((isStageRoot) ? stage.stageWidth : loaderInfo.width), ((isStageRoot) ? stage.stageHeight : loaderInfo.height), null, null, _local5, _local12);
        }
        public function useSWFBridge():Boolean{
            if (isStageRoot){
                return (false);
            };
            if (((!(topLevel)) && (topLevelSystemManager))){
                return (topLevelSystemManager.useSWFBridge());
            };
            if (((topLevel) && (!((getSandboxRoot() == this))))){
                return (true);
            };
            if (getSandboxRoot() == this){
                try {
                    root.loaderInfo.parentAllowsChild;
                    if (((parentAllowsChild) && (childAllowsParent))){
                        try {
                            if (!parent.dispatchEvent(new Event("mx.managers.SystemManager.isStageRoot", false, true))){
                                return (true);
                            };
                        } catch(e:Error) {
                        };
                    } else {
                        return (true);
                    };
                } catch(e1:Error) {
                    return (false);
                };
            };
            return (false);
        }
        mx_internal function childRemoved(_arg1:DisplayObject):void{
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).parentChanged(null);
            };
        }
        final mx_internal function $removeChildAt(_arg1:int):DisplayObject{
            return (super.removeChildAt(_arg1));
        }
        private function canActivatePopUp(_arg1:Object):Boolean{
            var _local2:RemotePopUp;
            var _local3:SWFBridgeRequest;
            if (isRemotePopUp(_arg1)){
                _local2 = RemotePopUp(_arg1);
                _local3 = new SWFBridgeRequest(SWFBridgeRequest.CAN_ACTIVATE_POP_UP_REQUEST, false, false, null, _local2.window);
                IEventDispatcher(_local2.bridge).dispatchEvent(_local3);
                return (_local3.data);
            };
            if (canActivateLocalComponent(_arg1)){
                return (true);
            };
            return (false);
        }
        mx_internal function get noTopMostIndex():int{
            return (_noTopMostIndex);
        }
        override public function get numChildren():int{
            return ((noTopMostIndex - applicationIndex));
        }
        private function canActivateLocalComponent(_arg1:Object):Boolean{
            if ((((((((_arg1 is Sprite)) && ((_arg1 is IUIComponent)))) && (Sprite(_arg1).visible))) && (IUIComponent(_arg1).enabled))){
                return (true);
            };
            return (false);
        }
        private function preloader_preloaderDoneHandler(_arg1:Event):void{
            var _local2:IUIComponent = topLevelWindow;
            preloader.removeEventListener(FlexEvent.PRELOADER_DONE, preloader_preloaderDoneHandler);
            _popUpChildren.removeChild(preloader);
            preloader = null;
            mouseCatcher = new FlexSprite();
            mouseCatcher.name = "mouseCatcher";
            noTopMostIndex++;
            super.addChildAt(mouseCatcher, 0);
            resizeMouseCatcher();
            if (!topLevel){
                mouseCatcher.visible = false;
                mask = mouseCatcher;
            };
            noTopMostIndex++;
            super.addChildAt(DisplayObject(_local2), 1);
            _local2.dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
            dispatchEvent(new FlexEvent(FlexEvent.APPLICATION_COMPLETE));
        }
        private function initializeTopLevelWindow(_arg1:Event):void{
            var _local2:IUIComponent;
            var _local3:DisplayObjectContainer;
            var _local4:ISystemManager;
            var _local5:DisplayObject;
            initialized = true;
            if (((!(parent)) && (parentAllowsChild))){
                return;
            };
            if (!topLevel){
                _local3 = parent.parent;
                if (!_local3){
                    return;
                };
                while (_local3) {
                    if ((_local3 is IUIComponent)){
                        _local4 = IUIComponent(_local3).systemManager;
                        if (((_local4) && (!(_local4.isTopLevel())))){
                            _local4 = _local4.topLevelSystemManager;
                        };
                        _topLevelSystemManager = _local4;
                        break;
                    };
                    _local3 = _local3.parent;
                };
            };
            if (((isTopLevelRoot()) || ((getSandboxRoot() == this)))){
                addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, true);
            };
            if (((isTopLevelRoot()) && (stage))){
                stage.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
            } else {
                if (((topLevel) && (stage))){
                    _local5 = getSandboxRoot();
                    if (_local5 != this){
                        _local5.addEventListener(Event.RESIZE, Stage_resizeHandler, false, 0, true);
                    };
                };
            };
            _local2 = (topLevelWindow = IUIComponent(create()));
            document = _local2;
            if (document){
                IEventDispatcher(_local2).addEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
                if (!LoaderConfig._url){
                    LoaderConfig._url = loaderInfo.url;
                    LoaderConfig._parameters = loaderInfo.parameters;
                };
                if (((isStageRoot) && (stage))){
                    _width = stage.stageWidth;
                    _height = stage.stageHeight;
                    IFlexDisplayObject(_local2).setActualSize(_width, _height);
                } else {
                    IFlexDisplayObject(_local2).setActualSize(loaderInfo.width, loaderInfo.height);
                };
                if (preloader){
                    preloader.registerApplication(_local2);
                };
                addingChild(DisplayObject(_local2));
                childAdded(DisplayObject(_local2));
            } else {
                document = this;
            };
        }
        final mx_internal function $addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            return (super.addChildAt(_arg1, _arg2));
        }
        mx_internal function dispatchActivatedWindowEvent(_arg1:DisplayObject):void{
            var _local3:DisplayObject;
            var _local4:Boolean;
            var _local5:SWFBridgeEvent;
            var _local2:IEventDispatcher = ((swfBridgeGroup) ? swfBridgeGroup.parentBridge : null);
            if (_local2){
                _local3 = getSandboxRoot();
                _local4 = !((_local3 == this));
                _local5 = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE, false, false, {
                    notifier:_local2,
                    window:((_local4) ? _arg1 : NameUtil.displayObjectToString(_arg1))
                });
                if (_local4){
                    _local3.dispatchEvent(_local5);
                } else {
                    _local2.dispatchEvent(_local5);
                };
            };
        }
        private function nextFrameTimerHandler(_arg1:TimerEvent):void{
            if ((currentFrame + 1) <= framesLoaded){
                nextFrame();
                nextFrameTimer.removeEventListener(TimerEvent.TIMER, nextFrameTimerHandler);
                nextFrameTimer.reset();
            };
        }
        public function get numModalWindows():int{
            return (_numModalWindows);
        }
        private function areFormsEqual(_arg1:Object, _arg2:Object):Boolean{
            if (_arg1 == _arg2){
                return (true);
            };
            if ((((_arg1 is RemotePopUp)) && ((_arg2 is RemotePopUp)))){
                return (areRemotePopUpsEqual(_arg1, _arg2));
            };
            return (false);
        }
        public function isTopLevelWindow(_arg1:DisplayObject):Boolean{
            return ((((_arg1 is IUIComponent)) && ((IUIComponent(_arg1) == topLevelWindow))));
        }
        private function removePlaceholderId(_arg1:String):void{
            delete idToPlaceholder[_arg1];
        }
        override public function get width():Number{
            return (_width);
        }
        private function dispatchActivatedApplicationEvent():void{
            var _local2:SWFBridgeEvent;
            var _local1:IEventDispatcher = ((swfBridgeGroup) ? swfBridgeGroup.parentBridge : null);
            if (_local1){
                _local2 = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_ACTIVATE, false, false);
                _local1.dispatchEvent(_local2);
            };
        }
        private function otherSystemManagerMouseListener(_arg1:SandboxMouseEvent):void{
            if (dispatchingToSystemManagers){
                return;
            };
            dispatchEventFromSWFBridges(_arg1);
            var _local2:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST);
            _local2.name = "sameSandbox";
            _local2.value = _arg1;
            getSandboxRoot().dispatchEvent(_local2);
            if (!_local2.value){
                dispatchEvent(_arg1);
            };
        }
        private function hideMouseCursorRequestHandler(_arg1:Event):void{
            var _local3:IEventDispatcher;
            if (((!(isTopLevelRoot())) && ((_arg1 is SWFBridgeRequest)))){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if (!isTopLevelRoot()){
                _local3 = swfBridgeGroup.parentBridge;
                _local2.requestor = _local3;
                _local3.dispatchEvent(_local2);
            } else {
                if (eventProxy){
                    SystemManagerGlobals.showMouseCursor = false;
                };
            };
        }
        private function getTopLevelSystemManager(_arg1:DisplayObject):ISystemManager{
            var _local3:ISystemManager;
            var _local2:DisplayObjectContainer = DisplayObjectContainer(_arg1.root);
            if (((((!(_local2)) || ((_local2 is Stage)))) && ((_arg1 is IUIComponent)))){
                _local2 = DisplayObjectContainer(IUIComponent(_arg1).systemManager);
            };
            if ((_local2 is ISystemManager)){
                _local3 = ISystemManager(_local2);
                if (!_local3.isTopLevel()){
                    _local3 = _local3.topLevelSystemManager;
                };
            };
            return (_local3);
        }
        public function isDisplayObjectInABridgedApplication(_arg1:DisplayObject):Boolean{
            return (!((getSWFBridgeOfDisplayObject(_arg1) == null)));
        }
        public function move(_arg1:Number, _arg2:Number):void{
        }
        public function set explicitWidth(_arg1:Number):void{
            _explicitWidth = _arg1;
        }
        public function get parentAllowsChild():Boolean{
            try {
                return (loaderInfo.parentAllowsChild);
            } catch(error:Error) {
            };
            return (false);
        }
        private function preloader_initProgressHandler(_arg1:Event):void{
            preloader.removeEventListener(FlexEvent.INIT_PROGRESS, preloader_initProgressHandler);
            deferredNextFrame();
        }
        public function get explicitWidth():Number{
            return (_explicitWidth);
        }
        private function activateFormSandboxEventHandler(_arg1:Event):void{
            var _local2:SWFBridgeEvent = SWFBridgeEvent.marshal(_arg1);
            if (!forwardFormEvent(_local2)){
                activateForm(new RemotePopUp(_local2.data.window, _local2.data.notifier));
            };
        }
        mx_internal function rawChildren_addChild(_arg1:DisplayObject):DisplayObject{
            addingChild(_arg1);
            super.addChild(_arg1);
            childAdded(_arg1);
            return (_arg1);
        }

    }
}//package mx.managers 
