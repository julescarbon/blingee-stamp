package mx.skins.halo {
    import flash.display.*;
    import mx.skins.*;

    public class ListDropIndicator extends ProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var direction:String = "horizontal";

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Graphics = graphics;
            _local3.clear();
            _local3.lineStyle(2, 2831164);
            if (direction == "horizontal"){
                _local3.moveTo(0, 0);
                _local3.lineTo(_arg1, 0);
            } else {
                _local3.moveTo(0, 0);
                _local3.lineTo(0, _arg2);
            };
        }

    }
}//package mx.skins.halo 
