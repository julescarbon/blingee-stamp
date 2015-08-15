package mx.effects.effectClasses {
    import flash.events.*;
    import flash.filters.*;

    public class BlurInstance extends TweenEffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var blurXTo:Number;
        public var blurYTo:Number;
        public var blurXFrom:Number;
        public var blurYFrom:Number;

        public function BlurInstance(_arg1:Object){
            super(_arg1);
        }
        override public function initEffect(_arg1:Event):void{
            super.initEffect(_arg1);
        }
        override public function onTweenEnd(_arg1:Object):void{
            setBlurFilter(_arg1[0], _arg1[1]);
            super.onTweenEnd(_arg1);
        }
        private function setBlurFilter(_arg1:Number, _arg2:Number):void{
            var _local3:Array = target.filters;
            var _local4:int = _local3.length;
            var _local5:int;
            while (_local5 < _local4) {
                if ((_local3[_local5] is BlurFilter)){
                    _local3.splice(_local5, 1);
                };
                _local5++;
            };
            if (((_arg1) || (_arg2))){
                _local3.push(new BlurFilter(_arg1, _arg2));
            };
            target.filters = _local3;
        }
        override public function play():void{
            super.play();
            if (isNaN(blurXFrom)){
                blurXFrom = 4;
            };
            if (isNaN(blurXTo)){
                blurXTo = 0;
            };
            if (isNaN(blurYFrom)){
                blurYFrom = 4;
            };
            if (isNaN(blurYTo)){
                blurYTo = 0;
            };
            tween = createTween(this, [blurXFrom, blurYFrom], [blurXTo, blurYTo], duration);
        }
        override public function onTweenUpdate(_arg1:Object):void{
            setBlurFilter(_arg1[0], _arg1[1]);
        }

    }
}//package mx.effects.effectClasses 
