package mx.effects.effectClasses {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;

    public class FadeInstance extends TweenEffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var alphaFrom:Number;
        private var restoreAlpha:Boolean;
        public var alphaTo:Number;
        private var origAlpha:Number = NaN;

        public function FadeInstance(_arg1:Object){
            super(_arg1);
        }
        override public function initEffect(_arg1:Event):void{
            super.initEffect(_arg1);
            switch (_arg1.type){
                case "childrenCreationComplete":
                case FlexEvent.CREATION_COMPLETE:
                case FlexEvent.SHOW:
                case Event.ADDED:
                case "resizeEnd":
                    if (isNaN(alphaFrom)){
                        alphaFrom = 0;
                    };
                    if (isNaN(alphaTo)){
                        alphaTo = target.alpha;
                    };
                    break;
                case FlexEvent.HIDE:
                case Event.REMOVED:
                case "resizeStart":
                    restoreAlpha = true;
                    if (isNaN(alphaFrom)){
                        alphaFrom = target.alpha;
                    };
                    if (isNaN(alphaTo)){
                        alphaTo = 0;
                    };
                    break;
            };
        }
        override public function onTweenEnd(_arg1:Object):void{
            super.onTweenEnd(_arg1);
            if (((mx_internal::hideOnEffectEnd) || (restoreAlpha))){
                target.alpha = origAlpha;
            };
        }
        override public function play():void{
            super.play();
            origAlpha = target.alpha;
            var _local1:PropertyChanges = propertyChanges;
            if (((isNaN(alphaFrom)) && (isNaN(alphaTo)))){
                if (((_local1) && (!((_local1.end["alpha"] === undefined))))){
                    alphaFrom = origAlpha;
                    alphaTo = _local1.end["alpha"];
                } else {
                    if (((_local1) && (!((_local1.end["visible"] === undefined))))){
                        alphaFrom = ((_local1.start["visible"]) ? origAlpha : 0);
                        alphaTo = ((_local1.end["visible"]) ? origAlpha : 0);
                    } else {
                        alphaFrom = 0;
                        alphaTo = origAlpha;
                    };
                };
            } else {
                if (isNaN(alphaFrom)){
                    alphaFrom = ((alphaTo)==0) ? origAlpha : 0;
                } else {
                    if (isNaN(alphaTo)){
                        if (((_local1) && (!((_local1.end["alpha"] === undefined))))){
                            alphaTo = _local1.end["alpha"];
                        } else {
                            alphaTo = ((alphaFrom)==0) ? origAlpha : 0;
                        };
                    };
                };
            };
            tween = createTween(this, alphaFrom, alphaTo, duration);
            target.alpha = tween.mx_internal::getCurrentValue(0);
        }
        override public function onTweenUpdate(_arg1:Object):void{
            target.alpha = _arg1;
        }

    }
}//package mx.effects.effectClasses 
