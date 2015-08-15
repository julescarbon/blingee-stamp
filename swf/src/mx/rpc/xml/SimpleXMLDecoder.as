package mx.rpc.xml {
    import mx.collections.*;
    import flash.xml.*;
    import mx.utils.*;

    public class SimpleXMLDecoder {

        private var makeObjectsBindable:Boolean;

        public function SimpleXMLDecoder(_arg1:Boolean=false){
            this.makeObjectsBindable = _arg1;
        }
        public static function getLocalName(_arg1:XMLNode):String{
            var _local2:String = _arg1.nodeName;
            var _local3:int = _local2.indexOf(":");
            if (_local3 != -1){
                _local2 = _local2.substring((_local3 + 1));
            };
            return (_local2);
        }
        public static function simpleType(_arg1:Object):Object{
            var _local3:String;
            var _local4:String;
            var _local2:Object = _arg1;
            if (_arg1 != null){
                if ((((_arg1 is String)) && ((String(_arg1) == "")))){
                    _local2 = _arg1.toString();
                } else {
                    if (((((((isNaN(Number(_arg1))) || ((_arg1.charAt(0) == "0")))) || ((((_arg1.charAt(0) == "-")) && ((_arg1.charAt(1) == "0")))))) || ((_arg1.charAt((_arg1.length - 1)) == "E")))){
                        _local3 = _arg1.toString();
                        _local4 = _local3.toLowerCase();
                        if (_local4 == "true"){
                            _local2 = true;
                        } else {
                            if (_local4 == "false"){
                                _local2 = false;
                            } else {
                                _local2 = _local3;
                            };
                        };
                    } else {
                        _local2 = Number(_arg1);
                    };
                };
            };
            return (_local2);
        }

        public function decodeXML(_arg1:XMLNode):Object{
            var _local2:Object;
            var _local6:String;
            var _local7:uint;
            var _local8:XMLNode;
            var _local9:String;
            var _local10:Object;
            var _local11:Object;
            var _local3:Boolean;
            if (_arg1 == null){
                return (null);
            };
            var _local4:Array = _arg1.childNodes;
            if ((((_local4.length == 1)) && ((_local4[0].nodeType == XMLNodeType.TEXT_NODE)))){
                _local3 = true;
                _local2 = SimpleXMLDecoder.simpleType(_local4[0].nodeValue);
            } else {
                if (_local4.length > 0){
                    _local2 = {};
                    if (makeObjectsBindable){
                        _local2 = new ObjectProxy(_local2);
                    };
                    _local7 = 0;
                    while (_local7 < _local4.length) {
                        _local8 = _local4[_local7];
                        if (_local8.nodeType != XMLNodeType.ELEMENT_NODE){
                        } else {
                            _local9 = getLocalName(_local8);
                            _local10 = decodeXML(_local8);
                            _local11 = _local2[_local9];
                            if (_local11 != null){
                                if ((_local11 is Array)){
                                    _local11.push(_local10);
                                } else {
                                    if ((_local11 is ArrayCollection)){
                                        _local11.source.push(_local10);
                                    } else {
                                        _local11 = [_local11];
                                        _local11.push(_local10);
                                        if (makeObjectsBindable){
                                            _local11 = new ArrayCollection((_local11 as Array));
                                        };
                                        _local2[_local9] = _local11;
                                    };
                                };
                            } else {
                                _local2[_local9] = _local10;
                            };
                        };
                        _local7++;
                    };
                };
            };
            var _local5:Object = _arg1.attributes;
            for (_local6 in _local5) {
                if ((((_local6 == "xmlns")) || (!((_local6.indexOf("xmlns:") == -1))))){
                } else {
                    if (_local2 == null){
                        _local2 = {};
                        if (makeObjectsBindable){
                            _local2 = new ObjectProxy(_local2);
                        };
                    };
                    if (((_local3) && (!((_local2 is ComplexString))))){
                        _local2 = new ComplexString(_local2.toString());
                        _local3 = false;
                    };
                    _local2[_local6] = SimpleXMLDecoder.simpleType(_local5[_local6]);
                };
            };
            return (_local2);
        }

    }
}//package mx.rpc.xml 
