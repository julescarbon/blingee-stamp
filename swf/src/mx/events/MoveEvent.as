package mx.events {
    import flash.events.*;

    public class MoveEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const MOVE:String = "move";

        public var oldX:Number;
        public var oldY:Number;

        public function MoveEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Number=NaN, _arg5:Number=NaN){
            super(_arg1, _arg2, _arg3);
            this.oldX = _arg4;
            this.oldY = _arg5;
        }
        override public function clone():Event{
            return (new MoveEvent(type, bubbles, cancelable, oldX, oldY));
        }

    }
}//package mx.events 
