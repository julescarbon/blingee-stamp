package mx.events {
    import flash.display.*;
    import flash.events.*;

    public class FlexMouseEvent extends MouseEvent {

        public static const MOUSE_DOWN_OUTSIDE:String = "mouseDownOutside";
        public static const MOUSE_WHEEL_OUTSIDE:String = "mouseWheelOutside";
        mx_internal static const VERSION:String = "3.2.0.3958";

        public function FlexMouseEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Number=0, _arg5:Number=0, _arg6:InteractiveObject=null, _arg7:Boolean=false, _arg8:Boolean=false, _arg9:Boolean=false, _arg10:Boolean=false, _arg11:int=0){
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11);
        }
        override public function clone():Event{
            return (new FlexMouseEvent(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta));
        }

    }
}//package mx.events 
