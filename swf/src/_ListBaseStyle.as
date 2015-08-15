package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ListBaseStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ListBase");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ListBase", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 2;
                    this.dropIndicatorSkin = ListDropIndicator;
                    this.paddingLeft = 2;
                    this.paddingRight = 0;
                    this.backgroundDisabledColor = 0xDDDDDD;
                    this.paddingBottom = 2;
                    this.borderStyle = "solid";
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
