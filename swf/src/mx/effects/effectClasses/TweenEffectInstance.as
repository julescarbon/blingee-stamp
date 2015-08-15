package mx.effects.effectClasses {
    import mx.core.*;
    import mx.events.*;
    import mx.effects.*;

    public class TweenEffectInstance extends EffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _seekTime:Number = 0;
        public var easingFunction:Function;
        public var tween:Tween;
        mx_internal var needToLayout:Boolean = false;

        public function TweenEffectInstance(_arg1:Object){
            super(_arg1);
        }
        override public function stop():void{
            super.stop();
            if (tween){
                tween.stop();
            };
        }
        mx_internal function applyTweenStartValues():void{
            if (duration > 0){
                onTweenUpdate(tween.getCurrentValue(0));
            };
        }
        override public function get playheadTime():Number{
            if (tween){
                return ((tween.playheadTime + super.playheadTime));
            };
            return (0);
        }
        protected function createTween(_arg1:Object, _arg2:Object, _arg3:Object, _arg4:Number=-1, _arg5:Number=-1):Tween{
            var _local6:Tween = new Tween(_arg1, _arg2, _arg3, _arg4, _arg5);
            _local6.addEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
            _local6.addEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
            _local6.addEventListener(TweenEvent.TWEEN_END, tweenEventHandler);
            if (easingFunction != null){
                _local6.easingFunction = easingFunction;
            };
            if (_seekTime > 0){
                _local6.seek(_seekTime);
            };
            _local6.playReversed = playReversed;
            return (_local6);
        }
        private function tweenEventHandler(_arg1:TweenEvent):void{
            dispatchEvent(_arg1);
        }
        override public function end():void{
            stopRepeat = true;
            if (delayTimer){
                delayTimer.reset();
            };
            if (tween){
                tween.endTween();
                tween = null;
            };
        }
        override public function reverse():void{
            super.reverse();
            if (tween){
                tween.reverse();
            };
            super.playReversed = !(playReversed);
        }
        override mx_internal function set playReversed(_arg1:Boolean):void{
            super.playReversed = _arg1;
            if (tween){
                tween.playReversed = _arg1;
            };
        }
        override public function resume():void{
            super.resume();
            if (tween){
                tween.resume();
            };
        }
        public function onTweenEnd(_arg1:Object):void{
            onTweenUpdate(_arg1);
            tween = null;
            if (needToLayout){
                UIComponentGlobals.layoutManager.validateNow();
            };
            finishRepeat();
        }
        public function onTweenUpdate(_arg1:Object):void{
        }
        override public function pause():void{
            super.pause();
            if (tween){
                tween.pause();
            };
        }
        public function seek(_arg1:Number):void{
            if (tween){
                tween.seek(_arg1);
            } else {
                _seekTime = _arg1;
            };
        }

    }
}//package mx.effects.effectClasses 
