package mx.controls {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.listClasses.*;
    import flash.utils.*;
    import flash.ui.*;
    import mx.controls.dataGridClasses.*;

    public class Button extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IFocusManagerComponent, IListItemRenderer, IFontContextComponent, IButton {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;
        mx_internal static var TEXT_WIDTH_PADDING:Number = 6;

        mx_internal var _emphasized:Boolean = false;
        mx_internal var extraSpacing:Number = 20;
        private var icons:Array;
        public var selectedField:String = null;
        private var labelChanged:Boolean = false;
        private var skinMeasuredWidth:Number;
        mx_internal var checkedDefaultSkin:Boolean = false;
        private var autoRepeatTimer:Timer;
        mx_internal var disabledIconName:String = "disabledIcon";
        mx_internal var disabledSkinName:String = "disabledSkin";
        mx_internal var checkedDefaultIcon:Boolean = false;
        public var stickyHighlighting:Boolean = false;
        private var enabledChanged:Boolean = false;
        mx_internal var selectedUpIconName:String = "selectedUpIcon";
        mx_internal var selectedUpSkinName:String = "selectedUpSkin";
        mx_internal var upIconName:String = "upIcon";
        mx_internal var upSkinName:String = "upSkin";
        mx_internal var centerContent:Boolean = true;
        mx_internal var buttonOffset:Number = 0;
        private var skinMeasuredHeight:Number;
        private var oldUnscaledWidth:Number;
        mx_internal var downIconName:String = "downIcon";
        mx_internal var _labelPlacement:String = "right";
        mx_internal var downSkinName:String = "downSkin";
        mx_internal var _toggle:Boolean = false;
        private var _phase:String = "up";
        private var toolTipSet:Boolean = false;
        private var _data:Object;
        mx_internal var currentIcon:IFlexDisplayObject;
        mx_internal var currentSkin:IFlexDisplayObject;
        mx_internal var overIconName:String = "overIcon";
        mx_internal var selectedDownIconName:String = "selectedDownIcon";
        mx_internal var overSkinName:String = "overSkin";
        mx_internal var iconName:String = "icon";
        mx_internal var skinName:String = "skin";
        mx_internal var selectedDownSkinName:String = "selectedDownSkin";
        private var skins:Array;
        private var selectedSet:Boolean;
        private var _autoRepeat:Boolean = false;
        private var styleChangedFlag:Boolean = true;
        mx_internal var selectedOverIconName:String = "selectedOverIcon";
        private var _listData:BaseListData;
        mx_internal var selectedOverSkinName:String = "selectedOverSkin";
        protected var textField:IUITextField;
        private var labelSet:Boolean;
        mx_internal var defaultIconUsesStates:Boolean = false;
        mx_internal var defaultSkinUsesStates:Boolean = false;
        mx_internal var toggleChanged:Boolean = false;
        private var emphasizedChanged:Boolean = false;
        private var _label:String = "";
        mx_internal var _selected:Boolean = false;
        mx_internal var selectedDisabledIconName:String = "selectedDisabledIcon";
        mx_internal var selectedDisabledSkinName:String = "selectedDisabledSkin";

        public function Button(){
            skins = [];
            icons = [];
            super();
            mouseChildren = false;
            addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
            addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            addEventListener(MouseEvent.CLICK, clickHandler);
        }
        private function previousVersion_measure():void{
            var bm:* = null;
            var lineMetrics:* = null;
            var paddingLeft:* = NaN;
            var paddingRight:* = NaN;
            var paddingTop:* = NaN;
            var paddingBottom:* = NaN;
            var horizontalGap:* = NaN;
            super.measure();
            var textWidth:* = 0;
            var textHeight:* = 0;
            if (label){
                lineMetrics = measureText(label);
                textWidth = lineMetrics.width;
                textHeight = lineMetrics.height;
                paddingLeft = getStyle("paddingLeft");
                paddingRight = getStyle("paddingRight");
                paddingTop = getStyle("paddingTop");
                paddingBottom = getStyle("paddingBottom");
                textWidth = (textWidth + ((paddingLeft + paddingRight) + getStyle("textIndent")));
                textHeight = (textHeight + (paddingTop + paddingBottom));
            };
            try {
                bm = currentSkin["borderMetrics"];
            } catch(e:Error) {
                bm = new EdgeMetrics(3, 3, 3, 3);
            };
            var tempCurrentIcon:* = getCurrentIcon();
            var iconWidth:* = ((tempCurrentIcon) ? tempCurrentIcon.width : 0);
            var iconHeight:* = ((tempCurrentIcon) ? tempCurrentIcon.height : 0);
            var w:* = 0;
            var h:* = 0;
            if ((((labelPlacement == ButtonLabelPlacement.LEFT)) || ((labelPlacement == ButtonLabelPlacement.RIGHT)))){
                w = (textWidth + iconWidth);
                if (iconWidth != 0){
                    horizontalGap = getStyle("horizontalGap");
                    w = (w + (horizontalGap - 2));
                };
                h = Math.max(textHeight, (iconHeight + 6));
            } else {
                w = Math.max(textWidth, iconWidth);
                h = (textHeight + iconHeight);
                if (iconHeight != 0){
                    h = (h + getStyle("verticalGap"));
                };
            };
            if (bm){
                w = (w + (bm.left + bm.right));
                h = (h + (bm.top + bm.bottom));
            };
            if (((label) && (!((label.length == 0))))){
                w = (w + extraSpacing);
            } else {
                w = (w + 6);
            };
            if (((currentSkin) && (((isNaN(skinMeasuredWidth)) || (isNaN(skinMeasuredHeight)))))){
                skinMeasuredWidth = currentSkin.measuredWidth;
                skinMeasuredHeight = currentSkin.measuredHeight;
            };
            if (!isNaN(skinMeasuredWidth)){
                w = Math.max(skinMeasuredWidth, w);
            };
            if (!isNaN(skinMeasuredHeight)){
                h = Math.max(skinMeasuredHeight, h);
            };
            measuredMinWidth = (measuredWidth = w);
            measuredMinHeight = (measuredHeight = h);
        }
        public function get label():String{
            return (_label);
        }
        mx_internal function getCurrentIconName():String{
            var _local1:String;
            if (!enabled){
                _local1 = ((selected) ? selectedDisabledIconName : disabledIconName);
            } else {
                if (phase == ButtonPhase.UP){
                    _local1 = ((selected) ? selectedUpIconName : upIconName);
                } else {
                    if (phase == ButtonPhase.OVER){
                        _local1 = ((selected) ? selectedOverIconName : overIconName);
                    } else {
                        if (phase == ButtonPhase.DOWN){
                            _local1 = ((selected) ? selectedDownIconName : downIconName);
                        };
                    };
                };
            };
            return (_local1);
        }
        protected function mouseUpHandler(_arg1:MouseEvent):void{
            if (!enabled){
                return;
            };
            phase = ButtonPhase.OVER;
            buttonReleased();
            if (!toggle){
                _arg1.updateAfterEvent();
            };
        }
        override protected function adjustFocusRect(_arg1:DisplayObject=null):void{
            super.adjustFocusRect(((currentSkin) ? this : DisplayObject(currentIcon)));
        }
        mx_internal function set phase(_arg1:String):void{
            _phase = _arg1;
            invalidateSize();
            invalidateDisplayList();
        }
        mx_internal function viewIconForPhase(_arg1:String):IFlexDisplayObject{
            var _local3:IFlexDisplayObject;
            var _local4:Boolean;
            var _local5:String;
            var _local2:Class = Class(getStyle(_arg1));
            if (!_local2){
                _local2 = Class(getStyle(iconName));
                if (defaultIconUsesStates){
                    _arg1 = iconName;
                };
                if (((!(checkedDefaultIcon)) && (_local2))){
                    _local3 = IFlexDisplayObject(new (_local2)());
                    if (((!((_local3 is IProgrammaticSkin))) && ((_local3 is IStateClient)))){
                        defaultIconUsesStates = true;
                        _arg1 = iconName;
                    };
                    if (_local3){
                        checkedDefaultIcon = true;
                    };
                };
            };
            _local3 = IFlexDisplayObject(getChildByName(_arg1));
            if (_local3 == null){
                if (_local2 != null){
                    _local3 = IFlexDisplayObject(new (_local2)());
                    _local3.name = _arg1;
                    if ((_local3 is ISimpleStyleClient)){
                        ISimpleStyleClient(_local3).styleName = this;
                    };
                    addChild(DisplayObject(_local3));
                    _local4 = false;
                    if ((_local3 is IInvalidating)){
                        IInvalidating(_local3).validateNow();
                        _local4 = true;
                    } else {
                        if ((_local3 is IProgrammaticSkin)){
                            IProgrammaticSkin(_local3).validateDisplayList();
                            _local4 = true;
                        };
                    };
                    if (((_local3) && ((_local3 is IUIComponent)))){
                        IUIComponent(_local3).enabled = enabled;
                    };
                    if (_local4){
                        _local3.setActualSize(_local3.measuredWidth, _local3.measuredHeight);
                    };
                    icons.push(_local3);
                };
            };
            if (currentIcon != null){
                currentIcon.visible = false;
            };
            currentIcon = _local3;
            if (((defaultIconUsesStates) && ((currentIcon is IStateClient)))){
                _local5 = "";
                if (!enabled){
                    _local5 = ((selected) ? "selectedDisabled" : "disabled");
                } else {
                    if (phase == ButtonPhase.UP){
                        _local5 = ((selected) ? "selectedUp" : "up");
                    } else {
                        if (phase == ButtonPhase.OVER){
                            _local5 = ((selected) ? "selectedOver" : "over");
                        } else {
                            if (phase == ButtonPhase.DOWN){
                                _local5 = ((selected) ? "selectedDown" : "down");
                            };
                        };
                    };
                };
                IStateClient(currentIcon).currentState = _local5;
            };
            if (currentIcon != null){
                currentIcon.visible = true;
            };
            return (_local3);
        }
        mx_internal function viewSkinForPhase(_arg1:String, _arg2:String):void{
            var _local4:IFlexDisplayObject;
            var _local5:Number;
            var _local6:ISimpleStyleClient;
            var _local3:Class = Class(getStyle(_arg1));
            if (!_local3){
                _local3 = Class(getStyle(skinName));
                if (defaultSkinUsesStates){
                    _arg1 = skinName;
                };
                if (((!(checkedDefaultSkin)) && (_local3))){
                    _local4 = IFlexDisplayObject(new (_local3)());
                    if (((!((_local4 is IProgrammaticSkin))) && ((_local4 is IStateClient)))){
                        defaultSkinUsesStates = true;
                        _arg1 = skinName;
                    };
                    if (_local4){
                        checkedDefaultSkin = true;
                    };
                };
            };
            _local4 = IFlexDisplayObject(getChildByName(_arg1));
            if (!_local4){
                if (_local3){
                    _local4 = IFlexDisplayObject(new (_local3)());
                    _local4.name = _arg1;
                    _local6 = (_local4 as ISimpleStyleClient);
                    if (_local6){
                        _local6.styleName = this;
                    };
                    addChild(DisplayObject(_local4));
                    _local4.setActualSize(unscaledWidth, unscaledHeight);
                    if ((((_local4 is IInvalidating)) && (initialized))){
                        IInvalidating(_local4).validateNow();
                    } else {
                        if ((((_local4 is IProgrammaticSkin)) && (initialized))){
                            IProgrammaticSkin(_local4).validateDisplayList();
                        };
                    };
                    skins.push(_local4);
                };
            };
            if (currentSkin){
                currentSkin.visible = false;
            };
            currentSkin = _local4;
            if (((defaultSkinUsesStates) && ((currentSkin is IStateClient)))){
                IStateClient(currentSkin).currentState = _arg2;
            };
            if (currentSkin){
                currentSkin.visible = true;
            };
            if (enabled){
                if (phase == ButtonPhase.OVER){
                    _local5 = textField.getStyle("textRollOverColor");
                } else {
                    if (phase == ButtonPhase.DOWN){
                        _local5 = textField.getStyle("textSelectedColor");
                    } else {
                        _local5 = textField.getStyle("color");
                    };
                };
                textField.setColor(_local5);
            };
        }
        mx_internal function getTextField():IUITextField{
            return (textField);
        }
        protected function rollOverHandler(_arg1:MouseEvent):void{
            if (phase == ButtonPhase.UP){
                if (_arg1.buttonDown){
                    return;
                };
                phase = ButtonPhase.OVER;
                _arg1.updateAfterEvent();
            } else {
                if (phase == ButtonPhase.OVER){
                    phase = ButtonPhase.DOWN;
                    _arg1.updateAfterEvent();
                    if (autoRepeatTimer){
                        autoRepeatTimer.start();
                    };
                };
            };
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.styleName = this;
                addChild(DisplayObject(textField));
            };
        }
        mx_internal function setSelected(_arg1:Boolean, _arg2:Boolean=false):void{
            if (_selected != _arg1){
                _selected = _arg1;
                invalidateDisplayList();
                if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                    if (toggle){
                        dispatchEvent(new Event(Event.CHANGE));
                    };
                } else {
                    if (((toggle) && (!(_arg2)))){
                        dispatchEvent(new Event(Event.CHANGE));
                    };
                };
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            };
        }
        private function autoRepeatTimer_timerDelayHandler(_arg1:Event):void{
            if (!enabled){
                return;
            };
            dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
            if (autoRepeat){
                autoRepeatTimer.reset();
                autoRepeatTimer.removeEventListener(TimerEvent.TIMER, autoRepeatTimer_timerDelayHandler);
                autoRepeatTimer.delay = getStyle("repeatInterval");
                autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeatTimer_timerHandler);
                autoRepeatTimer.start();
            };
        }
        public function get autoRepeat():Boolean{
            return (_autoRepeat);
        }
        public function set selected(_arg1:Boolean):void{
            selectedSet = true;
            setSelected(_arg1, true);
        }
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            super.focusOutHandler(_arg1);
            if (phase != ButtonPhase.UP){
                phase = ButtonPhase.UP;
            };
        }
        public function get labelPlacement():String{
            return (_labelPlacement);
        }
        public function set autoRepeat(_arg1:Boolean):void{
            _autoRepeat = _arg1;
            if (_arg1){
                autoRepeatTimer = new Timer(1);
            } else {
                autoRepeatTimer = null;
            };
        }
        mx_internal function changeIcons():void{
            var _local1:int = icons.length;
            var _local2:int;
            while (_local2 < _local1) {
                removeChild(icons[_local2]);
                _local2++;
            };
            icons = [];
            checkedDefaultIcon = false;
            defaultIconUsesStates = false;
        }
        public function set data(_arg1:Object):void{
            var _local2:*;
            var _local3:*;
            _data = _arg1;
            if (((((_listData) && ((_listData is DataGridListData)))) && (!((DataGridListData(_listData).dataField == null))))){
                _local2 = _data[DataGridListData(_listData).dataField];
                _local3 = "";
            } else {
                if (_listData){
                    if (selectedField){
                        _local2 = _data[selectedField];
                    };
                    _local3 = _listData.label;
                } else {
                    _local2 = _data;
                };
            };
            if (((!((_local2 === undefined))) && (!(selectedSet)))){
                selected = (_local2 as Boolean);
                selectedSet = false;
            };
            if (((!((_local3 === undefined))) && (!(labelSet)))){
                label = _local3;
                labelSet = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        mx_internal function getCurrentIcon():IFlexDisplayObject{
            var _local1:String = getCurrentIconName();
            if (!_local1){
                return (null);
            };
            return (viewIconForPhase(_local1));
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        public function get emphasized():Boolean{
            return (_emphasized);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        mx_internal function layoutContents(_arg1:Number, _arg2:Number, _arg3:Boolean):void{
            var _local20:TextLineMetrics;
            var _local28:MoveEvent;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                previousVersion_layoutContents(_arg1, _arg2, _arg3);
                return;
            };
            var _local4:Number = 0;
            var _local5:Number = 0;
            var _local6:Number = 0;
            var _local7:Number = 0;
            var _local8:Number = 0;
            var _local9:Number = 0;
            var _local10:Number = 0;
            var _local11:Number = 0;
            var _local12:Number = 0;
            var _local13:Number = 0;
            var _local14:Number = getStyle("paddingLeft");
            var _local15:Number = getStyle("paddingRight");
            var _local16:Number = getStyle("paddingTop");
            var _local17:Number = getStyle("paddingBottom");
            var _local18:Number = 0;
            var _local19:Number = 0;
            if (label){
                _local20 = measureText(label);
                _local18 = (_local20.width + TEXT_WIDTH_PADDING);
                _local19 = (_local20.height + UITextField.TEXT_HEIGHT_PADDING);
            } else {
                _local20 = measureText("Wj");
                _local19 = (_local20.height + UITextField.TEXT_HEIGHT_PADDING);
            };
            var _local21:Number = ((_arg3) ? buttonOffset : 0);
            var _local22:String = getStyle("textAlign");
            var _local23:Number = _arg1;
            var _local24:Number = _arg2;
            var _local25:EdgeMetrics = ((((((currentSkin) && ((currentSkin is IBorder)))) && (!((currentSkin is IFlexAsset))))) ? IBorder(currentSkin).borderMetrics : null);
            if (_local25){
                _local23 = (_local23 - (_local25.left + _local25.right));
                _local24 = (_local24 - (_local25.top + _local25.bottom));
            };
            if (currentIcon){
                _local8 = currentIcon.width;
                _local9 = currentIcon.height;
            };
            if ((((labelPlacement == ButtonLabelPlacement.LEFT)) || ((labelPlacement == ButtonLabelPlacement.RIGHT)))){
                _local12 = getStyle("horizontalGap");
                if ((((_local8 == 0)) || ((_local18 == 0)))){
                    _local12 = 0;
                };
                if (_local18 > 0){
                    _local4 = Math.max(Math.min(((((_local23 - _local8) - _local12) - _local14) - _local15), _local18), 0);
                    textField.width = _local4;
                } else {
                    _local4 = 0;
                    textField.width = _local4;
                };
                _local5 = Math.min(_local24, _local19);
                textField.height = _local5;
                if (_local22 == "left"){
                    _local6 = (_local6 + _local14);
                } else {
                    if (_local22 == "right"){
                        _local6 = (_local6 + ((((_local23 - _local4) - _local8) - _local12) - _local15));
                    } else {
                        _local6 = (_local6 + (((((((_local23 - _local4) - _local8) - _local12) - _local14) - _local15) / 2) + _local14));
                    };
                };
                if (labelPlacement == ButtonLabelPlacement.RIGHT){
                    _local6 = (_local6 + (_local8 + _local12));
                    _local10 = (_local6 - (_local8 + _local12));
                } else {
                    _local10 = ((_local6 + _local4) + _local12);
                };
                _local11 = (((((_local24 - _local9) - _local16) - _local17) / 2) + _local16);
                _local7 = (((((_local24 - _local5) - _local16) - _local17) / 2) + _local16);
            } else {
                _local13 = getStyle("verticalGap");
                if ((((_local9 == 0)) || ((label == "")))){
                    _local13 = 0;
                };
                if (_local18 > 0){
                    _local4 = Math.max(((_local23 - _local14) - _local15), 0);
                    textField.width = _local4;
                    _local5 = Math.min(((((_local24 - _local9) - _local16) - _local17) - _local13), _local19);
                    textField.height = _local5;
                } else {
                    _local4 = 0;
                    textField.width = _local4;
                    _local5 = 0;
                    textField.height = _local5;
                };
                _local6 = _local14;
                if (_local22 == "left"){
                    _local10 = (_local10 + _local14);
                } else {
                    if (_local22 == "right"){
                        _local10 = (_local10 + Math.max(((_local23 - _local8) - _local15), _local14));
                    } else {
                        _local10 = (_local10 + (((((_local23 - _local8) - _local14) - _local15) / 2) + _local14));
                    };
                };
                if (labelPlacement == ButtonLabelPlacement.TOP){
                    _local7 = (_local7 + (((((((_local24 - _local5) - _local9) - _local16) - _local17) - _local13) / 2) + _local16));
                    _local11 = (_local11 + ((_local7 + _local5) + _local13));
                } else {
                    _local11 = (_local11 + (((((((_local24 - _local5) - _local9) - _local16) - _local17) - _local13) / 2) + _local16));
                    _local7 = (_local7 + ((_local11 + _local9) + _local13));
                };
            };
            var _local26:Number = _local21;
            var _local27:Number = _local21;
            if (_local25){
                _local26 = (_local26 + _local25.left);
                _local27 = (_local27 + _local25.top);
            };
            textField.x = Math.round((_local6 + _local26));
            textField.y = Math.round((_local7 + _local27));
            if (currentIcon){
                _local10 = (_local10 + _local26);
                _local11 = (_local11 + _local27);
                _local28 = new MoveEvent(MoveEvent.MOVE);
                _local28.oldX = currentIcon.x;
                _local28.oldY = currentIcon.y;
                currentIcon.x = Math.round(_local10);
                currentIcon.y = Math.round(_local11);
                currentIcon.dispatchEvent(_local28);
            };
            if (currentSkin){
                setChildIndex(DisplayObject(currentSkin), (numChildren - 1));
            };
            if (currentIcon){
                setChildIndex(DisplayObject(currentIcon), (numChildren - 1));
            };
            if (textField){
                setChildIndex(DisplayObject(textField), (numChildren - 1));
            };
        }
        protected function mouseDownHandler(_arg1:MouseEvent):void{
            if (!enabled){
                return;
            };
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
            buttonPressed();
            _arg1.updateAfterEvent();
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            if (!enabled){
                return;
            };
            if (_arg1.keyCode == Keyboard.SPACE){
                buttonPressed();
            };
        }
        protected function rollOutHandler(_arg1:MouseEvent):void{
            if (phase == ButtonPhase.OVER){
                phase = ButtonPhase.UP;
                _arg1.updateAfterEvent();
            } else {
                if ((((phase == ButtonPhase.DOWN)) && (!(stickyHighlighting)))){
                    phase = ButtonPhase.OVER;
                    _arg1.updateAfterEvent();
                    if (autoRepeatTimer){
                        autoRepeatTimer.stop();
                    };
                };
            };
        }
        mx_internal function get phase():String{
            return (_phase);
        }
        override public function set enabled(_arg1:Boolean):void{
            if (super.enabled == _arg1){
                return;
            };
            super.enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        override protected function measure():void{
            var _local9:TextLineMetrics;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                previousVersion_measure();
                return;
            };
            super.measure();
            var _local1:Number = 0;
            var _local2:Number = 0;
            if (label){
                _local9 = measureText(label);
                _local1 = (_local9.width + TEXT_WIDTH_PADDING);
                _local2 = (_local9.height + UITextField.TEXT_HEIGHT_PADDING);
            };
            var _local3:IFlexDisplayObject = getCurrentIcon();
            var _local4:Number = ((_local3) ? _local3.width : 0);
            var _local5:Number = ((_local3) ? _local3.height : 0);
            var _local6:Number = 0;
            var _local7:Number = 0;
            if ((((labelPlacement == ButtonLabelPlacement.LEFT)) || ((labelPlacement == ButtonLabelPlacement.RIGHT)))){
                _local6 = (_local1 + _local4);
                if (((_local1) && (_local4))){
                    _local6 = (_local6 + getStyle("horizontalGap"));
                };
                _local7 = Math.max(_local2, _local5);
            } else {
                _local6 = Math.max(_local1, _local4);
                _local7 = (_local2 + _local5);
                if (((_local2) && (_local5))){
                    _local7 = (_local7 + getStyle("verticalGap"));
                };
            };
            if (((_local1) || (_local4))){
                _local6 = (_local6 + (getStyle("paddingLeft") + getStyle("paddingRight")));
                _local7 = (_local7 + (getStyle("paddingTop") + getStyle("paddingBottom")));
            };
            var _local8:EdgeMetrics = ((((((currentSkin) && ((currentSkin is IBorder)))) && (!((currentSkin is IFlexAsset))))) ? IBorder(currentSkin).borderMetrics : null);
            if (_local8){
                _local6 = (_local6 + (_local8.left + _local8.right));
                _local7 = (_local7 + (_local8.top + _local8.bottom));
            };
            if (((currentSkin) && (((isNaN(skinMeasuredWidth)) || (isNaN(skinMeasuredHeight)))))){
                skinMeasuredWidth = currentSkin.measuredWidth;
                skinMeasuredHeight = currentSkin.measuredHeight;
            };
            if (!isNaN(skinMeasuredWidth)){
                _local6 = Math.max(skinMeasuredWidth, _local6);
            };
            if (!isNaN(skinMeasuredHeight)){
                _local7 = Math.max(skinMeasuredHeight, _local7);
            };
            measuredMinWidth = (measuredWidth = _local6);
            measuredMinHeight = (measuredHeight = _local7);
        }
        public function get toggle():Boolean{
            return (_toggle);
        }
        mx_internal function buttonReleased():void{
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, systemManager_mouseUpHandler, true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, stage_mouseLeaveHandler);
            if (autoRepeatTimer){
                autoRepeatTimer.removeEventListener(TimerEvent.TIMER, autoRepeatTimer_timerDelayHandler);
                autoRepeatTimer.removeEventListener(TimerEvent.TIMER, autoRepeatTimer_timerHandler);
                autoRepeatTimer.reset();
            };
        }
        mx_internal function buttonPressed():void{
            phase = ButtonPhase.DOWN;
            dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
            if (autoRepeat){
                autoRepeatTimer.delay = getStyle("repeatDelay");
                autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeatTimer_timerDelayHandler);
                autoRepeatTimer.start();
            };
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            if (!enabled){
                return;
            };
            if (_arg1.keyCode == Keyboard.SPACE){
                buttonReleased();
                if (phase == ButtonPhase.DOWN){
                    dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                };
                phase = ButtonPhase.UP;
            };
        }
        public function get selected():Boolean{
            return (_selected);
        }
        public function set labelPlacement(_arg1:String):void{
            _labelPlacement = _arg1;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("labelPlacementChanged"));
        }
        protected function clickHandler(_arg1:MouseEvent):void{
            if (!enabled){
                _arg1.stopImmediatePropagation();
                return;
            };
            if (toggle){
                setSelected(!(selected));
                _arg1.updateAfterEvent();
            };
        }
        override protected function initializeAccessibility():void{
            if (Button.createAccessibilityImplementation != null){
                Button.createAccessibilityImplementation(this);
            };
        }
        public function set toggle(_arg1:Boolean):void{
            _toggle = _arg1;
            toggleChanged = true;
            invalidateProperties();
            invalidateDisplayList();
            dispatchEvent(new Event("toggleChanged"));
        }
        override public function get baselinePosition():Number{
            var _local1:String;
            var _local2:TextLineMetrics;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local1 = label;
                if (!_local1){
                    _local1 = "Wj";
                };
                validateNow();
                if (((!(label)) && ((((labelPlacement == ButtonLabelPlacement.TOP)) || ((labelPlacement == ButtonLabelPlacement.BOTTOM)))))){
                    _local2 = measureText(_local1);
                    return ((((measuredHeight - _local2.height) / 2) + _local2.ascent));
                };
                return ((textField.y + measureText(_local1).ascent));
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((textField.y + textField.baselinePosition));
        }
        public function get data():Object{
            return (_data);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        mx_internal function viewSkin():void{
            var _local1:String;
            var _local2:String;
            if (!enabled){
                _local1 = ((selected) ? selectedDisabledSkinName : disabledSkinName);
                _local2 = ((selected) ? "selectedDisabled" : "disabled");
            } else {
                if (phase == ButtonPhase.UP){
                    _local1 = ((selected) ? selectedUpSkinName : upSkinName);
                    _local2 = ((selected) ? "selectedUp" : "up");
                } else {
                    if (phase == ButtonPhase.OVER){
                        _local1 = ((selected) ? selectedOverSkinName : overSkinName);
                        _local2 = ((selected) ? "selectedOver" : "over");
                    } else {
                        if (phase == ButtonPhase.DOWN){
                            _local1 = ((selected) ? selectedDownSkinName : downSkinName);
                            _local2 = ((selected) ? "selectedDown" : "down");
                        };
                    };
                };
            };
            viewSkinForPhase(_local1, _local2);
        }
        override public function styleChanged(_arg1:String):void{
            styleChangedFlag = true;
            super.styleChanged(_arg1);
            if (((!(_arg1)) || ((_arg1 == "styleName")))){
                changeSkins();
                changeIcons();
                if (initialized){
                    viewSkin();
                    viewIcon();
                };
            } else {
                if (_arg1.toLowerCase().indexOf("skin") != -1){
                    changeSkins();
                } else {
                    if (_arg1.toLowerCase().indexOf("icon") != -1){
                        changeIcons();
                        invalidateSize();
                    };
                };
            };
        }
        public function set emphasized(_arg1:Boolean):void{
            _emphasized = _arg1;
            emphasizedChanged = true;
            invalidateDisplayList();
        }
        mx_internal function viewIcon():void{
            var _local1:String = getCurrentIconName();
            viewIconForPhase(_local1);
        }
        override public function set toolTip(_arg1:String):void{
            super.toolTip = _arg1;
            if (_arg1){
                toolTipSet = true;
            } else {
                toolTipSet = false;
                invalidateDisplayList();
            };
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                removeChild(DisplayObject(textField));
                textField = null;
            };
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.styleName = this;
                addChild(DisplayObject(textField));
                enabledChanged = true;
                toggleChanged = true;
            };
            if (!initialized){
                viewSkin();
                viewIcon();
            };
            if (enabledChanged){
                textField.enabled = enabled;
                if (((currentIcon) && ((currentIcon is IUIComponent)))){
                    IUIComponent(currentIcon).enabled = enabled;
                };
                enabledChanged = false;
            };
            if (toggleChanged){
                if (!toggle){
                    selected = false;
                };
                toggleChanged = false;
            };
        }
        mx_internal function changeSkins():void{
            var _local1:int = skins.length;
            var _local2:int;
            while (_local2 < _local1) {
                removeChild(skins[_local2]);
                _local2++;
            };
            skins = [];
            skinMeasuredWidth = NaN;
            skinMeasuredHeight = NaN;
            checkedDefaultSkin = false;
            defaultSkinUsesStates = false;
            if (((initialized) && ((FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)))){
                viewSkin();
                invalidateSize();
            };
        }
        private function autoRepeatTimer_timerHandler(_arg1:Event):void{
            if (!enabled){
                return;
            };
            dispatchEvent(new FlexEvent(FlexEvent.BUTTON_DOWN));
        }
        private function previousVersion_layoutContents(_arg1:Number, _arg2:Number, _arg3:Boolean):void{
            var _local20:TextLineMetrics;
            var _local28:Number;
            var _local29:MoveEvent;
            var _local4:Number = 0;
            var _local5:Number = 0;
            var _local6:Number = 0;
            var _local7:Number = 0;
            var _local8:Number = 0;
            var _local9:Number = 0;
            var _local10:Number = 0;
            var _local11:Number = 0;
            var _local12:Number = 2;
            var _local13:Number = 2;
            var _local14:Number = getStyle("paddingLeft");
            var _local15:Number = getStyle("paddingRight");
            var _local16:Number = getStyle("paddingTop");
            var _local17:Number = getStyle("paddingBottom");
            var _local18:Number = 0;
            var _local19:Number = 0;
            if (label){
                _local20 = measureText(label);
                if (_local20.width > 0){
                    _local18 = (((_local14 + _local15) + getStyle("textIndent")) + _local20.width);
                };
                _local19 = _local20.height;
            } else {
                _local20 = measureText("Wj");
                _local19 = _local20.height;
            };
            var _local21:Number = ((_arg3) ? buttonOffset : 0);
            var _local22:String = getStyle("textAlign");
            var _local23:EdgeMetrics = ((((currentSkin) && ((currentSkin is IRectangularBorder)))) ? IRectangularBorder(currentSkin).borderMetrics : null);
            var _local24:Number = _arg1;
            var _local25:Number = ((_arg2 - _local16) - _local17);
            if (_local23){
                _local24 = (_local24 - (_local23.left + _local23.right));
                _local25 = (_local25 - (_local23.top + _local23.bottom));
            };
            if (currentIcon){
                _local8 = currentIcon.width;
                _local9 = currentIcon.height;
            };
            if ((((labelPlacement == ButtonLabelPlacement.LEFT)) || ((labelPlacement == ButtonLabelPlacement.RIGHT)))){
                _local12 = getStyle("horizontalGap");
                if ((((_local8 == 0)) || ((_local18 == 0)))){
                    _local12 = 0;
                };
                if (_local18 > 0){
                    _local4 = Math.max(((((_local24 - _local8) - _local12) - _local14) - _local15), 0);
                    textField.width = _local4;
                } else {
                    _local4 = 0;
                    textField.width = _local4;
                };
                _local5 = Math.min((_local25 + 2), (_local19 + UITextField.TEXT_HEIGHT_PADDING));
                textField.height = _local5;
                if (labelPlacement == ButtonLabelPlacement.RIGHT){
                    _local6 = (_local8 + _local12);
                    if (centerContent){
                        if (_local22 == "left"){
                            _local6 = (_local6 + _local14);
                        } else {
                            if (_local22 == "right"){
                                _local6 = (_local6 + ((((_local24 - _local4) - _local8) - _local12) - _local14));
                            } else {
                                _local28 = ((((_local24 - _local4) - _local8) - _local12) / 2);
                                _local6 = (_local6 + Math.max(_local28, _local14));
                            };
                        };
                    };
                    _local10 = (_local6 - (_local8 + _local12));
                    if (!centerContent){
                        _local6 = (_local6 + _local14);
                    };
                } else {
                    _local6 = ((((_local24 - _local4) - _local8) - _local12) - _local15);
                    if (centerContent){
                        if (_local22 == "left"){
                            _local6 = 2;
                        } else {
                            if (_local22 == "right"){
                                _local6--;
                            } else {
                                if (_local6 > 0){
                                    _local6 = (_local6 / 2);
                                };
                            };
                        };
                    };
                    _local10 = ((_local6 + _local4) + _local12);
                };
                _local7 = 0;
                _local11 = _local7;
                if (centerContent){
                    _local11 = (Math.round(((_local25 - _local9) / 2)) + _local16);
                    _local7 = (Math.round(((_local25 - _local5) / 2)) + _local16);
                } else {
                    _local7 = (_local7 + (Math.max(0, ((_local25 - _local5) / 2)) + _local16));
                    _local11 = (_local11 + (Math.max(0, (((_local25 - _local9) / 2) - 1)) + _local16));
                };
            } else {
                _local13 = getStyle("verticalGap");
                if ((((_local9 == 0)) || ((_local19 == 0)))){
                    _local13 = 0;
                };
                if (_local18 > 0){
                    _local4 = Math.min(_local24, (_local18 + UITextField.TEXT_WIDTH_PADDING));
                    textField.width = _local4;
                    _local5 = Math.min(((_local25 - _local9) + 1), (_local19 + 5));
                    textField.height = _local5;
                } else {
                    _local4 = 0;
                    textField.width = _local4;
                    _local5 = 0;
                    textField.height = _local5;
                };
                _local6 = ((_local24 - _local4) / 2);
                _local10 = ((_local24 - _local8) / 2);
                if (labelPlacement == ButtonLabelPlacement.TOP){
                    _local7 = (((_local25 - _local5) - _local9) - _local13);
                    if (((centerContent) && ((_local7 > 0)))){
                        _local7 = (_local7 / 2);
                    };
                    _local7 = (_local7 + _local16);
                    _local11 = (((_local7 + _local5) + _local13) - 3);
                } else {
                    _local7 = ((_local9 + _local13) + _local16);
                    if (centerContent){
                        _local7 = (_local7 + (((((_local25 - _local5) - _local9) - _local13) / 2) + 1));
                    };
                    _local11 = (((_local7 - _local9) - _local13) + 3);
                };
            };
            var _local26:Number = _local21;
            var _local27:Number = _local21;
            if (_local23){
                _local26 = (_local26 + _local23.left);
                _local27 = (_local27 + _local23.top);
            };
            textField.x = (_local6 + _local26);
            textField.y = (_local7 + _local27);
            if (currentIcon){
                _local10 = (_local10 + _local26);
                _local11 = (_local11 + _local27);
                _local29 = new MoveEvent(MoveEvent.MOVE);
                _local29.oldX = currentIcon.x;
                _local29.oldY = currentIcon.y;
                currentIcon.x = Math.round(_local10);
                currentIcon.y = Math.round(_local11);
                currentIcon.dispatchEvent(_local29);
            };
            if (currentSkin){
                setChildIndex(DisplayObject(currentSkin), (numChildren - 1));
            };
            if (currentIcon){
                setChildIndex(DisplayObject(currentIcon), (numChildren - 1));
            };
            if (textField){
                setChildIndex(DisplayObject(textField), (numChildren - 1));
            };
        }
        private function systemManager_mouseUpHandler(_arg1:MouseEvent):void{
            if (contains(DisplayObject(_arg1.target))){
                return;
            };
            phase = ButtonPhase.UP;
            buttonReleased();
            _arg1.updateAfterEvent();
        }
        public function set label(_arg1:String):void{
            labelSet = true;
            if (_label != _arg1){
                _label = _arg1;
                labelChanged = true;
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("labelChanged"));
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local5:IFlexDisplayObject;
            var _local6:Boolean;
            super.updateDisplayList(_arg1, _arg2);
            if (emphasizedChanged){
                changeSkins();
                emphasizedChanged = false;
            };
            var _local3:int = skins.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = IFlexDisplayObject(skins[_local4]);
                _local5.setActualSize(_arg1, _arg2);
                _local4++;
            };
            viewSkin();
            viewIcon();
            layoutContents(_arg1, _arg2, (phase == ButtonPhase.DOWN));
            if ((((((((oldUnscaledWidth > _arg1)) || (!((textField.text == label))))) || (labelChanged))) || (styleChangedFlag))){
                textField.text = label;
                _local6 = textField.truncateToFit();
                if (!toolTipSet){
                    if (_local6){
                        super.toolTip = label;
                    } else {
                        super.toolTip = null;
                    };
                };
                styleChangedFlag = false;
                labelChanged = false;
            };
            oldUnscaledWidth = _arg1;
        }
        private function stage_mouseLeaveHandler(_arg1:Event):void{
            phase = ButtonPhase.UP;
            buttonReleased();
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }

    }
}//package mx.controls 
