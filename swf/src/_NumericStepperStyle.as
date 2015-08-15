package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _NumericStepperStyle {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("NumericStepper");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("NumericStepper", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.downArrowSkin = NumericStepperDownSkin;
                    this.cornerRadius = 5;
                    this.focusRoundedCorners = "tr br";
                    this.upArrowSkin = NumericStepperUpSkin;
                };
            };
        }

    }
}//package 
