package mx.utils {
    import mx.binding.*;
    import flash.utils.*;

    public class DescribeTypeCache {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cacheHandlers:Object = {};
        private static var typeCache:Object = {};

        public static function describeType(_arg1):DescribeTypeCacheRecord{
            var _local2:String;
            var _local3:XML;
            var _local4:DescribeTypeCacheRecord;
            if ((_arg1 is String)){
                _local2 = _arg1;
            } else {
                _local2 = getQualifiedClassName(_arg1);
            };
            if ((_local2 in typeCache)){
                return (typeCache[_local2]);
            };
            if ((_arg1 is String)){
                _arg1 = getDefinitionByName(_arg1);
            };
            _local3 = describeType(_arg1);
            _local4 = new DescribeTypeCacheRecord();
            _local4.typeDescription = _local3;
            _local4.typeName = _local2;
            typeCache[_local2] = _local4;
            return (_local4);
        }
        public static function registerCacheHandler(_arg1:String, _arg2:Function):void{
            cacheHandlers[_arg1] = _arg2;
        }
        static function extractValue(_arg1:String, _arg2:DescribeTypeCacheRecord){
            if ((_arg1 in cacheHandlers)){
                return (cacheHandlers[_arg1](_arg2));
            };
            return (undefined);
        }
        private static function bindabilityInfoHandler(_arg1:DescribeTypeCacheRecord){
            return (new BindabilityInfo(_arg1.typeDescription));
        }

        registerCacheHandler("bindabilityInfo", bindabilityInfoHandler);
    }
}//package mx.utils 
