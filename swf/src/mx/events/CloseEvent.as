package mx.events {
    import flash.events.*;

    public class CloseEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const CLOSE:String = "close";

        public var detail:int;

        public function CloseEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1){
            super(_arg1, _arg2, _arg3);
            this.detail = _arg4;
        }
        override public function clone():Event{
            return (new CloseEvent(type, bubbles, cancelable, detail));
        }

    }
}//package mx.events 
