package {
    import mx.core.*;
    import mx.styles.*;

    public class _ButtonBarStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ButtonBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ButtonBar", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "center";
                    this.horizontalAlign = "center";
                    this.verticalAlign = "middle";
                    this.verticalGap = 0;
                    this.horizontalGap = 0;
                };
            };
        }

    }
}//package 
