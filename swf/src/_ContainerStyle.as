package {
    import mx.core.*;
    import mx.styles.*;

    public class _ContainerStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("Container");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Container", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.borderStyle = "none";
                };
            };
        }

    }
}//package 
