package flexlib.containers {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.containers.*;
    import flash.utils.*;

    public class ButtonScrollingCanvas extends Canvas {

        protected static var DEFAULT_DOWN_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_DOWN_BUTTON;
        protected static var DEFAULT_RIGHT_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_RIGHT_BUTTON;
        public static var DEFAULT_BUTTON_WIDTH:Number = 50;
        protected static var DEFAULT_UP_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_UP_BUTTON;
        protected static var DEFAULT_LEFT_BUTTON:Class = ButtonScrollingCanvas_DEFAULT_LEFT_BUTTON;

        protected var leftButton:Button;
        public var scrollJump:Number = 10;
        protected var _childrenCreated:Boolean = false;
        protected var upButton:Button;
        protected var _explicitButtonHeight:Number;
        protected var timer:Timer;
        protected var innerCanvas:Canvas;
        protected var _stopScrollingEvent:String = "mouseUp";
        protected var rightButton:Button;
        protected var _startScrollingEvent:String = "mouseDown";
        protected var downButton:Button;
        public var scrollSpeed:Number = 10;

        protected static function initializeStyles():void{
            var selector:* = StyleManager.getStyleDeclaration("ButtonScrollingCanvas");
            if (!selector){
                selector = new CSSStyleDeclaration();
            };
            selector.defaultFactory = function ():void{
                this.upButtonStyleName = "upButton";
                this.downButtonStyleName = "downButton";
                this.leftButtonStyleName = "leftButton";
                this.rightButtonStyleName = "rightButton";
            };
            StyleManager.setStyleDeclaration("ButtonScrollingCanvas", selector, false);
            var upStyleName:* = selector.getStyle("upButtonStyleName");
            var upSelector:* = StyleManager.getStyleDeclaration(("." + upStyleName));
            if (!upSelector){
                upSelector = new CSSStyleDeclaration();
            };
            upSelector.defaultFactory = function ():void{
                this.icon = DEFAULT_UP_BUTTON;
                this.fillAlphas = [1, 1, 1, 1];
                this.cornerRadius = 0;
            };
            StyleManager.setStyleDeclaration(("." + upStyleName), upSelector, false);
            var downStyleName:* = selector.getStyle("downButtonStyleName");
            var downSelector:* = StyleManager.getStyleDeclaration(("." + downStyleName));
            if (!downSelector){
                downSelector = new CSSStyleDeclaration();
            };
            downSelector.defaultFactory = function ():void{
                this.icon = DEFAULT_DOWN_BUTTON;
                this.fillAlphas = [1, 1, 1, 1];
                this.cornerRadius = 0;
            };
            StyleManager.setStyleDeclaration(("." + downStyleName), downSelector, false);
            var leftStyleName:* = selector.getStyle("leftButtonStyleName");
            var leftSelector:* = StyleManager.getStyleDeclaration(("." + leftStyleName));
            if (!leftSelector){
                leftSelector = new CSSStyleDeclaration();
            };
            leftSelector.defaultFactory = function ():void{
                this.icon = DEFAULT_LEFT_BUTTON;
                this.fillAlphas = [1, 1, 1, 1];
                this.cornerRadius = 0;
            };
            StyleManager.setStyleDeclaration(("." + leftStyleName), leftSelector, false);
            var rightStyleName:* = selector.getStyle("rightButtonStyleName");
            var rightSelector:* = StyleManager.getStyleDeclaration(("." + rightStyleName));
            if (!rightSelector){
                rightSelector = new CSSStyleDeclaration();
            };
            rightSelector.defaultFactory = function ():void{
                this.icon = DEFAULT_RIGHT_BUTTON;
                this.fillAlphas = [1, 1, 1, 1];
                this.cornerRadius = 0;
            };
            StyleManager.setStyleDeclaration(("." + rightStyleName), rightSelector, false);
        }

        protected function enableOrDisableButtons():void{
            if (this.horizontalScrollPolicy == ScrollPolicy.OFF){
                leftButton.visible = (rightButton.visible = (leftButton.includeInLayout = (rightButton.includeInLayout = false)));
            } else {
                leftButton.visible = (leftButton.enabled = (innerCanvas.horizontalScrollPosition > 0));
                rightButton.visible = (rightButton.enabled = (innerCanvas.horizontalScrollPosition < innerCanvas.maxHorizontalScrollPosition));
            };
            if (this.verticalScrollPolicy == ScrollPolicy.OFF){
                upButton.visible = (downButton.visible = (upButton.includeInLayout = (downButton.includeInLayout = false)));
            } else {
                upButton.visible = (upButton.enabled = (upButton.includeInLayout = (innerCanvas.verticalScrollPosition > 0)));
                downButton.visible = (downButton.enabled = (downButton.includeInLayout = (innerCanvas.verticalScrollPosition < innerCanvas.maxVerticalScrollPosition)));
            };
            positionButtons(this.width, this.height);
        }
        override public function addChild(_arg1:DisplayObject):DisplayObject{
            if (innerCanvas){
                return (innerCanvas.addChild(_arg1));
            };
            return (super.addChild(_arg1));
        }
        protected function scrollLeft(_arg1:TimerEvent):void{
            innerCanvas.horizontalScrollPosition = (innerCanvas.horizontalScrollPosition - scrollJump);
            enableOrDisableButtons();
        }
        public function set stopScrollingEvent(_arg1:String):void{
            _stopScrollingEvent = _arg1;
        }
        protected function scrollDown(_arg1:TimerEvent):void{
            innerCanvas.verticalScrollPosition = (innerCanvas.verticalScrollPosition + scrollJump);
            enableOrDisableButtons();
        }
        override public function initialize():void{
            super.initialize();
            ButtonScrollingCanvas.initializeStyles();
        }
        protected function positionButtons(_arg1:Number, _arg2:Number):void{
            var _local3:Number = this.buttonWidth;
            var _local4:Number = ((_explicitButtonHeight) ? _explicitButtonHeight : _arg2);
            leftButton.move(0, 0);
            leftButton.setActualSize(_local3, _local4);
            rightButton.move((_arg1 - _local3), 0);
            rightButton.setActualSize(_local3, _local4);
            upButton.move(_local3, 0);
            downButton.move(_local3, (_arg2 - _local3));
            upButton.setActualSize((_arg1 - (_local3 * 2)), _local3);
            downButton.setActualSize((_arg1 - (_local3 * 2)), _local3);
        }
        public function set explicitButtonHeight(_arg1:Number):void{
            this._explicitButtonHeight = _arg1;
            invalidateDisplayList();
        }
        protected function addListeners(_arg1:String):void{
            leftButton.addEventListener(_arg1, startScrollingLeft, false, 0, true);
            rightButton.addEventListener(_arg1, startScrollingRight, false, 0, true);
            upButton.addEventListener(_arg1, startScrollingUp, false, 0, true);
            downButton.addEventListener(_arg1, startScrollingDown, false, 0, true);
        }
        override protected function createChildren():void{
            super.createChildren();
            timer = new Timer(scrollSpeed);
            leftButton = new Button();
            rightButton = new Button();
            upButton = new Button();
            downButton = new Button();
            leftButton.styleName = getStyle("leftButtonStyleName");
            rightButton.styleName = getStyle("rightButtonStyleName");
            upButton.styleName = getStyle("upButtonStyleName");
            downButton.styleName = getStyle("downButtonStyleName");
            innerCanvas = new Canvas();
            innerCanvas.document = this.document;
            innerCanvas.horizontalScrollPolicy = ScrollPolicy.OFF;
            innerCanvas.verticalScrollPolicy = ScrollPolicy.OFF;
            innerCanvas.clipContent = true;
            while (this.numChildren > 0) {
                innerCanvas.addChild(this.removeChildAt(0));
            };
            rawChildren.addChild(innerCanvas);
            rawChildren.addChild(leftButton);
            rawChildren.addChild(rightButton);
            rawChildren.addChild(upButton);
            rawChildren.addChild(downButton);
            _childrenCreated = true;
            addListeners(_startScrollingEvent);
        }
        public function get startScrollingEvent():String{
            return (this._startScrollingEvent);
        }
        protected function startScrollingRight(_arg1:Event):void{
            if (!(_arg1.currentTarget as Button).enabled){
                return;
            };
            startScrolling(scrollRight, (_arg1.currentTarget as Button));
        }
        protected function stopScrolling(_arg1:Event):void{
            if (timer.running){
                timer.stop();
            };
        }
        override public function get verticalScrollPosition():Number{
            return (innerCanvas.verticalScrollPosition);
        }
        protected function startScrollingUp(_arg1:Event):void{
            if (!(_arg1.currentTarget as Button).enabled){
                return;
            };
            startScrolling(scrollUp, (_arg1.currentTarget as Button));
        }
        override public function get maxVerticalScrollPosition():Number{
            return (innerCanvas.maxVerticalScrollPosition);
        }
        override public function set horizontalScrollPosition(_arg1:Number):void{
            innerCanvas.horizontalScrollPosition = _arg1;
            callLater(enableOrDisableButtons);
        }
        public function get buttonWidth():Number{
            var _local1:Number = getStyle("buttonWidth");
            if (_local1){
                return (_local1);
            };
            return (ButtonScrollingCanvas.DEFAULT_BUTTON_WIDTH);
        }
        protected function removeListeners(_arg1:String):void{
            leftButton.removeEventListener(_arg1, startScrollingLeft);
            rightButton.removeEventListener(_arg1, startScrollingRight);
            upButton.removeEventListener(_arg1, startScrollingUp);
            downButton.removeEventListener(_arg1, startScrollingDown);
        }
        protected function startScrolling(_arg1:Function, _arg2:Button):void{
            if (_stopScrollingEvent == MouseEvent.MOUSE_UP){
                stage.addEventListener(_stopScrollingEvent, stopScrolling);
            } else {
                _arg2.addEventListener(_stopScrollingEvent, stopScrolling);
            };
            if (timer.running){
                timer.stop();
            };
            timer = new Timer(this.scrollSpeed);
            timer.addEventListener(TimerEvent.TIMER, _arg1);
            timer.start();
        }
        public function get stopScrollingEvent():String{
            return (this._stopScrollingEvent);
        }
        protected function scrollUp(_arg1:TimerEvent):void{
            innerCanvas.verticalScrollPosition = (innerCanvas.verticalScrollPosition - scrollJump);
            enableOrDisableButtons();
        }
        protected function scrollRight(_arg1:TimerEvent):void{
            innerCanvas.horizontalScrollPosition = (innerCanvas.horizontalScrollPosition + scrollJump);
            enableOrDisableButtons();
        }
        public function set startScrollingEvent(_arg1:String):void{
            if (_childrenCreated){
                removeListeners(_startScrollingEvent);
                addListeners(_arg1);
            };
            _startScrollingEvent = _arg1;
        }
        override public function get maxHorizontalScrollPosition():Number{
            return (innerCanvas.maxHorizontalScrollPosition);
        }
        override public function get horizontalScrollPosition():Number{
            return (innerCanvas.horizontalScrollPosition);
        }
        override public function set verticalScrollPosition(_arg1:Number):void{
            innerCanvas.verticalScrollPosition = _arg1;
            callLater(enableOrDisableButtons);
        }
        protected function startScrollingLeft(_arg1:Event):void{
            if (!(_arg1.currentTarget as Button).enabled){
                return;
            };
            startScrolling(scrollLeft, (_arg1.currentTarget as Button));
        }
        protected function startScrollingDown(_arg1:Event):void{
            if (!(_arg1.currentTarget as Button).enabled){
                return;
            };
            startScrolling(scrollDown, (_arg1.currentTarget as Button));
        }
        public function set buttonWidth(_arg1:Number):void{
            this.setStyle("buttonWidth", _arg1);
            invalidateDisplayList();
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            innerCanvas.setActualSize(_arg1, _arg2);
            positionButtons(_arg1, _arg2);
            callLater(enableOrDisableButtons);
        }

        initializeStyles();
    }
}//package flexlib.containers 
