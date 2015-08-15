package mx.events {
    import flash.events.*;

    public class StateChangeEvent extends Event {

        public static const CURRENT_STATE_CHANGING:String = "currentStateChanging";
        public static const CURRENT_STATE_CHANGE:String = "currentStateChange";
        mx_internal static const VERSION:String = "3.2.0.3958";

        public var newState:String;
        public var oldState:String;

        public function StateChangeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:String=null){
            super(_arg1, _arg2, _arg3);
            this.oldState = _arg4;
            this.newState = _arg5;
        }
        override public function clone():Event{
            return (new StateChangeEvent(type, bubbles, cancelable, oldState, newState));
        }

    }
}//package mx.events 
