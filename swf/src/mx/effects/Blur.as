package mx.effects {
    import mx.effects.effectClasses.*;

    public class Blur extends TweenEffect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var AFFECTED_PROPERTIES:Array = ["filters"];

        public var blurXTo:Number;
        public var blurXFrom:Number;
        public var blurYFrom:Number;
        public var blurYTo:Number;

        public function Blur(_arg1:Object=null){
            super(_arg1);
            instanceClass = BlurInstance;
        }
        override public function getAffectedProperties():Array{
            return (AFFECTED_PROPERTIES);
        }
        override protected function initInstance(_arg1:IEffectInstance):void{
            var _local2:BlurInstance;
            super.initInstance(_arg1);
            _local2 = BlurInstance(_arg1);
            _local2.blurXFrom = blurXFrom;
            _local2.blurXTo = blurXTo;
            _local2.blurYFrom = blurYFrom;
            _local2.blurYTo = blurYTo;
        }

    }
}//package mx.effects 
