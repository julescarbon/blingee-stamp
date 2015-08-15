package {
    import mx.resources.*;

    public class en_US$containers_properties extends ResourceBundle {

        public function en_US$containers_properties(){
            super("en_US", "containers");
        }
        override protected function getContent():Object{
            var _local1:Object = {
                noColumnsFound:"No ConstraintColumns found.",
                noRowsFound:"No ConstraintRows found.",
                rowNotFound:"ConstraintRow '{0}' not found.",
                columnNotFound:"ConstraintColumn '{0}' not found."
            };
            return (_local1);
        }

    }
}//package 
