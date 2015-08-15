package mx.controls.sliderClasses {
    import flash.geom.*;
    import flash.events.*;
    import mx.controls.*;
    import flash.ui.*;

    public class SliderThumb extends Button {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var xOffset:Number;
        mx_internal var thumbIndex:int;

        public function SliderThumb(){
            stickyHighlighting = true;
        }
        public function get xPosition():Number{
            return (($x + (width / 2)));
        }
        public function set xPosition(_arg1:Number):void{
            $x = (_arg1 - (width / 2));
            Slider(owner).drawTrackHighlight();
        }
        override protected function mouseDownHandler(_arg1:MouseEvent):void{
            super.mouseDownHandler(_arg1);
            if (enabled){
                xOffset = _arg1.localX;
                systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
                systemManager.deployMouseShields(true);
                Slider(owner).onThumbPress(this);
            };
        }
        mx_internal function onTweenEnd(_arg1:Number):void{
            moveXPos(_arg1);
        }
        private function updateValue():void{
            Slider(owner).updateThumbValue(thumbIndex);
        }
        private function calculateXPos(_arg1:Number, _arg2:Boolean=false):Number{
            var _local3:Object = Slider(owner).getXBounds(thumbIndex);
            var _local4:Number = Math.min(Math.max(_arg1, _local3.min), _local3.max);
            if (!_arg2){
                _local4 = Slider(owner).getSnapValue(_local4, this);
            };
            return (_local4);
        }
        private function mouseMoveHandler(_arg1:MouseEvent):void{
            var _local2:Point;
            if (enabled){
                _local2 = new Point(_arg1.stageX, _arg1.stageY);
                _local2 = Slider(owner).innerSlider.globalToLocal(_local2);
                moveXPos(((_local2.x - xOffset) + (width / 2)), false, true);
                Slider(owner).onThumbMove(this);
            };
        }
        private function moveXPos(_arg1:Number, _arg2:Boolean=false, _arg3:Boolean=false):Number{
            var _local4:Number = calculateXPos(_arg1, _arg2);
            xPosition = _local4;
            if (!_arg3){
                updateValue();
            };
            return (_local4);
        }
        override mx_internal function buttonReleased():void{
            super.buttonReleased();
            if (enabled){
                systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
                systemManager.deployMouseShields(false);
                Slider(owner).onThumbRelease(this);
            };
        }
        override public function set x(_arg1:Number):void{
            var _local2:Number = moveXPos(_arg1);
            updateValue();
            super.x = _local2;
        }
        override public function drawFocus(_arg1:Boolean):void{
            phase = ((_arg1) ? ButtonPhase.DOWN : ButtonPhase.UP);
        }
        mx_internal function onTweenUpdate(_arg1:Number):void{
            moveXPos(_arg1, true, true);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local6:Number;
            var _local2 = (Slider(owner).thumbCount > 1);
            var _local3:Number = xPosition;
            var _local4:Number = (((Slider(owner).snapInterval > 0)) ? Slider(owner).getSnapIntervalWidth() : 1);
            var _local5 = (Slider(owner).direction == SliderDirection.HORIZONTAL);
            if ((((((_arg1.keyCode == Keyboard.DOWN)) && (!(_local5)))) || ((((_arg1.keyCode == Keyboard.LEFT)) && (_local5))))){
                _local6 = (_local3 - _local4);
            } else {
                if ((((((_arg1.keyCode == Keyboard.UP)) && (!(_local5)))) || ((((_arg1.keyCode == Keyboard.RIGHT)) && (_local5))))){
                    _local6 = (_local3 + _local4);
                } else {
                    if ((((((_arg1.keyCode == Keyboard.PAGE_DOWN)) && (!(_local5)))) || ((((_arg1.keyCode == Keyboard.HOME)) && (_local5))))){
                        _local6 = Slider(owner).getXFromValue(Slider(owner).minimum);
                    } else {
                        if ((((((_arg1.keyCode == Keyboard.PAGE_UP)) && (!(_local5)))) || ((((_arg1.keyCode == Keyboard.END)) && (_local5))))){
                            _local6 = Slider(owner).getXFromValue(Slider(owner).maximum);
                        };
                    };
                };
            };
            if (!isNaN(_local6)){
                _arg1.stopPropagation();
                Slider(owner).keyInteraction = true;
                moveXPos(_local6);
            };
        }
        override protected function measure():void{
            super.measure();
            measuredWidth = 12;
            measuredHeight = 12;
        }

    }
}//package mx.controls.sliderClasses 
