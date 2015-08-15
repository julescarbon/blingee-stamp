package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _globalStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("global");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("global", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.fontWeight = "normal";
                    this.modalTransparencyBlur = 3;
                    this.verticalGridLineColor = 14015965;
                    this.borderStyle = "inset";
                    this.buttonColor = 7305079;
                    this.borderCapColor = 9542041;
                    this.textAlign = "left";
                    this.disabledIconColor = 0x999999;
                    this.stroked = false;
                    this.fillColors = [0xFFFFFF, 0xCCCCCC, 0xFFFFFF, 0xEEEEEE];
                    this.fontStyle = "normal";
                    this.borderSides = "left top right bottom";
                    this.borderThickness = 1;
                    this.modalTransparencyDuration = 100;
                    this.useRollOver = true;
                    this.strokeWidth = 1;
                    this.filled = true;
                    this.borderColor = 12040892;
                    this.horizontalGridLines = false;
                    this.horizontalGridLineColor = 0xF7F7F7;
                    this.shadowCapColor = 14015965;
                    this.fontGridFitType = "pixel";
                    this.horizontalAlign = "left";
                    this.modalTransparencyColor = 0xDDDDDD;
                    this.disabledColor = 11187123;
                    this.borderSkin = HaloBorder;
                    this.dropShadowColor = 0;
                    this.paddingBottom = 0;
                    this.indentation = 17;
                    this.version = "3.0.0";
                    this.fontThickness = 0;
                    this.verticalGridLines = true;
                    this.embedFonts = false;
                    this.fontSharpness = 0;
                    this.shadowDirection = "center";
                    this.textDecoration = "none";
                    this.selectionDuration = 250;
                    this.bevel = true;
                    this.fillColor = 0xFFFFFF;
                    this.focusBlendMode = "normal";
                    this.dropShadowEnabled = false;
                    this.textRollOverColor = 2831164;
                    this.textIndent = 0;
                    this.fontSize = 10;
                    this.openDuration = 250;
                    this.closeDuration = 250;
                    this.kerning = false;
                    this.paddingTop = 0;
                    this.highlightAlphas = [0.3, 0];
                    this.cornerRadius = 0;
                    this.horizontalGap = 8;
                    this.textSelectedColor = 2831164;
                    this.paddingLeft = 0;
                    this.modalTransparency = 0.5;
                    this.roundedBottomCorners = true;
                    this.repeatDelay = 500;
                    this.selectionDisabledColor = 0xDDDDDD;
                    this.fontAntiAliasType = "advanced";
                    this.focusSkin = HaloFocusRect;
                    this.verticalGap = 6;
                    this.leading = 2;
                    this.shadowColor = 0xEEEEEE;
                    this.backgroundAlpha = 1;
                    this.iconColor = 0x111111;
                    this.focusAlpha = 0.4;
                    this.borderAlpha = 1;
                    this.focusThickness = 2;
                    this.themeColor = 40447;
                    this.backgroundSize = "auto";
                    this.indicatorGap = 14;
                    this.letterSpacing = 0;
                    this.fontFamily = "Verdana";
                    this.fillAlphas = [0.6, 0.4, 0.75, 0.65];
                    this.color = 734012;
                    this.paddingRight = 0;
                    this.errorColor = 0xFF0000;
                    this.verticalAlign = "top";
                    this.focusRoundedCorners = "tl tr bl br";
                    this.shadowDistance = 2;
                    this.repeatInterval = 35;
                };
            };
        }

    }
}//package 
