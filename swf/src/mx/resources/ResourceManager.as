package mx.resources {
    import mx.core.*;

    public class ResourceManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var implClassDependency:ResourceManagerImpl;
        private static var instance:IResourceManager;

        public static function getInstance():IResourceManager{
            if (!instance){
                try {
                    instance = IResourceManager(Singleton.getInstance("mx.resources::IResourceManager"));
                } catch(e:Error) {
                    instance = new ResourceManagerImpl();
                };
            };
            return (instance);
        }

    }
}//package mx.resources 
