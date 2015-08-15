package {
    import mx.resources.*;

    public class en_US$effects_properties extends ResourceBundle {

        public function en_US$effects_properties(){
            super("en_US", "effects");
        }
        override protected function getContent():Object{
            var _local1:Object = {
                incorrectTrigger:"The Zoom effect can not be triggered by a moveEffect trigger.",
                incorrectSource:"Source property must be a Class or String."
            };
            return (_local1);
        }

    }
}//package 
