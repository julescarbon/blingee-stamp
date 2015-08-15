package mx.controls.sliderClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;
    import mx.formatters.*;

    public class Slider extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;

        private var _enabled:Boolean;
        private var snapIntervalChanged:Boolean = false;
        private var _direction:String = "horizontal";
        private var _thumbClass:Class;
        private var _labels:Array;
        public var allowTrackClick:Boolean = true;
        private var valuesChanged:Boolean = false;
        mx_internal var keyInteraction:Boolean = false;
        private var directionChanged:Boolean = false;
        private var enabledChanged:Boolean = false;
        private var dataFormatter:NumberFormatter;
        private var track:IFlexDisplayObject;
        private var _values:Array;
        private var initValues:Boolean = true;
        public var liveDragging:Boolean = false;
        private var thumbs:UIComponent;
        private var _tickInterval:Number = 0;
        private var ticksChanged:Boolean = false;
        private var minimumSet:Boolean = false;
        private var ticks:UIComponent;
        private var _thumbCount:int = 1;
        private var labelObjects:UIComponent;
        public var allowThumbOverlap:Boolean = false;
        private var snapIntervalPrecision:int = -1;
        mx_internal var dataTip:SliderDataTip;
        private var _snapInterval:Number = 0;
        private var thumbsChanged:Boolean = true;
        private var _tabIndex:Number;
        private var _sliderDataTipClass:Class;
        private var tabIndexChanged:Boolean;
        private var _tickValues:Array;
        private var labelsChanged:Boolean = false;
        private var interactionClickTarget:String;
        private var trackHighlightChanged:Boolean = true;
        private var _minimum:Number = 0;
        public var showDataTip:Boolean = true;
        mx_internal var innerSlider:UIComponent;
        private var labelStyleChanged:Boolean = false;
        private var _dataTipFormatFunction:Function;
        private var trackHitArea:UIComponent;
        private var highlightTrack:IFlexDisplayObject;
        private var _maximum:Number = 10;

        public function Slider(){
            _labels = [];
            _thumbClass = SliderThumb;
            _sliderDataTipClass = SliderDataTip;
            _tickValues = [];
            _values = [0, 0];
            super();
            tabChildren = true;
        }
        public function get sliderThumbClass():Class{
            return (_thumbClass);
        }
        public function set sliderThumbClass(_arg1:Class):void{
            _thumbClass = _arg1;
            thumbsChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        public function set tickInterval(_arg1:Number):void{
            _tickInterval = _arg1;
            ticksChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        public function set direction(_arg1:String):void{
            _direction = _arg1;
            directionChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        public function get minimum():Number{
            return (_minimum);
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:int;
            var _local3:Boolean;
            var _local4:int;
            var _local5:SliderLabel;
            var _local6:String;
            var _local7:Number;
            super.commitProperties();
            if (trackHighlightChanged){
                trackHighlightChanged = false;
                if (getStyle("showTrackHighlight")){
                    createHighlightTrack();
                } else {
                    if (highlightTrack){
                        innerSlider.removeChild(DisplayObject(highlightTrack));
                        highlightTrack = null;
                    };
                };
            };
            if (directionChanged){
                directionChanged = false;
                _local3 = (_direction == SliderDirection.HORIZONTAL);
                if (_local3){
                    DisplayObject(innerSlider).rotation = 0;
                } else {
                    DisplayObject(innerSlider).rotation = -90;
                    innerSlider.y = unscaledHeight;
                };
                if (labelObjects){
                    _local4 = (labelObjects.numChildren - 1);
                    while (_local4 >= 0) {
                        _local5 = SliderLabel(labelObjects.getChildAt(_local4));
                        _local5.rotation = ((_local3) ? 0 : 90);
                        _local4--;
                    };
                };
            };
            if (((labelStyleChanged) && (!(labelsChanged)))){
                labelStyleChanged = false;
                if (labelObjects){
                    _local6 = getStyle("labelStyleName");
                    _local1 = labelObjects.numChildren;
                    _local2 = 0;
                    while (_local2 < _local1) {
                        ISimpleStyleClient(labelObjects.getChildAt(_local2)).styleName = _local6;
                        _local2++;
                    };
                };
            };
            if (ticksChanged){
                ticksChanged = false;
                createTicks();
            };
            if (labelsChanged){
                labelsChanged = false;
                createLabels();
            };
            if (thumbsChanged){
                thumbsChanged = false;
                createThumbs();
            };
            if (initValues){
                initValues = false;
                if (!valuesChanged){
                    _local7 = minimum;
                    _local1 = _thumbCount;
                    _local2 = 0;
                    while (_local2 < _local1) {
                        _values[_local2] = _local7;
                        setValueAt(_local7, _local2);
                        if (((_snapInterval) && (!((_snapInterval == 0))))){
                            _local7 = (_local7 + snapInterval);
                        } else {
                            _local7++;
                        };
                        _local2++;
                    };
                    snapIntervalChanged = false;
                };
            };
            if (snapIntervalChanged){
                snapIntervalChanged = false;
                if (!valuesChanged){
                    _local1 = thumbs.numChildren;
                    _local2 = 0;
                    while (_local2 < _local1) {
                        setValueAt(getValueFromX(SliderThumb(thumbs.getChildAt(_local2)).xPosition), _local2);
                        _local2++;
                    };
                };
            };
            if (valuesChanged){
                valuesChanged = false;
                _local1 = _thumbCount;
                _local2 = 0;
                while (_local2 < _local1) {
                    setValueAt(getValueFromX(getXFromValue(Math.min(Math.max(values[_local2], minimum), maximum))), _local2);
                    _local2++;
                };
            };
            if (enabledChanged){
                enabledChanged = false;
                _local1 = thumbs.numChildren;
                _local2 = 0;
                while (_local2 < _local1) {
                    SliderThumb(thumbs.getChildAt(_local2)).enabled = _enabled;
                    _local2++;
                };
                _local1 = ((labelObjects) ? labelObjects.numChildren : 0);
                _local2 = 0;
                while (_local2 < _local1) {
                    SliderLabel(labelObjects.getChildAt(_local2)).enabled = _enabled;
                    _local2++;
                };
            };
            if (tabIndexChanged){
                tabIndexChanged = false;
                _local1 = thumbs.numChildren;
                _local2 = 0;
                while (_local2 < _local1) {
                    SliderThumb(thumbs.getChildAt(_local2)).tabIndex = _tabIndex;
                    _local2++;
                };
            };
        }
        mx_internal function getSnapValue(_arg1:Number, _arg2:SliderThumb=null):Number{
            var _local3:Number;
            var _local4:Boolean;
            var _local5:Object;
            var _local6:SliderThumb;
            var _local7:SliderThumb;
            if (((!(isNaN(_snapInterval))) && (!((_snapInterval == 0))))){
                _local3 = getValueFromX(_arg1);
                if (((((_arg2) && ((thumbs.numChildren > 1)))) && (!(allowThumbOverlap)))){
                    _local4 = true;
                    _local5 = getXBounds(_arg2.thumbIndex);
                    _local6 = (((_arg2.thumbIndex > 0)) ? SliderThumb(thumbs.getChildAt((_arg2.thumbIndex - 1))) : null);
                    _local7 = ((((_arg2.thumbIndex + 1) < thumbs.numChildren)) ? SliderThumb(thumbs.getChildAt((_arg2.thumbIndex + 1))) : null);
                    if (_local6){
                        _local5.min = (_local5.min - (_local6.width / 2));
                        if (_local3 == minimum){
                            if (getValueFromX((_local6.xPosition - (_local6.width / 2))) != minimum){
                                _local4 = false;
                            };
                        };
                    } else {
                        if (_local3 == minimum){
                            _local4 = false;
                        };
                    };
                    if (_local7){
                        _local5.max = (_local5.max + (_local7.width / 2));
                        if (_local3 == maximum){
                            if (getValueFromX((_local7.xPosition + (_local7.width / 2))) != maximum){
                                _local4 = false;
                            };
                        };
                    } else {
                        if (_local3 == maximum){
                            _local4 = false;
                        };
                    };
                    if (_local4){
                        _local3 = Math.min(Math.max(_local3, (getValueFromX(Math.round(_local5.min)) + _snapInterval)), (getValueFromX(Math.round(_local5.max)) - _snapInterval));
                    };
                };
                return (getXFromValue(_local3));
            };
            return (_arg1);
        }
        private function createHighlightTrack():void{
            var _local2:Class;
            var _local1:Boolean = getStyle("showTrackHighlight");
            if (((!(highlightTrack)) && (_local1))){
                _local2 = getStyle("trackHighlightSkin");
                highlightTrack = new (_local2)();
                if ((highlightTrack is ISimpleStyleClient)){
                    ISimpleStyleClient(highlightTrack).styleName = this;
                };
                innerSlider.addChildAt(DisplayObject(highlightTrack), (innerSlider.getChildIndex(DisplayObject(track)) + 1));
            };
        }
        mx_internal function drawTrackHighlight():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:SliderThumb;
            var _local4:SliderThumb;
            if (highlightTrack){
                _local3 = SliderThumb(thumbs.getChildAt(0));
                if (_thumbCount > 1){
                    _local1 = _local3.xPosition;
                    _local4 = SliderThumb(thumbs.getChildAt(1));
                    _local2 = (_local4.xPosition - _local3.xPosition);
                } else {
                    _local1 = track.x;
                    _local2 = (_local3.xPosition - _local1);
                };
                highlightTrack.move(_local1, (track.y + 1));
                highlightTrack.setActualSize((((_local2 > 0)) ? _local2 : 0), highlightTrack.height);
            };
        }
        mx_internal function getXBounds(_arg1:int):Object{
            var _local2:Number = (track.x + track.width);
            var _local3:Number = track.x;
            if (allowThumbOverlap){
                return ({
                    max:_local2,
                    min:_local3
                });
            };
            var _local4:Number = NaN;
            var _local5:Number = NaN;
            var _local6:SliderThumb = (((_arg1 > 0)) ? SliderThumb(thumbs.getChildAt((_arg1 - 1))) : null);
            var _local7:SliderThumb = ((((_arg1 + 1) < thumbs.numChildren)) ? SliderThumb(thumbs.getChildAt((_arg1 + 1))) : null);
            if (_local6){
                _local4 = (_local6.xPosition + (_local6.width / 2));
            };
            if (_local7){
                _local5 = (_local7.xPosition - (_local7.width / 2));
            };
            if (isNaN(_local4)){
                _local4 = _local3;
            } else {
                _local4 = Math.min(Math.max(_local3, _local4), _local2);
            };
            if (isNaN(_local5)){
                _local5 = _local2;
            } else {
                _local5 = Math.max(Math.min(_local2, _local5), _local3);
            };
            return ({
                max:_local5,
                min:_local4
            });
        }
        protected function get thumbStyleFilters():Object{
            return (null);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local11:Number;
            var _local23:SliderLabel;
            var _local24:SliderLabel;
            var _local25:SliderThumb;
            super.updateDisplayList(_arg1, _arg2);
            var _local3 = (_direction == SliderDirection.HORIZONTAL);
            var _local4:int = ((labelObjects) ? labelObjects.numChildren : 0);
            var _local5:int = ((thumbs) ? thumbs.numChildren : 0);
            var _local6:Number = getStyle("trackMargin");
            var _local7:Number = 6;
            var _local8:SliderThumb = SliderThumb(thumbs.getChildAt(0));
            if (((thumbs) && (_local8))){
                _local7 = _local8.getExplicitOrMeasuredWidth();
            };
            var _local9:Number = (_local7 / 2);
            var _local10:Number = _local9;
            var _local12:Number = 0;
            if (_local4 > 0){
                _local23 = SliderLabel(labelObjects.getChildAt(0));
                _local12 = ((_local3) ? _local23.getExplicitOrMeasuredWidth() : _local23.getExplicitOrMeasuredHeight());
            };
            var _local13:Number = 0;
            if (_local4 > 1){
                _local24 = SliderLabel(labelObjects.getChildAt((_local4 - 1)));
                _local13 = ((_local3) ? _local24.getExplicitOrMeasuredWidth() : _local24.getExplicitOrMeasuredHeight());
            };
            if (!isNaN(_local6)){
                _local11 = _local6;
            } else {
                _local11 = ((_local12 + _local13) / 2);
            };
            if (_local4 > 0){
                if (!isNaN(_local6)){
                    _local9 = Math.max(_local9, (_local11 / (((_local4 > 1)) ? 2 : 1)));
                } else {
                    _local9 = Math.max(_local9, (_local12 / 2));
                };
            } else {
                _local9 = Math.max(_local9, (_local11 / 2));
            };
            var _local14:Object = getComponentBounds();
            var _local15:Number = (((((_local3) ? _arg2 : _arg1) - (Number(_local14.lower) - Number(_local14.upper))) / 2) - Number(_local14.upper));
            track.move(Math.round(_local9), Math.round(_local15));
            track.setActualSize((((_local3) ? _arg1 : _arg2) - (_local9 * 2)), track.height);
            var _local16:Number = ((track.y + ((track.height - _local8.getExplicitOrMeasuredHeight()) / 2)) + getStyle("thumbOffset"));
            var _local17:int = _thumbCount;
            var _local18:int;
            while (_local18 < _local17) {
                _local25 = SliderThumb(thumbs.getChildAt(_local18));
                SliderThumb(thumbs.getChildAt(_local18)).move(_local25.x, _local16);
                _local25.visible = true;
                _local25.setActualSize(_local25.getExplicitOrMeasuredWidth(), _local25.getExplicitOrMeasuredHeight());
                _local18++;
            };
            var _local19:Graphics = trackHitArea.graphics;
            var _local20:Number = 0;
            if ((((_tickInterval > 0)) || (((_tickValues) && ((_tickValues.length > 0)))))){
                _local20 = getStyle("tickLength");
            };
            _local19.clear();
            _local19.beginFill(0, 0);
            var _local21:Number = _local8.getExplicitOrMeasuredHeight();
            var _local22:Number = ((_local21) ? (_local21 / 2) : 0);
            _local19.drawRect(track.x, ((track.y - _local22) - _local20), track.width, ((track.height + _local21) + _local20));
            _local19.endFill();
            if (_direction != SliderDirection.HORIZONTAL){
                innerSlider.y = _arg2;
            };
            layoutTicks();
            layoutLabels();
            setPosFromValue();
            drawTrackHighlight();
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!innerSlider){
                innerSlider = new UIComponent();
                UIComponent(innerSlider).tabChildren = true;
                addChild(innerSlider);
            };
            createBackgroundTrack();
            if (!trackHitArea){
                trackHitArea = new UIComponent();
                innerSlider.addChild(trackHitArea);
                trackHitArea.addEventListener(MouseEvent.MOUSE_DOWN, track_mouseDownHandler);
            };
            invalidateProperties();
        }
        public function set minimum(_arg1:Number):void{
            _minimum = _arg1;
            ticksChanged = true;
            if (!initValues){
                valuesChanged = true;
            };
            invalidateProperties();
            invalidateDisplayList();
        }
        public function get tickValues():Array{
            return (_tickValues);
        }
        public function get maximum():Number{
            return (_maximum);
        }
        private function createBackgroundTrack():void{
            var _local1:Class;
            if (!track){
                _local1 = getStyle("trackSkin");
                track = new (_local1)();
                if ((track is ISimpleStyleClient)){
                    ISimpleStyleClient(track).styleName = this;
                };
                innerSlider.addChildAt(DisplayObject(track), 0);
            };
        }
        private function positionDataTip(_arg1:Object):void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number = _arg1.x;
            var _local5:Number = _arg1.y;
            var _local6:String = getStyle("dataTipPlacement");
            var _local7:Number = getStyle("dataTipOffset");
            if (_direction == SliderDirection.HORIZONTAL){
                _local2 = _local4;
                _local3 = _local5;
                if (_local6 == "left"){
                    _local2 = (_local2 - (_local7 + dataTip.width));
                    _local3 = (_local3 + ((_arg1.height - dataTip.height) / 2));
                } else {
                    if (_local6 == "right"){
                        _local2 = (_local2 + (_local7 + _arg1.width));
                        _local3 = (_local3 + ((_arg1.height - dataTip.height) / 2));
                    } else {
                        if (_local6 == "top"){
                            _local3 = (_local3 - (_local7 + dataTip.height));
                            _local2 = (_local2 - ((dataTip.width - _arg1.width) / 2));
                        } else {
                            if (_local6 == "bottom"){
                                _local3 = (_local3 + (_local7 + _arg1.height));
                                _local2 = (_local2 - ((dataTip.width - _arg1.width) / 2));
                            };
                        };
                    };
                };
            } else {
                _local2 = _local5;
                _local3 = ((unscaledHeight - _local4) - ((dataTip.height + _arg1.width) / 2));
                if (_local6 == "left"){
                    _local2 = (_local2 - (_local7 + dataTip.width));
                } else {
                    if (_local6 == "right"){
                        _local2 = (_local2 + (_local7 + _arg1.height));
                    } else {
                        if (_local6 == "top"){
                            _local3 = (_local3 - (_local7 + ((dataTip.height + _arg1.width) / 2)));
                            _local2 = (_local2 - ((dataTip.width - _arg1.height) / 2));
                        } else {
                            if (_local6 == "bottom"){
                                _local3 = (_local3 + (_local7 + ((dataTip.height + _arg1.width) / 2)));
                                _local2 = (_local2 - ((dataTip.width - _arg1.height) / 2));
                            };
                        };
                    };
                };
            };
            var _local8:Point = new Point(_local2, _local3);
            var _local9:Point = localToGlobal(_local8);
            _local9 = dataTip.parent.globalToLocal(_local9);
            dataTip.x = (((_local9.x < 0)) ? 0 : _local9.x);
            dataTip.y = (((_local9.y < 0)) ? 0 : _local9.y);
        }
        public function get values():Array{
            return (_values);
        }
        private function createLabels():void{
            var _local1:SliderLabel;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:String;
            if (labelObjects){
                _local2 = (labelObjects.numChildren - 1);
                while (_local2 >= 0) {
                    labelObjects.removeChildAt(_local2);
                    _local2--;
                };
            } else {
                labelObjects = new UIComponent();
                innerSlider.addChildAt(labelObjects, innerSlider.getChildIndex(trackHitArea));
            };
            if (_labels){
                _local3 = _labels.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local1 = new SliderLabel();
                    _local1.text = (((_labels[_local4] is String)) ? _labels[_local4] : _labels[_local4].toString());
                    if (_direction != SliderDirection.HORIZONTAL){
                        _local1.rotation = 90;
                    };
                    _local5 = getStyle("labelStyleName");
                    if (_local5){
                        _local1.styleName = _local5;
                    };
                    labelObjects.addChild(_local1);
                    _local4++;
                };
            };
        }
        private function destroyDataTip():void{
            if (dataTip){
                systemManager.toolTipChildren.removeChild(dataTip);
                dataTip = null;
            };
        }
        private function setValueFromPos(_arg1:int):void{
            var _local2:SliderThumb = SliderThumb(thumbs.getChildAt(_arg1));
            setValueAt(getValueFromX(_local2.xPosition), _arg1);
        }
        public function set tickValues(_arg1:Array):void{
            _tickValues = _arg1;
            ticksChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        override public function get enabled():Boolean{
            return (_enabled);
        }
        public function set values(_arg1:Array):void{
            _values = _arg1;
            valuesChanged = true;
            minimumSet = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        mx_internal function getXFromValue(_arg1:Number):Number{
            var _local2:Number;
            if (_arg1 == minimum){
                _local2 = track.x;
            } else {
                if (_arg1 == maximum){
                    _local2 = (track.x + track.width);
                } else {
                    _local2 = (track.x + (((_arg1 - minimum) * track.width) / (maximum - minimum)));
                };
            };
            return (_local2);
        }
        public function set maximum(_arg1:Number):void{
            _maximum = _arg1;
            ticksChanged = true;
            if (!initValues){
                valuesChanged = true;
            };
            invalidateProperties();
            invalidateDisplayList();
        }
        mx_internal function onThumbPress(_arg1:Object):void{
            var _local3:String;
            var _local4:String;
            if (showDataTip){
                dataFormatter = new NumberFormatter();
                dataFormatter.precision = getStyle("dataTipPrecision");
                if (!dataTip){
                    dataTip = SliderDataTip(new sliderDataTipClass());
                    systemManager.toolTipChildren.addChild(dataTip);
                    _local4 = getStyle("dataTipStyleName");
                    if (_local4){
                        dataTip.styleName = _local4;
                    };
                };
                if (_dataTipFormatFunction != null){
                    _local3 = this._dataTipFormatFunction(getValueFromX(_arg1.xPosition));
                } else {
                    _local3 = dataFormatter.format(getValueFromX(_arg1.xPosition));
                };
                dataTip.text = _local3;
                dataTip.validateNow();
                dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(), dataTip.getExplicitOrMeasuredHeight());
                positionDataTip(_arg1);
            };
            keyInteraction = false;
            var _local2:SliderEvent = new SliderEvent(SliderEvent.THUMB_PRESS);
            _local2.value = getValueFromX(_arg1.xPosition);
            _local2.thumbIndex = _arg1.thumbIndex;
            dispatchEvent(_local2);
        }
        public function setThumbValueAt(_arg1:int, _arg2:Number):void{
            setValueAt(_arg2, _arg1, true);
            valuesChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
        public function set snapInterval(_arg1:Number):void{
            _snapInterval = _arg1;
            var _local2:Array = new String((1 + _arg1)).split(".");
            if (_local2.length == 2){
                snapIntervalPrecision = _local2[1].length;
            } else {
                snapIntervalPrecision = -1;
            };
            if (((!(isNaN(_arg1))) && (!((_arg1 == 0))))){
                snapIntervalChanged = true;
                invalidateProperties();
                invalidateDisplayList();
            };
        }
        mx_internal function unRegisterMouseMove(_arg1:Function):void{
            innerSlider.removeEventListener(MouseEvent.MOUSE_MOVE, _arg1);
        }
        mx_internal function getTrackHitArea():UIComponent{
            return (trackHitArea);
        }
        private function layoutTicks():void{
            var _local1:Graphics;
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Boolean;
            var _local9:int;
            var _local10:Number;
            if (ticks){
                _local1 = ticks.graphics;
                _local2 = getStyle("tickLength");
                _local3 = getStyle("tickOffset");
                _local4 = getStyle("tickThickness");
                _local5 = (_local4 / 2);
                _local7 = getStyle("tickColor");
                _local8 = ((((_tickValues) && ((_tickValues.length > 0)))) ? true : false);
                _local9 = 0;
                _local10 = ((_local8) ? var _temp1 = _local9;
_local9 = (_local9 + 1);
_tickValues[_temp1] : minimum);
                _local1.clear();
                if ((((_tickInterval > 0)) || (_local8))){
                    _local1.lineStyle(_local4, _local7, 100);
                    do  {
                        _local6 = Math.round((getXFromValue(_local10) - _local5));
                        _local1.moveTo(_local6, _local2);
                        _local1.lineTo(_local6, 0);
                        _local10 = ((_local8) ? (((_local9 < _tickValues.length)) ? var _temp2 = _local9;
_local9 = (_local9 + 1);
_tickValues[_temp2] : NaN) : (_tickInterval + _local10));
                    } while ((((_local10 < maximum)) || (((_local8) && ((_local9 < _tickValues.length))))));
                    if (((!(_local8)) || ((_local10 == maximum)))){
                        _local6 = (((track.x + track.width) - 1) - _local5);
                        _local1.moveTo(_local6, _local2);
                        _local1.lineTo(_local6, 0);
                    };
                    ticks.y = Math.round(((track.y + _local3) - _local2));
                };
            };
        }
        public function getThumbAt(_arg1:int):SliderThumb{
            return ((((((_arg1 >= 0)) && ((_arg1 < thumbs.numChildren)))) ? SliderThumb(thumbs.getChildAt(_arg1)) : null));
        }
        private function setPosFromValue():void{
            var _local3:SliderThumb;
            var _local1:int = _thumbCount;
            var _local2:int;
            while (_local2 < _local1) {
                _local3 = SliderThumb(thumbs.getChildAt(_local2));
                _local3.xPosition = getXFromValue(values[_local2]);
                _local2++;
            };
        }
        private function createThumbs():void{
            var _local1:int;
            var _local2:int;
            var _local3:SliderThumb;
            if (thumbs){
                _local1 = thumbs.numChildren;
                _local2 = (_local1 - 1);
                while (_local2 >= 0) {
                    thumbs.removeChildAt(_local2);
                    _local2--;
                };
            } else {
                thumbs = new UIComponent();
                thumbs.tabChildren = true;
                thumbs.tabEnabled = false;
                innerSlider.addChild(thumbs);
            };
            _local1 = _thumbCount;
            _local2 = 0;
            while (_local2 < _local1) {
                _local3 = SliderThumb(new _thumbClass());
                _local3.owner = this;
                _local3.styleName = new StyleProxy(this, thumbStyleFilters);
                _local3.thumbIndex = _local2;
                _local3.visible = true;
                _local3.enabled = enabled;
                _local3.upSkinName = "thumbUpSkin";
                _local3.downSkinName = "thumbDownSkin";
                _local3.disabledSkinName = "thumbDisabledSkin";
                _local3.overSkinName = "thumbOverSkin";
                _local3.skinName = "thumbSkin";
                thumbs.addChild(_local3);
                _local3.addEventListener(FocusEvent.FOCUS_IN, thumb_focusInHandler);
                _local3.addEventListener(FocusEvent.FOCUS_OUT, thumb_focusOutHandler);
                _local2++;
            };
        }
        override public function set tabIndex(_arg1:int):void{
            super.tabIndex = _arg1;
            _tabIndex = _arg1;
            tabIndexChanged = true;
            invalidateProperties();
        }
        public function get direction():String{
            return (_direction);
        }
        override public function set enabled(_arg1:Boolean):void{
            _enabled = _arg1;
            enabledChanged = true;
            invalidateProperties();
        }
        override protected function measure():void{
            var _local1:Boolean;
            var _local6:Number;
            super.measure();
            _local1 = (direction == SliderDirection.HORIZONTAL);
            var _local2:int = ((labelObjects) ? labelObjects.numChildren : 0);
            var _local3:Number = getStyle("trackMargin");
            var _local4:Number = DEFAULT_MEASURED_WIDTH;
            if (!isNaN(_local3)){
                if (_local2 > 0){
                    _local4 = (_local4 + ((_local1) ? (SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredWidth() / 2) : (SliderLabel(labelObjects.getChildAt(0)).getExplicitOrMeasuredHeight() / 2)));
                };
                if (_local2 > 1){
                    _local4 = (_local4 + ((_local1) ? (SliderLabel(labelObjects.getChildAt((_local2 - 1))).getExplicitOrMeasuredWidth() / 2) : (SliderLabel(labelObjects.getChildAt((_local2 - 1))).getExplicitOrMeasuredHeight() / 2)));
                };
            };
            var _local5:Object = getComponentBounds();
            _local6 = (_local5.lower - _local5.upper);
            measuredMinWidth = (measuredWidth = ((_local1) ? _local4 : _local6));
            measuredMinHeight = (measuredHeight = ((_local1) ? _local6 : _local4));
        }
        public function get value():Number{
            return (_values[0]);
        }
        public function get tickInterval():Number{
            return (_tickInterval);
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (super.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return (int((0.75 * height)));
        }
        mx_internal function getSnapIntervalWidth():Number{
            return (((_snapInterval * track.width) / (maximum - minimum)));
        }
        private function thumb_focusOutHandler(_arg1:FocusEvent):void{
            dispatchEvent(_arg1);
        }
        override protected function initializeAccessibility():void{
            if (Slider.createAccessibilityImplementation != null){
                Slider.createAccessibilityImplementation(this);
            };
        }
        public function get snapInterval():Number{
            return (_snapInterval);
        }
        public function set thumbCount(_arg1:int):void{
            var _local2:int = ((_arg1)>2) ? 2 : _arg1;
            _local2 = (((_arg1 < 1)) ? 1 : _arg1);
            if (_local2 != _thumbCount){
                _thumbCount = _local2;
                thumbsChanged = true;
                initValues = true;
                invalidateProperties();
                invalidateDisplayList();
            };
        }
        mx_internal function registerMouseMove(_arg1:Function):void{
            innerSlider.addEventListener(MouseEvent.MOUSE_MOVE, _arg1);
        }
        public function set dataTipFormatFunction(_arg1:Function):void{
            _dataTipFormatFunction = _arg1;
        }
        override public function styleChanged(_arg1:String):void{
            var _local2:Boolean = (((_arg1 == null)) || ((_arg1 == "styleName")));
            super.styleChanged(_arg1);
            if ((((_arg1 == "showTrackHighlight")) || (_local2))){
                trackHighlightChanged = true;
                invalidateProperties();
            };
            if ((((_arg1 == "trackHighlightSkin")) || (_local2))){
                if (((innerSlider) && (highlightTrack))){
                    innerSlider.removeChild(DisplayObject(highlightTrack));
                    highlightTrack = null;
                };
                trackHighlightChanged = true;
                invalidateProperties();
            };
            if ((((_arg1 == "labelStyleName")) || (_local2))){
                labelStyleChanged = true;
                invalidateProperties();
            };
            if ((((_arg1 == "trackMargin")) || (_local2))){
                invalidateSize();
            };
            if ((((_arg1 == "trackSkin")) || (_local2))){
                if (track){
                    innerSlider.removeChild(DisplayObject(track));
                    track = null;
                    createBackgroundTrack();
                };
            };
            invalidateDisplayList();
        }
        public function set sliderDataTipClass(_arg1:Class):void{
            _sliderDataTipClass = _arg1;
            invalidateProperties();
        }
        mx_internal function onThumbMove(_arg1:Object):void{
            var _local2:Number = getValueFromX(_arg1.xPosition);
            if (showDataTip){
                dataTip.text = ((_dataTipFormatFunction)!=null) ? _dataTipFormatFunction(_local2) : dataFormatter.format(_local2);
                dataTip.setActualSize(dataTip.getExplicitOrMeasuredWidth(), dataTip.getExplicitOrMeasuredHeight());
                positionDataTip(_arg1);
            };
            if (liveDragging){
                interactionClickTarget = SliderEventClickTarget.THUMB;
                setValueAt(_local2, _arg1.thumbIndex);
            };
            var _local3:SliderEvent = new SliderEvent(SliderEvent.THUMB_DRAG);
            _local3.value = _local2;
            _local3.thumbIndex = _arg1.thumbIndex;
            dispatchEvent(_local3);
        }
        private function layoutLabels():void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Object;
            var _local7:int;
            var _local8:Number;
            var _local9:Number;
            var _local1:Number = ((labelObjects) ? labelObjects.numChildren : 0);
            if (_local1 > 0){
                _local3 = (track.width / (_local1 - 1));
                _local2 = Math.max(((((_direction == SliderDirection.HORIZONTAL)) ? unscaledWidth : unscaledHeight) - track.width), SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredWidth());
                _local5 = track.x;
                _local7 = 0;
                while (_local7 < _local1) {
                    _local6 = labelObjects.getChildAt(_local7);
                    labelObjects.getChildAt(_local7).setActualSize(_local6.getExplicitOrMeasuredWidth(), _local6.getExplicitOrMeasuredHeight());
                    _local8 = ((track.y - _local6.height) + getStyle("labelOffset"));
                    if (_direction == SliderDirection.HORIZONTAL){
                        _local4 = (_local6.getExplicitOrMeasuredWidth() / 2);
                        if (_local7 == 0){
                            _local4 = Math.min(_local4, (_local2 / (((_local1 > Number(1))) ? Number(2) : Number(1))));
                        } else {
                            if (_local7 == (_local1 - 1)){
                                _local4 = Math.max(_local4, (_local6.getExplicitOrMeasuredWidth() - (_local2 / 2)));
                            };
                        };
                        _local6.move((_local5 - _local4), _local8);
                    } else {
                        _local9 = getStyle("labelOffset");
                        _local4 = (_local6.getExplicitOrMeasuredHeight() / 2);
                        if (_local7 == 0){
                            _local4 = Math.max(_local4, (_local6.getExplicitOrMeasuredHeight() - (_local2 / (((_local1 > Number(1))) ? Number(2) : Number(1)))));
                        } else {
                            if (_local7 == (_local1 - 1)){
                                _local4 = Math.min(_local4, (_local2 / 2));
                            };
                        };
                        _local6.move((_local5 + _local4), ((track.y + _local9) + (((_local9 > 0)) ? 0 : -(_local6.getExplicitOrMeasuredWidth()))));
                    };
                    _local5 = (_local5 + _local3);
                    _local7++;
                };
            };
        }
        public function get thumbCount():int{
            return (_thumbCount);
        }
        private function getComponentBounds():Object{
            var _local3:Number;
            var _local5:Number;
            var _local8:SliderLabel;
            var _local9:Number;
            var _local10:int;
            var _local11:Number;
            var _local12:Number;
            var _local1 = (direction == SliderDirection.HORIZONTAL);
            var _local2:int = ((labelObjects) ? labelObjects.numChildren : 0);
            var _local4:Number = 0;
            var _local6:Number = 0;
            var _local7:Number = track.height;
            if (_local2 > 0){
                _local8 = SliderLabel(labelObjects.getChildAt(0));
                if (_local1){
                    _local4 = _local8.getExplicitOrMeasuredHeight();
                } else {
                    _local10 = 0;
                    while (_local10 < _local2) {
                        _local8 = SliderLabel(labelObjects.getChildAt(_local10));
                        _local4 = Math.max(_local4, _local8.getExplicitOrMeasuredWidth());
                        _local10++;
                    };
                };
                _local9 = getStyle("labelOffset");
                _local3 = (getStyle("labelOffset") - (((_local9 > 0)) ? 0 : _local4));
                _local6 = Math.min(_local6, _local3);
                _local7 = Math.max(_local7, (_local9 + (((_local9 > 0)) ? _local4 : 0)));
            };
            if (ticks){
                _local11 = getStyle("tickLength");
                _local12 = getStyle("tickOffset");
                _local6 = Math.min(_local6, (_local12 - _local11));
                _local7 = Math.max(_local7, _local12);
            };
            if (thumbs.numChildren > 0){
                _local5 = (((track.height - SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight()) / 2) + getStyle("thumbOffset"));
                _local6 = Math.min(_local6, _local5);
                _local7 = Math.max(_local7, (_local5 + SliderThumb(thumbs.getChildAt(0)).getExplicitOrMeasuredHeight()));
            };
            return ({
                lower:_local7,
                upper:_local6
            });
        }
        mx_internal function onThumbRelease(_arg1:Object):void{
            interactionClickTarget = SliderEventClickTarget.THUMB;
            destroyDataTip();
            setValueFromPos(_arg1.thumbIndex);
            dataFormatter = null;
            var _local2:SliderEvent = new SliderEvent(SliderEvent.THUMB_RELEASE);
            _local2.value = getValueFromX(_arg1.xPosition);
            _local2.thumbIndex = _arg1.thumbIndex;
            dispatchEvent(_local2);
        }
        public function get dataTipFormatFunction():Function{
            return (_dataTipFormatFunction);
        }
        public function set value(_arg1:Number):void{
            setValueAt(_arg1, 0, true);
            valuesChanged = true;
            minimumSet = true;
            invalidateProperties();
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        mx_internal function updateThumbValue(_arg1:int):void{
            setValueFromPos(_arg1);
        }
        private function track_mouseDownHandler(_arg1:MouseEvent):void{
            var _local2:Point;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:int;
            var _local7:int;
            var _local8:SliderThumb;
            var _local9:Number;
            var _local10:Tween;
            var _local11:Function;
            var _local12:Number;
            if (((!((_arg1.target == trackHitArea))) && (!((_arg1.target == ticks))))){
                return;
            };
            if (((enabled) && (allowTrackClick))){
                interactionClickTarget = SliderEventClickTarget.TRACK;
                keyInteraction = false;
                _local2 = new Point(_arg1.localX, _arg1.localY);
                _local3 = _local2.x;
                _local4 = 0;
                _local5 = 10000000;
                _local6 = _thumbCount;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local12 = Math.abs((SliderThumb(thumbs.getChildAt(_local7)).xPosition - _local3));
                    if (_local12 < _local5){
                        _local4 = _local7;
                        _local5 = _local12;
                    };
                    _local7++;
                };
                _local8 = SliderThumb(thumbs.getChildAt(_local4));
                if (((!(isNaN(_snapInterval))) && (!((_snapInterval == 0))))){
                    _local3 = getXFromValue(getValueFromX(_local3));
                };
                _local9 = getStyle("slideDuration");
                _local10 = new Tween(_local8, _local8.xPosition, _local3, _local9);
                _local11 = (getStyle("slideEasingFunction") as Function);
                if (_local11 != null){
                    _local10.easingFunction = _local11;
                };
                drawTrackHighlight();
            };
        }
        public function get sliderDataTipClass():Class{
            return (_sliderDataTipClass);
        }
        private function createTicks():void{
            if (!ticks){
                ticks = new UIComponent();
                innerSlider.addChild(ticks);
            };
        }
        mx_internal function getValueFromX(_arg1:Number):Number{
            var _local2:Number = ((((_arg1 - track.x) * (maximum - minimum)) / track.width) + minimum);
            if ((_local2 - minimum) <= 0.002){
                _local2 = minimum;
            } else {
                if ((maximum - _local2) <= 0.002){
                    _local2 = maximum;
                } else {
                    if (((!(isNaN(_snapInterval))) && (!((_snapInterval == 0))))){
                        _local2 = ((Math.round(((_local2 - minimum) / _snapInterval)) * _snapInterval) + minimum);
                    };
                };
            };
            return (_local2);
        }
        private function thumb_focusInHandler(_arg1:FocusEvent):void{
            dispatchEvent(_arg1);
        }
        private function setValueAt(_arg1:Number, _arg2:int, _arg3:Boolean=false):void{
            var _local5:Number;
            var _local6:SliderEvent;
            var _local4:Number = _values[_arg2];
            if (snapIntervalPrecision != -1){
                _local5 = Math.pow(10, snapIntervalPrecision);
                _arg1 = (Math.round((_arg1 * _local5)) / _local5);
            };
            _values[_arg2] = _arg1;
            if (!_arg3){
                _local6 = new SliderEvent(SliderEvent.CHANGE);
                _local6.value = _arg1;
                _local6.thumbIndex = _arg2;
                _local6.clickTarget = interactionClickTarget;
                if (keyInteraction){
                    _local6.triggerEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
                    keyInteraction = false;
                } else {
                    _local6.triggerEvent = new MouseEvent(MouseEvent.CLICK);
                };
                if (((!(isNaN(_local4))) && ((Math.abs((_local4 - _arg1)) > 0.002)))){
                    dispatchEvent(_local6);
                };
            };
            invalidateDisplayList();
        }
        public function set labels(_arg1:Array):void{
            _labels = _arg1;
            labelsChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        public function get labels():Array{
            return (_labels);
        }

    }
}//package mx.controls.sliderClasses 
