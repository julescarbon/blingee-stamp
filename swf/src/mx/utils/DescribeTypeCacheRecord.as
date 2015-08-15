package mx.utils {
    import flash.utils.*;

    public dynamic class DescribeTypeCacheRecord extends Proxy {

        public var typeDescription:XML;
        public var typeName:String;
        private var cache:Object;

        public function DescribeTypeCacheRecord(){
            cache = {};
            super();
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function getProperty(_arg1){
            var _local2:* = cache[_arg1];
            if (_local2 === undefined){
                _local2 = DescribeTypeCache.extractValue(_arg1, this);
                cache[_arg1] = _local2;
            };
            return (_local2);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function hasProperty(_arg1):Boolean{
            if ((_arg1 in cache)){
                return (true);
            };
            var _local2:* = DescribeTypeCache.extractValue(_arg1, this);
            if (_local2 === undefined){
                return (false);
            };
            cache[_arg1] = _local2;
            return (true);
        }

    }
}//package mx.utils 
