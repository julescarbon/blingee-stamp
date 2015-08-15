package mx.core {
    import flash.display.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.net.*;
    import mx.containers.utilityClasses.*;
    import flash.ui.*;
    import flash.external.*;

    public class Application extends LayoutContainer {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var useProgressiveLayout:Boolean = false;

        public var preloader:Object;
        public var pageTitle:String;
        private var resizeWidth:Boolean = true;
        private var _applicationViewMetrics:EdgeMetrics;
        mx_internal var _parameters:Object;
        private var processingCreationQueue:Boolean = false;
        public var scriptRecursionLimit:int;
        private var resizeHandlerAdded:Boolean = false;
        private var preloadObj:Object;
        public var usePreloader:Boolean;
        mx_internal var _url:String;
        private var _viewSourceURL:String;
        public var resetHistory:Boolean = true;
        public var historyManagementEnabled:Boolean = true;
        public var scriptTimeLimit:Number;
        public var frameRate:Number;
        private var creationQueue:Array;
        private var resizeHeight:Boolean = true;
        public var controlBar:IUIComponent;
        private var viewSourceCMI:ContextMenuItem;

        public function Application(){
            creationQueue = [];
            name = "application";
            UIComponentGlobals.layoutManager = ILayoutManager(Singleton.getInstance("mx.managers::ILayoutManager"));
            UIComponentGlobals.layoutManager.usePhasedInstantiation = true;
            if (!ApplicationGlobals.application){
                ApplicationGlobals.application = this;
            };
            super();
            layoutObject = new ApplicationLayout();
            layoutObject.target = this;
            boxLayoutClass = ApplicationLayout;
            showInAutomationHierarchy = true;
        }
        public static function get application():Object{
            return (ApplicationGlobals.application);
        }

        public function set viewSourceURL(_arg1:String):void{
            _viewSourceURL = _arg1;
        }
        override public function set percentWidth(_arg1:Number):void{
            super.percentWidth = _arg1;
            invalidateDisplayList();
        }
        override public function prepareToPrint(_arg1:IFlexDisplayObject):Object{
            var _local2:Object = {};
            if (_arg1 == this){
                _local2.width = width;
                _local2.height = height;
                _local2.verticalScrollPosition = verticalScrollPosition;
                _local2.horizontalScrollPosition = horizontalScrollPosition;
                _local2.horizontalScrollBarVisible = !((horizontalScrollBar == null));
                _local2.verticalScrollBarVisible = !((verticalScrollBar == null));
                _local2.whiteBoxVisible = !((whiteBox == null));
                setActualSize(measuredWidth, measuredHeight);
                horizontalScrollPosition = 0;
                verticalScrollPosition = 0;
                if (horizontalScrollBar){
                    horizontalScrollBar.visible = false;
                };
                if (verticalScrollBar){
                    verticalScrollBar.visible = false;
                };
                if (whiteBox){
                    whiteBox.visible = false;
                };
                updateDisplayList(unscaledWidth, unscaledHeight);
            };
            _local2.scrollRect = super.prepareToPrint(_arg1);
            return (_local2);
        }
        override protected function measure():void{
            var _local2:Number;
            super.measure();
            var _local1:EdgeMetrics = borderMetrics;
            if (((controlBar) && (controlBar.includeInLayout))){
                _local2 = ((controlBar.getExplicitOrMeasuredWidth() + _local1.left) + _local1.right);
                measuredWidth = Math.max(measuredWidth, _local2);
                measuredMinWidth = Math.max(measuredMinWidth, _local2);
            };
        }
        override public function getChildIndex(_arg1:DisplayObject):int{
            if (((controlBar) && ((_arg1 == controlBar)))){
                return (-1);
            };
            return (super.getChildIndex(_arg1));
        }
        private function resizeHandler(_arg1:Event):void{
            var _local2:Number;
            var _local3:Number;
            if (resizeWidth){
                if (isNaN(percentWidth)){
                    _local2 = DisplayObject(systemManager).width;
                } else {
                    super.percentWidth = Math.max(percentWidth, 0);
                    super.percentWidth = Math.min(percentWidth, 100);
                    _local2 = ((percentWidth * screen.width) / 100);
                };
                if (!isNaN(explicitMaxWidth)){
                    _local2 = Math.min(_local2, explicitMaxWidth);
                };
                if (!isNaN(explicitMinWidth)){
                    _local2 = Math.max(_local2, explicitMinWidth);
                };
            } else {
                _local2 = width;
            };
            if (resizeHeight){
                if (isNaN(percentHeight)){
                    _local3 = DisplayObject(systemManager).height;
                } else {
                    super.percentHeight = Math.max(percentHeight, 0);
                    super.percentHeight = Math.min(percentHeight, 100);
                    _local3 = ((percentHeight * screen.height) / 100);
                };
                if (!isNaN(explicitMaxHeight)){
                    _local3 = Math.min(_local3, explicitMaxHeight);
                };
                if (!isNaN(explicitMinHeight)){
                    _local3 = Math.max(_local3, explicitMinHeight);
                };
            } else {
                _local3 = height;
            };
            if (((!((_local2 == width))) || (!((_local3 == height))))){
                invalidateProperties();
                invalidateSize();
            };
            setActualSize(_local2, _local3);
            invalidateDisplayList();
        }
        private function initManagers(_arg1:ISystemManager):void{
            if (_arg1.isTopLevel()){
                focusManager = new FocusManager(this);
                _arg1.activate(this);
            };
        }
        override public function initialize():void{
            var _local2:Object;
            var _local1:ISystemManager = systemManager;
            _url = _local1.loaderInfo.url;
            _parameters = _local1.loaderInfo.parameters;
            initManagers(_local1);
            _descriptor = null;
            if (documentDescriptor){
                creationPolicy = documentDescriptor.properties.creationPolicy;
                if ((((creationPolicy == null)) || ((creationPolicy.length == 0)))){
                    creationPolicy = ContainerCreationPolicy.AUTO;
                };
                _local2 = documentDescriptor.properties;
                if (_local2.width != null){
                    width = _local2.width;
                    delete _local2.width;
                };
                if (_local2.height != null){
                    height = _local2.height;
                    delete _local2.height;
                };
                documentDescriptor.events = null;
            };
            initContextMenu();
            super.initialize();
            addEventListener(Event.ADDED, addedHandler);
            if (((_local1.isTopLevelRoot()) && ((Capabilities.isDebugger == true)))){
                setInterval(debugTickler, 1500);
            };
        }
        override public function set percentHeight(_arg1:Number):void{
            super.percentHeight = _arg1;
            invalidateDisplayList();
        }
        override public function get id():String{
            if (((((!(super.id)) && ((this == Application.application)))) && (ExternalInterface.available))){
                return (ExternalInterface.objectID);
            };
            return (super.id);
        }
        override mx_internal function setUnscaledWidth(_arg1:Number):void{
            invalidateProperties();
            super.setUnscaledWidth(_arg1);
        }
        private function debugTickler():void{
            var _local1:int;
        }
        private function doNextQueueItem(_arg1:FlexEvent=null):void{
            processingCreationQueue = true;
            Application.useProgressiveLayout = true;
            callLater(processNextQueueItem);
        }
        private function initContextMenu():void{
            var _local2:String;
            if (flexContextMenu != null){
                if ((systemManager is InteractiveObject)){
                    InteractiveObject(systemManager).contextMenu = contextMenu;
                };
                return;
            };
            var _local1:ContextMenu = new ContextMenu();
            _local1.hideBuiltInItems();
            _local1.builtInItems.print = true;
            if (_viewSourceURL){
                _local2 = resourceManager.getString("core", "viewSource");
                viewSourceCMI = new ContextMenuItem(_local2, true);
                viewSourceCMI.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
                _local1.customItems.push(viewSourceCMI);
            };
            contextMenu = _local1;
            if ((systemManager is InteractiveObject)){
                InteractiveObject(systemManager).contextMenu = _local1;
            };
        }
        private function addedHandler(_arg1:Event):void{
            if ((((_arg1.target == this)) && ((creationQueue.length > 0)))){
                doNextQueueItem();
            };
        }
        public function get viewSourceURL():String{
            return (_viewSourceURL);
        }
        override mx_internal function get usePadding():Boolean{
            return (!((layout == ContainerLayout.ABSOLUTE)));
        }
        override mx_internal function setUnscaledHeight(_arg1:Number):void{
            invalidateProperties();
            super.setUnscaledHeight(_arg1);
        }
        mx_internal function dockControlBar(_arg1:IUIComponent, _arg2:Boolean):void{
            var controlBar:* = _arg1;
            var dock:* = _arg2;
            if (dock){
                try {
                    removeChild(DisplayObject(controlBar));
                } catch(e:Error) {
                    return;
                };
                rawChildren.addChildAt(DisplayObject(controlBar), firstChildIndex);
                setControlBar(controlBar);
            } else {
                try {
                    rawChildren.removeChild(DisplayObject(controlBar));
                } catch(e:Error) {
                    return;
                };
                setControlBar(null);
                addChildAt(DisplayObject(controlBar), 0);
            };
        }
        override public function styleChanged(_arg1:String):void{
            super.styleChanged(_arg1);
            if ((((_arg1 == "backgroundColor")) && ((getStyle("backgroundImage") == getStyle("defaultBackgroundImage"))))){
                clearStyle("backgroundImage");
            };
        }
        override protected function layoutChrome(_arg1:Number, _arg2:Number):void{
            super.layoutChrome(_arg1, _arg2);
            if (!doingLayout){
                createBorder();
            };
            var _local3:EdgeMetrics = borderMetrics;
            var _local4:Number = getStyle("borderThickness");
            var _local5:EdgeMetrics = new EdgeMetrics();
            _local5.left = (_local3.left - _local4);
            _local5.top = (_local3.top - _local4);
            _local5.right = (_local3.right - _local4);
            _local5.bottom = (_local3.bottom - _local4);
            if (((controlBar) && (controlBar.includeInLayout))){
                if ((controlBar is IInvalidating)){
                    IInvalidating(controlBar).invalidateDisplayList();
                };
                controlBar.setActualSize((width - (_local5.left + _local5.right)), controlBar.getExplicitOrMeasuredHeight());
                controlBar.move(_local5.left, _local5.top);
            };
        }
        protected function menuItemSelectHandler(_arg1:Event):void{
            navigateToURL(new URLRequest(_viewSourceURL), "_blank");
        }
        private function printCreationQueue():void{
            var _local4:Object;
            var _local1 = "";
            var _local2:Number = creationQueue.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = creationQueue[_local3];
                _local1 = (_local1 + (((((" [" + _local3) + "] ") + _local4.id) + " ") + _local4.index));
                _local3++;
            };
        }
        override protected function resourcesChanged():void{
            super.resourcesChanged();
            if (viewSourceCMI){
                viewSourceCMI.caption = resourceManager.getString("core", "viewSource");
            };
        }
        override protected function commitProperties():void{
            super.commitProperties();
            resizeWidth = isNaN(explicitWidth);
            resizeHeight = isNaN(explicitHeight);
            if (((resizeWidth) || (resizeHeight))){
                resizeHandler(new Event(Event.RESIZE));
                if (!resizeHandlerAdded){
                    systemManager.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
                    resizeHandlerAdded = true;
                };
            } else {
                if (resizeHandlerAdded){
                    systemManager.removeEventListener(Event.RESIZE, resizeHandler);
                    resizeHandlerAdded = false;
                };
            };
        }
        override public function set toolTip(_arg1:String):void{
        }
        public function addToCreationQueue(_arg1:Object, _arg2:int=-1, _arg3:Function=null, _arg4:IFlexDisplayObject=null):void{
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local12:int;
            var _local5:int = creationQueue.length;
            var _local6:Object = {};
            var _local7:Boolean;
            _local6.id = _arg1;
            _local6.parent = _arg4;
            _local6.callbackFunc = _arg3;
            _local6.index = _arg2;
            var _local11:int;
            while (_local11 < _local5) {
                _local9 = creationQueue[_local11].index;
                _local10 = ((creationQueue[_local11].parent) ? creationQueue[_local11].parent.nestLevel : 0);
                if (_local6.index != -1){
                    if ((((_local9 == -1)) || ((_local6.index < _local9)))){
                        _local8 = _local11;
                        _local7 = true;
                        break;
                    };
                } else {
                    _local12 = ((_local6.parent) ? _local6.parent.nestLevel : 0);
                    if ((((_local9 == -1)) && ((_local10 < _local12)))){
                        _local8 = _local11;
                        _local7 = true;
                        break;
                    };
                };
                _local11++;
            };
            if (!_local7){
                creationQueue.push(_local6);
                _local7 = true;
            } else {
                creationQueue.splice(_local8, 0, _local6);
            };
            if (((initialized) && (!(processingCreationQueue)))){
                doNextQueueItem();
            };
        }
        override mx_internal function initThemeColor():Boolean{
            var _local2:Object;
            var _local3:Number;
            var _local4:Number;
            var _local5:CSSStyleDeclaration;
            var _local1:Boolean = super.initThemeColor();
            if (!_local1){
                _local5 = StyleManager.getStyleDeclaration("global");
                if (_local5){
                    _local2 = _local5.getStyle("themeColor");
                    _local3 = _local5.getStyle("rollOverColor");
                    _local4 = _local5.getStyle("selectionColor");
                };
                if (((((_local2) && (isNaN(_local3)))) && (isNaN(_local4)))){
                    setThemeColor(_local2);
                };
                _local1 = true;
            };
            return (_local1);
        }
        override public function finishPrint(_arg1:Object, _arg2:IFlexDisplayObject):void{
            if (_arg2 == this){
                setActualSize(_arg1.width, _arg1.height);
                if (horizontalScrollBar){
                    horizontalScrollBar.visible = _arg1.horizontalScrollBarVisible;
                };
                if (verticalScrollBar){
                    verticalScrollBar.visible = _arg1.verticalScrollBarVisible;
                };
                if (whiteBox){
                    whiteBox.visible = _arg1.whiteBoxVisible;
                };
                horizontalScrollPosition = _arg1.horizontalScrollPosition;
                verticalScrollPosition = _arg1.verticalScrollPosition;
                updateDisplayList(unscaledWidth, unscaledHeight);
            };
            super.finishPrint(_arg1.scrollRect, _arg2);
        }
        private function processNextQueueItem():void{
            var queueItem:* = null;
            var nextChild:* = null;
            if (EffectManager.effectsPlaying.length > 0){
                callLater(processNextQueueItem);
            } else {
                if (creationQueue.length > 0){
                    queueItem = creationQueue.shift();
                    try {
                        nextChild = (((queueItem.id is String)) ? document[queueItem.id] : queueItem.id);
                        if ((nextChild is Container)){
                            Container(nextChild).createComponentsFromDescriptors(true);
                        };
                        if ((((nextChild is Container)) && ((Container(nextChild).creationPolicy == ContainerCreationPolicy.QUEUED)))){
                            doNextQueueItem();
                        } else {
                            nextChild.addEventListener("childrenCreationComplete", doNextQueueItem);
                        };
                    } catch(e:Error) {
                        processNextQueueItem();
                    };
                } else {
                    processingCreationQueue = false;
                    Application.useProgressiveLayout = false;
                };
            };
        }
        override public function set label(_arg1:String):void{
        }
        public function get parameters():Object{
            return (_parameters);
        }
        override public function get viewMetrics():EdgeMetrics{
            if (!_applicationViewMetrics){
                _applicationViewMetrics = new EdgeMetrics();
            };
            var _local1:EdgeMetrics = _applicationViewMetrics;
            var _local2:EdgeMetrics = super.viewMetrics;
            var _local3:Number = getStyle("borderThickness");
            _local1.left = _local2.left;
            _local1.top = _local2.top;
            _local1.right = _local2.right;
            _local1.bottom = _local2.bottom;
            if (((controlBar) && (controlBar.includeInLayout))){
                _local1.top = (_local1.top - _local3);
                _local1.top = (_local1.top + Math.max(controlBar.getExplicitOrMeasuredHeight(), _local3));
            };
            return (_local1);
        }
        public function get url():String{
            return (_url);
        }
        override public function set icon(_arg1:Class):void{
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            createBorder();
        }
        private function setControlBar(_arg1:IUIComponent):void{
            if (_arg1 == controlBar){
                return;
            };
            if (((controlBar) && ((controlBar is IStyleClient)))){
                IStyleClient(controlBar).clearStyle("cornerRadius");
                IStyleClient(controlBar).clearStyle("docked");
            };
            controlBar = _arg1;
            if (((controlBar) && ((controlBar is IStyleClient)))){
                IStyleClient(controlBar).setStyle("cornerRadius", 0);
                IStyleClient(controlBar).setStyle("docked", true);
            };
            invalidateSize();
            invalidateDisplayList();
            invalidateViewMetricsAndPadding();
        }
        override public function set tabIndex(_arg1:int):void{
        }

    }
}//package mx.core 
