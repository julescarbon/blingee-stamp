package mx.messaging.config {
    import flash.utils.*;
    import mx.utils.*;

    public dynamic class ConfigMap extends Proxy {

        private var _item:Object;
        object_proxy var propertyList:Array;

        public function ConfigMap(_arg1:Object=null){
            if (!_arg1){
                _arg1 = {};
            };
            _item = _arg1;
            propertyList = [];
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function deleteProperty(_arg1):Boolean{
            var _local2:Object = _item[_arg1];
            var _local3 = delete _item[_arg1];
            var _local4 = -1;
            var _local5:int;
            while (_local5 < propertyList.length) {
                if (propertyList[_local5] == _arg1){
                    _local4 = _local5;
                    break;
                };
                _local5++;
            };
            if (_local4 > -1){
                propertyList.splice(_local4, 1);
            };
            return (_local3);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextName(_arg1:int):String{
            return (propertyList[(_arg1 - 1)]);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function getProperty(_arg1){
            var _local2:Object;
            _local2 = _item[_arg1];
            return (_local2);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function hasProperty(_arg1):Boolean{
            return ((_arg1 in _item));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextNameIndex(_arg1:int):int{
            if (_arg1 < propertyList.length){
                return ((_arg1 + 1));
            };
            return (0);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function setProperty(_arg1, _arg2):void{
            var _local4:int;
            var _local3:* = _item[_arg1];
            if (_local3 !== _arg2){
                _item[_arg1] = _arg2;
                _local4 = 0;
                while (_local4 < propertyList.length) {
                    if (propertyList[_local4] == _arg1){
                        return;
                    };
                    _local4++;
                };
                propertyList.push(_arg1);
            };
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function callProperty(_arg1, ... _args){
            return (_item[_arg1].apply(_item, _args));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextValue(_arg1:int){
            return (_item[propertyList[(_arg1 - 1)]]);
        }

    }
}//package mx.messaging.config 
