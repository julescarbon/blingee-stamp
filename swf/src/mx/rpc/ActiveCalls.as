package mx.rpc {

    public class ActiveCalls {

        private var callOrder:Array;
        private var calls:Object;

        public function ActiveCalls(){
            calls = {};
            callOrder = [];
        }
        public function removeCall(_arg1:String):AsyncToken{
            var _local2:AsyncToken = calls[_arg1];
            if (_local2 != null){
                delete calls[_arg1];
                callOrder.splice(callOrder.lastIndexOf(_arg1), 1);
            };
            return (_local2);
        }
        public function cancelLast():AsyncToken{
            if (callOrder.length > 0){
                return (removeCall((callOrder[(callOrder.length - 1)] as String)));
            };
            return (null);
        }
        public function hasActiveCalls():Boolean{
            return ((callOrder.length > 0));
        }
        public function wasLastCall(_arg1:String):Boolean{
            if (callOrder.length > 0){
                return ((callOrder[(callOrder.length - 1)] == _arg1));
            };
            return (false);
        }
        public function getAllMessages():Array{
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in calls) {
                _local1.push(calls[_local2]);
            };
            return (_local1);
        }
        public function addCall(_arg1:String, _arg2:AsyncToken):void{
            calls[_arg1] = _arg2;
            callOrder.push(_arg1);
        }

    }
}//package mx.rpc 
