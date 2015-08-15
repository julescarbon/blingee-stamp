package flexlib.controls.tabBarClasses {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import flash.events.*;
    import mx.controls.*;
    import mx.controls.tabBarClasses.*;

    public class SuperTab extends Tab {

        public static const CLOSE_NEVER:String = "close_never";
        public static const CLOSE_ALWAYS:String = "close_always";
        public static const CLOSE_ROLLOVER:String = "close_rollover";
        public static const CLOSE_TAB_EVENT:String = "closeTab";
        public static const CLOSE_SELECTED:String = "close_selected";

        private var _indicatorOffset:Number = 0;
        private var _closePolicy:String;
        private var indicator:DisplayObject;
        private var closeButton:Button;
        private var _showIndicator:Boolean = false;
        private var _rolledOver:Boolean = false;

        public function SuperTab():void{
            this.mouseChildren = true;
            this.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
        }
        private function cancelEvent(_arg1:Event):void{
            _arg1.stopPropagation();
            _arg1.stopImmediatePropagation();
        }
        private function textUnfocusListener(_arg1:Event):void{
            this.editableLabel = false;
            this.textField.removeEventListener(FocusEvent.FOCUS_OUT, textUnfocusListener);
        }
        public function get closePolicy():String{
            return (_closePolicy);
        }
        public function get showIndicator():Boolean{
            return (_showIndicator);
        }
        override protected function rollOverHandler(_arg1:MouseEvent):void{
            _rolledOver = true;
            super.rollOverHandler(_arg1);
        }
        private function doubleClickHandler(_arg1:MouseEvent):void{
            this.editableLabel = true;
            this.textField.addEventListener(FocusEvent.FOCUS_OUT, textUnfocusListener);
        }
        override protected function createChildren():void{
            super.createChildren();
            closeButton = new Button();
            closeButton.width = 10;
            closeButton.height = 10;
            closeButton.addEventListener(MouseEvent.MOUSE_UP, closeClickHandler, false, 0, true);
            closeButton.addEventListener(MouseEvent.MOUSE_DOWN, cancelEvent, false, 0, true);
            closeButton.addEventListener(MouseEvent.CLICK, cancelEvent, false, 0, true);
            closeButton.styleName = getStyle("tabCloseButtonStyleName");
            var _local1:Class = (getStyle("indicatorClass") as Class);
            if (_local1){
                indicator = (new (_local1)() as DisplayObject);
            } else {
                indicator = new UIComponent();
            };
            addChild(indicator);
            addChild(closeButton);
            this.textField.addEventListener(Event.CHANGE, captureTextChange);
        }
        override protected function measure():void{
            super.measure();
            if ((((_closePolicy == SuperTab.CLOSE_ALWAYS)) || ((_closePolicy == SuperTab.CLOSE_ROLLOVER)))){
                measuredMinWidth = (measuredMinWidth + 10);
            } else {
                if ((((_closePolicy == SuperTab.CLOSE_SELECTED)) && (selected))){
                    measuredMinWidth = (measuredMinWidth + 10);
                };
            };
        }
        public function set editableLabel(_arg1:Boolean):void{
            this.textField.type = ((_arg1) ? TextFieldType.INPUT : TextFieldType.DYNAMIC);
            this.textField.selectable = _arg1;
        }
        public function set closePolicy(_arg1:String):void{
            this._closePolicy = _arg1;
            this.invalidateDisplayList();
        }
        public function set showIndicator(_arg1:Boolean):void{
            this._showIndicator = _arg1;
            this.invalidateDisplayList();
        }
        override public function get measuredWidth():Number{
            return (this.measuredMinWidth);
        }
        private function captureTextChange(_arg1:Event):void{
            _arg1.stopImmediatePropagation();
        }
        public function showIndicatorAt(_arg1:Number):void{
            this._indicatorOffset = _arg1;
            this.showIndicator = true;
        }
        public function get editableLabel():Boolean{
            return ((((this.textField.type == TextFieldType.INPUT)) && (this.textField.selectable)));
        }
        override public function set selected(_arg1:Boolean):void{
            super.selected = _arg1;
            callLater(invalidateSize);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            setChildIndex(closeButton, (numChildren - 2));
            setChildIndex(indicator, (numChildren - 1));
            closeButton.visible = false;
            indicator.visible = false;
            if (_closePolicy == SuperTab.CLOSE_SELECTED){
                if (selected){
                    closeButton.visible = true;
                    closeButton.enabled = true;
                };
            } else {
                if (!_rolledOver){
                    if (_closePolicy == SuperTab.CLOSE_ALWAYS){
                        closeButton.visible = true;
                        closeButton.enabled = false;
                    } else {
                        if (_closePolicy == SuperTab.CLOSE_ROLLOVER){
                            closeButton.visible = false;
                            closeButton.enabled = false;
                        };
                    };
                } else {
                    if (_closePolicy != SuperTab.CLOSE_NEVER){
                        closeButton.visible = true;
                        closeButton.enabled = true;
                    };
                };
            };
            if (_showIndicator){
                indicator.visible = true;
                indicator.x = (_indicatorOffset - (indicator.width / 2));
                indicator.y = 0;
            };
            if (closeButton.visible){
                this.textField.width = (closeButton.x - textField.x);
                this.textField.truncateToFit();
                closeButton.x = ((_arg1 - closeButton.width) - 4);
                closeButton.y = 4;
            };
        }
        override protected function rollOutHandler(_arg1:MouseEvent):void{
            _rolledOver = false;
            super.rollOutHandler(_arg1);
        }
        private function closeClickHandler(_arg1:MouseEvent):void{
            dispatchEvent(new Event(CLOSE_TAB_EVENT));
            _arg1.stopImmediatePropagation();
            _arg1.stopPropagation();
        }

    }
}//package flexlib.controls.tabBarClasses 
