package mx.resources {
    import mx.core.*;
    import flash.system.*;
    import mx.utils.*;

    public class ResourceBundle implements IResourceBundle {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var backupApplicationDomain:ApplicationDomain;
        mx_internal static var locale:String;

        mx_internal var _locale:String;
        private var _content:Object;
        mx_internal var _bundleName:String;

        public function ResourceBundle(_arg1:String=null, _arg2:String=null){
            _content = {};
            super();
            mx_internal::_locale = _arg1;
            mx_internal::_bundleName = _arg2;
            _content = getContent();
        }
        private static function getClassByName(_arg1:String, _arg2:ApplicationDomain):Class{
            var _local3:Class;
            if (_arg2.hasDefinition(_arg1)){
                _local3 = (_arg2.getDefinition(_arg1) as Class);
            };
            return (_local3);
        }
        public static function getResourceBundle(_arg1:String, _arg2:ApplicationDomain=null):ResourceBundle{
            var _local3:String;
            var _local4:Class;
            var _local5:Object;
            var _local6:ResourceBundle;
            if (!_arg2){
                _arg2 = ApplicationDomain.currentDomain;
            };
            _local3 = (((mx_internal::locale + "$") + _arg1) + "_properties");
            _local4 = getClassByName(_local3, _arg2);
            if (!_local4){
                _local3 = (_arg1 + "_properties");
                _local4 = getClassByName(_local3, _arg2);
            };
            if (!_local4){
                _local3 = _arg1;
                _local4 = getClassByName(_local3, _arg2);
            };
            if (((!(_local4)) && (mx_internal::backupApplicationDomain))){
                _local3 = (_arg1 + "_properties");
                _local4 = getClassByName(_local3, mx_internal::backupApplicationDomain);
                if (!_local4){
                    _local3 = _arg1;
                    _local4 = getClassByName(_local3, mx_internal::backupApplicationDomain);
                };
            };
            if (_local4){
                _local5 = new (_local4)();
                if ((_local5 is ResourceBundle)){
                    _local6 = ResourceBundle(_local5);
                    return (_local6);
                };
            };
            throw (new Error(("Could not find resource bundle " + _arg1)));
        }

        protected function getContent():Object{
            return ({});
        }
        public function getString(_arg1:String):String{
            return (String(_getObject(_arg1)));
        }
        public function get content():Object{
            return (_content);
        }
        public function getBoolean(_arg1:String, _arg2:Boolean=true):Boolean{
            var _local3:String = _getObject(_arg1).toLowerCase();
            if (_local3 == "false"){
                return (false);
            };
            if (_local3 == "true"){
                return (true);
            };
            return (_arg2);
        }
        public function getStringArray(_arg1:String):Array{
            var _local2:Array = _getObject(_arg1).split(",");
            var _local3:int = _local2.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local2[_local4] = StringUtil.trim(_local2[_local4]);
                _local4++;
            };
            return (_local2);
        }
        public function getObject(_arg1:String):Object{
            return (_getObject(_arg1));
        }
        private function _getObject(_arg1:String):Object{
            var _local2:Object = content[_arg1];
            if (!_local2){
                throw (new Error(((("Key " + _arg1) + " was not found in resource bundle ") + bundleName)));
            };
            return (_local2);
        }
        public function get locale():String{
            return (mx_internal::_locale);
        }
        public function get bundleName():String{
            return (mx_internal::_bundleName);
        }
        public function getNumber(_arg1:String):Number{
            return (Number(_getObject(_arg1)));
        }

    }
}//package mx.resources 
