package {
    import mx.core.*;
    import mx.styles.*;

    public class _HRuleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("HRule");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("HRule", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.strokeWidth = 2;
                    this.strokeColor = 12897484;
                };
            };
        }

    }
}//package 
