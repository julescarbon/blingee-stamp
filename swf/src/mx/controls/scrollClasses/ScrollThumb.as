package mx.controls.scrollClasses {
    import flash.geom.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.*;

    public class ScrollThumb extends Button {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var lastY:Number;
        private var datamin:Number;
        private var ymax:Number;
        private var ymin:Number;
        private var datamax:Number;

        public function ScrollThumb(){
            explicitMinHeight = 10;
            stickyHighlighting = true;
        }
        private function stopDragThumb():void{
            var _local1:ScrollBar = ScrollBar(parent);
            _local1.isScrolling = false;
            _local1.dispatchScrollEvent(_local1.oldPosition, ScrollEventDetail.THUMB_POSITION);
            _local1.oldPosition = NaN;
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
        }
        override protected function mouseDownHandler(_arg1:MouseEvent):void{
            super.mouseDownHandler(_arg1);
            var _local2:ScrollBar = ScrollBar(parent);
            _local2.oldPosition = _local2.scrollPosition;
            lastY = _arg1.localY;
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
        }
        private function mouseMoveHandler(_arg1:MouseEvent):void{
            if (ymin == ymax){
                return;
            };
            var _local2:Point = new Point(_arg1.stageX, _arg1.stageY);
            _local2 = globalToLocal(_local2);
            var _local3:Number = (_local2.y - lastY);
            _local3 = (_local3 + y);
            if (_local3 < ymin){
                _local3 = ymin;
            } else {
                if (_local3 > ymax){
                    _local3 = ymax;
                };
            };
            var _local4:ScrollBar = ScrollBar(parent);
            _local4.isScrolling = true;
            $y = _local3;
            var _local5:Number = _local4.scrollPosition;
            var _local6:Number = (Math.round((((datamax - datamin) * (y - ymin)) / (ymax - ymin))) + datamin);
            _local4.scrollPosition = _local6;
            _local4.dispatchScrollEvent(_local5, ScrollEventDetail.THUMB_TRACK);
            _arg1.updateAfterEvent();
        }
        override mx_internal function buttonReleased():void{
            super.buttonReleased();
            stopDragThumb();
        }
        mx_internal function setRange(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):void{
            this.ymin = _arg1;
            this.ymax = _arg2;
            this.datamin = _arg3;
            this.datamax = _arg4;
        }

    }
}//package mx.controls.scrollClasses 
