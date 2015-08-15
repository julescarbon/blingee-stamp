package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.containers.*;
    import flash.ui.*;
    import mx.controls.buttonBarClasses.*;

    public class ButtonBar extends NavBar implements IFocusManagerComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal var simulatedClickTriggerEvent:Event = null;
        mx_internal var focusedIndex:int = 0;
        private var directionChanged:Boolean = false;
        mx_internal var buttonWidthProp:String = "buttonWidth";
        private var oldUnscaledHeight:Number;
        mx_internal var buttonStyleNameProp:String = "buttonStyleName";
        mx_internal var lastButtonStyleNameProp:String = "lastButtonStyleName";
        private var recalcButtonWidths:Boolean = false;
        private var oldUnscaledWidth:Number;
        private var recalcButtonHeights:Boolean = false;
        mx_internal var buttonHeightProp:String = "buttonHeight";
        mx_internal var firstButtonStyleNameProp:String = "firstButtonStyleName";

        public function ButtonBar(){
            tabEnabled = true;
            navItemFactory = new ClassFactory(ButtonBarButton);
            addEventListener("scaleXChanged", scaleChangedHandler);
            addEventListener("scaleYChanged", scaleChangedHandler);
            addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
        }
        override public function get borderMetrics():EdgeMetrics{
            return (EdgeMetrics.EMPTY);
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
            var _local2:Button;
            if (_arg1.eventPhase != EventPhase.AT_TARGET){
                return;
            };
            switch (_arg1.keyCode){
                case Keyboard.SPACE:
                    if (focusedIndex != -1){
                        _local2 = Button(getChildAt(focusedIndex));
                        _local2.dispatchEvent(_arg1);
                    };
                    _arg1.stopPropagation();
                    break;
            };
        }
        mx_internal function nextIndex(_arg1:int):int{
            var _local2:int = numChildren;
            if (_local2 == 0){
                return (-1);
            };
            return ((((_arg1 == (_local2 - 1))) ? 0 : (_arg1 + 1)));
        }
        private function calcFullWidth():Number{
            var _local6:Number;
            var _local8:Number;
            var _local1:int = numChildren;
            var _local2:Number = 0;
            if (_local1 == 0){
                return (0);
            };
            if (_local1 > 1){
                _local2 = getStyle("horizontalGap");
            };
            var _local3 = (direction == BoxDirection.HORIZONTAL);
            var _local4:Number = getStyle(buttonWidthProp);
            var _local5:IUIComponent = IUIComponent(getChildAt(0));
            if (_local4){
                _local6 = ((isNaN(_local5.explicitWidth)) ? _local4 : _local5.explicitWidth);
            } else {
                _local6 = _local5.getExplicitOrMeasuredWidth();
            };
            var _local7 = 1;
            while (_local7 < _local1) {
                _local5 = IUIComponent(getChildAt(_local7));
                if (_local4){
                    _local8 = ((isNaN(_local5.explicitWidth)) ? _local4 : _local5.explicitWidth);
                } else {
                    _local8 = _local5.getExplicitOrMeasuredWidth();
                };
                if (_local3){
                    _local6 = (_local6 + (_local2 + _local8));
                } else {
                    _local6 = Math.max(_local6, _local8);
                };
                _local7++;
            };
            return (_local6);
        }
        override protected function clickHandler(_arg1:MouseEvent):void{
            if (simulatedClickTriggerEvent == null){
                focusedIndex = getChildIndex(DisplayObject(_arg1.currentTarget));
                drawButtonFocus(focusedIndex, true);
            };
            super.clickHandler(_arg1);
        }
        override protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            var _local8:CSSStyleDeclaration;
            var _local9:Boolean;
            var _local10:Button;
            var _local3:Button = Button(navItemFactory.newInstance());
            _local3.focusEnabled = false;
            var _local4:String = getStyle(buttonStyleNameProp);
            var _local5:String = getStyle(firstButtonStyleNameProp);
            var _local6:String = getStyle(lastButtonStyleNameProp);
            if (!_local4){
                _local4 = "ButtonBarButton";
            };
            if (!_local5){
                _local5 = _local4;
            };
            if (!_local6){
                _local6 = _local4;
            };
            var _local7:int = numChildren;
            if (_local7 == 0){
                _local3.styleName = _local4;
            } else {
                _local3.styleName = _local6;
                _local8 = StyleManager.getStyleDeclaration(("." + _local6));
                if (((_local8) && (!(_local8.getStyle("focusRoundedCorners"))))){
                    _local3.setStyle("focusRoundedCorners", "tr br");
                };
                _local9 = (_local7 == 1);
                _local10 = Button(getChildAt(((_local9) ? 0 : (_local7 - 1))));
                if (_local9){
                    _local10.styleName = _local5;
                    _local8 = StyleManager.getStyleDeclaration(("." + _local5));
                    if (((_local8) && (!(_local8.getStyle("focusRoundedCorners"))))){
                        _local10.setStyle("focusRoundedCorners", "tl bl");
                    };
                } else {
                    _local10.styleName = _local4;
                    _local8 = StyleManager.getStyleDeclaration(("." + _local4));
                    if (((_local8) && (!(_local8.getStyle("focusRoundedCorners"))))){
                        _local10.setStyle("focusRoundedCorners", "");
                    };
                };
                _local10.changeSkins();
                _local10.invalidateDisplayList();
            };
            _local3.label = _arg1;
            _local3.setStyle("icon", _arg2);
            _local3.addEventListener(MouseEvent.CLICK, clickHandler);
            addChild(_local3);
            recalcButtonWidths = (recalcButtonHeights = true);
            return (_local3);
        }
        override public function styleChanged(_arg1:String):void{
            var _local3:String;
            var _local4:String;
            var _local5:String;
            var _local6:String;
            var _local7:int;
            var _local8:int;
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if (((((((_local2) || ((_arg1 == buttonStyleNameProp)))) || ((_arg1 == firstButtonStyleNameProp)))) || ((_arg1 == lastButtonStyleNameProp)))){
                _local3 = getStyle(buttonStyleNameProp);
                _local4 = getStyle(firstButtonStyleNameProp);
                _local5 = getStyle(lastButtonStyleNameProp);
                if (!_local3){
                    _local3 = "ButtonBarButton";
                };
                if (!_local4){
                    _local4 = _local3;
                };
                if (!_local5){
                    _local5 = _local3;
                };
                _local7 = numChildren;
                _local8 = 0;
                while (_local8 < _local7) {
                    if (_local8 == 0){
                        _local6 = _local4;
                    } else {
                        if (_local8 == (_local7 - 1)){
                            _local6 = _local5;
                        } else {
                            _local6 = _local3;
                        };
                    };
                    Button(getChildAt(_local8)).styleName = _local6;
                    _local8++;
                };
                recalcButtonWidths = (recalcButtonHeights = true);
            };
            if (_arg1 == buttonWidthProp){
                recalcButtonWidths = true;
            } else {
                if (_arg1 == buttonHeightProp){
                    recalcButtonHeights = true;
                };
            };
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:int;
            super.commitProperties();
            if (directionChanged){
                directionChanged = false;
                _local1 = numChildren;
                _local2 = 0;
                while (_local2 < _local1) {
                    Button(getChildAt(_local2)).changeSkins();
                    _local2++;
                };
            };
        }
        private function calcFullHeight():Number{
            var _local2:Number;
            var _local6:Number;
            var _local8:Number;
            var _local1:int = numChildren;
            if (_local1 == 0){
                return (0);
            };
            if (_local1 > 1){
                _local2 = getStyle("verticalGap");
            };
            var _local3 = (direction == BoxDirection.VERTICAL);
            var _local4:Number = getStyle(buttonHeightProp);
            var _local5:IUIComponent = IUIComponent(getChildAt(0));
            if (_local4){
                _local6 = ((isNaN(_local5.explicitHeight)) ? _local4 : _local5.explicitHeight);
            } else {
                _local6 = _local5.getExplicitOrMeasuredHeight();
            };
            var _local7 = 1;
            while (_local7 < _local1) {
                _local5 = IUIComponent(getChildAt(_local7));
                if (_local4){
                    _local8 = ((isNaN(_local5.explicitHeight)) ? _local4 : _local5.explicitHeight);
                } else {
                    _local8 = _local5.getExplicitOrMeasuredHeight();
                };
                if (_local3){
                    _local6 = (_local6 + (_local2 + _local8));
                } else {
                    _local6 = Math.max(_local6, _local8);
                };
                _local7++;
            };
            return (_local6);
        }
        override protected function resetNavItems():void{
            recalcButtonWidths = (recalcButtonHeights = true);
            invalidateDisplayList();
        }
        override public function get viewMetrics():EdgeMetrics{
            return (EdgeMetrics.EMPTY);
        }
        mx_internal function prevIndex(_arg1:int):int{
            var _local2:int = numChildren;
            return ((((_arg1 == 0)) ? (_local2 - 1) : (_arg1 - 1)));
        }
        private function scaleChangedHandler(_arg1:Event):void{
            var _local3:Button;
            var _local2:int;
            while (_local2 < numChildren) {
                _local3 = (getChildAt(_local2) as Button);
                if (_local3){
                    _local3.explicitWidth = NaN;
                    _local3.minWidth = NaN;
                    _local3.maxWidth = NaN;
                    _local3.explicitHeight = NaN;
                    _local3.minHeight = NaN;
                    _local3.maxHeight = NaN;
                };
                _local2++;
            };
        }
        mx_internal function drawButtonFocus(_arg1:int, _arg2:Boolean):void{
            var _local3:Button;
            if ((((numChildren > 0)) && ((_arg1 < numChildren)))){
                _local3 = Button(getChildAt(_arg1));
                _local3.drawFocus(((_arg2) && (focusManager.showFocusIndicator)));
                if (_arg2){
                    dispatchEvent(new Event("focusDraw"));
                };
                if (((!(_arg2)) && (!((_local3.phase == ButtonPhase.UP))))){
                    _local3.phase = ButtonPhase.UP;
                };
            };
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:Button;
            if (_arg1.eventPhase != EventPhase.AT_TARGET){
                return;
            };
            switch (_arg1.keyCode){
                case Keyboard.DOWN:
                case Keyboard.RIGHT:
                    focusManager.showFocusIndicator = true;
                    drawButtonFocus(focusedIndex, false);
                    focusedIndex = nextIndex(focusedIndex);
                    if (focusedIndex != -1){
                        drawButtonFocus(focusedIndex, true);
                    };
                    _arg1.stopPropagation();
                    break;
                case Keyboard.UP:
                case Keyboard.LEFT:
                    focusManager.showFocusIndicator = true;
                    drawButtonFocus(focusedIndex, false);
                    focusedIndex = prevIndex(focusedIndex);
                    if (focusedIndex != -1){
                        drawButtonFocus(focusedIndex, true);
                    };
                    _arg1.stopPropagation();
                    break;
                case Keyboard.SPACE:
                    if (focusedIndex != -1){
                        _local2 = Button(getChildAt(focusedIndex));
                        _local2.dispatchEvent(_arg1);
                    };
                    _arg1.stopPropagation();
                    break;
            };
        }
        override protected function measure():void{
            var _local1:EdgeMetrics;
            super.measure();
            _local1 = viewMetricsAndPadding;
            measuredWidth = ((calcFullWidth() + _local1.left) + _local1.right);
            measuredHeight = ((calcFullHeight() + _local1.top) + _local1.bottom);
            if (getStyle(buttonWidthProp)){
                measuredMinWidth = measuredWidth;
            };
            if (getStyle(buttonHeightProp)){
                measuredMinHeight = measuredHeight;
            };
        }
        private function childRemoveHandler(_arg1:ChildExistenceChangedEvent):void{
            var _local8:Button;
            var _local2:DisplayObject = _arg1.relatedObject;
            var _local3:int = getChildIndex(_local2);
            var _local4:int = numChildren;
            if (_local4 < 2){
                return;
            };
            var _local5:String = getStyle(buttonStyleNameProp);
            var _local6:String = getStyle(firstButtonStyleNameProp);
            var _local7:String = getStyle(lastButtonStyleNameProp);
            if (!_local5){
                _local5 = "buttonBarButtonStyle";
            };
            if (!_local6){
                _local6 = _local5;
            };
            if (!_local7){
                _local7 = _local5;
            };
            if ((((_local3 == 0)) || ((_local3 == (_local4 - 1))))){
                _local8 = Button(getChildAt((((_local3 == (_local4 - 1))) ? (_local4 - 2) : 0)));
                _local8.styleName = (((_local3 == 0)) ? _local6 : _local7);
                _local8.changeSkins();
                _local8.invalidateDisplayList();
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:Boolean;
            var _local16:int;
            var _local17:Button;
            var _local18:Number;
            var _local19:int;
            var _local20:int;
            var _local21:Number;
            var _local22:int;
            var _local23:int;
            var _local24:int;
            var _local25:Number;
            _local3 = (direction == BoxDirection.HORIZONTAL);
            var _local4 = !(_local3);
            var _local5:Number = getStyle(buttonWidthProp);
            var _local6:Number = getStyle(buttonHeightProp);
            var _local7:Number = _local6;
            var _local8:EdgeMetrics = viewMetricsAndPadding;
            var _local9:int = numChildren;
            var _local10:Number = getStyle("horizontalGap");
            var _local11:Number = getStyle("verticalGap");
            var _local12:Number = ((((_local3) && ((numChildren > 0)))) ? (_local10 * (_local9 - 1)) : 0);
            var _local13:Number = ((((_local4) && ((numChildren > 0)))) ? (_local11 * (_local9 - 1)) : 0);
            var _local14:Number = (((_arg1 - _local8.left) - _local8.right) - _local12);
            var _local15:Number = (((_arg2 - _local8.top) - _local8.bottom) - _local13);
            if (((!(_local14)) || (!(_local15)))){
                return;
            };
            if (border){
                border.visible = false;
            };
            if (_arg1 != oldUnscaledWidth){
                recalcButtonWidths = true;
                oldUnscaledWidth = _arg1;
            };
            if (_arg2 != oldUnscaledHeight){
                recalcButtonHeights = true;
                oldUnscaledHeight = _arg2;
            };
            if (recalcButtonWidths){
                recalcButtonWidths = false;
                if (((isNaN(_local5)) && (_local4))){
                    _local5 = _local14;
                };
                _local18 = (_local14 - (calcFullWidth() - _local12));
                _local19 = (((_local9 > 0)) ? (_local14 / _local9) : 0);
                _local20 = 0;
                _local21 = 0;
                _local22 = 0;
                if (((!((_local18 == 0))) && (_local3))){
                    _local16 = 0;
                    while (_local16 < _local9) {
                        _local17 = Button(getChildAt(_local16));
                        if (isNaN(_local17.explicitWidth)){
                            _local23 = _local17.measuredWidth;
                            _local21 = (_local21 + _local23);
                            if (_local23 > _local19){
                                _local20++;
                            } else {
                                _local22 = (_local22 + _local23);
                            };
                        };
                        _local16++;
                    };
                } else {
                    _local21 = _local14;
                };
                _local16 = 0;
                while (_local16 < _local9) {
                    _local17 = Button(getChildAt(_local16));
                    if (isNaN(_local17.explicitWidth)){
                        _local17.minWidth = 0;
                        if (!isNaN(_local5)){
                            _local17.minWidth = (_local17.maxWidth = _local5);
                            _local17.percentWidth = ((_local5 / Math.min(_local14, _local21)) * 100);
                        } else {
                            if (_local18 < 0){
                                _local24 = _local17.measuredWidth;
                                if (_local24 > _local19){
                                    _local24 = ((_local14 - _local22) / _local20);
                                };
                                _local17.percentWidth = ((Number(_local24) / _local14) * 100);
                            } else {
                                if (_local18 > 0){
                                    _local17.percentWidth = ((_local17.measuredWidth / _local21) * 100);
                                } else {
                                    _local17.percentWidth = NaN;
                                };
                            };
                        };
                        if (_local4){
                            _local17.percentWidth = 100;
                        };
                    };
                    _local16++;
                };
            };
            if (recalcButtonHeights){
                recalcButtonHeights = false;
                if (((isNaN(_local7)) && (_local3))){
                    _local7 = _local15;
                };
                _local18 = (_local15 - (calcFullHeight() - _local13));
                _local25 = 0;
                if (((!((_local18 == 0))) && (_local4))){
                    _local16 = 0;
                    while (_local16 < _local9) {
                        _local17 = Button(getChildAt(_local16));
                        if (isNaN(_local17.explicitHeight)){
                            _local25 = (_local25 + _local17.measuredHeight);
                        };
                        _local16++;
                    };
                };
                _local16 = 0;
                while (_local16 < _local9) {
                    _local17 = Button(getChildAt(_local16));
                    if (isNaN(_local17.explicitHeight)){
                        _local17.minHeight = 0;
                        if (!isNaN(_local7)){
                            _local17.minHeight = _local7;
                            _local17.percentHeight = ((_local7 / Math.min(_local25, _local15)) * 100);
                        };
                        if (!isNaN(_local6)){
                            _local17.maxHeight = _local6;
                        };
                        if (_local3){
                            _local17.percentHeight = 100;
                        } else {
                            if (_local18 < 0){
                                _local17.percentHeight = ((_local17.measuredHeight / _local25) * 100);
                            } else {
                                if (_local18 > 0){
                                    _local17.percentHeight = ((_local17.measuredHeight / _local25) * 100);
                                } else {
                                    _local17.percentHeight = NaN;
                                };
                            };
                        };
                    };
                    _local16++;
                };
            };
            super.updateDisplayList(_arg1, _arg2);
        }
        override public function drawFocus(_arg1:Boolean):void{
            drawButtonFocus(focusedIndex, _arg1);
        }
        override public function set direction(_arg1:String):void{
            if (((initialized) && (!((_arg1 == direction))))){
                directionChanged = true;
                invalidateProperties();
            };
            super.direction = _arg1;
        }

    }
}//package mx.controls 
