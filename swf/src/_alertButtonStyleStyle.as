package {
    import mx.core.*;
    import mx.styles.*;

    public class _alertButtonStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".alertButtonStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".alertButtonStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.color = 734012;
                };
            };
        }

    }
}//package 
