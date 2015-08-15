package mx.logging {
    import mx.resources.*;
    import mx.logging.errors.*;

    public class Log {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var _resourceManager:IResourceManager;
        private static var _targets:Array = [];
        private static var _loggers:Array;
        private static var NONE:int = 2147483647;
        private static var _targetLevel:int = NONE;

        private static function categoryMatchInFilterList(_arg1:String, _arg2:Array):Boolean{
            var _local4:String;
            var _local3:Boolean;
            var _local5 = -1;
            var _local6:uint;
            while (_local6 < _arg2.length) {
                _local4 = _arg2[_local6];
                _local5 = _local4.indexOf("*");
                if (_local5 == 0){
                    return (true);
                };
                _local5 = (((_local5 < 0)) ? _local5 = _arg1.length;
_local5 : (_local5 - 1));
                if (_arg1.substring(0, _local5) == _local4.substring(0, _local5)){
                    return (true);
                };
                _local6++;
            };
            return (false);
        }
        public static function flush():void{
            _loggers = [];
            _targets = [];
            _targetLevel = NONE;
        }
        public static function isDebug():Boolean{
            return (((_targetLevel)<=LogEventLevel.DEBUG) ? true : false);
        }
        public static function getLogger(_arg1:String):ILogger{
            var _local3:ILoggingTarget;
            checkCategory(_arg1);
            if (!_loggers){
                _loggers = [];
            };
            var _local2:ILogger = _loggers[_arg1];
            if (_local2 == null){
                _local2 = new LogLogger(_arg1);
                _loggers[_arg1] = _local2;
            };
            var _local4:int;
            while (_local4 < _targets.length) {
                _local3 = ILoggingTarget(_targets[_local4]);
                if (categoryMatchInFilterList(_arg1, _local3.filters)){
                    _local3.addLogger(_local2);
                };
                _local4++;
            };
            return (_local2);
        }
        public static function isWarn():Boolean{
            return (((_targetLevel)<=LogEventLevel.WARN) ? true : false);
        }
        public static function addTarget(_arg1:ILoggingTarget):void{
            var _local2:Array;
            var _local3:ILogger;
            var _local4:String;
            var _local5:String;
            if (_arg1){
                _local2 = _arg1.filters;
                for (_local4 in _loggers) {
                    if (categoryMatchInFilterList(_local4, _local2)){
                        _arg1.addLogger(ILogger(_loggers[_local4]));
                    };
                };
                _targets.push(_arg1);
                if (_targetLevel == NONE){
                    _targetLevel = _arg1.level;
                } else {
                    if (_arg1.level < _targetLevel){
                        _targetLevel = _arg1.level;
                    };
                };
            } else {
                _local5 = resourceManager.getString("logging", "invalidTarget");
                throw (new ArgumentError(_local5));
            };
        }
        public static function hasIllegalCharacters(_arg1:String):Boolean{
            return (!((_arg1.search(/[\[\]\~\$\^\&\\(\)\{\}\+\?\/=`!@#%,:;'"<>\s]/) == -1)));
        }
        private static function checkCategory(_arg1:String):void{
            var _local2:String;
            if ((((_arg1 == null)) || ((_arg1.length == 0)))){
                _local2 = resourceManager.getString("logging", "invalidLen");
                throw (new InvalidCategoryError(_local2));
            };
            if (((hasIllegalCharacters(_arg1)) || (!((_arg1.indexOf("*") == -1))))){
                _local2 = resourceManager.getString("logging", "invalidChars");
                throw (new InvalidCategoryError(_local2));
            };
        }
        private static function resetTargetLevel():void{
            var _local1:int = NONE;
            var _local2:int;
            while (_local2 < _targets.length) {
                if ((((_local1 == NONE)) || ((_targets[_local2].level < _local1)))){
                    _local1 = _targets[_local2].level;
                };
                _local2++;
            };
            _targetLevel = _local1;
        }
        public static function removeTarget(_arg1:ILoggingTarget):void{
            var _local2:Array;
            var _local3:ILogger;
            var _local4:String;
            var _local5:int;
            var _local6:String;
            if (_arg1){
                _local2 = _arg1.filters;
                for (_local4 in _loggers) {
                    if (categoryMatchInFilterList(_local4, _local2)){
                        _arg1.removeLogger(ILogger(_loggers[_local4]));
                    };
                };
                _local5 = 0;
                while (_local5 < _targets.length) {
                    if (_arg1 == _targets[_local5]){
                        _targets.splice(_local5, 1);
                        _local5--;
                    };
                    _local5++;
                };
                resetTargetLevel();
            } else {
                _local6 = resourceManager.getString("logging", "invalidTarget");
                throw (new ArgumentError(_local6));
            };
        }
        public static function isInfo():Boolean{
            return (((_targetLevel)<=LogEventLevel.INFO) ? true : false);
        }
        public static function isFatal():Boolean{
            return (((_targetLevel)<=LogEventLevel.FATAL) ? true : false);
        }
        public static function isError():Boolean{
            return (((_targetLevel)<=LogEventLevel.ERROR) ? true : false);
        }
        private static function get resourceManager():IResourceManager{
            if (!_resourceManager){
                _resourceManager = ResourceManager.getInstance();
            };
            return (_resourceManager);
        }

    }
}//package mx.logging 
