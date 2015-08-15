package {
    import mx.core.*;
    import mx.styles.*;

    public class _AlertStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Alert");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Alert", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 2;
                    this.borderColor = 8821927;
                    this.paddingLeft = 10;
                    this.color = 0xFFFFFF;
                    this.roundedBottomCorners = true;
                    this.paddingRight = 10;
                    this.backgroundAlpha = 0.9;
                    this.paddingBottom = 2;
                    this.borderAlpha = 0.9;
                    this.buttonStyleName = "alertButtonStyle";
                    this.backgroundColor = 8821927;
                };
            };
        }

    }
}//package 
