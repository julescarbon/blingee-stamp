package mx.utils {
    import flash.utils.*;

    public class XMLNotifier {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:XMLNotifier;

        public function XMLNotifier(_arg1:XMLNotifierSingleton){
        }
        public static function getInstance():XMLNotifier{
            if (!instance){
                instance = new XMLNotifier(new XMLNotifierSingleton());
            };
            return (instance);
        }
        mx_internal static function initializeXMLForNotification():Function{
            var notificationFunction:* = function (_arg1:Object, _arg2:String, _arg3:Object, _arg4:Object, _arg5:Object):void{
                var _local8:Object;
                var _local7:Dictionary = arguments.callee.watched;
                if (_local7 != null){
                    for (_local8 in _local7) {
                        IXMLNotifiable(_local8).xmlNotification(_arg1, _arg2, _arg3, _arg4, _arg5);
                    };
                };
            };
            return (notificationFunction);
        }

        public function watchXML(_arg1:Object, _arg2:IXMLNotifiable, _arg3:String=null):void{
            var _local6:Dictionary;
            var _local4:XML = XML(_arg1);
            var _local5:Object = _local4.notification();
            if (!(_local5 is Function)){
                _local5 = initializeXMLForNotification();
                _local4.setNotification((_local5 as Function));
                if (((_arg3) && ((_local5["uid"] == null)))){
                    _local5["uid"] = _arg3;
                };
            };
            if (_local5["watched"] == undefined){
                _local6 = new Dictionary(true);
                _local5["watched"] = _local6;
            } else {
                _local6 = _local5["watched"];
            };
            _local6[_arg2] = true;
        }
        public function unwatchXML(_arg1:Object, _arg2:IXMLNotifiable):void{
            var _local5:Dictionary;
            var _local3:XML = XML(_arg1);
            var _local4:Object = _local3.notification();
            if (!(_local4 is Function)){
                return;
            };
            if (_local4["watched"] != undefined){
                _local5 = _local4["watched"];
                delete _local5[_arg2];
            };
        }

    }
}//package mx.utils 

class XMLNotifierSingleton {

    public function XMLNotifierSingleton(){
    }
}
