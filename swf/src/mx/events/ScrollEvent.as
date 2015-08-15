package mx.events {
    import flash.events.*;

    public class ScrollEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const SCROLL:String = "scroll";

        public var detail:String;
        public var delta:Number;
        public var position:Number;
        public var direction:String;

        public function ScrollEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Number=NaN, _arg6:String=null, _arg7:Number=NaN){
            super(_arg1, _arg2, _arg3);
            this.detail = _arg4;
            this.position = _arg5;
            this.direction = _arg6;
            this.delta = _arg7;
        }
        override public function clone():Event{
            return (new ScrollEvent(type, bubbles, cancelable, detail, position, direction, delta));
        }

    }
}//package mx.events 
