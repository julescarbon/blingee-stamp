package mx.controls.sliderClasses {
    import mx.controls.*;

    public class SliderLabel extends Label {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override mx_internal function getMinimumText(_arg1:String):String{
            if (((!(_arg1)) || ((_arg1.length < 1)))){
                _arg1 = "W";
            };
            return (_arg1);
        }

    }
}//package mx.controls.sliderClasses 
