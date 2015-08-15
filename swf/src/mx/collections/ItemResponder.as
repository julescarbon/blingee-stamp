package mx.collections {
    import mx.rpc.*;

    public class ItemResponder implements IResponder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _faultHandler:Function;
        private var _token:Object;
        private var _resultHandler:Function;

        public function ItemResponder(_arg1:Function, _arg2:Function, _arg3:Object=null){
            _resultHandler = _arg1;
            _faultHandler = _arg2;
            _token = _arg3;
        }
        public function result(_arg1:Object):void{
            _resultHandler(_arg1, _token);
        }
        public function fault(_arg1:Object):void{
            _faultHandler(_arg1, _token);
        }

    }
}//package mx.collections 
