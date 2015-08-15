package mx.modules {
    import mx.core.*;

    public class ModuleManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function getModule(_arg1:String):IModuleInfo{
            return (getSingleton().getModule(_arg1));
        }
        private static function getSingleton():Object{
            if (!ModuleManagerGlobals.managerSingleton){
                ModuleManagerGlobals.managerSingleton = new ModuleManagerImpl();
            };
            return (ModuleManagerGlobals.managerSingleton);
        }
        public static function getAssociatedFactory(_arg1:Object):IFlexModuleFactory{
            return (getSingleton().getAssociatedFactory(_arg1));
        }

    }
}//package mx.modules 

import flash.display.*;
import mx.core.*;
import flash.events.*;
import mx.events.*;
import flash.system.*;
import flash.net.*;
import flash.utils.*;

class ModuleInfoProxy extends EventDispatcher implements IModuleInfo {

    private var _data:Object;
    private var info:ModuleInfo;
    private var referenced:Boolean = false;

    public function ModuleInfoProxy(_arg1:ModuleInfo){
        this.info = _arg1;
        _arg1.addEventListener(ModuleEvent.SETUP, moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.PROGRESS, moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.ERROR, moduleEventHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.UNLOAD, moduleEventHandler, false, 0, true);
    }
    public function get loaded():Boolean{
        return (info.loaded);
    }
    public function release():void{
        if (referenced){
            info.removeReference();
            referenced = false;
        };
    }
    public function get error():Boolean{
        return (info.error);
    }
    public function get factory():IFlexModuleFactory{
        return (info.factory);
    }
    public function publish(_arg1:IFlexModuleFactory):void{
        info.publish(_arg1);
    }
    public function set data(_arg1:Object):void{
        _data = _arg1;
    }
    public function get ready():Boolean{
        return (info.ready);
    }
    public function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null):void{
        var _local4:ModuleEvent;
        info.resurrect();
        if (!referenced){
            info.addReference();
            referenced = true;
        };
        if (info.error){
            dispatchEvent(new ModuleEvent(ModuleEvent.ERROR));
        } else {
            if (info.loaded){
                if (info.setup){
                    dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
                    if (info.ready){
                        _local4 = new ModuleEvent(ModuleEvent.PROGRESS);
                        _local4.bytesLoaded = info.size;
                        _local4.bytesTotal = info.size;
                        dispatchEvent(_local4);
                        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
                    };
                };
            } else {
                info.load(_arg1, _arg2, _arg3);
            };
        };
    }
    private function moduleEventHandler(_arg1:ModuleEvent):void{
        dispatchEvent(_arg1);
    }
    public function get url():String{
        return (info.url);
    }
    public function get data():Object{
        return (_data);
    }
    public function get setup():Boolean{
        return (info.setup);
    }
    public function unload():void{
        info.unload();
        info.removeEventListener(ModuleEvent.SETUP, moduleEventHandler);
        info.removeEventListener(ModuleEvent.PROGRESS, moduleEventHandler);
        info.removeEventListener(ModuleEvent.READY, moduleEventHandler);
        info.removeEventListener(ModuleEvent.ERROR, moduleEventHandler);
        info.removeEventListener(ModuleEvent.UNLOAD, moduleEventHandler);
    }

}
class ModuleManagerImpl extends EventDispatcher {

    private var moduleList:Object;

    public function ModuleManagerImpl(){
        moduleList = {};
        super();
    }
    public function getModule(_arg1:String):IModuleInfo{
        var _local2:ModuleInfo = (moduleList[_arg1] as ModuleInfo);
        if (!_local2){
            _local2 = new ModuleInfo(_arg1);
            moduleList[_arg1] = _local2;
        };
        return (new ModuleInfoProxy(_local2));
    }
    public function getAssociatedFactory(_arg1:Object):IFlexModuleFactory{
        var m:* = null;
        var info:* = null;
        var domain:* = null;
        var cls:* = null;
        var object:* = _arg1;
        var className:* = getQualifiedClassName(object);
        for each (m in moduleList) {
            info = (m as ModuleInfo);
            if (!info.ready){
            } else {
                domain = info.applicationDomain;
                try {
                    cls = Class(domain.getDefinition(className));
                    if ((object is cls)){
                        return (info.factory);
                    };
                } catch(error:Error) {
                };
            };
        };
        return (null);
    }

}
class ModuleInfo extends EventDispatcher {

    private var _error:Boolean = false;
    private var loader:Loader;
    private var factoryInfo:FactoryInfo;
    private var limbo:Dictionary;
    private var _loaded:Boolean = false;
    private var _ready:Boolean = false;
    private var numReferences:int = 0;
    private var _url:String;
    private var _setup:Boolean = false;

