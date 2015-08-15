package mx.managers {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.external.*;

    public class BrowserManagerImpl extends EventDispatcher implements IBrowserManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:IBrowserManager;

        private var _defaultFragment:String = "";
        private var _title:String;
        private var browserMode:Boolean = true;
        private var _fragment:String;
        private var _url:String;
        private var _base:String;

        public function BrowserManagerImpl(){
            var sandboxRoot:* = null;
            var parent:* = null;
            super();
            var systemManager:* = SystemManagerGlobals.topLevelSystemManagers;
            if (systemManager){
                systemManager = systemManager[0];
            };
            if (systemManager){
                sandboxRoot = systemManager.getSandboxRoot();
                if (!sandboxRoot.dispatchEvent(new Event("mx.managers::BrowserManager", false, true))){
                    browserMode = false;
                    return;
                };
                try {
                    parent = sandboxRoot.parent;
                    while (parent) {
                        if ((sandboxRoot.parent is Stage)){
                            break;
                        };
                        parent = parent.parent;
                    };
                } catch(e:Error) {
                    browserMode = false;
                    return;
                };
                sandboxRoot.addEventListener("mx.managers::BrowserManager", sandboxBrowserManagerHandler, false, 0, true);
            };
            try {
                ExternalInterface.addCallback("browserURLChange", browserURLChangeBrowser);
                ExternalInterface.addCallback("debugTrace", debugTrace);
            } catch(e:Error) {
                browserMode = false;
            };
        }
        public static function getInstance():IBrowserManager{
            if (!instance){
                instance = new (BrowserManagerImpl)();
            };
            return (instance);
        }

        private function setup(_arg1:String, _arg2:String):void{
            if (!browserMode){
                return;
            };
            _defaultFragment = _arg1;
            _url = ExternalInterface.call("BrowserHistory.getURL");
            if (!_url){
                browserMode = false;
                return;
            };
            var _local3:int = _url.indexOf("#");
            if ((((_local3 == -1)) || ((_local3 == (_url.length - 1))))){
                _base = _url;
                _fragment = "";
                _title = _arg2;
                ExternalInterface.call("BrowserHistory.setDefaultURL", _arg1);
                setTitle(_arg2);
            } else {
                _base = _url.substring(0, _local3);
                _fragment = _url.substring((_local3 + 1));
                _title = ExternalInterface.call("BrowserHistory.getTitle");
                ExternalInterface.call("BrowserHistory.setDefaultURL", _fragment);
                if (_fragment != _defaultFragment){
                    browserURLChange(_fragment, true);
                };
            };
        }
        private function browserURLChange(_arg1:String, _arg2:Boolean=false):void{
            var _local3:String;
            if (((!((decodeURI(_fragment) == decodeURI(_arg1)))) || (_arg2))){
                _fragment = _arg1;
                _local3 = url;
                _url = ((_base + "#") + _arg1);
                dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.BROWSER_URL_CHANGE, false, false, url, _local3));
                dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.URL_CHANGE, false, false, url, _local3));
            };
        }
        public function get base():String{
            return (_base);
        }
        public function setFragment(_arg1:String):void{
            if (!browserMode){
                return;
            };
            var _local2:String = _url;
            var _local3:String = _fragment;
            _url = ((base + "#") + _arg1);
            _fragment = _arg1;
            if (dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.APPLICATION_URL_CHANGE, false, true, _url, _local2))){
                ExternalInterface.call("BrowserHistory.setBrowserURL", _arg1, ExternalInterface.objectID);
                dispatchEvent(new BrowserChangeEvent(BrowserChangeEvent.URL_CHANGE, false, false, _url, _local2));
            } else {
                _fragment = _local3;
                _url = _local2;
            };
        }
        private function debugTrace(_arg1:String):void{
            trace(_arg1);
        }
        public function get fragment():String{
            if (((_fragment) && (_fragment.length))){
                return (_fragment);
            };
            return (_defaultFragment);
        }
        public function get title():String{
            return (_title);
        }
        public function setTitle(_arg1:String):void{
            if (!browserMode){
                return;
            };
            ExternalInterface.call("BrowserHistory.setTitle", _arg1);
            _title = ExternalInterface.call("BrowserHistory.getTitle");
        }
        public function init(_arg1:String="", _arg2:String=""):void{
            ApplicationGlobals.application.historyManagementEnabled = false;
            setup(_arg1, _arg2);
        }
        private function sandboxBrowserManagerHandler(_arg1:Event):void{
            _arg1.preventDefault();
        }
        private function browserURLChangeBrowser(_arg1:String):void{
            browserURLChange(_arg1, false);
        }
        public function initForHistoryManager():void{
            setup("", "");
        }
        public function get url():String{
            return (_url);
        }

    }
}//package mx.managers 
