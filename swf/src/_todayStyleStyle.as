package {
    import mx.core.*;
    import mx.styles.*;

    public class _todayStyleStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".todayStyle");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".todayStyle", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "center";
                    this.color = 0xFFFFFF;
                };
            };
        }

    }
}//package 
