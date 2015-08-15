package {
    import mx.core.*;
    import mx.styles.*;

    public class _TextInputStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("TextInput");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("TextInput", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.backgroundDisabledColor = 0xDDDDDD;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
        }

    }
}//package 
