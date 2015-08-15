package mx.rpc.http {
    import mx.resources.*;
    import mx.rpc.events.*;
    import mx.collections.*;
    import mx.messaging.messages.*;
    import mx.rpc.*;
    import flash.utils.*;
    import mx.messaging.*;
    import mx.logging.*;
    import flash.xml.*;
    import mx.messaging.channels.*;
    import mx.utils.*;
    import mx.messaging.config.*;
    import mx.rpc.xml.*;

    public class HTTPService extends AbstractInvoker {

        public static const RESULT_FORMAT_E4X:String = "e4x";
        public static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
        public static const RESULT_FORMAT_XML:String = "xml";
        public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
        public static const RESULT_FORMAT_TEXT:String = "text";
        public static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
        public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
        public static const CONTENT_TYPE_XML:String = "application/xml";
        public static const ERROR_ENCODING:String = "Client.CouldNotEncode";
        public static const RESULT_FORMAT_ARRAY:String = "array";
        public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
        public static const RESULT_FORMAT_OBJECT:String = "object";
        public static const ERROR_DECODING:String = "Client.CouldNotDecode";

        private static var _directChannelSet:ChannelSet;

        private var _log:ILogger;
        public var headers:Object;
        public var request:Object;
        private var _resultFormat:String = "object";
        public var xmlEncode:Function;
        private var _useProxy:Boolean = false;
        public var contentType:String = "application/x-www-form-urlencoded";
        public var method:String = "GET";
        public var xmlDecode:Function;
        mx_internal var _rootURL:String;
        private var _url:String;
        private var resourceManager:IResourceManager;

        public function HTTPService(_arg1:String=null, _arg2:String=null){
            resourceManager = ResourceManager.getInstance();
            headers = {};
            request = {};
            super();
            asyncRequest = new AsyncRequest();
            makeObjectsBindable = true;
            if (_arg2 == null){
                if (URLUtil.isHttpsURL(LoaderConfig.url)){
                    asyncRequest.destination = DEFAULT_DESTINATION_HTTPS;
                } else {
                    asyncRequest.destination = DEFAULT_DESTINATION_HTTP;
                };
            } else {
                asyncRequest.destination = _arg2;
                useProxy = true;
            };
            _log = Log.getLogger("mx.rpc.http.HTTPService");
        }
        private function getDirectChannelSet():ChannelSet{
            var _local1:ChannelSet;
            if (_directChannelSet == null){
                _local1 = new ChannelSet();
                _local1.addChannel(new DirectHTTPChannel("direct_http_channel"));
                _directChannelSet = _local1;
            };
            return (_directChannelSet);
        }
        public function send(_arg1:Object=null):AsyncToken{
            var _local2:Object;
            var _local3:AsyncToken;
            var _local4:Fault;
            var _local5:FaultEvent;
            var _local6:String;
            var _local8:Object;
            var _local9:SimpleXMLEncoder;
            var _local10:XMLDocument;
            var _local11:Array;
            var _local12:int;
            var _local13:Object;
            var _local14:Object;
            var _local15:*;
            var _local16:ChannelSet;
            if (_arg1 == null){
                _arg1 = request;
            };
            if (contentType == CONTENT_TYPE_XML){
                if (((!((_arg1 is XMLNode))) && (!((_arg1 is XML))))){
                    if (xmlEncode != null){
                        _local8 = xmlEncode(_arg1);
                        if (null == _local8){
                            _local3 = new AsyncToken(null);
                            _local6 = resourceManager.getString("rpc", "xmlEncodeReturnNull");
                            _local4 = new Fault(ERROR_ENCODING, _local6);
                            _local5 = FaultEvent.createEvent(_local4, _local3);
                            new AsyncDispatcher(dispatchRpcEvent, [_local5], 10);
                            return (_local3);
                        };
                        if (!(_local8 is XMLNode)){
                            _local3 = new AsyncToken(null);
                            _local6 = resourceManager.getString("rpc", "xmlEncodeReturnNoXMLNode");
                            _local4 = new Fault(ERROR_ENCODING, _local6);
                            _local5 = FaultEvent.createEvent(_local4, _local3);
                            new AsyncDispatcher(dispatchRpcEvent, [_local5], 10);
                            return (_local3);
                        };
                        _local2 = XMLNode(_local8).toString();
                    } else {
                        _local9 = new SimpleXMLEncoder(null);
                        _local10 = new XMLDocument();
                        _local11 = _local9.encodeValue(_arg1, new QName(null, "encoded"), new XMLNode(1, "top")).childNodes.concat();
                        _local12 = 0;
                        while (_local12 < _local11.length) {
                            _local10.appendChild(_local11[_local12]);
                            _local12++;
                        };
                        _local2 = _local10.toString();
                    };
                } else {
                    _local2 = XML(_arg1).toXMLString();
                };
            } else {
                if (contentType == CONTENT_TYPE_FORM){
                    _local2 = {};
                    _local14 = ObjectUtil.getClassInfo(_arg1);
                    for each (_local15 in _local14.properties) {
                        _local13 = _arg1[_local15];
                        if (_local13 != null){
                            if ((_local13 is Array)){
                                _local2[_local15] = _local13;
                            } else {
                                _local2[_local15] = _local13.toString();
                            };
                        };
                    };
                } else {
                    _local2 = _arg1;
                };
            };
            var _local7:HTTPRequestMessage = new HTTPRequestMessage();
            if (useProxy){
                if (((url) && (!((url == ""))))){
                    _local7.url = URLUtil.getFullURL(rootURL, url);
                };
            } else {
                if (!url){
                    _local3 = new AsyncToken(null);
                    _local6 = resourceManager.getString("rpc", "urlNotSpecified");
                    _local4 = new Fault(ERROR_URL_REQUIRED, _local6);
                    _local5 = FaultEvent.createEvent(_local4, _local3);
                    new AsyncDispatcher(dispatchRpcEvent, [_local5], 10);
                    return (_local3);
                };
                if (!useProxy){
                    _local16 = getDirectChannelSet();
                    if (_local16 != asyncRequest.channelSet){
                        asyncRequest.channelSet = _local16;
                    };
                };
                _local7.url = url;
            };
            _local7.contentType = contentType;
            _local7.method = method.toUpperCase();
            if ((((contentType == CONTENT_TYPE_XML)) && ((_local7.method == HTTPRequestMessage.GET_METHOD)))){
                _local7.method = HTTPRequestMessage.POST_METHOD;
            };
            _local7.body = _local2;
            _local7.httpHeaders = headers;
            return (invoke(_local7));
        }
        private function decodeArray(_arg1:Object):Object{
            var _local2:Array;
            if ((_arg1 is Array)){
                _local2 = (_arg1 as Array);
            } else {
                if ((_arg1 is ArrayCollection)){
                    return (_arg1);
                };
                _local2 = [];
                _local2.push(_arg1);
            };
            if (makeObjectsBindable){
                return (new ArrayCollection(_local2));
            };
            return (_local2);
        }
        public function set channelSet(_arg1:ChannelSet):void{
            useProxy = true;
            asyncRequest.channelSet = _arg1;
        }
        public function get destination():String{
            return (asyncRequest.destination);
        }
        public function get requestTimeout():int{
            return (asyncRequest.requestTimeout);
        }
        public function logout():void{
            asyncRequest.logout();
        }
        public function set useProxy(_arg1:Boolean):void{
            var _local2:ChannelSet;
            if (_arg1 != _useProxy){
                _useProxy = _arg1;
                _local2 = getDirectChannelSet();
                if (!useProxy){
                    if (_local2 != asyncRequest.channelSet){
                        asyncRequest.channelSet = _local2;
                    };
                } else {
                    if (asyncRequest.channelSet == _local2){
                        asyncRequest.channelSet = null;
                    };
                };
            };
        }
        public function get channelSet():ChannelSet{
            return (asyncRequest.channelSet);
        }
        public function set destination(_arg1:String):void{
            useProxy = true;
            asyncRequest.destination = _arg1;
        }
        public function set requestTimeout(_arg1:int):void{
            if (asyncRequest.requestTimeout != _arg1){
                asyncRequest.requestTimeout = _arg1;
            };
        }
        public function set url(_arg1:String):void{
            _url = _arg1;
        }
        public function get useProxy():Boolean{
            return (_useProxy);
        }
        public function set resultFormat(_arg1:String):void{
            var _local2:String;
            switch (_arg1){
                case RESULT_FORMAT_OBJECT:
                case RESULT_FORMAT_ARRAY:
                case RESULT_FORMAT_XML:
                case RESULT_FORMAT_E4X:
                case RESULT_FORMAT_TEXT:
                case RESULT_FORMAT_FLASHVARS:
                    break;
                default:
                    _local2 = resourceManager.getString("rpc", "invalidResultFormat", [_arg1, RESULT_FORMAT_OBJECT, RESULT_FORMAT_ARRAY, RESULT_FORMAT_XML, RESULT_FORMAT_E4X, RESULT_FORMAT_TEXT, RESULT_FORMAT_FLASHVARS]);
                    throw (new ArgumentError(_local2));
            };
            _resultFormat = _arg1;
        }
        public function set rootURL(_arg1:String):void{
            _rootURL = _arg1;
        }
        public function disconnect():void{
            asyncRequest.disconnect();
        }
        public function get url():String{
            return (_url);
        }
        public function get resultFormat():String{
            return (_resultFormat);
        }
        public function setRemoteCredentials(_arg1:String, _arg2:String, _arg3:String=null):void{
            asyncRequest.setRemoteCredentials(_arg1, _arg2, _arg3);
        }
        private function decodeParameterString(_arg1:String):Object{
            var _local6:String;
            var _local7:int;
            var _local8:String;
            var _local9:String;
            var _local2:String = StringUtil.trim(_arg1);
            var _local3:Array = _local2.split("&");
            var _local4:Object = {};
            var _local5:int;
            while (_local5 < _local3.length) {
                _local6 = _local3[_local5];
                _local7 = _local6.indexOf("=");
                if (_local7 != -1){
                    _local8 = unescape(_local6.substr(0, _local7));
                    _local8 = _local8.split("+").join(" ");
                    _local9 = unescape(_local6.substr((_local7 + 1)));
                    _local9 = _local9.split("+").join(" ");
                    _local4[_local8] = _local9;
                };
                _local5++;
            };
            return (_local4);
        }
        public function setCredentials(_arg1:String, _arg2:String, _arg3:String=null):void{
            asyncRequest.setCredentials(_arg1, _arg2, _arg3);
        }
        override mx_internal function processResult(_arg1:IMessage, _arg2:AsyncToken):Boolean{
            var tmp:* = null;
            var fault:* = null;
            var decoded:* = null;
            var msg:* = null;
            var fault1:* = null;
            var decoder:* = null;
            var fault2:* = null;
            var fault3:* = null;
            var message:* = _arg1;
            var token:* = _arg2;
            var body:* = message.body;
            _log.info("Decoding HTTPService response");
            _log.debug("Processing HTTPService response message:\n{0}", message);
            if ((((body == null)) || (((((!((body == null))) && ((body is String)))) && ((StringUtil.trim(String(body)) == "")))))){
                _result = body;
                return (true);
            };
            if ((body is String)){
                if ((((((resultFormat == RESULT_FORMAT_XML)) || ((resultFormat == RESULT_FORMAT_OBJECT)))) || ((resultFormat == RESULT_FORMAT_ARRAY)))){
                    tmp = new XMLDocument();
                    XMLDocument(tmp).ignoreWhite = true;
                    try {
                        XMLDocument(tmp).parseXML(String(body));
                    } catch(parseError:Error) {
                        fault = new Fault(ERROR_DECODING, parseError.message);
                        dispatchRpcEvent(FaultEvent.createEvent(fault, token, message));
                        return (false);
                    };
                    if ((((resultFormat == RESULT_FORMAT_OBJECT)) || ((resultFormat == RESULT_FORMAT_ARRAY)))){
                        if (xmlDecode != null){
                            decoded = xmlDecode(tmp);
                            if (decoded == null){
                                msg = resourceManager.getString("rpc", "xmlDecodeReturnNull");
                                fault1 = new Fault(ERROR_DECODING, msg);
                                dispatchRpcEvent(FaultEvent.createEvent(fault1, token, message));
                            };
                        } else {
                            decoder = new SimpleXMLDecoder(makeObjectsBindable);
                            decoded = decoder.decodeXML(XMLNode(tmp));
                            if (decoded == null){
                                msg = resourceManager.getString("rpc", "defaultDecoderFailed");
                                fault2 = new Fault(ERROR_DECODING, msg);
                                dispatchRpcEvent(FaultEvent.createEvent(fault2, token, message));
                            };
                        };
                        if (decoded == null){
                            return (false);
                        };
                        if (((makeObjectsBindable) && ((getQualifiedClassName(decoded) == "Object")))){
                            decoded = new ObjectProxy(decoded);
                        } else {
                            decoded = decoded;
                        };
                        if (resultFormat == RESULT_FORMAT_ARRAY){
                            decoded = decodeArray(decoded);
                        };
                        _result = decoded;
                    } else {
                        if (tmp.childNodes.length == 1){
                            tmp = tmp.firstChild;
                        };
                        _result = tmp;
                    };
                } else {
                    if (resultFormat == RESULT_FORMAT_E4X){
                        try {
                            _result = new XML(String(body));
                        } catch(error:Error) {
                            fault3 = new Fault(ERROR_DECODING, error.message);
                            dispatchRpcEvent(FaultEvent.createEvent(fault3, token, message));
                            return (false);
                        };
                    } else {
                        if (resultFormat == RESULT_FORMAT_FLASHVARS){
                            _result = decodeParameterString(String(body));
                        } else {
                            _result = body;
                        };
                    };
                };
            } else {
                if (resultFormat == RESULT_FORMAT_ARRAY){
                    body = decodeArray(body);
                };
                _result = body;
            };
            return (true);
        }
        public function get rootURL():String{
            if (_rootURL == null){
                _rootURL = LoaderConfig.url;
            };
            return (_rootURL);
        }

    }
}//package mx.rpc.http 
