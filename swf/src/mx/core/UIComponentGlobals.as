package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import mx.managers.*;

    public class UIComponentGlobals {

        mx_internal static var callLaterSuspendCount:int = 0;
        mx_internal static var layoutManager:ILayoutManager;
        mx_internal static var nextFocusObject:InteractiveObject;
        mx_internal static var designTime:Boolean = false;
        mx_internal static var tempMatrix:Matrix = new Matrix();
        mx_internal static var callLaterDispatcherCount:int = 0;
        private static var _catchCallLaterExceptions:Boolean = false;

        public static function set catchCallLaterExceptions(_arg1:Boolean):void{
            _catchCallLaterExceptions = _arg1;
        }
        public static function get designMode():Boolean{
            return (designTime);
        }
        public static function set designMode(_arg1:Boolean):void{
            designTime = _arg1;
        }
        public static function get catchCallLaterExceptions():Boolean{
            return (_catchCallLaterExceptions);
        }

    }
}//package mx.core 
