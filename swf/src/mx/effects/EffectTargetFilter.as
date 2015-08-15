package mx.effects {
    import mx.effects.effectClasses.*;

    public class EffectTargetFilter {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var filterFunction:Function;
        public var filterStyles:Array;
        public var filterProperties:Array;
        public var requiredSemantics:Object = null;

        public function EffectTargetFilter(){
            filterFunction = defaultFilterFunctionEx;
            filterProperties = [];
            filterStyles = [];
            super();
        }
        protected function defaultFilterFunctionEx(_arg1:Array, _arg2:IEffectTargetHost, _arg3:Object):Boolean{
            var _local4:String;
            if (requiredSemantics){
                for (_local4 in requiredSemantics) {
                    if (!_arg2){
                        return (false);
                    };
                    if (_arg2.getRendererSemanticValue(_arg3, _local4) != requiredSemantics[_local4]){
                        return (false);
                    };
                };
                return (true);
            };
            return (defaultFilterFunction(_arg1, _arg3));
        }
        protected function defaultFilterFunction(_arg1:Array, _arg2:Object):Boolean{
            var _local5:PropertyChanges;
            var _local6:Array;
            var _local7:int;
            var _local8:int;
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = _arg1[_local4];
                if (_local5.target == _arg2){
                    _local6 = filterProperties.concat(filterStyles);
                    _local7 = _local6.length;
                    _local8 = 0;
                    while (_local8 < _local7) {
                        if (((!((_local5.start[_local6[_local8]] === undefined))) && (!((_local5.end[_local6[_local8]] == _local5.start[_local6[_local8]]))))){
                            return (true);
                        };
                        _local8++;
                    };
                };
                _local4++;
            };
            return (false);
        }
        public function filterInstance(_arg1:Array, _arg2:IEffectTargetHost, _arg3:Object):Boolean{
            if (filterFunction.length == 2){
                return (filterFunction(_arg1, _arg3));
            };
            return (filterFunction(_arg1, _arg2, _arg3));
        }

    }
}//package mx.effects 
