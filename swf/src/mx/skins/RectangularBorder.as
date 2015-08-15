package mx.skins {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.resources.*;
    import mx.styles.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.net.*;

    public class RectangularBorder extends Border implements IRectangularBorder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var backgroundImage:DisplayObject;
        private var backgroundImageHeight:Number;
        private var _backgroundImageBounds:Rectangle;
        private var backgroundImageStyle:Object;
        private var backgroundImageWidth:Number;
        private var resourceManager:IResourceManager;

        public function RectangularBorder(){
            resourceManager = ResourceManager.getInstance();
            super();
            addEventListener(Event.REMOVED, removedHandler);
        }
        public function layoutBackgroundImage():void{
            var _local4:Number;
            var _local5:Number;
            var _local7:Number;
            var _local8:Number;
            var _local14:Number;
            var _local15:Graphics;
            var _local1:DisplayObject = parent;
            var _local2:EdgeMetrics = (((_local1 is IContainer)) ? IContainer(_local1).viewMetrics : borderMetrics);
            var _local3 = !((getStyle("backgroundAttachment") == "fixed"));
            if (_backgroundImageBounds){
                _local4 = _backgroundImageBounds.width;
                _local5 = _backgroundImageBounds.height;
            } else {
                _local4 = ((width - _local2.left) - _local2.right);
                _local5 = ((height - _local2.top) - _local2.bottom);
            };
            var _local6:Number = getBackgroundSize();
            if (isNaN(_local6)){
                _local7 = 1;
                _local8 = 1;
            } else {
                _local14 = (_local6 * 0.01);
                _local7 = ((_local14 * _local4) / backgroundImageWidth);
                _local8 = ((_local14 * _local5) / backgroundImageHeight);
            };
            backgroundImage.scaleX = _local7;
            backgroundImage.scaleY = _local8;
            var _local9:Number = Math.round((0.5 * (_local4 - (backgroundImageWidth * _local7))));
            var _local10:Number = Math.round((0.5 * (_local5 - (backgroundImageHeight * _local8))));
            backgroundImage.x = _local2.left;
            backgroundImage.y = _local2.top;
            var _local11:Shape = Shape(backgroundImage.mask);
            _local11.x = _local2.left;
            _local11.y = _local2.top;
            if (((_local3) && ((_local1 is IContainer)))){
                _local9 = (_local9 - IContainer(_local1).horizontalScrollPosition);
                _local10 = (_local10 - IContainer(_local1).verticalScrollPosition);
            };
            backgroundImage.alpha = getStyle("backgroundAlpha");
            backgroundImage.x = (backgroundImage.x + _local9);
            backgroundImage.y = (backgroundImage.y + _local10);
            var _local12:Number = ((width - _local2.left) - _local2.right);
            var _local13:Number = ((height - _local2.top) - _local2.bottom);
            if (((!((_local11.width == _local12))) || (!((_local11.height == _local13))))){
                _local15 = _local11.graphics;
                _local15.clear();
                _local15.beginFill(0xFFFFFF);
                _local15.drawRect(0, 0, _local12, _local13);
                _local15.endFill();
            };
        }
        public function set backgroundImageBounds(_arg1:Rectangle):void{
            _backgroundImageBounds = _arg1;
            invalidateDisplayList();
        }
        private function getBackgroundSize():Number{
            var _local3:int;
            var _local1:Number = NaN;
            var _local2:Object = getStyle("backgroundSize");
            if (((_local2) && ((_local2 is String)))){
                _local3 = _local2.indexOf("%");
                if (_local3 != -1){
                    _local1 = Number(_local2.substr(0, _local3));
                };
            };
            return (_local1);
        }
        private function removedHandler(_arg1:Event):void{
            var _local2:IChildList;
            if (backgroundImage){
                _local2 = (((parent is IRawChildrenContainer)) ? IRawChildrenContainer(parent).rawChildren : IChildList(parent));
                _local2.removeChild(backgroundImage.mask);
                _local2.removeChild(backgroundImage);
                backgroundImage = null;
            };
        }
        private function initBackgroundImage(_arg1:DisplayObject):void{
            backgroundImage = _arg1;
            if ((_arg1 is Loader)){
                backgroundImageWidth = Loader(_arg1).contentLoaderInfo.width;
                backgroundImageHeight = Loader(_arg1).contentLoaderInfo.height;
            } else {
                backgroundImageWidth = backgroundImage.width;
                backgroundImageHeight = backgroundImage.height;
                if ((_arg1 is ISimpleStyleClient)){
                    ISimpleStyleClient(_arg1).styleName = styleName;
                };
            };
            var _local2:IChildList = (((parent is IRawChildrenContainer)) ? IRawChildrenContainer(parent).rawChildren : IChildList(parent));
            var _local3:Shape = new FlexShape();
            _local3.name = "backgroundMask";
            _local3.x = 0;
            _local3.y = 0;
            _local2.addChild(_local3);
            var _local4:int = _local2.getChildIndex(this);
            _local2.addChildAt(backgroundImage, (_local4 + 1));
            backgroundImage.mask = _local3;
        }
        public function get backgroundImageBounds():Rectangle{
            return (_backgroundImageBounds);
        }
        public function get hasBackgroundImage():Boolean{
            return (!((backgroundImage == null)));
        }
        private function completeEventHandler(_arg1:Event):void{
            if (!parent){
                return;
            };
            var _local2:DisplayObject = DisplayObject(LoaderInfo(_arg1.target).loader);
            initBackgroundImage(_local2);
            layoutBackgroundImage();
            dispatchEvent(_arg1.clone());
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var cls:* = null;
            var newStyleObj:* = null;
            const loader:* = null;
            var loaderContext:* = null;
            var message:* = null;
            var unscaledWidth:* = _arg1;
            var unscaledHeight:* = _arg2;
            if (!parent){
                return;
            };
            var newStyle:* = getStyle("backgroundImage");
            if (newStyle != backgroundImageStyle){
                removedHandler(null);
                backgroundImageStyle = newStyle;
                if (((newStyle) && ((newStyle as Class)))){
                    cls = Class(newStyle);
                    initBackgroundImage(new (cls)());
                } else {
                    if (((newStyle) && ((newStyle is String)))){
                        try {
                            cls = Class(getDefinitionByName(String(newStyle)));
                        } catch(e:Error) {
                        };
                        if (cls){
                            newStyleObj = new (cls)();
                            initBackgroundImage(newStyleObj);
                        } else {
                            loader = new FlexLoader();
                            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeEventHandler);
                            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
                            loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, errorEventHandler);
                            loaderContext = new LoaderContext();
                            loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                            loader.load(new URLRequest(String(newStyle)), loaderContext);
                        };
                    } else {
                        if (newStyle){
                            message = resourceManager.getString("skins", "notLoaded", [newStyle]);
                            throw (new Error(message));
                        };
                    };
                };
            };
            if (backgroundImage){
                layoutBackgroundImage();
            };
        }
        private function errorEventHandler(_arg1:Event):void{
        }

    }
}//package mx.skins 
