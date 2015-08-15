package {
    import mx.core.*;
    import mx.styles.*;

    public class _headerDateTextStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".headerDateText");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".headerDateText", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "center";
                    this.fontWeight = "bold";
                };
            };
        }

    }
}//package 
