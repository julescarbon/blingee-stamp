package mx.events {
    import mx.core.*;
    import flash.events.*;
    import flash.net.*;

    public class RSLEvent extends ProgressEvent {

        public static const RSL_PROGRESS:String = "rslProgress";
        public static const RSL_ERROR:String = "rslError";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const RSL_COMPLETE:String = "rslComplete";

        public var errorText:String;
        public var rslIndex:int;
        public var rslTotal:int;
        public var url:URLRequest;

        public function RSLEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1, _arg5:int=-1, _arg6:int=-1, _arg7:int=-1, _arg8:URLRequest=null, _arg9:String=null){
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
            this.rslIndex = _arg6;
            this.rslTotal = _arg7;
            this.url = _arg8;
            this.errorText = _arg9;
        }
        override public function clone():Event{
            return (new RSLEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, rslIndex, rslTotal, url, errorText));
        }

    }
}//package mx.events 
