package mx.events {
    import flash.events.*;
    import mx.effects.*;

    public class EffectEvent extends Event {

        public static const EFFECT_START:String = "effectStart";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const EFFECT_END:String = "effectEnd";

        public var effectInstance:IEffectInstance;

        public function EffectEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:IEffectInstance=null){
            super(_arg1, _arg2, _arg3);
            this.effectInstance = _arg4;
        }
        override public function clone():Event{
            return (new EffectEvent(type, bubbles, cancelable, effectInstance));
        }

    }
}//package mx.events 
