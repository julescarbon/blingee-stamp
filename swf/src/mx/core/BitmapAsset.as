package mx.core {
    import flash.display.*;

    public class BitmapAsset extends FlexBitmap implements IFlexAsset, IFlexDisplayObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function BitmapAsset(_arg1:BitmapData=null, _arg2:String="auto", _arg3:Boolean=false){
            super(_arg1, _arg2, _arg3);
        }
        public function get measuredWidth():Number{
            if (bitmapData){
                return (bitmapData.width);
            };
            return (0);
        }
        public function get measuredHeight():Number{
            if (bitmapData){
                return (bitmapData.height);
            };
            return (0);
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            width = _arg1;
            height = _arg2;
        }
        public function move(_arg1:Number, _arg2:Number):void{
            this.x = _arg1;
            this.y = _arg2;
        }

    }
}//package mx.core 
