package mx.containers {
    import mx.core.*;
    import flash.events.*;
    import mx.containers.utilityClasses.*;

    public class Box extends Container {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal var layoutObject:BoxLayout;

        public function Box(){
            layoutObject = new BoxLayout();
            super();
            layoutObject.target = this;
        }
        mx_internal function isVertical():Boolean{
            return (!((direction == BoxDirection.HORIZONTAL)));
        }
        public function set direction(_arg1:String):void{
            layoutObject.direction = _arg1;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("directionChanged"));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            layoutObject.updateDisplayList(_arg1, _arg2);
        }
        public function pixelsToPercent(_arg1:Number):Number{
            var _local8:IUIComponent;
            var _local9:Number;
            var _local10:Number;
            var _local2:Boolean = isVertical();
            var _local3:Number = 0;
            var _local4:Number = 0;
            var _local5:int = numChildren;
            var _local6:int;
            while (_local6 < _local5) {
                _local8 = IUIComponent(getChildAt(_local6));
                _local9 = ((_local2) ? _local8.height : _local8.width);
                _local10 = ((_local2) ? _local8.percentHeight : _local8.percentWidth);
                if (!isNaN(_local10)){
                    _local3 = (_local3 + _local10);
                    _local4 = (_local4 + _local9);
                };
                _local6++;
            };
            var _local7:Number = 100;
            if (_local4 != _arg1){
                _local7 = (((_local4 * _local3) / (_local4 - _arg1)) - _local3);
            };
            return (_local7);
        }
        override protected function measure():void{
            super.measure();
            layoutObject.measure();
        }
        public function get direction():String{
            return (layoutObject.direction);
        }

    }
}//package mx.containers 
