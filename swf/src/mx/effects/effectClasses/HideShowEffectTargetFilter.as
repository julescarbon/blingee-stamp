package mx.effects.effectClasses {
    import mx.effects.*;

    public class HideShowEffectTargetFilter extends EffectTargetFilter {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var show:Boolean = true;

        public function HideShowEffectTargetFilter(){
            filterProperties = ["visible"];
        }
        override protected function defaultFilterFunction(_arg1:Array, _arg2:Object):Boolean{
            var _local5:PropertyChanges;
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = _arg1[_local4];
                if (_local5.target == _arg2){
                    return ((_local5.end["visible"] == show));
                };
                _local4++;
            };
            return (false);
        }

    }
}//package mx.effects.effectClasses 
