package mx.binding {

    public class BindingManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        static var debugDestinationStrings:Object = {};

        public static function executeBindings(_arg1:Object, _arg2:String, _arg3:Object):void{
            var _local4:String;
            if (((!(_arg2)) || ((_arg2 == "")))){
                return;
            };
            if (((((((_arg1) && ((((_arg1 is IBindingClient)) || (_arg1.hasOwnProperty("_bindingsByDestination")))))) && (_arg1._bindingsByDestination))) && (_arg1._bindingsBeginWithWord[getFirstWord(_arg2)]))){
                for (_local4 in _arg1._bindingsByDestination) {
                    if (_local4.charAt(0) == _arg2.charAt(0)){
                        if ((((((_local4.indexOf((_arg2 + ".")) == 0)) || ((_local4.indexOf((_arg2 + "[")) == 0)))) || ((_local4 == _arg2)))){
                            _arg1._bindingsByDestination[_local4].execute(_arg3);
                        };
                    };
                };
            };
        }
        public static function addBinding(_arg1:Object, _arg2:String, _arg3:Binding):void{
            if (!_arg1._bindingsByDestination){
                _arg1._bindingsByDestination = {};
                _arg1._bindingsBeginWithWord = {};
            };
            _arg1._bindingsByDestination[_arg2] = _arg3;
            _arg1._bindingsBeginWithWord[getFirstWord(_arg2)] = true;
        }
        public static function debugBinding(_arg1:String):void{
            debugDestinationStrings[_arg1] = true;
        }
        private static function getFirstWord(_arg1:String):String{
            var _local2:int = _arg1.indexOf(".");
            var _local3:int = _arg1.indexOf("[");
            if (_local2 == _local3){
                return (_arg1);
            };
            var _local4:int = Math.min(_local2, _local3);
            if (_local4 == -1){
                _local4 = Math.max(_local2, _local3);
            };
            return (_arg1.substr(0, _local4));
        }
        public static function setEnabled(_arg1:Object, _arg2:Boolean):void{
            var _local3:Array;
            var _local4:uint;
            var _local5:Binding;
            if ((((_arg1 is IBindingClient)) && (_arg1._bindings))){
                _local3 = (_arg1._bindings as Array);
                _local4 = 0;
                while (_local4 < _local3.length) {
                    _local5 = _local3[_local4];
                    _local5.isEnabled = _arg2;
                    _local4++;
                };
            };
        }

    }
}//package mx.binding 
