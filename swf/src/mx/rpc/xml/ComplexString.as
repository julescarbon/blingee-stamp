package mx.rpc.xml {
    import mx.rpc.xml.*;

    dynamic class ComplexString {

        public var value:String;

        public function ComplexString(_arg1:String){
            value = _arg1;
        }
        public function valueOf():Object{
            return (SimpleXMLDecoder.simpleType(value));
        }
        public function toString():String{
            return (value);
        }

    }
}//package mx.rpc.xml 
