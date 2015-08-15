package mx.controls {
    import mx.core.*;
    import mx.controls.listClasses.*;

    public class TileList extends TileBase {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function TileList(){
            _horizontalScrollPolicy = ScrollPolicy.AUTO;
            itemRenderer = new ClassFactory(TileListItemRenderer);
        }
    }
}//package mx.controls 
