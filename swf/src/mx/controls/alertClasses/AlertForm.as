package mx.controls.alertClasses {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.*;
    import flash.ui.*;

    public class AlertForm extends UIComponent implements IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal var buttons:Array;
        private var icon:DisplayObject;
        mx_internal var textField:IUITextField;
        mx_internal var defaultButton:Button;
        private var textWidth:Number;
        private var defaultButtonChanged:Boolean = false;
        private var textHeight:Number;

        public function AlertForm(){
            buttons = [];
            super();
            tabChildren = true;
        }
        override public function styleChanged(_arg1:String):void{
            var _local2:String;
            var _local3:int;
            var _local4:int;
            super.styleChanged(_arg1);
            if (((((!(_arg1)) || ((_arg1 == "styleName")))) || ((_arg1 == "buttonStyleName")))){
                if (buttons){
                    _local2 = getStyle("buttonStyleName");
                    _local3 = buttons.length;
                    _local4 = 0;
                    while (_local4 < _local3) {
                        buttons[_local4].styleName = _local2;
                        _local4++;
                    };
                };
            };
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:ISystemManager;
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((textField == null))))){
                _local1 = getChildIndex(DisplayObject(textField));
                removeTextField();
                createTextField(_local1);
            };
            if (((defaultButtonChanged) && (defaultButton))){
                defaultButtonChanged = false;
                Alert(parent).defaultButton = defaultButton;
                if ((parent is IFocusManagerContainer)){
                    _local2 = Alert(parent).systemManager;
                    _local2.activate(IFocusManagerContainer(parent));
                };
                defaultButton.setFocus();
            };
        }
        private function createButton(_arg1:String, _arg2:String):Button{
            var _local3:Button = new Button();
            _local3.label = _arg1;
            _local3.name = _arg2;
            var _local4:String = getStyle("buttonStyleName");
            if (_local4){
                _local3.styleName = _local4;
            };
            _local3.addEventListener(MouseEvent.CLICK, clickHandler);
            _local3.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            _local3.owner = parent;
            addChild(_local3);
            _local3.setActualSize(Alert.buttonWidth, Alert.buttonHeight);
            buttons.push(_local3);
            return (_local3);
        }
        override protected function resourcesChanged():void{
            var _local1:Button;
            super.resourcesChanged();
            _local1 = Button(getChildByName("OK"));
            if (_local1){
                _local1.label = String(Alert.okLabel);
            };
            _local1 = Button(getChildByName("CANCEL"));
            if (_local1){
                _local1.label = String(Alert.cancelLabel);
            };
            _local1 = Button(getChildByName("YES"));
            if (_local1){
                _local1.label = String(Alert.yesLabel);
            };
            _local1 = Button(getChildByName("NO"));
            if (_local1){
                _local1.label = String(Alert.noLabel);
            };
        }
        override protected function createChildren():void{
            var _local5:String;
            var _local6:Button;
            super.createChildren();
            createTextField(-1);
            var _local1:Class = Alert(parent).iconClass;
            if (((_local1) && (!(icon)))){
                icon = new (_local1)();
                addChild(icon);
            };
            var _local2:Alert = Alert(parent);
            var _local3:uint = _local2.buttonFlags;
            var _local4:uint = _local2.defaultButtonFlag;
            if ((_local3 & Alert.OK)){
                _local5 = String(Alert.okLabel);
                _local6 = createButton(_local5, "OK");
                if (_local4 == Alert.OK){
                    defaultButton = _local6;
                };
            };
            if ((_local3 & Alert.YES)){
                _local5 = String(Alert.yesLabel);
                _local6 = createButton(_local5, "YES");
                if (_local4 == Alert.YES){
                    defaultButton = _local6;
                };
            };
            if ((_local3 & Alert.NO)){
                _local5 = String(Alert.noLabel);
                _local6 = createButton(_local5, "NO");
                if (_local4 == Alert.NO){
                    defaultButton = _local6;
                };
            };
            if ((_local3 & Alert.CANCEL)){
                _local5 = String(Alert.cancelLabel);
                _local6 = createButton(_local5, "CANCEL");
                if (_local4 == Alert.CANCEL){
                    defaultButton = _local6;
                };
            };
            if (((!(defaultButton)) && (buttons.length))){
                defaultButton = buttons[0];
            };
            if (defaultButton){
                defaultButtonChanged = true;
                invalidateProperties();
            };
        }
        override protected function measure():void{
            super.measure();
            var _local1:String = Alert(parent).title;
            var _local2:TextLineMetrics = Alert(parent).getTitleTextField().getUITextFormat().measureText(_local1);
            var _local3:int = Math.max(buttons.length, 2);
            var _local4:Number = ((_local3 * buttons[0].width) + ((_local3 - 1) * 8));
            var _local5:Number = Math.max(_local4, _local2.width);
            textField.width = (2 * _local5);
            textWidth = (textField.textWidth + UITextField.TEXT_WIDTH_PADDING);
            var _local6:Number = Math.max(_local5, textWidth);
            _local6 = Math.min(_local6, (2 * _local5));
            if ((((textWidth < _local6)) && ((textField.multiline == true)))){
                textField.multiline = false;
                textField.wordWrap = false;
            } else {
                if (textField.multiline == false){
                    textField.wordWrap = true;
                    textField.multiline = true;
                };
            };
            _local6 = (_local6 + 16);
            if (icon){
                _local6 = (_local6 + (icon.width + 8));
            };
            textHeight = (textField.textHeight + UITextField.TEXT_HEIGHT_PADDING);
            var _local7:Number = textHeight;
            if (icon){
                _local7 = Math.max(_local7, icon.height);
            };
            _local7 = Math.min(_local7, (screen.height * 0.75));
            _local7 = (_local7 + (buttons[0].height + (3 * 8)));
            measuredWidth = _local6;
            measuredHeight = _local7;
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        private function clickHandler(_arg1:MouseEvent):void{
            var _local2:String = Button(_arg1.currentTarget).name;
            removeAlert(_local2);
        }
        mx_internal function removeTextField():void{
            if (textField){
                removeChild(DisplayObject(textField));
                textField = null;
            };
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:uint = Alert(parent).buttonFlags;
            if (_arg1.keyCode == Keyboard.ESCAPE){
                if ((((_local2 & Alert.CANCEL)) || (!((_local2 & Alert.NO))))){
                    removeAlert("CANCEL");
                } else {
                    if ((_local2 & Alert.NO)){
                        removeAlert("NO");
                    };
                };
            };
        }
        mx_internal function createTextField(_arg1:int):void{
            if (!textField){
                textField = IUITextField(createInFontContext(UITextField));
                textField.styleName = this;
                textField.text = Alert(parent).text;
                textField.multiline = true;
                textField.wordWrap = true;
                textField.selectable = true;
                if (_arg1 == -1){
                    addChild(DisplayObject(textField));
                } else {
                    addChildAt(DisplayObject(textField), _arg1);
                };
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            super.updateDisplayList(_arg1, _arg2);
            _local4 = (_arg2 - buttons[0].height);
            _local5 = ((buttons.length * (buttons[0].width + 8)) - 8);
            _local3 = ((_arg1 - _local5) / 2);
            var _local6:int;
            while (_local6 < buttons.length) {
                buttons[_local6].move(_local3, _local4);
                buttons[_local6].tabIndex = (_local6 + 1);
                _local3 = (_local3 + (buttons[_local6].width + 8));
                _local6++;
            };
            _local5 = textWidth;
            if (icon){
                _local5 = (_local5 + (icon.width + 8));
            };
            _local3 = ((_arg1 - _local5) / 2);
            if (icon){
                icon.x = _local3;
                icon.y = ((_local4 - icon.height) / 2);
                _local3 = (_local3 + (icon.width + 8));
            };
            var _local7:Number = textField.getExplicitOrMeasuredHeight();
            textField.move(_local3, ((_local4 - _local7) / 2));
            textField.setActualSize((textWidth + 5), _local7);
        }
        private function removeAlert(_arg1:String):void{
            var _local2:Alert = Alert(parent);
            _local2.visible = false;
            var _local3:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
            if (_arg1 == "YES"){
                _local3.detail = Alert.YES;
            } else {
                if (_arg1 == "NO"){
                    _local3.detail = Alert.NO;
                } else {
                    if (_arg1 == "OK"){
                        _local3.detail = Alert.OK;
                    } else {
                        if (_arg1 == "CANCEL"){
                            _local3.detail = Alert.CANCEL;
                        };
                    };
                };
            };
            _local2.dispatchEvent(_local3);
            PopUpManager.removePopUp(_local2);
        }

    }
}//package mx.controls.alertClasses 
