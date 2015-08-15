package mx.controls {
    import mx.controls.scrollClasses.*;
    import flash.ui.*;

    public class VScrollBar extends ScrollBar {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function VScrollBar(){
            super.direction = ScrollBarDirection.VERTICAL;
        }
        override protected function measure():void{
            super.measure();
            measuredWidth = _minWidth;
            measuredHeight = _minHeight;
        }
        override public function get minHeight():Number{
            return (_minHeight);
        }
        override mx_internal function isScrollBarKey(_arg1:uint):Boolean{
            if (_arg1 == Keyboard.UP){
                lineScroll(-1);
                return (true);
            };
            if (_arg1 == Keyboard.DOWN){
                lineScroll(1);
                return (true);
            };
            if (_arg1 == Keyboard.PAGE_UP){
                pageScroll(-1);
                return (true);
            };
            if (_arg1 == Keyboard.PAGE_DOWN){
                pageScroll(1);
                return (true);
            };
            return (super.isScrollBarKey(_arg1));
        }
        override public function get minWidth():Number{
            return (_minWidth);
        }
        override public function set direction(_arg1:String):void{
        }

    }
}//package mx.controls 
