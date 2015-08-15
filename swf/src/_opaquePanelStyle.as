package {
    import mx.core.*;
    import mx.styles.*;

    public class _opaquePanelStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".opaquePanel");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".opaquePanel", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.footerColors = [0xE7E7E7, 0xC7C7C7];
                    this.borderColor = 0xFFFFFF;
                    this.headerColors = [0xE7E7E7, 0xD9D9D9];
                    this.borderAlpha = 1;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
