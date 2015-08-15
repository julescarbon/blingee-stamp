package mx.resources {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.system.*;
    import mx.modules.*;
    import flash.utils.*;
    import mx.utils.*;

    public class ResourceManagerImpl extends EventDispatcher implements IResourceManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:IResourceManager;

        private var resourceModules:Object;
        private var initializedForNonFrameworkApp:Boolean = false;
        private var localeMap:Object;
        private var _localeChain:Array;

        public function ResourceManagerImpl(){
            localeMap = {};
            resourceModules = {};
            super();
        }
        public static function getInstance():IResourceManager{
            if (!instance){
                instance = new (ResourceManagerImpl)();
            };
            return (instance);
        }

        public function get localeChain():Array{
            return (_localeChain);
        }
        public function set localeChain(_arg1:Array):void{
            _localeChain = _arg1;
            update();
        }
        public function getStringArray(_arg1:String, _arg2:String, _arg3:String=null):Array{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (null);
            };
            var _local5:* = _local4.content[_arg2];
            var _local6:Array = String(_local5).split(",");
            var _local7:int = _local6.length;
            var _local8:int;
            while (_local8 < _local7) {
                _local6[_local8] = StringUtil.trim(_local6[_local8]);
                _local8++;
            };
            return (_local6);
        }
        mx_internal function installCompiledResourceBundle(_arg1:ApplicationDomain, _arg2:String, _arg3:String):void{
            var _local4:String;
            var _local5:String = _arg3;
            var _local6:int = _arg3.indexOf(":");
            if (_local6 != -1){
                _local4 = _arg3.substring(0, _local6);
                _local5 = _arg3.substring((_local6 + 1));
            };
            if (getResourceBundle(_arg2, _arg3)){
                return;
            };
            var _local7 = (((_arg2 + "$") + _local5) + "_properties");
            if (_local4 != null){
                _local7 = ((_local4 + ".") + _local7);
            };
            var _local8:Class;
            if (_arg1.hasDefinition(_local7)){
                _local8 = Class(_arg1.getDefinition(_local7));
            };
            if (!_local8){
                _local7 = _arg3;
                if (_arg1.hasDefinition(_local7)){
                    _local8 = Class(_arg1.getDefinition(_local7));
                };
            };
            if (!_local8){
                _local7 = (_arg3 + "_properties");
                if (_arg1.hasDefinition(_local7)){
                    _local8 = Class(_arg1.getDefinition(_local7));
                };
            };
            if (!_local8){
                throw (new Error((((("Could not find compiled resource bundle '" + _arg3) + "' for locale '") + _arg2) + "'.")));
            };
            var _local9:ResourceBundle = ResourceBundle(new (_local8)());
            _local9.mx_internal::_locale = _arg2;
            _local9.mx_internal::_bundleName = _arg3;
            addResourceBundle(_local9);
        }
        public function getString(_arg1:String, _arg2:String, _arg3:Array=null, _arg4:String=null):String{
            var _local5:IResourceBundle = findBundle(_arg1, _arg2, _arg4);
            if (!_local5){
                return (null);
            };
            var _local6:String = String(_local5.content[_arg2]);
            if (_arg3){
                _local6 = StringUtil.substitute(_local6, _arg3);
            };
            return (_local6);
        }
        public function loadResourceModule(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher{
            var moduleInfo:* = null;
            var resourceEventDispatcher:* = null;
            var timer:* = null;
            var timerHandler:* = null;
            var url:* = _arg1;
            var updateFlag:Boolean = _arg2;
            var applicationDomain = _arg3;
            var securityDomain = _arg4;
            moduleInfo = ModuleManager.getModule(url);
            resourceEventDispatcher = new ResourceEventDispatcher(moduleInfo);
            var readyHandler:* = function (_arg1:ModuleEvent):void{
                var _local2:* = _arg1.module.factory.create();
                resourceModules[_arg1.module.url].resourceModule = _local2;
                if (updateFlag){
                    update();
                };
            };
            moduleInfo.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            var errorHandler:* = function (_arg1:ModuleEvent):void{
                var _local3:ResourceEvent;
                var _local2:String = ("Unable to load resource module from " + url);
                if (resourceEventDispatcher.willTrigger(ResourceEvent.ERROR)){
                    _local3 = new ResourceEvent(ResourceEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
                    _local3.bytesLoaded = 0;
                    _local3.bytesTotal = 0;
                    _local3.errorText = _local2;
                    resourceEventDispatcher.dispatchEvent(_local3);
                } else {
                    throw (new Error(_local2));
                };
            };
            moduleInfo.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            resourceModules[url] = new ResourceModuleInfo(moduleInfo, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (_arg1:TimerEvent):void{
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                moduleInfo.load(applicationDomain, securityDomain);
            };
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return (resourceEventDispatcher);
        }
        public function getLocales():Array{
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in localeMap) {
                _local1.push(_local2);
            };
            return (_local1);
        }
        public function removeResourceBundlesForLocale(_arg1:String):void{
            delete localeMap[_arg1];
        }
        public function getResourceBundle(_arg1:String, _arg2:String):IResourceBundle{
            var _local3:Object = localeMap[_arg1];
            if (!_local3){
                return (null);
            };
            return (_local3[_arg2]);
        }
        private function dumpResourceModule(_arg1):void{
            var _local2:ResourceBundle;
            var _local3:String;
            for each (_local2 in _arg1.resourceBundles) {
                trace(_local2.locale, _local2.bundleName);
                for (_local3 in _local2.content) {
                };
            };
        }
        public function addResourceBundle(_arg1:IResourceBundle):void{
            var _local2:String = _arg1.locale;
            var _local3:String = _arg1.bundleName;
            if (!localeMap[_local2]){
                localeMap[_local2] = {};
            };
            localeMap[_local2][_local3] = _arg1;
        }
        public function getObject(_arg1:String, _arg2:String, _arg3:String=null){
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (undefined);
            };
            return (_local4.content[_arg2]);
        }
        public function getInt(_arg1:String, _arg2:String, _arg3:String=null):int{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (0);
            };
            var _local5:* = _local4.content[_arg2];
            return (int(_local5));
        }
        private function findBundle(_arg1:String, _arg2:String, _arg3:String):IResourceBundle{
            supportNonFrameworkApps();
            return (((_arg3)!=null) ? getResourceBundle(_arg3, _arg1) : findResourceBundleWithResource(_arg1, _arg2));
        }
        private function supportNonFrameworkApps():void{
            if (initializedForNonFrameworkApp){
                return;
            };
            initializedForNonFrameworkApp = true;
            if (getLocales().length > 0){
                return;
            };
            var _local1:ApplicationDomain = ApplicationDomain.currentDomain;
            if (!_local1.hasDefinition("_CompiledResourceBundleInfo")){
                return;
            };
            var _local2:Class = Class(_local1.getDefinition("_CompiledResourceBundleInfo"));
            var _local3:Array = _local2.compiledLocales;
            var _local4:Array = _local2.compiledResourceBundleNames;
            installCompiledResourceBundles(_local1, _local3, _local4);
            localeChain = _local3;
        }
        public function getBundleNamesForLocale(_arg1:String):Array{
            var _local3:String;
            var _local2:Array = [];
            for (_local3 in localeMap[_arg1]) {
                _local2.push(_local3);
            };
            return (_local2);
        }
        public function getPreferredLocaleChain():Array{
            return (LocaleSorter.sortLocalesByPreference(getLocales(), getSystemPreferredLocales(), null, true));
        }
        public function getNumber(_arg1:String, _arg2:String, _arg3:String=null):Number{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (NaN);
            };
            var _local5:* = _local4.content[_arg2];
            return (Number(_local5));
        }
        public function update():void{
            dispatchEvent(new Event(Event.CHANGE));
        }
        public function getClass(_arg1:String, _arg2:String, _arg3:String=null):Class{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (null);
            };
            var _local5:* = _local4.content[_arg2];
            return ((_local5 as Class));
        }
        public function removeResourceBundle(_arg1:String, _arg2:String):void{
            delete localeMap[_arg1][_arg2];
            if (getBundleNamesForLocale(_arg1).length == 0){
                delete localeMap[_arg1];
            };
        }
        public function initializeLocaleChain(_arg1:Array):void{
            localeChain = LocaleSorter.sortLocalesByPreference(_arg1, getSystemPreferredLocales(), null, true);
        }
        public function findResourceBundleWithResource(_arg1:String, _arg2:String):IResourceBundle{
            var _local5:String;
            var _local6:Object;
            var _local7:ResourceBundle;
            if (!_localeChain){
                return (null);
            };
            var _local3:int = _localeChain.length;
            var _local4:int;
            while (_local4 < _local3) {
                _local5 = localeChain[_local4];
                _local6 = localeMap[_local5];
                if (!_local6){
                } else {
                    _local7 = _local6[_arg1];
                    if (!_local7){
                    } else {
                        if ((_arg2 in _local7.content)){
                            return (_local7);
                        };
                    };
                };
                _local4++;
            };
            return (null);
        }
        public function getUint(_arg1:String, _arg2:String, _arg3:String=null):uint{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (0);
            };
            var _local5:* = _local4.content[_arg2];
            return (uint(_local5));
        }
        private function getSystemPreferredLocales():Array{
            var _local1:Array;
            if (Capabilities["languages"]){
                _local1 = Capabilities["languages"];
            } else {
                _local1 = [Capabilities.language];
            };
            return (_local1);
        }
        public function installCompiledResourceBundles(_arg1:ApplicationDomain, _arg2:Array, _arg3:Array):void{
            var _local7:String;
            var _local8:int;
            var _local9:String;
            var _local4:int = ((_arg2) ? _arg2.length : 0);
            var _local5:int = ((_arg3) ? _arg3.length : 0);
            var _local6:int;
            while (_local6 < _local4) {
                _local7 = _arg2[_local6];
                _local8 = 0;
                while (_local8 < _local5) {
                    _local9 = _arg3[_local8];
                    mx_internal::installCompiledResourceBundle(_arg1, _local7, _local9);
                    _local8++;
                };
                _local6++;
            };
        }
        public function getBoolean(_arg1:String, _arg2:String, _arg3:String=null):Boolean{
            var _local4:IResourceBundle = findBundle(_arg1, _arg2, _arg3);
            if (!_local4){
                return (false);
            };
            var _local5:* = _local4.content[_arg2];
            return ((String(_local5).toLowerCase() == "true"));
        }
        public function unloadResourceModule(_arg1:String, _arg2:Boolean=true):void{
            throw (new Error("unloadResourceModule() is not yet implemented."));
        }

    }
}//package mx.resources 

