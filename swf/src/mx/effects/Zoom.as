package mx.effects {
    import mx.effects.effectClasses.*;

    public class Zoom extends TweenEffect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var AFFECTED_PROPERTIES:Array = ["scaleX", "scaleY", "x", "y", "width", "height"];

        public var zoomHeightFrom:Number;
        public var zoomWidthTo:Number;
        public var originX:Number;
        public var zoomHeightTo:Number;
        public var originY:Number;
        public var captureRollEvents:Boolean;
        public var zoomWidthFrom:Number;

        public function Zoom(_arg1:Object=null){
            super(_arg1);
            instanceClass = ZoomInstance;
            applyActualDimensions = false;
            relevantProperties = ["scaleX", "scaleY", "width", "height", "visible"];
        }
        override protected function initInstance(_arg1:IEffectInstance):void{
            var _local2:ZoomInstance;
            super.initInstance(_arg1);
            _local2 = ZoomInstance(_arg1);
            _local2.zoomWidthFrom = zoomWidthFrom;
            _local2.zoomWidthTo = zoomWidthTo;
            _local2.zoomHeightFrom = zoomHeightFrom;
            _local2.zoomHeightTo = zoomHeightTo;
            _local2.originX = originX;
            _local2.originY = originY;
            _local2.captureRollEvents = captureRollEvents;
        }
        override public function getAffectedProperties():Array{
            return (AFFECTED_PROPERTIES);
        }

    }
}//package mx.effects 
