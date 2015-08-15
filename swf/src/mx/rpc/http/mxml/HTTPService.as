package mx.rpc.http.mxml {
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.resources.*;
    import mx.rpc.events.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;
    import mx.rpc.http.*;
    import mx.rpc.mxml.*;

    public class HTTPService extends HTTPService implements IMXMLSupport, IMXMLObject {

        private var id:String;
        private var document:Object;
        private var _showBusyCursor:Boolean;
        private var _concurrency:String;
        private var resourceManager:IResourceManager;

        public function HTTPService(_arg1:String=null, _arg2:String=null){
            resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
            showBusyCursor = false;
            concurrency = Concurrency.MULTIPLE;
        }
        override public function send(_arg1:Object=null):AsyncToken{
            var _local2:AsyncToken;
            var _local3:String;
            var _local4:Fault;
            var _local5:FaultEvent;
            if ((((Concurrency.SINGLE == concurrency)) && (activeCalls.hasActiveCalls()))){
                _local2 = new AsyncToken(null);
                _local3 = resourceManager.getString("rpc", "pendingCallExists");
                _local4 = new Fault("ConcurrencyError", _local3);
                _local5 = FaultEvent.createEvent(_local4, _local2);
                new AsyncDispatcher(dispatchRpcEvent, [_local5], 10);
                return (_local2);
            };
            return (super.send(_arg1));
        }
        override mx_internal function dispatchRpcEvent(_arg1:AbstractEvent):void{
            var _local2:ErrorEvent;
            _arg1.callTokenResponders();
            if (!_arg1.isDefaultPrevented()){
                if (hasEventListener(_arg1.type)){
                    dispatchEvent(_arg1);
                } else {
                    if ((((_arg1 is FaultEvent)) && ((((_arg1.token == null)) || (!(_arg1.token.hasResponder())))))){
                        if (((document) && (document.willTrigger(ErrorEvent.ERROR)))){
                            _local2 = new ErrorEvent(ErrorEvent.ERROR, true, true);
                            _local2.text = FaultEvent(_arg1).fault.faultString;
                            document.dispatchEvent(_local2);
                        } else {
                            throw (FaultEvent(_arg1).fault);
                        };
                    };
                };
            };
        }
        public function get concurrency():String{
            return (_concurrency);
        }
        public function set showBusyCursor(_arg1:Boolean):void{
            _showBusyCursor = _arg1;
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            this.id = _arg2;
            this.document = _arg1;
        }
        public function get showBusyCursor():Boolean{
            return (_showBusyCursor);
        }
        public function set concurrency(_arg1:String):void{
            _concurrency = _arg1;
        }
        override mx_internal function preHandle(_arg1:MessageEvent):AsyncToken{
            if (showBusyCursor){
                CursorManager.removeBusyCursor();
            };
            var _local2:Boolean = activeCalls.wasLastCall(AsyncMessage(_arg1.message).correlationId);
            var _local3:AsyncToken = super.preHandle(_arg1);
            if ((((Concurrency.LAST == concurrency)) && (!(_local2)))){
                return (null);
            };
            return (_local3);
        }
        override mx_internal function invoke(_arg1:IMessage, _arg2:AsyncToken=null):AsyncToken{
            if (showBusyCursor){
                CursorManager.setBusyCursor();
            };
            return (super.invoke(_arg1, _arg2));
        }
        override public function cancel(_arg1:String=null):AsyncToken{
            if (showBusyCursor){
                CursorManager.removeBusyCursor();
            };
            return (super.cancel(_arg1));
        }

    }
}//package mx.rpc.http.mxml 
