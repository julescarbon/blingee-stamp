package {
    import mx.core.*;
    import mx.styles.*;

    public class _textAreaVScrollBarStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".textAreaVScrollBarStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".textAreaVScrollBarStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                };
            };
        }

    }
}//package 
