package src {
    import flash.events.*;
    import mx.events.*;
    import mx.rpc.events.*;
    import mx.collections.*;
    import mx.rpc.http.*;

    public class PhotoService implements IEventDispatcher {

        public static const MODE_RETRIEVE_URL:int = 0;
        public static const MODE_PARSE_INPUT:int = 1;

        private var _bindingEventDispatcher:EventDispatcher;
        protected var m_Service:HTTPService;
        private var _319535984galleries:ArrayCollection;
        protected var m_EventDispatcher:EventDispatcher;
        public var imagesUrls:ArrayCollection;

        public function PhotoService(){
            _bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            m_EventDispatcher = new EventDispatcher();
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (_bindingEventDispatcher.dispatchEvent(_arg1));
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            _bindingEventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        private function ResultHandler(_arg1:ResultEvent):void{
            parseXml((_arg1.result as XML));
        }
        public function willTrigger(_arg1:String):Boolean{
            return (_bindingEventDispatcher.willTrigger(_arg1));
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            _bindingEventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function set galleries(_arg1:ArrayCollection):void{
            var _local2:Object = this._319535984galleries;
            if (_local2 !== _arg1){
                this._319535984galleries = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "galleries", _local2, _arg1));
            };
        }
        private function parseXml(_arg1:XML):void{
            var _local2:XML;
            var _local3:ArrayCollection;
            var _local4:XML;
            imagesUrls = new ArrayCollection();
            for each (_local2 in _arg1.Image) {
                imagesUrls.addItem(_local2.@imgHref);
                imagesUrls.addItem(_local2.@dbHref1);
                imagesUrls.addItem(_local2.@dbHref2);
                imagesUrls.addItem(_local2.@dbHref3);
                imagesUrls.addItem(_local2.@dbHref4);
            };
            _local3 = new ArrayCollection();
            for each (_local4 in _arg1.Blingees) {
                _local3.addItem(new Gallery(_local4));
            };
            galleries = _local3;
            m_EventDispatcher.dispatchEvent(new ResultEvent(ResultEvent.RESULT));
        }
        public function Initialize(_arg1:String, _arg2:Function, _arg3:int=0):void{
            m_EventDispatcher.addEventListener(ResultEvent.RESULT, _arg2);
            if (MODE_RETRIEVE_URL == _arg3){
                m_Service = new HTTPService();
                m_Service.url = _arg1;
                m_Service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
                m_Service.addEventListener(ResultEvent.RESULT, ResultHandler);
                m_Service.send();
            } else {
                if (MODE_PARSE_INPUT == _arg3){
                    parseXml(new XML(_arg1));
                };
            };
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (_bindingEventDispatcher.hasEventListener(_arg1));
        }
        public function get galleries():ArrayCollection{
            return (this._319535984galleries);
        }

    }
}//package src 
