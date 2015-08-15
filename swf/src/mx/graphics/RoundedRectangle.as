package mx.graphics {
    import flash.geom.*;
    import mx.core.*;

    public class RoundedRectangle extends Rectangle {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var cornerRadius:Number = 0;

        public function RoundedRectangle(_arg1:Number=0, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0, _arg5:Number=0){
            super(_arg1, _arg2, _arg3, _arg4);
            this.cornerRadius = _arg5;
        }
    }
}//package mx.graphics 
