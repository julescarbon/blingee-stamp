package {
    import mx.core.*;
    import mx.styles.*;

    public class _TextAreaStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("TextArea");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("TextArea", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.horizontalScrollBarStyleName = "textAreaHScrollBarStyle";
                    this.backgroundDisabledColor = 0xDDDDDD;
                    this.borderStyle = "solid";
                    this.backgroundColor = 0xFFFFFF;
                    this.verticalScrollBarStyleName = "textAreaVScrollBarStyle";
                };
            };
        }

    }
}//package 
