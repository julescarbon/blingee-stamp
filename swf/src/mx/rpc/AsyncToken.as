package mx.rpc {
    import flash.events.*;
    import mx.events.*;
    import mx.rpc.events.*;
    import mx.messaging.messages.*;

    public dynamic class AsyncToken extends EventDispatcher {

        private var _message:IMessage;
        private var _responders:Array;
        private var _result:Object;

        public function AsyncToken(_arg1:IMessage){
            _message = _arg1;
        }
        public function addResponder(_arg1:IResponder):void{
            if (_responders == null){
                _responders = [];
            };
            _responders.push(_arg1);
        }
        mx_internal function setMessage(_arg1:IMessage):void{
            _message = _arg1;
        }
        public function get message():IMessage{
            return (_message);
        }
        mx_internal function applyResult(_arg1:ResultEvent):void{
            var _local2:uint;
            var _local3:IResponder;
            setResult(_arg1.result);
            if (_responders != null){
                _local2 = 0;
                while (_local2 < _responders.length) {
                    _local3 = _responders[_local2];
                    if (_local3 != null){
                        _local3.result(_arg1);
                    };
                    _local2++;
                };
            };
        }
        public function hasResponder():Boolean{
            return (((!((_responders == null))) && ((_responders.length > 0))));
        }
        public function get responders():Array{
            return (_responders);
        }
        mx_internal function applyFault(_arg1:FaultEvent):void{
            var _local2:uint;
            var _local3:IResponder;
            if (_responders != null){
                _local2 = 0;
                while (_local2 < _responders.length) {
                    _local3 = _responders[_local2];
                    if (_local3 != null){
                        _local3.fault(_arg1);
                    };
                    _local2++;
                };
            };
        }
        public function get result():Object{
            return (_result);
        }
        mx_internal function setResult(_arg1:Object):void{
            var _local2:PropertyChangeEvent;
            if (_result !== _arg1){
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "result", _result, _arg1);
                _result = _arg1;
                dispatchEvent(_local2);
            };
        }

    }
}//package mx.rpc 
