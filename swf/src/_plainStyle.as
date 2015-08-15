package {
    import mx.core.*;
    import mx.styles.*;

    public class _plainStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".plain");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".plain", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 0;
                    this.paddingLeft = 0;
                    this.horizontalAlign = "left";
                    this.paddingRight = 0;
                    this.backgroundImage = "";
                    this.paddingBottom = 0;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
