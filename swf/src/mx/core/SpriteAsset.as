package mx.core {

    public class SpriteAsset extends FlexSprite implements IFlexAsset, IFlexDisplayObject, IBorder {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _measuredHeight:Number;
        private var _measuredWidth:Number;

        public function SpriteAsset(){
            _measuredWidth = width;
            _measuredHeight = height;
        }
        public function get measuredWidth():Number{
            return (_measuredWidth);
        }
        public function get measuredHeight():Number{
            return (_measuredHeight);
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            width = _arg1;
            height = _arg2;
        }
        public function move(_arg1:Number, _arg2:Number):void{
            this.x = _arg1;
            this.y = _arg2;
        }
        public function get borderMetrics():EdgeMetrics{
            if (scale9Grid == null){
                return (EdgeMetrics.EMPTY);
            };
            return (new EdgeMetrics(scale9Grid.left, scale9Grid.top, Math.ceil((measuredWidth - scale9Grid.right)), Math.ceil((measuredHeight - scale9Grid.bottom))));
        }

    }
}//package mx.core 
