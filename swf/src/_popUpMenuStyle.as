package {
    import mx.core.*;
    import mx.styles.*;

    public class _popUpMenuStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".popUpMenu");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".popUpMenu", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "left";
                    this.fontWeight = "normal";
                };
            };
        }

    }
}//package 
