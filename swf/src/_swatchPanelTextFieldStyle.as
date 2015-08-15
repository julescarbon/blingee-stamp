package {
    import mx.core.*;
    import mx.styles.*;

    public class _swatchPanelTextFieldStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration(".swatchPanelTextField");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".swatchPanelTextField", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.highlightColor = 12897484;
                    this.borderColor = 14015965;
                    this.paddingLeft = 5;
                    this.shadowCapColor = 14015965;
                    this.paddingRight = 5;
                    this.shadowColor = 14015965;
                    this.borderStyle = "inset";
                    this.buttonColor = 7305079;
                    this.backgroundColor = 0xFFFFFF;
                    this.borderCapColor = 9542041;
                };
            };
        }

    }
}//package 
