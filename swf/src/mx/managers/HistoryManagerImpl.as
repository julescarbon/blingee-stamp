package mx.managers {
    import flash.display.*;
    import mx.core.*;
    import mx.events.*;
    import flash.utils.*;

    public class HistoryManagerImpl implements IHistoryManager {

        private static const NAME_VALUE_SEPARATOR:String = "=";
        private static const HANDSHAKE_INTERVAL:int = 500;
        private static const ID_NAME_SEPARATOR:String = "-";
        private static const MAX_HANDSHAKE_TRIES:int = 100;
        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const PROPERTY_SEPARATOR:String = "&";

        private static var instance:IHistoryManager;
        private static var appID:String;
        private static var historyURL:String;
        private static var systemManager:ISystemManager;

        private var registeredObjects:Array;
        private var pendingQueryString:String;
        private var pendingStates:Object;
        private var registrationMap:Dictionary;

        public function HistoryManagerImpl(){
            var _local1:LoaderInfo;
            var _local2:String;
            registeredObjects = [];
            pendingStates = {};
            super();
            if (instance){
                throw (new Error("Instance already exists."));
            };
            if (appID){
                return;
            };
            if (!ApplicationGlobals.application.historyManagementEnabled){
                return;
            };
            if (HistoryManagerGlobals.loaderInfo){
                _local1 = HistoryManagerGlobals.loaderInfo;
            } else {
                _local1 = DisplayObject(systemManager).loaderInfo;
            };
            if (HistoryManagerGlobals.loaderInfo){
                _local2 = HistoryManagerGlobals.loaderInfo.url;
            } else {
                _local2 = DisplayObject(systemManager).loaderInfo.url;
            };
            appID = calcCRC(_local2);
            BrowserManager.getInstance().addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, browserURLChangeHandler);
            BrowserManager.getInstance().initForHistoryManager();
        }
        public static function getInstance():IHistoryManager{
            if (!instance){
                systemManager = SystemManagerGlobals.topLevelSystemManagers[0];
                instance = new (HistoryManagerImpl)();
            };
            return (instance);
        }

        public function registered():void{
        }
        public function unregister(_arg1:IHistoryManagerClient):void{
            if (!ApplicationGlobals.application.historyManagementEnabled){
                return;
            };
            var _local2 = -1;
            var _local3:int = registeredObjects.length;
            var _local4:int;
            while (_local4 < _local3) {
                if (registeredObjects[_local4] == _arg1){
                    _local2 = _local4;
                    break;
                };
                _local4++;
            };
            if (_local2 >= 0){
                registeredObjects.splice(_local2, 1);
            };
            if (((_arg1) && (registrationMap))){
                delete registrationMap[_arg1];
            };
        }
        private function updateCRC(_arg1:uint, _arg2:uint):uint{
            var _local6:Boolean;
            var _local3:uint = 4129;
            var _local4:uint = 128;
            var _local5:int;
            while (_local5 < 8) {
                _local6 = !(((_arg1 & 0x8000) == 0));
                _arg1 = (_arg1 << 1);
                _arg1 = (_arg1 & 0xFFFF);
                if ((_arg2 & _local4) != 0){
                    _arg1++;
                };
                if (_local6){
                    _arg1 = (_arg1 ^ _local3);
                };
                _local4 = (_local4 >> 1);
                _local5++;
            };
            return (_arg1);
        }
        private function submitQuery():void{
            if (pendingQueryString){
                BrowserManager.getInstance().setFragment(pendingQueryString);
                pendingQueryString = null;
                ApplicationGlobals.application.resetHistory = true;
            };
        }
        public function browserURLChangeHandler(_arg1:BrowserChangeEvent):void{
            var _local2:String;
            var _local3:String;
            var _local9:Array;
            var _local10:int;
            var _local11:String;
            var _local12:Object;
            var _local13:IHistoryManagerClient;
            if (!ApplicationGlobals.application.historyManagementEnabled){
                return;
            };
            var _local4:Array = _arg1.url.split(PROPERTY_SEPARATOR);
            var _local5:Object = {};
            var _local6:int = _local4.length;
            var _local7:int;
            while (_local7 < _local6) {
                _local9 = _local4[_local7].split(NAME_VALUE_SEPARATOR);
                _local5[_local9[0]] = parseString(_local9[1]);
                _local7++;
            };
            var _local8:Object = {};
            for (_local2 in _local5) {
                _local10 = _local2.indexOf(ID_NAME_SEPARATOR);
                if (_local10 > -1){
                    _local3 = _local2.substr(0, _local10);
                    _local11 = _local2.substr((_local10 + 1), _local2.length);
                    _local12 = _local5[_local2];
                    if (!_local8[_local3]){
                        _local8[_local3] = {};
                    };
                    _local8[_local3][_local11] = _local12;
                };
            };
            _local6 = registeredObjects.length;
            _local7 = 0;
            while (_local7 < _local6) {
                _local13 = registeredObjects[_local7];
                _local3 = getRegistrationInfo(_local13).crc;
                _local13.loadState(_local8[_local3]);
                delete _local8[_local3];
                _local7++;
            };
            for (_local2 in _local8) {
                pendingStates[_local2] = _local8[_local2];
            };
        }
        public function registerHandshake():void{
        }
        private function getRegistrationInfo(_arg1:IHistoryManagerClient):RegistrationInfo{
            return (((registrationMap) ? registrationMap[_arg1] : null));
        }
        private function getPath(_arg1:IHistoryManagerClient):String{
            return (_arg1.toString());
        }
        public function load(_arg1:Object):void{
        }
        private function depthCompare(_arg1:Object, _arg2:Object):int{
            var _local3:RegistrationInfo = getRegistrationInfo(IHistoryManagerClient(_arg1));
            var _local4:RegistrationInfo = getRegistrationInfo(IHistoryManagerClient(_arg2));
            if (((!(_local3)) || (!(_local4)))){
                return (0);
            };
            if (_local3.depth > _local4.depth){
                return (1);
            };
            if (_local3.depth < _local4.depth){
                return (-1);
            };
            return (0);
        }
        public function register(_arg1:IHistoryManagerClient):void{
            if (!ApplicationGlobals.application.historyManagementEnabled){
                return;
            };
            unregister(_arg1);
            registeredObjects.push(_arg1);
            var _local2:String = getPath(_arg1);
            var _local3:String = calcCRC(_local2);
            var _local4:int = calcDepth(_local2);
            if (!registrationMap){
                registrationMap = new Dictionary(true);
            };
            registrationMap[_arg1] = new RegistrationInfo(_local3, _local4);
            registeredObjects.sort(depthCompare);
            if (pendingStates[_local3]){
                _arg1.loadState(pendingStates[_local3]);
                delete pendingStates[_local3];
            };
        }
        private function parseString(_arg1:String):Object{
            if (_arg1 == "true"){
                return (true);
            };
            if (_arg1 == "false"){
                return (false);
            };
            var _local2:int = parseInt(_arg1);
            if (_local2.toString() == _arg1){
                return (_local2);
            };
            var _local3:Number = parseFloat(_arg1);
            if (_local3.toString() == _arg1){
                return (_local3);
            };
            return (_arg1);
        }
        private function calcDepth(_arg1:String):int{
            return (_arg1.split(".").length);
        }
        public function loadInitialState():void{
        }
        public function save():void{
            var _local5:IHistoryManagerClient;
            var _local6:Object;
            var _local7:String;
            var _local8:String;
            var _local9:Object;
            if (!ApplicationGlobals.application.historyManagementEnabled){
                return;
            };
            var _local1:Boolean;
            var _local2:String = ("app=" + appID);
            var _local3:int = registeredObjects.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = registeredObjects[_local4];
                _local6 = _local5.saveState();
                _local7 = getRegistrationInfo(_local5).crc;
                for (_local8 in _local6) {
                    _local9 = _local6[_local8];
                    if (_local2.length > 0){
                        _local2 = (_local2 + PROPERTY_SEPARATOR);
                    };
                    _local2 = (_local2 + _local7);
                    _local2 = (_local2 + ID_NAME_SEPARATOR);
                    _local2 = (_local2 + escape(_local8));
                    _local2 = (_local2 + NAME_VALUE_SEPARATOR);
                    _local2 = (_local2 + escape(_local9.toString()));
                    _local1 = true;
                };
                _local4++;
            };
            if (_local1){
                pendingQueryString = _local2;
                ApplicationGlobals.application.callLater(this.submitQuery);
            };
        }
        private function calcCRC(_arg1:String):String{
            var _local5:uint;
            var _local6:uint;
            var _local7:uint;
            var _local2:uint = 0xFFFF;
            var _local3:int = _arg1.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = _arg1.charCodeAt(_local4);
                _local6 = (_local5 & 0xFF);
                _local7 = (_local5 >> 8);
                if (_local7 != 0){
                    _local2 = updateCRC(_local2, _local7);
                };
                _local2 = updateCRC(_local2, _local6);
                _local4++;
            };
            _local2 = updateCRC(_local2, 0);
            _local2 = updateCRC(_local2, 0);
            return (_local2.toString(16));
        }

    }
}//package mx.managers 

class RegistrationInfo {

    mx_internal static const VERSION:String = "3.2.0.3958";

    public var depth:int;
    public var crc:String;

    public function RegistrationInfo(_arg1:String, _arg2:int){
        this.crc = _arg1;
        this.depth = _arg2;
    }
}
