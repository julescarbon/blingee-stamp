package mx.skins.halo {
    import mx.core.*;
    import mx.skins.*;

    public class LinkButtonSkin extends Border {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("cornerRadius");
            var _local4:uint = getStyle("rollOverColor");
            var _local5:uint = getStyle("selectionColor");
            graphics.clear();
            switch (name){
                case "upSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local3, 0, 0);
                    break;
                case "overSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local3, _local4, 1);
                    break;
                case "downSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local3, _local5, 1);
                    break;
                case "disabledSkin":
                    drawRoundRect(0, 0, _arg1, _arg2, _local3, 0, 0);
                    break;
            };
        }
        override public function get borderMetrics():EdgeMetrics{
            return (EdgeMetrics.EMPTY);
        }

    }
}//package mx.skins.halo 
