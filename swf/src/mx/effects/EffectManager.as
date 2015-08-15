package mx.effects {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.utils.*;

    public class EffectManager extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var _resourceManager:IResourceManager;
        private static var effects:Dictionary = new Dictionary(true);
        mx_internal static var effectsPlaying:Array = [];
        private static var targetsInfo:Array = [];
        private static var effectTriggersForEvent:Object = {};
        mx_internal static var lastEffectCreated:Effect;
        private static var eventHandlingSuspendCount:Number = 0;
        private static var eventsForEffectTriggers:Object = {};

        public static function suspendEventHandling():void{
            eventHandlingSuspendCount++;
        }
        mx_internal static function registerEffectTrigger(_arg1:String, _arg2:String):void{
            var _local3:Number;
            if (_arg1 != ""){
                if (_arg2 == ""){
                    _local3 = _arg1.length;
                    if ((((_local3 > 6)) && ((_arg1.substring((_local3 - 6)) == "Effect")))){
                        _arg2 = _arg1.substring(0, (_local3 - 6));
                    };
                };
                if (_arg2 != ""){
                    effectTriggersForEvent[_arg2] = _arg1;
                    eventsForEffectTriggers[_arg1] = _arg2;
                };
            };
        }
        private static function removedEffectHandler(_arg1:DisplayObject, _arg2:DisplayObjectContainer, _arg3:int, _arg4:Event):void{
            suspendEventHandling();
            _arg2.addChildAt(_arg1, _arg3);
            resumeEventHandling();
            createAndPlayEffect(_arg4, _arg1);
        }
        private static function createAndPlayEffect(_arg1:Event, _arg2:Object):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local9:String;
            var _local10:String;
            var _local11:Array;
            var _local12:Array;
            var _local13:Array;
            var _local14:Array;
            var _local15:EffectInstance;
            var _local3:Effect = createEffectForType(_arg2, _arg1.type);
            if (!_local3){
                return;
            };
            if ((((_local3 is Zoom)) && ((_arg1.type == MoveEvent.MOVE)))){
                _local9 = resourceManager.getString("effects", "incorrectTrigger");
                throw (new Error(_local9));
            };
            if (_arg2.initialized == false){
                _local10 = _arg1.type;
                if ((((((((((_local10 == MoveEvent.MOVE)) || ((_local10 == ResizeEvent.RESIZE)))) || ((_local10 == FlexEvent.SHOW)))) || ((_local10 == FlexEvent.HIDE)))) || ((_local10 == Event.CHANGE)))){
                    _local3 = null;
                    return;
                };
            };
            if ((_local3.target is IUIComponent)){
                _local11 = IUIComponent(_local3.target).tweeningProperties;
                if (((_local11) && ((_local11.length > 0)))){
                    _local12 = _local3.getAffectedProperties();
                    _local4 = _local11.length;
                    _local6 = _local12.length;
                    _local5 = 0;
                    while (_local5 < _local4) {
                        _local7 = 0;
                        while (_local7 < _local6) {
                            if (_local11[_local5] == _local12[_local7]){
                                _local3 = null;
                                return;
                            };
                            _local7++;
                        };
                        _local5++;
                    };
                };
            };
            if ((((_local3.target is UIComponent)) && (UIComponent(_local3.target).isEffectStarted))){
                _local13 = _local3.getAffectedProperties();
                _local5 = 0;
                while (_local5 < _local13.length) {
                    _local14 = _local3.target.getEffectsForProperty(_local13[_local5]);
                    if (_local14.length > 0){
                        if (_arg1.type == ResizeEvent.RESIZE){
                            return;
                        };
                        _local7 = 0;
                        while (_local7 < _local14.length) {
                            _local15 = _local14[_local7];
                            if ((((_arg1.type == FlexEvent.SHOW)) && (_local15.hideOnEffectEnd))){
                                _local15.target.removeEventListener(FlexEvent.SHOW, _local15.eventHandler);
                                _local15.hideOnEffectEnd = false;
                            };
                            _local15.end();
                            _local7++;
                        };
                    };
                    _local5++;
                };
            };
            _local3.triggerEvent = _arg1;
            _local3.addEventListener(EffectEvent.EFFECT_END, EffectManager.effectEndHandler);
            lastEffectCreated = _local3;
            var _local8:Array = _local3.play();
            _local4 = _local8.length;
            _local5 = 0;
            while (_local5 < _local4) {
                effectsPlaying.push(new EffectNode(_local3, _local8[_local5]));
                _local5++;
            };
            if (_local3.suspendBackgroundProcessing){
                UIComponent.suspendBackgroundProcessing();
            };
        }
        public static function endEffectsForTarget(_arg1:IUIComponent):void{
            var _local4:EffectInstance;
            var _local2:int = effectsPlaying.length;
            var _local3:int = (_local2 - 1);
            while (_local3 >= 0) {
                _local4 = effectsPlaying[_local3].instance;
                if (_local4.target == _arg1){
                    _local4.end();
                };
                _local3--;
            };
        }
        private static function cacheOrUncacheTargetAsBitmap(_arg1:IUIComponent, _arg2:Boolean=true, _arg3:Boolean=true):void{
            var _local4:int;
            var _local5:int;
            var _local6:Object;
            _local4 = targetsInfo.length;
            _local5 = 0;
            while (_local5 < _local4) {
                if (targetsInfo[_local5].target == _arg1){
                    _local6 = targetsInfo[_local5];
                    break;
                };
                _local5++;
            };
            if (!_local6){
                _local6 = {
                    target:_arg1,
                    bitmapEffectsCount:0,
                    vectorEffectsCount:0
                };
                targetsInfo.push(_local6);
            };
            if (_arg2){
                if (_arg3){
                    _local6.bitmapEffectsCount++;
                    if ((((_local6.vectorEffectsCount == 0)) && ((_arg1 is IDeferredInstantiationUIComponent)))){
                        IDeferredInstantiationUIComponent(_arg1).cacheHeuristic = true;
                    };
                } else {
                    if ((((((_local6.vectorEffectsCount++ == 0)) && ((_arg1 is IDeferredInstantiationUIComponent)))) && ((IDeferredInstantiationUIComponent(_arg1).cachePolicy == UIComponentCachePolicy.AUTO)))){
                        _arg1.cacheAsBitmap = false;
                    };
                };
            } else {
                if (_arg3){
                    if (_local6.bitmapEffectsCount != 0){
                        _local6.bitmapEffectsCount--;
                    };
                    if ((_arg1 is IDeferredInstantiationUIComponent)){
                        IDeferredInstantiationUIComponent(_arg1).cacheHeuristic = false;
                    };
                } else {
                    if (_local6.vectorEffectsCount != 0){
                        if ((((--_local6.vectorEffectsCount == 0)) && (!((_local6.bitmapEffectsCount == 0))))){
                            _local4 = _local6.bitmapEffectsCount;
                            _local5 = 0;
                            while (_local5 < _local4) {
                                if ((_arg1 is IDeferredInstantiationUIComponent)){
                                    IDeferredInstantiationUIComponent(_arg1).cacheHeuristic = true;
                                };
                                _local5++;
                            };
                        };
                    };
                };
                if ((((_local6.bitmapEffectsCount == 0)) && ((_local6.vectorEffectsCount == 0)))){
                    _local4 = targetsInfo.length;
                    _local5 = 0;
                    while (_local5 < _local4) {
                        if (targetsInfo[_local5].target == _arg1){
                            targetsInfo.splice(_local5, 1);
                            break;
                        };
                        _local5++;
                    };
                };
            };
        }
        mx_internal static function eventHandler(_arg1:Event):void{
            var _local2:FocusEvent;
            var _local3:DisplayObject;
            var _local4:int;
            var _local5:DisplayObjectContainer;
            var _local6:int;
            if (!(_arg1.currentTarget is IFlexDisplayObject)){
                return;
            };
            if (eventHandlingSuspendCount > 0){
                return;
            };
            if ((((_arg1 is FocusEvent)) && ((((_arg1.type == FocusEvent.FOCUS_OUT)) || ((_arg1.type == FocusEvent.FOCUS_IN)))))){
                _local2 = FocusEvent(_arg1);
                if (((_local2.relatedObject) && (((_local2.currentTarget.contains(_local2.relatedObject)) || ((_local2.currentTarget == _local2.relatedObject)))))){
                    return;
                };
            };
            if ((((((_arg1.type == Event.ADDED)) || ((_arg1.type == Event.REMOVED)))) && (!((_arg1.target == _arg1.currentTarget))))){
                return;
            };
            if (_arg1.type == Event.REMOVED){
                if ((_arg1.target is UIComponent)){
                    if (UIComponent(_arg1.target).initialized == false){
                        return;
                    };
                    if (UIComponent(_arg1.target).isEffectStarted){
                        _local4 = 0;
                        while (_local4 < UIComponent(_arg1.target)._effectsStarted.length) {
                            if (UIComponent(_arg1.target)._effectsStarted[_local4].triggerEvent.type == Event.REMOVED){
                                return;
                            };
                            _local4++;
                        };
                    };
                };
                _local3 = (_arg1.target as DisplayObject);
                if (_local3 != null){
                    _local5 = (_local3.parent as DisplayObjectContainer);
                    if (_local5 != null){
                        _local6 = _local5.getChildIndex(_local3);
                        if (_local6 >= 0){
                            if ((_local3 is UIComponent)){
                                UIComponent(_local3).callLater(removedEffectHandler, [_local3, _local5, _local6, _arg1]);
                            };
                        };
                    };
                };
            } else {
                createAndPlayEffect(_arg1, _arg1.currentTarget);
            };
        }
        mx_internal static function endBitmapEffect(_arg1:IUIComponent):void{
            cacheOrUncacheTargetAsBitmap(_arg1, false, true);
        }
        private static function animateSameProperty(_arg1:Effect, _arg2:Effect, _arg3:EffectInstance):Boolean{
            var _local4:Array;
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            if (_arg1.target == _arg3.target){
                _local4 = _arg1.getAffectedProperties();
                _local5 = _arg2.getAffectedProperties();
                _local6 = _local4.length;
                _local7 = _local5.length;
                _local8 = 0;
                while (_local8 < _local6) {
                    _local9 = 0;
                    while (_local9 < _local7) {
                        if (_local4[_local8] == _local5[_local9]){
                            return (true);
                        };
                        _local9++;
                    };
                    _local8++;
                };
            };
            return (false);
        }
        mx_internal static function effectFinished(_arg1:EffectInstance):void{
            delete effects[_arg1];
        }
        mx_internal static function effectsInEffect():Boolean{
            var _local1:*;
            for (_local1 in effects) {
                return (true);
            };
            return (false);
        }
        mx_internal static function effectEndHandler(_arg1:EffectEvent):void{
            var _local5:DisplayObject;
            var _local6:DisplayObjectContainer;
            var _local2:IEffectInstance = _arg1.effectInstance;
            var _local3:int = effectsPlaying.length;
            var _local4:int = (_local3 - 1);
            while (_local4 >= 0) {
                if (effectsPlaying[_local4].instance == _local2){
                    effectsPlaying.splice(_local4, 1);
                    break;
                };
                _local4--;
            };
            if (Object(_local2).hideOnEffectEnd == true){
                _local2.target.removeEventListener(FlexEvent.SHOW, Object(_local2).eventHandler);
                _local2.target.setVisible(false, true);
            };
            if (((_local2.triggerEvent) && ((_local2.triggerEvent.type == Event.REMOVED)))){
                _local5 = (_local2.target as DisplayObject);
                if (_local5 != null){
                    _local6 = (_local5.parent as DisplayObjectContainer);
                    if (_local6 != null){
                        suspendEventHandling();
                        _local6.removeChild(_local5);
                        resumeEventHandling();
                    };
                };
            };
            if (_local2.suspendBackgroundProcessing){
                UIComponent.resumeBackgroundProcessing();
            };
        }
        mx_internal static function startBitmapEffect(_arg1:IUIComponent):void{
            cacheOrUncacheTargetAsBitmap(_arg1, true, true);
        }
        mx_internal static function setStyle(_arg1:String, _arg2):void{
            var _local3:String = eventsForEffectTriggers[_arg1];
            if (((!((_local3 == null))) && (!((_local3 == ""))))){
                _arg2.addEventListener(_local3, EffectManager.eventHandler, false, EventPriority.EFFECT);
            };
        }
        mx_internal static function getEventForEffectTrigger(_arg1:String):String{
            var effectTrigger:* = _arg1;
            if (eventsForEffectTriggers){
                try {
                    return (eventsForEffectTriggers[effectTrigger]);
                } catch(e:Error) {
                    return ("");
                };
            };
            return ("");
        }
        mx_internal static function createEffectForType(_arg1:Object, _arg2:String):Effect{
            var cls:* = null;
            var effectObj:* = null;
            var doc:* = null;
            var target:* = _arg1;
            var type:* = _arg2;
            var trigger:* = effectTriggersForEvent[type];
            if (trigger == ""){
                trigger = (type + "Effect");
            };
            var value:* = target.getStyle(trigger);
            if (!value){
                return (null);
            };
            if ((value is Class)){
                cls = Class(value);
                return (new cls(target));
            };
            try {
                if ((value is String)){
                    doc = target.parentDocument;
                    if (!doc){
                        doc = ApplicationGlobals.application;
                    };
                    effectObj = doc[value];
                } else {
                    if ((value is Effect)){
                        effectObj = Effect(value);
                    };
                };
                if (effectObj){
                    effectObj.target = target;
                    return (effectObj);
                };
            } catch(e:Error) {
            };
            var effectClass:* = Class(target.systemManager.getDefinitionByName(("mx.effects." + value)));
            if (effectClass){
                return (new effectClass(target));
            };
            return (null);
        }
        mx_internal static function effectStarted(_arg1:EffectInstance):void{
            effects[_arg1] = 1;
        }
        public static function resumeEventHandling():void{
            eventHandlingSuspendCount--;
        }
        mx_internal static function startVectorEffect(_arg1:IUIComponent):void{
            cacheOrUncacheTargetAsBitmap(_arg1, true, false);
        }
        mx_internal static function endVectorEffect(_arg1:IUIComponent):void{
            cacheOrUncacheTargetAsBitmap(_arg1, false, false);
        }
        private static function get resourceManager():IResourceManager{
            if (!_resourceManager){
                _resourceManager = ResourceManager.getInstance();
            };
            return (_resourceManager);
        }

    }
}//package mx.effects 

class EffectNode {

    public var factory:Effect;
    public var instance:EffectInstance;

    public function EffectNode(_arg1:Effect, _arg2:EffectInstance){
        this.factory = _arg1;
        this.instance = _arg2;
    }
}
