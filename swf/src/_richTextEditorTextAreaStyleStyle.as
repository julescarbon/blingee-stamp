package {
    import mx.core.*;
    import mx.styles.*;

    public class _richTextEditorTextAreaStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".richTextEditorTextAreaStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".richTextEditorTextAreaStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                };
            };
        }

    }
}//package 
