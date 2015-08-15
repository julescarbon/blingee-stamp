package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ApplicationStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Application");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Application", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 24;
                    this.paddingLeft = 24;
                    this.backgroundGradientAlphas = [1, 1];
                    this.horizontalAlign = "center";
                    this.paddingRight = 24;
                    this.backgroundImage = ApplicationBackground;
                    this.paddingBottom = 24;
                    this.backgroundSize = "100%";
                    this.backgroundColor = 8821927;
                };
            };
        }

    }
}//package 
