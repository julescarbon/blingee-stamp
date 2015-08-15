package mx.core {
    import flash.display.*;
    import flash.events.*;
    import mx.events.*;
    import flash.system.*;
    import flash.net.*;
    import mx.utils.*;

    public class RSLItem {

        mx_internal static const VERSION:String = "3.2.0.3958";

        protected var chainedSecurityErrorHandler:Function;
        public var total:uint = 0;
        public var loaded:uint = 0;
        private var completed:Boolean = false;
        protected var chainedRSLErrorHandler:Function;
        protected var chainedIOErrorHandler:Function;
        protected var chainedCompleteHandler:Function;
        private var errorText:String;
        protected var chainedProgressHandler:Function;
        public var urlRequest:URLRequest;
        public var rootURL:String;
        protected var url:String;

        public function RSLItem(_arg1:String, _arg2:String=null){
            this.url = _arg1;
            this.rootURL = _arg2;
        }
        public function itemProgressHandler(_arg1:ProgressEvent):void{
            loaded = _arg1.bytesLoaded;
            total = _arg1.bytesTotal;
            if (chainedProgressHandler != null){
                chainedProgressHandler(_arg1);
            };
        }
        public function itemErrorHandler(_arg1:ErrorEvent):void{
            errorText = decodeURI(_arg1.text);
            completed = true;
            loaded = 0;
            total = 0;
            trace(errorText);
            if ((((_arg1.type == IOErrorEvent.IO_ERROR)) && (!((chainedIOErrorHandler == null))))){
                chainedIOErrorHandler(_arg1);
            } else {
                if ((((_arg1.type == SecurityErrorEvent.SECURITY_ERROR)) && (!((chainedSecurityErrorHandler == null))))){
                    chainedSecurityErrorHandler(_arg1);
                } else {
                    if ((((_arg1.type == RSLEvent.RSL_ERROR)) && (!((chainedRSLErrorHandler == null))))){
                        chainedRSLErrorHandler(_arg1);
                    };
                };
            };
        }
        public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void{
            chainedProgressHandler = _arg1;
            chainedCompleteHandler = _arg2;
            chainedIOErrorHandler = _arg3;
            chainedSecurityErrorHandler = _arg4;
            chainedRSLErrorHandler = _arg5;
            var _local6:Loader = new Loader();
            var _local7:LoaderContext = new LoaderContext();
            urlRequest = new URLRequest(LoaderUtil.createAbsoluteURL(rootURL, url));
            _local6.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, itemProgressHandler);
            _local6.contentLoaderInfo.addEventListener(Event.COMPLETE, itemCompleteHandler);
            _local6.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, itemErrorHandler);
            _local6.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, itemErrorHandler);
            _local7.applicationDomain = ApplicationDomain.currentDomain;
            _local6.load(urlRequest, _local7);
        }
        public function itemCompleteHandler(_arg1:Event):void{
            completed = true;
            if (chainedCompleteHandler != null){
                chainedCompleteHandler(_arg1);
            };
        }

    }
}//package mx.core 
