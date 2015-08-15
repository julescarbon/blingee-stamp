package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _ComboBoxStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("ComboBox");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ComboBox", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.skin = ComboBoxArrowSkin;
                    this.paddingLeft = 5;
                    this.fontWeight = "bold";
                    this.disabledIconColor = 9542041;
                    this.cornerRadius = 5;
                    this.arrowButtonWidth = 22;
                    this.paddingRight = 5;
                    this.leading = 0;
                    this.dropdownStyleName = "comboDropdown";
                };
            };
        }

    }
}//package 
