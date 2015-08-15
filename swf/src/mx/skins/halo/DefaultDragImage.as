package mx.skins.halo {
    import flash.display.*;
    import mx.core.*;

    public class DefaultDragImage extends SpriteAsset implements IFlexDisplayObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function DefaultDragImage(){
            draw(10, 10);
            super();
        }
        override public function get measuredWidth():Number{
            return (10);
        }
        override public function move(_arg1:Number, _arg2:Number):void{
            this.x = _arg1;
            this.y = _arg2;
        }
        override public function get measuredHeight():Number{
            return (10);
        }
        override public function setActualSize(_arg1:Number, _arg2:Number):void{
            draw(_arg1, _arg2);
        }
        private function draw(_arg1:Number, _arg2:Number):void{
            var _local3:Graphics = graphics;
            _local3.clear();
            _local3.beginFill(0xEEEEEE);
            _local3.lineStyle(1, 8433818);
            _local3.drawRect(0, 0, _arg1, _arg2);
            _local3.endFill();
        }

    }
}//package mx.skins.halo 
