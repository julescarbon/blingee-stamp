package mx.effects {
    import flash.events.*;
    import mx.events.*;
    import mx.effects.effectClasses.*;

    public class TweenEffect extends Effect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var easingFunction:Function = null;

        public function TweenEffect(_arg1:Object=null){
            super(_arg1);
            instanceClass = TweenEffectInstance;
        }
        protected function tweenEventHandler(_arg1:TweenEvent):void{
            dispatchEvent(_arg1);
        }
        override protected function initInstance(_arg1:IEffectInstance):void{
            super.initInstance(_arg1);
            TweenEffectInstance(_arg1).easingFunction = easingFunction;
            EventDispatcher(_arg1).addEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
            EventDispatcher(_arg1).addEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
            EventDispatcher(_arg1).addEventListener(TweenEvent.TWEEN_END, tweenEventHandler);
        }

    }
}//package mx.effects 
