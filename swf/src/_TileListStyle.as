package {
    import mx.core.*;
    import mx.styles.*;

    public class _TileListStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("TileList");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("TileList", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "center";
                    this.paddingLeft = 2;
                    this.paddingRight = 2;
                    this.verticalAlign = "middle";
                };
            };
        }

    }
}//package 
