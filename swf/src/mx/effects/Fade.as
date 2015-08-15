package mx.effects {
    import mx.effects.effectClasses.*;

    public class Fade extends TweenEffect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var AFFECTED_PROPERTIES:Array = ["alpha", "visible"];

        public var alphaFrom:Number;
        public var alphaTo:Number;

        public function Fade(_arg1:Object=null){
            super(_arg1);
            instanceClass = FadeInstance;
        }
        override protected function initInstance(_arg1:IEffectInstance):void{
            super.initInstance(_arg1);
            var _local2:FadeInstance = FadeInstance(_arg1);
            _local2.alphaFrom = alphaFrom;
            _local2.alphaTo = alphaTo;
        }
        override public function getAffectedProperties():Array{
            return (AFFECTED_PROPERTIES);
        }

    }
}//package mx.effects 
