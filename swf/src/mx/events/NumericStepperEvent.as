package mx.events {
    import flash.events.*;

    public class NumericStepperEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const CHANGE:String = "change";

        public var value:Number;
        public var triggerEvent:Event;

        public function NumericStepperEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Number=NaN, _arg5:Event=null){
            super(_arg1, _arg2, _arg3);
            this.value = _arg4;
            this.triggerEvent = _arg5;
        }
        override public function clone():Event{
            return (new NumericStepperEvent(type, bubbles, cancelable, value));
        }

    }
}//package mx.events 
