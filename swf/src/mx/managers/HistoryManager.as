package mx.managers {
    import mx.core.*;

    public class HistoryManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var implClassDependency:HistoryManagerImpl;
        private static var _impl:IHistoryManager;

        public static function save():void{
            impl.save();
        }
        private static function get impl():IHistoryManager{
            if (!_impl){
                _impl = IHistoryManager(Singleton.getInstance("mx.managers::IHistoryManager"));
            };
            return (_impl);
        }
        public static function register(_arg1:IHistoryManagerClient):void{
            impl.register(_arg1);
        }
        public static function unregister(_arg1:IHistoryManagerClient):void{
            impl.unregister(_arg1);
        }
        public static function initialize(_arg1:ISystemManager):void{
        }

    }
}//package mx.managers 