import flash.events.*;
import mx.events.*;
import mx.modules.*;

class ResourceModuleInfo {

    public var resourceModule:IResourceModule;
    public var errorHandler:Function;
    public var readyHandler:Function;
    public var moduleInfo:IModuleInfo;

    public function ResourceModuleInfo(_arg1:IModuleInfo, _arg2:Function, _arg3:Function){
        this.moduleInfo = _arg1;
        this.readyHandler = _arg2;
        this.errorHandler = _arg3;
    }
}
class ResourceEventDispatcher extends EventDispatcher {

    public function ResourceEventDispatcher(_arg1:IModuleInfo){
        _arg1.addEventListener(ModuleEvent.ERROR, moduleInfo_errorHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.PROGRESS, moduleInfo_progressHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, moduleInfo_readyHandler, false, 0, true);
    }
    private function moduleInfo_progressHandler(_arg1:ModuleEvent):void{
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }
    private function moduleInfo_readyHandler(_arg1:ModuleEvent):void{
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.COMPLETE);
        dispatchEvent(_local2);
    }
    private function moduleInfo_errorHandler(_arg1:ModuleEvent):void{
        var _local2:ResourceEvent = new ResourceEvent(ResourceEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        _local2.errorText = _arg1.errorText;
        dispatchEvent(_local2);
    }

}
