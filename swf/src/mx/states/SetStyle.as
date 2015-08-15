package mx.states {
    import mx.core.*;
    import mx.styles.*;

    public class SetStyle implements IOverride {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const RELATED_PROPERTIES:Object = {
            left:["x"],
            top:["y"],
            right:["x"],
            bottom:["y"]
        };

        private var oldRelatedValues:Array;
        private var oldValue:Object;
        public var name:String;
        public var target:IStyleClient;
        public var value:Object;

        public function SetStyle(_arg1:IStyleClient=null, _arg2:String=null, _arg3:Object=null){
            this.target = _arg1;
            this.name = _arg2;
            this.value = _arg3;
        }
        public function remove(_arg1:UIComponent):void{
            var _local4:int;
            var _local2:IStyleClient = ((target) ? target : _arg1);
            if ((oldValue is Number)){
                _local2.setStyle(name, Number(oldValue));
            } else {
                if ((oldValue is Boolean)){
                    _local2.setStyle(name, toBoolean(oldValue));
                } else {
                    if (oldValue === null){
                        _local2.clearStyle(name);
                    } else {
                        _local2.setStyle(name, oldValue);
                    };
                };
            };
            var _local3:Array = ((RELATED_PROPERTIES[name]) ? RELATED_PROPERTIES[name] : null);
            if (_local3){
                _local4 = 0;
                while (_local4 < _local3.length) {
                    _local2[_local3[_local4]] = oldRelatedValues[_local4];
                    _local4++;
                };
            };
        }
        private function toBoolean(_arg1:Object):Boolean{
            if ((_arg1 is String)){
                return ((_arg1.toLowerCase() == "true"));
            };
            return (!((_arg1 == false)));
        }
        public function apply(_arg1:UIComponent):void{
            var _local4:int;
            var _local2:IStyleClient = ((target) ? target : _arg1);
            var _local3:Array = ((RELATED_PROPERTIES[name]) ? RELATED_PROPERTIES[name] : null);
            oldValue = _local2.getStyle(name);
            if (_local3){
                oldRelatedValues = [];
                _local4 = 0;
                while (_local4 < _local3.length) {
                    oldRelatedValues[_local4] = _local2[_local3[_local4]];
                    _local4++;
                };
            };
            if (value === null){
                _local2.clearStyle(name);
            } else {
                if ((oldValue is Number)){
                    if (name.toLowerCase().indexOf("color") != -1){
                        _local2.setStyle(name, StyleManager.getColorName(value));
                    } else {
                        _local2.setStyle(name, Number(value));
                    };
                } else {
                    if ((oldValue is Boolean)){
                        _local2.setStyle(name, toBoolean(value));
                    } else {
                        _local2.setStyle(name, value);
                    };
                };
            };
        }
        public function initialize():void{
        }

    }
}//package mx.states 
