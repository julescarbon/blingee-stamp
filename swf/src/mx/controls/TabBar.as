package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.controls.tabBarClasses.*;

    public class TabBar extends ToggleButtonBar {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;

        public function TabBar(){
            buttonHeightProp = "tabHeight";
            buttonStyleNameProp = "tabStyleName";
            firstButtonStyleNameProp = "firstTabStyleName";
            lastButtonStyleNameProp = "lastTabStyleName";
            buttonWidthProp = "tabWidth";
            navItemFactory = new ClassFactory(Tab);
            selectedButtonTextStyleNameProp = "selectedTabTextStyleName";
        }
        override protected function clickHandler(_arg1:MouseEvent):void{
            if (getChildIndex(DisplayObject(_arg1.currentTarget)) == selectedIndex){
                Button(_arg1.currentTarget).selected = true;
                _arg1.stopImmediatePropagation();
                return;
            };
            super.clickHandler(_arg1);
        }
        override protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            var _local3:IFlexDisplayObject = super.createNavItem(_arg1, _arg2);
            DisplayObject(_local3).addEventListener(MouseEvent.MOUSE_DOWN, tab_mouseDownHandler);
            DisplayObject(_local3).addEventListener(MouseEvent.DOUBLE_CLICK, tab_doubleClickHandler);
            return (_local3);
        }
        private function tab_doubleClickHandler(_arg1:MouseEvent):void{
            Button(_arg1.currentTarget).selected = true;
        }
        private function tab_mouseDownHandler(_arg1:MouseEvent):void{
            selectButton(_arg1.currentTarget.parent.getChildIndex(_arg1.currentTarget), true, _arg1);
        }
        override protected function initializeAccessibility():void{
            if (TabBar.createAccessibilityImplementation != null){
                TabBar.createAccessibilityImplementation(this);
            };
        }

    }
}//package mx.controls 
