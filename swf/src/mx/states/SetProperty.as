package mx.states {
    import mx.core.*;

    public class SetProperty implements IOverride {

        private static const RELATED_PROPERTIES:Object = {
            explicitWidth:["percentWidth"],
            explicitHeight:["percentHeight"]
        };
        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const PSEUDONYMS:Object = {
            width:"explicitWidth",
            height:"explicitHeight"
        };

        private var oldRelatedValues:Array;
        private var oldValue:Object;
        public var name:String;
        public var target:Object;
        public var value;

        public function SetProperty(_arg1:Object=null, _arg2:String=null, _arg3=undefined){
            this.target = _arg1;
            this.name = _arg2;
            this.value = _arg3;
        }
        public function remove(_arg1:UIComponent):void{
            var _local5:int;
            var _local2:Object = ((target) ? target : _arg1);
            var _local3:String = ((PSEUDONYMS[name]) ? PSEUDONYMS[name] : name);
            var _local4:Array = ((RELATED_PROPERTIES[_local3]) ? RELATED_PROPERTIES[_local3] : null);
            if ((((((name == "width")) || ((name == "height")))) && (!(isNaN(Number(oldValue)))))){
                _local3 = name;
            };
            setPropertyValue(_local2, _local3, oldValue, oldValue);
            if (_local4){
                _local5 = 0;
                while (_local5 < _local4.length) {
                    setPropertyValue(_local2, _local4[_local5], oldRelatedValues[_local5], oldRelatedValues[_local5]);
                    _local5++;
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
            var _local6:int;
            var _local2:Object = ((target) ? target : _arg1);
            var _local3:String = ((PSEUDONYMS[name]) ? PSEUDONYMS[name] : name);
            var _local4:Array = ((RELATED_PROPERTIES[_local3]) ? RELATED_PROPERTIES[_local3] : null);
            var _local5:* = value;
            oldValue = _local2[_local3];
            if (_local4){
                oldRelatedValues = [];
                _local6 = 0;
                while (_local6 < _local4.length) {
                    oldRelatedValues[_local6] = _local2[_local4[_local6]];
                    _local6++;
                };
            };
            if ((((name == "width")) || ((name == "height")))){
                if ((((_local5 is String)) && ((_local5.indexOf("%") >= 0)))){
                    _local3 = (((name == "width")) ? "percentWidth" : "percentHeight");
                    _local5 = _local5.slice(0, _local5.indexOf("%"));
                } else {
                    _local3 = name;
                };
            };
            setPropertyValue(_local2, _local3, _local5, oldValue);
        }
        public function initialize():void{
        }
        private function setPropertyValue(_arg1:Object, _arg2:String, _arg3, _arg4:Object):void{
            if ((_arg4 is Number)){
                _arg1[_arg2] = Number(_arg3);
            } else {
                if ((_arg4 is Boolean)){
                    _arg1[_arg2] = toBoolean(_arg3);
                } else {
                    _arg1[_arg2] = _arg3;
                };
            };
        }

    }
}//package mx.states 
