package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.managers.*;
    import mx.automation.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.states.*;
    import mx.effects.*;
    import mx.graphics.*;
    import mx.binding.*;
    import flash.utils.*;
    import flash.system.*;
    import mx.utils.*;
    import mx.validators.*;
    import mx.modules.*;

    public class UIComponent extends FlexSprite implements IAutomationObject, IChildList, IDeferredInstantiationUIComponent, IFlexDisplayObject, IFlexModule, IInvalidating, ILayoutManagerClient, IPropertyChangeNotifier, IRepeaterClient, ISimpleStyleClient, IStyleClient, IToolTipManagerClient, IUIComponent, IValidatorListener, IStateClient, IConstraintClient {

        public static const DEFAULT_MEASURED_WIDTH:Number = 160;
        public static const DEFAULT_MAX_WIDTH:Number = 10000;
        public static const DEFAULT_MEASURED_MIN_HEIGHT:Number = 22;
        public static const DEFAULT_MAX_HEIGHT:Number = 10000;
        public static const DEFAULT_MEASURED_HEIGHT:Number = 22;
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const DEFAULT_MEASURED_MIN_WIDTH:Number = 40;

        mx_internal static var dispatchEventHook:Function;
        private static var fakeMouseY:QName = new QName(mx_internal, "_mouseY");
        mx_internal static var createAccessibilityImplementation:Function;
        mx_internal static var STYLE_UNINITIALIZED:Object = {};
        private static var fakeMouseX:QName = new QName(mx_internal, "_mouseX");
        private static var _embeddedFontRegistry:IEmbeddedFontRegistry;

        private var cachedEmbeddedFont:EmbeddedFont = null;
        private var errorStringChanged:Boolean = false;
        mx_internal var overlay:UIComponent;
        mx_internal var automaticRadioButtonGroups:Object;
        private var _currentState:String;
        private var _isPopUp:Boolean;
        private var _repeaters:Array;
        private var _systemManager:ISystemManager;
        private var _measuredWidth:Number = 0;
        private var methodQueue:Array;
        mx_internal var _width:Number;
        private var _tweeningProperties:Array;
        private var _validationSubField:String;
        private var _endingEffectInstances:Array;
        mx_internal var saveBorderColor:Boolean = true;
        mx_internal var overlayColor:uint;
        mx_internal var overlayReferenceCount:int = 0;
        private var hasFontContextBeenSaved:Boolean = false;
        private var _repeaterIndices:Array;
        private var oldExplicitWidth:Number;
        mx_internal var _descriptor:UIComponentDescriptor;
        private var _initialized:Boolean = false;
        private var _focusEnabled:Boolean = true;
        private var cacheAsBitmapCount:int = 0;
        private var requestedCurrentState:String;
        private var listeningForRender:Boolean = false;
        mx_internal var invalidateDisplayListFlag:Boolean = false;
        private var oldScaleX:Number = 1;
        private var oldScaleY:Number = 1;
        mx_internal var _explicitMaxHeight:Number;
        mx_internal var invalidatePropertiesFlag:Boolean = false;
        private var hasFocusRect:Boolean = false;
        mx_internal var invalidateSizeFlag:Boolean = false;
        private var _scaleX:Number = 1;
        private var _scaleY:Number = 1;
        private var _styleDeclaration:CSSStyleDeclaration;
        private var _resourceManager:IResourceManager;
        mx_internal var _affectedProperties:Object;
        mx_internal var _documentDescriptor:UIComponentDescriptor;
        private var _processedDescriptors:Boolean = false;
        mx_internal var origBorderColor:Number;
        private var _focusManager:IFocusManager;
        private var _cachePolicy:String = "auto";
        private var _measuredHeight:Number = 0;
        private var _id:String;
        private var _owner:DisplayObjectContainer;
        public var transitions:Array;
        mx_internal var _parent:DisplayObjectContainer;
        private var _measuredMinWidth:Number = 0;
        private var oldMinWidth:Number;
        private var _explicitWidth:Number;
        private var _enabled:Boolean = false;
        public var states:Array;
        private var _mouseFocusEnabled:Boolean = true;
        private var oldHeight:Number = 0;
        private var _currentStateChanged:Boolean;
        private var cachedTextFormat:UITextFormat;
        mx_internal var _height:Number;
        private var _automationDelegate:IAutomationObject;
        private var _percentWidth:Number;
        private var _automationName:String = null;
        private var _isEffectStarted:Boolean = false;
        private var _styleName:Object;
        private var lastUnscaledWidth:Number;
        mx_internal var _document:Object;
        mx_internal var _errorString:String = "";
        private var oldExplicitHeight:Number;
        private var _nestLevel:int = 0;
        private var _systemManagerDirty:Boolean = false;
        private var _explicitHeight:Number;
        mx_internal var _toolTip:String;
        private var _filters:Array;
        private var _focusPane:Sprite;
        private var playStateTransition:Boolean = true;
        private var _nonInheritingStyles:Object;
        private var _showInAutomationHierarchy:Boolean = true;
        private var _moduleFactory:IFlexModuleFactory;
        private var preventDrawFocus:Boolean = false;
        private var oldX:Number = 0;
        private var oldY:Number = 0;
        private var _instanceIndices:Array;
        private var _visible:Boolean = true;
        private var _inheritingStyles:Object;
        private var _includeInLayout:Boolean = true;
        mx_internal var _effectsStarted:Array;
        mx_internal var _explicitMinWidth:Number;
        private var lastUnscaledHeight:Number;
        mx_internal var _explicitMaxWidth:Number;
        private var _measuredMinHeight:Number = 0;
        private var _uid:String;
        private var _currentTransitionEffect:IEffect;
        private var _updateCompletePendingFlag:Boolean = false;
        private var oldMinHeight:Number;
        private var _flexContextMenu:IFlexContextMenu;
        mx_internal var _explicitMinHeight:Number;
        private var _percentHeight:Number;
        private var oldEmbeddedFontContext:IFlexModuleFactory = null;
        private var oldWidth:Number = 0;

        public function UIComponent(){
            methodQueue = [];
            _resourceManager = ResourceManager.getInstance();
            _inheritingStyles = UIComponent.STYLE_UNINITIALIZED;
            _nonInheritingStyles = UIComponent.STYLE_UNINITIALIZED;
            states = [];
            transitions = [];
            _effectsStarted = [];
            _affectedProperties = {};
            _endingEffectInstances = [];
            super();
            focusRect = false;
            tabEnabled = (this is IFocusManagerComponent);
            tabChildren = false;
            enabled = true;
            $visible = false;
            addEventListener(Event.ADDED, addedHandler);
            addEventListener(Event.REMOVED, removedHandler);
            if ((this is IFocusManagerComponent)){
                addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
                addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
                addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
            };
            resourcesChanged();
            resourceManager.addEventListener(Event.CHANGE, resourceManager_changeHandler, false, 0, true);
            _width = super.width;
            _height = super.height;
        }
        private static function get embeddedFontRegistry():IEmbeddedFontRegistry{
            if (!_embeddedFontRegistry){
                _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            };
            return (_embeddedFontRegistry);
        }
        public static function resumeBackgroundProcessing():void{
            var _local1:ISystemManager;
            if (UIComponentGlobals.callLaterSuspendCount > 0){
                UIComponentGlobals.callLaterSuspendCount--;
                if (UIComponentGlobals.callLaterSuspendCount == 0){
                    _local1 = SystemManagerGlobals.topLevelSystemManagers[0];
                    if (((_local1) && (_local1.stage))){
                        _local1.stage.invalidate();
                    };
                };
            };
        }
        public static function suspendBackgroundProcessing():void{
            UIComponentGlobals.callLaterSuspendCount++;
        }

        override public function get filters():Array{
            return (((_filters) ? _filters : super.filters));
        }
        public function get toolTip():String{
            return (_toolTip);
        }
        private function transition_effectEndHandler(_arg1:EffectEvent):void{
            _currentTransitionEffect = null;
        }
        public function get nestLevel():int{
            return (_nestLevel);
        }
        protected function adjustFocusRect(_arg1:DisplayObject=null):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:Point;
            var _local7:Number;
            if (!_arg1){
                _arg1 = this;
            };
            if (((isNaN(_arg1.width)) || (isNaN(_arg1.height)))){
                return;
            };
            var _local2:IFocusManager = focusManager;
            if (!_local2){
                return;
            };
            var _local3:IFlexDisplayObject = IFlexDisplayObject(getFocusObject());
            if (_local3){
                if (((errorString) && (!((errorString == ""))))){
                    _local4 = getStyle("errorColor");
                } else {
                    _local4 = getStyle("themeColor");
                };
                _local5 = getStyle("focusThickness");
                if ((_local3 is IStyleClient)){
                    IStyleClient(_local3).setStyle("focusColor", _local4);
                };
                _local3.setActualSize((_arg1.width + (2 * _local5)), (_arg1.height + (2 * _local5)));
                if (rotation){
                    _local7 = ((rotation * Math.PI) / 180);
                    _local6 = new Point((_arg1.x - (_local5 * (Math.cos(_local7) - Math.sin(_local7)))), (_arg1.y - (_local5 * (Math.cos(_local7) + Math.sin(_local7)))));
                    DisplayObject(_local3).rotation = rotation;
                } else {
                    _local6 = new Point((_arg1.x - _local5), (_arg1.y - _local5));
                };
                if (_arg1.parent == this){
                    _local6.x = (_local6.x + x);
                    _local6.y = (_local6.y + y);
                };
                _local6 = parent.localToGlobal(_local6);
                _local6 = parent.globalToLocal(_local6);
                _local3.move(_local6.x, _local6.y);
                if ((_local3 is IInvalidating)){
                    IInvalidating(_local3).validateNow();
                } else {
                    if ((_local3 is IProgrammaticSkin)){
                        IProgrammaticSkin(_local3).validateNow();
                    };
                };
            };
        }
        mx_internal function setUnscaledWidth(_arg1:Number):void{
            var _local2:Number = (_arg1 * Math.abs(oldScaleX));
            if (_explicitWidth == _local2){
                return;
            };
            if (!isNaN(_local2)){
                _percentWidth = NaN;
            };
            _explicitWidth = _local2;
            invalidateSize();
            var _local3:IInvalidating = (parent as IInvalidating);
            if (((_local3) && (includeInLayout))){
                _local3.invalidateSize();
                _local3.invalidateDisplayList();
            };
        }
        private function isOnDisplayList():Boolean{
            var p:* = null;
            try {
                p = ((_parent) ? _parent : super.parent);
            } catch(e:SecurityError) {
                return (true);
            };
            return (((p) ? true : false));
        }
        public function set nestLevel(_arg1:int):void{
            var _local2:IChildList;
            var _local3:int;
            var _local4:int;
            var _local5:ILayoutManagerClient;
            var _local6:IUITextField;
            if ((((_arg1 > 1)) && (!((_nestLevel == _arg1))))){
                _nestLevel = _arg1;
                updateCallbacks();
                _local2 = (((this is IRawChildrenContainer)) ? IRawChildrenContainer(this).rawChildren : IChildList(this));
                _local3 = _local2.numChildren;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local5 = (_local2.getChildAt(_local4) as ILayoutManagerClient);
                    if (_local5){
                        _local5.nestLevel = (_arg1 + 1);
                    } else {
                        _local6 = (_local2.getChildAt(_local4) as IUITextField);
                        if (_local6){
                            _local6.nestLevel = (_arg1 + 1);
                        };
                    };
                    _local4++;
                };
            };
        }
        public function getExplicitOrMeasuredHeight():Number{
            return (((isNaN(explicitHeight)) ? measuredHeight : explicitHeight));
        }
        private function callLaterDispatcher(_arg1:Event):void{
            var callLaterErrorEvent:* = null;
            var event:* = _arg1;
            UIComponentGlobals.callLaterDispatcherCount++;
            if (!UIComponentGlobals.catchCallLaterExceptions){
                callLaterDispatcher2(event);
            } else {
                try {
                    callLaterDispatcher2(event);
                } catch(e:Error) {
                    callLaterErrorEvent = new DynamicEvent("callLaterError");
                    callLaterErrorEvent.error = e;
                    systemManager.dispatchEvent(callLaterErrorEvent);
                };
            };
            UIComponentGlobals.callLaterDispatcherCount--;
        }
        public function getStyle(_arg1:String){
            return (((StyleManager.inheritingStyles[_arg1]) ? _inheritingStyles[_arg1] : _nonInheritingStyles[_arg1]));
        }
        final mx_internal function get $width():Number{
            return (super.width);
        }
        public function get className():String{
            var _local1:String = getQualifiedClassName(this);
            var _local2:int = _local1.indexOf("::");
            if (_local2 != -1){
                _local1 = _local1.substr((_local2 + 2));
            };
            return (_local1);
        }
        public function verticalGradientMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Matrix{
            UIComponentGlobals.tempMatrix.createGradientBox(_arg3, _arg4, (Math.PI / 2), _arg1, _arg2);
            return (UIComponentGlobals.tempMatrix);
        }
        public function setCurrentState(_arg1:String, _arg2:Boolean=true):void{
            if (((!((_arg1 == currentState))) && (!(((isBaseState(_arg1)) && (isBaseState(currentState))))))){
                requestedCurrentState = _arg1;
                playStateTransition = _arg2;
                if (initialized){
                    commitCurrentState();
                } else {
                    _currentStateChanged = true;
                    addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
                };
            };
        }
        private function getBaseStates(_arg1:State):Array{
            var _local2:Array = [];
            while (((_arg1) && (_arg1.basedOn))) {
                _local2.push(_arg1.basedOn);
                _arg1 = getState(_arg1.basedOn);
            };
            return (_local2);
        }
        public function set minHeight(_arg1:Number):void{
            if (explicitMinHeight == _arg1){
                return;
            };
            explicitMinHeight = _arg1;
        }
        protected function isOurFocus(_arg1:DisplayObject):Boolean{
            return ((_arg1 == this));
        }
        public function get errorString():String{
            return (_errorString);
        }
        mx_internal function setUnscaledHeight(_arg1:Number):void{
            var _local2:Number = (_arg1 * Math.abs(oldScaleY));
            if (_explicitHeight == _local2){
                return;
            };
            if (!isNaN(_local2)){
                _percentHeight = NaN;
            };
            _explicitHeight = _local2;
            invalidateSize();
            var _local3:IInvalidating = (parent as IInvalidating);
            if (((_local3) && (includeInLayout))){
                _local3.invalidateSize();
                _local3.invalidateDisplayList();
            };
        }
        public function get automationName():String{
            if (_automationName){
                return (_automationName);
            };
            if (automationDelegate){
                return (automationDelegate.automationName);
            };
            return ("");
        }
        final mx_internal function set $width(_arg1:Number):void{
            super.width = _arg1;
        }
        public function getVisibleRect(_arg1:DisplayObject=null):Rectangle{
            if (!_arg1){
                _arg1 = DisplayObject(systemManager);
            };
            var _local2:Point = new Point(x, y);
            var _local3:DisplayObject = (($parent) ? $parent : parent);
            _local2 = _local3.localToGlobal(_local2);
            var _local4:Rectangle = new Rectangle(_local2.x, _local2.y, width, height);
            var _local5:DisplayObject = this;
            var _local6:Rectangle = new Rectangle();
            do  {
                if ((_local5 is UIComponent)){
                    if (UIComponent(_local5).$parent){
                        _local5 = UIComponent(_local5).$parent;
                    } else {
                        _local5 = UIComponent(_local5).parent;
                    };
                } else {
                    _local5 = _local5.parent;
                };
                if (((_local5) && (_local5.scrollRect))){
                    _local6 = _local5.scrollRect.clone();
                    _local2 = _local5.localToGlobal(_local6.topLeft);
                    _local6.x = _local2.x;
                    _local6.y = _local2.y;
                    _local4 = _local4.intersection(_local6);
                };
            } while (((_local5) && (!((_local5 == _arg1)))));
            return (_local4);
        }
        public function invalidateDisplayList():void{
            if (!invalidateDisplayListFlag){
                invalidateDisplayListFlag = true;
                if (((isOnDisplayList()) && (UIComponentGlobals.layoutManager))){
                    UIComponentGlobals.layoutManager.invalidateDisplayList(this);
                };
            };
        }
        mx_internal function initThemeColor():Boolean{
            var _local2:Object;
            var _local3:Number;
            var _local4:Number;
            var _local5:Object;
            var _local6:Array;
            var _local7:int;
            var _local8:CSSStyleDeclaration;
            var _local1:Object = _styleName;
            if (_styleDeclaration){
                _local2 = _styleDeclaration.getStyle("themeColor");
                _local3 = _styleDeclaration.getStyle("rollOverColor");
                _local4 = _styleDeclaration.getStyle("selectionColor");
            };
            if ((((((_local2 === null)) || (!(StyleManager.isValidStyleValue(_local2))))) && (((_local1) && (!((_local1 is ISimpleStyleClient))))))){
                _local5 = (((_local1 is String)) ? StyleManager.getStyleDeclaration(("." + _local1)) : _local1);
                if (_local5){
                    _local2 = _local5.getStyle("themeColor");
                    _local3 = _local5.getStyle("rollOverColor");
                    _local4 = _local5.getStyle("selectionColor");
                };
            };
            if ((((_local2 === null)) || (!(StyleManager.isValidStyleValue(_local2))))){
                _local6 = getClassStyleDeclarations();
                _local7 = 0;
                while (_local7 < _local6.length) {
                    _local8 = _local6[_local7];
                    if (_local8){
                        _local2 = _local8.getStyle("themeColor");
                        _local3 = _local8.getStyle("rollOverColor");
                        _local4 = _local8.getStyle("selectionColor");
                    };
                    if (((!((_local2 === null))) && (StyleManager.isValidStyleValue(_local2)))){
                        break;
                    };
                    _local7++;
                };
            };
            if (((((((!((_local2 === null))) && (StyleManager.isValidStyleValue(_local2)))) && (isNaN(_local3)))) && (isNaN(_local4)))){
                setThemeColor(_local2);
                return (true);
            };
            return (((((((!((_local2 === null))) && (StyleManager.isValidStyleValue(_local2)))) && (!(isNaN(_local3))))) && (!(isNaN(_local4)))));
        }
        override public function get scaleX():Number{
            return (_scaleX);
        }
        public function get uid():String{
            if (!_uid){
                _uid = toString();
            };
            return (_uid);
        }
        override public function get mouseX():Number{
            if (((((!(root)) || ((root is Stage)))) || ((root[fakeMouseX] === undefined)))){
                return (super.mouseX);
            };
            return (globalToLocal(new Point(root[fakeMouseX], 0)).x);
        }
        override public function stopDrag():void{
            super.stopDrag();
            invalidateProperties();
            dispatchEvent(new Event("xChanged"));
            dispatchEvent(new Event("yChanged"));
        }
        public function get focusPane():Sprite{
            return (_focusPane);
        }
        public function set tweeningProperties(_arg1:Array):void{
            _tweeningProperties = _arg1;
        }
        public function horizontalGradientMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Matrix{
            UIComponentGlobals.tempMatrix.createGradientBox(_arg3, _arg4, 0, _arg1, _arg2);
            return (UIComponentGlobals.tempMatrix);
        }
        public function get isDocument():Boolean{
            return ((document == this));
        }
        public function set validationSubField(_arg1:String):void{
            _validationSubField = _arg1;
        }
        override public function get scaleY():Number{
            return (_scaleY);
        }
        protected function keyDownHandler(_arg1:KeyboardEvent):void{
        }
        protected function createInFontContext(_arg1:Class):Object{
            hasFontContextBeenSaved = true;
            var _local2:String = StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
            var _local3:String = getStyle("fontWeight");
            var _local4:String = getStyle("fontStyle");
            var _local5 = (_local3 == "bold");
            var _local6 = (_local4 == "italic");
            oldEmbeddedFontContext = getFontContext(_local2, _local5, _local6);
            var _local7:Object = createInModuleContext(((oldEmbeddedFontContext) ? oldEmbeddedFontContext : moduleFactory), getQualifiedClassName(_arg1));
            if (_local7 == null){
                _local7 = new (_arg1)();
            };
            return (_local7);
        }
        public function get screen():Rectangle{
            var _local1:ISystemManager = systemManager;
            return (((_local1) ? _local1.screen : null));
        }
        protected function focusInHandler(_arg1:FocusEvent):void{
            var _local2:IFocusManager;
            if (isOurFocus(DisplayObject(_arg1.target))){
                _local2 = focusManager;
                if (((_local2) && (_local2.showFocusIndicator))){
                    drawFocus(true);
                };
                ContainerGlobals.checkFocus(_arg1.relatedObject, this);
            };
        }
        public function hasFontContextChanged():Boolean{
            if (!hasFontContextBeenSaved){
                return (false);
            };
            var _local1:String = StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
            var _local2:String = getStyle("fontWeight");
            var _local3:String = getStyle("fontStyle");
            var _local4 = (_local2 == "bold");
            var _local5 = (_local3 == "italic");
            var _local6:EmbeddedFont = getEmbeddedFont(_local1, _local4, _local5);
            var _local7:IFlexModuleFactory = embeddedFontRegistry.getAssociatedModuleFactory(_local6, moduleFactory);
            return (!((_local7 == oldEmbeddedFontContext)));
        }
        public function get explicitHeight():Number{
            return (_explicitHeight);
        }
        override public function get x():Number{
            return (super.x);
        }
        override public function get y():Number{
            return (super.y);
        }
        override public function get visible():Boolean{
            return (_visible);
        }
        mx_internal function addOverlay(_arg1:uint, _arg2:RoundedRectangle=null):void{
            if (!overlay){
                overlayColor = _arg1;
                overlay = new UIComponent();
                overlay.name = "overlay";
                overlay.$visible = true;
                fillOverlay(overlay, _arg1, _arg2);
                attachOverlay();
                if (!_arg2){
                    addEventListener(ResizeEvent.RESIZE, overlay_resizeHandler);
                };
                overlay.x = 0;
                overlay.y = 0;
                invalidateDisplayList();
                overlayReferenceCount = 1;
            } else {
                overlayReferenceCount++;
            };
            dispatchEvent(new ChildExistenceChangedEvent(ChildExistenceChangedEvent.OVERLAY_CREATED, true, false, overlay));
        }
        public function get percentWidth():Number{
            return (_percentWidth);
        }
        public function set explicitMinHeight(_arg1:Number):void{
            if (_explicitMinHeight == _arg1){
                return;
            };
            _explicitMinHeight = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitMinHeightChanged"));
        }
        public function set automationName(_arg1:String):void{
            _automationName = _arg1;
        }
        public function get mouseFocusEnabled():Boolean{
            return (_mouseFocusEnabled);
        }
        mx_internal function getEmbeddedFont(_arg1:String, _arg2:Boolean, _arg3:Boolean):EmbeddedFont{
            if (cachedEmbeddedFont){
                if ((((cachedEmbeddedFont.fontName == _arg1)) && ((cachedEmbeddedFont.fontStyle == EmbeddedFontRegistry.getFontStyle(_arg2, _arg3))))){
                    return (cachedEmbeddedFont);
                };
            };
            cachedEmbeddedFont = new EmbeddedFont(_arg1, _arg2, _arg3);
            return (cachedEmbeddedFont);
        }
        public function stylesInitialized():void{
        }
        public function set errorString(_arg1:String):void{
            var _local2:String = _errorString;
            _errorString = _arg1;
            ToolTipManager.registerErrorString(this, _local2, _arg1);
            errorStringChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("errorStringChanged"));
        }
        public function getExplicitOrMeasuredWidth():Number{
            return (((isNaN(explicitWidth)) ? measuredWidth : explicitWidth));
        }
        final mx_internal function set $height(_arg1:Number):void{
            super.height = _arg1;
        }
        protected function keyUpHandler(_arg1:KeyboardEvent):void{
        }
        final mx_internal function $removeChild(_arg1:DisplayObject):DisplayObject{
            return (super.removeChild(_arg1));
        }
        override public function set scaleX(_arg1:Number):void{
            if (_scaleX == _arg1){
                return;
            };
            _scaleX = _arg1;
            invalidateProperties();
            invalidateSize();
            dispatchEvent(new Event("scaleXChanged"));
        }
        override public function set scaleY(_arg1:Number):void{
            if (_scaleY == _arg1){
                return;
            };
            _scaleY = _arg1;
            invalidateProperties();
            invalidateSize();
            dispatchEvent(new Event("scaleYChanged"));
        }
        public function set uid(_arg1:String):void{
            this._uid = _arg1;
        }
        public function createAutomationIDPart(_arg1:IAutomationObject):Object{
            if (automationDelegate){
                return (automationDelegate.createAutomationIDPart(_arg1));
            };
            return (null);
        }
        public function getAutomationChildAt(_arg1:int):IAutomationObject{
            if (automationDelegate){
                return (automationDelegate.getAutomationChildAt(_arg1));
            };
            return (null);
        }
        mx_internal function get isEffectStarted():Boolean{
            return (_isEffectStarted);
        }
        override public function get parent():DisplayObjectContainer{
            try {
                return (((_parent) ? _parent : super.parent));
            } catch(e:SecurityError) {
            };
            return (null);
        }
        override public function get mouseY():Number{
            if (((((!(root)) || ((root is Stage)))) || ((root[fakeMouseY] === undefined)))){
                return (super.mouseY);
            };
            return (globalToLocal(new Point(0, root[fakeMouseY])).y);
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            var _local3:Boolean;
            if (_width != _arg1){
                _width = _arg1;
                dispatchEvent(new Event("widthChanged"));
                _local3 = true;
            };
            if (_height != _arg2){
                _height = _arg2;
                dispatchEvent(new Event("heightChanged"));
                _local3 = true;
            };
            if (_local3){
                invalidateDisplayList();
                dispatchResizeEvent();
            };
        }
        private function focusObj_resizeHandler(_arg1:ResizeEvent):void{
            adjustFocusRect();
        }
        mx_internal function adjustSizesForScaleChanges():void{
            var _local3:Number;
            var _local1:Number = scaleX;
            var _local2:Number = scaleY;
            if (_local1 != oldScaleX){
                _local3 = Math.abs((_local1 / oldScaleX));
                if (explicitMinWidth){
                    explicitMinWidth = (explicitMinWidth * _local3);
                };
                if (!isNaN(explicitWidth)){
                    explicitWidth = (explicitWidth * _local3);
                };
                if (explicitMaxWidth){
                    explicitMaxWidth = (explicitMaxWidth * _local3);
                };
                oldScaleX = _local1;
            };
            if (_local2 != oldScaleY){
                _local3 = Math.abs((_local2 / oldScaleY));
                if (explicitMinHeight){
                    explicitMinHeight = (explicitMinHeight * _local3);
                };
                if (explicitHeight){
                    explicitHeight = (explicitHeight * _local3);
                };
                if (explicitMaxHeight){
                    explicitMaxHeight = (explicitMaxHeight * _local3);
                };
                oldScaleY = _local2;
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
                _focusPane.mask = null;
                _focusPane = null;
            };
        }
        public function determineTextFormatFromStyles():UITextFormat{
            var _local2:String;
            var _local1:UITextFormat = cachedTextFormat;
            if (!_local1){
                _local2 = StringUtil.trimArrayElements(_inheritingStyles.fontFamily, ",");
                _local1 = new UITextFormat(getNonNullSystemManager(), _local2);
                _local1.moduleFactory = moduleFactory;
                _local1.align = _inheritingStyles.textAlign;
                _local1.bold = (_inheritingStyles.fontWeight == "bold");
                _local1.color = ((enabled) ? _inheritingStyles.color : _inheritingStyles.disabledColor);
                _local1.font = _local2;
                _local1.indent = _inheritingStyles.textIndent;
                _local1.italic = (_inheritingStyles.fontStyle == "italic");
                _local1.kerning = _inheritingStyles.kerning;
                _local1.leading = _nonInheritingStyles.leading;
                _local1.leftMargin = _nonInheritingStyles.paddingLeft;
                _local1.letterSpacing = _inheritingStyles.letterSpacing;
                _local1.rightMargin = _nonInheritingStyles.paddingRight;
                _local1.size = _inheritingStyles.fontSize;
                _local1.underline = (_nonInheritingStyles.textDecoration == "underline");
                _local1.antiAliasType = _inheritingStyles.fontAntiAliasType;
                _local1.gridFitType = _inheritingStyles.fontGridFitType;
                _local1.sharpness = _inheritingStyles.fontSharpness;
                _local1.thickness = _inheritingStyles.fontThickness;
                cachedTextFormat = _local1;
            };
            return (_local1);
        }
        public function validationResultHandler(_arg1:ValidationResultEvent):void{
            var _local2:String;
            var _local3:ValidationResult;
            var _local4:int;
            if (_arg1.type == ValidationResultEvent.VALID){
                if (errorString != ""){
                    errorString = "";
                    dispatchEvent(new FlexEvent(FlexEvent.VALID));
                };
            } else {
                if (((((!((validationSubField == null))) && (!((validationSubField == ""))))) && (_arg1.results))){
                    _local4 = 0;
                    while (_local4 < _arg1.results.length) {
                        _local3 = _arg1.results[_local4];
                        if (_local3.subField == validationSubField){
                            if (_local3.isError){
                                _local2 = _local3.errorMessage;
                            } else {
                                if (errorString != ""){
                                    errorString = "";
                                    dispatchEvent(new FlexEvent(FlexEvent.VALID));
                                };
                            };
                            break;
                        };
                        _local4++;
                    };
                } else {
                    if (((_arg1.results) && ((_arg1.results.length > 0)))){
                        _local2 = _arg1.results[0].errorMessage;
                    };
                };
                if (((_local2) && (!((errorString == _local2))))){
                    errorString = _local2;
                    dispatchEvent(new FlexEvent(FlexEvent.INVALID));
                };
            };
        }
        public function invalidateProperties():void{
            if (!invalidatePropertiesFlag){
                invalidatePropertiesFlag = true;
                if (((parent) && (UIComponentGlobals.layoutManager))){
                    UIComponentGlobals.layoutManager.invalidateProperties(this);
                };
            };
        }
        public function get inheritingStyles():Object{
            return (_inheritingStyles);
        }
        private function focusObj_scrollHandler(_arg1:Event):void{
            adjustFocusRect();
        }
        final mx_internal function get $x():Number{
            return (super.x);
        }
        final mx_internal function get $y():Number{
            return (super.y);
        }
        public function setConstraintValue(_arg1:String, _arg2):void{
            setStyle(_arg1, _arg2);
        }
        protected function resourcesChanged():void{
        }
        public function registerEffects(_arg1:Array):void{
            var _local4:String;
            var _local2:int = _arg1.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = EffectManager.getEventForEffectTrigger(_arg1[_local3]);
                if (((!((_local4 == null))) && (!((_local4 == ""))))){
                    addEventListener(_local4, EffectManager.eventHandler, false, EventPriority.EFFECT);
                };
                _local3++;
            };
        }
        public function get explicitMinWidth():Number{
            return (_explicitMinWidth);
        }
        private function filterChangeHandler(_arg1:Event):void{
            super.filters = _filters;
        }
        override public function set visible(_arg1:Boolean):void{
            setVisible(_arg1);
        }
        public function set explicitHeight(_arg1:Number):void{
            if (_explicitHeight == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _percentHeight = NaN;
            };
            _explicitHeight = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (((_local2) && (includeInLayout))){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitHeightChanged"));
        }
        override public function set x(_arg1:Number):void{
            if (super.x == _arg1){
                return;
            };
            super.x = _arg1;
            invalidateProperties();
            dispatchEvent(new Event("xChanged"));
        }
        public function set showInAutomationHierarchy(_arg1:Boolean):void{
            _showInAutomationHierarchy = _arg1;
        }
        override public function set y(_arg1:Number):void{
            if (super.y == _arg1){
                return;
            };
            super.y = _arg1;
            invalidateProperties();
            dispatchEvent(new Event("yChanged"));
        }
        private function resourceManager_changeHandler(_arg1:Event):void{
            resourcesChanged();
        }
        public function set systemManager(_arg1:ISystemManager):void{
            _systemManager = _arg1;
            _systemManagerDirty = false;
        }
        mx_internal function getFocusObject():DisplayObject{
            var _local1:IFocusManager = focusManager;
            if (((!(_local1)) || (!(_local1.focusPane)))){
                return (null);
            };
            return ((((_local1.focusPane.numChildren == 0)) ? null : _local1.focusPane.getChildAt(0)));
        }
        public function set percentWidth(_arg1:Number):void{
            if (_percentWidth == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _explicitWidth = NaN;
            };
            _percentWidth = _arg1;
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
        }
        public function get moduleFactory():IFlexModuleFactory{
            return (_moduleFactory);
        }
        override public function addChild(_arg1:DisplayObject):DisplayObject{
            var _local2:DisplayObjectContainer = _arg1.parent;
            if (((_local2) && (!((_local2 is Loader))))){
                _local2.removeChild(_arg1);
            };
            var _local3:int = ((((overlayReferenceCount) && (!((_arg1 == overlay))))) ? Math.max(0, (super.numChildren - 1)) : super.numChildren);
            addingChild(_arg1);
            $addChildAt(_arg1, _local3);
            childAdded(_arg1);
            return (_arg1);
        }
        public function get document():Object{
            return (_document);
        }
        public function set mouseFocusEnabled(_arg1:Boolean):void{
            _mouseFocusEnabled = _arg1;
        }
        final mx_internal function $addChild(_arg1:DisplayObject):DisplayObject{
            return (super.addChild(_arg1));
        }
        mx_internal function setThemeColor(_arg1:Object):void{
            var _local2:Number;
            if ((_local2 is String)){
                _local2 = parseInt(String(_arg1));
            } else {
                _local2 = Number(_arg1);
            };
            if (isNaN(_local2)){
                _local2 = StyleManager.getColorName(_arg1);
            };
            var _local3:Number = ColorUtil.adjustBrightness2(_local2, 50);
            var _local4:Number = ColorUtil.adjustBrightness2(_local2, 70);
            setStyle("selectionColor", _local3);
            setStyle("rollOverColor", _local4);
        }
        public function get explicitMaxWidth():Number{
            return (_explicitMaxWidth);
        }
        public function get id():String{
            return (_id);
        }
        override public function get height():Number{
            return (_height);
        }
        public function set minWidth(_arg1:Number):void{
            if (explicitMinWidth == _arg1){
                return;
            };
            explicitMinWidth = _arg1;
        }
        public function set currentState(_arg1:String):void{
            setCurrentState(_arg1, true);
        }
        public function getRepeaterItem(_arg1:int=-1):Object{
            var _local2:Array = repeaters;
            if (_arg1 == -1){
                _arg1 = (_local2.length - 1);
            };
            return (_local2[_arg1].getItemAt(repeaterIndices[_arg1]));
        }
        public function executeBindings(_arg1:Boolean=false):void{
            var _local2:Object = ((((descriptor) && (descriptor.document))) ? descriptor.document : parentDocument);
            BindingManager.executeBindings(_local2, id, this);
        }
        public function replayAutomatableEvent(_arg1:Event):Boolean{
            if (automationDelegate){
                return (automationDelegate.replayAutomatableEvent(_arg1));
            };
            return (false);
        }
        mx_internal function getFontContext(_arg1:String, _arg2:Boolean, _arg3:Boolean):IFlexModuleFactory{
            return (embeddedFontRegistry.getAssociatedModuleFactory(getEmbeddedFont(_arg1, _arg2, _arg3), moduleFactory));
        }
        public function get instanceIndex():int{
            return (((_instanceIndices) ? _instanceIndices[(_instanceIndices.length - 1)] : -1));
        }
        public function set measuredWidth(_arg1:Number):void{
            _measuredWidth = _arg1;
        }
        public function effectFinished(_arg1:IEffectInstance):void{
            _endingEffectInstances.push(_arg1);
            invalidateProperties();
            UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler, false, 0, true);
        }
        mx_internal function set isEffectStarted(_arg1:Boolean):void{
            _isEffectStarted = _arg1;
        }
        mx_internal function fillOverlay(_arg1:UIComponent, _arg2:uint, _arg3:RoundedRectangle=null):void{
            if (!_arg3){
                _arg3 = new RoundedRectangle(0, 0, unscaledWidth, unscaledHeight, 0);
            };
            var _local4:Graphics = _arg1.graphics;
            _local4.clear();
            _local4.beginFill(_arg2);
            _local4.drawRoundRect(_arg3.x, _arg3.y, _arg3.width, _arg3.height, (_arg3.cornerRadius * 2), (_arg3.cornerRadius * 2));
            _local4.endFill();
        }
        public function get instanceIndices():Array{
            return (((_instanceIndices) ? _instanceIndices.slice(0) : null));
        }
        mx_internal function childAdded(_arg1:DisplayObject):void{
            if ((_arg1 is UIComponent)){
                if (!UIComponent(_arg1).initialized){
                    UIComponent(_arg1).initialize();
                };
            } else {
                if ((_arg1 is IUIComponent)){
                    IUIComponent(_arg1).initialize();
                };
            };
        }
        public function globalToContent(_arg1:Point):Point{
            return (globalToLocal(_arg1));
        }
        mx_internal function removingChild(_arg1:DisplayObject):void{
        }
        mx_internal function getEffectsForProperty(_arg1:String):Array{
            return (((_affectedProperties[_arg1])!=undefined) ? _affectedProperties[_arg1] : []);
        }
        override public function removeChildAt(_arg1:int):DisplayObject{
            var _local2:DisplayObject = getChildAt(_arg1);
            removingChild(_local2);
            $removeChild(_local2);
            childRemoved(_local2);
            return (_local2);
        }
        protected function measure():void{
            measuredMinWidth = 0;
            measuredMinHeight = 0;
            measuredWidth = 0;
            measuredHeight = 0;
        }
        public function set owner(_arg1:DisplayObjectContainer):void{
            _owner = _arg1;
        }
        mx_internal function getNonNullSystemManager():ISystemManager{
            var _local1:ISystemManager = systemManager;
            if (!_local1){
                _local1 = ISystemManager(SystemManager.getSWFRoot(this));
            };
            if (!_local1){
                return (SystemManagerGlobals.topLevelSystemManagers[0]);
            };
            return (_local1);
        }
        protected function get unscaledWidth():Number{
            return ((width / Math.abs(scaleX)));
        }
        public function set processedDescriptors(_arg1:Boolean):void{
            _processedDescriptors = _arg1;
            if (_arg1){
                dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
            };
        }
        private function processEffectFinished(_arg1:Array):void{
            var _local3:int;
            var _local4:IEffectInstance;
            var _local5:IEffectInstance;
            var _local6:Array;
            var _local7:int;
            var _local8:String;
            var _local9:int;
            var _local2:int = (_effectsStarted.length - 1);
            while (_local2 >= 0) {
                _local3 = 0;
                while (_local3 < _arg1.length) {
                    _local4 = _arg1[_local3];
                    if (_local4 == _effectsStarted[_local2]){
                        _local5 = _effectsStarted[_local2];
                        _effectsStarted.splice(_local2, 1);
                        _local6 = _local5.effect.getAffectedProperties();
                        _local7 = 0;
                        while (_local7 < _local6.length) {
                            _local8 = _local6[_local7];
                            if (_affectedProperties[_local8] != undefined){
                                _local9 = 0;
                                while (_local9 < _affectedProperties[_local8].length) {
                                    if (_affectedProperties[_local8][_local9] == _local4){
                                        _affectedProperties[_local8].splice(_local9, 1);
                                        break;
                                    };
                                    _local9++;
                                };
                                if (_affectedProperties[_local8].length == 0){
                                    delete _affectedProperties[_local8];
                                };
                            };
                            _local7++;
                        };
                        break;
                    };
                    _local3++;
                };
                _local2--;
            };
            isEffectStarted = (((_effectsStarted.length > 0)) ? true : false);
            if (((_local4) && (_local4.hideFocusRing))){
                preventDrawFocus = false;
            };
        }
        private function commitCurrentState():void{
            var _local3:StateChangeEvent;
            var _local1:IEffect = ((playStateTransition) ? getTransition(_currentState, requestedCurrentState) : null);
            var _local2:String = findCommonBaseState(_currentState, requestedCurrentState);
            var _local4:String = ((_currentState) ? _currentState : "");
            var _local5:State = getState(requestedCurrentState);
            if (_currentTransitionEffect){
                _currentTransitionEffect.end();
            };
            initializeState(requestedCurrentState);
            if (_local1){
                _local1.captureStartValues();
            };
            _local3 = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
            _local3.oldState = _local4;
            _local3.newState = ((requestedCurrentState) ? requestedCurrentState : "");
            dispatchEvent(_local3);
            if (isBaseState(_currentState)){
                dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
            };
            removeState(_currentState, _local2);
            _currentState = requestedCurrentState;
            if (isBaseState(currentState)){
                dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
            } else {
                applyState(_currentState, _local2);
            };
            _local3 = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
            _local3.oldState = _local4;
            _local3.newState = ((_currentState) ? _currentState : "");
            dispatchEvent(_local3);
            if (_local1){
                UIComponentGlobals.layoutManager.validateNow();
                _currentTransitionEffect = _local1;
                _local1.addEventListener(EffectEvent.EFFECT_END, transition_effectEndHandler);
                _local1.play();
            };
        }
        public function get includeInLayout():Boolean{
            return (_includeInLayout);
        }
        private function dispatchResizeEvent():void{
            var _local1:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
            _local1.oldWidth = oldWidth;
            _local1.oldHeight = oldHeight;
            dispatchEvent(_local1);
            oldWidth = width;
            oldHeight = height;
        }
        public function set maxWidth(_arg1:Number):void{
            if (explicitMaxWidth == _arg1){
                return;
            };
            explicitMaxWidth = _arg1;
        }
        public function validateDisplayList():void{
            var _local1:ISystemManager;
            var _local2:Number;
            var _local3:Number;
            if (invalidateDisplayListFlag){
                _local1 = (parent as ISystemManager);
                if (_local1){
                    if ((((_local1 is SystemManagerProxy)) || ((((_local1 == systemManager.topLevelSystemManager)) && (!((_local1.document == this))))))){
                        setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
                    };
                };
                _local2 = (((scaleX == 0)) ? 0 : (width / scaleX));
                _local3 = (((scaleY == 0)) ? 0 : (height / scaleY));
                if (Math.abs((_local2 - lastUnscaledWidth)) < 1E-5){
                    _local2 = lastUnscaledWidth;
                };
                if (Math.abs((_local3 - lastUnscaledHeight)) < 1E-5){
                    _local3 = lastUnscaledHeight;
                };
                updateDisplayList(_local2, _local3);
                lastUnscaledWidth = _local2;
                lastUnscaledHeight = _local3;
                invalidateDisplayListFlag = false;
            };
        }
        public function contentToGlobal(_arg1:Point):Point{
            return (localToGlobal(_arg1));
        }
        public function resolveAutomationIDPart(_arg1:Object):Array{
            if (automationDelegate){
                return (automationDelegate.resolveAutomationIDPart(_arg1));
            };
            return ([]);
        }
        public function set inheritingStyles(_arg1:Object):void{
            _inheritingStyles = _arg1;
        }
        public function setFocus():void{
            var _local1:ISystemManager = systemManager;
            if (((_local1) && (((_local1.stage) || (_local1.useSWFBridge()))))){
                if (UIComponentGlobals.callLaterDispatcherCount == 0){
                    _local1.stage.focus = this;
                    UIComponentGlobals.nextFocusObject = null;
                } else {
                    UIComponentGlobals.nextFocusObject = this;
                    _local1.addEventListener(FlexEvent.ENTER_FRAME, setFocusLater);
                };
            } else {
                UIComponentGlobals.nextFocusObject = this;
                callLater(setFocusLater);
            };
        }
        private function getTransition(_arg1:String, _arg2:String):IEffect{
            var _local6:Transition;
            var _local3:IEffect;
            var _local4:int;
            if (!transitions){
                return (null);
            };
            if (!_arg1){
                _arg1 = "";
            };
            if (!_arg2){
                _arg2 = "";
            };
            var _local5:int;
            while (_local5 < transitions.length) {
                _local6 = transitions[_local5];
                if ((((((_local6.fromState == "*")) && ((_local6.toState == "*")))) && ((_local4 < 1)))){
                    _local3 = _local6.effect;
                    _local4 = 1;
                } else {
                    if ((((((_local6.fromState == _arg1)) && ((_local6.toState == "*")))) && ((_local4 < 2)))){
                        _local3 = _local6.effect;
                        _local4 = 2;
                    } else {
                        if ((((((_local6.fromState == "*")) && ((_local6.toState == _arg2)))) && ((_local4 < 3)))){
                            _local3 = _local6.effect;
                            _local4 = 3;
                        } else {
                            if ((((((_local6.fromState == _arg1)) && ((_local6.toState == _arg2)))) && ((_local4 < 4)))){
                                _local3 = _local6.effect;
                                _local4 = 4;
                                break;
                            };
                        };
                    };
                };
                _local5++;
            };
            return (_local3);
        }
        public function set initialized(_arg1:Boolean):void{
            _initialized = _arg1;
            if (_arg1){
                setVisible(_visible, true);
                dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
            };
        }
        final mx_internal function set $y(_arg1:Number):void{
            super.y = _arg1;
        }
        public function owns(_arg1:DisplayObject):Boolean{
            var child:* = _arg1;
            var childList:* = (((this is IRawChildrenContainer)) ? IRawChildrenContainer(this).rawChildren : IChildList(this));
            if (childList.contains(child)){
                return (true);
            };
            try {
                while (((child) && (!((child == this))))) {
                    if ((child is IUIComponent)){
                        child = IUIComponent(child).owner;
                    } else {
                        child = child.parent;
                    };
                };
            } catch(e:SecurityError) {
                return (false);
            };
            return ((child == this));
        }
        public function setVisible(_arg1:Boolean, _arg2:Boolean=false):void{
            _visible = _arg1;
            if (!initialized){
                return;
            };
            if ($visible == _arg1){
                return;
            };
            $visible = _arg1;
            if (!_arg2){
                dispatchEvent(new FlexEvent(((_arg1) ? FlexEvent.SHOW : FlexEvent.HIDE)));
            };
        }
        final mx_internal function $addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            return (super.addChildAt(_arg1, _arg2));
        }
        public function deleteReferenceOnParentDocument(_arg1:IFlexDisplayObject):void{
            var _local2:Array;
            var _local3:Object;
            var _local4:Array;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:Object;
            var _local9:PropertyChangeEvent;
            if (((id) && (!((id == ""))))){
                _local2 = _instanceIndices;
                if (!_local2){
                    _arg1[id] = null;
                } else {
                    _local3 = _arg1[id];
                    if (!_local3){
                        return;
                    };
                    _local4 = [];
                    _local4.push(_local3);
                    _local5 = _local2.length;
                    _local6 = 0;
                    while (_local6 < (_local5 - 1)) {
                        _local8 = _local3[_local2[_local6]];
                        if (!_local8){
                            return;
                        };
                        _local3 = _local8;
                        _local4.push(_local3);
                        _local6++;
                    };
                    _local3.splice(_local2[(_local5 - 1)], 1);
                    _local7 = (_local4.length - 1);
                    while (_local7 > 0) {
                        if (_local4[_local7].length == 0){
                            _local4[(_local7 - 1)].splice(_local2[_local7], 1);
                        };
                        _local7--;
                    };
                    if ((((_local4.length > 0)) && ((_local4[0].length == 0)))){
                        _arg1[id] = null;
                    } else {
                        _local9 = PropertyChangeEvent.createUpdateEvent(_arg1, id, _arg1[id], _arg1[id]);
                        _arg1.dispatchEvent(_local9);
                    };
                };
            };
        }
        public function get nonInheritingStyles():Object{
            return (_nonInheritingStyles);
        }
        public function effectStarted(_arg1:IEffectInstance):void{
            var _local4:String;
            _effectsStarted.push(_arg1);
            var _local2:Array = _arg1.effect.getAffectedProperties();
            var _local3:int;
            while (_local3 < _local2.length) {
                _local4 = _local2[_local3];
                if (_affectedProperties[_local4] == undefined){
                    _affectedProperties[_local4] = [];
                };
                _affectedProperties[_local4].push(_arg1);
                _local3++;
            };
            isEffectStarted = true;
            if (_arg1.hideFocusRing){
                preventDrawFocus = true;
                drawFocus(false);
            };
        }
        final mx_internal function set $x(_arg1:Number):void{
            super.x = _arg1;
        }
        private function applyState(_arg1:String, _arg2:String):void{
            var _local4:Array;
            var _local5:int;
            var _local3:State = getState(_arg1);
            if (_arg1 == _arg2){
                return;
            };
            if (_local3){
                if (_local3.basedOn != _arg2){
                    applyState(_local3.basedOn, _arg2);
                };
                _local4 = _local3.overrides;
                _local5 = 0;
                while (_local5 < _local4.length) {
                    _local4[_local5].apply(this);
                    _local5++;
                };
                _local3.dispatchEnterState();
            };
        }
        protected function commitProperties():void{
            var _local1:Number;
            var _local2:Number;
            if (_scaleX != oldScaleX){
                _local1 = Math.abs((_scaleX / oldScaleX));
                if (!isNaN(explicitMinWidth)){
                    explicitMinWidth = (explicitMinWidth * _local1);
                };
                if (!isNaN(explicitWidth)){
                    explicitWidth = (explicitWidth * _local1);
                };
                if (!isNaN(explicitMaxWidth)){
                    explicitMaxWidth = (explicitMaxWidth * _local1);
                };
                _width = (_width * _local1);
                super.scaleX = (oldScaleX = _scaleX);
            };
            if (_scaleY != oldScaleY){
                _local2 = Math.abs((_scaleY / oldScaleY));
                if (!isNaN(explicitMinHeight)){
                    explicitMinHeight = (explicitMinHeight * _local2);
                };
                if (!isNaN(explicitHeight)){
                    explicitHeight = (explicitHeight * _local2);
                };
                if (!isNaN(explicitMaxHeight)){
                    explicitMaxHeight = (explicitMaxHeight * _local2);
                };
                _height = (_height * _local2);
                super.scaleY = (oldScaleY = _scaleY);
            };
            if (((!((x == oldX))) || (!((y == oldY))))){
                dispatchMoveEvent();
            };
            if (((!((width == oldWidth))) || (!((height == oldHeight))))){
                dispatchResizeEvent();
            };
            if (errorStringChanged){
                errorStringChanged = false;
                setBorderColorForErrorString();
            };
        }
        public function get percentHeight():Number{
            return (_percentHeight);
        }
        override public function get width():Number{
            return (_width);
        }
        final mx_internal function get $parent():DisplayObjectContainer{
            return (super.parent);
        }
        public function set explicitMinWidth(_arg1:Number):void{
            if (_explicitMinWidth == _arg1){
                return;
            };
            _explicitMinWidth = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitMinWidthChanged"));
        }
        public function get isPopUp():Boolean{
            return (_isPopUp);
        }
        private function measureSizes():Boolean{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local1:Boolean;
            if (!invalidateSizeFlag){
                return (_local1);
            };
            if (((isNaN(explicitWidth)) || (isNaN(explicitHeight)))){
                _local4 = Math.abs(scaleX);
                _local5 = Math.abs(scaleY);
                if (_local4 != 1){
                    _measuredMinWidth = (_measuredMinWidth / _local4);
                    _measuredWidth = (_measuredWidth / _local4);
                };
                if (_local5 != 1){
                    _measuredMinHeight = (_measuredMinHeight / _local5);
                    _measuredHeight = (_measuredHeight / _local5);
                };
                measure();
                invalidateSizeFlag = false;
                if (((!(isNaN(explicitMinWidth))) && ((measuredWidth < explicitMinWidth)))){
                    measuredWidth = explicitMinWidth;
                };
                if (((!(isNaN(explicitMaxWidth))) && ((measuredWidth > explicitMaxWidth)))){
                    measuredWidth = explicitMaxWidth;
                };
                if (((!(isNaN(explicitMinHeight))) && ((measuredHeight < explicitMinHeight)))){
                    measuredHeight = explicitMinHeight;
                };
                if (((!(isNaN(explicitMaxHeight))) && ((measuredHeight > explicitMaxHeight)))){
                    measuredHeight = explicitMaxHeight;
                };
                if (_local4 != 1){
                    _measuredMinWidth = (_measuredMinWidth * _local4);
                    _measuredWidth = (_measuredWidth * _local4);
                };
                if (_local5 != 1){
                    _measuredMinHeight = (_measuredMinHeight * _local5);
                    _measuredHeight = (_measuredHeight * _local5);
                };
            } else {
                invalidateSizeFlag = false;
                _measuredMinWidth = 0;
                _measuredMinHeight = 0;
            };
            adjustSizesForScaleChanges();
            if (isNaN(oldMinWidth)){
                oldMinWidth = ((isNaN(explicitMinWidth)) ? measuredMinWidth : explicitMinWidth);
                oldMinHeight = ((isNaN(explicitMinHeight)) ? measuredMinHeight : explicitMinHeight);
                oldExplicitWidth = ((isNaN(explicitWidth)) ? measuredWidth : explicitWidth);
                oldExplicitHeight = ((isNaN(explicitHeight)) ? measuredHeight : explicitHeight);
                _local1 = true;
            } else {
                _local3 = ((isNaN(explicitMinWidth)) ? measuredMinWidth : explicitMinWidth);
                if (_local3 != oldMinWidth){
                    oldMinWidth = _local3;
                    _local1 = true;
                };
                _local3 = ((isNaN(explicitMinHeight)) ? measuredMinHeight : explicitMinHeight);
                if (_local3 != oldMinHeight){
                    oldMinHeight = _local3;
                    _local1 = true;
                };
                _local3 = ((isNaN(explicitWidth)) ? measuredWidth : explicitWidth);
                if (_local3 != oldExplicitWidth){
                    oldExplicitWidth = _local3;
                    _local1 = true;
                };
                _local3 = ((isNaN(explicitHeight)) ? measuredHeight : explicitHeight);
                if (_local3 != oldExplicitHeight){
                    oldExplicitHeight = _local3;
                    _local1 = true;
                };
            };
            return (_local1);
        }
        public function get automationTabularData():Object{
            if (automationDelegate){
                return (automationDelegate.automationTabularData);
            };
            return (null);
        }
        public function validateNow():void{
            UIComponentGlobals.layoutManager.validateClient(this);
        }
        public function finishPrint(_arg1:Object, _arg2:IFlexDisplayObject):void{
        }
        public function get repeaters():Array{
            return (((_repeaters) ? _repeaters.slice(0) : []));
        }
        private function dispatchMoveEvent():void{
            var _local1:MoveEvent = new MoveEvent(MoveEvent.MOVE);
            _local1.oldX = oldX;
            _local1.oldY = oldY;
            dispatchEvent(_local1);
            oldX = x;
            oldY = y;
        }
        public function drawFocus(_arg1:Boolean):void{
            var _local4:DisplayObjectContainer;
            var _local5:Class;
            if (!parent){
                return;
            };
            var _local2:DisplayObject = getFocusObject();
            var _local3:Sprite = ((focusManager) ? focusManager.focusPane : null);
            if (((_arg1) && (!(preventDrawFocus)))){
                _local4 = _local3.parent;
                if (_local4 != parent){
                    if (_local4){
                        if ((_local4 is ISystemManager)){
                            ISystemManager(_local4).focusPane = null;
                        } else {
                            IUIComponent(_local4).focusPane = null;
                        };
                    };
                    if ((parent is ISystemManager)){
                        ISystemManager(parent).focusPane = _local3;
                    } else {
                        IUIComponent(parent).focusPane = _local3;
                    };
                };
                _local5 = getStyle("focusSkin");
                if (((_local2) && (!((_local2 is _local5))))){
                    _local3.removeChild(_local2);
                    _local2 = null;
                };
                if (!_local2){
                    _local2 = new (_local5)();
                    _local2.name = "focus";
                    _local3.addChild(_local2);
                };
                if ((_local2 is ILayoutManagerClient)){
                    ILayoutManagerClient(_local2).nestLevel = nestLevel;
                };
                if ((_local2 is ISimpleStyleClient)){
                    ISimpleStyleClient(_local2).styleName = this;
                };
                addEventListener(MoveEvent.MOVE, focusObj_moveHandler, true);
                addEventListener(MoveEvent.MOVE, focusObj_moveHandler);
                addEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler, true);
                addEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler);
                addEventListener(Event.REMOVED, focusObj_removedHandler, true);
                _local2.visible = true;
                hasFocusRect = true;
                adjustFocusRect();
            } else {
                if (hasFocusRect){
                    hasFocusRect = false;
                    if (_local2){
                        _local2.visible = false;
                    };
                    removeEventListener(MoveEvent.MOVE, focusObj_moveHandler);
                    removeEventListener(MoveEvent.MOVE, focusObj_moveHandler, true);
                    removeEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler, true);
                    removeEventListener(ResizeEvent.RESIZE, focusObj_resizeHandler);
                    removeEventListener(Event.REMOVED, focusObj_removedHandler, true);
                };
            };
        }
        public function get flexContextMenu():IFlexContextMenu{
            return (_flexContextMenu);
        }
        private function get indexedID():String{
            var _local1:String = id;
            var _local2:Array = instanceIndices;
            if (_local2){
                _local1 = (_local1 + (("[" + _local2.join("][")) + "]"));
            };
            return (_local1);
        }
        public function get measuredMinHeight():Number{
            return (_measuredMinHeight);
        }
        mx_internal function addingChild(_arg1:DisplayObject):void{
            if ((((_arg1 is IUIComponent)) && (!(IUIComponent(_arg1).document)))){
                IUIComponent(_arg1).document = ((document) ? document : ApplicationGlobals.application);
            };
            if ((((_arg1 is UIComponent)) && ((UIComponent(_arg1).moduleFactory == null)))){
                if (moduleFactory != null){
                    UIComponent(_arg1).moduleFactory = moduleFactory;
                } else {
                    if ((((document is IFlexModule)) && (!((document.moduleFactory == null))))){
                        UIComponent(_arg1).moduleFactory = document.moduleFactory;
                    } else {
                        if ((((parent is UIComponent)) && (!((UIComponent(parent).moduleFactory == null))))){
                            UIComponent(_arg1).moduleFactory = UIComponent(parent).moduleFactory;
                        };
                    };
                };
            };
            if ((((((_arg1 is IFontContextComponent)) && ((!(_arg1) is UIComponent)))) && ((IFontContextComponent(_arg1).fontContext == null)))){
                IFontContextComponent(_arg1).fontContext = moduleFactory;
            };
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).parentChanged(this);
            };
            if ((_arg1 is ILayoutManagerClient)){
                ILayoutManagerClient(_arg1).nestLevel = (nestLevel + 1);
            } else {
                if ((_arg1 is IUITextField)){
                    IUITextField(_arg1).nestLevel = (nestLevel + 1);
                };
            };
            if ((_arg1 is InteractiveObject)){
                if (doubleClickEnabled){
                    InteractiveObject(_arg1).doubleClickEnabled = true;
                };
            };
            if ((_arg1 is IStyleClient)){
                IStyleClient(_arg1).regenerateStyleCache(true);
            } else {
                if ((((_arg1 is IUITextField)) && (IUITextField(_arg1).inheritingStyles))){
                    StyleProtoChain.initTextField(IUITextField(_arg1));
                };
            };
            if ((_arg1 is ISimpleStyleClient)){
                ISimpleStyleClient(_arg1).styleChanged(null);
            };
            if ((_arg1 is IStyleClient)){
                IStyleClient(_arg1).notifyStyleChangeInChildren(null, true);
            };
            if ((_arg1 is UIComponent)){
                UIComponent(_arg1).initThemeColor();
            };
            if ((_arg1 is UIComponent)){
                UIComponent(_arg1).stylesInitialized();
            };
        }
        public function set repeaterIndices(_arg1:Array):void{
            _repeaterIndices = _arg1;
        }
        protected function initializationComplete():void{
            processedDescriptors = true;
        }
        public function set moduleFactory(_arg1:IFlexModuleFactory):void{
            var _local4:UIComponent;
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = (getChildAt(_local3) as UIComponent);
                if (!_local4){
                } else {
                    if ((((_local4.moduleFactory == null)) || ((_local4.moduleFactory == _moduleFactory)))){
                        _local4.moduleFactory = _arg1;
                    };
                };
                _local3++;
            };
            _moduleFactory = _arg1;
        }
        private function focusObj_removedHandler(_arg1:Event):void{
            if (_arg1.target != this){
                return;
            };
            var _local2:DisplayObject = getFocusObject();
            if (_local2){
                _local2.visible = false;
            };
        }
        mx_internal function updateCallbacks():void{
            if (invalidateDisplayListFlag){
                UIComponentGlobals.layoutManager.invalidateDisplayList(this);
            };
            if (invalidateSizeFlag){
                UIComponentGlobals.layoutManager.invalidateSize(this);
            };
            if (invalidatePropertiesFlag){
                UIComponentGlobals.layoutManager.invalidateProperties(this);
            };
            if (((systemManager) && (((_systemManager.stage) || (_systemManager.useSWFBridge()))))){
                if ((((methodQueue.length > 0)) && (!(listeningForRender)))){
                    _systemManager.addEventListener(FlexEvent.RENDER, callLaterDispatcher);
                    _systemManager.addEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
                    listeningForRender = true;
                };
                if (_systemManager.stage){
                    _systemManager.stage.invalidate();
                };
            };
        }
        public function set styleDeclaration(_arg1:CSSStyleDeclaration):void{
            _styleDeclaration = _arg1;
        }
        override public function set doubleClickEnabled(_arg1:Boolean):void{
            var _local2:IChildList;
            var _local4:InteractiveObject;
            super.doubleClickEnabled = _arg1;
            if ((this is IRawChildrenContainer)){
                _local2 = IRawChildrenContainer(this).rawChildren;
            } else {
                _local2 = IChildList(this);
            };
            var _local3:int;
            while (_local3 < _local2.numChildren) {
                _local4 = (_local2.getChildAt(_local3) as InteractiveObject);
                if (_local4){
                    _local4.doubleClickEnabled = _arg1;
                };
                _local3++;
            };
        }
        public function prepareToPrint(_arg1:IFlexDisplayObject):Object{
            return (null);
        }
        public function get minHeight():Number{
            if (!isNaN(explicitMinHeight)){
                return (explicitMinHeight);
            };
            return (measuredMinHeight);
        }
        public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            var _local5:ISimpleStyleClient;
            cachedTextFormat = null;
            var _local3:int = numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = (getChildAt(_local4) as ISimpleStyleClient);
                if (_local5){
                    _local5.styleChanged(_arg1);
                    if ((_local5 is IStyleClient)){
                        IStyleClient(_local5).notifyStyleChangeInChildren(_arg1, _arg2);
                    };
                };
                _local4++;
            };
        }
        public function get contentMouseX():Number{
            return (mouseX);
        }
        public function get contentMouseY():Number{
            return (mouseY);
        }
        public function get tweeningProperties():Array{
            return (_tweeningProperties);
        }
        public function set explicitMaxWidth(_arg1:Number):void{
            if (_explicitMaxWidth == _arg1){
                return;
            };
            _explicitMaxWidth = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitMaxWidthChanged"));
        }
        public function set document(_arg1:Object):void{
            var _local4:IUIComponent;
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = (getChildAt(_local3) as IUIComponent);
                if (!_local4){
                } else {
                    if ((((_local4.document == _document)) || ((_local4.document == ApplicationGlobals.application)))){
                        _local4.document = _arg1;
                    };
                };
                _local3++;
            };
            _document = _arg1;
        }
        public function validateSize(_arg1:Boolean=false):void{
            var _local2:int;
            var _local3:DisplayObject;
            var _local4:Boolean;
            var _local5:IInvalidating;
            if (_arg1){
                _local2 = 0;
                while (_local2 < numChildren) {
                    _local3 = getChildAt(_local2);
                    if ((_local3 is ILayoutManagerClient)){
                        (_local3 as ILayoutManagerClient).validateSize(true);
                    };
                    _local2++;
                };
            };
            if (invalidateSizeFlag){
                _local4 = measureSizes();
                if (((_local4) && (includeInLayout))){
                    invalidateDisplayList();
                    _local5 = (parent as IInvalidating);
                    if (_local5){
                        _local5.invalidateSize();
                        _local5.invalidateDisplayList();
                    };
                };
            };
        }
        public function get validationSubField():String{
            return (_validationSubField);
        }
        override public function dispatchEvent(_arg1:Event):Boolean{
            if (dispatchEventHook != null){
                dispatchEventHook(_arg1, this);
            };
            return (super.dispatchEvent(_arg1));
        }
        public function set id(_arg1:String):void{
            _id = _arg1;
        }
        private function overlay_resizeHandler(_arg1:Event):void{
            fillOverlay(overlay, overlayColor, null);
        }
        public function set updateCompletePendingFlag(_arg1:Boolean):void{
            _updateCompletePendingFlag = _arg1;
        }
        final mx_internal function get $height():Number{
            return (super.height);
        }
        protected function attachOverlay():void{
            addChild(overlay);
        }
        public function get explicitMinHeight():Number{
            return (_explicitMinHeight);
        }
        override public function set height(_arg1:Number):void{
            var _local2:IInvalidating;
            if (explicitHeight != _arg1){
                explicitHeight = _arg1;
                invalidateSize();
            };
            if (_height != _arg1){
                invalidateProperties();
                invalidateDisplayList();
                _local2 = (parent as IInvalidating);
                if (((_local2) && (includeInLayout))){
                    _local2.invalidateSize();
                    _local2.invalidateDisplayList();
                };
                _height = _arg1;
                dispatchEvent(new Event("heightChanged"));
            };
        }
        public function get numAutomationChildren():int{
            if (automationDelegate){
                return (automationDelegate.numAutomationChildren);
            };
            return (0);
        }
        public function get parentApplication():Object{
            var _local2:UIComponent;
            var _local1:Object = systemManager.document;
            if (_local1 == this){
                _local2 = (_local1.systemManager.parent as UIComponent);
                _local1 = ((_local2) ? _local2.systemManager.document : null);
            };
            return (_local1);
        }
        public function localToContent(_arg1:Point):Point{
            return (_arg1);
        }
        public function get repeaterIndex():int{
            return (((_repeaterIndices) ? _repeaterIndices[(_repeaterIndices.length - 1)] : -1));
        }
        private function removeState(_arg1:String, _arg2:String):void{
            var _local4:Array;
            var _local5:int;
            var _local3:State = getState(_arg1);
            if (_arg1 == _arg2){
                return;
            };
            if (_local3){
                _local3.dispatchExitState();
                _local4 = _local3.overrides;
                _local5 = _local4.length;
                while (_local5) {
                    _local4[(_local5 - 1)].remove(this);
                    _local5--;
                };
                if (_local3.basedOn != _arg2){
                    removeState(_local3.basedOn, _arg2);
                };
            };
        }
        public function setStyle(_arg1:String, _arg2):void{
            if (_arg1 == "styleName"){
                styleName = _arg2;
                return;
            };
            if (EffectManager.getEventForEffectTrigger(_arg1) != ""){
                EffectManager.setStyle(_arg1, this);
            };
            var _local3:Boolean = StyleManager.isInheritingStyle(_arg1);
            var _local4 = !((inheritingStyles == UIComponent.STYLE_UNINITIALIZED));
            var _local5 = !((getStyle(_arg1) == _arg2));
            if (!_styleDeclaration){
                _styleDeclaration = new CSSStyleDeclaration();
                _styleDeclaration.setStyle(_arg1, _arg2);
                if (_local4){
                    regenerateStyleCache(_local3);
                };
            } else {
                _styleDeclaration.setStyle(_arg1, _arg2);
            };
            if (((_local4) && (_local5))){
                styleChanged(_arg1);
                notifyStyleChangeInChildren(_arg1, _local3);
            };
        }
        public function get showInAutomationHierarchy():Boolean{
            return (_showInAutomationHierarchy);
        }
        public function get systemManager():ISystemManager{
            var _local1:DisplayObject;
            var _local2:DisplayObjectContainer;
            var _local3:IUIComponent;
            if (((!(_systemManager)) || (_systemManagerDirty))){
                _local1 = root;
                if ((_systemManager is SystemManagerProxy)){
                } else {
                    if (((_local1) && (!((_local1 is Stage))))){
                        _systemManager = (_local1 as ISystemManager);
                    } else {
                        if (_local1){
                            _systemManager = (Stage(_local1).getChildAt(0) as ISystemManager);
                        } else {
                            _local2 = parent;
                            while (_local2) {
                                _local3 = (_local2 as IUIComponent);
                                if (_local3){
                                    _systemManager = _local3.systemManager;
                                    break;
                                };
                                if ((_local2 is ISystemManager)){
                                    _systemManager = (_local2 as ISystemManager);
                                    break;
                                };
                                _local2 = _local2.parent;
                            };
                        };
                    };
                };
                _systemManagerDirty = false;
            };
            return (_systemManager);
        }
        private function isBaseState(_arg1:String):Boolean{
            return (((!(_arg1)) || ((_arg1 == ""))));
        }
        public function set enabled(_arg1:Boolean):void{
            _enabled = _arg1;
            cachedTextFormat = null;
            invalidateDisplayList();
            dispatchEvent(new Event("enabledChanged"));
        }
        public function set focusEnabled(_arg1:Boolean):void{
            _focusEnabled = _arg1;
        }
        public function get minWidth():Number{
            if (!isNaN(explicitMinWidth)){
                return (explicitMinWidth);
            };
            return (measuredMinWidth);
        }
        private function setFocusLater(_arg1:Event=null):void{
            var _local2:ISystemManager = systemManager;
            if (((_local2) && (_local2.stage))){
                _local2.stage.removeEventListener(Event.ENTER_FRAME, setFocusLater);
                if (UIComponentGlobals.nextFocusObject){
                    _local2.stage.focus = UIComponentGlobals.nextFocusObject;
                };
                UIComponentGlobals.nextFocusObject = null;
            };
        }
        public function get currentState():String{
            return (((_currentStateChanged) ? requestedCurrentState : _currentState));
        }
        public function initializeRepeaterArrays(_arg1:IRepeaterClient):void{
            if (((((((_arg1) && (_arg1.instanceIndices))) && (((!(_arg1.isDocument)) || (!((_arg1 == descriptor.document))))))) && (!(_instanceIndices)))){
                _instanceIndices = _arg1.instanceIndices;
                _repeaters = _arg1.repeaters;
                _repeaterIndices = _arg1.repeaterIndices;
            };
        }
        public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (NaN);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            var _local1:TextLineMetrics = measureText("Wj");
            if (height < ((2 + _local1.ascent) + 2)){
                return (int((height + ((_local1.ascent - height) / 2))));
            };
            return ((2 + _local1.ascent));
        }
        public function get measuredWidth():Number{
            return (_measuredWidth);
        }
        public function set instanceIndices(_arg1:Array):void{
            _instanceIndices = _arg1;
        }
        public function set cachePolicy(_arg1:String):void{
            if (_cachePolicy != _arg1){
                _cachePolicy = _arg1;
                if (_arg1 == UIComponentCachePolicy.OFF){
                    cacheAsBitmap = false;
                } else {
                    if (_arg1 == UIComponentCachePolicy.ON){
                        cacheAsBitmap = true;
                    } else {
                        cacheAsBitmap = (cacheAsBitmapCount > 0);
                    };
                };
            };
        }
        public function get automationValue():Array{
            if (automationDelegate){
                return (automationDelegate.automationValue);
            };
            return ([]);
        }
        private function addedHandler(_arg1:Event):void{
            var event:* = _arg1;
            if (event.eventPhase != EventPhase.AT_TARGET){
                return;
            };
            try {
                if ((((parent is IContainer)) && (IContainer(parent).creatingContentPane))){
                    event.stopImmediatePropagation();
                    return;
                };
            } catch(error:SecurityError) {
            };
        }
        public function parentChanged(_arg1:DisplayObjectContainer):void{
            if (!_arg1){
                _parent = null;
                _nestLevel = 0;
            } else {
                if ((_arg1 is IStyleClient)){
                    _parent = _arg1;
                } else {
                    if ((_arg1 is ISystemManager)){
                        _parent = _arg1;
                    } else {
                        _parent = _arg1.parent;
                    };
                };
            };
        }
        public function get owner():DisplayObjectContainer{
            return (((_owner) ? _owner : parent));
        }
        public function get processedDescriptors():Boolean{
            return (_processedDescriptors);
        }
        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            var _local3:DisplayObjectContainer = _arg1.parent;
            if (((_local3) && (!((_local3 is Loader))))){
                _local3.removeChild(_arg1);
            };
            if (((overlayReferenceCount) && (!((_arg1 == overlay))))){
                _arg2 = Math.min(_arg2, Math.max(0, (super.numChildren - 1)));
            };
            addingChild(_arg1);
            $addChildAt(_arg1, _arg2);
            childAdded(_arg1);
            return (_arg1);
        }
        public function get maxWidth():Number{
            return (((isNaN(explicitMaxWidth)) ? DEFAULT_MAX_WIDTH : explicitMaxWidth));
        }
        override public function set alpha(_arg1:Number):void{
            super.alpha = _arg1;
            dispatchEvent(new Event("alphaChanged"));
        }
        private function removedHandler(_arg1:Event):void{
            var event:* = _arg1;
            if (event.eventPhase != EventPhase.AT_TARGET){
                return;
            };
            try {
                if ((((parent is IContainer)) && (IContainer(parent).creatingContentPane))){
                    event.stopImmediatePropagation();
                    return;
                };
            } catch(error:SecurityError) {
            };
            _systemManagerDirty = true;
        }
        public function callLater(_arg1:Function, _arg2:Array=null):void{
            methodQueue.push(new MethodQueueElement(_arg1, _arg2));
            var _local3:ISystemManager = systemManager;
            if (((_local3) && (((_local3.stage) || (_local3.useSWFBridge()))))){
                if (!listeningForRender){
                    _local3.addEventListener(FlexEvent.RENDER, callLaterDispatcher);
                    _local3.addEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
                    listeningForRender = true;
                };
                if (_local3.stage){
                    _local3.stage.invalidate();
                };
            };
        }
        public function get initialized():Boolean{
            return (_initialized);
        }
        private function callLaterDispatcher2(_arg1:Event):void{
            var _local6:MethodQueueElement;
            if (UIComponentGlobals.callLaterSuspendCount > 0){
                return;
            };
            var _local2:ISystemManager = systemManager;
            if (((((_local2) && (((_local2.stage) || (_local2.useSWFBridge()))))) && (listeningForRender))){
                _local2.removeEventListener(FlexEvent.RENDER, callLaterDispatcher);
                _local2.removeEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
                listeningForRender = false;
            };
            var _local3:Array = methodQueue;
            methodQueue = [];
            var _local4:int = _local3.length;
            var _local5:int;
            while (_local5 < _local4) {
                _local6 = MethodQueueElement(_local3[_local5]);
                _local6.method.apply(null, _local6.args);
                _local5++;
            };
        }
        public function measureHTMLText(_arg1:String):TextLineMetrics{
            return (determineTextFormatFromStyles().measureHTMLText(_arg1));
        }
        public function set descriptor(_arg1:UIComponentDescriptor):void{
            _descriptor = _arg1;
        }
        private function getState(_arg1:String):State{
            if (((!(states)) || (isBaseState(_arg1)))){
                return (null);
            };
            var _local2:int;
            while (_local2 < states.length) {
                if (states[_local2].name == _arg1){
                    return (states[_local2]);
                };
                _local2++;
            };
            var _local3:String = resourceManager.getString("core", "stateUndefined", [_arg1]);
            throw (new ArgumentError(_local3));
        }
        public function validateProperties():void{
            if (invalidatePropertiesFlag){
                commitProperties();
                invalidatePropertiesFlag = false;
            };
        }
        mx_internal function get documentDescriptor():UIComponentDescriptor{
            return (_documentDescriptor);
        }
        public function set includeInLayout(_arg1:Boolean):void{
            var _local2:IInvalidating;
            if (_includeInLayout != _arg1){
                _includeInLayout = _arg1;
                _local2 = (parent as IInvalidating);
                if (_local2){
                    _local2.invalidateSize();
                    _local2.invalidateDisplayList();
                };
                dispatchEvent(new Event("includeInLayoutChanged"));
            };
        }
        public function getClassStyleDeclarations():Array{
            var myApplicationDomain:* = null;
            var cache:* = null;
            var myRoot:* = null;
            var s:* = null;
            var factory:* = ModuleManager.getAssociatedFactory(this);
            if (factory != null){
                myApplicationDomain = ApplicationDomain(factory.info()["currentDomain"]);
            } else {
                myRoot = SystemManager.getSWFRoot(this);
                if (!myRoot){
                    return ([]);
                };
                myApplicationDomain = myRoot.loaderInfo.applicationDomain;
            };
            var className:* = getQualifiedClassName(this);
            className = className.replace("::", ".");
            cache = StyleManager.typeSelectorCache[className];
            if (cache){
                return (cache);
            };
            var decls:* = [];
            var classNames:* = [];
            var caches:* = [];
            var declcache:* = [];
            while (((((!((className == null))) && (!((className == "mx.core.UIComponent"))))) && (!((className == "mx.core.UITextField"))))) {
                cache = StyleManager.typeSelectorCache[className];
                if (cache){
                    decls = decls.concat(cache);
                    break;
                };
                s = StyleManager.getStyleDeclaration(className);
                if (s){
                    decls.unshift(s);
                    classNames.push(className);
                    caches.push(classNames);
                    declcache.push(decls);
                    decls = [];
                    classNames = [];
                } else {
                    classNames.push(className);
                };
                try {
                    className = getQualifiedSuperclassName(myApplicationDomain.getDefinition(className));
                    className = className.replace("::", ".");
                } catch(e:ReferenceError) {
                    className = null;
                };
            };
            caches.push(classNames);
            declcache.push(decls);
            decls = [];
            while (caches.length) {
                classNames = caches.pop();
                decls = decls.concat(declcache.pop());
                while (classNames.length) {
                    StyleManager.typeSelectorCache[classNames.pop()] = decls;
                };
            };
            return (decls);
        }
        public function set measuredMinWidth(_arg1:Number):void{
            _measuredMinWidth = _arg1;
        }
        private function initializeState(_arg1:String):void{
            var _local2:State = getState(_arg1);
            while (_local2) {
                _local2.initialize();
                _local2 = getState(_local2.basedOn);
            };
        }
        mx_internal function initProtoChain():void{
            var _local1:CSSStyleDeclaration;
            var _local7:Object;
            var _local8:CSSStyleDeclaration;
            if (styleName){
                if ((styleName is CSSStyleDeclaration)){
                    _local1 = CSSStyleDeclaration(styleName);
                } else {
                    if ((((styleName is IFlexDisplayObject)) || ((styleName is IStyleClient)))){
                        StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                        return;
                    };
                    if ((styleName is String)){
                        _local1 = StyleManager.getStyleDeclaration(("." + styleName));
                    };
                };
            };
            var _local2:Object = StyleManager.stylesRoot;
            if (((_local2) && (_local2.effects))){
                registerEffects(_local2.effects);
            };
            var _local3:IStyleClient = (parent as IStyleClient);
            if (_local3){
                _local7 = _local3.inheritingStyles;
                if (_local7 == UIComponent.STYLE_UNINITIALIZED){
                    _local7 = _local2;
                };
            } else {
                if (isPopUp){
                    if ((((((FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)) && (_owner))) && ((_owner is IStyleClient)))){
                        _local7 = IStyleClient(_owner).inheritingStyles;
                    } else {
                        _local7 = ApplicationGlobals.application.inheritingStyles;
                    };
                } else {
                    _local7 = StyleManager.stylesRoot;
                };
            };
            var _local4:Array = getClassStyleDeclarations();
            var _local5:int = _local4.length;
            var _local6:int;
            while (_local6 < _local5) {
                _local8 = _local4[_local6];
                _local7 = _local8.addStyleToProtoChain(_local7, this);
                _local2 = _local8.addStyleToProtoChain(_local2, this);
                if (_local8.effects){
                    registerEffects(_local8.effects);
                };
                _local6++;
            };
            if (_local1){
                _local7 = _local1.addStyleToProtoChain(_local7, this);
                _local2 = _local1.addStyleToProtoChain(_local2, this);
                if (_local1.effects){
                    registerEffects(_local1.effects);
                };
            };
            inheritingStyles = ((_styleDeclaration) ? _styleDeclaration.addStyleToProtoChain(_local7, this) : _local7);
            nonInheritingStyles = ((_styleDeclaration) ? _styleDeclaration.addStyleToProtoChain(_local2, this) : _local2);
        }
        public function get repeaterIndices():Array{
            return (((_repeaterIndices) ? _repeaterIndices.slice() : []));
        }
        override public function removeChild(_arg1:DisplayObject):DisplayObject{
            removingChild(_arg1);
            $removeChild(_arg1);
            childRemoved(_arg1);
            return (_arg1);
        }
        private function focusObj_moveHandler(_arg1:MoveEvent):void{
            adjustFocusRect();
        }
        public function get styleDeclaration():CSSStyleDeclaration{
            return (_styleDeclaration);
        }
        override public function get doubleClickEnabled():Boolean{
            return (super.doubleClickEnabled);
        }
        public function contentToLocal(_arg1:Point):Point{
            return (_arg1);
        }
        private function creationCompleteHandler(_arg1:FlexEvent):void{
            if (_currentStateChanged){
                _currentStateChanged = false;
                commitCurrentState();
                validateNow();
            };
            removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        }
        public function set measuredHeight(_arg1:Number):void{
            _measuredHeight = _arg1;
        }
        protected function createChildren():void{
        }
        public function get activeEffects():Array{
            return (_effectsStarted);
        }
        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            if (((overlayReferenceCount) && (!((_arg1 == overlay))))){
                _arg2 = Math.min(_arg2, Math.max(0, (super.numChildren - 2)));
            };
            super.setChildIndex(_arg1, _arg2);
        }
        public function regenerateStyleCache(_arg1:Boolean):void{
            var _local5:DisplayObject;
            initProtoChain();
            var _local2:IChildList = (((this is IRawChildrenContainer)) ? IRawChildrenContainer(this).rawChildren : IChildList(this));
            var _local3:int = _local2.numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = _local2.getChildAt(_local4);
                if ((_local5 is IStyleClient)){
                    if (IStyleClient(_local5).inheritingStyles != UIComponent.STYLE_UNINITIALIZED){
                        IStyleClient(_local5).regenerateStyleCache(_arg1);
                    };
                } else {
                    if ((_local5 is IUITextField)){
                        if (IUITextField(_local5).inheritingStyles){
                            StyleProtoChain.initTextField(IUITextField(_local5));
                        };
                    };
                };
                _local4++;
            };
        }
        public function get updateCompletePendingFlag():Boolean{
            return (_updateCompletePendingFlag);
        }
        protected function focusOutHandler(_arg1:FocusEvent):void{
            if (isOurFocus(DisplayObject(_arg1.target))){
                drawFocus(false);
            };
        }
        public function getFocus():InteractiveObject{
            var _local1:ISystemManager = systemManager;
            if (!_local1){
                return (null);
            };
            if (UIComponentGlobals.nextFocusObject){
                return (UIComponentGlobals.nextFocusObject);
            };
            return (_local1.stage.focus);
        }
        public function endEffectsStarted():void{
            var _local1:int = _effectsStarted.length;
            var _local2:int;
            while (_local2 < _local1) {
                _effectsStarted[_local2].end();
                _local2++;
            };
        }
        protected function get unscaledHeight():Number{
            return ((height / Math.abs(scaleY)));
        }
        public function get enabled():Boolean{
            return (_enabled);
        }
        public function get focusEnabled():Boolean{
            return (_focusEnabled);
        }
        override public function set cacheAsBitmap(_arg1:Boolean):void{
            super.cacheAsBitmap = _arg1;
            cacheAsBitmapCount = ((_arg1) ? 1 : 0);
        }
        mx_internal function removeOverlay():void{
            if ((((((overlayReferenceCount > 0)) && ((--overlayReferenceCount == 0)))) && (overlay))){
                removeEventListener("resize", overlay_resizeHandler);
                if (super.getChildByName("overlay")){
                    $removeChild(overlay);
                };
                overlay = null;
            };
        }
        public function set cacheHeuristic(_arg1:Boolean):void{
            if (_cachePolicy == UIComponentCachePolicy.AUTO){
                if (_arg1){
                    cacheAsBitmapCount++;
                } else {
                    if (cacheAsBitmapCount != 0){
                        cacheAsBitmapCount--;
                    };
                };
                super.cacheAsBitmap = !((cacheAsBitmapCount == 0));
            };
        }
        public function get cachePolicy():String{
            return (_cachePolicy);
        }
        public function set maxHeight(_arg1:Number):void{
            if (explicitMaxHeight == _arg1){
                return;
            };
            explicitMaxHeight = _arg1;
        }
        public function getConstraintValue(_arg1:String){
            return (getStyle(_arg1));
        }
        public function set focusManager(_arg1:IFocusManager):void{
            _focusManager = _arg1;
        }
        public function clearStyle(_arg1:String):void{
            setStyle(_arg1, undefined);
        }
        public function get descriptor():UIComponentDescriptor{
            return (_descriptor);
        }
        public function set nonInheritingStyles(_arg1:Object):void{
            _nonInheritingStyles = _arg1;
        }
        public function get cursorManager():ICursorManager{
            var _local2:ICursorManager;
            var _local1:DisplayObject = parent;
            while (_local1) {
                if ((((_local1 is IUIComponent)) && (("cursorManager" in _local1)))){
                    _local2 = _local1["cursorManager"];
                    return (_local2);
                };
                _local1 = _local1.parent;
            };
            return (CursorManager.getInstance());
        }
        public function set automationDelegate(_arg1:Object):void{
            _automationDelegate = (_arg1 as IAutomationObject);
        }
        public function get measuredMinWidth():Number{
            return (_measuredMinWidth);
        }
        public function createReferenceOnParentDocument(_arg1:IFlexDisplayObject):void{
            var _local2:Array;
            var _local3:Object;
            var _local4:int;
            var _local5:int;
            var _local6:PropertyChangeEvent;
            var _local7:Object;
            if (((id) && (!((id == ""))))){
                _local2 = _instanceIndices;
                if (!_local2){
                    _arg1[id] = this;
                } else {
                    _local3 = _arg1[id];
                    if (!(_local3 is Array)){
                        _local3 = (_arg1[id] = []);
                    };
                    _local4 = _local2.length;
                    _local5 = 0;
                    while (_local5 < (_local4 - 1)) {
                        _local7 = _local3[_local2[_local5]];
                        if (!(_local7 is Array)){
                            _local7 = (_local3[_local2[_local5]] = []);
                        };
                        _local3 = _local7;
                        _local5++;
                    };
                    _local3[_local2[(_local4 - 1)]] = this;
                    _local6 = PropertyChangeEvent.createUpdateEvent(_arg1, id, _arg1[id], _arg1[id]);
                    _arg1.dispatchEvent(_local6);
                };
            };
        }
        public function get repeater():IRepeater{
            return (((_repeaters) ? _repeaters[(_repeaters.length - 1)] : null));
        }
        public function set isPopUp(_arg1:Boolean):void{
            _isPopUp = _arg1;
        }
        public function get measuredHeight():Number{
            return (_measuredHeight);
        }
        public function initialize():void{
            if (initialized){
                return;
            };
            dispatchEvent(new FlexEvent(FlexEvent.PREINITIALIZE));
            createChildren();
            childrenCreated();
            initializeAccessibility();
            initializationComplete();
        }
        override public function set width(_arg1:Number):void{
            var _local2:IInvalidating;
            if (explicitWidth != _arg1){
                explicitWidth = _arg1;
                invalidateSize();
            };
            if (_width != _arg1){
                invalidateProperties();
                invalidateDisplayList();
                _local2 = (parent as IInvalidating);
                if (((_local2) && (includeInLayout))){
                    _local2.invalidateSize();
                    _local2.invalidateDisplayList();
                };
                _width = _arg1;
                dispatchEvent(new Event("widthChanged"));
            };
        }
        public function set percentHeight(_arg1:Number):void{
            if (_percentHeight == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _explicitHeight = NaN;
            };
            _percentHeight = _arg1;
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
        }
        final mx_internal function set $visible(_arg1:Boolean):void{
            super.visible = _arg1;
        }
        private function findCommonBaseState(_arg1:String, _arg2:String):String{
            var _local3:State = getState(_arg1);
            var _local4:State = getState(_arg2);
            if (((!(_local3)) || (!(_local4)))){
                return ("");
            };
            if (((isBaseState(_local3.basedOn)) && (isBaseState(_local4.basedOn)))){
                return ("");
            };
            var _local5:Array = getBaseStates(_local3);
            var _local6:Array = getBaseStates(_local4);
            var _local7 = "";
            while (_local5[(_local5.length - 1)] == _local6[(_local6.length - 1)]) {
                _local7 = _local5.pop();
                _local6.pop();
                if (((!(_local5.length)) || (!(_local6.length)))){
                    break;
                };
            };
            if (((_local5.length) && ((_local5[(_local5.length - 1)] == _local4.name)))){
                _local7 = _local4.name;
            } else {
                if (((_local6.length) && ((_local6[(_local6.length - 1)] == _local3.name)))){
                    _local7 = _local3.name;
                };
            };
            return (_local7);
        }
        mx_internal function childRemoved(_arg1:DisplayObject):void{
            if ((_arg1 is IUIComponent)){
                if (IUIComponent(_arg1).document != _arg1){
                    IUIComponent(_arg1).document = null;
                };
                IUIComponent(_arg1).parentChanged(null);
            };
        }
        final mx_internal function $removeChildAt(_arg1:int):DisplayObject{
            return (super.removeChildAt(_arg1));
        }
        public function get maxHeight():Number{
            return (((isNaN(explicitMaxHeight)) ? DEFAULT_MAX_HEIGHT : explicitMaxHeight));
        }
        protected function initializeAccessibility():void{
            if (UIComponent.createAccessibilityImplementation != null){
                UIComponent.createAccessibilityImplementation(this);
            };
        }
        public function set explicitMaxHeight(_arg1:Number):void{
            if (_explicitMaxHeight == _arg1){
                return;
            };
            _explicitMaxHeight = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitMaxHeightChanged"));
        }
        public function get focusManager():IFocusManager{
            if (_focusManager){
                return (_focusManager);
            };
            var _local1:DisplayObject = parent;
            while (_local1) {
                if ((_local1 is IFocusManagerContainer)){
                    return (IFocusManagerContainer(_local1).focusManager);
                };
                _local1 = _local1.parent;
            };
            return (null);
        }
        public function set styleName(_arg1:Object):void{
            if (_styleName === _arg1){
                return;
            };
            _styleName = _arg1;
            if (inheritingStyles == UIComponent.STYLE_UNINITIALIZED){
                return;
            };
            regenerateStyleCache(true);
            initThemeColor();
            styleChanged("styleName");
            notifyStyleChangeInChildren("styleName", true);
        }
        public function get automationDelegate():Object{
            return (_automationDelegate);
        }
        protected function get resourceManager():IResourceManager{
            return (_resourceManager);
        }
        mx_internal function validateBaselinePosition():Boolean{
            var _local1:Number;
            var _local2:Number;
            if (!parent){
                return (false);
            };
            if ((((width == 0)) && ((height == 0)))){
                validateNow();
                _local1 = getExplicitOrMeasuredWidth();
                _local2 = getExplicitOrMeasuredHeight();
                setActualSize(_local1, _local2);
            };
            validateNow();
            return (true);
        }
        mx_internal function cancelAllCallLaters():void{
            var _local1:ISystemManager = systemManager;
            if (((_local1) && (((_local1.stage) || (_local1.useSWFBridge()))))){
                if (listeningForRender){
                    _local1.removeEventListener(FlexEvent.RENDER, callLaterDispatcher);
                    _local1.removeEventListener(FlexEvent.ENTER_FRAME, callLaterDispatcher);
                    listeningForRender = false;
                };
            };
            methodQueue.splice(0);
        }
        private function updateCompleteHandler(_arg1:FlexEvent):void{
            UIComponentGlobals.layoutManager.removeEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler);
            processEffectFinished(_endingEffectInstances);
            _endingEffectInstances = [];
        }
        public function styleChanged(_arg1:String):void{
            if ((((this is IFontContextComponent)) && (hasFontContextChanged()))){
                invalidateProperties();
            };
            if (((((!(_arg1)) || ((_arg1 == "styleName")))) || (StyleManager.isSizeInvalidatingStyle(_arg1)))){
                invalidateSize();
            };
            if (((((!(_arg1)) || ((_arg1 == "styleName")))) || ((_arg1 == "themeColor")))){
                initThemeColor();
            };
            invalidateDisplayList();
            if ((parent is IInvalidating)){
                if (StyleManager.isParentSizeInvalidatingStyle(_arg1)){
                    IInvalidating(parent).invalidateSize();
                };
                if (StyleManager.isParentDisplayListInvalidatingStyle(_arg1)){
                    IInvalidating(parent).invalidateDisplayList();
                };
            };
        }
        final mx_internal function get $visible():Boolean{
            return (super.visible);
        }
        public function drawRoundRect(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null, _arg6:Object=null, _arg7:Object=null, _arg8:Object=null, _arg9:String=null, _arg10:Array=null, _arg11:Object=null):void{
            var _local13:Number;
            var _local14:Array;
            var _local15:Matrix;
            var _local16:Object;
            var _local12:Graphics = graphics;
            if (((!(_arg3)) || (!(_arg4)))){
                return;
            };
            if (_arg6 !== null){
                if ((_arg6 is Array)){
                    if ((_arg7 is Array)){
                        _local14 = (_arg7 as Array);
                    } else {
                        _local14 = [_arg7, _arg7];
                    };
                    if (!_arg10){
                        _arg10 = [0, 0xFF];
                    };
                    _local15 = null;
                    if (_arg8){
                        if ((_arg8 is Matrix)){
                            _local15 = Matrix(_arg8);
                        } else {
                            _local15 = new Matrix();
                            if ((_arg8 is Number)){
                                _local15.createGradientBox(_arg3, _arg4, ((Number(_arg8) * Math.PI) / 180), _arg1, _arg2);
                            } else {
                                _local15.createGradientBox(_arg8.w, _arg8.h, _arg8.r, _arg8.x, _arg8.y);
                            };
                        };
                    };
                    if (_arg9 == GradientType.RADIAL){
                        _local12.beginGradientFill(GradientType.RADIAL, (_arg6 as Array), _local14, _arg10, _local15);
                    } else {
                        _local12.beginGradientFill(GradientType.LINEAR, (_arg6 as Array), _local14, _arg10, _local15);
                    };
                } else {
                    _local12.beginFill(Number(_arg6), Number(_arg7));
                };
            };
            if (!_arg5){
                _local12.drawRect(_arg1, _arg2, _arg3, _arg4);
            } else {
                if ((_arg5 is Number)){
                    _local13 = (Number(_arg5) * 2);
                    _local12.drawRoundRect(_arg1, _arg2, _arg3, _arg4, _local13, _local13);
                } else {
                    GraphicsUtil.drawRoundRectComplex(_local12, _arg1, _arg2, _arg3, _arg4, _arg5.tl, _arg5.tr, _arg5.bl, _arg5.br);
                };
            };
            if (_arg11){
                _local16 = _arg11.r;
                if ((_local16 is Number)){
                    _local13 = (Number(_local16) * 2);
                    _local12.drawRoundRect(_arg11.x, _arg11.y, _arg11.w, _arg11.h, _local13, _local13);
                } else {
                    GraphicsUtil.drawRoundRectComplex(_local12, _arg11.x, _arg11.y, _arg11.w, _arg11.h, _local16.tl, _local16.tr, _local16.bl, _local16.br);
                };
            };
            if (_arg6 !== null){
                _local12.endFill();
            };
        }
        public function move(_arg1:Number, _arg2:Number):void{
            var _local3:Boolean;
            if (_arg1 != super.x){
                super.x = _arg1;
                dispatchEvent(new Event("xChanged"));
                _local3 = true;
            };
            if (_arg2 != super.y){
                super.y = _arg2;
                dispatchEvent(new Event("yChanged"));
                _local3 = true;
            };
            if (_local3){
                dispatchMoveEvent();
            };
        }
        public function set toolTip(_arg1:String):void{
            var _local2:String = _toolTip;
            _toolTip = _arg1;
            ToolTipManager.registerToolTip(this, _local2, _arg1);
            dispatchEvent(new Event("toolTipChanged"));
        }
        public function set repeaters(_arg1:Array):void{
            _repeaters = _arg1;
        }
        public function get explicitMaxHeight():Number{
            return (_explicitMaxHeight);
        }
        public function measureText(_arg1:String):TextLineMetrics{
            return (determineTextFormatFromStyles().measureText(_arg1));
        }
        public function get styleName():Object{
            return (_styleName);
        }
        protected function createInModuleContext(_arg1:IFlexModuleFactory, _arg2:String):Object{
            var _local3:Object;
            if (_arg1){
                _local3 = _arg1.create(_arg2);
            };
            return (_local3);
        }
        public function get parentDocument():Object{
            var _local1:IUIComponent;
            var _local2:ISystemManager;
            if (document == this){
                _local1 = (parent as IUIComponent);
                if (_local1){
                    return (_local1.document);
                };
                _local2 = (parent as ISystemManager);
                if (_local2){
                    return (_local2.document);
                };
                return (null);
            };
            return (document);
        }
        protected function childrenCreated():void{
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        public function set flexContextMenu(_arg1:IFlexContextMenu):void{
            if (_flexContextMenu){
                _flexContextMenu.unsetContextMenu(this);
            };
            _flexContextMenu = _arg1;
            if (_arg1 != null){
                _flexContextMenu.setContextMenu(this);
            };
        }
        public function set explicitWidth(_arg1:Number):void{
            if (_explicitWidth == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _percentWidth = NaN;
            };
            _explicitWidth = _arg1;
            invalidateSize();
            var _local2:IInvalidating = (parent as IInvalidating);
            if (((_local2) && (includeInLayout))){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitWidthChanged"));
        }
        private function setBorderColorForErrorString():void{
            if (((!(_errorString)) || ((_errorString.length == 0)))){
                if (!isNaN(origBorderColor)){
                    setStyle("borderColor", origBorderColor);
                    saveBorderColor = true;
                };
            } else {
                if (saveBorderColor){
                    saveBorderColor = false;
                    origBorderColor = getStyle("borderColor");
                };
                setStyle("borderColor", getStyle("errorColor"));
            };
            styleChanged("themeColor");
            var _local1:IFocusManager = focusManager;
            var _local2:DisplayObject = ((_local1) ? DisplayObject(_local1.getFocus()) : null);
            if (((((_local1) && (_local1.showFocusIndicator))) && ((_local2 == this)))){
                drawFocus(true);
            };
        }
        public function get explicitWidth():Number{
            return (_explicitWidth);
        }
        public function invalidateSize():void{
            if (!invalidateSizeFlag){
                invalidateSizeFlag = true;
                if (((parent) && (UIComponentGlobals.layoutManager))){
                    UIComponentGlobals.layoutManager.invalidateSize(this);
                };
            };
        }
        public function set measuredMinHeight(_arg1:Number):void{
            _measuredMinHeight = _arg1;
        }
        protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
        }
        override public function set filters(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            var _local4:IEventDispatcher;
            if (_filters){
                _local2 = _filters.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    _local4 = (_filters[_local3] as IEventDispatcher);
                    if (_local4){
                        _local4.removeEventListener("change", filterChangeHandler);
                    };
                    _local3++;
                };
            };
            _filters = _arg1;
            if (_filters){
                _local2 = _filters.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    _local4 = (_filters[_local3] as IEventDispatcher);
                    if (_local4){
                        _local4.addEventListener("change", filterChangeHandler);
                    };
                    _local3++;
                };
            };
            super.filters = _filters;
        }

    }
}//package mx.core 

class MethodQueueElement {

    public var method:Function;
    public var args:Array;

    public function MethodQueueElement(_arg1:Function, _arg2:Array=null){
        this.method = _arg1;
        this.args = _arg2;
    }
}
