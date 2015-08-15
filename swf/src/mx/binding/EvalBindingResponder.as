package mx.binding {
    import mx.rpc.*;

    public class EvalBindingResponder implements IResponder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var binding:Binding;
        private var object:Object;

        public function EvalBindingResponder(_arg1:Binding, _arg2:Object){
            this.binding = _arg1;
            this.object = _arg2;
        }
        public function fault(_arg1:Object):void{
        }
        public function result(_arg1:Object):void{
            binding.execute(object);
        }

    }
}//package mx.binding 
