package mx.events {
    import flash.events.*;

    public class ResizeEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const RESIZE:String = "resize";

        public var oldHeight:Number;
        public var oldWidth:Number;

        public function ResizeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Number=NaN, _arg5:Number=NaN){
            super(_arg1, _arg2, _arg3);
            this.oldWidth = _arg4;
            this.oldHeight = _arg5;
        }
        override public function clone():Event{
            return (new ResizeEvent(type, bubbles, cancelable, oldWidth, oldHeight));
        }

    }
}//package mx.events 
