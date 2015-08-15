package mx.rpc {
    import flash.events.*;
    import flash.utils.*;

    public class AsyncDispatcher {

        private var _method:Function;
        private var _timer:Timer;
        private var _args:Array;

        public function AsyncDispatcher(_arg1:Function, _arg2:Array, _arg3:Number){
            _method = _arg1;
            _args = _arg2;
            _timer = new Timer(_arg3);
            _timer.addEventListener(TimerEvent.TIMER, timerEventHandler);
            _timer.start();
        }
        private function timerEventHandler(_arg1:TimerEvent):void{
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER, timerEventHandler);
            _method.apply(null, _args);
        }

    }
}//package mx.rpc 
