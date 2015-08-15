package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _LinkButtonStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("LinkButton");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("LinkButton", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.skin = LinkButtonSkin;
                    this.paddingLeft = 7;
                    this.selectedDownSkin = null;
                    this.selectedUpSkin = null;
                    this.paddingRight = 7;
                    this.selectedOverSkin = null;
                    this.upSkin = null;
                    this.overSkin = null;
                    this.downSkin = null;
                    this.selectedDisabledSkin = null;
                    this.disabledSkin = null;
                };
            };
        }

    }
}//package 
