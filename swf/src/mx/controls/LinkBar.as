package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;

    public class LinkBar extends NavBar {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const SEPARATOR_NAME:String = "_separator";

        private var _selectedIndex:int = -1;
        private var _selectedIndexChanged:Boolean = false;

        public function LinkBar(){
            navItemFactory = new ClassFactory(LinkButton);
            addEventListener(MouseEvent.CLICK, defaultClickHandler);
            addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
        }
        override protected function clickHandler(_arg1:MouseEvent):void{
            var _local2:int = getChildIndex(Button(_arg1.currentTarget));
            if (targetStack){
                if (_local2 == selectedIndex){
                    hiliteSelectedNavItem(-1);
                } else {
                    hiliteSelectedNavItem(_local2);
                };
            };
            super.clickHandler(_arg1);
        }
        private function defaultClickHandler(_arg1:MouseEvent):void{
            if (!(_arg1 is ItemClickEvent)){
                _arg1.stopImmediatePropagation();
            };
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (_selectedIndexChanged){
                hiliteSelectedNavItem(_selectedIndex);
                super.selectedIndex = _selectedIndex;
                _selectedIndexChanged = false;
            };
        }
        override protected function hiliteSelectedNavItem(_arg1:int):void{
            var _local2:Button;
            if (((!((selectedIndex == -1))) && ((selectedIndex < numChildren)))){
                _local2 = Button(getChildAt(selectedIndex));
                _local2.enabled = true;
            };
            super.selectedIndex = _arg1;
            _local2 = Button(getChildAt(selectedIndex));
            _local2.enabled = false;
        }
        override public function set selectedIndex(_arg1:int):void{
            if (_arg1 == selectedIndex){
                return;
            };
            _selectedIndex = _arg1;
            _selectedIndexChanged = true;
            invalidateProperties();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        private function childRemoveHandler(_arg1:ChildExistenceChangedEvent):void{
            var _local2:DisplayObject = _arg1.relatedObject;
            var _local3:int = getChildIndex(_local2);
            var _local4:DisplayObject = rawChildren.getChildByName((SEPARATOR_NAME + _local3));
            rawChildren.removeChild(_local4);
            var _local5:int = (numChildren - 1);
            var _local6:int = _local3;
            while (_local6 < _local5) {
                rawChildren.getChildByName((SEPARATOR_NAME + (_local6 + 1))).name = (SEPARATOR_NAME + _local6);
                _local6++;
            };
        }
        override public function styleChanged(_arg1:String):void{
            var _local2:Object;
            var _local3:int;
            var _local4:int;
            super.styleChanged(_arg1);
            if ((((_arg1 == "styleName")) && ((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)))){
                _local2 = this;
            } else {
                if ((((_arg1 == "linkButtonStyleName")) && ((FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)))){
                    _local2 = getStyle("linkButtonStyleName");
                };
            };
            if (_local2){
                _local3 = numChildren;
                _local4 = 0;
                while (_local4 < _local3) {
                    LinkButton(getChildAt(_local4)).styleName = _local2;
                    _local4++;
                };
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local10:IFlexDisplayObject;
            var _local11:IFlexDisplayObject;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:EdgeMetrics = viewMetricsAndPadding;
            var _local4:Number = getStyle("horizontalGap");
            var _local5:Number = getStyle("verticalGap");
            var _local6:Number = (_arg2 - (_local3.top + _local3.bottom));
            var _local7:Number = (_arg1 - (_local3.left + _local3.right));
            var _local8:int = numChildren;
            var _local9:int;
            while (_local9 < _local8) {
                _local10 = IFlexDisplayObject(getChildAt(_local9));
                _local11 = IFlexDisplayObject(rawChildren.getChildByName((SEPARATOR_NAME + _local9)));
                if (_local11){
                    _local11.visible = false;
                    if (_local9 == 0){
                    } else {
                        if (isVertical()){
                            _local11.move(_local3.left, (_local10.y - _local5));
                            _local11.setActualSize(_local7, _local5);
                            if ((_local11.y + _local11.height) < (_arg2 - _local3.bottom)){
                                _local11.visible = true;
                            };
                        } else {
                            _local11.move((_local10.x - _local4), _local3.top);
                            _local11.setActualSize(_local4, _local6);
                            if ((_local11.x + _local11.width) < (_arg1 - _local3.right)){
                                _local11.visible = true;
                            };
                        };
                    };
                };
                _local9++;
            };
        }
        override protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            var _local6:String;
            var _local3:Button = Button(navItemFactory.newInstance());
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local3.styleName = this;
            } else {
                _local6 = getStyle("linkButtonStyleName");
                if (_local6){
                    _local3.styleName = _local6;
                };
            };
            if (((_arg1) && ((_arg1.length > 0)))){
                _local3.label = _arg1;
            } else {
                _local3.label = " ";
            };
            if (_arg2){
                _local3.setStyle("icon", _arg2);
            };
            addChild(_local3);
            _local3.addEventListener(MouseEvent.CLICK, clickHandler);
            var _local4:Class = Class(getStyle("separatorSkin"));
            var _local5:DisplayObject = DisplayObject(new (_local4)());
            _local5.name = (SEPARATOR_NAME + (numChildren - 1));
            if ((_local5 is ISimpleStyleClient)){
                ISimpleStyleClient(_local5).styleName = this;
            };
            rawChildren.addChild(_local5);
            return (_local3);
        }
        override protected function resetNavItems():void{
            var _local3:Button;
            var _local1:int = numChildren;
            var _local2:int;
            while (_local2 < _local1) {
                _local3 = Button(getChildAt(_local2));
                _local3.enabled = !((_local2 == selectedIndex));
                _local2++;
            };
            invalidateDisplayList();
        }
        override public function get selectedIndex():int{
            return (super.selectedIndex);
        }

    }
}//package mx.controls 
