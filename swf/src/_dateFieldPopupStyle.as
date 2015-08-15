package {
    import mx.core.*;
    import mx.styles.*;

    public class _dateFieldPopupStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".dateFieldPopup");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".dateFieldPopup", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.dropShadowEnabled = true;
                    this.borderThickness = 0;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
