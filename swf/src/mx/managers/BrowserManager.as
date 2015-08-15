package mx.managers {
    import mx.core.*;

    public class BrowserManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var implClassDependency:BrowserManagerImpl;
        private static var instance:IBrowserManager;

        public static function getInstance():IBrowserManager{
            if (!instance){
                instance = IBrowserManager(Singleton.getInstance("mx.managers::IBrowserManager"));
            };
            return (instance);
        }

    }
}//package mx.managers 
