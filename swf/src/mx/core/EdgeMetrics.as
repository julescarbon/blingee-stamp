package mx.core {

    public class EdgeMetrics {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const EMPTY:EdgeMetrics = new EdgeMetrics(0, 0, 0, 0);
;

        public var top:Number;
        public var left:Number;
        public var bottom:Number;
        public var right:Number;

        public function EdgeMetrics(_arg1:Number=0, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0){
            this.left = _arg1;
            this.top = _arg2;
            this.right = _arg3;
            this.bottom = _arg4;
        }
        public function clone():EdgeMetrics{
            return (new EdgeMetrics(left, top, right, bottom));
        }

    }
}//package mx.core 
