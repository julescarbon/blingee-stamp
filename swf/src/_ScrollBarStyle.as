package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ScrollBarStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ScrollBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ScrollBar", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.trackColors = [9738651, 0xE7E7E7];
                    this.thumbOffset = 0;
                    this.paddingTop = 0;
                    this.downArrowSkin = ScrollArrowSkin;
                    this.borderColor = 12040892;
                    this.paddingLeft = 0;
                    this.cornerRadius = 4;
                    this.paddingRight = 0;
                    this.trackSkin = ScrollTrackSkin;
                    this.thumbSkin = ScrollThumbSkin;
                    this.paddingBottom = 0;
                    this.upArrowSkin = ScrollArrowSkin;
                };
            };
        }

    }
}//package 