    public function ModuleInfo(_arg1:String){
        _url = _arg1;
    }
    private function clearLoader():void{
        if (loader){
            if (loader.contentLoaderInfo){
                loader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
                loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
                loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
                loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
                loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
            };
            try {
                if (loader.content){
                    loader.content.removeEventListener("ready", readyHandler);
                    loader.content.removeEventListener("error", moduleErrorHandler);
                };
            } catch(error:Error) {
            };
            if (_loaded){
                try {
                    loader.close();
                } catch(error:Error) {
                };
            };
            try {
                loader.unload();
            } catch(error:Error) {
            };
            loader = null;
        };
    }
    public function get size():int{
        return (((((!(limbo)) && (factoryInfo))) ? factoryInfo.bytesTotal : 0));
    }
    public function get loaded():Boolean{
        return (((limbo) ? false : _loaded));
    }
    public function release():void{
        if (((_ready) && (!(limbo)))){
            limbo = new Dictionary(true);
            limbo[factoryInfo] = 1;
            factoryInfo = null;
        } else {
            unload();
        };
    }
    public function get error():Boolean{
        return (((limbo) ? false : _error));
    }
    public function get factory():IFlexModuleFactory{
        return (((((!(limbo)) && (factoryInfo))) ? factoryInfo.factory : null));
    }
    public function completeHandler(_arg1:Event):void{
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = loader.contentLoaderInfo.bytesLoaded;
        _local2.bytesTotal = loader.contentLoaderInfo.bytesTotal;
        dispatchEvent(_local2);
    }
    public function publish(_arg1:IFlexModuleFactory):void{
        if (factoryInfo){
            return;
        };
        if (_url.indexOf("published://") != 0){
            return;
        };
        factoryInfo = new FactoryInfo();
        factoryInfo.factory = _arg1;
        _loaded = true;
        _setup = true;
        _ready = true;
        _error = false;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
        dispatchEvent(new ModuleEvent(ModuleEvent.PROGRESS));
        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
    }
    public function initHandler(_arg1:Event):void{
        var moduleEvent:* = null;
        var event:* = _arg1;
        factoryInfo = new FactoryInfo();
        try {
            factoryInfo.factory = (loader.content as IFlexModuleFactory);
        } catch(error:Error) {
        };
        if (!factoryInfo.factory){
            moduleEvent = new ModuleEvent(ModuleEvent.ERROR, event.bubbles, event.cancelable);
            moduleEvent.bytesLoaded = 0;
            moduleEvent.bytesTotal = 0;
            moduleEvent.errorText = "SWF is not a loadable module";
            dispatchEvent(moduleEvent);
            return;
        };
        loader.content.addEventListener("ready", readyHandler);
        loader.content.addEventListener("error", moduleErrorHandler);
        try {
            factoryInfo.applicationDomain = loader.contentLoaderInfo.applicationDomain;
        } catch(error:Error) {
        };
        _setup = true;
        dispatchEvent(new ModuleEvent(ModuleEvent.SETUP));
    }
    public function resurrect():void{
        var _local1:Object;
        if (((!(factoryInfo)) && (limbo))){
            for (_local1 in limbo) {
                factoryInfo = (_local1 as FactoryInfo);
                break;
            };
            limbo = null;
        };
        if (!factoryInfo){
            if (_loaded){
                dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
            };
            loader = null;
            _loaded = false;
            _setup = false;
            _ready = false;
            _error = false;
        };
    }
    public function errorHandler(_arg1:ErrorEvent):void{
        _error = true;
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = 0;
        _local2.bytesTotal = 0;
        _local2.errorText = _arg1.text;
        dispatchEvent(_local2);
    }
    public function get ready():Boolean{
        return (((limbo) ? false : _ready));
    }
    private function loadBytes(_arg1:ApplicationDomain, _arg2:ByteArray):void{
        var _local3:LoaderContext = new LoaderContext();
        _local3.applicationDomain = ((_arg1) ? _arg1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        if (("allowLoadBytesCodeExecution" in _local3)){
            _local3["allowLoadBytesCodeExecution"] = true;
        };
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
        loader.loadBytes(_arg2, _local3);
    }
    public function removeReference():void{
        numReferences--;
        if (numReferences == 0){
            release();
        };
    }
    public function addReference():void{
        numReferences++;
    }
    public function progressHandler(_arg1:ProgressEvent):void{
        var _local2:ModuleEvent = new ModuleEvent(ModuleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }
    public function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null):void{
        if (_loaded){
            return;
        };
        _loaded = true;
        limbo = null;
        if (_arg3){
            loadBytes(_arg1, _arg3);
            return;
        };
        if (_url.indexOf("published://") == 0){
            return;
        };
        var _local4:URLRequest = new URLRequest(_url);
        var _local5:LoaderContext = new LoaderContext();
        _local5.applicationDomain = ((_arg1) ? _arg1 : new ApplicationDomain(ApplicationDomain.currentDomain));
        _local5.securityDomain = _arg2;
        if ((((_arg2 == null)) && ((Security.sandboxType == Security.REMOTE)))){
            _local5.securityDomain = SecurityDomain.currentDomain;
        };
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
        loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
        loader.load(_local4, _local5);
    }
    public function get url():String{
        return (_url);
    }
    public function get applicationDomain():ApplicationDomain{
        return (((((!(limbo)) && (factoryInfo))) ? factoryInfo.applicationDomain : null));
    }
    public function moduleErrorHandler(_arg1:Event):void{
        var _local2:ModuleEvent;
        _ready = true;
        factoryInfo.bytesTotal = loader.contentLoaderInfo.bytesTotal;
        clearLoader();
        if ((_arg1 is ModuleEvent)){
            _local2 = ModuleEvent(_arg1);
        } else {
            _local2 = new ModuleEvent(ModuleEvent.ERROR);
        };
        dispatchEvent(_local2);
    }
    public function readyHandler(_arg1:Event):void{
        _ready = true;
        factoryInfo.bytesTotal = loader.contentLoaderInfo.bytesTotal;
        clearLoader();
        dispatchEvent(new ModuleEvent(ModuleEvent.READY));
    }
    public function get setup():Boolean{
        return (((limbo) ? false : _setup));
    }
    public function unload():void{
        clearLoader();
        if (_loaded){
            dispatchEvent(new ModuleEvent(ModuleEvent.UNLOAD));
        };
        limbo = null;
        factoryInfo = null;
        _loaded = false;
        _setup = false;
        _ready = false;
        _error = false;
    }

}
class FactoryInfo {

    public var bytesTotal:int = 0;
    public var factory:IFlexModuleFactory;
    public var applicationDomain:ApplicationDomain;

    public function FactoryInfo(){
    }
}
