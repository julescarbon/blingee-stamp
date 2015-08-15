package mx.controls.scrollClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import flash.utils.*;
    import flash.ui.*;

    public class ScrollBar extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const THICKNESS:Number = 16;

        private var _direction:String = "vertical";
        private var _pageScrollSize:Number = 0;
        mx_internal var scrollTrack:Button;
        mx_internal var downArrow:Button;
        mx_internal var scrollThumb:ScrollThumb;
        private var trackScrollRepeatDirection:int;
        private var _minScrollPosition:Number = 0;
        private var trackPosition:Number;
        private var _pageSize:Number = 0;
        mx_internal var _minHeight:Number = 32;
        private var _maxScrollPosition:Number = 0;
        private var trackScrollTimer:Timer;
        mx_internal var upArrow:Button;
        private var _lineScrollSize:Number = 1;
        private var _scrollPosition:Number = 0;
        private var trackScrolling:Boolean = false;
        mx_internal var isScrolling:Boolean;
        mx_internal var oldPosition:Number;
        mx_internal var _minWidth:Number = 16;

        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            invalidateDisplayList();
        }
        public function set lineScrollSize(_arg1:Number):void{
            _lineScrollSize = _arg1;
        }
        public function get minScrollPosition():Number{
            return (_minScrollPosition);
        }
        mx_internal function dispatchScrollEvent(_arg1:Number, _arg2:String):void{
            var _local3:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
            _local3.detail = _arg2;
            _local3.position = scrollPosition;
            _local3.delta = (scrollPosition - _arg1);
            _local3.direction = direction;
            dispatchEvent(_local3);
        }
        private function downArrow_buttonDownHandler(_arg1:FlexEvent):void{
            if (isNaN(oldPosition)){
                oldPosition = scrollPosition;
            };
            lineScroll(1);
        }
        private function scrollTrack_mouseDownHandler(_arg1:MouseEvent):void{
            if (!(((_arg1.target == this)) || ((_arg1.target == scrollTrack)))){
                return;
            };
            trackScrolling = true;
            var _local2:DisplayObject = systemManager.getSandboxRoot();
            _local2.addEventListener(MouseEvent.MOUSE_UP, scrollTrack_mouseUpHandler, true);
            _local2.addEventListener(MouseEvent.MOUSE_MOVE, scrollTrack_mouseMoveHandler, true);
            _local2.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, scrollTrack_mouseLeaveHandler);
            systemManager.deployMouseShields(true);
            var _local3:Point = new Point(_arg1.localX, _arg1.localY);
            _local3 = _arg1.target.localToGlobal(_local3);
            _local3 = globalToLocal(_local3);
            trackPosition = _local3.y;
            if (isNaN(oldPosition)){
                oldPosition = scrollPosition;
            };
            trackScrollRepeatDirection = ((((scrollThumb.y + scrollThumb.height) < _local3.y)) ? 1 : (((scrollThumb.y > _local3.y)) ? -1 : 0));
            pageScroll(trackScrollRepeatDirection);
            if (!trackScrollTimer){
                trackScrollTimer = new Timer(getStyle("repeatDelay"), 1);
                trackScrollTimer.addEventListener(TimerEvent.TIMER, trackScrollTimerHandler);
            };
            trackScrollTimer.start();
        }
        public function set minScrollPosition(_arg1:Number):void{
            _minScrollPosition = _arg1;
            invalidateDisplayList();
        }
        public function get scrollPosition():Number{
            return (_scrollPosition);
        }
        mx_internal function get linePlusDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.LINE_DOWN : ScrollEventDetail.LINE_RIGHT));
        }
        public function get maxScrollPosition():Number{
            return (_maxScrollPosition);
        }
        protected function get thumbStyleFilters():Object{
            return (null);
        }
        override public function set doubleClickEnabled(_arg1:Boolean):void{
        }
        public function get lineScrollSize():Number{
            return (_lineScrollSize);
        }
        mx_internal function get virtualHeight():Number{
            return (unscaledHeight);
        }
        public function set scrollPosition(_arg1:Number):void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            _scrollPosition = _arg1;
            if (scrollThumb){
                if (!cacheAsBitmap){
                    cacheHeuristic = (scrollThumb.cacheHeuristic = true);
                };
                if (!isScrolling){
                    _arg1 = Math.min(_arg1, maxScrollPosition);
                    _arg1 = Math.max(_arg1, minScrollPosition);
                    _local2 = (maxScrollPosition - minScrollPosition);
                    _local3 = (((((_local2 == 0)) || (isNaN(_local2)))) ? 0 : ((((_arg1 - minScrollPosition) * (trackHeight - scrollThumb.height)) / _local2) + trackY));
                    _local4 = (((virtualWidth - scrollThumb.width) / 2) + getStyle("thumbOffset"));
                    scrollThumb.move(Math.round(_local4), Math.round(_local3));
                };
            };
        }
        protected function get downArrowStyleFilters():Object{
            return (null);
        }
        public function get pageSize():Number{
            return (_pageSize);
        }
        public function set pageScrollSize(_arg1:Number):void{
            _pageScrollSize = _arg1;
        }
        public function set maxScrollPosition(_arg1:Number):void{
            _maxScrollPosition = _arg1;
            invalidateDisplayList();
        }
        mx_internal function pageScroll(_arg1:int):void{
            var _local4:Number;
            var _local5:String;
            var _local2:Number = ((_pageScrollSize)!=0) ? _pageScrollSize : pageSize;
            var _local3:Number = (_scrollPosition + (_arg1 * _local2));
            if (_local3 > maxScrollPosition){
                _local3 = maxScrollPosition;
            } else {
                if (_local3 < minScrollPosition){
                    _local3 = minScrollPosition;
                };
            };
            if (_local3 != scrollPosition){
                _local4 = scrollPosition;
                scrollPosition = _local3;
                _local5 = (((_arg1 < 0)) ? pageMinusDetail : pagePlusDetail);
                dispatchScrollEvent(_local4, _local5);
            };
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!scrollTrack){
                scrollTrack = new Button();
                scrollTrack.focusEnabled = false;
                scrollTrack.skinName = "trackSkin";
                scrollTrack.upSkinName = "trackUpSkin";
                scrollTrack.overSkinName = "trackOverSkin";
                scrollTrack.downSkinName = "trackDownSkin";
                scrollTrack.disabledSkinName = "trackDisabledSkin";
                if ((scrollTrack is ISimpleStyleClient)){
                    ISimpleStyleClient(scrollTrack).styleName = this;
                };
                addChild(scrollTrack);
                scrollTrack.validateProperties();
            };
            if (!upArrow){
                upArrow = new Button();
                upArrow.enabled = false;
                upArrow.autoRepeat = true;
                upArrow.focusEnabled = false;
                upArrow.upSkinName = "upArrowUpSkin";
                upArrow.overSkinName = "upArrowOverSkin";
                upArrow.downSkinName = "upArrowDownSkin";
                upArrow.disabledSkinName = "upArrowDisabledSkin";
                upArrow.skinName = "upArrowSkin";
                upArrow.upIconName = "";
                upArrow.overIconName = "";
                upArrow.downIconName = "";
                upArrow.disabledIconName = "";
                addChild(upArrow);
                upArrow.styleName = new StyleProxy(this, upArrowStyleFilters);
                upArrow.validateProperties();
                upArrow.addEventListener(FlexEvent.BUTTON_DOWN, upArrow_buttonDownHandler);
            };
            if (!downArrow){
                downArrow = new Button();
                downArrow.enabled = false;
                downArrow.autoRepeat = true;
                downArrow.focusEnabled = false;
                downArrow.upSkinName = "downArrowUpSkin";
                downArrow.overSkinName = "downArrowOverSkin";
                downArrow.downSkinName = "downArrowDownSkin";
                downArrow.disabledSkinName = "downArrowDisabledSkin";
                downArrow.skinName = "downArrowSkin";
                downArrow.upIconName = "";
                downArrow.overIconName = "";
                downArrow.downIconName = "";
                downArrow.disabledIconName = "";
                addChild(downArrow);
                downArrow.styleName = new StyleProxy(this, downArrowStyleFilters);
                downArrow.validateProperties();
                downArrow.addEventListener(FlexEvent.BUTTON_DOWN, downArrow_buttonDownHandler);
            };
        }
        private function scrollTrack_mouseOverHandler(_arg1:MouseEvent):void{
            if (!(((_arg1.target == this)) || ((_arg1.target == scrollTrack)))){
                return;
            };
            if (trackScrolling){
                trackScrollTimer.start();
            };
        }
        private function get minDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.AT_TOP : ScrollEventDetail.AT_LEFT));
        }
        mx_internal function isScrollBarKey(_arg1:uint):Boolean{
            var _local2:Number;
            if (_arg1 == Keyboard.HOME){
                if (scrollPosition != 0){
                    _local2 = scrollPosition;
                    scrollPosition = 0;
                    dispatchScrollEvent(_local2, minDetail);
                };
                return (true);
            };
            if (_arg1 == Keyboard.END){
                if (scrollPosition < maxScrollPosition){
                    _local2 = scrollPosition;
                    scrollPosition = maxScrollPosition;
                    dispatchScrollEvent(_local2, maxDetail);
                };
                return (true);
            };
            return (false);
        }
        mx_internal function get lineMinusDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.LINE_UP : ScrollEventDetail.LINE_LEFT));
        }
        mx_internal function get pageMinusDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.PAGE_UP : ScrollEventDetail.PAGE_LEFT));
        }
        private function get maxDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.AT_BOTTOM : ScrollEventDetail.AT_RIGHT));
        }
        private function scrollTrack_mouseLeaveHandler(_arg1:Event):void{
            trackScrolling = false;
            var _local2:DisplayObject = systemManager.getSandboxRoot();
            _local2.removeEventListener(MouseEvent.MOUSE_UP, scrollTrack_mouseUpHandler, true);
            _local2.removeEventListener(MouseEvent.MOUSE_MOVE, scrollTrack_mouseMoveHandler, true);
            _local2.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, scrollTrack_mouseLeaveHandler);
            systemManager.deployMouseShields(false);
            if (trackScrollTimer){
                trackScrollTimer.reset();
            };
            if (_arg1.target != scrollTrack){
                return;
            };
            var _local3:String = (((oldPosition > scrollPosition)) ? pageMinusDetail : pagePlusDetail);
            dispatchScrollEvent(oldPosition, _local3);
            oldPosition = NaN;
        }
        protected function get upArrowStyleFilters():Object{
            return (null);
        }
        private function get trackHeight():Number{
            return ((virtualHeight - (upArrow.getExplicitOrMeasuredHeight() + downArrow.getExplicitOrMeasuredHeight())));
        }
        public function get pageScrollSize():Number{
            return (_pageScrollSize);
        }
        override protected function measure():void{
            super.measure();
            upArrow.validateSize();
            downArrow.validateSize();
            scrollTrack.validateSize();
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                _minWidth = ((scrollThumb) ? scrollThumb.getExplicitOrMeasuredWidth() : 0);
                _minWidth = Math.max(scrollTrack.getExplicitOrMeasuredWidth(), upArrow.getExplicitOrMeasuredWidth(), downArrow.getExplicitOrMeasuredWidth(), _minWidth);
            } else {
                _minWidth = upArrow.getExplicitOrMeasuredWidth();
            };
            _minHeight = (upArrow.getExplicitOrMeasuredHeight() + downArrow.getExplicitOrMeasuredHeight());
        }
        mx_internal function lineScroll(_arg1:int):void{
            var _local4:Number;
            var _local5:String;
            var _local2:Number = _lineScrollSize;
            var _local3:Number = (_scrollPosition + (_arg1 * _local2));
            if (_local3 > maxScrollPosition){
                _local3 = maxScrollPosition;
            } else {
                if (_local3 < minScrollPosition){
                    _local3 = minScrollPosition;
                };
            };
            if (_local3 != scrollPosition){
                _local4 = scrollPosition;
                scrollPosition = _local3;
                _local5 = (((_arg1 < 0)) ? lineMinusDetail : linePlusDetail);
                dispatchScrollEvent(_local4, _local5);
            };
        }
        public function setScrollProperties(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number=0):void{
            var _local5:Number;
            this.pageSize = _arg1;
            _pageScrollSize = ((_arg4)>0) ? _arg4 : _arg1;
            this.minScrollPosition = Math.max(_arg2, 0);
            this.maxScrollPosition = Math.max(_arg3, 0);
            _scrollPosition = Math.max(this.minScrollPosition, _scrollPosition);
            _scrollPosition = Math.min(this.maxScrollPosition, _scrollPosition);
            if (((((this.maxScrollPosition - this.minScrollPosition) > 0)) && (enabled))){
                upArrow.enabled = true;
                downArrow.enabled = true;
                scrollTrack.enabled = true;
                addEventListener(MouseEvent.MOUSE_DOWN, scrollTrack_mouseDownHandler);
                addEventListener(MouseEvent.MOUSE_OVER, scrollTrack_mouseOverHandler);
                addEventListener(MouseEvent.MOUSE_OUT, scrollTrack_mouseOutHandler);
                if (!scrollThumb){
                    scrollThumb = new ScrollThumb();
                    scrollThumb.focusEnabled = false;
                    addChildAt(scrollThumb, getChildIndex(downArrow));
                    scrollThumb.styleName = new StyleProxy(this, thumbStyleFilters);
                    scrollThumb.upSkinName = "thumbUpSkin";
                    scrollThumb.overSkinName = "thumbOverSkin";
                    scrollThumb.downSkinName = "thumbDownSkin";
                    scrollThumb.iconName = "thumbIcon";
                    scrollThumb.skinName = "thumbSkin";
                };
                _local5 = (((trackHeight < 0)) ? 0 : Math.round(((_arg1 / ((this.maxScrollPosition - this.minScrollPosition) + _arg1)) * trackHeight)));
                if (_local5 < scrollThumb.minHeight){
                    if (trackHeight < scrollThumb.minHeight){
                        scrollThumb.visible = false;
                    } else {
                        _local5 = scrollThumb.minHeight;
                        scrollThumb.visible = true;
                        scrollThumb.setActualSize(scrollThumb.measuredWidth, scrollThumb.minHeight);
                    };
                } else {
                    scrollThumb.visible = true;
                    scrollThumb.setActualSize(scrollThumb.measuredWidth, _local5);
                };
                scrollThumb.setRange((upArrow.getExplicitOrMeasuredHeight() + 0), ((virtualHeight - downArrow.getExplicitOrMeasuredHeight()) - scrollThumb.height), this.minScrollPosition, this.maxScrollPosition);
                scrollPosition = Math.max(Math.min(scrollPosition, this.maxScrollPosition), this.minScrollPosition);
            } else {
                upArrow.enabled = false;
                downArrow.enabled = false;
                scrollTrack.enabled = false;
                if (scrollThumb){
                    scrollThumb.visible = false;
                };
            };
        }
        private function trackScrollTimerHandler(_arg1:Event):void{
            if (trackScrollRepeatDirection == 1){
                if ((scrollThumb.y + scrollThumb.height) > trackPosition){
                    return;
                };
            };
            if (trackScrollRepeatDirection == -1){
                if (scrollThumb.y < trackPosition){
                    return;
                };
            };
            pageScroll(trackScrollRepeatDirection);
            if (((trackScrollTimer) && ((trackScrollTimer.repeatCount == 1)))){
                trackScrollTimer.delay = getStyle("repeatInterval");
                trackScrollTimer.repeatCount = 0;
            };
        }
        private function upArrow_buttonDownHandler(_arg1:FlexEvent):void{
            if (isNaN(oldPosition)){
                oldPosition = scrollPosition;
            };
            lineScroll(-1);
        }
        public function set pageSize(_arg1:Number):void{
            _pageSize = _arg1;
        }
        private function get trackY():Number{
            return (upArrow.getExplicitOrMeasuredHeight());
        }
        private function scrollTrack_mouseOutHandler(_arg1:MouseEvent):void{
            if (trackScrolling){
                trackScrollTimer.stop();
            };
        }
        private function scrollTrack_mouseUpHandler(_arg1:MouseEvent):void{
            scrollTrack_mouseLeaveHandler(_arg1);
        }
        private function scrollTrack_mouseMoveHandler(_arg1:MouseEvent):void{
            var _local2:Point;
            if (trackScrolling){
                _local2 = new Point(_arg1.stageX, _arg1.stageY);
                _local2 = globalToLocal(_local2);
                trackPosition = _local2.y;
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            if ($height == 1){
                return;
            };
            if (!upArrow){
                return;
            };
            super.updateDisplayList(_arg1, _arg2);
            if (cacheAsBitmap){
                cacheHeuristic = (scrollThumb.cacheHeuristic = false);
            };
            upArrow.setActualSize(upArrow.getExplicitOrMeasuredWidth(), upArrow.getExplicitOrMeasuredHeight());
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                upArrow.move(((virtualWidth - upArrow.width) / 2), 0);
            } else {
                upArrow.move(0, 0);
            };
            scrollTrack.setActualSize(scrollTrack.getExplicitOrMeasuredWidth(), virtualHeight);
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                scrollTrack.x = ((virtualWidth - scrollTrack.width) / 2);
            };
            scrollTrack.y = 0;
            downArrow.setActualSize(downArrow.getExplicitOrMeasuredWidth(), downArrow.getExplicitOrMeasuredHeight());
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0){
                downArrow.move(((virtualWidth - downArrow.width) / 2), (virtualHeight - downArrow.getExplicitOrMeasuredHeight()));
            } else {
                downArrow.move(0, (virtualHeight - downArrow.getExplicitOrMeasuredHeight()));
            };
            setScrollProperties(pageSize, minScrollPosition, maxScrollPosition, _pageScrollSize);
            scrollPosition = _scrollPosition;
        }
        mx_internal function get pagePlusDetail():String{
            return ((((direction == ScrollBarDirection.VERTICAL)) ? ScrollEventDetail.PAGE_DOWN : ScrollEventDetail.PAGE_RIGHT));
        }
        mx_internal function get virtualWidth():Number{
            return (unscaledWidth);
        }
        public function set direction(_arg1:String):void{
            _direction = _arg1;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("directionChanged"));
        }
        public function get direction():String{
            return (_direction);
        }

    }
}//package mx.controls.scrollClasses 
