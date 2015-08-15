package mx.rpc {

    public class Responder implements IResponder {

        private var _faultHandler:Function;
        private var _resultHandler:Function;

        public function Responder(_arg1:Function, _arg2:Function){
            _resultHandler = _arg1;
            _faultHandler = _arg2;
        }
        public function result(_arg1:Object):void{
            _resultHandler(_arg1);
        }
        public function fault(_arg1:Object):void{
            _faultHandler(_arg1);
        }

    }
}//package mx.rpc 
