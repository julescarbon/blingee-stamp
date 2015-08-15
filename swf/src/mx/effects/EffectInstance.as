package mx.effects {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.effects.effectClasses.*;
    import flash.utils.*;

    public class EffectInstance extends EventDispatcher implements IEffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _hideFocusRing:Boolean;
        private var delayStartTime:Number = 0;
        mx_internal var stopRepeat:Boolean = false;
        private var playCount:int = 0;
        private var _repeatCount:int = 0;
        private var _suspendBackgroundProcessing:Boolean = false;
        mx_internal var delayTimer:Timer;
        private var _triggerEvent:Event;
        private var _effectTargetHost:IEffectTargetHost;
        mx_internal var parentCompositeEffectInstance:EffectInstance;
        mx_internal var durationExplicitlySet:Boolean = false;
        private var _effect:IEffect;
        private var _target:Object;
        mx_internal var hideOnEffectEnd:Boolean = false;
        private var _startDelay:int = 0;
        private var delayElapsedTime:Number = 0;
        private var _repeatDelay:int = 0;
        private var _propertyChanges:PropertyChanges;
        private var _duration:Number = 500;
        private var _playReversed:Boolean;

        public function EffectInstance(_arg1:Object){
            this.target = _arg1;
        }
        public function get playheadTime():Number{
            return ((((Math.max((playCount - 1), 0) * duration) + (Math.max((playCount - 2), 0) * repeatDelay)) + ((playReversed) ? 0 : startDelay)));
        }
        public function get hideFocusRing():Boolean{
            return (_hideFocusRing);
        }
        public function stop():void{
            if (delayTimer){
                delayTimer.reset();
            };
            stopRepeat = true;
            finishEffect();
        }
        public function finishEffect():void{
            playCount = 0;
            dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END, false, false, this));
            if (target){
                target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END, false, false, this));
            };
            if ((target is UIComponent)){
                UIComponent(target).effectFinished(this);
            };
            EffectManager.effectFinished(this);
        }
        public function set hideFocusRing(_arg1:Boolean):void{
            _hideFocusRing = _arg1;
        }
        public function finishRepeat():void{
            if (((((!(stopRepeat)) && (!((playCount == 0))))) && ((((playCount < repeatCount)) || ((repeatCount == 0)))))){
                if (repeatDelay > 0){
                    delayTimer = new Timer(repeatDelay, 1);
                    delayStartTime = getTimer();
                    delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
                    delayTimer.start();
                } else {
                    play();
                };
            } else {
                finishEffect();
            };
        }
        mx_internal function get playReversed():Boolean{
            return (_playReversed);
        }
        public function set effect(_arg1:IEffect):void{
            _effect = _arg1;
        }
        public function get className():String{
            var _local1:String = getQualifiedClassName(this);
            var _local2:int = _local1.indexOf("::");
            if (_local2 != -1){
                _local1 = _local1.substr((_local2 + 2));
            };
            return (_local1);
        }
        public function set duration(_arg1:Number):void{
            durationExplicitlySet = true;
            _duration = _arg1;
        }
        mx_internal function set playReversed(_arg1:Boolean):void{
            _playReversed = _arg1;
        }
        public function resume():void{
            if (((((delayTimer) && (!(delayTimer.running)))) && (!(isNaN(delayElapsedTime))))){
                delayTimer.delay = ((playReversed) ? delayElapsedTime : (delayTimer.delay - delayElapsedTime));
                delayTimer.start();
            };
        }
        public function get propertyChanges():PropertyChanges{
            return (_propertyChanges);
        }
        public function set target(_arg1:Object):void{
            _target = _arg1;
        }
        public function get repeatCount():int{
            return (_repeatCount);
        }
        mx_internal function playWithNoDuration():void{
            duration = 0;
            repeatCount = 1;
            repeatDelay = 0;
            startDelay = 0;
            startEffect();
        }
        public function get startDelay():int{
            return (_startDelay);
        }
        mx_internal function get actualDuration():Number{
            var _local1:Number = NaN;
            if (repeatCount > 0){
                _local1 = (((duration * repeatCount) + ((repeatDelay * repeatCount) - 1)) + startDelay);
            };
            return (_local1);
        }
        public function play():void{
            playCount++;
            dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
            if (target){
                target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
            };
        }
        public function get suspendBackgroundProcessing():Boolean{
            return (_suspendBackgroundProcessing);
        }
        public function get effectTargetHost():IEffectTargetHost{
            return (_effectTargetHost);
        }
        public function set repeatDelay(_arg1:int):void{
            _repeatDelay = _arg1;
        }
        public function set propertyChanges(_arg1:PropertyChanges):void{
            _propertyChanges = _arg1;
        }
        mx_internal function eventHandler(_arg1:Event):void{
            if ((((_arg1.type == FlexEvent.SHOW)) && ((hideOnEffectEnd == true)))){
                hideOnEffectEnd = false;
                _arg1.target.removeEventListener(FlexEvent.SHOW, eventHandler);
            };
        }
        public function set repeatCount(_arg1:int):void{
            _repeatCount = _arg1;
        }
        private function delayTimerHandler(_arg1:TimerEvent):void{
            delayTimer.reset();
            delayStartTime = NaN;
            delayElapsedTime = NaN;
            play();
        }
        public function set suspendBackgroundProcessing(_arg1:Boolean):void{
            _suspendBackgroundProcessing = _arg1;
        }
        public function set triggerEvent(_arg1:Event):void{
            _triggerEvent = _arg1;
        }
        public function set startDelay(_arg1:int):void{
            _startDelay = _arg1;
        }
        public function get effect():IEffect{
            return (_effect);
        }
        public function set effectTargetHost(_arg1:IEffectTargetHost):void{
            _effectTargetHost = _arg1;
        }
        public function get target():Object{
            return (_target);
        }
        public function startEffect():void{
            EffectManager.effectStarted(this);
            if ((target is UIComponent)){
                UIComponent(target).effectStarted(this);
            };
            if ((((startDelay > 0)) && (!(playReversed)))){
                delayTimer = new Timer(startDelay, 1);
                delayStartTime = getTimer();
                delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
                delayTimer.start();
            } else {
                play();
            };
        }
        public function get repeatDelay():int{
            return (_repeatDelay);
        }
        public function get duration():Number{
            if (((!(durationExplicitlySet)) && (parentCompositeEffectInstance))){
                return (parentCompositeEffectInstance.duration);
            };
            return (_duration);
        }
        public function initEffect(_arg1:Event):void{
            triggerEvent = _arg1;
            switch (_arg1.type){
                case "resizeStart":
                case "resizeEnd":
                    if (!durationExplicitlySet){
                        duration = 250;
                    };
                    break;
                case FlexEvent.HIDE:
                    target.setVisible(true, true);
                    hideOnEffectEnd = true;
                    target.addEventListener(FlexEvent.SHOW, eventHandler);
                    break;
            };
        }
        public function get triggerEvent():Event{
            return (_triggerEvent);
        }
        public function end():void{
            if (delayTimer){
                delayTimer.reset();
            };
            stopRepeat = true;
            finishEffect();
        }
        public function reverse():void{
            if (repeatCount > 0){
                playCount = ((repeatCount - playCount) + 1);
            };
        }
        public function pause():void{
            if (((((delayTimer) && (delayTimer.running))) && (!(isNaN(delayStartTime))))){
                delayTimer.stop();
                delayElapsedTime = (getTimer() - delayStartTime);
            };
        }

    }
}//package mx.effects 
