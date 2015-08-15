package mx.collections.errors {
    import mx.rpc.*;

    public class ItemPendingError extends Error {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _responders:Array;

        public function ItemPendingError(_arg1:String){
            super(_arg1);
        }
        public function get responders():Array{
            return (_responders);
        }
        public function addResponder(_arg1:IResponder):void{
            if (!_responders){
                _responders = [];
            };
            _responders.push(_arg1);
        }

    }
}//package mx.collections.errors 
