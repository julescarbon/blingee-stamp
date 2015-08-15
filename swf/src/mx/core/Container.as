package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.graphics.*;
    import mx.controls.scrollClasses.*;
    import mx.binding.*;
    import mx.controls.listClasses.*;
    import flash.utils.*;
    import flash.ui.*;

    public class Container extends UIComponent implements IContainer, IDataRenderer, IFocusManagerContainer, IListItemRenderer, IRawChildrenContainer {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const MULTIPLE_PROPERTIES:String = "<MULTIPLE>";

        private var forceLayout:Boolean = false;
        private var _numChildrenCreated:int = -1;
        private var _horizontalLineScrollSize:Number = 5;
        mx_internal var border:IFlexDisplayObject;
        protected var actualCreationPolicy:String;
        private var _viewMetricsAndPadding:EdgeMetrics;
        private var _creatingContentPane:Boolean = false;
        private var _childRepeaters:Array;
        private var scrollableWidth:Number = 0;
        private var _childDescriptors:Array;
        private var _rawChildren:ContainerRawChildrenList;
        private var _data:Object;
        private var _verticalPageScrollSize:Number = 0;
        private var _viewMetrics:EdgeMetrics;
        private var _verticalScrollBar:ScrollBar;
        private var scrollPropertiesChanged:Boolean = false;
        private var changedStyles:String = null;
        private var scrollPositionChanged:Boolean = true;
        private var _defaultButton:IFlexDisplayObject;
        private var mouseEventReferenceCount:int = 0;
        private var _focusPane:Sprite;
        protected var whiteBox:Shape;
        private var _forceClippingCount:int;
        private var _horizontalPageScrollSize:Number = 0;
        private var _creationPolicy:String;
        private var _creationIndex:int = -1;
        private var _clipContent:Boolean = true;
        private var _verticalScrollPosition:Number = 0;
        private var _autoLayout:Boolean = true;
        private var _icon:Class = null;
        mx_internal var doingLayout:Boolean = false;
        private var _horizontalScrollBar:ScrollBar;
        private var numChildrenBefore:int;
        private var viewableHeight:Number = 0;
        private var viewableWidth:Number = 0;
        mx_internal var contentPane:Sprite = null;
        private var _createdComponents:Array;
        private var _firstChildIndex:int = 0;
        private var scrollableHeight:Number = 0;
        private var _verticalLineScrollSize:Number = 5;
        private var _horizontalScrollPosition:Number = 0;
        mx_internal var _horizontalScrollPolicy:String = "auto";
        private var verticalScrollPositionPending:Number;
        mx_internal var _verticalScrollPolicy:String = "auto";
        private var horizontalScrollPositionPending:Number;
        mx_internal var _numChildren:int = 0;
        private var recursionFlag:Boolean = true;
        private var _label:String = "";
        mx_internal var blocker:Sprite;

        public function Container(){
            tabChildren = true;
            tabEnabled = false;
            showInAutomationHierarchy = false;
        }
        public function set verticalScrollPolicy(_arg1:String):void{
            if (_verticalScrollPolicy != _arg1){
                _verticalScrollPolicy = _arg1;
                invalidateDisplayList();
                dispatchEvent(new Event("verticalScrollPolicyChanged"));
            };
        }
        private function createContentPaneAndScrollbarsIfNeeded():Boolean{
            var _local1:Rectangle;
            var _local2:Boolean;
            if (_clipContent){
                _local1 = getScrollableRect();
                _local2 = createScrollbarsIfNeeded(_local1);
                if (border){
                    updateBackgroundImageRect();
                };
                return (_local2);
            };
            _local2 = createOrDestroyScrollbars(false, false, false);
            _local1 = getScrollableRect();
            scrollableWidth = _local1.right;
            scrollableHeight = _local1.bottom;
            if (((_local2) && (border))){
                updateBackgroundImageRect();
            };
            return (_local2);
        }
        override protected function initializationComplete():void{
        }
        mx_internal function rawChildren_getObjectsUnderPoint(_arg1:Point):Array{
            return (super.getObjectsUnderPoint(_arg1));
        }
        public function set creatingContentPane(_arg1:Boolean):void{
            _creatingContentPane = _arg1;
        }
        public function set clipContent(_arg1:Boolean):void{
            if (_clipContent != _arg1){
                _clipContent = _arg1;
                invalidateDisplayList();
            };
        }
        protected function scrollChildren():void{
            if (!contentPane){
                return;
            };
            var _local1:EdgeMetrics = viewMetrics;
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:Number = ((unscaledWidth - _local1.left) - _local1.right);
            var _local5:Number = ((unscaledHeight - _local1.top) - _local1.bottom);
            if (_clipContent){
                _local2 = (_local2 + _horizontalScrollPosition);
                if (horizontalScrollBar){
                    _local4 = viewableWidth;
                };
                _local3 = (_local3 + _verticalScrollPosition);
                if (verticalScrollBar){
                    _local5 = viewableHeight;
                };
            } else {
                _local4 = scrollableWidth;
                _local5 = scrollableHeight;
            };
            var _local6:Rectangle = getScrollableRect();
            if ((((((((((((((_local2 == 0)) && ((_local3 == 0)))) && ((_local4 >= _local6.right)))) && ((_local5 >= _local6.bottom)))) && ((_local6.left >= 0)))) && ((_local6.top >= 0)))) && ((_forceClippingCount <= 0)))){
                contentPane.scrollRect = null;
                contentPane.opaqueBackground = null;
                contentPane.cacheAsBitmap = false;
            } else {
                contentPane.scrollRect = new Rectangle(_local2, _local3, _local4, _local5);
            };
            if (focusPane){
                focusPane.scrollRect = contentPane.scrollRect;
            };
            if (((((border) && ((border is IRectangularBorder)))) && (IRectangularBorder(border).hasBackgroundImage))){
                IRectangularBorder(border).layoutBackgroundImage();
            };
        }
        override public function set doubleClickEnabled(_arg1:Boolean):void{
            var _local2:int;
            var _local3:int;
            var _local4:InteractiveObject;
            super.doubleClickEnabled = _arg1;
            if (contentPane){
                _local2 = contentPane.numChildren;
                _local3 = 0;
                while (_local3 < _local2) {
                    _local4 = (contentPane.getChildAt(_local3) as InteractiveObject);
                    if (_local4){
                        _local4.doubleClickEnabled = _arg1;
                    };
                    _local3++;
                };
            };
        }
        override public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            var _local5:ISimpleStyleClient;
            var _local3:int = super.numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                if (((((contentPane) || ((_local4 < _firstChildIndex)))) || ((_local4 >= (_firstChildIndex + _numChildren))))){
                    _local5 = (super.getChildAt(_local4) as ISimpleStyleClient);
                    if (_local5){
                        _local5.styleChanged(_arg1);
                        if ((_local5 is IStyleClient)){
                            IStyleClient(_local5).notifyStyleChangeInChildren(_arg1, _arg2);
                        };
                    };
                };
                _local4++;
            };
            if (_arg2){
                changedStyles = ((((!((changedStyles == null))) || ((_arg1 == null)))) ? MULTIPLE_PROPERTIES : _arg1);
                invalidateProperties();
            };
        }
        mx_internal function get createdComponents():Array{
            return (_createdComponents);
        }
        public function get childDescriptors():Array{
            return (_childDescriptors);
        }
        override public function get contentMouseY():Number{
            if (contentPane){
                return (contentPane.mouseY);
            };
            return (super.contentMouseY);
        }
        mx_internal function get childRepeaters():Array{
            return (_childRepeaters);
        }
        override public function contains(_arg1:DisplayObject):Boolean{
            if (contentPane){
                return (contentPane.contains(_arg1));
            };
            return (super.contains(_arg1));
        }
        override public function get contentMouseX():Number{
            if (contentPane){
                return (contentPane.mouseX);
            };
            return (super.contentMouseX);
        }
        mx_internal function set createdComponents(_arg1:Array):void{
            _createdComponents = _arg1;
        }
        public function get horizontalScrollBar():ScrollBar{
            return (_horizontalScrollBar);
        }
        override public function validateSize(_arg1:Boolean=false):void{
            var _local2:int;
            var _local3:int;
            var _local4:DisplayObject;
            if ((((autoLayout == false)) && ((forceLayout == false)))){
                if (_arg1){
                    _local2 = super.numChildren;
                    _local3 = 0;
                    while (_local3 < _local2) {
                        _local4 = super.getChildAt(_local3);
                        if ((_local4 is ILayoutManagerClient)){
                            ILayoutManagerClient(_local4).validateSize(true);
                        };
                        _local3++;
                    };
                };
                adjustSizesForScaleChanges();
            } else {
                super.validateSize(_arg1);
            };
        }
        public function get rawChildren():IChildList{
            if (!_rawChildren){
                _rawChildren = new ContainerRawChildrenList(this);
            };
            return (_rawChildren);
        }
        override public function getChildAt(_arg1:int):DisplayObject{
            if (contentPane){
                return (contentPane.getChildAt(_arg1));
            };
            return (super.getChildAt((_firstChildIndex + _arg1)));
        }
        override protected function attachOverlay():void{
            rawChildren_addChild(overlay);
        }
        override public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            super.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
            if ((((((((((((((((_arg1 == MouseEvent.CLICK)) || ((_arg1 == MouseEvent.DOUBLE_CLICK)))) || ((_arg1 == MouseEvent.MOUSE_DOWN)))) || ((_arg1 == MouseEvent.MOUSE_MOVE)))) || ((_arg1 == MouseEvent.MOUSE_OVER)))) || ((_arg1 == MouseEvent.MOUSE_OUT)))) || ((_arg1 == MouseEvent.MOUSE_UP)))) || ((_arg1 == MouseEvent.MOUSE_WHEEL)))){
                if ((((mouseEventReferenceCount < 2147483647)) && ((mouseEventReferenceCount++ == 0)))){
                    setStyle("mouseShield", true);
                    setStyle("mouseShieldChildren", true);
                };
            };
        }
        override public function localToContent(_arg1:Point):Point{
            if (!contentPane){
                return (_arg1);
            };
            _arg1 = localToGlobal(_arg1);
            return (globalToContent(_arg1));
        }
        public function executeChildBindings(_arg1:Boolean):void{
            var _local4:IUIComponent;
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = IUIComponent(getChildAt(_local3));
                if ((_local4 is IDeferredInstantiationUIComponent)){
                    IDeferredInstantiationUIComponent(_local4).executeBindings(_arg1);
                };
                _local3++;
            };
        }
        protected function createBorder():void{
            var _local1:Class;
            if (((!(border)) && (isBorderNeeded()))){
                _local1 = getStyle("borderSkin");
                if (_local1 != null){
                    border = new (_local1)();
                    border.name = "border";
                    if ((border is IUIComponent)){
                        IUIComponent(border).enabled = enabled;
                    };
                    if ((border is ISimpleStyleClient)){
                        ISimpleStyleClient(border).styleName = this;
                    };
                    rawChildren.addChildAt(DisplayObject(border), 0);
                    invalidateDisplayList();
                };
            };
        }
        public function get verticalScrollPosition():Number{
            if (!isNaN(verticalScrollPositionPending)){
                return (verticalScrollPositionPending);
            };
            return (_verticalScrollPosition);
        }
        public function get horizontalScrollPosition():Number{
            if (!isNaN(horizontalScrollPositionPending)){
                return (horizontalScrollPositionPending);
            };
            return (_horizontalScrollPosition);
        }
        protected function layoutChrome(_arg1:Number, _arg2:Number):void{
            if (border){
                updateBackgroundImageRect();
                border.move(0, 0);
                border.setActualSize(_arg1, _arg2);
            };
        }
        mx_internal function set childRepeaters(_arg1:Array):void{
            _childRepeaters = _arg1;
        }
        override public function get focusPane():Sprite{
            return (_focusPane);
        }
        public function set creationIndex(_arg1:int):void{
            _creationIndex = _arg1;
        }
        public function get viewMetrics():EdgeMetrics{
            var _local1:EdgeMetrics = borderMetrics;
            var _local2:Boolean = ((!((verticalScrollBar == null))) && (((doingLayout) || ((verticalScrollPolicy == ScrollPolicy.ON)))));
            var _local3:Boolean = ((!((horizontalScrollBar == null))) && (((doingLayout) || ((horizontalScrollPolicy == ScrollPolicy.ON)))));
            if (((!(_local2)) && (!(_local3)))){
                return (_local1);
            };
            if (!_viewMetrics){
                _viewMetrics = _local1.clone();
            } else {
                _viewMetrics.left = _local1.left;
                _viewMetrics.right = _local1.right;
                _viewMetrics.top = _local1.top;
                _viewMetrics.bottom = _local1.bottom;
            };
            if (_local2){
                _viewMetrics.right = (_viewMetrics.right + verticalScrollBar.minWidth);
            };
            if (_local3){
                _viewMetrics.bottom = (_viewMetrics.bottom + horizontalScrollBar.minHeight);
            };
            return (_viewMetrics);
        }
        public function set verticalScrollBar(_arg1:ScrollBar):void{
            _verticalScrollBar = _arg1;
        }
        public function set verticalScrollPosition(_arg1:Number):void{
            if (_verticalScrollPosition == _arg1){
                return;
            };
            _verticalScrollPosition = _arg1;
            scrollPositionChanged = true;
            if (!initialized){
                verticalScrollPositionPending = _arg1;
            };
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
        }
        private function createOrDestroyScrollbars(_arg1:Boolean, _arg2:Boolean, _arg3:Boolean):Boolean{
            var _local5:IFocusManager;
            var _local6:String;
            var _local7:String;
            var _local8:Graphics;
            var _local4:Boolean;
            if (((((_arg1) || (_arg2))) || (_arg3))){
                createContentPane();
            };
            if (_arg1){
                if (!horizontalScrollBar){
                    horizontalScrollBar = new HScrollBar();
                    horizontalScrollBar.name = "horizontalScrollBar";
                    _local6 = getStyle("horizontalScrollBarStyleName");
                    if (((_local6) && ((horizontalScrollBar is ISimpleStyleClient)))){
                        ISimpleStyleClient(horizontalScrollBar).styleName = _local6;
                    };
                    rawChildren.addChild(DisplayObject(horizontalScrollBar));
                    horizontalScrollBar.lineScrollSize = horizontalLineScrollSize;
                    horizontalScrollBar.pageScrollSize = horizontalPageScrollSize;
                    horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, horizontalScrollBar_scrollHandler);
                    horizontalScrollBar.enabled = enabled;
                    if ((horizontalScrollBar is IInvalidating)){
                        IInvalidating(horizontalScrollBar).validateNow();
                    };
                    invalidateDisplayList();
                    invalidateViewMetricsAndPadding();
                    _local4 = true;
                    if (!verticalScrollBar){
                        addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    };
                };
            } else {
                if (horizontalScrollBar){
                    horizontalScrollBar.removeEventListener(ScrollEvent.SCROLL, horizontalScrollBar_scrollHandler);
                    rawChildren.removeChild(DisplayObject(horizontalScrollBar));
                    horizontalScrollBar = null;
                    viewableWidth = (scrollableWidth = 0);
                    if (_horizontalScrollPosition != 0){
                        _horizontalScrollPosition = 0;
                        scrollPositionChanged = true;
                    };
                    invalidateDisplayList();
                    invalidateViewMetricsAndPadding();
                    _local4 = true;
                    _local5 = focusManager;
                    if (((!(verticalScrollBar)) && (((!(_local5)) || (!((_local5.getFocus() == this))))))){
                        removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    };
                };
            };
            if (_arg2){
                if (!verticalScrollBar){
                    verticalScrollBar = new VScrollBar();
                    verticalScrollBar.name = "verticalScrollBar";
                    _local7 = getStyle("verticalScrollBarStyleName");
                    if (((_local7) && ((verticalScrollBar is ISimpleStyleClient)))){
                        ISimpleStyleClient(verticalScrollBar).styleName = _local7;
                    };
                    rawChildren.addChild(DisplayObject(verticalScrollBar));
                    verticalScrollBar.lineScrollSize = verticalLineScrollSize;
                    verticalScrollBar.pageScrollSize = verticalPageScrollSize;
                    verticalScrollBar.addEventListener(ScrollEvent.SCROLL, verticalScrollBar_scrollHandler);
                    verticalScrollBar.enabled = enabled;
                    if ((verticalScrollBar is IInvalidating)){
                        IInvalidating(verticalScrollBar).validateNow();
                    };
                    invalidateDisplayList();
                    invalidateViewMetricsAndPadding();
                    _local4 = true;
                    if (!horizontalScrollBar){
                        addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    };
                    addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
                };
            } else {
                if (verticalScrollBar){
                    verticalScrollBar.removeEventListener(ScrollEvent.SCROLL, verticalScrollBar_scrollHandler);
                    rawChildren.removeChild(DisplayObject(verticalScrollBar));
                    verticalScrollBar = null;
                    viewableHeight = (scrollableHeight = 0);
                    if (_verticalScrollPosition != 0){
                        _verticalScrollPosition = 0;
                        scrollPositionChanged = true;
                    };
                    invalidateDisplayList();
                    invalidateViewMetricsAndPadding();
                    _local4 = true;
                    _local5 = focusManager;
                    if (((!(horizontalScrollBar)) && (((!(_local5)) || (!((_local5.getFocus() == this))))))){
                        removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                    };
                    removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
                };
            };
            if (((horizontalScrollBar) && (verticalScrollBar))){
                if (!whiteBox){
                    whiteBox = new FlexShape();
                    whiteBox.name = "whiteBox";
                    _local8 = whiteBox.graphics;
                    _local8.beginFill(0xFFFFFF);
                    _local8.drawRect(0, 0, verticalScrollBar.minWidth, horizontalScrollBar.minHeight);
                    _local8.endFill();
                    rawChildren.addChild(whiteBox);
                };
            } else {
                if (whiteBox){
                    rawChildren.removeChild(whiteBox);
                    whiteBox = null;
                };
            };
            return (_local4);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local3:String;
            var _local4:Number;
            var _local2:Object = getFocus();
            if ((_local2 is TextField)){
                return;
            };
            if (verticalScrollBar){
                _local3 = ScrollEventDirection.VERTICAL;
                _local4 = verticalScrollPosition;
                switch (_arg1.keyCode){
                    case Keyboard.DOWN:
                        verticalScrollPosition = (verticalScrollPosition + verticalLineScrollSize);
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.LINE_DOWN);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.UP:
                        verticalScrollPosition = (verticalScrollPosition - verticalLineScrollSize);
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.LINE_UP);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.PAGE_UP:
                        verticalScrollPosition = (verticalScrollPosition - verticalPageScrollSize);
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.PAGE_UP);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.PAGE_DOWN:
                        verticalScrollPosition = (verticalScrollPosition + verticalPageScrollSize);
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.PAGE_DOWN);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.HOME:
                        verticalScrollPosition = verticalScrollBar.minScrollPosition;
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.AT_TOP);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.END:
                        verticalScrollPosition = verticalScrollBar.maxScrollPosition;
                        dispatchScrollEvent(_local3, _local4, verticalScrollPosition, ScrollEventDetail.AT_BOTTOM);
                        _arg1.stopPropagation();
                        break;
                };
            };
            if (horizontalScrollBar){
                _local3 = ScrollEventDirection.HORIZONTAL;
                _local4 = horizontalScrollPosition;
                switch (_arg1.keyCode){
                    case Keyboard.LEFT:
                        horizontalScrollPosition = (horizontalScrollPosition - horizontalLineScrollSize);
                        dispatchScrollEvent(_local3, _local4, horizontalScrollPosition, ScrollEventDetail.LINE_LEFT);
                        _arg1.stopPropagation();
                        break;
                    case Keyboard.RIGHT:
                        horizontalScrollPosition = (horizontalScrollPosition + horizontalLineScrollSize);
                        dispatchScrollEvent(_local3, _local4, horizontalScrollPosition, ScrollEventDetail.LINE_RIGHT);
                        _arg1.stopPropagation();
                        break;
                };
            };
        }
        public function get icon():Class{
            return (_icon);
        }
        private function createOrDestroyBlocker():void{
            var _local1:DisplayObject;
            var _local2:ISystemManager;
            if (enabled){
                if (blocker){
                    rawChildren.removeChild(blocker);
                    blocker = null;
                };
            } else {
                if (!blocker){
                    blocker = new FlexSprite();
                    blocker.name = "blocker";
                    blocker.mouseEnabled = true;
                    rawChildren.addChild(blocker);
                    blocker.addEventListener(MouseEvent.CLICK, blocker_clickHandler);
                    _local1 = ((focusManager) ? DisplayObject(focusManager.getFocus()) : null);
                    while (_local1) {
                        if (_local1 == this){
                            _local2 = systemManager;
                            if (((_local2) && (_local2.stage))){
                                _local2.stage.focus = null;
                            };
                            break;
                        };
                        _local1 = _local1.parent;
                    };
                };
            };
        }
        private function horizontalScrollBar_scrollHandler(_arg1:Event):void{
            var _local2:Number;
            if ((_arg1 is ScrollEvent)){
                _local2 = horizontalScrollPosition;
                horizontalScrollPosition = horizontalScrollBar.scrollPosition;
                dispatchScrollEvent(ScrollEventDirection.HORIZONTAL, _local2, horizontalScrollPosition, ScrollEvent(_arg1).detail);
            };
        }
        public function createComponentFromDescriptor(_arg1:ComponentDescriptor, _arg2:Boolean):IFlexDisplayObject{
            var _local7:String;
            var _local10:IRepeaterClient;
            var _local11:IStyleClient;
            var _local12:String;
            var _local13:String;
            var _local3:UIComponentDescriptor = UIComponentDescriptor(_arg1);
            var _local4:Object = _local3.properties;
            if (((((((!((numChildrenBefore == 0))) || (!((numChildrenCreated == -1))))) && ((_local3.instanceIndices == null)))) && (hasChildMatchingDescriptor(_local3)))){
                return (null);
            };
            UIComponentGlobals.layoutManager.usePhasedInstantiation = true;
            var _local5:Class = _local3.type;
            var _local6:IDeferredInstantiationUIComponent = new (_local5)();
            _local6.id = _local3.id;
            if (((_local6.id) && (!((_local6.id == ""))))){
                _local6.name = _local6.id;
            };
            _local6.descriptor = _local3;
            if (((_local4.childDescriptors) && ((_local6 is Container)))){
                Container(_local6)._childDescriptors = _local4.childDescriptors;
                delete _local4.childDescriptors;
            };
            for (_local7 in _local4) {
                _local6[_local7] = _local4[_local7];
            };
            if ((_local6 is Container)){
                Container(_local6).recursionFlag = _arg2;
            };
            if (_local3.instanceIndices){
                if ((_local6 is IRepeaterClient)){
                    _local10 = IRepeaterClient(_local6);
                    _local10.instanceIndices = _local3.instanceIndices;
                    _local10.repeaters = _local3.repeaters;
                    _local10.repeaterIndices = _local3.repeaterIndices;
                };
            };
            if ((_local6 is IStyleClient)){
                _local11 = IStyleClient(_local6);
                if (_local3.stylesFactory != null){
                    if (!_local11.styleDeclaration){
                        _local11.styleDeclaration = new CSSStyleDeclaration();
                    };
                    _local11.styleDeclaration.factory = _local3.stylesFactory;
                };
            };
            var _local8:Object = _local3.events;
            if (_local8){
                for (_local12 in _local8) {
                    _local13 = _local8[_local12];
                    _local6.addEventListener(_local12, _local3.document[_local13]);
                };
            };
            var _local9:Array = _local3.effects;
            if (_local9){
                _local6.registerEffects(_local9);
            };
            if ((_local6 is IRepeaterClient)){
                IRepeaterClient(_local6).initializeRepeaterArrays(this);
            };
            _local6.createReferenceOnParentDocument(IFlexDisplayObject(_local3.document));
            if (!_local6.document){
                _local6.document = _local3.document;
            };
            if ((_local6 is IRepeater)){
                if (!childRepeaters){
                    childRepeaters = [];
                };
                childRepeaters.push(_local6);
                _local6.executeBindings();
                IRepeater(_local6).initializeRepeater(this, _arg2);
            } else {
                addChild(DisplayObject(_local6));
                _local6.executeBindings();
                if ((((creationPolicy == ContainerCreationPolicy.QUEUED)) || ((creationPolicy == ContainerCreationPolicy.NONE)))){
                    _local6.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
                };
            };
            return (_local6);
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            if (horizontalScrollBar){
                horizontalScrollBar.enabled = _arg1;
            };
            if (verticalScrollBar){
                verticalScrollBar.enabled = _arg1;
            };
            invalidateProperties();
        }
        public function set horizontalScrollBar(_arg1:ScrollBar):void{
            _horizontalScrollBar = _arg1;
        }
        mx_internal function get usePadding():Boolean{
            return (true);
        }
        override public function get baselinePosition():Number{
            var _local2:IUIComponent;
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                if ((((getStyle("verticalAlign") == "top")) && ((numChildren > 0)))){
                    _local2 = (getChildAt(0) as IUIComponent);
                    if (_local2){
                        return ((_local2.y + _local2.baselinePosition));
                    };
                };
                return (super.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            var _local1:TextLineMetrics = measureText("Wj");
            if (height < (((2 * viewMetrics.top) + 4) + _local1.ascent)){
                return (int((height + ((_local1.ascent - height) / 2))));
            };
            return (((viewMetrics.top + 2) + _local1.ascent));
        }
        override public function getChildByName(_arg1:String):DisplayObject{
            var _local2:DisplayObject;
            var _local3:int;
            if (contentPane){
                return (contentPane.getChildByName(_arg1));
            };
            _local2 = super.getChildByName(_arg1);
            if (!_local2){
                return (null);
            };
            _local3 = (super.getChildIndex(_local2) - _firstChildIndex);
            if ((((_local3 < 0)) || ((_local3 >= _numChildren)))){
                return (null);
            };
            return (_local2);
        }
        public function get verticalLineScrollSize():Number{
            return (_verticalLineScrollSize);
        }
        public function get horizontalScrollPolicy():String{
            return (_horizontalScrollPolicy);
        }
        override public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            var _local3:DisplayObjectContainer = _arg1.parent;
            if (((_local3) && (!((_local3 is Loader))))){
                if (_local3 == this){
                    _arg2 = ((_arg2)==numChildren) ? (_arg2 - 1) : _arg2;
                };
                _local3.removeChild(_arg1);
            };
            addingChild(_arg1);
            if (contentPane){
                contentPane.addChildAt(_arg1, _arg2);
            } else {
                $addChildAt(_arg1, (_firstChildIndex + _arg2));
            };
            childAdded(_arg1);
            if ((((_arg1 is UIComponent)) && (UIComponent(_arg1).isDocument))){
                BindingManager.setEnabled(_arg1, true);
            };
            return (_arg1);
        }
        public function get maxVerticalScrollPosition():Number{
            return (((verticalScrollBar) ? verticalScrollBar.maxScrollPosition : Math.max((scrollableHeight - viewableHeight), 0)));
        }
        public function set horizontalScrollPosition(_arg1:Number):void{
            if (_horizontalScrollPosition == _arg1){
                return;
            };
            _horizontalScrollPosition = _arg1;
            scrollPositionChanged = true;
            if (!initialized){
                horizontalScrollPositionPending = _arg1;
            };
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
        }
        mx_internal function invalidateViewMetricsAndPadding():void{
            _viewMetricsAndPadding = null;
        }
        public function get horizontalLineScrollSize():Number{
            return (_horizontalLineScrollSize);
        }
        override public function set focusPane(_arg1:Sprite):void{
            var _local2:Boolean = invalidateSizeFlag;
            var _local3:Boolean = invalidateDisplayListFlag;
            invalidateSizeFlag = true;
            invalidateDisplayListFlag = true;
            if (_arg1){
                rawChildren.addChild(_arg1);
                _arg1.x = 0;
                _arg1.y = 0;
                _arg1.scrollRect = null;
                _focusPane = _arg1;
            } else {
                rawChildren.removeChild(_focusPane);
                _focusPane = null;
            };
            if (((_arg1) && (contentPane))){
                _arg1.x = contentPane.x;
                _arg1.y = contentPane.y;
                _arg1.scrollRect = contentPane.scrollRect;
            };
            invalidateSizeFlag = _local2;
            invalidateDisplayListFlag = _local3;
        }
        private function updateBackgroundImageRect():void{
            var _local1:IRectangularBorder = (border as IRectangularBorder);
            if (!_local1){
                return;
            };
            if ((((viewableWidth == 0)) && ((viewableHeight == 0)))){
                _local1.backgroundImageBounds = null;
                return;
            };
            var _local2:EdgeMetrics = viewMetrics;
            var _local3:Number = ((viewableWidth) ? viewableWidth : ((unscaledWidth - _local2.left) - _local2.right));
            var _local4:Number = ((viewableHeight) ? viewableHeight : ((unscaledHeight - _local2.top) - _local2.bottom));
            if (getStyle("backgroundAttachment") == "fixed"){
                _local1.backgroundImageBounds = new Rectangle(_local2.left, _local2.top, _local3, _local4);
            } else {
                _local1.backgroundImageBounds = new Rectangle(_local2.left, _local2.top, Math.max(scrollableWidth, _local3), Math.max(scrollableHeight, _local4));
            };
        }
        private function blocker_clickHandler(_arg1:Event):void{
            _arg1.stopPropagation();
        }
        private function mouseWheelHandler(_arg1:MouseEvent):void{
            var _local2:int;
            var _local3:int;
            var _local4:Number;
            var _local5:Number;
            if (verticalScrollBar){
                _arg1.stopPropagation();
                _local2 = (((_arg1.delta <= 0)) ? 1 : -1);
                _local3 = ((verticalScrollBar) ? verticalScrollBar.lineScrollSize : 1);
                _local4 = Math.max(Math.abs(_arg1.delta), _local3);
                _local5 = verticalScrollPosition;
                verticalScrollPosition = (verticalScrollPosition + ((3 * _local4) * _local2));
                dispatchScrollEvent(ScrollEventDirection.VERTICAL, _local5, verticalScrollPosition, (((_arg1.delta <= 0)) ? ScrollEventDetail.LINE_UP : ScrollEventDetail.LINE_DOWN));
            };
        }
        public function get defaultButton():IFlexDisplayObject{
            return (_defaultButton);
        }
        mx_internal function createContentPane():void{
            var _local3:int;
            var _local5:IUIComponent;
            if (contentPane){
                return;
            };
            creatingContentPane = true;
            var _local1:int = numChildren;
            var _local2:Sprite = new FlexSprite();
            _local2.name = "contentPane";
            _local2.tabChildren = true;
            if (border){
                _local3 = (rawChildren.getChildIndex(DisplayObject(border)) + 1);
                if ((((border is IRectangularBorder)) && (IRectangularBorder(border).hasBackgroundImage))){
                    _local3++;
                };
            } else {
                _local3 = 0;
            };
            rawChildren.addChildAt(_local2, _local3);
            var _local4:int;
            while (_local4 < _local1) {
                _local5 = IUIComponent(super.getChildAt(_firstChildIndex));
                _local2.addChild(DisplayObject(_local5));
                _local5.parentChanged(_local2);
                _numChildren--;
                _local4++;
            };
            contentPane = _local2;
            creatingContentPane = false;
            contentPane.visible = true;
        }
        public function set verticalPageScrollSize(_arg1:Number):void{
            scrollPropertiesChanged = true;
            _verticalPageScrollSize = _arg1;
            invalidateDisplayList();
            dispatchEvent(new Event("verticalPageScrollSizeChanged"));
        }
        mx_internal function setDocumentDescriptor(_arg1:UIComponentDescriptor):void{
            var _local2:String;
            if (processedDescriptors){
                return;
            };
            if (((_documentDescriptor) && (_documentDescriptor.properties.childDescriptors))){
                if (_arg1.properties.childDescriptors){
                    _local2 = resourceManager.getString("core", "multipleChildSets_ClassAndSubclass");
                    throw (new Error(_local2));
                };
            } else {
                _documentDescriptor = _arg1;
                _documentDescriptor.document = this;
            };
        }
        private function verticalScrollBar_scrollHandler(_arg1:Event):void{
            var _local2:Number;
            if ((_arg1 is ScrollEvent)){
                _local2 = verticalScrollPosition;
                verticalScrollPosition = verticalScrollBar.scrollPosition;
                dispatchScrollEvent(ScrollEventDirection.VERTICAL, _local2, verticalScrollPosition, ScrollEvent(_arg1).detail);
            };
        }
        public function get creationPolicy():String{
            return (_creationPolicy);
        }
        public function set icon(_arg1:Class):void{
            _icon = _arg1;
            dispatchEvent(new Event("iconChanged"));
        }
        private function dispatchScrollEvent(_arg1:String, _arg2:Number, _arg3:Number, _arg4:String):void{
            var _local5:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
            _local5.direction = _arg1;
            _local5.position = _arg3;
            _local5.delta = (_arg3 - _arg2);
            _local5.detail = _arg4;
            dispatchEvent(_local5);
        }
        public function get label():String{
            return (_label);
        }
        public function get verticalScrollPolicy():String{
            return (_verticalScrollPolicy);
        }
        public function get borderMetrics():EdgeMetrics{
            return (((((border) && ((border is IRectangularBorder)))) ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY));
        }
        private function creationCompleteHandler(_arg1:FlexEvent):void{
            numChildrenCreated--;
            if (numChildrenCreated <= 0){
                dispatchEvent(new FlexEvent("childrenCreationComplete"));
            };
        }
        override public function contentToLocal(_arg1:Point):Point{
            if (!contentPane){
                return (_arg1);
            };
            _arg1 = contentToGlobal(_arg1);
            return (globalToLocal(_arg1));
        }
        override public function removeChild(_arg1:DisplayObject):DisplayObject{
            var _local2:int;
            var _local3:int;
            if ((((_arg1 is IDeferredInstantiationUIComponent)) && (IDeferredInstantiationUIComponent(_arg1).descriptor))){
                if (createdComponents){
                    _local2 = createdComponents.length;
                    _local3 = 0;
                    while (_local3 < _local2) {
                        if (createdComponents[_local3] === _arg1){
                            createdComponents.splice(_local3, 1);
                        };
                        _local3++;
                    };
                };
            };
            removingChild(_arg1);
            if ((((_arg1 is UIComponent)) && (UIComponent(_arg1).isDocument))){
                BindingManager.setEnabled(_arg1, false);
            };
            if (contentPane){
                contentPane.removeChild(_arg1);
            } else {
                $removeChild(_arg1);
            };
            childRemoved(_arg1);
            return (_arg1);
        }
        final mx_internal function get $numChildren():int{
            return (super.numChildren);
        }
        mx_internal function get numRepeaters():int{
            return (((childRepeaters) ? childRepeaters.length : 0));
        }
        mx_internal function set numChildrenCreated(_arg1:int):void{
            _numChildrenCreated = _arg1;
        }
        public function get creatingContentPane():Boolean{
            return (_creatingContentPane);
        }
        public function get clipContent():Boolean{
            return (_clipContent);
        }
        mx_internal function rawChildren_getChildIndex(_arg1:DisplayObject):int{
            return (super.getChildIndex(_arg1));
        }
        override public function regenerateStyleCache(_arg1:Boolean):void{
            var _local2:int;
            var _local3:int;
            var _local4:DisplayObject;
            super.regenerateStyleCache(_arg1);
            if (contentPane){
                _local2 = contentPane.numChildren;
                _local3 = 0;
                while (_local3 < _local2) {
                    _local4 = getChildAt(_local3);
                    if (((_arg1) && ((_local4 is UIComponent)))){
                        if (UIComponent(_local4).inheritingStyles != UIComponent.STYLE_UNINITIALIZED){
                            UIComponent(_local4).regenerateStyleCache(_arg1);
                        };
                    } else {
                        if ((((_local4 is IUITextField)) && (IUITextField(_local4).inheritingStyles))){
                            StyleProtoChain.initTextField(IUITextField(_local4));
                        };
                    };
                    _local3++;
                };
            };
        }
        override public function getChildIndex(_arg1:DisplayObject):int{
            var _local2:int;
            if (contentPane){
                return (contentPane.getChildIndex(_arg1));
            };
            _local2 = (super.getChildIndex(_arg1) - _firstChildIndex);
            return (_local2);
        }
        mx_internal function rawChildren_contains(_arg1:DisplayObject):Boolean{
            return (super.contains(_arg1));
        }
        mx_internal function getScrollableRect():Rectangle{
            var _local9:DisplayObject;
            var _local1:Number = 0;
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:Number = 0;
            var _local5:int = numChildren;
            var _local6:int;
            while (_local6 < _local5) {
                _local9 = getChildAt(_local6);
                if ((((_local9 is IUIComponent)) && (!(IUIComponent(_local9).includeInLayout)))){
                } else {
                    _local1 = Math.min(_local1, _local9.x);
                    _local2 = Math.min(_local2, _local9.y);
                    if (!isNaN(_local9.width)){
                        _local3 = Math.max(_local3, (_local9.x + _local9.width));
                    };
                    if (!isNaN(_local9.height)){
                        _local4 = Math.max(_local4, (_local9.y + _local9.height));
                    };
                };
                _local6++;
            };
            var _local7:EdgeMetrics = viewMetrics;
            var _local8:Rectangle = new Rectangle();
            _local8.left = _local1;
            _local8.top = _local2;
            _local8.right = _local3;
            _local8.bottom = _local4;
            if (usePadding){
                _local8.right = (_local8.right + getStyle("paddingRight"));
                _local8.bottom = (_local8.bottom + getStyle("paddingBottom"));
            };
            return (_local8);
        }
        override protected function createChildren():void{
            var _local1:Application;
            super.createChildren();
            createBorder();
            createOrDestroyScrollbars((horizontalScrollPolicy == ScrollPolicy.ON), (verticalScrollPolicy == ScrollPolicy.ON), (((horizontalScrollPolicy == ScrollPolicy.ON)) || ((verticalScrollPolicy == ScrollPolicy.ON))));
            if (creationPolicy != null){
                actualCreationPolicy = creationPolicy;
            } else {
                if ((parent is Container)){
                    if (Container(parent).actualCreationPolicy == ContainerCreationPolicy.QUEUED){
                        actualCreationPolicy = ContainerCreationPolicy.AUTO;
                    } else {
                        actualCreationPolicy = Container(parent).actualCreationPolicy;
                    };
                };
            };
            if (actualCreationPolicy == ContainerCreationPolicy.NONE){
                actualCreationPolicy = ContainerCreationPolicy.AUTO;
            } else {
                if (actualCreationPolicy == ContainerCreationPolicy.QUEUED){
                    _local1 = ((parentApplication) ? Application(parentApplication) : Application(Application.application));
                    _local1.addToCreationQueue(this, creationIndex, null, this);
                } else {
                    if (recursionFlag){
                        createComponentsFromDescriptors();
                    };
                };
            };
            if (autoLayout == false){
                forceLayout = true;
            };
            UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
        }
        override public function executeBindings(_arg1:Boolean=false):void{
            var _local2:Object = ((((descriptor) && (descriptor.document))) ? descriptor.document : parentDocument);
            BindingManager.executeBindings(_local2, id, this);
            if (_arg1){
                executeChildBindings(_arg1);
            };
        }
        override public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            var _local3:int;
            var _local4:int = _local3;
            var _local5:int = _arg2;
            if (contentPane){
                contentPane.setChildIndex(_arg1, _arg2);
                if (((_autoLayout) || (forceLayout))){
                    invalidateDisplayList();
                };
            } else {
                _local3 = super.getChildIndex(_arg1);
                _arg2 = (_arg2 + _firstChildIndex);
                if (_arg2 == _local3){
                    return;
                };
                super.setChildIndex(_arg1, _arg2);
                invalidateDisplayList();
                _local4 = (_local3 - _firstChildIndex);
                _local5 = (_arg2 - _firstChildIndex);
            };
            var _local6:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHILD_INDEX_CHANGE);
            _local6.relatedObject = _arg1;
            _local6.oldIndex = _local4;
            _local6.newIndex = _local5;
            dispatchEvent(_local6);
            dispatchEvent(new Event("childrenChanged"));
        }
        override public function globalToContent(_arg1:Point):Point{
            if (contentPane){
                return (contentPane.globalToLocal(_arg1));
            };
            return (globalToLocal(_arg1));
        }
        mx_internal function rawChildren_removeChild(_arg1:DisplayObject):DisplayObject{
            var _local2:int = rawChildren_getChildIndex(_arg1);
            return (rawChildren_removeChildAt(_local2));
        }
        mx_internal function rawChildren_setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            var _local3:int = super.getChildIndex(_arg1);
            super.setChildIndex(_arg1, _arg2);
            if ((((_local3 < _firstChildIndex)) && ((_arg2 >= _firstChildIndex)))){
                _firstChildIndex--;
            } else {
                if ((((_local3 >= _firstChildIndex)) && ((_arg2 <= _firstChildIndex)))){
                    _firstChildIndex++;
                };
            };
            dispatchEvent(new Event("childrenChanged"));
        }
        public function set verticalLineScrollSize(_arg1:Number):void{
            scrollPropertiesChanged = true;
            _verticalLineScrollSize = _arg1;
            invalidateDisplayList();
            dispatchEvent(new Event("verticalLineScrollSizeChanged"));
        }
        mx_internal function rawChildren_getChildAt(_arg1:int):DisplayObject{
            return (super.getChildAt(_arg1));
        }
        public function get creationIndex():int{
            return (_creationIndex);
        }
        public function get verticalScrollBar():ScrollBar{
            return (_verticalScrollBar);
        }
        public function get viewMetricsAndPadding():EdgeMetrics{
            if (((((_viewMetricsAndPadding) && (((!(horizontalScrollBar)) || ((horizontalScrollPolicy == ScrollPolicy.ON)))))) && (((!(verticalScrollBar)) || ((verticalScrollPolicy == ScrollPolicy.ON)))))){
                return (_viewMetricsAndPadding);
            };
            if (!_viewMetricsAndPadding){
                _viewMetricsAndPadding = new EdgeMetrics();
            };
            var _local1:EdgeMetrics = _viewMetricsAndPadding;
            var _local2:EdgeMetrics = viewMetrics;
            _local1.left = (_local2.left + getStyle("paddingLeft"));
            _local1.right = (_local2.right + getStyle("paddingRight"));
            _local1.top = (_local2.top + getStyle("paddingTop"));
            _local1.bottom = (_local2.bottom + getStyle("paddingBottom"));
            return (_local1);
        }
        override public function addChild(_arg1:DisplayObject):DisplayObject{
            return (addChildAt(_arg1, numChildren));
        }
        public function set horizontalPageScrollSize(_arg1:Number):void{
            scrollPropertiesChanged = true;
            _horizontalPageScrollSize = _arg1;
            invalidateDisplayList();
            dispatchEvent(new Event("horizontalPageScrollSizeChanged"));
        }
        override mx_internal function childAdded(_arg1:DisplayObject):void{
            dispatchEvent(new Event("childrenChanged"));
            var _local2:ChildExistenceChangedEvent = new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_ADD);
            _local2.relatedObject = _arg1;
            dispatchEvent(_local2);
            _arg1.dispatchEvent(new FlexEvent(FlexEvent.ADD));
            super.childAdded(_arg1);
        }
        public function set horizontalScrollPolicy(_arg1:String):void{
            if (_horizontalScrollPolicy != _arg1){
                _horizontalScrollPolicy = _arg1;
                invalidateDisplayList();
                dispatchEvent(new Event("horizontalScrollPolicyChanged"));
            };
        }
        private function layoutCompleteHandler(_arg1:FlexEvent):void{
            UIComponentGlobals.layoutManager.removeEventListener(FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler);
            forceLayout = false;
            var _local2:Boolean;
            if (!isNaN(horizontalScrollPositionPending)){
                if (horizontalScrollPositionPending < 0){
                    horizontalScrollPositionPending = 0;
                } else {
                    if (horizontalScrollPositionPending > maxHorizontalScrollPosition){
                        horizontalScrollPositionPending = maxHorizontalScrollPosition;
                    };
                };
                if (((horizontalScrollBar) && (!((horizontalScrollBar.scrollPosition == horizontalScrollPositionPending))))){
                    _horizontalScrollPosition = horizontalScrollPositionPending;
                    horizontalScrollBar.scrollPosition = horizontalScrollPositionPending;
                    _local2 = true;
                };
                horizontalScrollPositionPending = NaN;
            };
            if (!isNaN(verticalScrollPositionPending)){
                if (verticalScrollPositionPending < 0){
                    verticalScrollPositionPending = 0;
                } else {
                    if (verticalScrollPositionPending > maxVerticalScrollPosition){
                        verticalScrollPositionPending = maxVerticalScrollPosition;
                    };
                };
                if (((verticalScrollBar) && (!((verticalScrollBar.scrollPosition == verticalScrollPositionPending))))){
                    _verticalScrollPosition = verticalScrollPositionPending;
                    verticalScrollBar.scrollPosition = verticalScrollPositionPending;
                    _local2 = true;
                };
                verticalScrollPositionPending = NaN;
            };
            if (_local2){
                scrollChildren();
            };
        }
        public function createComponentsFromDescriptors(_arg1:Boolean=true):void{
            var _local4:IFlexDisplayObject;
            numChildrenBefore = numChildren;
            createdComponents = [];
            var _local2:int = ((childDescriptors) ? childDescriptors.length : 0);
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = createComponentFromDescriptor(childDescriptors[_local3], _arg1);
                createdComponents.push(_local4);
                _local3++;
            };
            if ((((creationPolicy == ContainerCreationPolicy.QUEUED)) || ((creationPolicy == ContainerCreationPolicy.NONE)))){
                UIComponentGlobals.layoutManager.usePhasedInstantiation = false;
            };
            numChildrenCreated = (numChildren - numChildrenBefore);
            processedDescriptors = true;
        }
        override mx_internal function fillOverlay(_arg1:UIComponent, _arg2:uint, _arg3:RoundedRectangle=null):void{
            var _local4:EdgeMetrics = viewMetrics;
            var _local5:Number = 0;
            if (!_arg3){
                _arg3 = new RoundedRectangle(_local4.left, _local4.top, ((unscaledWidth - _local4.right) - _local4.left), ((unscaledHeight - _local4.bottom) - _local4.top), _local5);
            };
            if (((((((((isNaN(_arg3.x)) || (isNaN(_arg3.y)))) || (isNaN(_arg3.width)))) || (isNaN(_arg3.height)))) || (isNaN(_arg3.cornerRadius)))){
                return;
            };
            var _local6:Graphics = _arg1.graphics;
            _local6.clear();
            _local6.beginFill(_arg2);
            _local6.drawRoundRect(_arg3.x, _arg3.y, _arg3.width, _arg3.height, (_arg3.cornerRadius * 2), (_arg3.cornerRadius * 2));
            _local6.endFill();
        }
        override public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            super.removeEventListener(_arg1, _arg2, _arg3);
            if ((((((((((((((((_arg1 == MouseEvent.CLICK)) || ((_arg1 == MouseEvent.DOUBLE_CLICK)))) || ((_arg1 == MouseEvent.MOUSE_DOWN)))) || ((_arg1 == MouseEvent.MOUSE_MOVE)))) || ((_arg1 == MouseEvent.MOUSE_OVER)))) || ((_arg1 == MouseEvent.MOUSE_OUT)))) || ((_arg1 == MouseEvent.MOUSE_UP)))) || ((_arg1 == MouseEvent.MOUSE_WHEEL)))){
                if ((((mouseEventReferenceCount > 0)) && ((--mouseEventReferenceCount == 0)))){
                    setStyle("mouseShield", false);
                    setStyle("mouseShieldChildren", false);
                };
            };
        }
        mx_internal function rawChildren_removeChildAt(_arg1:int):DisplayObject{
            var _local2:DisplayObject = super.getChildAt(_arg1);
            super.removingChild(_local2);
            $removeChildAt(_arg1);
            super.childRemoved(_local2);
            if ((((_firstChildIndex < _arg1)) && ((_arg1 < (_firstChildIndex + _numChildren))))){
                _numChildren--;
            } else {
                if ((((_numChildren == 0)) || ((_arg1 < _firstChildIndex)))){
                    _firstChildIndex--;
                };
            };
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("childrenChanged"));
            return (_local2);
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            invalidateDisplayList();
        }
        override public function removeChildAt(_arg1:int):DisplayObject{
            return (removeChild(getChildAt(_arg1)));
        }
        private function isBorderNeeded():Boolean{
            var c:* = getStyle("borderSkin");
            try {
                if (c != getDefinitionByName("mx.skins.halo::HaloBorder")){
                    return (true);
                };
            } catch(e:Error) {
                return (true);
            };
            var v:* = getStyle("borderStyle");
            if (v){
                if (((!((v == "none"))) || ((((v == "none")) && (getStyle("mouseShield")))))){
                    return (true);
                };
            };
            v = getStyle("backgroundColor");
            if (((!((v === null))) && (!((v === ""))))){
                return (true);
            };
            v = getStyle("backgroundImage");
            return (((!((v == null))) && (!((v == "")))));
        }
        public function set autoLayout(_arg1:Boolean):void{
            var _local2:IInvalidating;
            _autoLayout = _arg1;
            if (_arg1){
                invalidateSize();
                invalidateDisplayList();
                _local2 = (parent as IInvalidating);
                if (_local2){
                    _local2.invalidateSize();
                    _local2.invalidateDisplayList();
                };
            };
        }
        public function get verticalPageScrollSize():Number{
            return (_verticalPageScrollSize);
        }
        public function getChildren():Array{
            var _local1:Array = [];
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local1.push(getChildAt(_local3));
                _local3++;
            };
            return (_local1);
        }
        private function createScrollbarsIfNeeded(_arg1:Rectangle):Boolean{
            var _local2:Number = _arg1.right;
            var _local3:Number = _arg1.bottom;
            var _local4:Number = unscaledWidth;
            var _local5:Number = unscaledHeight;
            var _local6:Boolean = (((_arg1.left < 0)) || ((_arg1.top < 0)));
            var _local7:EdgeMetrics = viewMetrics;
            if (scaleX != 1){
                _local4 = (_local4 + (1 / Math.abs(scaleX)));
            };
            if (scaleY != 1){
                _local5 = (_local5 + (1 / Math.abs(scaleY)));
            };
            _local4 = Math.floor(_local4);
            _local5 = Math.floor(_local5);
            _local2 = Math.floor(_local2);
            _local3 = Math.floor(_local3);
            if (((horizontalScrollBar) && (!((horizontalScrollPolicy == ScrollPolicy.ON))))){
                _local5 = (_local5 - horizontalScrollBar.minHeight);
            };
            if (((verticalScrollBar) && (!((verticalScrollPolicy == ScrollPolicy.ON))))){
                _local4 = (_local4 - verticalScrollBar.minWidth);
            };
            _local4 = (_local4 - (_local7.left + _local7.right));
            _local5 = (_local5 - (_local7.top + _local7.bottom));
            var _local8 = (horizontalScrollPolicy == ScrollPolicy.ON);
            var _local9 = (verticalScrollPolicy == ScrollPolicy.ON);
            var _local10:Boolean = ((((((((((_local8) || (_local9))) || (_local6))) || (!((overlay == null))))) || ((_local7.left > 0)))) || ((_local7.top > 0)));
            if (_local4 < _local2){
                _local10 = true;
                if ((((((horizontalScrollPolicy == ScrollPolicy.AUTO)) && ((((unscaledHeight - _local7.top) - _local7.bottom) >= 18)))) && ((((unscaledWidth - _local7.left) - _local7.right) >= 32)))){
                    _local8 = true;
                };
            };
            if (_local5 < _local3){
                _local10 = true;
                if ((((((verticalScrollPolicy == ScrollPolicy.AUTO)) && ((((unscaledWidth - _local7.left) - _local7.right) >= 18)))) && ((((unscaledHeight - _local7.top) - _local7.bottom) >= 32)))){
                    _local9 = true;
                };
            };
            if (((((((((((((((_local8) && (_local9))) && ((horizontalScrollPolicy == ScrollPolicy.AUTO)))) && ((verticalScrollPolicy == ScrollPolicy.AUTO)))) && (horizontalScrollBar))) && (verticalScrollBar))) && (((_local4 + verticalScrollBar.minWidth) >= _local2)))) && (((_local5 + horizontalScrollBar.minHeight) >= _local3)))){
                _local9 = false;
                _local8 = _local9;
            } else {
                if (((((((((_local8) && (!(_local9)))) && (verticalScrollBar))) && ((horizontalScrollPolicy == ScrollPolicy.AUTO)))) && (((_local4 + verticalScrollBar.minWidth) >= _local2)))){
                    _local8 = false;
                };
            };
            var _local11:Boolean = createOrDestroyScrollbars(_local8, _local9, _local10);
            if (((((!((scrollableWidth == _local2))) || (!((viewableWidth == _local4))))) || (_local11))){
                if (horizontalScrollBar){
                    horizontalScrollBar.setScrollProperties(_local4, 0, (_local2 - _local4), horizontalPageScrollSize);
                    scrollPositionChanged = true;
                };
                viewableWidth = _local4;
                scrollableWidth = _local2;
            };
            if (((((!((scrollableHeight == _local3))) || (!((viewableHeight == _local5))))) || (_local11))){
                if (verticalScrollBar){
                    verticalScrollBar.setScrollProperties(_local5, 0, (_local3 - _local5), verticalPageScrollSize);
                    scrollPositionChanged = true;
                };
                viewableHeight = _local5;
                scrollableHeight = _local3;
            };
            return (_local11);
        }
        override mx_internal function removingChild(_arg1:DisplayObject):void{
            super.removingChild(_arg1);
            _arg1.dispatchEvent(new FlexEvent(FlexEvent.REMOVE));
            var _local2:ChildExistenceChangedEvent = new ChildExistenceChangedEvent(ChildExistenceChangedEvent.CHILD_REMOVE);
            _local2.relatedObject = _arg1;
            dispatchEvent(_local2);
        }
        mx_internal function get numChildrenCreated():int{
            return (_numChildrenCreated);
        }
        mx_internal function rawChildren_addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            if ((((_firstChildIndex < _arg2)) && ((_arg2 < ((_firstChildIndex + _numChildren) + 1))))){
                _numChildren++;
            } else {
                if (_arg2 <= _firstChildIndex){
                    _firstChildIndex++;
                };
            };
            super.addingChild(_arg1);
            $addChildAt(_arg1, _arg2);
            super.childAdded(_arg1);
            dispatchEvent(new Event("childrenChanged"));
            return (_arg1);
        }
        private function hasChildMatchingDescriptor(_arg1:UIComponentDescriptor):Boolean{
            var _local4:int;
            var _local5:IUIComponent;
            var _local2:String = _arg1.id;
            if (((!((_local2 == null))) && ((document[_local2] == null)))){
                return (false);
            };
            var _local3:int = numChildren;
            _local4 = 0;
            while (_local4 < _local3) {
                _local5 = IUIComponent(getChildAt(_local4));
                if ((((_local5 is IDeferredInstantiationUIComponent)) && ((IDeferredInstantiationUIComponent(_local5).descriptor == _arg1)))){
                    return (true);
                };
                _local4++;
            };
            if (childRepeaters){
                _local3 = childRepeaters.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    if (IDeferredInstantiationUIComponent(childRepeaters[_local4]).descriptor == _arg1){
                        return (true);
                    };
                    _local4++;
                };
            };
            return (false);
        }
        mx_internal function rawChildren_getChildByName(_arg1:String):DisplayObject{
            return (super.getChildByName(_arg1));
        }
        override public function validateDisplayList():void{
            var _local1:EdgeMetrics;
            var _local2:Number;
            var _local3:Number;
            var _local4:Object;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            if (((_autoLayout) || (forceLayout))){
                doingLayout = true;
                super.validateDisplayList();
                doingLayout = false;
            } else {
                layoutChrome(unscaledWidth, unscaledHeight);
            };
            invalidateDisplayListFlag = true;
            if (createContentPaneAndScrollbarsIfNeeded()){
                if (((_autoLayout) || (forceLayout))){
                    doingLayout = true;
                    super.validateDisplayList();
                    doingLayout = false;
                };
                createContentPaneAndScrollbarsIfNeeded();
            };
            if (clampScrollPositions()){
                scrollChildren();
            };
            if (contentPane){
                _local1 = viewMetrics;
                if (overlay){
                    overlay.x = 0;
                    overlay.y = 0;
                    overlay.width = unscaledWidth;
                    overlay.height = unscaledHeight;
                };
                if (((horizontalScrollBar) || (verticalScrollBar))){
                    if (((verticalScrollBar) && ((verticalScrollPolicy == ScrollPolicy.ON)))){
                        _local1.right = (_local1.right - verticalScrollBar.minWidth);
                    };
                    if (((horizontalScrollBar) && ((horizontalScrollPolicy == ScrollPolicy.ON)))){
                        _local1.bottom = (_local1.bottom - horizontalScrollBar.minHeight);
                    };
                    if (horizontalScrollBar){
                        _local2 = ((unscaledWidth - _local1.left) - _local1.right);
                        if (verticalScrollBar){
                            _local2 = (_local2 - verticalScrollBar.minWidth);
                        };
                        horizontalScrollBar.setActualSize(_local2, horizontalScrollBar.minHeight);
                        horizontalScrollBar.move(_local1.left, ((unscaledHeight - _local1.bottom) - horizontalScrollBar.minHeight));
                    };
                    if (verticalScrollBar){
                        _local3 = ((unscaledHeight - _local1.top) - _local1.bottom);
                        if (horizontalScrollBar){
                            _local3 = (_local3 - horizontalScrollBar.minHeight);
                        };
                        verticalScrollBar.setActualSize(verticalScrollBar.minWidth, _local3);
                        verticalScrollBar.move(((unscaledWidth - _local1.right) - verticalScrollBar.minWidth), _local1.top);
                    };
                    if (whiteBox){
                        whiteBox.x = verticalScrollBar.x;
                        whiteBox.y = horizontalScrollBar.y;
                    };
                };
                contentPane.x = _local1.left;
                contentPane.y = _local1.top;
                if (focusPane){
                    focusPane.x = _local1.left;
                    focusPane.y = _local1.top;
                };
                scrollChildren();
            };
            invalidateDisplayListFlag = false;
            if (blocker){
                _local1 = viewMetrics;
                _local4 = ((enabled) ? null : getStyle("backgroundDisabledColor"));
                if ((((_local4 === null)) || (isNaN(Number(_local4))))){
                    _local4 = getStyle("backgroundColor");
                };
                if ((((_local4 === null)) || (isNaN(Number(_local4))))){
                    _local4 = 0xFFFFFF;
                };
                _local5 = getStyle("disabledOverlayAlpha");
                if (isNaN(_local5)){
                    _local5 = 0.6;
                };
                blocker.x = _local1.left;
                blocker.y = _local1.top;
                _local6 = (unscaledWidth - (_local1.left + _local1.right));
                _local7 = (unscaledHeight - (_local1.top + _local1.bottom));
                blocker.graphics.clear();
                blocker.graphics.beginFill(uint(_local4), _local5);
                blocker.graphics.drawRect(0, 0, _local6, _local7);
                blocker.graphics.endFill();
                rawChildren.setChildIndex(blocker, (rawChildren.numChildren - 1));
            };
        }
        public function set horizontalLineScrollSize(_arg1:Number):void{
            scrollPropertiesChanged = true;
            _horizontalLineScrollSize = _arg1;
            invalidateDisplayList();
            dispatchEvent(new Event("horizontalLineScrollSizeChanged"));
        }
        override public function initialize():void{
            var _local1:*;
            var _local2:String;
            if (((((isDocument) && (documentDescriptor))) && (!(processedDescriptors)))){
                _local1 = documentDescriptor.properties;
                if (((_local1) && (_local1.childDescriptors))){
                    if (_childDescriptors){
                        _local2 = resourceManager.getString("core", "multipleChildSets_ClassAndInstance");
                        throw (new Error(_local2));
                    };
                    _childDescriptors = _local1.childDescriptors;
                };
            };
            super.initialize();
        }
        mx_internal function set forceClipping(_arg1:Boolean):void{
            if (_clipContent){
                if (_arg1){
                    _forceClippingCount++;
                } else {
                    _forceClippingCount--;
                };
                createContentPane();
                scrollChildren();
            };
        }
        public function removeAllChildren():void{
            while (numChildren > 0) {
                removeChildAt(0);
            };
        }
        override public function contentToGlobal(_arg1:Point):Point{
            if (contentPane){
                return (contentPane.localToGlobal(_arg1));
            };
            return (localToGlobal(_arg1));
        }
        public function get horizontalPageScrollSize():Number{
            return (_horizontalPageScrollSize);
        }
        override mx_internal function childRemoved(_arg1:DisplayObject):void{
            super.childRemoved(_arg1);
            invalidateSize();
            invalidateDisplayList();
            if (!contentPane){
                _numChildren--;
                if (_numChildren == 0){
                    _firstChildIndex = super.numChildren;
                };
            };
            if (((contentPane) && (!(autoLayout)))){
                forceLayout = true;
                UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
            };
            dispatchEvent(new Event("childrenChanged"));
        }
        public function set defaultButton(_arg1:IFlexDisplayObject):void{
            _defaultButton = _arg1;
            ContainerGlobals.focusedContainer = null;
        }
        public function get data():Object{
            return (_data);
        }
        override public function get numChildren():int{
            return (((contentPane) ? contentPane.numChildren : _numChildren));
        }
        public function get autoLayout():Boolean{
            return (_autoLayout);
        }
        override public function styleChanged(_arg1:String):void{
            var _local3:String;
            var _local4:String;
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            if (((_local2) || (StyleManager.isSizeInvalidatingStyle(_arg1)))){
                invalidateDisplayList();
            };
            if (((_local2) || ((_arg1 == "borderSkin")))){
                if (border){
                    rawChildren.removeChild(DisplayObject(border));
                    border = null;
                    createBorder();
                };
            };
            if (((((((((((_local2) || ((_arg1 == "borderStyle")))) || ((_arg1 == "backgroundColor")))) || ((_arg1 == "backgroundImage")))) || ((_arg1 == "mouseShield")))) || ((_arg1 == "mouseShieldChildren")))){
                createBorder();
            };
            super.styleChanged(_arg1);
            if (((_local2) || (StyleManager.isSizeInvalidatingStyle(_arg1)))){
                invalidateViewMetricsAndPadding();
            };
            if (((_local2) || ((_arg1 == "horizontalScrollBarStyleName")))){
                if (((horizontalScrollBar) && ((horizontalScrollBar is ISimpleStyleClient)))){
                    _local3 = getStyle("horizontalScrollBarStyleName");
                    ISimpleStyleClient(horizontalScrollBar).styleName = _local3;
                };
            };
            if (((_local2) || ((_arg1 == "verticalScrollBarStyleName")))){
                if (((verticalScrollBar) && ((verticalScrollBar is ISimpleStyleClient)))){
                    _local4 = getStyle("verticalScrollBarStyleName");
                    ISimpleStyleClient(verticalScrollBar).styleName = _local4;
                };
            };
        }
        override protected function commitProperties():void{
            var _local1:String;
            super.commitProperties();
            if (changedStyles){
                _local1 = (((changedStyles == MULTIPLE_PROPERTIES)) ? null : changedStyles);
                super.notifyStyleChangeInChildren(_local1, true);
                changedStyles = null;
            };
            createOrDestroyBlocker();
        }
        override public function finishPrint(_arg1:Object, _arg2:IFlexDisplayObject):void{
            if (_arg1){
                contentPane.scrollRect = Rectangle(_arg1);
            };
            super.finishPrint(_arg1, _arg2);
        }
        public function get maxHorizontalScrollPosition():Number{
            return (((horizontalScrollBar) ? horizontalScrollBar.maxScrollPosition : Math.max((scrollableWidth - viewableWidth), 0)));
        }
        public function set creationPolicy(_arg1:String):void{
            _creationPolicy = _arg1;
            setActualCreationPolicies(_arg1);
        }
        public function set label(_arg1:String):void{
            _label = _arg1;
            dispatchEvent(new Event("labelChanged"));
        }
        private function clampScrollPositions():Boolean{
            var _local1:Boolean;
            if (_horizontalScrollPosition < 0){
                _horizontalScrollPosition = 0;
                _local1 = true;
            } else {
                if (_horizontalScrollPosition > maxHorizontalScrollPosition){
                    _horizontalScrollPosition = maxHorizontalScrollPosition;
                    _local1 = true;
                };
            };
            if (((horizontalScrollBar) && (!((horizontalScrollBar.scrollPosition == _horizontalScrollPosition))))){
                horizontalScrollBar.scrollPosition = _horizontalScrollPosition;
            };
            if (_verticalScrollPosition < 0){
                _verticalScrollPosition = 0;
                _local1 = true;
            } else {
                if (_verticalScrollPosition > maxVerticalScrollPosition){
                    _verticalScrollPosition = maxVerticalScrollPosition;
                    _local1 = true;
                };
            };
            if (((verticalScrollBar) && (!((verticalScrollBar.scrollPosition == _verticalScrollPosition))))){
                verticalScrollBar.scrollPosition = _verticalScrollPosition;
            };
            return (_local1);
        }
        override public function prepareToPrint(_arg1:IFlexDisplayObject):Object{
            var _local2:Rectangle = ((((contentPane) && (contentPane.scrollRect))) ? contentPane.scrollRect : null);
            if (_local2){
                contentPane.scrollRect = null;
            };
            super.prepareToPrint(_arg1);
            return (_local2);
        }
        mx_internal function get firstChildIndex():int{
            return (_firstChildIndex);
        }
        mx_internal function rawChildren_addChild(_arg1:DisplayObject):DisplayObject{
            if (_numChildren == 0){
                _firstChildIndex++;
            };
            super.addingChild(_arg1);
            $addChild(_arg1);
            super.childAdded(_arg1);
            dispatchEvent(new Event("childrenChanged"));
            return (_arg1);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:Object;
            var _local4:Number;
            super.updateDisplayList(_arg1, _arg2);
            layoutChrome(_arg1, _arg2);
            if (scrollPositionChanged){
                clampScrollPositions();
                scrollChildren();
                scrollPositionChanged = false;
            };
            if (scrollPropertiesChanged){
                if (horizontalScrollBar){
                    horizontalScrollBar.lineScrollSize = horizontalLineScrollSize;
                    horizontalScrollBar.pageScrollSize = horizontalPageScrollSize;
                };
                if (verticalScrollBar){
                    verticalScrollBar.lineScrollSize = verticalLineScrollSize;
                    verticalScrollBar.pageScrollSize = verticalPageScrollSize;
                };
                scrollPropertiesChanged = false;
            };
            if (((contentPane) && (contentPane.scrollRect))){
                _local3 = ((enabled) ? null : getStyle("backgroundDisabledColor"));
                if ((((_local3 === null)) || (isNaN(Number(_local3))))){
                    _local3 = getStyle("backgroundColor");
                };
                _local4 = getStyle("backgroundAlpha");
                if (((((((!(_clipContent)) || (isNaN(Number(_local3))))) || ((_local3 === "")))) || (((!(((horizontalScrollBar) || (verticalScrollBar)))) && (!(cacheAsBitmap)))))){
                    _local3 = null;
                } else {
                    if (((getStyle("backgroundImage")) || (getStyle("background")))){
                        _local3 = null;
                    } else {
                        if (_local4 != 1){
                            _local3 = null;
                        };
                    };
                };
                contentPane.opaqueBackground = _local3;
                contentPane.cacheAsBitmap = !((_local3 == null));
            };
        }
        override mx_internal function addingChild(_arg1:DisplayObject):void{
            var _local2:IUIComponent = IUIComponent(_arg1);
            super.addingChild(_arg1);
            invalidateSize();
            invalidateDisplayList();
            if (!contentPane){
                if (_numChildren == 0){
                    _firstChildIndex = super.numChildren;
                };
                _numChildren++;
            };
            if (((contentPane) && (!(autoLayout)))){
                forceLayout = true;
                UIComponentGlobals.layoutManager.addEventListener(FlexEvent.UPDATE_COMPLETE, layoutCompleteHandler, false, 0, true);
            };
        }
        mx_internal function setActualCreationPolicies(_arg1:String):void{
            var _local5:IFlexDisplayObject;
            var _local6:Container;
            actualCreationPolicy = _arg1;
            var _local2:String = _arg1;
            if (_arg1 == ContainerCreationPolicy.QUEUED){
                _local2 = ContainerCreationPolicy.AUTO;
            };
            var _local3:int = numChildren;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = IFlexDisplayObject(getChildAt(_local4));
                if ((_local5 is Container)){
                    _local6 = Container(_local5);
                    if (_local6.creationPolicy == null){
                        _local6.setActualCreationPolicies(_local2);
                    };
                };
                _local4++;
            };
        }

    }
}//package mx.core 
