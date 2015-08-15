package mx.styles {
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.system.*;
    import mx.modules.*;
    import flash.utils.*;

    public class StyleManagerImpl implements IStyleManager2 {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var parentSizeInvalidatingStyles:Object = {
            bottom:true,
            horizontalCenter:true,
            left:true,
            right:true,
            top:true,
            verticalCenter:true,
            baseline:true
        };
        private static var colorNames:Object = {
            transparent:"transparent",
            black:0,
            blue:0xFF,
            green:0x8000,
            gray:0x808080,
            silver:0xC0C0C0,
            lime:0xFF00,
            olive:0x808000,
            white:0xFFFFFF,
            yellow:0xFFFF00,
            maroon:0x800000,
            navy:128,
            red:0xFF0000,
            purple:0x800080,
            teal:0x8080,
            fuchsia:0xFF00FF,
            aqua:0xFFFF,
            magenta:0xFF00FF,
            cyan:0xFFFF,
            halogreen:8453965,
            haloblue:40447,
            haloorange:0xFFB600,
            halosilver:11455193
        };
        private static var inheritingTextFormatStyles:Object = {
            align:true,
            bold:true,
            color:true,
            font:true,
            indent:true,
            italic:true,
            size:true
        };
        private static var instance:IStyleManager2;
        private static var parentDisplayListInvalidatingStyles:Object = {
            bottom:true,
            horizontalCenter:true,
            left:true,
            right:true,
            top:true,
            verticalCenter:true,
            baseline:true
        };
        private static var sizeInvalidatingStyles:Object = {
            borderStyle:true,
            borderThickness:true,
            fontAntiAliasType:true,
            fontFamily:true,
            fontGridFitType:true,
            fontSharpness:true,
            fontSize:true,
            fontStyle:true,
            fontThickness:true,
            fontWeight:true,
            headerHeight:true,
            horizontalAlign:true,
            horizontalGap:true,
            kerning:true,
            leading:true,
            letterSpacing:true,
            paddingBottom:true,
            paddingLeft:true,
            paddingRight:true,
            paddingTop:true,
            strokeWidth:true,
            tabHeight:true,
            tabWidth:true,
            verticalAlign:true,
            verticalGap:true
        };

        private var _stylesRoot:Object;
        private var _selectors:Object;
        private var styleModules:Object;
        private var _inheritingStyles:Object;
        private var resourceManager:IResourceManager;
        private var _typeSelectorCache:Object;

        public function StyleManagerImpl(){
            _selectors = {};
            styleModules = {};
            resourceManager = ResourceManager.getInstance();
            _inheritingStyles = {};
            _typeSelectorCache = {};
            super();
        }
        public static function getInstance():IStyleManager2{
            if (!instance){
                instance = new (StyleManagerImpl)();
            };
            return (instance);
        }

        public function setStyleDeclaration(_arg1:String, _arg2:CSSStyleDeclaration, _arg3:Boolean):void{
            _arg2.selectorRefCount++;
            _selectors[_arg1] = _arg2;
            typeSelectorCache = {};
            if (_arg3){
                styleDeclarationsChanged();
            };
        }
        public function registerParentDisplayListInvalidatingStyle(_arg1:String):void{
            parentDisplayListInvalidatingStyles[_arg1] = true;
        }
        public function getStyleDeclaration(_arg1:String):CSSStyleDeclaration{
            var _local2:int;
            if (_arg1.charAt(0) != "."){
                _local2 = _arg1.lastIndexOf(".");
                if (_local2 != -1){
                    _arg1 = _arg1.substr((_local2 + 1));
                };
            };
            return (_selectors[_arg1]);
        }
        public function set typeSelectorCache(_arg1:Object):void{
            _typeSelectorCache = _arg1;
        }
        public function isColorName(_arg1:String):Boolean{
            return (!((colorNames[_arg1.toLowerCase()] === undefined)));
        }
        public function set inheritingStyles(_arg1:Object):void{
            _inheritingStyles = _arg1;
        }
        public function getColorNames(_arg1:Array):void{
            var _local4:uint;
            if (!_arg1){
                return;
            };
            var _local2:int = _arg1.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (((!((_arg1[_local3] == null))) && (isNaN(_arg1[_local3])))){
                    _local4 = getColorName(_arg1[_local3]);
                    if (_local4 != StyleManager.NOT_A_COLOR){
                        _arg1[_local3] = _local4;
                    };
                };
                _local3++;
            };
        }
        public function isInheritingTextFormatStyle(_arg1:String):Boolean{
            return ((inheritingTextFormatStyles[_arg1] == true));
        }
        public function registerParentSizeInvalidatingStyle(_arg1:String):void{
            parentSizeInvalidatingStyles[_arg1] = true;
        }
        public function registerColorName(_arg1:String, _arg2:uint):void{
            colorNames[_arg1.toLowerCase()] = _arg2;
        }
        public function isParentSizeInvalidatingStyle(_arg1:String):Boolean{
            return ((parentSizeInvalidatingStyles[_arg1] == true));
        }
        public function registerInheritingStyle(_arg1:String):void{
            inheritingStyles[_arg1] = true;
        }
        public function set stylesRoot(_arg1:Object):void{
            _stylesRoot = _arg1;
        }
        public function get typeSelectorCache():Object{
            return (_typeSelectorCache);
        }
        public function isParentDisplayListInvalidatingStyle(_arg1:String):Boolean{
            return ((parentDisplayListInvalidatingStyles[_arg1] == true));
        }
        public function isSizeInvalidatingStyle(_arg1:String):Boolean{
            return ((sizeInvalidatingStyles[_arg1] == true));
        }
        public function styleDeclarationsChanged():void{
            var _local4:Object;
            var _local1:Array = SystemManagerGlobals.topLevelSystemManagers;
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = _local1[_local3];
                _local4.regenerateStyleCache(true);
                _local4.notifyStyleChangeInChildren(null, true);
                _local3++;
            };
        }
        public function isValidStyleValue(_arg1):Boolean{
            return (!((_arg1 === undefined)));
        }
        public function loadStyleDeclarations(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false):IEventDispatcher{
            return (loadStyleDeclarations2(_arg1, _arg2));
        }
        public function get inheritingStyles():Object{
            return (_inheritingStyles);
        }
        public function unloadStyleDeclarations(_arg1:String, _arg2:Boolean=true):void{
            var _local4:IModuleInfo;
            var _local3:StyleModuleInfo = styleModules[_arg1];
            if (_local3){
                _local3.styleModule.unload();
                _local4 = _local3.module;
                _local4.unload();
                _local4.removeEventListener(ModuleEvent.READY, _local3.readyHandler);
                _local4.removeEventListener(ModuleEvent.ERROR, _local3.errorHandler);
                styleModules[_arg1] = null;
            };
            if (_arg2){
                styleDeclarationsChanged();
            };
        }
        public function getColorName(_arg1:Object):uint{
            var _local2:Number;
            var _local3:*;
            if ((_arg1 is String)){
                if (_arg1.charAt(0) == "#"){
                    _local2 = Number(("0x" + _arg1.slice(1)));
                    return (((isNaN(_local2)) ? StyleManager.NOT_A_COLOR : uint(_local2)));
                };
                if ((((_arg1.charAt(1) == "x")) && ((_arg1.charAt(0) == "0")))){
                    _local2 = Number(_arg1);
                    return (((isNaN(_local2)) ? StyleManager.NOT_A_COLOR : uint(_local2)));
                };
                _local3 = colorNames[_arg1.toLowerCase()];
                if (_local3 === undefined){
                    return (StyleManager.NOT_A_COLOR);
                };
                return (uint(_local3));
            };
            return (uint(_arg1));
        }
        public function isInheritingStyle(_arg1:String):Boolean{
            return ((inheritingStyles[_arg1] == true));
        }
        public function get stylesRoot():Object{
            return (_stylesRoot);
        }
        public function initProtoChainRoots():void{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                delete _inheritingStyles["textDecoration"];
                delete _inheritingStyles["leading"];
            };
            if (!stylesRoot){
                stylesRoot = _selectors["global"].addStyleToProtoChain({}, null);
            };
        }
        public function loadStyleDeclarations2(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher{
            var module:* = null;
            var styleEventDispatcher:* = null;
            var timer:* = null;
            var timerHandler:* = null;
            var url:* = _arg1;
            var update:Boolean = _arg2;
            var applicationDomain = _arg3;
            var securityDomain = _arg4;
            module = ModuleManager.getModule(url);
            var readyHandler:* = function (_arg1:ModuleEvent):void{
                var _local2:IStyleModule = IStyleModule(_arg1.module.factory.create());
                styleModules[_arg1.module.url].styleModule = _local2;
                if (update){
                    styleDeclarationsChanged();
                };
            };
            module.addEventListener(ModuleEvent.READY, readyHandler, false, 0, true);
            styleEventDispatcher = new StyleEventDispatcher(module);
            var errorHandler:* = function (_arg1:ModuleEvent):void{
                var _local3:StyleEvent;
                var _local2:String = resourceManager.getString("styles", "unableToLoad", [_arg1.errorText, url]);
                if (styleEventDispatcher.willTrigger(StyleEvent.ERROR)){
                    _local3 = new StyleEvent(StyleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
                    _local3.bytesLoaded = 0;
                    _local3.bytesTotal = 0;
                    _local3.errorText = _local2;
                    styleEventDispatcher.dispatchEvent(_local3);
                } else {
                    throw (new Error(_local2));
                };
            };
            module.addEventListener(ModuleEvent.ERROR, errorHandler, false, 0, true);
            styleModules[url] = new StyleModuleInfo(module, readyHandler, errorHandler);
            timer = new Timer(0);
            timerHandler = function (_arg1:TimerEvent):void{
                timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                timer.stop();
                module.load(applicationDomain, securityDomain);
            };
            timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
            timer.start();
            return (styleEventDispatcher);
        }
        public function registerSizeInvalidatingStyle(_arg1:String):void{
            sizeInvalidatingStyles[_arg1] = true;
        }
        public function clearStyleDeclaration(_arg1:String, _arg2:Boolean):void{
            var _local3:CSSStyleDeclaration = getStyleDeclaration(_arg1);
            if (((_local3) && ((_local3.selectorRefCount > 0)))){
                _local3.selectorRefCount--;
            };
            delete _selectors[_arg1];
            if (_arg2){
                styleDeclarationsChanged();
            };
        }
        public function get selectors():Array{
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in _selectors) {
                _local1.push(_local2);
            };
            return (_local1);
        }

    }
}//package mx.styles 

