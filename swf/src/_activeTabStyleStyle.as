package {
    import mx.core.*;
    import mx.styles.*;

    public class _activeTabStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".activeTabStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".activeTabStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.fontWeight = "bold";
                };
            };
        }

    }
}//package 
