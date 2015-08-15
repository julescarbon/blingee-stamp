package mx.core {
    import flash.display.*;
    import mx.utils.*;

    public class FlexLoader extends Loader {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function FlexLoader(){
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
