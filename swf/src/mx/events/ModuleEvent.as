package mx.events {
    import mx.core.*;
    import flash.events.*;
    import mx.modules.*;

    public class ModuleEvent extends ProgressEvent {

        public static const READY:String = "ready";
        public static const ERROR:String = "error";
        public static const PROGRESS:String = "progress";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const SETUP:String = "setup";
        public static const UNLOAD:String = "unload";

        public var errorText:String;
        private var _module:IModuleInfo;

        public function ModuleEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:uint=0, _arg5:uint=0, _arg6:String=null, _arg7:IModuleInfo=null){
            super(_arg1, _arg2, _arg3, _arg4, _arg5);
            this.errorText = _arg6;
            this._module = _arg7;
        }
        public function get module():IModuleInfo{
            if (_module){
                return (_module);
            };
            return ((target as IModuleInfo));
        }
        override public function clone():Event{
            return (new ModuleEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal, errorText, module));
        }

    }
}//package mx.events 
