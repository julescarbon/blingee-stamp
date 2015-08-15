package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ScrollTrackSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override public function get measuredWidth():Number{
            return (16);
        }
        override public function get measuredHeight():Number{
            return (1);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Array = getStyle("trackColors");
            StyleManager.getColorNames(_local3);
            var _local4:uint = ColorUtil.adjustBrightness2(getStyle("borderColor"), -20);
            var _local5:uint = ColorUtil.adjustBrightness2(_local4, -30);
            graphics.clear();
            var _local6:Number = 1;
            if ((((name == "trackDisabledSkin")) && ((FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)))){
                _local6 = 0.2;
            };
            drawRoundRect(0, 0, _arg1, _arg2, 0, [_local4, _local5], _local6, verticalGradientMatrix(0, 0, _arg1, _arg2), GradientType.LINEAR, null, {
                x:1,
                y:1,
                w:(_arg1 - 2),
                h:(_arg2 - 2),
                r:0
            });
            drawRoundRect(1, 1, (_arg1 - 2), (_arg2 - 2), 0, _local3, _local6, horizontalGradientMatrix(1, 1, ((_arg1 / 3) * 2), (_arg2 - 2)));
        }

    }
}//package mx.skins.halo 
