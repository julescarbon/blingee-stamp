package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.graphics.*;
    import mx.skins.*;
    import flash.filters.*;

    public class ToolTipBorder extends RectangularBorder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _borderMetrics:EdgeMetrics;
        private var dropShadow:RectangularDropShadow;

        override public function get borderMetrics():EdgeMetrics{
            if (_borderMetrics){
                return (_borderMetrics);
            };
            var _local1:String = getStyle("borderStyle");
            switch (_local1){
                case "errorTipRight":
                    _borderMetrics = new EdgeMetrics(15, 1, 3, 3);
                    break;
                case "errorTipAbove":
                    _borderMetrics = new EdgeMetrics(3, 1, 3, 15);
                    break;
                case "errorTipBelow":
                    _borderMetrics = new EdgeMetrics(3, 13, 3, 3);
                    break;
                default:
                    _borderMetrics = new EdgeMetrics(3, 1, 3, 3);
            };
            return (_borderMetrics);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:String = getStyle("borderStyle");
            var _local4:uint = getStyle("backgroundColor");
            var _local5:Number = getStyle("backgroundAlpha");
            var _local6:uint = getStyle("borderColor");
            var _local7:Number = getStyle("cornerRadius");
            var _local8:uint = getStyle("shadowColor");
            var _local9:Number = 0.1;
            var _local10:Graphics = graphics;
            _local10.clear();
            filters = [];
            switch (_local3){
                case "toolTip":
                    drawRoundRect(3, 1, (_arg1 - 6), (_arg2 - 4), _local7, _local4, _local5);
                    if (!dropShadow){
                        dropShadow = new RectangularDropShadow();
                    };
                    dropShadow.distance = 3;
                    dropShadow.angle = 90;
                    dropShadow.color = 0;
                    dropShadow.alpha = 0.4;
                    dropShadow.tlRadius = (_local7 + 2);
                    dropShadow.trRadius = (_local7 + 2);
                    dropShadow.blRadius = (_local7 + 2);
                    dropShadow.brRadius = (_local7 + 2);
                    dropShadow.drawShadow(graphics, 3, 0, (_arg1 - 6), (_arg2 - 4));
                    break;
                case "errorTipRight":
                    drawRoundRect(11, 0, (_arg1 - 11), (_arg2 - 2), 3, _local6, _local5);
                    _local10.beginFill(_local6, _local5);
                    _local10.moveTo(11, 7);
                    _local10.lineTo(0, 13);
                    _local10.lineTo(11, 19);
                    _local10.moveTo(11, 7);
                    _local10.endFill();
                    filters = [new DropShadowFilter(2, 90, 0, 0.4)];
                    break;
                case "errorTipAbove":
                    drawRoundRect(0, 0, _arg1, (_arg2 - 13), 3, _local6, _local5);
                    _local10.beginFill(_local6, _local5);
                    _local10.moveTo(9, (_arg2 - 13));
                    _local10.lineTo(15, (_arg2 - 2));
                    _local10.lineTo(21, (_arg2 - 13));
                    _local10.moveTo(9, (_arg2 - 13));
                    _local10.endFill();
                    filters = [new DropShadowFilter(2, 90, 0, 0.4)];
                    break;
                case "errorTipBelow":
                    drawRoundRect(0, 11, _arg1, (_arg2 - 13), 3, _local6, _local5);
                    _local10.beginFill(_local6, _local5);
                    _local10.moveTo(9, 11);
                    _local10.lineTo(15, 0);
                    _local10.lineTo(21, 11);
                    _local10.moveTo(10, 11);
                    _local10.endFill();
                    filters = [new DropShadowFilter(2, 90, 0, 0.4)];
                    break;
            };
        }
        override public function styleChanged(_arg1:String):void{
            if ((((((_arg1 == "borderStyle")) || ((_arg1 == "styleName")))) || ((_arg1 == null)))){
                _borderMetrics = null;
            };
            invalidateDisplayList();
        }

    }
}//package mx.skins.halo 
