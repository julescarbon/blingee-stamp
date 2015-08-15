package mx.preloaders {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.utils.*;

    public class Preloader extends Sprite {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var app:IEventDispatcher = null;
        private var showDisplay:Boolean;
        private var timer:Timer;
        private var rslDone:Boolean = false;
        private var displayClass:IPreloaderDisplay = null;
        private var rslListLoader:RSLListLoader;

        private function getByteValues():Object{
            var _local1:LoaderInfo = root.loaderInfo;
            var _local2:int = _local1.bytesLoaded;
            var _local3:int = _local1.bytesTotal;
            var _local4:int = ((rslListLoader) ? rslListLoader.getItemCount() : 0);
            var _local5:int;
            while (_local5 < _local4) {
                _local2 = (_local2 + rslListLoader.getItem(_local5).loaded);
                _local3 = (_local3 + rslListLoader.getItem(_local5).total);
                _local5++;
            };
            return ({
                loaded:_local2,
                total:_local3
            });
        }
        private function appProgressHandler(_arg1:Event):void{
            dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));
        }
        private function dispatchAppEndEvent(_arg1:Object=null):void{
            dispatchEvent(new FlexEvent(FlexEvent.INIT_COMPLETE));
            if (!showDisplay){
                displayClassCompleteHandler(null);
            };
        }
        private function ioErrorHandler(_arg1:IOErrorEvent):void{
        }
        private function appCreationCompleteHandler(_arg1:FlexEvent):void{
            dispatchAppEndEvent();
        }
        mx_internal function rslErrorHandler(_arg1:ErrorEvent):void{
            var _local2:int = rslListLoader.getIndex();
            var _local3:RSLItem = rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_ERROR);
            _local4.bytesLoaded = 0;
            _local4.bytesTotal = 0;
            _local4.rslIndex = _local2;
            _local4.rslTotal = rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            _local4.errorText = decodeURI(_arg1.text);
            dispatchEvent(_local4);
        }
        public function initialize(_arg1:Boolean, _arg2:Class, _arg3:uint, _arg4:Number, _arg5:Object, _arg6:String, _arg7:Number, _arg8:Number, _arg9:Array=null, _arg10:Array=null, _arg11:Array=null, _arg12:Array=null):void{
            var _local13:int;
            var _local14:int;
            var _local15:RSLItem;
            var _local16:ResourceModuleRSLItem;
            if (((((!((_arg9 == null))) || (!((_arg10 == null))))) && (!((_arg11 == null))))){
                throw (new Error("RSLs may only be specified by using libs and sizes or rslList, not both."));
            };
            root.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            if (((_arg9) && ((_arg9.length > 0)))){
                if (_arg11 == null){
                    _arg11 = [];
                };
                _local13 = _arg9.length;
                _local14 = 0;
                while (_local14 < _local13) {
                    _local15 = new RSLItem(_arg9[_local14]);
                    _arg11.push(_local15);
                    _local14++;
                };
            };
            if (((_arg12) && ((_arg12.length > 0)))){
                _local13 = _arg12.length;
                _local14 = 0;
                while (_local14 < _local13) {
                    _local16 = new ResourceModuleRSLItem(_arg12[_local14]);
                    _arg11.push(_local16);
                    _local14++;
                };
            };
            rslListLoader = new RSLListLoader(_arg11);
            this.showDisplay = _arg1;
            timer = new Timer(10);
            timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.start();
            if (_arg1){
                displayClass = new (_arg2)();
                displayClass.addEventListener(Event.COMPLETE, displayClassCompleteHandler);
                addChild(DisplayObject(displayClass));
                displayClass.backgroundColor = _arg3;
                displayClass.backgroundAlpha = _arg4;
                displayClass.backgroundImage = _arg5;
                displayClass.backgroundSize = _arg6;
                displayClass.stageWidth = _arg7;
                displayClass.stageHeight = _arg8;
                displayClass.initialize();
                displayClass.preloader = this;
            };
            if (rslListLoader.getItemCount() > 0){
                rslListLoader.load(mx_internal::rslProgressHandler, mx_internal::rslCompleteHandler, mx_internal::rslErrorHandler, mx_internal::rslErrorHandler, mx_internal::rslErrorHandler);
            } else {
                rslDone = true;
            };
        }
        mx_internal function rslProgressHandler(_arg1:ProgressEvent):void{
            var _local2:int = rslListLoader.getIndex();
            var _local3:RSLItem = rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_PROGRESS);
            _local4.bytesLoaded = _arg1.bytesLoaded;
            _local4.bytesTotal = _arg1.bytesTotal;
            _local4.rslIndex = _local2;
            _local4.rslTotal = rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            dispatchEvent(_local4);
        }
        public function registerApplication(_arg1:IEventDispatcher):void{
            _arg1.addEventListener("validatePropertiesComplete", appProgressHandler);
            _arg1.addEventListener("validateSizeComplete", appProgressHandler);
            _arg1.addEventListener("validateDisplayListComplete", appProgressHandler);
            _arg1.addEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
            this.app = _arg1;
        }
        mx_internal function rslCompleteHandler(_arg1:Event):void{
            var _local2:int = rslListLoader.getIndex();
            var _local3:RSLItem = rslListLoader.getItem(_local2);
            var _local4:RSLEvent = new RSLEvent(RSLEvent.RSL_COMPLETE);
            _local4.bytesLoaded = _local3.total;
            _local4.bytesTotal = _local3.total;
            _local4.rslIndex = _local2;
            _local4.rslTotal = rslListLoader.getItemCount();
            _local4.url = _local3.urlRequest;
            dispatchEvent(_local4);
            rslDone = ((_local2 + 1) == _local4.rslTotal);
        }
        private function timerHandler(_arg1:TimerEvent):void{
            if (!root){
                return;
            };
            var _local2:Object = getByteValues();
            var _local3:int = _local2.loaded;
            var _local4:int = _local2.total;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _local3, _local4));
            if (((rslDone) && ((((((((_local3 >= _local4)) && ((_local4 > 0)))) || ((((_local4 == 0)) && ((_local3 > 0)))))) || ((((((root is MovieClip)) && ((MovieClip(root).totalFrames > 2)))) && ((MovieClip(root).framesLoaded >= 2)))))))){
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.reset();
                dispatchEvent(new Event(Event.COMPLETE));
                dispatchEvent(new FlexEvent(FlexEvent.INIT_PROGRESS));
            };
        }
        private function displayClassCompleteHandler(_arg1:Event):void{
            if (displayClass){
                displayClass.removeEventListener(Event.COMPLETE, displayClassCompleteHandler);
            };
            if (root){
                root.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            };
            if (app){
                app.removeEventListener("validatePropertiesComplete", appProgressHandler);
                app.removeEventListener("validateSizeComplete", appProgressHandler);
                app.removeEventListener("validateDisplayListComplete", appProgressHandler);
                app.removeEventListener(FlexEvent.CREATION_COMPLETE, appCreationCompleteHandler);
                app = null;
            };
            dispatchEvent(new FlexEvent(FlexEvent.PRELOADER_DONE));
        }

    }
}//package mx.preloaders 
