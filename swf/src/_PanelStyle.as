package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _PanelStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var effects:* = null;
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Panel");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Panel", style, false);
                effects = style.mx_internal::effects;
                if (!effects){
                    effects = (style.mx_internal::effects = new Array());
                };
                effects.push("resizeEndEffect");
                effects.push("resizeStartEffect");
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.borderColor = 0xE2E2E2;
                    this.paddingLeft = 0;
                    this.roundedBottomCorners = false;
                    this.dropShadowEnabled = true;
                    this.resizeStartEffect = "Dissolve";
                    this.borderSkin = PanelSkin;
                    this.statusStyleName = "windowStatus";
                    this.borderAlpha = 0.4;
                    this.borderStyle = "default";
                    this.paddingBottom = 0;
                    this.resizeEndEffect = "Dissolve";
                    this.paddingTop = 0;
                    this.borderThicknessRight = 10;
                    this.titleStyleName = "windowStyles";
                    this.cornerRadius = 4;
                    this.paddingRight = 0;
                    this.borderThicknessLeft = 10;
                    this.titleBackgroundSkin = TitleBackground;
                    this.borderThickness = 0;
                    this.borderThicknessTop = 2;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
