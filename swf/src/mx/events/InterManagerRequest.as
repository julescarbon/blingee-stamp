package mx.events {
    import mx.core.*;
    import flash.events.*;

    public class InterManagerRequest extends Event {

        public static const TOOLTIP_MANAGER_REQUEST:String = "tooltipManagerRequest";
        public static const SYSTEM_MANAGER_REQUEST:String = "systemManagerRequest";
        public static const INIT_MANAGER_REQUEST:String = "initManagerRequest";
        public static const DRAG_MANAGER_REQUEST:String = "dragManagerRequest";
        public static const CURSOR_MANAGER_REQUEST:String = "cursorManagerRequest";
        mx_internal static const VERSION:String = "3.2.0.3958";

        public var value:Object;
        public var name:String;

        public function InterManagerRequest(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Object=null){
            super(_arg1, _arg2, _arg3);
            this.name = _arg4;
            this.value = _arg5;
        }
        override public function clone():Event{
            var _local1:InterManagerRequest = new InterManagerRequest(type, bubbles, cancelable, name, value);
            return (_local1);
        }

    }
}//package mx.events 
