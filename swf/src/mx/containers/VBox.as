package mx.containers {
    import mx.core.*;

    public class VBox extends Box {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function VBox(){
            mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
        }
        override public function set direction(_arg1:String):void{
        }

    }
}//package mx.containers 
