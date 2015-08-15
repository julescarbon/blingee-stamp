package mx.messaging.channels {
    import flash.events.*;
    import mx.resources.*;
    import mx.messaging.messages.*;
    import mx.messaging.*;
    import flash.net.*;
    import mx.messaging.errors.*;

    public class DirectHTTPChannel extends Channel {

        private static var clientCounter:uint;

        mx_internal var clientId:String;
        private var resourceManager:IResourceManager;

        public function DirectHTTPChannel(_arg1:String, _arg2:String=""){
            var _local3:String;
            resourceManager = ResourceManager.getInstance();
            super(_arg1, _arg2);
            if (_arg2.length > 0){
                _local3 = resourceManager.getString("messaging", "noURIAllowed");
                throw (new InvalidChannelError(_local3));
            };
            clientId = ("DirectHTTPChannel" + clientCounter++);
        }
        override public function setCredentials(_arg1:String, _arg2:MessageAgent=null, _arg3:String=null):void{
            var _local4:String = resourceManager.getString("messaging", "authenticationNotSupported");
            throw (new ChannelError(_local4));
        }
        override protected function internalSend(_arg1:MessageResponder):void{
            var httpMsgResp:* = null;
            var urlRequest:* = null;
            var msgResp:* = _arg1;
            httpMsgResp = DirectHTTPMessageResponder(msgResp);
            try {
                urlRequest = createURLRequest(httpMsgResp.message);
            } catch(e:MessageSerializationError) {
                httpMsgResp.agent.fault(e.fault, httpMsgResp.message);
                return;
            };
            var urlLoader:* = httpMsgResp.urlLoader;
            urlLoader.addEventListener(ErrorEvent.ERROR, httpMsgResp.errorHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, httpMsgResp.errorHandler);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, httpMsgResp.securityErrorHandler);
            urlLoader.addEventListener(Event.COMPLETE, httpMsgResp.completeHandler);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpMsgResp.httpStatusHandler);
            urlLoader.load(urlRequest);
        }
        override public function get connected():Boolean{
            return (true);
        }
        override mx_internal function get realtime():Boolean{
            return (false);
        }
        override protected function internalConnect():void{
            connectSuccess();
        }
        override protected function getMessageResponder(_arg1:MessageAgent, _arg2:IMessage):MessageResponder{
            return (new DirectHTTPMessageResponder(_arg1, _arg2, this, new URLLoader()));
        }
        override public function get protocol():String{
            return ("http");
        }
        override protected function connectTimeoutHandler(_arg1:TimerEvent):void{
        }
        mx_internal function createURLRequest(_arg1:IMessage):URLRequest{
            var _local8:Array;
            var _local9:URLRequestHeader;
            var _local10:String;
            var _local11:URLVariables;
            var _local12:Object;
            var _local13:String;
            var _local2:HTTPRequestMessage = HTTPRequestMessage(_arg1);
            var _local3:URLRequest = new URLRequest();
            var _local4:String = _local2.url;
            var _local5:String;
            _local3.contentType = _local2.contentType;
            var _local6:Boolean = (((_local3.contentType == HTTPRequestMessage.CONTENT_TYPE_XML)) || ((_local3.contentType == HTTPRequestMessage.CONTENT_TYPE_SOAP_XML)));
            var _local7:Object = _local2.httpHeaders;
            if (_local7){
                _local8 = [];
                for (_local10 in _local7) {
                    _local9 = new URLRequestHeader(_local10, _local7[_local10]);
                    _local8.push(_local9);
                };
                _local3.requestHeaders = _local8;
            };
            if (!_local6){
                _local11 = new URLVariables();
                _local12 = _local2.body;
                for (_local13 in _local12) {
                    _local11[_local13] = _local2.body[_local13];
                };
                _local5 = _local11.toString();
            };
            if ((((_local2.method == HTTPRequestMessage.POST_METHOD)) || (_local6))){
                _local3.method = "POST";
                if (_local3.contentType == HTTPRequestMessage.CONTENT_TYPE_FORM){
                    _local3.data = _local5;
                } else {
                    if (((!((_local2.body == null))) && ((_local2.body is XML)))){
                        _local3.data = XML(_local2.body).toXMLString();
                    } else {
                        _local3.data = _local2.body;
                    };
                };
            } else {
                if (((_local5) && (!((_local5 == ""))))){
                    _local4 = (_local4 + ((_local4.indexOf("?"))>-1) ? "&" : "?");
                    _local4 = (_local4 + _local5);
                };
            };
            _local3.url = _local4;
            return (_local3);
        }

    }
}//package mx.messaging.channels 

