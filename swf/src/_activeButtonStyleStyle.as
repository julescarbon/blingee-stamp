package {
    import mx.core.*;
    import mx.styles.*;

    public class _activeButtonStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".activeButtonStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".activeButtonStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                };
            };
        }

    }
}//package 
