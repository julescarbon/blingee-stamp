package mx.rpc.events {
    import mx.messaging.events.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;

    public class AbstractEvent extends MessageEvent {

        private var _token:AsyncToken;

        public function AbstractEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=true, _arg4:AsyncToken=null, _arg5:IMessage=null){
            super(_arg1, _arg2, _arg3, _arg5);
            _token = _arg4;
        }
        public function get token():AsyncToken{
            return (_token);
        }
        mx_internal function callTokenResponders():void{
        }

    }
}//package mx.rpc.events 
