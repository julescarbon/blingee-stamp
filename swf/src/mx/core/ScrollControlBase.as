package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.controls.scrollClasses.*;

    public class ScrollControlBase extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var numberOfRows:Number = 0;
        private var _scrollTipFunction:Function;
        private var scrollTip:ToolTip;
        public var showScrollTips:Boolean = false;
        private var numberOfCols:Number = 0;
        protected var maskShape:Shape;
        private var oldTTMEnabled:Boolean;
        mx_internal var _maxHorizontalScrollPosition:Number;
        protected var border:IFlexDisplayObject;
        private var _viewMetrics:EdgeMetrics;
        mx_internal var _maxVerticalScrollPosition:Number;
        protected var verticalScrollBar:ScrollBar;
        mx_internal var _horizontalScrollPosition:Number = 0;
        private var propsInited:Boolean;
        protected var horizontalScrollBar:ScrollBar;
        mx_internal var _horizontalScrollPolicy:String = "off";
        mx_internal var _verticalScrollPosition:Number = 0;
        private var scrollThumbMidPoint:Number;
        mx_internal var _verticalScrollPolicy:String = "auto";
        protected var scrollAreaChanged:Boolean;
        private var viewableColumns:Number;
        public var liveScrolling:Boolean = true;
        private var viewableRows:Number;
        private var invLayout:Boolean;

        public function ScrollControlBase(){
            _viewMetrics = EdgeMetrics.EMPTY;
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            if (horizontalScrollBar){
                horizontalScrollBar.enabled = _arg1;
            };
            if (verticalScrollBar){
                verticalScrollBar.enabled = _arg1;
            };
        }
        public function get scrollTipFunction():Function{
            return (_scrollTipFunction);
        }
        public function set scrollTipFunction(_arg1:Function):void{
            _scrollTipFunction = _arg1;
            dispatchEvent(new Event("scrollTipFunctionChanged"));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            layoutChrome(_arg1, _arg2);
            var _local3:Number = _arg1;
            var _local4:Number = _arg2;
            invLayout = false;
            var _local5:EdgeMetrics = (_viewMetrics = viewMetrics);
            if (((horizontalScrollBar) && (horizontalScrollBar.visible))){
                horizontalScrollBar.setActualSize(((_local3 - _local5.left) - _local5.right), horizontalScrollBar.minHeight);
                horizontalScrollBar.move(_local5.left, (_local4 - _local5.bottom));
                horizontalScrollBar.enabled = enabled;
            };
            if (((verticalScrollBar) && (verticalScrollBar.visible))){
                verticalScrollBar.setActualSize(verticalScrollBar.minWidth, ((_local4 - _local5.top) - _local5.bottom));
                verticalScrollBar.move((_local3 - _local5.right), _local5.top);
                verticalScrollBar.enabled = enabled;
            };
            var _local6:DisplayObject = maskShape;
            var _local7:Number = ((_local3 - _local5.left) - _local5.right);
            var _local8:Number = ((_local4 - _local5.top) - _local5.bottom);
            _local6.width = (((_local7 < 0)) ? 0 : _local7);
            _local6.height = (((_local8 < 0)) ? 0 : _local8);
            _local6.x = _local5.left;
            _local6.y = _local5.top;
        }
        protected function setScrollBarProperties(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void{
            var _local7:Boolean;
            var _local5:String = this.horizontalScrollPolicy;
            var _local6:String = this.verticalScrollPolicy;
            scrollAreaChanged = false;
            if ((((_local5 == ScrollPolicy.ON)) || ((((((_arg2 < _arg1)) && ((_arg1 > 0)))) && ((_local5 == ScrollPolicy.AUTO)))))){
                if (!horizontalScrollBar){
                    createHScrollBar(false);
                    horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler);
                    horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollTipHandler);
                    horizontalScrollBar.scrollPosition = _horizontalScrollPosition;
                };
                _local7 = roomForScrollBar(horizontalScrollBar, unscaledWidth, unscaledHeight);
                if (_local7 != horizontalScrollBar.visible){
                    horizontalScrollBar.visible = _local7;
                    scrollAreaChanged = true;
                };
                if (((((horizontalScrollBar) && (horizontalScrollBar.visible))) && (((((!((numberOfCols == _arg1))) || (!((viewableColumns == _arg2))))) || (scrollAreaChanged))))){
                    horizontalScrollBar.setScrollProperties(_arg2, 0, (_arg1 - _arg2));
                    if (horizontalScrollBar.scrollPosition != _horizontalScrollPosition){
                        horizontalScrollBar.scrollPosition = _horizontalScrollPosition;
                    };
                    viewableColumns = _arg2;
                    numberOfCols = _arg1;
                };
            } else {
                if ((((((((_local5 == ScrollPolicy.AUTO)) || ((_local5 == ScrollPolicy.OFF)))) && (horizontalScrollBar))) && (horizontalScrollBar.visible))){
                    horizontalScrollPosition = 0;
                    horizontalScrollBar.setScrollProperties(_arg2, 0, 0);
                    horizontalScrollBar.visible = false;
                    viewableColumns = NaN;
                    scrollAreaChanged = true;
                };
            };
            if ((((_local6 == ScrollPolicy.ON)) || ((((((_arg4 < _arg3)) && ((_arg3 > 0)))) && ((_local6 == ScrollPolicy.AUTO)))))){
                if (!verticalScrollBar){
                    createVScrollBar(false);
                    verticalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler);
                    verticalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollTipHandler);
                    verticalScrollBar.scrollPosition = _verticalScrollPosition;
                };
                _local7 = roomForScrollBar(verticalScrollBar, unscaledWidth, unscaledHeight);
                if (_local7 != verticalScrollBar.visible){
                    verticalScrollBar.visible = _local7;
                    scrollAreaChanged = true;
                };
                if (((((verticalScrollBar) && (verticalScrollBar.visible))) && (((((!((numberOfRows == _arg3))) || (!((viewableRows == _arg4))))) || (scrollAreaChanged))))){
                    verticalScrollBar.setScrollProperties(_arg4, 0, (_arg3 - _arg4));
                    if (verticalScrollBar.scrollPosition != _verticalScrollPosition){
                        verticalScrollBar.scrollPosition = _verticalScrollPosition;
                    };
                    viewableRows = _arg4;
                    numberOfRows = _arg3;
                };
            } else {
                if ((((((((_local6 == ScrollPolicy.AUTO)) || ((_local6 == ScrollPolicy.OFF)))) && (verticalScrollBar))) && (verticalScrollBar.visible))){
                    verticalScrollPosition = 0;
                    verticalScrollBar.setScrollProperties(_arg4, 0, 0);
                    verticalScrollBar.visible = false;
                    viewableRows = NaN;
                    scrollAreaChanged = true;
                };
            };
            if (scrollAreaChanged){
                updateDisplayList(unscaledWidth, unscaledHeight);
            };
        }
        private function createHScrollBar(_arg1:Boolean):ScrollBar{
            horizontalScrollBar = new HScrollBar();
            horizontalScrollBar.visible = _arg1;
            horizontalScrollBar.enabled = enabled;
            var _local2:String = getStyle("horizontalScrollBarStyleName");
            horizontalScrollBar.styleName = _local2;
            addChild(horizontalScrollBar);
            horizontalScrollBar.validateNow();
            return (horizontalScrollBar);
        }
        public function get horizontalScrollPolicy():String{
            return (_horizontalScrollPolicy);
        }
        public function get maxVerticalScrollPosition():Number{
            if (!isNaN(_maxVerticalScrollPosition)){
                return (_maxVerticalScrollPosition);
            };
            var _local1:Number = ((verticalScrollBar) ? verticalScrollBar.maxScrollPosition : 0);
            return (_local1);
        }
        public function set horizontalScrollPosition(_arg1:Number):void{
            _horizontalScrollPosition = _arg1;
            if (horizontalScrollBar){
                horizontalScrollBar.scrollPosition = _arg1;
            };
            dispatchEvent(new Event("viewChanged"));
        }
        protected function roomForScrollBar(_arg1:ScrollBar, _arg2:Number, _arg3:Number):Boolean{
            var _local4:EdgeMetrics = borderMetrics;
            return ((((_arg2 >= ((_arg1.minWidth + _local4.left) + _local4.right))) && ((_arg3 >= ((_arg1.minHeight + _local4.top) + _local4.bottom)))));
        }
        public function set maxHorizontalScrollPosition(_arg1:Number):void{
            _maxHorizontalScrollPosition = _arg1;
            dispatchEvent(new Event("maxHorizontalScrollPositionChanged"));
        }
        public function get verticalScrollPosition():Number{
            return (_verticalScrollPosition);
        }
        public function set horizontalScrollPolicy(_arg1:String):void{
            var _local2:String = _arg1.toLowerCase();
            if (_horizontalScrollPolicy != _local2){
                _horizontalScrollPolicy = _local2;
                invalidateDisplayList();
                dispatchEvent(new Event("horizontalScrollPolicyChanged"));
            };
        }
        override protected function createChildren():void{
            var _local1:Graphics;
            super.createChildren();
            createBorder();
            if (!maskShape){
                maskShape = new FlexShape();
                maskShape.name = "mask";
                _local1 = maskShape.graphics;
                _local1.beginFill(0xFFFFFF);
                _local1.drawRect(0, 0, 10, 10);
                _local1.endFill();
                addChild(maskShape);
            };
            maskShape.visible = false;
        }
        override public function styleChanged(_arg1:String):void{
            var _local3:String;
            var _local4:String;
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if (((_local2) || ((_arg1 == "horizontalScrollBarStyleName")))){
                if (horizontalScrollBar){
                    _local3 = getStyle("horizontalScrollBarStyleName");
                    horizontalScrollBar.styleName = _local3;
                };
            };
            if (((_local2) || ((_arg1 == "verticalScrollBarStyleName")))){
                if (verticalScrollBar){
                    _local4 = getStyle("verticalScrollBarStyleName");
                    verticalScrollBar.styleName = _local4;
                };
            };
            if (((_local2) || ((_arg1 == "borderSkin")))){
                if (border){
                    removeChild(DisplayObject(border));
                    border = null;
                    createBorder();
                };
            };
        }
        private function createVScrollBar(_arg1:Boolean):ScrollBar{
            verticalScrollBar = new VScrollBar();
            verticalScrollBar.visible = _arg1;
            verticalScrollBar.enabled = enabled;
            var _local2:String = getStyle("verticalScrollBarStyleName");
            verticalScrollBar.styleName = _local2;
            addChild(verticalScrollBar);
            return (verticalScrollBar);
        }
        mx_internal function get scroll_verticalScrollBar():ScrollBar{
            return (verticalScrollBar);
        }
        protected function createBorder():void{
            var _local1:Class;
            if (((!(border)) && (isBorderNeeded()))){
                _local1 = getStyle("borderSkin");
                if (_local1 != null){
                    border = new (_local1)();
                    if ((border is IUIComponent)){
                        IUIComponent(border).enabled = enabled;
                    };
                    if ((border is ISimpleStyleClient)){
                        ISimpleStyleClient(border).styleName = this;
                    };
                    addChildAt(DisplayObject(border), 0);
                    invalidateDisplayList();
                };
            };
        }
        mx_internal function get scroll_horizontalScrollBar():ScrollBar{
            return (horizontalScrollBar);
        }
        protected function layoutChrome(_arg1:Number, _arg2:Number):void{
            if (border){
                border.move(0, 0);
                border.setActualSize(_arg1, _arg2);
            };
        }
        protected function scrollHandler(_arg1:Event):void{
            var _local2:ScrollBar;
            var _local3:Number;
            var _local4:QName;
            if ((_arg1 is ScrollEvent)){
                _local2 = ScrollBar(_arg1.target);
                _local3 = _local2.scrollPosition;
                if (_local2 == verticalScrollBar){
                    _local4 = new QName(mx_internal, "_verticalScrollPosition");
                } else {
                    if (_local2 == horizontalScrollBar){
                        _local4 = new QName(mx_internal, "_horizontalScrollPosition");
                    };
                };
                dispatchEvent(_arg1);
                if (_local4){
                    this[_local4] = _local3;
                };
            };
        }
        protected function mouseWheelHandler(_arg1:MouseEvent):void{
            var _local2:int;
            var _local3:Number;
            var _local4:Number;
            var _local5:ScrollEvent;
            if (((verticalScrollBar) && (verticalScrollBar.visible))){
                _arg1.stopPropagation();
                _local2 = (((_arg1.delta <= 0)) ? 1 : -1);
                _local3 = Math.max(Math.abs(_arg1.delta), verticalScrollBar.lineScrollSize);
                _local4 = verticalScrollPosition;
                verticalScrollPosition = (verticalScrollPosition + ((3 * _local3) * _local2));
                _local5 = new ScrollEvent(ScrollEvent.SCROLL);
                _local5.direction = ScrollEventDirection.VERTICAL;
                _local5.position = verticalScrollPosition;
                _local5.delta = (verticalScrollPosition - _local4);
                dispatchEvent(_local5);
            };
        }
        private function scrollTipHandler(_arg1:Event):void{
            var _local2:ScrollBar;
            var _local3:Boolean;
            var _local4:String;
            var _local5:Number;
            var _local6:String;
            var _local7:Point;
            if ((_arg1 is ScrollEvent)){
                if (!showScrollTips){
                    return;
                };
                if (ScrollEvent(_arg1).detail == ScrollEventDetail.THUMB_POSITION){
                    if (scrollTip){
                        systemManager.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", (scrollTip as DisplayObject));
                        scrollTip = null;
                        ToolTipManager.enabled = oldTTMEnabled;
                    };
                } else {
                    if (ScrollEvent(_arg1).detail == ScrollEventDetail.THUMB_TRACK){
                        _local2 = ScrollBar(_arg1.target);
                        _local3 = (_local2 == verticalScrollBar);
                        _local4 = ((_local3) ? "vertical" : "horizontal");
                        _local5 = _local2.scrollPosition;
                        if (!scrollTip){
                            scrollTip = new ToolTip();
                            systemManager.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", (scrollTip as DisplayObject));
                            scrollThumbMidPoint = (_local2.scrollThumb.height / 2);
                            oldTTMEnabled = ToolTipManager.enabled;
                            ToolTipManager.enabled = false;
                        };
                        _local6 = _local5.toString();
                        if (_scrollTipFunction != null){
                            _local6 = _scrollTipFunction(_local4, _local5);
                        };
                        if (_local6 == ""){
                            scrollTip.visible = false;
                        } else {
                            scrollTip.text = _local6;
                            ToolTipManager.sizeTip(scrollTip);
                            _local7 = new Point();
                            if (_local3){
                                _local7.x = (-3 - scrollTip.width);
                                _local7.y = ((_local2.scrollThumb.y + scrollThumbMidPoint) - (scrollTip.height / 2));
                            } else {
                                _local7.x = (-3 - scrollTip.height);
                                _local7.y = ((_local2.scrollThumb.y + scrollThumbMidPoint) - (scrollTip.width / 2));
                            };
                            _local7 = _local2.localToGlobal(_local7);
                            scrollTip.move(_local7.x, _local7.y);
                            scrollTip.visible = true;
                        };
                    };
                };
            };
        }
        public function set verticalScrollPosition(_arg1:Number):void{
            _verticalScrollPosition = _arg1;
            if (verticalScrollBar){
                verticalScrollBar.scrollPosition = _arg1;
            };
            dispatchEvent(new Event("viewChanged"));
        }
        public function get horizontalScrollPosition():Number{
            return (_horizontalScrollPosition);
        }
        private function isBorderNeeded():Boolean{
            var _local1:Object = getStyle("borderStyle");
            if (_local1){
                if (((!((_local1 == "none"))) || ((((_local1 == "none")) && (getStyle("mouseShield")))))){
                    return (true);
                };
            };
            _local1 = getStyle("backgroundColor");
            if (((!((_local1 === null))) && (!((_local1 === ""))))){
                return (true);
            };
            _local1 = getStyle("backgroundImage");
            return (((!((_local1 == null))) && (!((_local1 == "")))));
        }
        public function get maxHorizontalScrollPosition():Number{
            if (!isNaN(_maxHorizontalScrollPosition)){
                return (_maxHorizontalScrollPosition);
            };
            var _local1:Number = ((horizontalScrollBar) ? horizontalScrollBar.maxScrollPosition : 0);
            return (_local1);
        }
        public function set maxVerticalScrollPosition(_arg1:Number):void{
            _maxVerticalScrollPosition = _arg1;
            dispatchEvent(new Event("maxVerticalScrollPositionChanged"));
        }
        public function set verticalScrollPolicy(_arg1:String):void{
            var _local2:String = _arg1.toLowerCase();
            if (_verticalScrollPolicy != _local2){
                _verticalScrollPolicy = _local2;
                invalidateDisplayList();
                dispatchEvent(new Event("verticalScrollPolicyChanged"));
            };
        }
        public function get viewMetrics():EdgeMetrics{
            _viewMetrics = borderMetrics.clone();
            if (((!(horizontalScrollBar)) && ((horizontalScrollPolicy == ScrollPolicy.ON)))){
                createHScrollBar(true);
                horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler);
                horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollTipHandler);
                horizontalScrollBar.scrollPosition = _horizontalScrollPosition;
                invalidateDisplayList();
            };
            if (((!(verticalScrollBar)) && ((verticalScrollPolicy == ScrollPolicy.ON)))){
                createVScrollBar(true);
                verticalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollHandler);
                verticalScrollBar.addEventListener(ScrollEvent.SCROLL, scrollTipHandler);
                verticalScrollBar.scrollPosition = _verticalScrollPosition;
                invalidateDisplayList();
            };
            if (((verticalScrollBar) && (verticalScrollBar.visible))){
                _viewMetrics.right = (_viewMetrics.right + verticalScrollBar.minWidth);
            };
            if (((horizontalScrollBar) && (horizontalScrollBar.visible))){
                _viewMetrics.bottom = (_viewMetrics.bottom + horizontalScrollBar.minHeight);
            };
            return (_viewMetrics);
        }
        public function get verticalScrollPolicy():String{
            return (_verticalScrollPolicy);
        }
        public function get borderMetrics():EdgeMetrics{
            return (((((border) && ((border is IRectangularBorder)))) ? IRectangularBorder(border).borderMetrics : EdgeMetrics.EMPTY));
        }

    }
}//package mx.core 
