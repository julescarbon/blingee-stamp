package mx.core {
    import flash.display.*;
    import mx.utils.*;

    public class FlexBitmap extends Bitmap {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function FlexBitmap(_arg1:BitmapData=null, _arg2:String="auto", _arg3:Boolean=false){
            var bitmapData = _arg1;
            var pixelSnapping:String = _arg2;
            var smoothing:Boolean = _arg3;
            super(bitmapData, pixelSnapping, smoothing);
            try {
                name = NameUtil.createUniqueName(this);
            } catch(e:Error) {
            };
        }
        override public function toString():String{
            return (NameUtil.displayObjectToString(this));
        }

    }
}//package mx.core 
