package mx.skins.halo {
    import mx.skins.*;

    public class SliderHighlightSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override public function get measuredWidth():Number{
            return (1);
        }
        override public function get measuredHeight():Number{
            return (2);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:int = getStyle("themeColor");
            graphics.clear();
            drawRoundRect(0, 0, _arg1, 1, 0, _local3, 0.7);
            drawRoundRect(0, (_arg2 - 1), _arg1, 1, 0, _local3, 1);
            drawRoundRect(0, (_arg2 - 2), _arg1, 1, 0, _local3, 0.4);
        }

    }
}//package mx.skins.halo 
