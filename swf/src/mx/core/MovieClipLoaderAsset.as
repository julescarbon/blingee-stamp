package mx.core {
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.system.*;

    public class MovieClipLoaderAsset extends MovieClipAsset implements IFlexAsset, IFlexDisplayObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        protected var initialHeight:Number = 0;
        private var loader:Loader = null;
        private var initialized:Boolean = false;
        protected var initialWidth:Number = 0;
        private var requestedHeight:Number;
        private var requestedWidth:Number;

        public function MovieClipLoaderAsset(){
            var _local1:LoaderContext = new LoaderContext();
            _local1.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            if (("allowLoadBytesCodeExecution" in _local1)){
                _local1["allowLoadBytesCodeExecution"] = true;
            };
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            loader.loadBytes(movieClipData, _local1);
            addChild(loader);
        }
        override public function get width():Number{
            if (!initialized){
                return (initialWidth);
            };
            return (super.width);
        }
        override public function set width(_arg1:Number):void{
            if (!initialized){
                requestedWidth = _arg1;
            } else {
                loader.width = _arg1;
            };
        }
        override public function get measuredHeight():Number{
            return (initialHeight);
        }
        private function completeHandler(_arg1:Event):void{
            initialized = true;
            initialWidth = loader.width;
            initialHeight = loader.height;
            if (!isNaN(requestedWidth)){
                loader.width = requestedWidth;
            };
            if (!isNaN(requestedHeight)){
                loader.height = requestedHeight;
            };
            dispatchEvent(_arg1);
        }
        override public function set height(_arg1:Number):void{
            if (!initialized){
                requestedHeight = _arg1;
            } else {
                loader.height = _arg1;
            };
        }
        override public function get measuredWidth():Number{
            return (initialWidth);
        }
        override public function get height():Number{
            if (!initialized){
                return (initialHeight);
            };
            return (super.height);
        }
        public function get movieClipData():ByteArray{
            return (null);
        }

    }
}//package mx.core 
