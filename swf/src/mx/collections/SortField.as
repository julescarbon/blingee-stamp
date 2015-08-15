package mx.collections {
    import flash.events.*;
    import mx.resources.*;
    import mx.utils.*;
    import mx.collections.errors.*;

    public class SortField extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _caseInsensitive:Boolean;
        private var _numeric:Object;
        private var _descending:Boolean;
        private var _compareFunction:Function;
        private var _usingCustomCompareFunction:Boolean;
        private var _name:String;
        private var resourceManager:IResourceManager;

        public function SortField(_arg1:String=null, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Object=null){
            resourceManager = ResourceManager.getInstance();
            super();
            _name = _arg1;
            _caseInsensitive = _arg2;
            _descending = _arg3;
            _numeric = _arg4;
            _compareFunction = stringCompare;
        }
        public function get caseInsensitive():Boolean{
            return (_caseInsensitive);
        }
        mx_internal function get usingCustomCompareFunction():Boolean{
            return (_usingCustomCompareFunction);
        }
        public function set caseInsensitive(_arg1:Boolean):void{
            if (_arg1 != _caseInsensitive){
                _caseInsensitive = _arg1;
                dispatchEvent(new Event("caseInsensitiveChanged"));
            };
        }
        public function get name():String{
            return (_name);
        }
        public function get numeric():Object{
            return (_numeric);
        }
        public function set name(_arg1:String):void{
            _name = _arg1;
            dispatchEvent(new Event("nameChanged"));
        }
        private function numericCompare(_arg1:Object, _arg2:Object):int{
            var fa:* = NaN;
            var fb:* = NaN;
            var a:* = _arg1;
            var b:* = _arg2;
            try {
                fa = (((_name == null)) ? Number(a) : Number(a[_name]));
            } catch(error:Error) {
            };
            try {
                fb = (((_name == null)) ? Number(b) : Number(b[_name]));
            } catch(error:Error) {
            };
            return (ObjectUtil.numericCompare(fa, fb));
        }
        public function set numeric(_arg1:Object):void{
            if (_numeric != _arg1){
                _numeric = _arg1;
                dispatchEvent(new Event("numericChanged"));
            };
        }
        private function stringCompare(_arg1:Object, _arg2:Object):int{
            var fa:* = null;
            var fb:* = null;
            var a:* = _arg1;
            var b:* = _arg2;
            try {
                fa = (((_name == null)) ? String(a) : String(a[_name]));
            } catch(error:Error) {
            };
            try {
                fb = (((_name == null)) ? String(b) : String(b[_name]));
            } catch(error:Error) {
            };
            return (ObjectUtil.stringCompare(fa, fb, _caseInsensitive));
        }
        public function get compareFunction():Function{
            return (_compareFunction);
        }
        public function reverse():void{
            descending = !(descending);
        }
        mx_internal function getArraySortOnOptions():int{
            if (((((((usingCustomCompareFunction) || ((name == null)))) || ((_compareFunction == xmlCompare)))) || ((_compareFunction == dateCompare)))){
                return (-1);
            };
            var _local1:int;
            if (caseInsensitive){
                _local1 = (_local1 | Array.CASEINSENSITIVE);
            };
            if (descending){
                _local1 = (_local1 | Array.DESCENDING);
            };
            if ((((numeric == true)) || ((_compareFunction == numericCompare)))){
                _local1 = (_local1 | Array.NUMERIC);
            };
            return (_local1);
        }
        private function dateCompare(_arg1:Object, _arg2:Object):int{
            var fa:* = null;
            var fb:* = null;
            var a:* = _arg1;
            var b:* = _arg2;
            try {
                fa = (((_name == null)) ? (a as Date) : (a[_name] as Date));
            } catch(error:Error) {
            };
            try {
                fb = (((_name == null)) ? (b as Date) : (b[_name] as Date));
            } catch(error:Error) {
            };
            return (ObjectUtil.dateCompare(fa, fb));
        }
        mx_internal function internalCompare(_arg1:Object, _arg2:Object):int{
            var _local3:int = compareFunction(_arg1, _arg2);
            if (descending){
                _local3 = (_local3 * -1);
            };
            return (_local3);
        }
        override public function toString():String{
            return (ObjectUtil.toString(this));
        }
        private function nullCompare(_arg1:Object, _arg2:Object):int{
            var value:* = null;
            var left:* = null;
            var right:* = null;
            var message:* = null;
            var a:* = _arg1;
            var b:* = _arg2;
            var found:* = false;
            if ((((a == null)) && ((b == null)))){
                return (0);
            };
            if (_name){
                try {
                    left = a[_name];
                } catch(error:Error) {
                };
                try {
                    right = b[_name];
                } catch(error:Error) {
                };
            };
            if ((((left == null)) && ((right == null)))){
                return (0);
            };
            if (left == null){
                left = a;
            };
            if (right == null){
                right = b;
            };
            var typeLeft:* = typeof(left);
            var typeRight:* = typeof(right);
            if ((((typeLeft == "string")) || ((typeRight == "string")))){
                found = true;
                _compareFunction = stringCompare;
            } else {
                if ((((typeLeft == "object")) || ((typeRight == "object")))){
                    if ((((left is Date)) || ((right is Date)))){
                        found = true;
                        _compareFunction = dateCompare;
                    };
                } else {
                    if ((((typeLeft == "xml")) || ((typeRight == "xml")))){
                        found = true;
                        _compareFunction = xmlCompare;
                    } else {
                        if ((((((((typeLeft == "number")) || ((typeRight == "number")))) || ((typeLeft == "boolean")))) || ((typeRight == "boolean")))){
                            found = true;
                            _compareFunction = numericCompare;
                        };
                    };
                };
            };
            if (found){
                return (_compareFunction(left, right));
            };
            message = resourceManager.getString("collections", "noComparatorSortField", [name]);
            throw (new SortError(message));
        }
        public function set descending(_arg1:Boolean):void{
            if (_descending != _arg1){
                _descending = _arg1;
                dispatchEvent(new Event("descendingChanged"));
            };
        }
        mx_internal function initCompare(_arg1:Object):void{
            var value:* = null;
            var typ:* = null;
            var test:* = null;
            var obj:* = _arg1;
            if (!usingCustomCompareFunction){
                if (numeric == true){
                    _compareFunction = numericCompare;
                } else {
                    if (((caseInsensitive) || ((numeric == false)))){
                        _compareFunction = stringCompare;
                    } else {
                        if (_name){
                            try {
                                value = obj[_name];
                            } catch(error:Error) {
                            };
                        };
                        if (value == null){
                            value = obj;
                        };
                        typ = typeof(value);
                        switch (typ){
                            case "string":
                                _compareFunction = stringCompare;
                                break;
                            case "object":
                                if ((value is Date)){
                                    _compareFunction = dateCompare;
                                } else {
                                    _compareFunction = stringCompare;
                                    try {
                                        test = value.toString();
                                    } catch(error2:Error) {
                                    };
                                    if (((!(test)) || ((test == "[object Object]")))){
                                        _compareFunction = nullCompare;
                                    };
                                };
                                break;
                            case "xml":
                                _compareFunction = xmlCompare;
                                break;
                            case "boolean":
                            case "number":
                                _compareFunction = numericCompare;
                                break;
                        };
                    };
                };
            };
        }
        public function get descending():Boolean{
            return (_descending);
        }
        public function set compareFunction(_arg1:Function):void{
            _compareFunction = _arg1;
            _usingCustomCompareFunction = !((_arg1 == null));
        }
        private function xmlCompare(_arg1:Object, _arg2:Object):int{
            var sa:* = null;
            var sb:* = null;
            var a:* = _arg1;
            var b:* = _arg2;
            try {
                sa = (((_name == null)) ? a.toString() : a[_name].toString());
            } catch(error:Error) {
            };
            try {
                sb = (((_name == null)) ? b.toString() : b[_name].toString());
            } catch(error:Error) {
            };
            if (numeric == true){
                return (ObjectUtil.numericCompare(parseFloat(sa), parseFloat(sb)));
            };
            return (ObjectUtil.stringCompare(sa, sb, _caseInsensitive));
        }

    }
}//package mx.collections 
