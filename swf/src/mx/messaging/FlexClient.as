package mx.messaging {
    import flash.events.*;
    import mx.events.*;

    public class FlexClient extends EventDispatcher {

        mx_internal static const NULL_FLEXCLIENT_ID:String = "nil";

        private static var _instance:FlexClient;

        private var _waitForFlexClientId:Boolean = false;
        private var _id:String;

        public static function getInstance():FlexClient{
            if (_instance == null){
                _instance = new (FlexClient)();
            };
            return (_instance);
        }

        public function get id():String{
            return (_id);
        }
        mx_internal function get waitForFlexClientId():Boolean{
            return (_waitForFlexClientId);
        }
        public function set id(_arg1:String):void{
            var _local2:PropertyChangeEvent;
            if (_id != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "id", _id, _arg1);
                _id = _arg1;
                dispatchEvent(_local2);
            };
        }
        mx_internal function set waitForFlexClientId(_arg1:Boolean):void{
            var _local2:PropertyChangeEvent;
            if (_waitForFlexClientId != _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "waitForFlexClientId", _waitForFlexClientId, _arg1);
                _waitForFlexClientId = _arg1;
                dispatchEvent(_local2);
            };
        }

    }
}//package mx.messaging 
