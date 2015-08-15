package mx.effects {
    import mx.effects.effectClasses.*;

    public class Move extends TweenEffect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var AFFECTED_PROPERTIES:Array = ["x", "y"];

        public var xFrom:Number;
        public var yFrom:Number;
        public var xBy:Number;
        public var yBy:Number;
        public var yTo:Number;
        public var xTo:Number;

        public function Move(_arg1:Object=null){
            super(_arg1);
            instanceClass = MoveInstance;
        }
        override protected function initInstance(_arg1:IEffectInstance):void{
            var _local2:MoveInstance;
            super.initInstance(_arg1);
            _local2 = MoveInstance(_arg1);
            _local2.xFrom = xFrom;
            _local2.xTo = xTo;
            _local2.xBy = xBy;
            _local2.yFrom = yFrom;
            _local2.yTo = yTo;
            _local2.yBy = yBy;
        }
        override public function getAffectedProperties():Array{
            return (AFFECTED_PROPERTIES);
        }

    }
}//package mx.effects 
