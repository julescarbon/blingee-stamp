package mx.logging {
    import flash.events.*;
    import mx.resources.*;

    public class LogLogger extends EventDispatcher implements ILogger {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _category:String;
        private var resourceManager:IResourceManager;

        public function LogLogger(_arg1:String){
            resourceManager = ResourceManager.getInstance();
            super();
            _category = _arg1;
        }
        public function log(_arg1:int, _arg2:String, ... _args):void{
            var _local4:String;
            var _local5:int;
            if (_arg1 < LogEventLevel.DEBUG){
                _local4 = resourceManager.getString("logging", "levelLimit");
                throw (new ArgumentError(_local4));
            };
            if (hasEventListener(LogEvent.LOG)){
                _local5 = 0;
                while (_local5 < _args.length) {
                    _arg2 = _arg2.replace(new RegExp((("\\{" + _local5) + "\\}"), "g"), _args[_local5]);
                    _local5++;
                };
                dispatchEvent(new LogEvent(_arg2, _arg1));
            };
        }
        public function error(_arg1:String, ... _args):void{
            var _local3:int;
            if (hasEventListener(LogEvent.LOG)){
                _local3 = 0;
                while (_local3 < _args.length) {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.ERROR));
            };
        }
        public function warn(_arg1:String, ... _args):void{
            var _local3:int;
            if (hasEventListener(LogEvent.LOG)){
                _local3 = 0;
                while (_local3 < _args.length) {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.WARN));
            };
        }
        public function get category():String{
            return (_category);
        }
        public function info(_arg1:String, ... _args):void{
            var _local3:int;
            if (hasEventListener(LogEvent.LOG)){
                _local3 = 0;
                while (_local3 < _args.length) {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.INFO));
            };
        }
        public function debug(_arg1:String, ... _args):void{
            var _local3:int;
            if (hasEventListener(LogEvent.LOG)){
                _local3 = 0;
                while (_local3 < _args.length) {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.DEBUG));
            };
        }
        public function fatal(_arg1:String, ... _args):void{
            var _local3:int;
            if (hasEventListener(LogEvent.LOG)){
                _local3 = 0;
                while (_local3 < _args.length) {
                    _arg1 = _arg1.replace(new RegExp((("\\{" + _local3) + "\\}"), "g"), _args[_local3]);
                    _local3++;
                };
                dispatchEvent(new LogEvent(_arg1, LogEventLevel.FATAL));
            };
        }

    }
}//package mx.logging 
