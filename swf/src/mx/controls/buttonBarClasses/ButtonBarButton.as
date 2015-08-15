package mx.controls.buttonBarClasses {
    import mx.core.*;
    import mx.controls.*;

    public class ButtonBarButton extends Button {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var inLayoutContents:Boolean = false;

        override mx_internal function layoutContents(_arg1:Number, _arg2:Number, _arg3:Boolean):void{
            inLayoutContents = true;
            super.layoutContents(_arg1, _arg2, _arg3);
            inLayoutContents = false;
        }
        override public function determineTextFormatFromStyles():UITextFormat{
            if (((inLayoutContents) && (selected))){
                return (textField.getUITextFormat());
            };
            return (super.determineTextFormatFromStyles());
        }

    }
}//package mx.controls.buttonBarClasses 
