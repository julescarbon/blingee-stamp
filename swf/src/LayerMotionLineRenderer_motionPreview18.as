package {
    import mx.core.*;
    import flash.utils.*;

    public class LayerMotionLineRenderer_motionPreview18 extends MovieClipLoaderAsset {

        private static var bytes:ByteArray = null;

        public var dataClass:Class;

        public function LayerMotionLineRenderer_motionPreview18(){
            dataClass = LayerMotionLineRenderer_motionPreview18_dataClass;
            super();
            initialWidth = (1000 / 20);
            initialHeight = (1000 / 20);
        }
        override public function get movieClipData():ByteArray{
            if (bytes == null){
                bytes = ByteArray(new dataClass());
            };
            return (bytes);
        }

    }
}//package 
