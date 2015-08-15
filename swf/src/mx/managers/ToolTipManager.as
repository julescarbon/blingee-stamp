package mx.managers {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.effects.*;

    public class ToolTipManager extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var implClassDependency:ToolTipManagerImpl;
        private static var _impl:IToolTipManager2;

        mx_internal static function registerToolTip(_arg1:DisplayObject, _arg2:String, _arg3:String):void{
            impl.registerToolTip(_arg1, _arg2, _arg3);
        }
        public static function get enabled():Boolean{
            return (impl.enabled);
        }
        public static function set enabled(_arg1:Boolean):void{
            impl.enabled = _arg1;
        }
        public static function createToolTip(_arg1:String, _arg2:Number, _arg3:Number, _arg4:String=null, _arg5:IUIComponent=null):IToolTip{
            return (impl.createToolTip(_arg1, _arg2, _arg3, _arg4, _arg5));
        }
        public static function set hideDelay(_arg1:Number):void{
            impl.hideDelay = _arg1;
        }
        public static function set showDelay(_arg1:Number):void{
            impl.showDelay = _arg1;
        }
        public static function get showDelay():Number{
            return (impl.showDelay);
        }
        public static function destroyToolTip(_arg1:IToolTip):void{
            return (impl.destroyToolTip(_arg1));
        }
        public static function get scrubDelay():Number{
            return (impl.scrubDelay);
        }
        public static function get toolTipClass():Class{
            return (impl.toolTipClass);
        }
        mx_internal static function registerErrorString(_arg1:DisplayObject, _arg2:String, _arg3:String):void{
            impl.registerErrorString(_arg1, _arg2, _arg3);
        }
        mx_internal static function sizeTip(_arg1:IToolTip):void{
            impl.sizeTip(_arg1);
        }
        public static function set currentTarget(_arg1:DisplayObject):void{
            impl.currentTarget = _arg1;
        }
        public static function set showEffect(_arg1:IAbstractEffect):void{
            impl.showEffect = _arg1;
        }
        private static function get impl():IToolTipManager2{
            if (!_impl){
                _impl = IToolTipManager2(Singleton.getInstance("mx.managers::IToolTipManager2"));
            };
            return (_impl);
        }
        public static function get hideDelay():Number{
            return (impl.hideDelay);
        }
        public static function set hideEffect(_arg1:IAbstractEffect):void{
            impl.hideEffect = _arg1;
        }
        public static function set scrubDelay(_arg1:Number):void{
            impl.scrubDelay = _arg1;
        }
        public static function get currentToolTip():IToolTip{
            return (impl.currentToolTip);
        }
        public static function set currentToolTip(_arg1:IToolTip):void{
            impl.currentToolTip = _arg1;
        }
        public static function get showEffect():IAbstractEffect{
            return (impl.showEffect);
        }
        public static function get currentTarget():DisplayObject{
            return (impl.currentTarget);
        }
        public static function get hideEffect():IAbstractEffect{
            return (impl.hideEffect);
        }
        public static function set toolTipClass(_arg1:Class):void{
            impl.toolTipClass = _arg1;
        }

    }
}//package mx.managers 
