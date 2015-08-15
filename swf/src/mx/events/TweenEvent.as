package mx.events {
    import flash.events.*;

    public class TweenEvent extends Event {

        public static const TWEEN_END:String = "tweenEnd";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const TWEEN_UPDATE:String = "tweenUpdate";
        public static const TWEEN_START:String = "tweenStart";

        public var value:Object;

        public function TweenEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Object=null){
            super(_arg1, _arg2, _arg3);
            this.value = _arg4;
        }
        override public function clone():Event{
            return (new TweenEvent(type, bubbles, cancelable, value));
        }

    }
}//package mx.events 
