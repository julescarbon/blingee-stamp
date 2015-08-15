package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class SliderTrackSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override public function get measuredWidth():Number{
            return (200);
        }
        override public function get measuredHeight():Number{
            return (4);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("borderColor");
            var _local4:Array = getStyle("fillAlphas");
            var _local5:Array = (getStyle("trackColors") as Array);
            StyleManager.getColorNames(_local5);
            var _local6:Number = ColorUtil.adjustBrightness2(_local3, -50);
            graphics.clear();
            drawRoundRect(0, 0, _arg1, _arg2, 0, 0, 0);
            drawRoundRect(1, 0, _arg1, (_arg2 - 1), 1.5, _local6, 1, null, GradientType.LINEAR, null, {
                x:2,
                y:1,
                w:(_arg1 - 2),
                h:1,
                r:0
            });
            drawRoundRect(2, 1, (_arg1 - 2), (_arg2 - 2), 1, _local3, 1, null, GradientType.LINEAR, null, {
                x:2,
                y:1,
                w:(_arg1 - 2),
                h:1,
                r:0
            });
            drawRoundRect(2, 1, (_arg1 - 2), 1, 0, _local5, Math.max((_local4[1] - 0.3), 0), horizontalGradientMatrix(2, 1, (_arg1 - 2), 1));
        }

    }
}//package mx.skins.halo 
