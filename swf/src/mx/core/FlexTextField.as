package mx.core {
    import flash.text.*;
    import mx.utils.*;

    public class FlexTextField extends TextField {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function FlexTextField(){
            super();
            try {
                name = NameUtil.createUniqueName(this);
            } catch(e:Error) {
            };
        }
        override public function toString():String{
            return (NameUtil.displayObjectToString(this));
        }

    }
}//package mx.core 
