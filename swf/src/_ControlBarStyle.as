package {
    import mx.core.*;
    import mx.styles.*;

    public class _ControlBarStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ControlBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ControlBar", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 10;
                    this.disabledOverlayAlpha = 0;
                    this.paddingLeft = 10;
                    this.paddingRight = 10;
                    this.verticalAlign = "middle";
                    this.paddingBottom = 10;
                    this.borderStyle = "controlBar";
                };
            };
        }

    }
}//package 
