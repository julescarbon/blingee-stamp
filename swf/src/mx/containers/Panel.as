package mx.containers {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.core.*;
    import mx.automation.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.effects.*;
    import flash.utils.*;
    import mx.containers.utilityClasses.*;

    public class Panel extends Container implements IConstraintLayout, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const HEADER_PADDING:Number = 14;

        mx_internal static var createAccessibilityImplementation:Function;
        private static var _closeButtonStyleFilters:Object = {
            closeButtonUpSkin:"closeButtonUpSkin",
            closeButtonOverSkin:"closeButtonOverSkin",
            closeButtonDownSkin:"closeButtonDownSkin",
            closeButtonDisabledSkin:"closeButtonDisabledSkin",
            closeButtonSkin:"closeButtonSkin",
            repeatDelay:"repeatDelay",
            repeatInterval:"repeatInterval"
        };

        private var layoutObject:Layout;
        private var _status:String = "";
        private var _titleChanged:Boolean = false;
        mx_internal var titleBarBackground:IFlexDisplayObject;
        private var regX:Number;
        private var regY:Number;
        private var _layout:String = "vertical";
        mx_internal var closeButton:Button;
        private var initializing:Boolean = true;
        private var _title:String = "";
        protected var titleTextField:IUITextField;
        private var _statusChanged:Boolean = false;
        private var autoSetRoundedCorners:Boolean;
        private var _titleIcon:Class;
        private var _constraintRows:Array;
        protected var controlBar:IUIComponent;
        mx_internal var titleIconObject:Object = null;
        protected var titleBar:UIComponent;
        private var panelViewMetrics:EdgeMetrics;
        private var _constraintColumns:Array;
        mx_internal var _showCloseButton:Boolean = false;
        private var checkedForAutoSetRoundedCorners:Boolean;
        private var _titleIconChanged:Boolean = false;
        protected var statusTextField:IUITextField;

        public function Panel(){
            _constraintColumns = [];
            _constraintRows = [];
            super();
            addEventListener("resizeStart", EffectManager.eventHandler, false, EventPriority.EFFECT);
            addEventListener("resizeEnd", EffectManager.eventHandler, false, EventPriority.EFFECT);
            layoutObject = new BoxLayout();
            layoutObject.target = this;
            showInAutomationHierarchy = true;
        }
        private function systemManager_mouseUpHandler(_arg1:MouseEvent):void{
            if (!isNaN(regX)){
                stopDragging();
            };
        }
        mx_internal function getHeaderHeightProxy():Number{
            return (getHeaderHeight());
        }
        override public function getChildIndex(_arg1:DisplayObject):int{
            if (((controlBar) && ((_arg1 == controlBar)))){
                return (numChildren);
            };
            return (super.getChildIndex(_arg1));
        }
        mx_internal function get _controlBar():IUIComponent{
            return (controlBar);
        }
        mx_internal function getTitleBar():UIComponent{
            return (titleBar);
        }
        public function get layout():String{
            return (_layout);
        }
        override protected function createChildren():void{
            var _local1:Class;
            var _local2:IStyleClient;
            var _local3:ISimpleStyleClient;
            super.createChildren();
            if (!titleBar){
                titleBar = new UIComponent();
                titleBar.visible = false;
                titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBar_mouseDownHandler);
                rawChildren.addChild(titleBar);
            };
            if (!titleBarBackground){
                _local1 = getStyle("titleBackgroundSkin");
                if (_local1){
                    titleBarBackground = new (_local1)();
                    _local2 = (titleBarBackground as IStyleClient);
                    if (_local2){
                        _local2.setStyle("backgroundImage", undefined);
                    };
                    _local3 = (titleBarBackground as ISimpleStyleClient);
                    if (_local3){
                        _local3.styleName = this;
                    };
                    titleBar.addChild(DisplayObject(titleBarBackground));
                };
            };
            createTitleTextField(-1);
            createStatusTextField(-1);
            if (!closeButton){
                closeButton = new Button();
                closeButton.styleName = new StyleProxy(this, closeButtonStyleFilters);
                closeButton.upSkinName = "closeButtonUpSkin";
                closeButton.overSkinName = "closeButtonOverSkin";
                closeButton.downSkinName = "closeButtonDownSkin";
                closeButton.disabledSkinName = "closeButtonDisabledSkin";
                closeButton.skinName = "closeButtonSkin";
                closeButton.explicitWidth = (closeButton.explicitHeight = 16);
                closeButton.focusEnabled = false;
                closeButton.visible = false;
                closeButton.enabled = enabled;
                closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
                titleBar.addChild(closeButton);
                closeButton.owner = this;
            };
        }
        public function get constraintColumns():Array{
            return (_constraintColumns);
        }
        override public function set cacheAsBitmap(_arg1:Boolean):void{
            super.cacheAsBitmap = _arg1;
            if (((((((cacheAsBitmap) && (!(contentPane)))) && (!((cachePolicy == UIComponentCachePolicy.OFF))))) && (getStyle("backgroundColor")))){
                createContentPane();
                invalidateDisplayList();
            };
        }
        override public function createComponentsFromDescriptors(_arg1:Boolean=true):void{
            var _local3:Object;
            super.createComponentsFromDescriptors();
            if (numChildren == 0){
                setControlBar(null);
                return;
            };
            var _local2:IUIComponent = IUIComponent(getChildAt((numChildren - 1)));
            if ((_local2 is ControlBar)){
                _local3 = _local2.document;
                if (contentPane){
                    contentPane.removeChild(DisplayObject(_local2));
                } else {
                    removeChild(DisplayObject(_local2));
                };
                _local2.document = _local3;
                rawChildren.addChild(DisplayObject(_local2));
                setControlBar(_local2);
            } else {
                setControlBar(null);
            };
        }
        override protected function layoutChrome(_arg1:Number, _arg2:Number):void{
            var _local9:Number;
            var _local10:Graphics;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            var _local18:Number;
            var _local19:Number;
            var _local20:Number;
            var _local21:Number;
            super.layoutChrome(_arg1, _arg2);
            var _local3:EdgeMetrics = EdgeMetrics.EMPTY;
            var _local4:Number = getStyle("borderThickness");
            if ((((((getQualifiedClassName(border) == "mx.skins.halo::PanelSkin")) && (!((getStyle("borderStyle") == "default"))))) && (_local4))){
                _local3 = new EdgeMetrics(_local4, _local4, _local4, _local4);
            };
            var _local5:EdgeMetrics = (((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) ? borderMetrics : _local3);
            var _local6:Number = _local5.left;
            var _local7:Number = _local5.top;
            var _local8:Number = getHeaderHeight();
            if ((((_local8 > 0)) && ((height >= _local8)))){
                _local9 = ((_arg1 - _local5.left) - _local5.right);
                showTitleBar(true);
                titleBar.mouseChildren = true;
                titleBar.mouseEnabled = true;
                _local10 = titleBar.graphics;
                _local10.clear();
                _local10.beginFill(0xFFFFFF, 0);
                _local10.drawRect(0, 0, _local9, _local8);
                _local10.endFill();
                titleBar.move(_local6, _local7);
                titleBar.setActualSize(_local9, _local8);
                titleBarBackground.move(0, 0);
                IFlexDisplayObject(titleBarBackground).setActualSize(_local9, _local8);
                closeButton.visible = _showCloseButton;
                if (_showCloseButton){
                    closeButton.setActualSize(closeButton.getExplicitOrMeasuredWidth(), closeButton.getExplicitOrMeasuredHeight());
                    closeButton.move(((((_arg1 - _local6) - _local5.right) - 10) - closeButton.getExplicitOrMeasuredWidth()), ((_local8 - closeButton.getExplicitOrMeasuredHeight()) / 2));
                };
                _local11 = 10;
                _local12 = 10;
                if (titleIconObject){
                    _local13 = titleIconObject.height;
                    _local14 = ((_local8 - _local13) / 2);
                    titleIconObject.move(_local11, _local14);
                    _local11 = (_local11 + (titleIconObject.width + 4));
                };
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    _local13 = titleTextField.nonZeroTextHeight;
                } else {
                    _local13 = titleTextField.getUITextFormat().measureText(titleTextField.text).height;
                };
                _local14 = ((_local8 - _local13) / 2);
                _local15 = (_local5.left + _local5.right);
                titleTextField.move(_local11, (_local14 - 1));
                titleTextField.setActualSize(Math.max(0, (((_arg1 - _local11) - _local12) - _local15)), (_local13 + UITextField.TEXT_HEIGHT_PADDING));
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    _local13 = statusTextField.textHeight;
                } else {
                    _local13 = ((statusTextField.text)!="") ? statusTextField.getUITextFormat().measureText(statusTextField.text).height : 0;
                };
                _local14 = ((_local8 - _local13) / 2);
                _local16 = ((((_arg1 - _local12) - 4) - _local15) - statusTextField.textWidth);
                if (_showCloseButton){
                    _local16 = (_local16 - (closeButton.getExplicitOrMeasuredWidth() + 4));
                };
                statusTextField.move(_local16, (_local14 - 1));
                statusTextField.setActualSize((statusTextField.textWidth + 8), (statusTextField.textHeight + UITextField.TEXT_HEIGHT_PADDING));
                _local17 = ((titleTextField.x + titleTextField.textWidth) + 8);
                if (statusTextField.x < _local17){
                    statusTextField.width = Math.max((statusTextField.width - (_local17 - statusTextField.x)), 0);
                    statusTextField.x = _local17;
                };
            } else {
                if (titleBar){
                    showTitleBar(false);
                    titleBar.mouseChildren = false;
                    titleBar.mouseEnabled = false;
                };
            };
            if (controlBar){
                _local18 = controlBar.x;
                _local19 = controlBar.y;
                _local20 = controlBar.width;
                _local21 = controlBar.height;
                controlBar.setActualSize((_arg1 - (_local5.left + _local5.right)), controlBar.getExplicitOrMeasuredHeight());
                controlBar.move(_local5.left, ((_arg2 - _local5.bottom) - controlBar.getExplicitOrMeasuredHeight()));
                if (controlBar.includeInLayout){
                    controlBar.visible = (controlBar.y >= _local5.top);
                };
                if (((((((!((_local18 == controlBar.x))) || (!((_local19 == controlBar.y))))) || (!((_local20 == controlBar.width))))) || (!((_local21 == controlBar.height))))){
                    invalidateDisplayList();
                };
            };
        }
        public function set layout(_arg1:String):void{
            if (_layout != _arg1){
                _layout = _arg1;
                if (layoutObject){
                    layoutObject.target = null;
                };
                if (_layout == ContainerLayout.ABSOLUTE){
                    layoutObject = new CanvasLayout();
                } else {
                    layoutObject = new BoxLayout();
                    if (_layout == ContainerLayout.VERTICAL){
                        BoxLayout(layoutObject).direction = BoxDirection.VERTICAL;
                    } else {
                        BoxLayout(layoutObject).direction = BoxDirection.HORIZONTAL;
                    };
                };
                if (layoutObject){
                    layoutObject.target = this;
                };
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("layoutChanged"));
            };
        }
        public function get constraintRows():Array{
            return (_constraintRows);
        }
        public function get title():String{
            return (_title);
        }
        mx_internal function getTitleTextField():IUITextField{
            return (titleTextField);
        }
        mx_internal function createStatusTextField(_arg1:int):void{
            var _local2:String;
            if (((titleBar) && (!(statusTextField)))){
                statusTextField = IUITextField(createInFontContext(UITextField));
                statusTextField.selectable = false;
                if (_arg1 == -1){
                    titleBar.addChild(DisplayObject(statusTextField));
                } else {
                    titleBar.addChildAt(DisplayObject(statusTextField), _arg1);
                };
                _local2 = getStyle("statusStyleName");
                statusTextField.styleName = _local2;
                statusTextField.text = status;
                statusTextField.enabled = enabled;
            };
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        override protected function measure():void{
            var _local6:Number;
            super.measure();
            layoutObject.measure();
            var _local1:Rectangle = measureHeaderText();
            var _local2:Number = _local1.width;
            var _local3:Number = _local1.height;
            var _local4:EdgeMetrics = (((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) ? borderMetrics : EdgeMetrics.EMPTY);
            _local2 = (_local2 + (_local4.left + _local4.right));
            var _local5:Number = 5;
            _local2 = (_local2 + (_local5 * 2));
            if (titleIconObject){
                _local2 = (_local2 + titleIconObject.width);
            };
            if (closeButton){
                _local2 = (_local2 + (closeButton.getExplicitOrMeasuredWidth() + 6));
            };
            measuredMinWidth = Math.max(_local2, measuredMinWidth);
            measuredWidth = Math.max(_local2, measuredWidth);
            if (((controlBar) && (controlBar.includeInLayout))){
                _local6 = ((controlBar.getExplicitOrMeasuredWidth() + _local4.left) + _local4.right);
                measuredWidth = Math.max(measuredWidth, _local6);
            };
        }
        mx_internal function getControlBar():IUIComponent{
            return (controlBar);
        }
        override public function get viewMetrics():EdgeMetrics{
            var _local2:EdgeMetrics;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local1:EdgeMetrics = super.viewMetrics;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                if (!panelViewMetrics){
                    panelViewMetrics = new EdgeMetrics(0, 0, 0, 0);
                };
                _local1 = panelViewMetrics;
                _local2 = super.viewMetrics;
                _local3 = getStyle("borderThickness");
                _local4 = getStyle("borderThicknessLeft");
                _local5 = getStyle("borderThicknessTop");
                _local6 = getStyle("borderThicknessRight");
                _local7 = getStyle("borderThicknessBottom");
                _local1.left = (_local2.left + ((isNaN(_local4)) ? _local3 : _local4));
                _local1.top = (_local2.top + ((isNaN(_local5)) ? _local3 : _local5));
                _local1.right = (_local2.right + ((isNaN(_local6)) ? _local3 : _local6));
                _local1.bottom = (_local2.bottom + ((isNaN(_local7)) ? ((((controlBar) && (!(isNaN(_local5))))) ? _local5 : ((isNaN(_local4)) ? _local3 : _local4)) : _local7));
                _local8 = getHeaderHeight();
                if (!isNaN(_local8)){
                    _local1.top = (_local1.top + _local8);
                };
                if (((controlBar) && (controlBar.includeInLayout))){
                    _local1.bottom = (_local1.bottom + controlBar.getExplicitOrMeasuredHeight());
                };
            };
            return (_local1);
        }
        private function measureHeaderText():Rectangle{
            var _local3:UITextFormat;
            var _local4:TextLineMetrics;
            var _local1:Number = 20;
            var _local2:Number = 14;
            if (((titleTextField) && (titleTextField.text))){
                titleTextField.validateNow();
                _local3 = titleTextField.getUITextFormat();
                _local4 = _local3.measureText(titleTextField.text, false);
                _local1 = _local4.width;
                _local2 = _local4.height;
            };
            if (((statusTextField) && (statusTextField.text))){
                statusTextField.validateNow();
                _local3 = statusTextField.getUITextFormat();
                _local4 = _local3.measureText(statusTextField.text, false);
                _local1 = Math.max(_local1, _local4.width);
                _local2 = Math.max(_local2, _local4.height);
            };
            return (new Rectangle(0, 0, Math.round(_local1), Math.round(_local2)));
        }
        mx_internal function createTitleTextField(_arg1:int):void{
            var _local2:String;
            if (!titleTextField){
                titleTextField = IUITextField(createInFontContext(UITextField));
                titleTextField.selectable = false;
                if (_arg1 == -1){
                    titleBar.addChild(DisplayObject(titleTextField));
                } else {
                    titleBar.addChildAt(DisplayObject(titleTextField), _arg1);
                };
                _local2 = getStyle("titleStyleName");
                titleTextField.styleName = _local2;
                titleTextField.text = title;
                titleTextField.enabled = enabled;
            };
        }
        private function closeButton_clickHandler(_arg1:MouseEvent):void{
            dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
        }
        private function setControlBar(_arg1:IUIComponent):void{
            if (_arg1 == controlBar){
                return;
            };
            controlBar = _arg1;
            if (!checkedForAutoSetRoundedCorners){
                checkedForAutoSetRoundedCorners = true;
                autoSetRoundedCorners = ((styleDeclaration) ? (styleDeclaration.getStyle("roundedBottomCorners") === undefined) : true);
            };
            if (autoSetRoundedCorners){
                setStyle("roundedBottomCorners", !((controlBar == null)));
            };
            var _local2:String = getStyle("controlBarStyleName");
            if (((_local2) && ((controlBar is ISimpleStyleClient)))){
                ISimpleStyleClient(controlBar).styleName = _local2;
            };
            if (controlBar){
                controlBar.enabled = enabled;
            };
            if ((controlBar is IAutomationObject)){
                IAutomationObject(controlBar).showInAutomationHierarchy = false;
            };
            invalidateViewMetricsAndPadding();
            invalidateSize();
            invalidateDisplayList();
        }
        protected function get closeButtonStyleFilters():Object{
            return (_closeButtonStyleFilters);
        }
        public function set constraintColumns(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            if (_arg1 != _constraintColumns){
                _local2 = _arg1.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    ConstraintColumn(_arg1[_local3]).container = this;
                    _local3++;
                };
                _constraintColumns = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            if (titleTextField){
                titleTextField.enabled = _arg1;
            };
            if (statusTextField){
                statusTextField.enabled = _arg1;
            };
            if (controlBar){
                controlBar.enabled = _arg1;
            };
            if (closeButton){
                closeButton.enabled = _arg1;
            };
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (super.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return (((titleBar.y + titleTextField.y) + titleTextField.baselinePosition));
        }
        protected function stopDragging():void{
            var _local1:DisplayObject = systemManager.getSandboxRoot();
            _local1.removeEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
            _local1.removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
            _local1.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
            regX = NaN;
            regY = NaN;
            systemManager.deployMouseShields(false);
        }
        private function titleBar_mouseDownHandler(_arg1:MouseEvent):void{
            if (_arg1.target == closeButton){
                return;
            };
            if (((((enabled) && (isPopUp))) && (isNaN(regX)))){
                startDragging(_arg1);
            };
        }
        override mx_internal function get usePadding():Boolean{
            return (!((layout == ContainerLayout.ABSOLUTE)));
        }
        override protected function initializeAccessibility():void{
            if (Panel.createAccessibilityImplementation != null){
                Panel.createAccessibilityImplementation(this);
            };
        }
        protected function getHeaderHeight():Number{
            var _local1:Number = getStyle("headerHeight");
            if (isNaN(_local1)){
                _local1 = (measureHeaderText().height + HEADER_PADDING);
            };
            return (_local1);
        }
        public function set constraintRows(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            if (_arg1 != _constraintRows){
                _local2 = _arg1.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    ConstraintRow(_arg1[_local3]).container = this;
                    _local3++;
                };
                _constraintRows = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }
        public function set title(_arg1:String):void{
            _title = _arg1;
            _titleChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateViewMetricsAndPadding();
            dispatchEvent(new Event("titleChanged"));
        }
        private function showTitleBar(_arg1:Boolean):void{
            var _local4:DisplayObject;
            titleBar.visible = _arg1;
            var _local2:int = titleBar.numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = titleBar.getChildAt(_local3);
                _local4.visible = _arg1;
                _local3++;
            };
        }
        override public function styleChanged(_arg1:String):void{
            var _local3:String;
            var _local4:String;
            var _local5:String;
            var _local6:Class;
            var _local7:IStyleClient;
            var _local8:ISimpleStyleClient;
            var _local2:Boolean = ((!(_arg1)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if (((_local2) || ((_arg1 == "titleStyleName")))){
                if (titleTextField){
                    _local3 = getStyle("titleStyleName");
                    titleTextField.styleName = _local3;
                };
            };
            if (((_local2) || ((_arg1 == "statusStyleName")))){
                if (statusTextField){
                    _local4 = getStyle("statusStyleName");
                    statusTextField.styleName = _local4;
                };
            };
            if (((_local2) || ((_arg1 == "controlBarStyleName")))){
                if (((controlBar) && ((controlBar is ISimpleStyleClient)))){
                    _local5 = getStyle("controlBarStyleName");
                    ISimpleStyleClient(controlBar).styleName = _local5;
                };
            };
            if (((_local2) || ((_arg1 == "titleBackgroundSkin")))){
                if (titleBar){
                    _local6 = getStyle("titleBackgroundSkin");
                    if (_local6){
                        if (titleBarBackground){
                            titleBar.removeChild(DisplayObject(titleBarBackground));
                            titleBarBackground = null;
                        };
                        titleBarBackground = new (_local6)();
                        _local7 = (titleBarBackground as IStyleClient);
                        if (_local7){
                            _local7.setStyle("backgroundImage", undefined);
                        };
                        _local8 = (titleBarBackground as ISimpleStyleClient);
                        if (_local8){
                            _local8.styleName = this;
                        };
                        titleBar.addChildAt(DisplayObject(titleBarBackground), 0);
                    };
                };
            };
        }
        mx_internal function getStatusTextField():IUITextField{
            return (statusTextField);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        override protected function commitProperties():void{
            var _local1:int;
            super.commitProperties();
            if (hasFontContextChanged()){
                if (titleTextField){
                    _local1 = titleBar.getChildIndex(DisplayObject(titleTextField));
                    removeTitleTextField();
                    createTitleTextField(_local1);
                    _titleChanged = true;
                };
                if (statusTextField){
                    _local1 = titleBar.getChildIndex(DisplayObject(statusTextField));
                    removeStatusTextField();
                    createStatusTextField(_local1);
                    _statusChanged = true;
                };
            };
            if (_titleChanged){
                _titleChanged = false;
                titleTextField.text = _title;
                if (initialized){
                    layoutChrome(unscaledWidth, unscaledHeight);
                };
            };
            if (_titleIconChanged){
                _titleIconChanged = false;
                if (titleIconObject){
                    titleBar.removeChild(DisplayObject(titleIconObject));
                    titleIconObject = null;
                };
                if (_titleIcon){
                    titleIconObject = new _titleIcon();
                    titleBar.addChild(DisplayObject(titleIconObject));
                };
                if (initialized){
                    layoutChrome(unscaledWidth, unscaledHeight);
                };
            };
            if (_statusChanged){
                _statusChanged = false;
                statusTextField.text = _status;
                if (initialized){
                    layoutChrome(unscaledWidth, unscaledHeight);
                };
            };
        }
        protected function startDragging(_arg1:MouseEvent):void{
            regX = (_arg1.stageX - x);
            regY = (_arg1.stageY - y);
            var _local2:DisplayObject = systemManager.getSandboxRoot();
            _local2.addEventListener(MouseEvent.MOUSE_MOVE, systemManager_mouseMoveHandler, true);
            _local2.addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
            _local2.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
            systemManager.deployMouseShields(true);
        }
        mx_internal function removeStatusTextField():void{
            if (((titleBar) && (statusTextField))){
                titleBar.removeChild(DisplayObject(statusTextField));
                statusTextField = null;
            };
        }
        private function stage_mouseLeaveHandler(_arg1:Event):void{
            if (!isNaN(regX)){
                stopDragging();
            };
        }
        public function set status(_arg1:String):void{
            _status = _arg1;
            _statusChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("statusChanged"));
        }
        public function get titleIcon():Class{
            return (_titleIcon);
        }
        public function get status():String{
            return (_status);
        }
        private function systemManager_mouseMoveHandler(_arg1:MouseEvent):void{
            _arg1.stopImmediatePropagation();
            if (((isNaN(regX)) || (isNaN(regY)))){
                return;
            };
            move((_arg1.stageX - regX), (_arg1.stageY - regY));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            layoutObject.updateDisplayList(_arg1, _arg2);
            if (border){
                border.visible = true;
            };
            titleBar.visible = true;
        }
        mx_internal function removeTitleTextField():void{
            if (((titleBar) && (titleTextField))){
                titleBar.removeChild(DisplayObject(titleTextField));
                titleTextField = null;
            };
        }
        public function set titleIcon(_arg1:Class):void{
            _titleIcon = _arg1;
            _titleIconChanged = true;
            invalidateProperties();
            invalidateSize();
            dispatchEvent(new Event("titleIconChanged"));
        }

    }
}//package mx.containers 
