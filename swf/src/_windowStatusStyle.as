package {
    import mx.core.*;
    import mx.styles.*;

    public class _windowStatusStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".windowStatus");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".windowStatus", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.color = 0x666666;
                };
            };
        }

    }
}//package 
