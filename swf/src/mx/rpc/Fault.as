package mx.rpc {

    public class Fault extends Error {

        public var rootCause:Object;
        protected var _faultCode:String;
        protected var _faultString:String;
        public var content:Object;
        protected var _faultDetail:String;

        public function Fault(_arg1:String, _arg2:String, _arg3:String=null){
            super((((((("faultCode:" + _arg1) + " faultString:'") + _arg2) + "' faultDetail:'") + _arg3) + "'"));
            this._faultCode = _arg1;
            this._faultString = ((_arg2) ? _arg2 : "");
            this._faultDetail = _arg3;
        }
        public function get faultString():String{
            return (_faultString);
        }
        public function toString():String{
            var _local1 = "[RPC Fault";
            _local1 = (_local1 + ((" faultString=\"" + faultString) + "\""));
            _local1 = (_local1 + ((" faultCode=\"" + faultCode) + "\""));
            _local1 = (_local1 + ((" faultDetail=\"" + faultDetail) + "\"]"));
            return (_local1);
        }
        public function get faultCode():String{
            return (_faultCode);
        }
        public function get faultDetail():String{
            return (_faultDetail);
        }

    }
}//package mx.rpc 
