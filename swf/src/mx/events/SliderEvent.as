package mx.events {
    import flash.events.*;

    public class SliderEvent extends Event {

        public static const THUMB_PRESS:String = "thumbPress";
        public static const CHANGE:String = "change";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const THUMB_DRAG:String = "thumbDrag";
        public static const THUMB_RELEASE:String = "thumbRelease";

        public var value:Number;
        public var triggerEvent:Event;
        public var clickTarget:String;
        public var thumbIndex:int;
        public var keyCode:int;

        public function SliderEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1, _arg5:Number=NaN, _arg6:Event=null, _arg7:String=null, _arg8:int=-1){
            super(_arg1, _arg2, _arg3);
            this.thumbIndex = _arg4;
            this.value = _arg5;
            this.triggerEvent = _arg6;
            this.clickTarget = _arg7;
            this.keyCode = _arg8;
        }
        override public function clone():Event{
            return (new SliderEvent(type, bubbles, cancelable, thumbIndex, value, triggerEvent, clickTarget, keyCode));
        }

    }
}//package mx.events 
