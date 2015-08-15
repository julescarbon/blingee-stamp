package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ButtonStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Button");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Button", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 2;
                    this.textAlign = "center";
                    this.skin = ButtonSkin;
                    this.paddingLeft = 10;
                    this.fontWeight = "bold";
                    this.cornerRadius = 4;
                    this.paddingRight = 10;
                    this.verticalGap = 2;
                    this.horizontalGap = 2;
                    this.paddingBottom = 2;
                };
            };
        }

    }
}//package 
