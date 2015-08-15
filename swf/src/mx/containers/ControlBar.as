package mx.containers {
    import mx.core.*;

    public class ControlBar extends Box {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function ControlBar(){
            direction = BoxDirection.HORIZONTAL;
        }
        override public function set verticalScrollPolicy(_arg1:String):void{
        }
        override public function set horizontalScrollPolicy(_arg1:String):void{
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            if (contentPane){
                contentPane.opaqueBackground = null;
            };
        }
        override public function set enabled(_arg1:Boolean):void{
            if (_arg1 != super.enabled){
                super.enabled = _arg1;
                alpha = ((_arg1) ? 1 : 0.4);
            };
        }
        override public function get horizontalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        override public function invalidateSize():void{
            super.invalidateSize();
            if (parent){
                Container(parent).invalidateViewMetricsAndPadding();
            };
        }
        override public function get verticalScrollPolicy():String{
            return (ScrollPolicy.OFF);
        }
        override public function set includeInLayout(_arg1:Boolean):void{
            var _local2:Container;
            if (includeInLayout != _arg1){
                super.includeInLayout = _arg1;
                _local2 = (parent as Container);
                if (_local2){
                    _local2.invalidateViewMetricsAndPadding();
                };
            };
        }

    }
}//package mx.containers 
