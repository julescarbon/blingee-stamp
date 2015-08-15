package {
    import mx.core.*;
    import mx.styles.*;

    public class _TabBarStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("TabBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("TabBar", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.textAlign = "center";
                    this.horizontalAlign = "left";
                    this.verticalAlign = "top";
                    this.verticalGap = -1;
                    this.horizontalGap = -1;
                    this.selectedTabTextStyleName = "activeTabStyle";
                };
            };
        }

    }
}//package 
