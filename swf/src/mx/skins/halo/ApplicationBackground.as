package mx.skins.halo {
    import flash.display.*;
    import mx.utils.*;
    import mx.skins.*;

    public class ApplicationBackground extends ProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override public function get measuredWidth():Number{
            return (8);
        }
        override public function get measuredHeight():Number{
            return (8);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local6:uint;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Graphics = graphics;
            var _local4:Array = getStyle("backgroundGradientColors");
            var _local5:Array = getStyle("backgroundGradientAlphas");
            if (!_local4){
                _local6 = getStyle("backgroundColor");
                if (isNaN(_local6)){
                    _local6 = 0xFFFFFF;
                };
                _local4 = [];
                _local4[0] = ColorUtil.adjustBrightness(_local6, 15);
                _local4[1] = ColorUtil.adjustBrightness(_local6, -25);
            };
            if (!_local5){
                _local5 = [1, 1];
            };
            _local3.clear();
            drawRoundRect(0, 0, _arg1, _arg2, 0, _local4, _local5, verticalGradientMatrix(0, 0, _arg1, _arg2));
        }

    }
}//package mx.skins.halo 
