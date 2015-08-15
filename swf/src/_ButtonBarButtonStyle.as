package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ButtonBarButtonStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ButtonBarButton");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ButtonBarButton", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.skin = ButtonBarButtonSkin;
                    this.selectedDownSkin = null;
                    this.selectedUpSkin = null;
                    this.selectedOverSkin = null;
                    this.upSkin = null;
                    this.overSkin = null;
                    this.horizontalGap = 1;
                    this.downSkin = null;
                    this.selectedDisabledSkin = null;
                    this.disabledSkin = null;
                };
            };
        }

    }
}//package 
