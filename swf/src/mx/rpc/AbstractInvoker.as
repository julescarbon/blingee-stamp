package mx.rpc {
    import flash.events.*;
    import mx.resources.*;
    import mx.rpc.events.*;
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import mx.logging.*;
    import mx.utils.*;
    import mx.messaging.errors.*;

    public class AbstractInvoker extends EventDispatcher {

        mx_internal static const BINDING_RESULT:String = "resultForBinding";

        mx_internal var _responseHeaders:Array;
        private var resourceManager:IResourceManager;
        private var _asyncRequest:AsyncRequest;
        private var _log:ILogger;
        mx_internal var activeCalls:ActiveCalls;
        mx_internal var _result:Object;
        mx_internal var _makeObjectsBindable:Boolean;

        public function AbstractInvoker(){
            resourceManager = ResourceManager.getInstance();
            super();
            _log = Log.getLogger("mx.rpc.AbstractInvoker");
            activeCalls = new ActiveCalls();
        }
        mx_internal function getNetmonId():String{
            return (null);
        }
        public function cancel(_arg1:String=null):AsyncToken{
            if (_arg1 != null){
                return (activeCalls.removeCall(_arg1));
            };
            return (activeCalls.cancelLast());
        }
        mx_internal function processFault(_arg1:IMessage, _arg2:AsyncToken):Boolean{
            return (true);
        }
        mx_internal function faultHandler(_arg1:MessageFaultEvent):void{
            var _local4:Fault;
            var _local5:FaultEvent;
            var _local2:MessageEvent = MessageEvent.createEvent(MessageEvent.MESSAGE, _arg1.message);
            var _local3:AsyncToken = preHandle(_local2);
            if ((((((((_local3 == null)) && (!((AsyncMessage(_arg1.message).correlationId == null))))) && (!((AsyncMessage(_arg1.message).correlationId == ""))))) && (!((_arg1.faultCode == "Client.Authentication"))))){
                return;
            };
            if (processFault(_arg1.message, _local3)){
                _local4 = new Fault(_arg1.faultCode, _arg1.faultString, _arg1.faultDetail);
                _local4.content = _arg1.message.body;
                _local4.rootCause = _arg1.rootCause;
                _local5 = FaultEvent.createEvent(_local4, _local3, _arg1.message);
                _local5.headers = _responseHeaders;
                dispatchRpcEvent(_local5);
            };
        }
        public function clearResult(_arg1:Boolean=true):void{
            _result = null;
            if (_arg1){
                dispatchEvent(new Event(BINDING_RESULT));
            };
        }
        mx_internal function get asyncRequest():AsyncRequest{
            if (_asyncRequest == null){
                _asyncRequest = new AsyncRequest();
            };
            return (_asyncRequest);
        }
        mx_internal function dispatchRpcEvent(_arg1:AbstractEvent):void{
            _arg1.callTokenResponders();
            if (!_arg1.isDefaultPrevented()){
                dispatchEvent(_arg1);
            };
        }
        public function get lastResult():Object{
            return (_result);
        }
        mx_internal function set asyncRequest(_arg1:AsyncRequest):void{
            _asyncRequest = _arg1;
        }
        mx_internal function preHandle(_arg1:MessageEvent):AsyncToken{
            return (activeCalls.removeCall(AsyncMessage(_arg1.message).correlationId));
        }
        mx_internal function processResult(_arg1:IMessage, _arg2:AsyncToken):Boolean{
            var _local3:Object = _arg1.body;
            if (((((makeObjectsBindable) && (!((_local3 == null))))) && ((getQualifiedClassName(_local3) == "Object")))){
                _result = new ObjectProxy(_local3);
            } else {
                _result = _local3;
            };
            return (true);
        }
        mx_internal function resultHandler(_arg1:MessageEvent):void{
            var _local3:ResultEvent;
            var _local2:AsyncToken = preHandle(_arg1);
            if (_local2 == null){
                return;
            };
            if (processResult(_arg1.message, _local2)){
                dispatchEvent(new Event(BINDING_RESULT));
                _local3 = ResultEvent.createEvent(_result, _local2, _arg1.message);
                _local3.headers = _responseHeaders;
                dispatchRpcEvent(_local3);
            };
        }
        public function set makeObjectsBindable(_arg1:Boolean):void{
            _makeObjectsBindable = _arg1;
        }
        public function get makeObjectsBindable():Boolean{
            return (_makeObjectsBindable);
        }
        mx_internal function invoke(_arg1:IMessage, _arg2:AsyncToken=null):AsyncToken{
            var fault:* = null;
            var errorText:* = null;
            var message:* = _arg1;
            var token = _arg2;
            if (token == null){
                token = new AsyncToken(message);
            } else {
                token.setMessage(message);
            };
            activeCalls.addCall(message.messageId, token);
            try {
                asyncRequest.invoke(message, new Responder(resultHandler, faultHandler));
                dispatchRpcEvent(InvokeEvent.createEvent(token, message));
            } catch(e:MessagingError) {
                _log.warn(e.toString());
                errorText = resourceManager.getString("rpc", "cannotConnectToDestination", [asyncRequest.destination]);
                fault = new Fault("InvokeFailed", e.toString(), errorText);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            } catch(e2:Error) {
                _log.warn(e2.toString());
                fault = new Fault("InvokeFailed", e2.message);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            };
            return (token);
        }

    }
}//package mx.rpc 
