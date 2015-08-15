package mx.controls {
    import flash.text.*;
    import mx.core.*;

    public class LinkButton extends Button {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;

        public function LinkButton(){
            buttonMode = true;
            extraSpacing = 4;
        }
        override protected function measure():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:TextLineMetrics;
            super.measure();
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                _local1 = 8;
                _local2 = 8;
                if (label){
                    _local7 = measureText(label);
                    _local1 = (_local1 + _local7.width);
                    _local2 = (_local2 + _local7.height);
                };
                _local1 = (_local1 + (getStyle("paddingLeft") + getStyle("paddingRight")));
                viewIcon();
                viewSkin();
                _local3 = ((currentIcon) ? currentIcon.width : 0);
                _local4 = ((currentIcon) ? currentIcon.height : 0);
                _local5 = 0;
                _local6 = 0;
                if ((((labelPlacement == ButtonLabelPlacement.LEFT)) || ((labelPlacement == ButtonLabelPlacement.RIGHT)))){
                    if (((label) && ((label.length > 0)))){
                        _local5 = (_local1 + _local3);
                    } else {
                        _local5 = _local3;
                    };
                    if (_local3 != 0){
                        _local5 = (_local5 + getStyle("horizontalGap"));
                    };
                    _local6 = Math.max(_local2, _local4);
                } else {
                    _local5 = Math.max(_local1, _local3);
                    if (((label) && ((label.length > 0)))){
                        _local6 = (_local2 + _local4);
                    } else {
                        _local6 = _local4;
                    };
                    if (_local4 != 0){
                        _local6 = (_local6 + getStyle("verticalGap"));
                    };
                };
                if (((label) && (!((label == ""))))){
                    _local5 = (_local5 + extraSpacing);
                };
                _local5 = Math.max(20, _local5);
                _local6 = Math.max(14, _local6);
                measuredMinWidth = (measuredWidth = _local5);
                measuredMinHeight = (measuredHeight = _local6);
            };
        }
        override public function set emphasized(_arg1:Boolean):void{
        }
        override protected function initializeAccessibility():void{
            if (createAccessibilityImplementation != null){
                createAccessibilityImplementation(this);
            };
        }

    }
}//package mx.controls 