import flash.events.*;
import mx.events.*;
import mx.modules.*;

class StyleEventDispatcher extends EventDispatcher {

    public function StyleEventDispatcher(_arg1:IModuleInfo){
        _arg1.addEventListener(ModuleEvent.ERROR, moduleInfo_errorHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.PROGRESS, moduleInfo_progressHandler, false, 0, true);
        _arg1.addEventListener(ModuleEvent.READY, moduleInfo_readyHandler, false, 0, true);
    }
    private function moduleInfo_progressHandler(_arg1:ModuleEvent):void{
        var _local2:StyleEvent = new StyleEvent(StyleEvent.PROGRESS, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        dispatchEvent(_local2);
    }
    private function moduleInfo_readyHandler(_arg1:ModuleEvent):void{
        var _local2:StyleEvent = new StyleEvent(StyleEvent.COMPLETE);
        dispatchEvent(_local2);
    }
    private function moduleInfo_errorHandler(_arg1:ModuleEvent):void{
        var _local2:StyleEvent = new StyleEvent(StyleEvent.ERROR, _arg1.bubbles, _arg1.cancelable);
        _local2.bytesLoaded = _arg1.bytesLoaded;
        _local2.bytesTotal = _arg1.bytesTotal;
        _local2.errorText = _arg1.errorText;
        dispatchEvent(_local2);
    }

}
class StyleModuleInfo {

    public var errorHandler:Function;
    public var readyHandler:Function;
    public var module:IModuleInfo;
    public var styleModule:IStyleModule;

    public function StyleModuleInfo(_arg1:IModuleInfo, _arg2:Function, _arg3:Function){
        this.module = _arg1;
        this.readyHandler = _arg2;
        this.errorHandler = _arg3;
    }
}
