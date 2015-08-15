package mx.formatters {
    import flash.events.*;
    import mx.resources.*;

    public class Formatter {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var defaultInvalidFormatErrorOverride:String;
        private static var _defaultInvalidValueError:String;
        private static var _static_resourceManager:IResourceManager;
        private static var initialized:Boolean = false;
        private static var defaultInvalidValueErrorOverride:String;
        private static var _defaultInvalidFormatError:String;

        private var _resourceManager:IResourceManager;
        public var error:String;

        public function Formatter(){
            _resourceManager = ResourceManager.getInstance();
            super();
            resourceManager.addEventListener(Event.CHANGE, resourceManager_changeHandler, false, 0, true);
            resourcesChanged();
        }
        private static function static_resourcesChanged():void{
            defaultInvalidFormatError = defaultInvalidFormatErrorOverride;
            defaultInvalidValueError = defaultInvalidValueErrorOverride;
        }
        public static function set defaultInvalidValueError(_arg1:String):void{
            defaultInvalidValueErrorOverride = _arg1;
            _defaultInvalidValueError = ((_arg1)!=null) ? _arg1 : static_resourceManager.getString("formatters", "defaultInvalidValueError");
        }
        private static function static_resourceManager_changeHandler(_arg1:Event):void{
            static_resourcesChanged();
        }
        public static function get defaultInvalidValueError():String{
            initialize();
            return (_defaultInvalidValueError);
        }
        private static function get static_resourceManager():IResourceManager{
            if (!_static_resourceManager){
                _static_resourceManager = ResourceManager.getInstance();
            };
            return (_static_resourceManager);
        }
        public static function set defaultInvalidFormatError(_arg1:String):void{
            defaultInvalidFormatErrorOverride = _arg1;
            _defaultInvalidFormatError = ((_arg1)!=null) ? _arg1 : static_resourceManager.getString("formatters", "defaultInvalidFormatError");
        }
        private static function initialize():void{
            if (!initialized){
                static_resourceManager.addEventListener(Event.CHANGE, static_resourceManager_changeHandler, false, 0, true);
                static_resourcesChanged();
                initialized = true;
            };
        }
        public static function get defaultInvalidFormatError():String{
            initialize();
            return (_defaultInvalidFormatError);
        }

        protected function resourcesChanged():void{
        }
        private function resourceManager_changeHandler(_arg1:Event):void{
            resourcesChanged();
        }
        public function format(_arg1:Object):String{
            error = ("This format function is abstract. " + "Subclasses must override it.");
            return ("");
        }
        protected function get resourceManager():IResourceManager{
            return (_resourceManager);
        }

    }
}//package mx.formatters 
