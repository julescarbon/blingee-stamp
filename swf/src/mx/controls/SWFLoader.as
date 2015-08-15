package mx.controls {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.net.*;
    import mx.utils.*;

    public class SWFLoader extends UIComponent implements ISWFLoader {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _loadForCompatibility:Boolean = false;
        private var _loaderContext:LoaderContext;
        private var requestedURL:URLRequest;
        private var _swfBridge:IEventDispatcher;
        private var _bytesTotal:Number = NaN;
        private var useUnloadAndStop:Boolean;
        private var flexContent:Boolean = false;
        private var explicitLoaderContext:Boolean = false;
        private var resizableContent:Boolean = false;
        private var brokenImageBorder:IFlexDisplayObject;
        private var _maintainAspectRatio:Boolean = true;
        private var _source:Object;
        private var mouseShield:Sprite;
        private var contentRequestID:String = null;
        mx_internal var contentHolder:DisplayObject;
        private var brokenImage:Boolean = false;
        private var _bytesLoaded:Number = NaN;
        private var _autoLoad:Boolean = true;
        private var _showBusyCursor:Boolean = false;
        private var _scaleContent:Boolean = true;
        private var isContentLoaded:Boolean = false;
        private var unloadAndStopGC:Boolean;
        private var _trustContent:Boolean = false;
        private var attemptingChildAppDomain:Boolean = false;
        private var scaleContentChanged:Boolean = false;
        private var contentChanged:Boolean = false;

        public function SWFLoader(){
            tabChildren = true;
            tabEnabled = false;
            addEventListener(FlexEvent.INITIALIZE, initializeHandler);
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            showInAutomationHierarchy = false;
        }
        public function get contentHeight():Number{
            return (((contentHolder) ? contentHolder.height : NaN));
        }
        public function get trustContent():Boolean{
            return (_trustContent);
        }
        public function set trustContent(_arg1:Boolean):void{
            if (_trustContent != _arg1){
                _trustContent = _arg1;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("trustContentChanged"));
            };
        }
        public function get maintainAspectRatio():Boolean{
            return (_maintainAspectRatio);
        }
        private function unScaleContent():void{
            contentHolder.scaleX = 1;
            contentHolder.scaleY = 1;
            contentHolder.x = 0;
            contentHolder.y = 0;
        }
        public function set maintainAspectRatio(_arg1:Boolean):void{
            _maintainAspectRatio = _arg1;
            dispatchEvent(new Event("maintainAspectRatioChanged"));
        }
        override public function regenerateStyleCache(_arg1:Boolean):void{
            var sm:* = null;
            var recursive:* = _arg1;
            super.regenerateStyleCache(recursive);
            try {
                sm = (content as ISystemManager);
                if (sm != null){
                    Object(sm).regenerateStyleCache(recursive);
                };
            } catch(error:Error) {
            };
        }
        private function get contentHolderHeight():Number{
            var loaderInfo:* = null;
            var content:* = null;
            var bridge:* = null;
            var request:* = null;
            var testContent:* = null;
            if ((contentHolder is Loader)){
                loaderInfo = Loader(contentHolder).contentLoaderInfo;
            };
            if (loaderInfo){
                if (loaderInfo.contentType == "application/x-shockwave-flash"){
                    try {
                        if (systemManager.swfBridgeGroup){
                            bridge = swfBridge;
                            if (bridge){
                                request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                                bridge.dispatchEvent(request);
                                return (request.data.height);
                            };
                        };
                        content = (Loader(contentHolder).content as IFlexDisplayObject);
                        if (content){
                            return (content.measuredHeight);
                        };
                    } catch(error:Error) {
                        return (contentHolder.height);
                    };
                } else {
                    try {
                        testContent = Loader(contentHolder).content;
                    } catch(error:Error) {
                        return (contentHolder.height);
                    };
                };
                return (loaderInfo.height);
            };
            if ((contentHolder is IUIComponent)){
                return (IUIComponent(contentHolder).getExplicitOrMeasuredHeight());
            };
            if ((contentHolder is IFlexDisplayObject)){
                return (IFlexDisplayObject(contentHolder).measuredHeight);
            };
            return (contentHolder.height);
        }
        public function get loaderContext():LoaderContext{
            return (_loaderContext);
        }
        public function set showBusyCursor(_arg1:Boolean):void{
            if (_showBusyCursor != _arg1){
                _showBusyCursor = _arg1;
                if (_showBusyCursor){
                    CursorManager.registerToUseBusyCursor(this);
                } else {
                    CursorManager.unRegisterToUseBusyCursor(this);
                };
            };
        }
        override public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            var sm:* = null;
            var styleProp:* = _arg1;
            var recursive:* = _arg2;
            super.notifyStyleChangeInChildren(styleProp, recursive);
            try {
                sm = (content as ISystemManager);
                if (sm != null){
                    Object(sm).notifyStyleChangeInChildren(styleProp, recursive);
                };
            } catch(error:Error) {
            };
        }
        private function getHorizontalAlignValue():Number{
            var _local1:String = getStyle("horizontalAlign");
            if (_local1 == "left"){
                return (0);
            };
            if (_local1 == "right"){
                return (1);
            };
            return (0.5);
        }
        public function get source():Object{
            return (_source);
        }
        public function get loadForCompatibility():Boolean{
            return (_loadForCompatibility);
        }
        private function contentLoaderInfo_httpStatusEventHandler(_arg1:HTTPStatusEvent):void{
            dispatchEvent(_arg1);
        }
        public function get autoLoad():Boolean{
            return (_autoLoad);
        }
        public function set source(_arg1:Object):void{
            if (_source != _arg1){
                _source = _arg1;
                contentChanged = true;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("sourceChanged"));
            };
        }
        public function set loaderContext(_arg1:LoaderContext):void{
            _loaderContext = _arg1;
            explicitLoaderContext = true;
            dispatchEvent(new Event("loaderContextChanged"));
        }
        private function get contentHolderWidth():Number{
            var loaderInfo:* = null;
            var content:* = null;
            var request:* = null;
            var testContent:* = null;
            if ((contentHolder is Loader)){
                loaderInfo = Loader(contentHolder).contentLoaderInfo;
            };
            if (loaderInfo){
                if (loaderInfo.contentType == "application/x-shockwave-flash"){
                    try {
                        if (swfBridge){
                            request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                            swfBridge.dispatchEvent(request);
                            return (request.data.width);
                        };
                        content = (Loader(contentHolder).content as IFlexDisplayObject);
                        if (content){
                            return (content.measuredWidth);
                        };
                    } catch(error:Error) {
                        return (contentHolder.width);
                    };
                } else {
                    try {
                        testContent = Loader(contentHolder).content;
                    } catch(error:Error) {
                        return (contentHolder.width);
                    };
                };
                return (loaderInfo.width);
            };
            if ((contentHolder is IUIComponent)){
                return (IUIComponent(contentHolder).getExplicitOrMeasuredWidth());
            };
            if ((contentHolder is IFlexDisplayObject)){
                return (IFlexDisplayObject(contentHolder).measuredWidth);
            };
            return (contentHolder.width);
        }
        public function get bytesLoaded():Number{
            return (_bytesLoaded);
        }
        private function removeInitSystemManagerCompleteListener(_arg1:LoaderInfo):void{
            var _local2:EventDispatcher;
            if (_arg1.contentType == "application/x-shockwave-flash"){
                _local2 = _arg1.sharedEvents;
                _local2.removeEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION, initSystemManagerCompleteEventHandler);
            };
        }
        public function set loadForCompatibility(_arg1:Boolean):void{
            if (_loadForCompatibility != _arg1){
                _loadForCompatibility = _arg1;
                contentChanged = true;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("loadForCompatibilityChanged"));
            };
        }
        override protected function measure():void{
            var _local1:Number;
            var _local2:Number;
            super.measure();
            if (isContentLoaded){
                _local1 = contentHolder.scaleX;
                _local2 = contentHolder.scaleY;
                contentHolder.scaleX = 1;
                contentHolder.scaleY = 1;
                measuredWidth = contentHolderWidth;
                measuredHeight = contentHolderHeight;
                contentHolder.scaleX = _local1;
                contentHolder.scaleY = _local2;
            } else {
                if (((!(_source)) || ((_source == "")))){
                    measuredWidth = 0;
                    measuredHeight = 0;
                };
            };
        }
        private function contentLoaderInfo_initEventHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
            addInitSystemManagerCompleteListener(LoaderInfo(_arg1.target).loader.contentLoaderInfo);
        }
        public function set autoLoad(_arg1:Boolean):void{
            if (_autoLoad != _arg1){
                _autoLoad = _arg1;
                contentChanged = true;
                invalidateProperties();
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("autoLoadChanged"));
            };
        }
        private function doScaleLoader():void{
            if (!isContentLoaded){
                return;
            };
            unScaleContent();
            var _local1:Number = unscaledWidth;
            var _local2:Number = unscaledHeight;
            if ((((((contentHolderWidth > _local1)) || ((contentHolderHeight > _local2)))) || (!(parentAllowsChild)))){
                contentHolder.scrollRect = new Rectangle(0, 0, _local1, _local2);
            } else {
                contentHolder.scrollRect = null;
            };
            contentHolder.x = ((_local1 - contentHolderWidth) * getHorizontalAlignValue());
            contentHolder.y = ((_local2 - contentHolderHeight) * getVerticalAlignValue());
        }
        private function getVerticalAlignValue():Number{
            var _local1:String = getStyle("verticalAlign");
            if (_local1 == "top"){
                return (0);
            };
            if (_local1 == "bottom"){
                return (1);
            };
            return (0.5);
        }
        public function get content():DisplayObject{
            if ((contentHolder is Loader)){
                return (Loader(contentHolder).content);
            };
            return (contentHolder);
        }
        private function dispatchInvalidateRequest(_arg1:Boolean, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:ISystemManager = systemManager;
            if (!_local4.useSWFBridge()){
                return;
            };
            var _local5:IEventDispatcher = _local4.swfBridgeGroup.parentBridge;
            var _local6:uint;
            if (_arg1){
                _local6 = (_local6 | InvalidateRequestData.PROPERTIES);
            };
            if (_arg2){
                _local6 = (_local6 | InvalidateRequestData.SIZE);
            };
            if (_arg3){
                _local6 = (_local6 | InvalidateRequestData.DISPLAY_LIST);
            };
            var _local7:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.INVALIDATE_REQUEST, false, false, _local5, _local6);
            _local5.dispatchEvent(_local7);
        }
        public function getVisibleApplicationRect(_arg1:Boolean=false):Rectangle{
            var _local2:Rectangle = getVisibleRect();
            if (_arg1){
                _local2 = systemManager.getVisibleApplicationRect(_local2);
            };
            return (_local2);
        }
        public function unloadAndStop(_arg1:Boolean=true):void{
            useUnloadAndStop = true;
            unloadAndStopGC = _arg1;
            source = null;
        }
        private function contentLoaderInfo_progressEventHandler(_arg1:ProgressEvent):void{
            _bytesTotal = _arg1.bytesTotal;
            _bytesLoaded = _arg1.bytesLoaded;
            dispatchEvent(_arg1);
        }
        public function get showBusyCursor():Boolean{
            return (_showBusyCursor);
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (0);
            };
            return (super.baselinePosition);
        }
        private function initSystemManagerCompleteEventHandler(_arg1:Event):void{
            var _local3:ISystemManager;
            var _local2:Object = Object(_arg1);
            if ((((contentHolder is Loader)) && ((_local2.data == Loader(contentHolder).contentLoaderInfo.sharedEvents)))){
                _swfBridge = Loader(contentHolder).contentLoaderInfo.sharedEvents;
                _local3 = systemManager;
                _local3.addChildBridge(_swfBridge, this);
                removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
                _swfBridge.addEventListener(SWFBridgeRequest.INVALIDATE_REQUEST, invalidateRequestHandler);
            };
        }
        public function get bytesTotal():Number{
            return (_bytesTotal);
        }
        private function initializeHandler(_arg1:FlexEvent):void{
            if (contentChanged){
                contentChanged = false;
                if (_autoLoad){
                    load(_source);
                };
            };
        }
        private function contentLoaderInfo_unloadEventHandler(_arg1:Event):void{
            var _local2:ISystemManager;
            dispatchEvent(_arg1);
            if (_swfBridge){
                _swfBridge.removeEventListener(SWFBridgeRequest.INVALIDATE_REQUEST, invalidateRequestHandler);
                _local2 = systemManager;
                _local2.removeChildBridge(_swfBridge);
                _swfBridge = null;
            };
            if ((contentHolder is Loader)){
                removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            };
        }
        mx_internal function contentLoaderInfo_completeEventHandler(_arg1:Event):void{
            if (LoaderInfo(_arg1.target).loader != contentHolder){
                return;
            };
            dispatchEvent(_arg1);
            contentLoaded();
            if ((contentHolder is Loader)){
                removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            };
        }
        public function set scaleContent(_arg1:Boolean):void{
            if (_scaleContent != _arg1){
                _scaleContent = _arg1;
                scaleContentChanged = true;
                invalidateDisplayList();
            };
            dispatchEvent(new Event("scaleContentChanged"));
        }
        private function contentLoaderInfo_openEventHandler(_arg1:Event):void{
            dispatchEvent(_arg1);
        }
        private function addedToStageHandler(_arg1:Event):void{
            systemManager.getSandboxRoot().addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST, mouseShieldHandler, false, 0, true);
        }
        public function get percentLoaded():Number{
            var _local1:Number = ((((isNaN(_bytesTotal)) || ((_bytesTotal == 0)))) ? 0 : (100 * (_bytesLoaded / _bytesTotal)));
            if (isNaN(_local1)){
                _local1 = 0;
            };
            return (_local1);
        }
        public function get swfBridge():IEventDispatcher{
            return (_swfBridge);
        }
        private function loadContent(_arg1:Object):DisplayObject{
            var child:* = null;
            var cls:* = null;
            var url:* = null;
            var byteArray:* = null;
            var loader:* = null;
            var lc:* = null;
            var rootURL:* = null;
            var lastIndex:* = 0;
            var currentDomain:* = null;
            var topmostDomain:* = null;
            var message:* = null;
            var classOrString:* = _arg1;
            if ((classOrString is Class)){
                cls = Class(classOrString);
            } else {
                if ((classOrString is String)){
                    try {
                        cls = Class(systemManager.getDefinitionByName(String(classOrString)));
                    } catch(e:Error) {
                    };
                    url = String(classOrString);
                } else {
                    if ((classOrString is ByteArray)){
                        byteArray = ByteArray(classOrString);
                    } else {
                        url = classOrString.toString();
                    };
                };
            };
            if (cls){
                var _local3 = new (cls)();
                child = _local3;
                contentHolder = _local3;
                addChild(child);
                contentLoaded();
            } else {
                if ((classOrString is DisplayObject)){
                    _local3 = DisplayObject(classOrString);
                    child = _local3;
                    contentHolder = _local3;
                    addChild(child);
                    contentLoaded();
                } else {
                    if (byteArray){
                        loader = new FlexLoader();
                        child = loader;
                        addChild(child);
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaderInfo_completeEventHandler);
                        loader.contentLoaderInfo.addEventListener(Event.INIT, contentLoaderInfo_initEventHandler);
                        loader.contentLoaderInfo.addEventListener(Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
                        loader.loadBytes(byteArray, loaderContext);
                    } else {
                        if (url){
                            loader = new FlexLoader();
                            child = loader;
                            addChild(loader);
                            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaderInfo_completeEventHandler);
                            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, contentLoaderInfo_httpStatusEventHandler);
                            loader.contentLoaderInfo.addEventListener(Event.INIT, contentLoaderInfo_initEventHandler);
                            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, contentLoaderInfo_ioErrorEventHandler);
                            loader.contentLoaderInfo.addEventListener(Event.OPEN, contentLoaderInfo_openEventHandler);
                            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, contentLoaderInfo_progressEventHandler);
                            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, contentLoaderInfo_securityErrorEventHandler);
                            loader.contentLoaderInfo.addEventListener(Event.UNLOAD, contentLoaderInfo_unloadEventHandler);
                            if ((((((Capabilities.isDebugger == true)) && ((url.indexOf(".jpg") == -1)))) && ((LoaderUtil.normalizeURL(Application.application.systemManager.loaderInfo).indexOf("debug=true") > -1)))){
                                url = (url + ((url.indexOf("?"))>-1) ? "&debug=true" : "?debug=true");
                            };
                            if (!(((((url.indexOf(":") > -1)) || ((url.indexOf("/") == 0)))) || ((url.indexOf("\\") == 0)))){
                                if (((!((SystemManagerGlobals.bootstrapLoaderInfoURL == null))) && (!((SystemManagerGlobals.bootstrapLoaderInfoURL == ""))))){
                                    rootURL = SystemManagerGlobals.bootstrapLoaderInfoURL;
                                } else {
                                    if (root){
                                        rootURL = LoaderUtil.normalizeURL(root.loaderInfo);
                                    } else {
                                        if (systemManager){
                                            rootURL = LoaderUtil.normalizeURL(DisplayObject(systemManager).loaderInfo);
                                        };
                                    };
                                };
                                if (rootURL){
                                    lastIndex = Math.max(rootURL.lastIndexOf("\\"), rootURL.lastIndexOf("/"));
                                    if (lastIndex != -1){
                                        url = (rootURL.substr(0, (lastIndex + 1)) + url);
                                    };
                                };
                            };
                            requestedURL = new URLRequest(url);
                            lc = loaderContext;
                            if (!lc){
                                lc = new LoaderContext();
                                _loaderContext = lc;
                                if (loadForCompatibility){
                                    currentDomain = ApplicationDomain.currentDomain.parentDomain;
                                    topmostDomain = null;
                                    while (currentDomain) {
                                        topmostDomain = currentDomain;
                                        currentDomain = currentDomain.parentDomain;
                                    };
                                    lc.applicationDomain = new ApplicationDomain(topmostDomain);
                                };
                                if (trustContent){
                                    lc.securityDomain = SecurityDomain.currentDomain;
                                } else {
                                    if (!loadForCompatibility){
                                        attemptingChildAppDomain = true;
                                        lc.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                                    };
                                };
                            };
                            loader.load(requestedURL, lc);
                        } else {
                            message = resourceManager.getString("controls", "notLoadable", [source]);
                            throw (new Error(message));
                        };
                    };
                };
            };
            invalidateDisplayList();
            return (child);
        }
        public function get contentWidth():Number{
            return (((contentHolder) ? contentHolder.width : NaN));
        }
        public function get scaleContent():Boolean{
            return (_scaleContent);
        }
        public function get childAllowsParent():Boolean{
            if (!isContentLoaded){
                return (false);
            };
            if ((contentHolder is Loader)){
                return (Loader(contentHolder).contentLoaderInfo.childAllowsParent);
            };
            return (true);
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (contentChanged){
                contentChanged = false;
                if (_autoLoad){
                    load(_source);
                };
            };
        }
        private function contentLoaderInfo_securityErrorEventHandler(_arg1:SecurityErrorEvent):void{
            var _local2:LoaderContext;
            if (attemptingChildAppDomain){
                attemptingChildAppDomain = false;
                _local2 = new LoaderContext();
                _loaderContext = _local2;
                callLater(load);
                return;
            };
            dispatchEvent(_arg1);
            if ((contentHolder is Loader)){
                removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            };
        }
        private function sizeShield():void{
            if (((mouseShield) && (mouseShield.parent))){
                mouseShield.width = unscaledWidth;
                mouseShield.height = unscaledHeight;
            };
        }
        private function addInitSystemManagerCompleteListener(_arg1:LoaderInfo):void{
            var _local2:EventDispatcher;
            if (_arg1.contentType == "application/x-shockwave-flash"){
                _local2 = _arg1.sharedEvents;
                _local2.addEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION, initSystemManagerCompleteEventHandler);
            };
        }
        private function invalidateRequestHandler(_arg1:Event):void{
            if ((_arg1 is SWFBridgeRequest)){
                return;
            };
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            var _local3:uint = uint(_local2.data);
            if ((_local3 & InvalidateRequestData.PROPERTIES)){
                invalidateProperties();
            };
            if ((_local3 & InvalidateRequestData.SIZE)){
                invalidateSize();
            };
            if ((_local3 & InvalidateRequestData.DISPLAY_LIST)){
                invalidateDisplayList();
            };
            dispatchInvalidateRequest(!(((_local3 & InvalidateRequestData.PROPERTIES) == 0)), !(((_local3 & InvalidateRequestData.SIZE) == 0)), !(((_local3 & InvalidateRequestData.DISPLAY_LIST) == 0)));
        }
        private function contentLoaded():void{
            var loaderInfo:* = null;
            isContentLoaded = true;
            if ((contentHolder is Loader)){
                loaderInfo = Loader(contentHolder).contentLoaderInfo;
            };
            resizableContent = false;
            if (loaderInfo){
                if (loaderInfo.contentType == "application/x-shockwave-flash"){
                    resizableContent = true;
                };
                if (resizableContent){
                    try {
                        if ((Loader(contentHolder).content is IFlexDisplayObject)){
                            flexContent = true;
                        } else {
                            flexContent = !((swfBridge == null));
                        };
                    } catch(e:Error) {
                        flexContent = !((swfBridge == null));
                    };
                };
            };
            try {
                if (((((tabChildren) && ((contentHolder is Loader)))) && ((((loaderInfo.contentType == "application/x-shockwave-flash")) || ((Loader(contentHolder).content is DisplayObjectContainer)))))){
                    Loader(contentHolder).tabChildren = true;
                    DisplayObjectContainer(Loader(contentHolder).content).tabChildren = true;
                };
            } catch(e:Error) {
            };
            invalidateSize();
            invalidateDisplayList();
        }
        private function getContentSize():Point{
            var _local3:IEventDispatcher;
            var _local4:SWFBridgeRequest;
            var _local1:Point = new Point();
            if ((!(contentHolder) is Loader)){
                return (_local1);
            };
            var _local2:Loader = Loader(contentHolder);
            if (_local2.contentLoaderInfo.childAllowsParent){
                _local1.x = _local2.content.width;
                _local1.y = _local2.content.height;
            } else {
                _local3 = swfBridge;
                if (_local3){
                    _local4 = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                    _local3.dispatchEvent(_local4);
                    _local1.x = _local4.data.width;
                    _local1.y = _local4.data.height;
                };
            };
            if (_local1.x == 0){
                _local1.x = _local2.contentLoaderInfo.width;
            };
            if (_local1.y == 0){
                _local1.y = _local2.contentLoaderInfo.height;
            };
            return (_local1);
        }
        public function load(_arg1:Object=null):void{
            var imageData:* = null;
            var request:* = null;
            var url = _arg1;
            if (url){
                _source = url;
            };
            if (contentHolder){
                if (isContentLoaded){
                    if ((contentHolder is Loader)){
                        try {
                            if ((Loader(contentHolder).content is Bitmap)){
                                imageData = Bitmap(Loader(contentHolder).content);
                                if (imageData.bitmapData){
                                    imageData.bitmapData = null;
                                };
                            };
                        } catch(error:Error) {
                        };
                        if (_swfBridge){
                            request = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING, false, false, _swfBridge);
                            _swfBridge.dispatchEvent(request);
                        };
                        if (((useUnloadAndStop) && (("unloadAndStop" in contentHolder)))){
                            var _local3 = contentHolder;
                            _local3["unloadAndStop"](unloadAndStopGC);
                        } else {
                            Loader(contentHolder).unload();
                        };
                        if (!explicitLoaderContext){
                            _loaderContext = null;
                        };
                    } else {
                        if ((contentHolder is Bitmap)){
                            imageData = Bitmap(contentHolder);
                            if (imageData.bitmapData){
                                imageData.bitmapData = null;
                            };
                        };
                    };
                } else {
                    if ((contentHolder is Loader)){
                        try {
                            Loader(contentHolder).close();
                        } catch(error:Error) {
                        };
                    };
                };
                try {
                    if (contentHolder.parent == this){
                        removeChild(contentHolder);
                    };
                } catch(error:Error) {
                    try {
                        removeChild(contentHolder);
                    } catch(error1:Error) {
                    };
                };
                contentHolder = null;
            };
            isContentLoaded = false;
            brokenImage = false;
            useUnloadAndStop = false;
            if (((!(_source)) || ((_source == "")))){
                return;
            };
            contentHolder = loadContent(_source);
        }
        public function get parentAllowsChild():Boolean{
            if (!isContentLoaded){
                return (false);
            };
            if ((contentHolder is Loader)){
                return (Loader(contentHolder).contentLoaderInfo.parentAllowsChild);
            };
            return (true);
        }
        private function contentLoaderInfo_ioErrorEventHandler(_arg1:IOErrorEvent):void{
            source = getStyle("brokenImageSkin");
            load();
            contentChanged = false;
            brokenImage = true;
            if (hasEventListener(_arg1.type)){
                dispatchEvent(_arg1);
            };
            if ((contentHolder is Loader)){
                removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:Class;
            super.updateDisplayList(_arg1, _arg2);
            if (contentChanged){
                contentChanged = false;
                if (_autoLoad){
                    load(_source);
                };
            };
            if (isContentLoaded){
                if (((_scaleContent) && (!(brokenImage)))){
                    doScaleContent();
                } else {
                    doScaleLoader();
                };
                scaleContentChanged = false;
            };
            if (((brokenImage) && (!(brokenImageBorder)))){
                _local3 = getStyle("brokenImageBorderSkin");
                if (_local3){
                    brokenImageBorder = IFlexDisplayObject(new (_local3)());
                    if ((brokenImageBorder is ISimpleStyleClient)){
                        ISimpleStyleClient(brokenImageBorder).styleName = this;
                    };
                    addChild(DisplayObject(brokenImageBorder));
                };
            } else {
                if (((!(brokenImage)) && (brokenImageBorder))){
                    removeChild(DisplayObject(brokenImageBorder));
                    brokenImageBorder = null;
                };
            };
            if (brokenImageBorder){
                brokenImageBorder.setActualSize(_arg1, _arg2);
            };
            sizeShield();
        }
        private function doScaleContent():void{
            var interiorWidth:* = NaN;
            var interiorHeight:* = NaN;
            var contentWidth:* = NaN;
            var contentHeight:* = NaN;
            var x:* = NaN;
            var y:* = NaN;
            var newXScale:* = NaN;
            var newYScale:* = NaN;
            var scale:* = NaN;
            var w:* = NaN;
            var h:* = NaN;
            var holder:* = null;
            var sizeSet:* = false;
            var lInfo:* = null;
            if (!isContentLoaded){
                return;
            };
            if (((!(resizableContent)) || (((maintainAspectRatio) && (!(flexContent)))))){
                unScaleContent();
                interiorWidth = unscaledWidth;
                interiorHeight = unscaledHeight;
                contentWidth = contentHolderWidth;
                contentHeight = contentHolderHeight;
                x = 0;
                y = 0;
                newXScale = (((contentWidth == 0)) ? 1 : (interiorWidth / contentWidth));
                newYScale = (((contentHeight == 0)) ? 1 : (interiorHeight / contentHeight));
                if (_maintainAspectRatio){
                    if (newXScale > newYScale){
                        x = Math.floor(((interiorWidth - (contentWidth * newYScale)) * getHorizontalAlignValue()));
                        scale = newYScale;
                    } else {
                        y = Math.floor(((interiorHeight - (contentHeight * newXScale)) * getVerticalAlignValue()));
                        scale = newXScale;
                    };
                    contentHolder.scaleX = scale;
                    contentHolder.scaleY = scale;
                } else {
                    contentHolder.scaleX = newXScale;
                    contentHolder.scaleY = newYScale;
                };
                contentHolder.x = x;
                contentHolder.y = y;
            } else {
                contentHolder.x = 0;
                contentHolder.y = 0;
                w = unscaledWidth;
                h = unscaledHeight;
                if ((contentHolder is Loader)){
                    holder = Loader(contentHolder);
                    try {
                        if (getContentSize().x > 0){
                            sizeSet = false;
                            if (holder.contentLoaderInfo.contentType == "application/x-shockwave-flash"){
                                if (childAllowsParent){
                                    if ((holder.content is IFlexDisplayObject)){
                                        IFlexDisplayObject(holder.content).setActualSize(w, h);
                                        sizeSet = true;
                                    };
                                };
                                if (!sizeSet){
                                    if (swfBridge){
                                        swfBridge.dispatchEvent(new SWFBridgeRequest(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST, false, false, null, {
                                            width:w,
                                            height:h
                                        }));
                                        sizeSet = true;
                                    };
                                };
                            } else {
                                lInfo = holder.contentLoaderInfo;
                                if (lInfo){
                                    contentHolder.scaleX = (w / lInfo.width);
                                    contentHolder.scaleY = (h / lInfo.height);
                                    sizeSet = true;
                                };
                            };
                            if (!sizeSet){
                                contentHolder.width = w;
                                contentHolder.height = h;
                            };
                        } else {
                            if (((childAllowsParent) && (!((holder.content is IFlexDisplayObject))))){
                                contentHolder.width = w;
                                contentHolder.height = h;
                            };
                        };
                    } catch(error:Error) {
                        contentHolder.width = w;
                        contentHolder.height = h;
                    };
                    if (!parentAllowsChild){
                        contentHolder.scrollRect = new Rectangle(0, 0, (w / contentHolder.scaleX), (h / contentHolder.scaleY));
                    };
                } else {
                    contentHolder.width = w;
                    contentHolder.height = h;
                };
            };
        }
        private function mouseShieldHandler(_arg1:Event):void{
            if (_arg1["name"] != "mouseShield"){
                return;
            };
            if (parentAllowsChild){
                return;
            };
            if (_arg1["value"]){
                if (!mouseShield){
                    mouseShield = new Sprite();
                    mouseShield.graphics.beginFill(0, 0);
                    mouseShield.graphics.drawRect(0, 0, 100, 100);
                    mouseShield.graphics.endFill();
                };
                if (!mouseShield.parent){
                    addChild(mouseShield);
                };
                sizeShield();
            } else {
                if (((mouseShield) && (mouseShield.parent))){
                    removeChild(mouseShield);
                };
            };
        }

    }
}//package mx.controls 
