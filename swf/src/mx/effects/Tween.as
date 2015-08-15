package mx.effects {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.utils.*;

    public class Tween extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var timer:Timer = null;
        private static var interval:Number = 10;
        mx_internal static var activeTweens:Array = [];
        mx_internal static var intervalTime:Number = NaN;

        private var started:Boolean = false;
        private var previousUpdateTime:Number;
        public var duration:Number = 3000;
        private var id:int;
        private var arrayMode:Boolean;
        private var _isPlaying:Boolean = true;
        private var startValue:Object;
        public var listener:Object;
        private var userEquation:Function;
        mx_internal var needToLayout:Boolean = false;
        private var updateFunction:Function;
        private var _doSeek:Boolean = false;
        mx_internal var startTime:Number;
        private var endFunction:Function;
        private var endValue:Object;
        private var _doReverse:Boolean = false;
        private var _playheadTime:Number = 0;
        private var _invertValues:Boolean = false;
        private var maxDelay:Number = 87.5;

        public function Tween(_arg1:Object, _arg2:Object, _arg3:Object, _arg4:Number=-1, _arg5:Number=-1, _arg6:Function=null, _arg7:Function=null){
            userEquation = defaultEasingFunction;
            super();
            if (!_arg1){
                return;
            };
            if ((_arg2 is Array)){
                arrayMode = true;
            };
            this.listener = _arg1;
            this.startValue = _arg2;
            this.endValue = _arg3;
            if (((!(isNaN(_arg4))) && (!((_arg4 == -1))))){
                this.duration = _arg4;
            };
            if (((!(isNaN(_arg5))) && (!((_arg5 == -1))))){
                maxDelay = (1000 / _arg5);
            };
            this.updateFunction = _arg6;
            this.endFunction = _arg7;
            if (_arg4 == 0){
                id = -1;
                endTween();
            } else {
                Tween.addTween(this);
            };
        }
        mx_internal static function removeTween(_arg1:Tween):void{
            removeTweenAt(_arg1.id);
        }
        private static function addTween(_arg1:Tween):void{
            _arg1.id = activeTweens.length;
            activeTweens.push(_arg1);
            if (!timer){
                timer = new Timer(interval);
                timer.addEventListener(TimerEvent.TIMER, timerHandler);
                timer.start();
            } else {
                timer.start();
            };
            if (isNaN(intervalTime)){
                intervalTime = getTimer();
            };
            _arg1.startTime = (_arg1.previousUpdateTime = intervalTime);
        }
        private static function timerHandler(_arg1:TimerEvent):void{
            var _local6:Tween;
            var _local2:Boolean;
            var _local3:Number = intervalTime;
            intervalTime = getTimer();
            var _local4:int = activeTweens.length;
            var _local5:int = _local4;
            while (_local5 >= 0) {
                _local6 = Tween(activeTweens[_local5]);
                if (_local6){
                    _local6.needToLayout = false;
                    _local6.doInterval();
                    if (_local6.needToLayout){
                        _local2 = true;
                    };
                };
                _local5--;
            };
            if (_local2){
                UIComponentGlobals.layoutManager.validateNow();
            };
            _arg1.updateAfterEvent();
        }
        private static function removeTweenAt(_arg1:int):void{
            var _local4:Tween;
            if ((((_arg1 >= activeTweens.length)) || ((_arg1 < 0)))){
                return;
            };
            activeTweens.splice(_arg1, 1);
            var _local2:int = activeTweens.length;
            var _local3:int = _arg1;
            while (_local3 < _local2) {
                _local4 = Tween(activeTweens[_local3]);
                _local4.id--;
                _local3++;
            };
            if (_local2 == 0){
                intervalTime = NaN;
                timer.reset();
            };
        }

        mx_internal function get playheadTime():Number{
            return (_playheadTime);
        }
        public function stop():void{
            if (id >= 0){
                Tween.removeTweenAt(id);
            };
        }
        mx_internal function get playReversed():Boolean{
            return (_invertValues);
        }
        mx_internal function set playReversed(_arg1:Boolean):void{
            _invertValues = _arg1;
        }
        public function resume():void{
            _isPlaying = true;
            startTime = (intervalTime - _playheadTime);
            if (_doReverse){
                reverse();
                _doReverse = false;
            };
        }
        public function setTweenHandlers(_arg1:Function, _arg2:Function):void{
            this.updateFunction = _arg1;
            this.endFunction = _arg2;
        }
        private function defaultEasingFunction(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Number{
            return ((((_arg3 / 2) * (Math.sin((Math.PI * ((_arg1 / _arg4) - 0.5))) + 1)) + _arg2));
        }
        public function set easingFunction(_arg1:Function):void{
            userEquation = _arg1;
        }
        public function endTween():void{
            var _local1:TweenEvent = new TweenEvent(TweenEvent.TWEEN_END);
            var _local2:Object = getCurrentValue(duration);
            _local1.value = _local2;
            dispatchEvent(_local1);
            if (endFunction != null){
                endFunction(_local2);
            } else {
                listener.onTweenEnd(_local2);
            };
            if (id >= 0){
                Tween.removeTweenAt(id);
            };
        }
        public function reverse():void{
            if (_isPlaying){
                _doReverse = false;
                seek((duration - _playheadTime));
                _invertValues = !(_invertValues);
            } else {
                _doReverse = !(_doReverse);
            };
        }
        mx_internal function getCurrentValue(_arg1:Number):Object{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            if (duration == 0){
                return (endValue);
            };
            if (_invertValues){
                _arg1 = (duration - _arg1);
            };
            if (arrayMode){
                _local2 = [];
                _local3 = startValue.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local2[_local4] = userEquation(_arg1, startValue[_local4], (endValue[_local4] - startValue[_local4]), duration);
                    _local4++;
                };
                return (_local2);
            };
            return (userEquation(_arg1, startValue, (Number(endValue) - Number(startValue)), duration));
        }
        mx_internal function doInterval():Boolean{
            var _local2:Number;
            var _local3:Object;
            var _local4:TweenEvent;
            var _local5:TweenEvent;
            var _local1:Boolean;
            previousUpdateTime = intervalTime;
            if (((_isPlaying) || (_doSeek))){
                _local2 = (intervalTime - startTime);
                _playheadTime = _local2;
                _local3 = getCurrentValue(_local2);
                if ((((_local2 >= duration)) && (!(_doSeek)))){
                    endTween();
                    _local1 = true;
                } else {
                    if (!started){
                        _local5 = new TweenEvent(TweenEvent.TWEEN_START);
                        dispatchEvent(_local5);
                        started = true;
                    };
                    _local4 = new TweenEvent(TweenEvent.TWEEN_UPDATE);
                    _local4.value = _local3;
                    dispatchEvent(_local4);
                    if (updateFunction != null){
                        updateFunction(_local3);
                    } else {
                        listener.onTweenUpdate(_local3);
                    };
                };
                _doSeek = false;
            };
            return (_local1);
        }
        public function pause():void{
            _isPlaying = false;
        }
        public function seek(_arg1:Number):void{
            var _local2:Number = intervalTime;
            previousUpdateTime = _local2;
            startTime = (_local2 - _arg1);
            _doSeek = true;
        }

    }
}//package mx.effects 