import flash.events.*;
import mx.resources.*;
import mx.messaging.messages.*;
import mx.messaging.*;
import flash.net.*;

class DirectHTTPMessageResponder extends MessageResponder {

    private var clientId:String;
    private var lastStatus:int;
    public var urlLoader:URLLoader;
    private var resourceManager:IResourceManager;

    public function DirectHTTPMessageResponder(_arg1:MessageAgent, _arg2:IMessage, _arg3:DirectHTTPChannel, _arg4:URLLoader){
        resourceManager = ResourceManager.getInstance();
        super(_arg1, _arg2, _arg3);
        this.urlLoader = _arg4;
        clientId = _arg3.clientId;
    }
    public function securityErrorHandler(_arg1:Event):void{
        status(null);
        var _local2:AcknowledgeMessage = new AcknowledgeMessage();
        _local2.clientId = clientId;
        _local2.correlationId = message.messageId;
        _local2.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
        agent.acknowledge(_local2, message);
        var _local3:ErrorMessage = new ErrorMessage();
        _local3.clientId = clientId;
        _local3.correlationId = message.messageId;
        _local3.faultCode = "Channel.Security.Error";
        _local3.faultString = resourceManager.getString("messaging", "securityError");
        _local3.faultDetail = resourceManager.getString("messaging", "securityError.details", [message.destination]);
        _local3.rootCause = _arg1;
        _local3.body = URLLoader(_arg1.target).data;
        _local3.headers[AbstractMessage.STATUS_CODE_HEADER] = lastStatus;
        agent.fault(_local3, message);
    }
    override protected function requestTimedOut():void{
        urlLoader.removeEventListener(ErrorEvent.ERROR, errorHandler);
        urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
        urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        urlLoader.close();
        status(null);
        var _local1:AcknowledgeMessage = new AcknowledgeMessage();
        _local1.clientId = clientId;
        _local1.correlationId = message.messageId;
        _local1.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
        agent.acknowledge(_local1, message);
        agent.fault(createRequestTimeoutErrorMessage(), message);
    }
    public function errorHandler(_arg1:Event):void{
        var _local3:ErrorMessage;
        status(null);
        var _local2:AcknowledgeMessage = new AcknowledgeMessage();
        _local2.clientId = clientId;
        _local2.correlationId = message.messageId;
        _local2.headers[AcknowledgeMessage.ERROR_HINT_HEADER] = true;
        agent.acknowledge(_local2, message);
        _local3 = new ErrorMessage();
        _local3.clientId = clientId;
        _local3.correlationId = message.messageId;
        _local3.faultCode = "Server.Error.Request";
        _local3.faultString = resourceManager.getString("messaging", "httpRequestError");
        var _local4:String = _arg1.toString();
        if ((message is HTTPRequestMessage)){
            _local4 = (_local4 + ". URL: ");
            _local4 = (_local4 + HTTPRequestMessage(message).url);
        };
        _local3.faultDetail = resourceManager.getString("messaging", "httpRequestError.details", [_local4]);
        _local3.rootCause = _arg1;
        _local3.body = URLLoader(_arg1.target).data;
        _local3.headers[AbstractMessage.STATUS_CODE_HEADER] = lastStatus;
        agent.fault(_local3, message);
    }
    public function httpStatusHandler(_arg1:HTTPStatusEvent):void{
        lastStatus = _arg1.status;
    }
    public function completeHandler(_arg1:Event):void{
        result(null);
        var _local2:AcknowledgeMessage = new AcknowledgeMessage();
        _local2.clientId = clientId;
        _local2.correlationId = message.messageId;
        _local2.body = URLLoader(_arg1.target).data;
        _local2.headers[AbstractMessage.STATUS_CODE_HEADER] = lastStatus;
        agent.acknowledge(_local2, message);
    }

}
