package mx.events {
    import mx.core.*;
    import flash.events.*;

    public class ToolTipEvent extends Event {

        public static const TOOL_TIP_SHOWN:String = "toolTipShown";
        public static const TOOL_TIP_CREATE:String = "toolTipCreate";
        public static const TOOL_TIP_SHOW:String = "toolTipShow";
        public static const TOOL_TIP_HIDE:String = "toolTipHide";
        public static const TOOL_TIP_END:String = "toolTipEnd";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const TOOL_TIP_START:String = "toolTipStart";

        public var toolTip:IToolTip;

        public function ToolTipEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:IToolTip=null){
            super(_arg1, _arg2, _arg3);
            this.toolTip = _arg4;
        }
        override public function clone():Event{
            return (new ToolTipEvent(type, bubbles, cancelable, toolTip));
        }

    }
}//package mx.events 
