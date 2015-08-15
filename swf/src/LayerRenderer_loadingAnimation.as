package {
    import mx.core.*;
    import flash.utils.*;

    public class LayerRenderer_loadingAnimation extends MovieClipLoaderAsset {

        private static var bytes:ByteArray = null;

        public var dataClass:Class;

        public function LayerRenderer_loadingAnimation(){
            dataClass = LayerRenderer_loadingAnimation_dataClass;
            super();
            initialWidth = (1080 / 20);
            initialHeight = (1100 / 20);
        }
        override public function get movieClipData():ByteArray{
            if (bytes == null){
                bytes = ByteArray(new dataClass());
            };
            return (bytes);
        }

    }
}//package 
