package mx.preloaders {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.text.*;
    import flash.events.*;
    import mx.events.*;
    import flash.system.*;
    import mx.graphics.*;
    import flash.net.*;
    import flash.utils.*;

    public class DownloadProgressBar extends Sprite implements IPreloaderDisplay {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var _initializingLabel:String = "Initializing";

        protected var MINIMUM_DISPLAY_TIME:uint = 0;
        private var _barFrameRect:RoundedRectangle;
        private var _stageHeight:Number = 375;
        private var _stageWidth:Number = 500;
        private var _percentRect:Rectangle;
        private var _percentObj:TextField;
        private var _downloadingLabel:String = "Loading";
        private var _showProgressBar:Boolean = true;
        private var _yOffset:Number = 20;
        private var _initProgressCount:uint = 0;
        private var _barSprite:Sprite;
        private var _visible:Boolean = false;
        private var _barRect:RoundedRectangle;
        private var _showingDisplay:Boolean = false;
        private var _backgroundSize:String = "";
        private var _initProgressTotal:uint = 12;
        private var _startedInit:Boolean = false;
        private var _showLabel:Boolean = true;
        private var _value:Number = 0;
        private var _labelRect:Rectangle;
        private var _backgroundImage:Object;
        private var _backgroundAlpha:Number = 1;
        private var _backgroundColor:uint;
        private var _startedLoading:Boolean = false;
        private var _showPercentage:Boolean = false;
        private var _barFrameSprite:Sprite;
        protected var DOWNLOAD_PERCENTAGE:uint = 60;
        private var _displayStartCount:uint = 0;
        private var _labelObj:TextField;
        private var _borderRect:RoundedRectangle;
        private var _maximum:Number = 0;
        private var _displayTime:int;
        private var _label:String = "";
        private var _preloader:Sprite;
        private var _xOffset:Number = 20;
        private var _startTime:int;

        public function DownloadProgressBar(){
            _labelRect = labelRect;
            _percentRect = percentRect;
            _borderRect = borderRect;
            _barFrameRect = barFrameRect;
            _barRect = barRect;
            super();
        }
        public static function get initializingLabel():String{
            return (_initializingLabel);
        }
        public static function set initializingLabel(_arg1:String):void{
            _initializingLabel = _arg1;
        }

        protected function getPercentLoaded(_arg1:Number, _arg2:Number):Number{
            var _local3:Number;
            if ((((((((_arg1 == 0)) || ((_arg2 == 0)))) || (isNaN(_arg2)))) || (isNaN(_arg1)))){
                return (0);
            };
            _local3 = ((100 * _arg1) / _arg2);
            if (((isNaN(_local3)) || ((_local3 <= 0)))){
                return (0);
            };
            if (_local3 > 99){
                return (99);
            };
            return (Math.round(_local3));
        }
        protected function get labelFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.color = 0x333333;
            _local1.font = "Verdana";
            _local1.size = 10;
            return (_local1);
        }
        private function calcScale():void{
            var _local1:Number;
            if ((((stageWidth < 160)) || ((stageHeight < 120)))){
                scaleX = 1;
                scaleY = 1;
            } else {
                if ((((stageWidth < 240)) || ((stageHeight < 150)))){
                    createChildren();
                    _local1 = Math.min((stageWidth / 240), (stageHeight / 150));
                    scaleX = _local1;
                    scaleY = _local1;
                } else {
                    createChildren();
                };
            };
        }
        protected function get percentRect():Rectangle{
            return (new Rectangle(108, 4, 34, 16));
        }
        protected function set showLabel(_arg1:Boolean):void{
            _showLabel = _arg1;
            draw();
        }
        private function calcBackgroundSize():Number{
            var _local2:int;
            var _local1:Number = NaN;
            if (backgroundSize){
                _local2 = backgroundSize.indexOf("%");
                if (_local2 != -1){
                    _local1 = Number(backgroundSize.substr(0, _local2));
                };
            };
            return (_local1);
        }
        private function show():void{
            _showingDisplay = true;
            calcScale();
            draw();
            _displayTime = getTimer();
        }
        private function loadBackgroundImage(_arg1:Object):void{
            var cls:* = null;
            var newStyleObj:* = null;
            var loader:* = null;
            var loaderContext:* = null;
            var classOrString:* = _arg1;
            if (((classOrString) && ((classOrString as Class)))){
                cls = Class(classOrString);
                initBackgroundImage(new (cls)());
            } else {
                if (((classOrString) && ((classOrString is String)))){
                    try {
                        cls = Class(getDefinitionByName(String(classOrString)));
                    } catch(e:Error) {
                    };
                    if (cls){
                        newStyleObj = new (cls)();
                        initBackgroundImage(newStyleObj);
                    } else {
                        loader = new Loader();
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
                        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
                        loaderContext = new LoaderContext();
                        loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                        loader.load(new URLRequest(String(classOrString)), loaderContext);
                    };
                };
            };
        }
        protected function set showPercentage(_arg1:Boolean):void{
            _showPercentage = _arg1;
            draw();
        }
        protected function get barFrameRect():RoundedRectangle{
            return (new RoundedRectangle(14, 40, 154, 4));
        }
        private function loader_ioErrorHandler(_arg1:IOErrorEvent):void{
        }
        protected function rslErrorHandler(_arg1:RSLEvent):void{
            _preloader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            _preloader.removeEventListener(Event.COMPLETE, completeHandler);
            _preloader.removeEventListener(RSLEvent.RSL_PROGRESS, rslProgressHandler);
            _preloader.removeEventListener(RSLEvent.RSL_COMPLETE, rslCompleteHandler);
            _preloader.removeEventListener(RSLEvent.RSL_ERROR, rslErrorHandler);
            _preloader.removeEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
            _preloader.removeEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
            if (!_showingDisplay){
                show();
                _showingDisplay = true;
            };
            label = ((("RSL Error " + (_arg1.rslIndex + 1)) + " of ") + _arg1.rslTotal);
            var _local2:ErrorField = new ErrorField(this);
            _local2.show(_arg1.errorText);
        }
        protected function rslCompleteHandler(_arg1:RSLEvent):void{
            label = ((("Loaded library " + _arg1.rslIndex) + " of ") + _arg1.rslTotal);
        }
        protected function get borderRect():RoundedRectangle{
            return (new RoundedRectangle(0, 0, 182, 60, 4));
        }
        protected function showDisplayForDownloading(_arg1:int, _arg2:ProgressEvent):Boolean{
            return ((((_arg1 > 700)) && ((_arg2.bytesLoaded < (_arg2.bytesTotal / 2)))));
        }
        protected function createChildren():void{
            var _local2:TextField;
            var _local3:TextField;
            var _local1:Graphics = graphics;
            if (backgroundColor != 0xFFFFFFFF){
                _local1.beginFill(backgroundColor, backgroundAlpha);
                _local1.drawRect(0, 0, stageWidth, stageHeight);
            };
            if (backgroundImage != null){
                loadBackgroundImage(backgroundImage);
            };
            _barFrameSprite = new Sprite();
            _barSprite = new Sprite();
            addChild(_barFrameSprite);
            addChild(_barSprite);
            _local1.beginFill(0xCCCCCC, 0.4);
            _local1.drawRoundRect(calcX(_borderRect.x), calcY(_borderRect.y), _borderRect.width, _borderRect.height, (_borderRect.cornerRadius * 2), (_borderRect.cornerRadius * 2));
            _local1.drawRoundRect(calcX((_borderRect.x + 1)), calcY((_borderRect.y + 1)), (_borderRect.width - 2), (_borderRect.height - 2), (_borderRect.cornerRadius - (1 * 2)), (_borderRect.cornerRadius - (1 * 2)));
            _local1.endFill();
            _local1.beginFill(0xCCCCCC, 0.4);
            _local1.drawRoundRect(calcX((_borderRect.x + 1)), calcY((_borderRect.y + 1)), (_borderRect.width - 2), (_borderRect.height - 2), (_borderRect.cornerRadius - (1 * 2)), (_borderRect.cornerRadius - (1 * 2)));
            _local1.endFill();
            var _local4:Graphics = _barFrameSprite.graphics;
            var _local5:Matrix = new Matrix();
            _local5.createGradientBox(_barFrameRect.width, _barFrameRect.height, (Math.PI / 2), calcX(_barFrameRect.x), calcY(_barFrameRect.y));
            _local4.beginGradientFill(GradientType.LINEAR, [6054502, 11909306], [1, 1], [0, 0xFF], _local5);
            _local4.drawRoundRect(calcX(_barFrameRect.x), calcY(_barFrameRect.y), _barFrameRect.width, _barFrameRect.height, (_barFrameRect.cornerRadius * 2), (_barFrameRect.cornerRadius * 2));
            _local4.drawRoundRect(calcX((_barFrameRect.x + 1)), calcY((_barFrameRect.y + 1)), (_barFrameRect.width - 2), (_barFrameRect.height - 2), (_barFrameRect.cornerRadius * 2), (_barFrameRect.cornerRadius * 2));
            _local4.endFill();
            _labelObj = new TextField();
            _labelObj.x = calcX(_labelRect.x);
            _labelObj.y = calcY(_labelRect.y);
            _labelObj.width = _labelRect.width;
            _labelObj.height = _labelRect.height;
            _labelObj.selectable = false;
            _labelObj.defaultTextFormat = labelFormat;
            addChild(_labelObj);
            _percentObj = new TextField();
            _percentObj.x = calcX(_percentRect.x);
            _percentObj.y = calcY(_percentRect.y);
            _percentObj.width = _percentRect.width;
            _percentObj.height = _percentRect.height;
            _percentObj.selectable = false;
            _percentObj.defaultTextFormat = percentFormat;
            addChild(_percentObj);
            var _local6:RectangularDropShadow = new RectangularDropShadow();
            _local6.color = 0;
            _local6.angle = 90;
            _local6.alpha = 0.6;
            _local6.distance = 2;
            _local6.tlRadius = (_local6.trRadius = (_local6.blRadius = (_local6.brRadius = _borderRect.cornerRadius)));
            _local6.drawShadow(_local1, calcX(_borderRect.x), calcY(_borderRect.y), _borderRect.width, _borderRect.height);
            _local1.lineStyle(1, 0xFFFFFF, 0.3);
            _local1.moveTo((calcX(_borderRect.x) + _borderRect.cornerRadius), calcY(_borderRect.y));
            _local1.lineTo(((calcX(_borderRect.x) - _borderRect.cornerRadius) + _borderRect.width), calcY(_borderRect.y));
        }
        private function draw():void{
            var _local1:Number;
            if (_startedLoading){
                if (!_startedInit){
                    _local1 = Math.round(((getPercentLoaded(_value, _maximum) * DOWNLOAD_PERCENTAGE) / 100));
                } else {
                    _local1 = Math.round((((getPercentLoaded(_value, _maximum) * (100 - DOWNLOAD_PERCENTAGE)) / 100) + DOWNLOAD_PERCENTAGE));
                };
            } else {
                _local1 = getPercentLoaded(_value, _maximum);
            };
            if (_labelObj){
                _labelObj.text = _label;
            };
            if (_percentObj){
                if (!_showPercentage){
                    _percentObj.visible = false;
                    _percentObj.text = "";
                } else {
                    _percentObj.text = (String(_local1) + "%");
                };
            };
            if (((_barSprite) && (_barFrameSprite))){
                if (!_showProgressBar){
                    _barSprite.visible = false;
                    _barFrameSprite.visible = false;
                } else {
                    drawProgressBar(_local1);
                };
            };
        }
        private function timerHandler(_arg1:Event=null):void{
            dispatchEvent(new Event(Event.COMPLETE));
        }
        private function hide():void{
        }
        public function get backgroundSize():String{
            return (_backgroundSize);
        }
        protected function center(_arg1:Number, _arg2:Number):void{
            _xOffset = Math.floor(((_arg1 - _borderRect.width) / 2));
            _yOffset = Math.floor(((_arg2 - _borderRect.height) / 2));
        }
        protected function progressHandler(_arg1:ProgressEvent):void{
            var _local2:uint = _arg1.bytesLoaded;
            var _local3:uint = _arg1.bytesTotal;
            var _local4:int = (getTimer() - _startTime);
            if (((_showingDisplay) || (showDisplayForDownloading(_local4, _arg1)))){
                if (!_startedLoading){
                    show();
                    label = downloadingLabel;
                    _startedLoading = true;
                };
                setProgress(_arg1.bytesLoaded, _arg1.bytesTotal);
            };
        }
        protected function initProgressHandler(_arg1:Event):void{
            var _local3:Number;
            var _local2:int = (getTimer() - _startTime);
            _initProgressCount++;
            if (((!(_showingDisplay)) && (showDisplayForInit(_local2, _initProgressCount)))){
                _displayStartCount = _initProgressCount;
                show();
            } else {
                if (_showingDisplay){
                    if (!_startedInit){
                        _startedInit = true;
                        label = initializingLabel;
                    };
                    _local3 = ((100 * _initProgressCount) / (_initProgressTotal - _displayStartCount));
                    setProgress(_local3, 100);
                };
            };
        }
        protected function set downloadingLabel(_arg1:String):void{
            _downloadingLabel = _arg1;
        }
        public function get stageWidth():Number{
            return (_stageWidth);
        }
        protected function get showPercentage():Boolean{
            return (_showPercentage);
        }
        override public function get visible():Boolean{
            return (_visible);
        }
        public function set stageHeight(_arg1:Number):void{
            _stageHeight = _arg1;
        }
        public function initialize():void{
            _startTime = getTimer();
            center(stageWidth, stageHeight);
        }
        protected function rslProgressHandler(_arg1:RSLEvent):void{
        }
        protected function get barRect():RoundedRectangle{
            return (new RoundedRectangle(14, 39, 154, 6, 0));
        }
        protected function get percentFormat():TextFormat{
            var _local1:TextFormat = new TextFormat();
            _local1.align = "right";
            _local1.color = 0;
            _local1.font = "Verdana";
            _local1.size = 10;
            return (_local1);
        }
        public function set backgroundImage(_arg1:Object):void{
            _backgroundImage = _arg1;
        }
        private function calcX(_arg1:Number):Number{
            return ((_arg1 + _xOffset));
        }
        private function calcY(_arg1:Number):Number{
            return ((_arg1 + _yOffset));
        }
        public function set backgroundAlpha(_arg1:Number):void{
            _backgroundAlpha = _arg1;
        }
        private function initCompleteHandler(_arg1:Event):void{
            var _local3:Timer;
            var _local2:int = (getTimer() - _displayTime);
            if (((_showingDisplay) && ((_local2 < MINIMUM_DISPLAY_TIME)))){
                _local3 = new Timer((MINIMUM_DISPLAY_TIME - _local2), 1);
                _local3.addEventListener(TimerEvent.TIMER, timerHandler);
                _local3.start();
            } else {
                timerHandler();
            };
        }
        public function set backgroundColor(_arg1:uint):void{
            _backgroundColor = _arg1;
        }
        private function initBackgroundImage(_arg1:DisplayObject):void{
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            addChildAt(_arg1, 0);
            var _local2:Number = _arg1.width;
            var _local3:Number = _arg1.height;
            var _local4:Number = calcBackgroundSize();
            if (isNaN(_local4)){
                _local7 = 1;
                _local8 = 1;
            } else {
                _local9 = (_local4 * 0.01);
                _local7 = ((_local9 * stageWidth) / _local2);
                _local8 = ((_local9 * stageHeight) / _local3);
            };
            _arg1.scaleX = _local7;
            _arg1.scaleY = _local8;
            var _local5:Number = Math.round((0.5 * (stageWidth - (_local2 * _local7))));
            var _local6:Number = Math.round((0.5 * (stageHeight - (_local3 * _local8))));
            _arg1.x = _local5;
            _arg1.y = _local6;
            if (!isNaN(backgroundAlpha)){
                _arg1.alpha = backgroundAlpha;
            };
        }
        public function set backgroundSize(_arg1:String):void{
            _backgroundSize = _arg1;
        }
        protected function showDisplayForInit(_arg1:int, _arg2:int):Boolean{
            return ((((_arg1 > 300)) && ((_arg2 == 2))));
        }
        protected function get downloadingLabel():String{
            return (_downloadingLabel);
        }
        private function loader_completeHandler(_arg1:Event):void{
            var _local2:DisplayObject = DisplayObject(LoaderInfo(_arg1.target).loader);
            initBackgroundImage(_local2);
        }
        protected function setProgress(_arg1:Number, _arg2:Number):void{
            if (((((((!(isNaN(_arg1))) && (!(isNaN(_arg2))))) && ((_arg1 >= 0)))) && ((_arg2 > 0)))){
                _value = Number(_arg1);
                _maximum = Number(_arg2);
                draw();
            };
        }
        public function get stageHeight():Number{
            return (_stageHeight);
        }
        public function get backgroundImage():Object{
            return (_backgroundImage);
        }
        public function get backgroundAlpha():Number{
            if (!isNaN(_backgroundAlpha)){
                return (_backgroundAlpha);
            };
            return (1);
        }
        private function drawProgressBar(_arg1:Number):void{
            var _local11:Number;
            var _local2:Graphics = _barSprite.graphics;
            _local2.clear();
            var _local3:Array = [0xFFFFFF, 0xFFFFFF];
            var _local4:Array = [0, 0xFF];
            var _local5:Matrix = new Matrix();
            var _local6:Number = ((_barRect.width * _arg1) / 100);
            var _local7:Number = (_local6 / 2);
            var _local8:Number = (_barRect.height - 4);
            var _local9:Number = calcX(_barRect.x);
            var _local10:Number = (calcY(_barRect.y) + 2);
            _local5.createGradientBox(_local7, _local8, 0, _local9, _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.39, 0.85], _local4, _local5);
            _local2.drawRect(_local9, _local10, _local7, _local8);
            _local5.createGradientBox(_local7, _local8, 0, (_local9 + _local7), _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.85, 1], _local4, _local5);
            _local2.drawRect((_local9 + _local7), _local10, _local7, _local8);
            _local7 = (_local6 / 3);
            _local8 = _barRect.height;
            _local10 = calcY(_barRect.y);
            _local11 = ((_local10 + _local8) - 1);
            _local5.createGradientBox(_local7, _local8, 0, _local9, _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.05, 0.15], _local4, _local5);
            _local2.drawRect(_local9, _local10, _local7, 1);
            _local2.drawRect(_local9, _local11, _local7, 1);
            _local5.createGradientBox(_local7, _local8, 0, (_local9 + _local7), _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.15, 0.25], _local4, _local5);
            _local2.drawRect((_local9 + _local7), _local10, _local7, 1);
            _local2.drawRect((_local9 + _local7), _local11, _local7, 1);
            _local5.createGradientBox(_local7, _local8, 0, (_local9 + (_local7 * 2)), _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.25, 0.1], _local4, _local5);
            _local2.drawRect((_local9 + (_local7 * 2)), _local10, _local7, 1);
            _local2.drawRect((_local9 + (_local7 * 2)), _local11, _local7, 1);
            _local7 = (_local6 / 3);
            _local8 = _barRect.height;
            _local10 = (calcY(_barRect.y) + 1);
            _local11 = ((calcY(_barRect.y) + _local8) - 2);
            _local5.createGradientBox(_local7, _local8, 0, _local9, _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.15, 0.3], _local4, _local5);
            _local2.drawRect(_local9, _local10, _local7, 1);
            _local2.drawRect(_local9, _local11, _local7, 1);
            _local5.createGradientBox(_local7, _local8, 0, (_local9 + _local7), _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.3, 0.4], _local4, _local5);
            _local2.drawRect((_local9 + _local7), _local10, _local7, 1);
            _local2.drawRect((_local9 + _local7), _local11, _local7, 1);
            _local5.createGradientBox(_local7, _local8, 0, (_local9 + (_local7 * 2)), _local10);
            _local2.beginGradientFill(GradientType.LINEAR, _local3, [0.4, 0.25], _local4, _local5);
            _local2.drawRect((_local9 + (_local7 * 2)), _local10, _local7, 1);
            _local2.drawRect((_local9 + (_local7 * 2)), _local11, _local7, 1);
        }
        public function get backgroundColor():uint{
            return (_backgroundColor);
        }
        public function set stageWidth(_arg1:Number):void{
            _stageWidth = _arg1;
        }
        protected function completeHandler(_arg1:Event):void{
        }
        protected function set label(_arg1:String):void{
            if (!(_arg1 is Function)){
                _label = _arg1;
            };
            draw();
        }
        public function set preloader(_arg1:Sprite):void{
            _preloader = _arg1;
            _arg1.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            _arg1.addEventListener(Event.COMPLETE, completeHandler);
            _arg1.addEventListener(RSLEvent.RSL_PROGRESS, rslProgressHandler);
            _arg1.addEventListener(RSLEvent.RSL_COMPLETE, rslCompleteHandler);
            _arg1.addEventListener(RSLEvent.RSL_ERROR, rslErrorHandler);
            _arg1.addEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
            _arg1.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
        }
        protected function get label():String{
            return (_label);
        }
        protected function get labelRect():Rectangle{
            return (new Rectangle(14, 17, 100, 16));
        }
        override public function set visible(_arg1:Boolean):void{
            if (((!(_visible)) && (_arg1))){
                show();
            } else {
                if (((_visible) && (!(_arg1)))){
                    hide();
                };
            };
            _visible = _arg1;
        }
        protected function get showLabel():Boolean{
            return (_showLabel);
        }

    }
}//package mx.preloaders 

