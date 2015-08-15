package mx.core {
    import flash.display.*;
    import flash.text.*;
    import mx.managers.*;
    import mx.automation.*;
    import flash.events.*;
    import mx.resources.*;
    import mx.styles.*;
    import flash.utils.*;
    import mx.utils.*;

    public class UITextField extends FlexTextField implements IAutomationObject, IIMESupport, IFlexModule, IInvalidating, ISimpleStyleClient, IToolTipManagerClient, IUITextField {

        mx_internal static const TEXT_WIDTH_PADDING:int = 5;
        mx_internal static const TEXT_HEIGHT_PADDING:int = 4;
        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var truncationIndicatorResource:String;
        private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
        mx_internal static var debuggingBorders:Boolean = false;

        private var _enabled:Boolean = true;
        private var untruncatedText:String;
        private var cachedEmbeddedFont:EmbeddedFont = null;
        private var cachedTextFormat:TextFormat;
        private var _automationDelegate:IAutomationObject;
        private var _automationName:String;
        private var _styleName:Object;
        private var _document:Object;
        mx_internal var _toolTip:String;
        private var _nestLevel:int = 0;
        private var _explicitHeight:Number;
        private var _moduleFactory:IFlexModuleFactory;
        private var _initialized:Boolean = false;
        private var _nonInheritingStyles:Object;
        private var _inheritingStyles:Object;
        private var _includeInLayout:Boolean = true;
        private var invalidateDisplayListFlag:Boolean = true;
        mx_internal var explicitColor:uint = 0xFFFFFFFF;
        private var _processedDescriptors:Boolean = true;
        private var _updateCompletePendingFlag:Boolean = false;
        private var explicitHTMLText:String = null;
        mx_internal var _parent:DisplayObjectContainer;
        private var _imeMode:String = null;
        private var resourceManager:IResourceManager;
        mx_internal var styleChangedFlag:Boolean = true;
        private var _ignorePadding:Boolean = true;
        private var _owner:DisplayObjectContainer;
        private var _explicitWidth:Number;

        public function UITextField(){
            resourceManager = ResourceManager.getInstance();
            _inheritingStyles = UIComponent.STYLE_UNINITIALIZED;
            _nonInheritingStyles = UIComponent.STYLE_UNINITIALIZED;
            super();
            super.text = "";
            focusRect = false;
            selectable = false;
            tabEnabled = false;
            if (debuggingBorders){
                border = true;
            };
            if (!truncationIndicatorResource){
                truncationIndicatorResource = resourceManager.getString("core", "truncationIndicator");
            };
            addEventListener(Event.CHANGE, changeHandler);
            addEventListener("textFieldStyleChange", textFieldStyleChangeHandler);
            resourceManager.addEventListener(Event.CHANGE, resourceManager_changeHandler, false, 0, true);
        }
        private static function get embeddedFontRegistry():IEmbeddedFontRegistry{
            if (!_embeddedFontRegistry){
                _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            };
            return (_embeddedFontRegistry);
        }

        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        public function get nestLevel():int{
            return (_nestLevel);
        }
        private function textFieldStyleChangeHandler(_arg1:Event):void{
            if (explicitHTMLText != null){
                super.htmlText = explicitHTMLText;
            };
        }
        public function truncateToFit(_arg1:String=null):Boolean{
            var _local4:String;
            if (!_arg1){
                _arg1 = truncationIndicatorResource;
            };
            validateNow();
            var _local2:String = super.text;
            untruncatedText = _local2;
            var _local3:Number = width;
            if (((!((_local2 == ""))) && (((textWidth + TEXT_WIDTH_PADDING) > (_local3 + 1E-14))))){
                var _local5 = _local2;
                super.text = _local5;
                _local4 = _local5;
                _local2.slice(0, Math.floor(((_local3 / (textWidth + TEXT_WIDTH_PADDING)) * _local2.length)));
                while ((((_local4.length > 1)) && (((textWidth + TEXT_WIDTH_PADDING) > _local3)))) {
                    _local4 = _local4.slice(0, -1);
                    super.text = (_local4 + _arg1);
                };
                return (true);
            };
            return (false);
        }
        public function set nestLevel(_arg1:int):void{
            if ((((_arg1 > 1)) && (!((_nestLevel == _arg1))))){
                _nestLevel = _arg1;
                StyleProtoChain.initTextField(this);
                styleChangedFlag = true;
                validateNow();
            };
        }
        public function get minHeight():Number{
            return (0);
        }
        public function getExplicitOrMeasuredHeight():Number{
            return (((isNaN(explicitHeight)) ? measuredHeight : explicitHeight));
        }
        public function getStyle(_arg1:String){
            if (StyleManager.inheritingStyles[_arg1]){
                return (((inheritingStyles) ? inheritingStyles[_arg1] : IStyleClient(parent).getStyle(_arg1)));
            };
            return (((nonInheritingStyles) ? nonInheritingStyles[_arg1] : IStyleClient(parent).getStyle(_arg1)));
        }
        public function get className():String{
            var _local1:String = getQualifiedClassName(this);
            var _local2:int = _local1.indexOf("::");
            if (_local2 != -1){
                _local1 = _local1.substr((_local2 + 2));
            };
            return (_local1);
        }
        public function setColor(_arg1:uint):void{
            explicitColor = _arg1;
            styleChangedFlag = true;
            invalidateDisplayListFlag = true;
            validateNow();
        }
        override public function replaceText(_arg1:int, _arg2:int, _arg3:String):void{
            super.replaceText(_arg1, _arg2, _arg3);
            dispatchEvent(new Event("textReplace"));
        }
        private function creatingSystemManager():ISystemManager{
            return (((((!((moduleFactory == null))) && ((moduleFactory is ISystemManager)))) ? ISystemManager(moduleFactory) : systemManager));
        }
        public function set document(_arg1:Object):void{
            _document = _arg1;
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
        public function get explicitMinHeight():Number{
            return (NaN);
        }
        public function get focusPane():Sprite{
            return (null);
        }
        public function getTextStyles():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.align = getStyle("textAlign");
            _local1.bold = (getStyle("fontWeight") == "bold");
            if (enabled){
                if (explicitColor == StyleManager.NOT_A_COLOR){
                    _local1.color = getStyle("color");
                } else {
                    _local1.color = explicitColor;
                };
            } else {
                _local1.color = getStyle("disabledColor");
            };
            _local1.font = StringUtil.trimArrayElements(getStyle("fontFamily"), ",");
            _local1.indent = getStyle("textIndent");
            _local1.italic = (getStyle("fontStyle") == "italic");
            _local1.kerning = getStyle("kerning");
            _local1.leading = getStyle("leading");
            _local1.leftMargin = ((ignorePadding) ? 0 : getStyle("paddingLeft"));
            _local1.letterSpacing = getStyle("letterSpacing");
            _local1.rightMargin = ((ignorePadding) ? 0 : getStyle("paddingRight"));
            _local1.size = getStyle("fontSize");
            _local1.underline = (getStyle("textDecoration") == "underline");
            cachedTextFormat = _local1;
            return (_local1);
        }
        override public function set text(_arg1:String):void{
            if (!_arg1){
                _arg1 = "";
            };
            if (((!(isHTML)) && ((super.text == _arg1)))){
                return;
            };
            super.text = _arg1;
            explicitHTMLText = null;
            if (invalidateDisplayListFlag){
                validateNow();
            };
        }
        public function getExplicitOrMeasuredWidth():Number{
            return (((isNaN(explicitWidth)) ? measuredWidth : explicitWidth));
        }
        public function get showInAutomationHierarchy():Boolean{
            return (true);
        }
        public function set automationName(_arg1:String):void{
            _automationName = _arg1;
        }
        public function get systemManager():ISystemManager{
            var _local2:IUIComponent;
            var _local1:DisplayObject = parent;
            while (_local1) {
                _local2 = (_local1 as IUIComponent);
                if (_local2){
                    return (_local2.systemManager);
                };
                _local1 = _local1.parent;
            };
            return (null);
        }
        public function setStyle(_arg1:String, _arg2):void{
        }
        public function get percentWidth():Number{
            return (NaN);
        }
        public function get explicitHeight():Number{
            return (_explicitHeight);
        }
        public function get baselinePosition():Number{
            var _local1:TextLineMetrics;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local1 = getLineMetrics(0);
                return (((height - 4) - _local1.descent));
            };
            if (!parent){
                return (NaN);
            };
            var _local2 = (text == "");
            if (_local2){
                super.text = "Wj";
            };
            _local1 = getLineMetrics(0);
            if (_local2){
                super.text = "";
            };
            return ((2 + _local1.ascent));
        }
        public function set enabled(_arg1:Boolean):void{
            mouseEnabled = _arg1;
            _enabled = _arg1;
            styleChanged("color");
        }
        public function get minWidth():Number{
            return (0);
        }
        public function get automationValue():Array{
            if (automationDelegate){
                return (automationDelegate.automationValue);
            };
            return ([""]);
        }
        public function get tweeningProperties():Array{
            return (null);
        }
        public function get measuredWidth():Number{
            validateNow();
            if (!stage){
                return ((textWidth + TEXT_WIDTH_PADDING));
            };
            return (((textWidth * transform.concatenatedMatrix.d) + TEXT_WIDTH_PADDING));
        }
        public function set tweeningProperties(_arg1:Array):void{
        }
        public function createAutomationIDPart(_arg1:IAutomationObject):Object{
            return (null);
        }
        override public function get parent():DisplayObjectContainer{
            return (((_parent) ? _parent : super.parent));
        }
        public function set updateCompletePendingFlag(_arg1:Boolean):void{
            _updateCompletePendingFlag = _arg1;
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            if (width != _arg1){
                width = _arg1;
            };
            if (height != _arg2){
                height = _arg2;
            };
        }
        public function get numAutomationChildren():int{
            return (0);
        }
        public function set focusPane(_arg1:Sprite):void{
        }
        public function getAutomationChildAt(_arg1:int):IAutomationObject{
            return (null);
        }
        public function get inheritingStyles():Object{
            return (_inheritingStyles);
        }
        public function get owner():DisplayObjectContainer{
            return (((_owner) ? _owner : parent));
        }
        public function parentChanged(_arg1:DisplayObjectContainer):void{
            if (!_arg1){
                _parent = null;
                _nestLevel = 0;
            } else {
                if ((_arg1 is IStyleClient)){
                    _parent = _arg1;
                } else {
                    if ((_arg1 is SystemManager)){
                        _parent = _arg1;
                    } else {
                        _parent = _arg1.parent;
                    };
                };
            };
        }
        public function get processedDescriptors():Boolean{
            return (_processedDescriptors);
        }
        public function get maxWidth():Number{
            return (UIComponent.DEFAULT_MAX_WIDTH);
        }
        private function getEmbeddedFont(_arg1:String, _arg2:Boolean, _arg3:Boolean):EmbeddedFont{
            if (cachedEmbeddedFont){
                if ((((cachedEmbeddedFont.fontName == _arg1)) && ((cachedEmbeddedFont.fontStyle == EmbeddedFontRegistry.getFontStyle(_arg2, _arg3))))){
                    return (cachedEmbeddedFont);
                };
            };
            cachedEmbeddedFont = new EmbeddedFont(_arg1, _arg2, _arg3);
            return (cachedEmbeddedFont);
        }
        public function get initialized():Boolean{
            return (_initialized);
        }
        public function invalidateDisplayList():void{
            invalidateDisplayListFlag = true;
        }
        public function invalidateProperties():void{
        }
        override public function insertXMLText(_arg1:int, _arg2:int, _arg3:String, _arg4:Boolean=false):void{
            super.insertXMLText(_arg1, _arg2, _arg3, _arg4);
            dispatchEvent(new Event("textInsert"));
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
            };
        }
        override public function set htmlText(_arg1:String):void{
            if (!_arg1){
                _arg1 = "";
            };
            if (((isHTML) && ((super.htmlText == _arg1)))){
                return;
            };
            if (((cachedTextFormat) && ((styleSheet == null)))){
                defaultTextFormat = cachedTextFormat;
            };
            super.htmlText = _arg1;
            explicitHTMLText = _arg1;
            if (invalidateDisplayListFlag){
                validateNow();
            };
        }
        public function set showInAutomationHierarchy(_arg1:Boolean):void{
        }
        private function resourceManager_changeHandler(_arg1:Event):void{
            truncationIndicatorResource = resourceManager.getString("core", "truncationIndicator");
            if (untruncatedText != null){
                super.text = untruncatedText;
                truncateToFit();
            };
        }
        public function set measuredMinWidth(_arg1:Number):void{
        }
        public function set explicitHeight(_arg1:Number):void{
            _explicitHeight = _arg1;
        }
        public function get explicitMinWidth():Number{
            return (NaN);
        }
        public function set percentWidth(_arg1:Number):void{
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        public function get moduleFactory():IFlexModuleFactory{
            return (_moduleFactory);
        }
        public function set systemManager(_arg1:ISystemManager):void{
        }
        public function get explicitMaxWidth():Number{
            return (NaN);
        }
        public function get document():Object{
            return (_document);
        }
        public function get updateCompletePendingFlag():Boolean{
            return (_updateCompletePendingFlag);
        }
        public function replayAutomatableEvent(_arg1:Event):Boolean{
            if (automationDelegate){
                return (automationDelegate.replayAutomatableEvent(_arg1));
            };
            return (false);
        }
        public function get enabled():Boolean{
            return (_enabled);
        }
        public function set owner(_arg1:DisplayObjectContainer):void{
            _owner = _arg1;
        }
        public function get automationTabularData():Object{
            return (null);
        }
        public function set nonInheritingStyles(_arg1:Object):void{
            _nonInheritingStyles = _arg1;
        }
        public function get includeInLayout():Boolean{
            return (_includeInLayout);
        }
        public function get measuredMinWidth():Number{
            return (0);
        }
        public function set isPopUp(_arg1:Boolean):void{
        }
        public function set automationDelegate(_arg1:Object):void{
            _automationDelegate = (_arg1 as IAutomationObject);
        }
        public function get measuredHeight():Number{
            validateNow();
            if (!stage){
                return ((textHeight + TEXT_HEIGHT_PADDING));
            };
            return (((textHeight * transform.concatenatedMatrix.a) + TEXT_HEIGHT_PADDING));
        }
        public function set processedDescriptors(_arg1:Boolean):void{
            _processedDescriptors = _arg1;
        }
        public function setFocus():void{
            systemManager.stage.focus = this;
        }
        public function initialize():void{
        }
        public function set percentHeight(_arg1:Number):void{
        }
        public function resolveAutomationIDPart(_arg1:Object):Array{
            return ([]);
        }
        public function set inheritingStyles(_arg1:Object):void{
            _inheritingStyles = _arg1;
        }
        public function getUITextFormat():UITextFormat{
            validateNow();
            var _local1:UITextFormat = new UITextFormat(creatingSystemManager());
            _local1.moduleFactory = moduleFactory;
            _local1.copyFrom(getTextFormat());
            _local1.antiAliasType = antiAliasType;
            _local1.gridFitType = gridFitType;
            _local1.sharpness = sharpness;
            _local1.thickness = thickness;
            return (_local1);
        }
        private function changeHandler(_arg1:Event):void{
            explicitHTMLText = null;
        }
        public function set initialized(_arg1:Boolean):void{
            _initialized = _arg1;
        }
        public function get nonZeroTextHeight():Number{
            var _local1:Number;
            if (super.text == ""){
                super.text = "Wj";
                _local1 = textHeight;
                super.text = "";
                return (_local1);
            };
            return (textHeight);
        }
        public function owns(_arg1:DisplayObject):Boolean{
            return ((_arg1 == this));
        }
        override public function setTextFormat(_arg1:TextFormat, _arg2:int=-1, _arg3:int=-1):void{
            if (styleSheet){
                return;
            };
            super.setTextFormat(_arg1, _arg2, _arg3);
            dispatchEvent(new Event("textFormatChange"));
        }
        public function get nonInheritingStyles():Object{
            return (_nonInheritingStyles);
        }
        public function setVisible(_arg1:Boolean, _arg2:Boolean=false):void{
            this.visible = _arg1;
        }
        public function get maxHeight():Number{
            return (UIComponent.DEFAULT_MAX_HEIGHT);
        }
        public function get automationDelegate():Object{
            return (_automationDelegate);
        }
        public function get isPopUp():Boolean{
            return (false);
        }
        public function set ignorePadding(_arg1:Boolean):void{
            _ignorePadding = _arg1;
            styleChanged(null);
        }
        public function set styleName(_arg1:Object):void{
            if (_styleName === _arg1){
                return;
            };
            _styleName = _arg1;
            if (parent){
                StyleProtoChain.initTextField(this);
                styleChanged("styleName");
            };
        }
        public function styleChanged(_arg1:String):void{
            styleChangedFlag = true;
            if (!invalidateDisplayListFlag){
                invalidateDisplayListFlag = true;
                if (("callLater" in parent)){
                    Object(parent).callLater(validateNow);
                };
            };
        }
        public function get percentHeight():Number{
            return (NaN);
        }
        private function get isHTML():Boolean{
            return (!((explicitHTMLText == null)));
        }
        public function get explicitMaxHeight():Number{
            return (NaN);
        }
        public function get styleName():Object{
            return (_styleName);
        }
        public function set explicitWidth(_arg1:Number):void{
            _explicitWidth = _arg1;
        }
        public function validateNow():void{
            var _local1:TextFormat;
            var _local2:EmbeddedFont;
            var _local3:IFlexModuleFactory;
            var _local4:ISystemManager;
            if (!parent){
                return;
            };
            if (((!(isNaN(explicitWidth))) && (!((super.width == explicitWidth))))){
                super.width = ((explicitWidth)>4) ? explicitWidth : 4;
            };
            if (((!(isNaN(explicitHeight))) && (!((super.height == explicitHeight))))){
                super.height = explicitHeight;
            };
            if (styleChangedFlag){
                _local1 = getTextStyles();
                if (_local1.font){
                    _local2 = getEmbeddedFont(_local1.font, _local1.bold, _local1.italic);
                    _local3 = embeddedFontRegistry.getAssociatedModuleFactory(_local2, moduleFactory);
                    if (_local3 != null){
                        embedFonts = true;
                    } else {
                        _local4 = creatingSystemManager();
                        embedFonts = ((!((_local4 == null))) && (_local4.isFontFaceEmbedded(_local1)));
                    };
                } else {
                    embedFonts = getStyle("embedFonts");
                };
                if (getStyle("fontAntiAliasType") != undefined){
                    antiAliasType = getStyle("fontAntiAliasType");
                    gridFitType = getStyle("fontGridFitType");
                    sharpness = getStyle("fontSharpness");
                    thickness = getStyle("fontThickness");
                };
                if (!styleSheet){
                    super.setTextFormat(_local1);
                    defaultTextFormat = _local1;
                };
                dispatchEvent(new Event("textFieldStyleChange"));
            };
            styleChangedFlag = false;
            invalidateDisplayListFlag = false;
        }
        public function set toolTip(_arg1:String):void{
            var _local2:String = _toolTip;
            _toolTip = _arg1;
            ToolTipManager.registerToolTip(this, _local2, _arg1);
        }
        public function move(_arg1:Number, _arg2:Number):void{
            if (this.x != _arg1){
                this.x = _arg1;
            };
            if (this.y != _arg2){
                this.y = _arg2;
            };
        }
        public function get toolTip():String{
            return (_toolTip);
        }
        public function get ignorePadding():Boolean{
            return (_ignorePadding);
        }
        public function get explicitWidth():Number{
            return (_explicitWidth);
        }
        public function invalidateSize():void{
            invalidateDisplayListFlag = true;
        }
        public function set measuredMinHeight(_arg1:Number):void{
        }
        public function get measuredMinHeight():Number{
            return (0);
        }
        public function set moduleFactory(_arg1:IFlexModuleFactory):void{
            _moduleFactory = _arg1;
        }

    }
}//package mx.core 
