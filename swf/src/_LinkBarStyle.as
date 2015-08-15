package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _LinkBarStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("LinkBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("LinkBar", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 2;
                    this.paddingLeft = 2;
                    this.separatorWidth = 1;
                    this.paddingRight = 2;
                    this.separatorSkin = LinkSeparator;
                    this.verticalGap = 8;
                    this.linkButtonStyleName = "linkButtonStyle";
                    this.horizontalGap = 8;
                    this.paddingBottom = 2;
                    this.separatorColor = 12897484;
                };
            };
        }

    }
}//package 
