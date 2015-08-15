package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.styles.*;

    public class BusyCursor extends FlexSprite {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var hourHand:Shape;
        private var minuteHand:Shape;

        public function BusyCursor(){
            var _local6:Graphics;
            super();
            var _local1:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CursorManager");
            var _local2:Class = _local1.getStyle("busyCursorBackground");
            var _local3:DisplayObject = new (_local2)();
            if ((_local3 is InteractiveObject)){
                InteractiveObject(_local3).mouseEnabled = false;
            };
            addChild(_local3);
            var _local4:Number = -0.5;
            var _local5:Number = -0.5;
            minuteHand = new FlexShape();
            minuteHand.name = "minuteHand";
            _local6 = minuteHand.graphics;
            _local6.beginFill(0);
            _local6.moveTo(_local4, _local5);
            _local6.lineTo((1 + _local4), (0 + _local5));
            _local6.lineTo((1 + _local4), (5 + _local5));
            _local6.lineTo((0 + _local4), (5 + _local5));
            _local6.lineTo((0 + _local4), (0 + _local5));
            _local6.endFill();
            addChild(minuteHand);
            hourHand = new FlexShape();
            hourHand.name = "hourHand";
            _local6 = hourHand.graphics;
            _local6.beginFill(0);
            _local6.moveTo(_local4, _local5);
            _local6.lineTo((4 + _local4), (0 + _local5));
            _local6.lineTo((4 + _local4), (1 + _local5));
            _local6.lineTo((0 + _local4), (1 + _local5));
            _local6.lineTo((0 + _local4), (0 + _local5));
            _local6.endFill();
            addChild(hourHand);
            addEventListener(Event.ADDED, handleAdded);
            addEventListener(Event.REMOVED, handleRemoved);
        }
        private function enterFrameHandler(_arg1:Event):void{
            minuteHand.rotation = (minuteHand.rotation + 12);
            hourHand.rotation = (hourHand.rotation + 1);
        }
        private function handleAdded(_arg1:Event):void{
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
        private function handleRemoved(_arg1:Event):void{
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

    }
}//package mx.skins.halo 
