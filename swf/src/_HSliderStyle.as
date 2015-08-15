package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _HSliderStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("HSlider");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("HSlider", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.thumbOffset = 0;
                    this.borderColor = 9542041;
                    this.trackHighlightSkin = SliderHighlightSkin;
                    this.tickColor = 7305079;
                    this.tickOffset = -6;
                    this.labelOffset = -10;
                    this.tickLength = 4;
                    this.trackColors = [0xE7E7E7, 0xE7E7E7];
                    this.dataTipPlacement = "top";
                    this.dataTipOffset = 16;
                    this.trackSkin = SliderTrackSkin;
                    this.showTrackHighlight = false;
                    this.thumbSkin = SliderThumbSkin;
                    this.tickThickness = 1;
                    this.dataTipPrecision = 2;
                    this.slideDuration = 300;
                };
            };
        }

    }
}//package 
