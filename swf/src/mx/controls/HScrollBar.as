package mx.controls {
    import mx.controls.scrollClasses.*;
    import flash.ui.*;

    public class HScrollBar extends ScrollBar {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function HScrollBar(){
            super.direction = ScrollBarDirection.HORIZONTAL;
            scaleX = -1;
            rotation = -90;
        }
        override mx_internal function get virtualHeight():Number{
            return (unscaledWidth);
        }
        override protected function measure():void{
            super.measure();
            measuredWidth = _minHeight;
            measuredHeight = _minWidth;
        }
        override public function get minHeight():Number{
            return (_minWidth);
        }
        override mx_internal function get virtualWidth():Number{
            return (unscaledHeight);
        }
        override public function get minWidth():Number{
            return (_minHeight);
        }
        override mx_internal function isScrollBarKey(_arg1:uint):Boolean{
            if (_arg1 == Keyboard.LEFT){
                lineScroll(-1);
                return (true);
            };
            if (_arg1 == Keyboard.RIGHT){
                lineScroll(1);
                return (true);
            };
            return (super.isScrollBarKey(_arg1));
        }
        override public function set direction(_arg1:String):void{
        }

    }
}//package mx.controls 
