package mx.managers {
    import flash.display.*;
    import mx.core.*;

    public class PopUpManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var implClassDependency:PopUpManagerImpl;
        private static var _impl:IPopUpManager;

        private static function get impl():IPopUpManager{
            if (!_impl){
                _impl = IPopUpManager(Singleton.getInstance("mx.managers::IPopUpManager"));
            };
            return (_impl);
        }
        public static function removePopUp(_arg1:IFlexDisplayObject):void{
            impl.removePopUp(_arg1);
        }
        public static function addPopUp(_arg1:IFlexDisplayObject, _arg2:DisplayObject, _arg3:Boolean=false, _arg4:String=null):void{
            impl.addPopUp(_arg1, _arg2, _arg3, _arg4);
        }
        public static function centerPopUp(_arg1:IFlexDisplayObject):void{
            impl.centerPopUp(_arg1);
        }
        public static function bringToFront(_arg1:IFlexDisplayObject):void{
            impl.bringToFront(_arg1);
        }
        public static function createPopUp(_arg1:DisplayObject, _arg2:Class, _arg3:Boolean=false, _arg4:String=null):IFlexDisplayObject{
            return (impl.createPopUp(_arg1, _arg2, _arg3, _arg4));
        }

    }
}//package mx.managers 
