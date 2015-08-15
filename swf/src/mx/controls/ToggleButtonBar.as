package mx.controls {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.ui.*;

    public class ToggleButtonBar extends ButtonBar {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal var selectedButtonTextStyleNameProp:String = "selectedButtonTextStyleName";
        private var initializeSelectedButton:Boolean = true;
        private var _toggleOnClick:Boolean = false;
        private var _selectedIndex:int = -2;
        private var selectedIndexChanged:Boolean = false;

        override protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            var _local3:Button = Button(super.createNavItem(_arg1, _arg2));
            _local3.toggle = true;
            return (_local3);
        }
        override public function styleChanged(_arg1:String):void{
            var _local3:Button;
            var _local4:String;
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if (((_local2) || ((_arg1 == selectedButtonTextStyleNameProp)))){
                if (((!((selectedIndex == -1))) && ((selectedIndex < numChildren)))){
                    _local3 = Button(getChildAt(selectedIndex));
                    if (_local3){
                        _local4 = getStyle(selectedButtonTextStyleNameProp);
                        _local3.getTextField().styleName = ((_local4) ? _local4 : "activeButtonStyle");
                    };
                };
            };
        }
        override protected function resetNavItems():void{
            var _local4:Button;
            var _local1:String = getStyle(selectedButtonTextStyleNameProp);
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = Button(getChildAt(_local3));
                if (_local3 == selectedIndex){
                    _local4.selected = true;
                    _local4.getTextField().styleName = ((_local1) ? _local1 : "activeButtonStyle");
                } else {
                    _local4.selected = false;
                    _local4.getTextField().styleName = _local4;
                };
                _local3++;
            };
            super.resetNavItems();
        }
        mx_internal function selectButton(_arg1:int, _arg2:Boolean=false, _arg3:Event=null):void{
            _selectedIndex = _arg1;
            if (_arg2){
                drawButtonFocus(focusedIndex, false);
                focusedIndex = _arg1;
                drawButtonFocus(focusedIndex, false);
            };
            var _local4:Button = Button(getChildAt(_arg1));
            simulatedClickTriggerEvent = _arg3;
            _local4.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            simulatedClickTriggerEvent = null;
        }
        override protected function keyUpHandler(_arg1:KeyboardEvent):void{
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (selectedIndexChanged){
                hiliteSelectedNavItem(_selectedIndex);
                super.selectedIndex = _selectedIndex;
                selectedIndexChanged = false;
            };
        }
        override protected function hiliteSelectedNavItem(_arg1:int):void{
            var _local2:Button;
            var _local3:String;
            if (((!((selectedIndex == -1))) && ((selectedIndex < numChildren)))){
                _local2 = Button(getChildAt(selectedIndex));
                _local2.selected = false;
                _local2.getTextField().styleName = _local2;
                _local2.invalidateDisplayList();
                _local2.invalidateSize();
            };
            super.selectedIndex = _arg1;
            if (_arg1 > -1){
                _local2 = Button(getChildAt(selectedIndex));
                _local2.selected = true;
                _local3 = getStyle(selectedButtonTextStyleNameProp);
                _local2.getTextField().styleName = ((_local3) ? _local3 : "activeButtonStyle");
                _local2.invalidateDisplayList();
            };
        }
        override protected function clickHandler(_arg1:MouseEvent):void{
            var _local2:int = getChildIndex(Button(_arg1.currentTarget));
            _selectedIndex = _local2;
            if (((_toggleOnClick) && ((_local2 == selectedIndex)))){
                selectedIndex = -1;
                hiliteSelectedNavItem(-1);
            } else {
                hiliteSelectedNavItem(_local2);
            };
            super.clickHandler(_arg1);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2 = -1;
            var _local3:Boolean;
            var _local4:int = numChildren;
            switch (_arg1.keyCode){
                case Keyboard.PAGE_DOWN:
                    _local2 = nextIndex(selectedIndex);
                    break;
                case Keyboard.PAGE_UP:
                    if (selectedIndex != -1){
                        _local2 = prevIndex(selectedIndex);
                    } else {
                        if (_local4 > 0){
                            _local2 = 0;
                        };
                    };
                    break;
                case Keyboard.HOME:
                    if (_local4 > 0){
                        _local2 = 0;
                    };
                    break;
                case Keyboard.END:
                    if (_local4 > 0){
                        _local2 = (_local4 - 1);
                    };
                    break;
                case Keyboard.SPACE:
                case Keyboard.ENTER:
                    if (focusedIndex != -1){
                        _local2 = focusedIndex;
                        _local3 = false;
                    };
                    break;
                default:
                    super.keyDownHandler(_arg1);
            };
            if (_local2 != -1){
                selectButton(_local2, _local3, _arg1);
            };
            _arg1.stopPropagation();
        }
        public function set toggleOnClick(_arg1:Boolean):void{
            _toggleOnClick = _arg1;
        }
        override public function set selectedIndex(_arg1:int):void{
            if (_arg1 == selectedIndex){
                return;
            };
            if (numChildren == 0){
                _selectedIndex = _arg1;
                selectedIndexChanged = true;
            };
            if (_arg1 < numChildren){
                _selectedIndex = _arg1;
                selectedIndexChanged = true;
                invalidateProperties();
                dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
            };
        }
        public function get toggleOnClick():Boolean{
            return (_toggleOnClick);
        }
        override public function get selectedIndex():int{
            return (super.selectedIndex);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:int;
            super.updateDisplayList(_arg1, _arg2);
            if (initializeSelectedButton){
                initializeSelectedButton = false;
                _local3 = _selectedIndex;
                if (_local3 == -2){
                    if (numChildren > 0){
                        _local3 = 0;
                    } else {
                        _local3 = -1;
                    };
                };
                hiliteSelectedNavItem(_local3);
            };
        }

    }
}//package mx.controls 
