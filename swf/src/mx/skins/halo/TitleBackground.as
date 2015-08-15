package mx.skins.halo {
    import flash.display.*;
    import mx.styles.*;
    import mx.utils.*;
    import mx.skins.*;

    public class TitleBackground extends ProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = getStyle("borderAlpha");
            var _local4:Number = getStyle("cornerRadius");
            var _local5:Array = getStyle("highlightAlphas");
            var _local6:Array = getStyle("headerColors");
            var _local7 = !((_local6 == null));
            StyleManager.getColorNames(_local6);
            var _local8:Number = ColorUtil.adjustBrightness2(((_local6) ? _local6[1] : 0xFFFFFF), -20);
            var _local9:Graphics = graphics;
            _local9.clear();
            if (_arg2 < 3){
                return;
            };
            if (_local7){
                _local9.lineStyle(0, _local8, _local3);
                _local9.moveTo(0, _arg2);
                _local9.lineTo(_arg1, _arg2);
                _local9.lineStyle(0, 0, 0);
                drawRoundRect(0, 0, _arg1, _arg2, {
                    tl:_local4,
                    tr:_local4,
                    bl:0,
                    br:0
                }, _local6, _local3, verticalGradientMatrix(0, 0, _arg1, _arg2));
                drawRoundRect(0, 0, _arg1, (_arg2 / 2), {
                    tl:_local4,
                    tr:_local4,
                    bl:0,
                    br:0
                }, [0xFFFFFF, 0xFFFFFF], _local5, verticalGradientMatrix(0, 0, _arg1, (_arg2 / 2)));
                drawRoundRect(0, 0, _arg1, _arg2, {
                    tl:_local4,
                    tr:_local4,
                    bl:0,
                    br:0
                }, 0xFFFFFF, _local5[0], null, GradientType.LINEAR, null, {
                    x:0,
                    y:1,
                    w:_arg1,
                    h:(_arg2 - 1),
                    r:{
                        tl:_local4,
                        tr:_local4,
                        bl:0,
                        br:0
                    }
                });
            };
        }

    }
}//package mx.skins.halo 
