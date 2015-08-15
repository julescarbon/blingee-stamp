package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _TabStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Tab");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Tab", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 1;
                    this.skin = TabSkin;
                    this.selectedDownSkin = null;
                    this.selectedUpSkin = null;
                    this.selectedOverSkin = null;
                    this.upSkin = null;
                    this.overSkin = null;
                    this.downSkin = null;
                    this.selectedDisabledSkin = null;
                    this.paddingBottom = 1;
                    this.disabledSkin = null;
                };
            };
        }

    }
}//package 
