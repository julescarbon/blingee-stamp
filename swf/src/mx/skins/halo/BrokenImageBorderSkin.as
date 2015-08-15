package mx.skins.halo {
    import flash.display.*;
    import mx.skins.*;

    public class BrokenImageBorderSkin extends ProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Graphics = graphics;
            _local3.clear();
            _local3.lineStyle(1, getStyle("borderColor"));
            _local3.drawRect(0, 0, _arg1, _arg2);
        }

    }
}//package mx.skins.halo 
