package {
    import mx.core.*;
    import flash.utils.*;

    public class Thumbnail_loadingAnimation extends MovieClipLoaderAsset {

        private static var bytes:ByteArray = null;

        public var dataClass:Class;

        public function Thumbnail_loadingAnimation(){
            dataClass = Thumbnail_loadingAnimation_dataClass;
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
