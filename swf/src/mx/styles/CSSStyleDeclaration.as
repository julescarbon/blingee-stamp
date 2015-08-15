package mx.styles {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import flash.utils.*;

    public class CSSStyleDeclaration extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";
        private static const NOT_A_COLOR:uint = 0xFFFFFFFF;
        private static const FILTERMAP_PROP:String = "__reserved__filterMap";

        mx_internal var effects:Array;
        protected var overrides:Object;
        public var defaultFactory:Function;
        public var factory:Function;
        mx_internal var selectorRefCount:int = 0;
        private var styleManager:IStyleManager2;
        private var clones:Dictionary;

        public function CSSStyleDeclaration(_arg1:String=null){
            clones = new Dictionary(true);
            super();
            if (_arg1){
                styleManager = (Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2);
                styleManager.setStyleDeclaration(_arg1, this, false);
            };
        }
        mx_internal function addStyleToProtoChain(_arg1:Object, _arg2:DisplayObject, _arg3:Object=null):Object{
            var p:* = null;
            var emptyObjectFactory:* = null;
            var filteredChain:* = null;
            var filterObjectFactory:* = null;
            var i:* = null;
            var chain:* = _arg1;
            var target:* = _arg2;
            var filterMap = _arg3;
            var nodeAddedToChain:* = false;
            var originalChain:* = chain;
            if (filterMap){
                chain = {};
            };
            if (defaultFactory != null){
                defaultFactory.prototype = chain;
                chain = new defaultFactory();
                nodeAddedToChain = true;
            };
            if (factory != null){
                factory.prototype = chain;
                chain = new factory();
                nodeAddedToChain = true;
            };
            if (overrides){
                if ((((defaultFactory == null)) && ((factory == null)))){
                    emptyObjectFactory = function ():void{
                    };
                    emptyObjectFactory.prototype = chain;
                    chain = new (emptyObjectFactory)();
                    nodeAddedToChain = true;
                };
                for (p in overrides) {
                    if (overrides[p] === undefined){
                        delete chain[p];
                    } else {
                        chain[p] = overrides[p];
                    };
                };
            };
            if (filterMap){
                if (nodeAddedToChain){
                    filteredChain = {};
                    filterObjectFactory = function ():void{
                    };
                    filterObjectFactory.prototype = originalChain;
                    filteredChain = new (filterObjectFactory)();
                    for (i in chain) {
                        if (filterMap[i] != null){
                            filteredChain[filterMap[i]] = chain[i];
                        };
                    };
                    chain = filteredChain;
                    chain[FILTERMAP_PROP] = filterMap;
                } else {
                    chain = originalChain;
                };
            };
            if (nodeAddedToChain){
                clones[chain] = 1;
            };
            return (chain);
        }
        public function getStyle(_arg1:String){
            var _local2:*;
            var _local3:*;
            if (overrides){
                if ((((_arg1 in overrides)) && ((overrides[_arg1] === undefined)))){
                    return (undefined);
                };
                _local3 = overrides[_arg1];
                if (_local3 !== undefined){
                    return (_local3);
                };
            };
            if (factory != null){
                factory.prototype = {};
                _local2 = new factory();
                _local3 = _local2[_arg1];
                if (_local3 !== undefined){
                    return (_local3);
                };
            };
            if (defaultFactory != null){
                defaultFactory.prototype = {};
                _local2 = new defaultFactory();
                _local3 = _local2[_arg1];
                if (_local3 !== undefined){
                    return (_local3);
                };
            };
            return (undefined);
        }
        public function clearStyle(_arg1:String):void{
            setStyle(_arg1, undefined);
        }
        public function setStyle(_arg1:String, _arg2):void{
            var _local7:int;
            var _local8:Object;
            var _local3:Object = getStyle(_arg1);
            var _local4:Boolean;
            if ((((((((((selectorRefCount > 0)) && ((factory == null)))) && ((defaultFactory == null)))) && (!(overrides)))) && (!((_local3 === _arg2))))){
                _local4 = true;
            };
            if (_arg2 !== undefined){
                setStyle(_arg1, _arg2);
            } else {
                if (_arg2 == _local3){
                    return;
                };
                setStyle(_arg1, _arg2);
            };
            var _local5:Array = SystemManagerGlobals.topLevelSystemManagers;
            var _local6:int = _local5.length;
            if (_local4){
                _local7 = 0;
                while (_local7 < _local6) {
                    _local8 = _local5[_local7];
                    _local8.regenerateStyleCache(true);
                    _local7++;
                };
            };
            _local7 = 0;
            while (_local7 < _local6) {
                _local8 = _local5[_local7];
                _local8.notifyStyleChangeInChildren(_arg1, true);
                _local7++;
            };
        }
        private function clearStyleAttr(_arg1:String):void{
            var _local2:*;
            if (!overrides){
                overrides = {};
            };
            overrides[_arg1] = undefined;
            for (_local2 in clones) {
                delete _local2[_arg1];
            };
        }
        mx_internal function createProtoChainRoot():Object{
            var _local1:Object = {};
            if (defaultFactory != null){
                defaultFactory.prototype = _local1;
                _local1 = new defaultFactory();
            };
            if (factory != null){
                factory.prototype = _local1;
                _local1 = new factory();
            };
            clones[_local1] = 1;
            return (_local1);
        }
        mx_internal function clearOverride(_arg1:String):void{
            if (((overrides) && (overrides[_arg1]))){
                delete overrides[_arg1];
            };
        }
        mx_internal function setStyle(_arg1:String, _arg2):void{
            var _local3:Object;
            var _local4:*;
            var _local5:Number;
            var _local6:Object;
            if (_arg2 === undefined){
                clearStyleAttr(_arg1);
                return;
            };
            if ((_arg2 is String)){
                if (!styleManager){
                    styleManager = (Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2);
                };
                _local5 = styleManager.getColorName(_arg2);
                if (_local5 != NOT_A_COLOR){
                    _arg2 = _local5;
                };
            };
            if (defaultFactory != null){
                _local3 = new defaultFactory();
                if (_local3[_arg1] !== _arg2){
                    if (!overrides){
                        overrides = {};
                    };
                    overrides[_arg1] = _arg2;
                } else {
                    if (overrides){
                        delete overrides[_arg1];
                    };
                };
            };
            if (factory != null){
                _local3 = new factory();
                if (_local3[_arg1] !== _arg2){
                    if (!overrides){
                        overrides = {};
                    };
                    overrides[_arg1] = _arg2;
                } else {
                    if (overrides){
                        delete overrides[_arg1];
                    };
                };
            };
            if ((((defaultFactory == null)) && ((factory == null)))){
                if (!overrides){
                    overrides = {};
                };
                overrides[_arg1] = _arg2;
            };
            for (_local4 in clones) {
                _local6 = _local4[FILTERMAP_PROP];
                if (_local6){
                    if (_local6[_arg1] != null){
                        _local4[_local6[_arg1]] = _arg2;
                    };
                } else {
                    _local4[_arg1] = _arg2;
                };
            };
        }

    }
}//package mx.styles 
