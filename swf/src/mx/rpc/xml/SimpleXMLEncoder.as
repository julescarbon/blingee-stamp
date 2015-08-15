package mx.rpc.xml {
    import flash.xml.*;
    import mx.utils.*;

    public class SimpleXMLEncoder {

        private static const ARRAY_TYPE:uint = 6;
        private static const DOC_TYPE:uint = 13;
        private static const XML_TYPE:uint = 5;
        private static const HEX_BINARY_TYPE:uint = 18;
        private static const FUNCTION_TYPE:uint = 15;
        private static const OBJECT_TYPE:uint = 2;
        private static const CLASS_INFO_OPTIONS:Object = {
            includeReadOnly:false,
            includeTransient:false
        };
        private static const ANY_TYPE:uint = 8;
        private static const BASE64_BINARY_TYPE:uint = 17;
        private static const BOOLEAN_TYPE:uint = 4;
        private static const ROWSET_TYPE:uint = 11;
        private static const MAP_TYPE:uint = 7;
        private static const SCHEMA_TYPE:uint = 14;
        private static const STRING_TYPE:uint = 1;
        private static const DATE_TYPE:uint = 3;
        private static const NUMBER_TYPE:uint = 0;
        private static const QBEAN_TYPE:uint = 12;
        private static const ELEMENT_TYPE:uint = 16;

        private var myXMLDoc:XMLDocument;

        public function SimpleXMLEncoder(_arg1:XMLDocument){
            this.myXMLDoc = ((_arg1) ? _arg1 : new XMLDocument());
        }
        static function encodeDate(_arg1:Date, _arg2:String):String{
            var _local4:Number;
            var _local3:String = new String();
            if ((((_arg2 == "dateTime")) || ((_arg2 == "date")))){
                _local3 = _local3.concat(_arg1.getUTCFullYear(), "-");
                _local4 = (_arg1.getUTCMonth() + 1);
                if (_local4 < 10){
                    _local3 = _local3.concat("0");
                };
                _local3 = _local3.concat(_local4, "-");
                _local4 = _arg1.getUTCDate();
                if (_local4 < 10){
                    _local3 = _local3.concat("0");
                };
                _local3 = _local3.concat(_local4);
            };
            if (_arg2 == "dateTime"){
                _local3 = _local3.concat("T");
            };
            if ((((_arg2 == "dateTime")) || ((_arg2 == "time")))){
                _local4 = _arg1.getUTCHours();
                if (_local4 < 10){
                    _local3 = _local3.concat("0");
                };
                _local3 = _local3.concat(_local4, ":");
                _local4 = _arg1.getUTCMinutes();
                if (_local4 < 10){
                    _local3 = _local3.concat("0");
                };
                _local3 = _local3.concat(_local4, ":");
                _local4 = _arg1.getUTCSeconds();
                if (_local4 < 10){
                    _local3 = _local3.concat("0");
                };
                _local3 = _local3.concat(_local4, ".");
                _local4 = _arg1.getUTCMilliseconds();
                if (_local4 < 10){
                    _local3 = _local3.concat("00");
                } else {
                    if (_local4 < 100){
                        _local3 = _local3.concat("0");
                    };
                };
                _local3 = _local3.concat(_local4);
            };
            _local3 = _local3.concat("Z");
            return (_local3);
        }

        public function encodeValue(_arg1:Object, _arg2:QName, _arg3:XMLNode):XMLNode{
            var _local4:XMLNode;
            var _local6:Object;
            var _local7:Array;
            var _local8:uint;
            var _local9:uint;
            var _local10:String;
            var _local11:QName;
            var _local12:uint;
            var _local13:QName;
            var _local14:uint;
            var _local15:String;
            var _local16:XMLNode;
            var _local17:String;
            var _local18:String;
            if (_arg1 == null){
                return (null);
            };
            var _local5:uint = getDataTypeFromObject(_arg1);
            if (_local5 == SimpleXMLEncoder.FUNCTION_TYPE){
                return (null);
            };
            if (_local5 == SimpleXMLEncoder.XML_TYPE){
                _local4 = _arg1.cloneNode(true);
                _arg3.appendChild(_local4);
                return (_local4);
            };
            _local4 = myXMLDoc.createElement("foo");
            _local4.nodeName = _arg2.localName;
            _arg3.appendChild(_local4);
            if (_local5 == SimpleXMLEncoder.OBJECT_TYPE){
                _local6 = ObjectUtil.getClassInfo(_arg1, null, CLASS_INFO_OPTIONS);
                _local7 = _local6.properties;
                _local8 = _local7.length;
                _local9 = 0;
                while (_local9 < _local8) {
                    _local10 = _local7[_local9];
                    _local11 = new QName("", _local10);
                    encodeValue(_arg1[_local10], _local11, _local4);
                    _local9++;
                };
            } else {
                if (_local5 == SimpleXMLEncoder.ARRAY_TYPE){
                    _local12 = _arg1.length;
                    _local13 = new QName("", "item");
                    _local14 = 0;
                    while (_local14 < _local12) {
                        encodeValue(_arg1[_local14], _local13, _local4);
                        _local14++;
                    };
                } else {
                    if (_local5 == SimpleXMLEncoder.DATE_TYPE){
                        _local15 = encodeDate((_arg1 as Date), "dateTime");
                    } else {
                        if (_local5 == SimpleXMLEncoder.NUMBER_TYPE){
                            if (_arg1 == Number.POSITIVE_INFINITY){
                                _local15 = "INF";
                            } else {
                                if (_arg1 == Number.NEGATIVE_INFINITY){
                                    _local15 = "-INF";
                                } else {
                                    _local17 = _arg1.toString();
                                    _local18 = _local17.substr(0, 2);
                                    if ((((_local18 == "0X")) || ((_local18 == "0x")))){
                                        _local15 = parseInt(_local17).toString();
                                    } else {
                                        _local15 = _local17;
                                    };
                                };
                            };
                        } else {
                            _local15 = _arg1.toString();
                        };
                    };
                    _local16 = myXMLDoc.createTextNode(_local15);
                    _local4.appendChild(_local16);
                };
            };
            return (_local4);
        }
        private function getDataTypeFromObject(_arg1:Object):uint{
            if ((_arg1 is Number)){
                return (SimpleXMLEncoder.NUMBER_TYPE);
            };
            if ((_arg1 is Boolean)){
                return (SimpleXMLEncoder.BOOLEAN_TYPE);
            };
            if ((_arg1 is String)){
                return (SimpleXMLEncoder.STRING_TYPE);
            };
            if ((_arg1 is XMLDocument)){
                return (SimpleXMLEncoder.XML_TYPE);
            };
            if ((_arg1 is Date)){
                return (SimpleXMLEncoder.DATE_TYPE);
            };
            if ((_arg1 is Array)){
                return (SimpleXMLEncoder.ARRAY_TYPE);
            };
            if ((_arg1 is Function)){
                return (SimpleXMLEncoder.FUNCTION_TYPE);
            };
            if ((_arg1 is Object)){
                return (SimpleXMLEncoder.OBJECT_TYPE);
            };
            return (SimpleXMLEncoder.STRING_TYPE);
        }

    }
}//package mx.rpc.xml 