import flash.display.*;
import flash.text.*;
import flash.system.*;

class ErrorField extends Sprite {

    private const TEXT_MARGIN_PX:int = 10;
    private const MAX_WIDTH_INCHES:int = 6;
    private const MIN_WIDTH_INCHES:int = 2;

    private var downloadProgressBar:DownloadProgressBar;

    public function ErrorField(_arg1:DownloadProgressBar){
        this.downloadProgressBar = _arg1;
    }
    protected function get labelFormat():TextFormat{
        var _local1:TextFormat = new TextFormat();
        _local1.color = 0;
        _local1.font = "Verdana";
        _local1.size = 10;
        return (_local1);
    }
    public function show(_arg1:String):void{
        if ((((_arg1 == null)) || ((_arg1.length == 0)))){
            return;
        };
        var _local2:Number = downloadProgressBar.stageWidth;
        var _local3:Number = downloadProgressBar.stageHeight;
        var _local4:TextField = new TextField();
        _local4.autoSize = TextFieldAutoSize.LEFT;
        _local4.multiline = true;
        _local4.wordWrap = true;
        _local4.background = true;
        _local4.defaultTextFormat = labelFormat;
        _local4.text = _arg1;
        _local4.width = Math.max((MIN_WIDTH_INCHES * Capabilities.screenDPI), (_local2 - (TEXT_MARGIN_PX * 2)));
        _local4.width = Math.min((MAX_WIDTH_INCHES * Capabilities.screenDPI), _local4.width);
        _local4.y = Math.max(0, ((_local3 - TEXT_MARGIN_PX) - _local4.height));
        _local4.x = ((_local2 - _local4.width) / 2);
        downloadProgressBar.parent.addChild(this);
        this.addChild(_local4);
    }

}
