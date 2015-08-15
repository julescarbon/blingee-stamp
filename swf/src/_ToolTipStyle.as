package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ToolTipStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ToolTip");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ToolTip", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.paddingTop = 2;
                    this.borderColor = 9542041;
                    this.paddingLeft = 4;
                    this.cornerRadius = 2;
                    this.paddingRight = 4;
                    this.shadowColor = 0;
                    this.fontSize = 9;
                    this.borderSkin = ToolTipBorder;
                    this.backgroundAlpha = 0.95;
                    this.paddingBottom = 2;
                    this.borderStyle = "toolTip";
                    this.backgroundColor = 16777164;
                };
            };
        }

    }
}//package 
