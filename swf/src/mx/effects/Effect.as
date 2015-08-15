package mx.effects {
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.effects.effectClasses.*;
    import flash.utils.*;

    public class Effect extends EventDispatcher implements IEffect {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _perElementOffset:Number = 0;
        private var _hideFocusRing:Boolean = false;
        private var _customFilter:EffectTargetFilter;
        public var repeatCount:int = 1;
        public var suspendBackgroundProcessing:Boolean = false;
        public var startDelay:int = 0;
        private var _relevantProperties:Array;
        private var _callValidateNow:Boolean = false;
        mx_internal var applyActualDimensions:Boolean = true;
        private var _filter:String;
        private var _triggerEvent:Event;
        private var _effectTargetHost:IEffectTargetHost;
        mx_internal var durationExplicitlySet:Boolean = false;
        public var repeatDelay:int = 0;
        private var _targets:Array;
        mx_internal var propertyChangesArray:Array;
        mx_internal var filterObject:EffectTargetFilter;
        protected var endValuesCaptured:Boolean = false;
        public var instanceClass:Class;
        private var _duration:Number = 500;
        private var isPaused:Boolean = false;
        private var _relevantStyles:Array;
        private var _instances:Array;

        public function Effect(_arg1:Object=null){
            _instances = [];
            instanceClass = IEffectInstance;
            _relevantStyles = [];
            _targets = [];
            super();
            this.target = _arg1;
        }
        private static function mergeArrays(_arg1:Array, _arg2:Array):Array{
            var _local3:int;
            var _local4:Boolean;
            var _local5:int;
            if (_arg2){
                _local3 = 0;
                while (_local3 < _arg2.length) {
                    _local4 = true;
                    _local5 = 0;
                    while (_local5 < _arg1.length) {
                        if (_arg1[_local5] == _arg2[_local3]){
                            _local4 = false;
                            break;
                        };
                        _local5++;
                    };
                    if (_local4){
                        _arg1.push(_arg2[_local3]);
                    };
                    _local3++;
                };
            };
            return (_arg1);
        }
        private static function stripUnchangedValues(_arg1:Array):Array{
            var _local3:Object;
            var _local2:int;
            while (_local2 < _arg1.length) {
                for (_local3 in _arg1[_local2].start) {
                    if ((((_arg1[_local2].start[_local3] == _arg1[_local2].end[_local3])) || ((((((((typeof(_arg1[_local2].start[_local3]) == "number")) && ((typeof(_arg1[_local2].end[_local3]) == "number")))) && (isNaN(_arg1[_local2].start[_local3])))) && (isNaN(_arg1[_local2].end[_local3])))))){
                        delete _arg1[_local2].start[_local3];
                        delete _arg1[_local2].end[_local3];
                    };
                };
                _local2++;
            };
            return (_arg1);
        }

        public function get targets():Array{
            return (_targets);
        }
        public function set targets(_arg1:Array):void{
            var _local2:int = _arg1.length;
            var _local3:int = (_local2 - 1);
            while (_local3 > 0) {
                if (_arg1[_local3] == null){
                    _arg1.splice(_local3, 1);
                };
                _local3--;
            };
            _targets = _arg1;
        }
        public function set hideFocusRing(_arg1:Boolean):void{
            _hideFocusRing = _arg1;
        }
        public function get hideFocusRing():Boolean{
            return (_hideFocusRing);
        }
        public function stop():void{
            var _local3:IEffectInstance;
            var _local1:int = _instances.length;
            var _local2:int = _local1;
            while (_local2 >= 0) {
                _local3 = IEffectInstance(_instances[_local2]);
                if (_local3){
                    _local3.stop();
                };
                _local2--;
            };
        }
        public function captureStartValues():void{
            var _local1:int;
            var _local2:int;
            if (targets.length > 0){
                propertyChangesArray = [];
                _callValidateNow = true;
                _local1 = targets.length;
                _local2 = 0;
                while (_local2 < _local1) {
                    propertyChangesArray.push(new PropertyChanges(targets[_local2]));
                    _local2++;
                };
                propertyChangesArray = captureValues(propertyChangesArray, true);
            };
            endValuesCaptured = false;
        }
        mx_internal function captureValues(_arg1:Array, _arg2:Boolean):Array{
            var _local4:Object;
            var _local5:Object;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local3:Array = ((filterObject) ? mergeArrays(relevantProperties, filterObject.filterProperties) : relevantProperties);
            if (((_local3) && ((_local3.length > 0)))){
                _local6 = _arg1.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local5 = _arg1[_local7].target;
                    _local4 = ((_arg2) ? _arg1[_local7].start : _arg1[_local7].end);
                    _local8 = _local3.length;
                    _local9 = 0;
                    while (_local9 < _local8) {
                        _local4[_local3[_local9]] = getValueFromTarget(_local5, _local3[_local9]);
                        _local9++;
                    };
                    _local7++;
                };
            };
            var _local10:Array = ((filterObject) ? mergeArrays(relevantStyles, filterObject.filterStyles) : relevantStyles);
            if (((_local10) && ((_local10.length > 0)))){
                _local6 = _arg1.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    _local5 = _arg1[_local7].target;
                    _local4 = ((_arg2) ? _arg1[_local7].start : _arg1[_local7].end);
                    _local8 = _local10.length;
                    _local9 = 0;
                    while (_local9 < _local8) {
                        _local4[_local10[_local9]] = _local5.getStyle(_local10[_local9]);
                        _local9++;
                    };
                    _local7++;
                };
            };
            return (_arg1);
        }
        protected function getValueFromTarget(_arg1:Object, _arg2:String){
            if ((_arg2 in _arg1)){
                return (_arg1[_arg2]);
            };
            return (undefined);
        }
        public function set target(_arg1:Object):void{
            _targets.splice(0);
            if (_arg1){
                _targets[0] = _arg1;
            };
        }
        public function get className():String{
            var _local1:String = getQualifiedClassName(this);
            var _local2:int = _local1.indexOf("::");
            if (_local2 != -1){
                _local1 = _local1.substr((_local2 + 2));
            };
            return (_local1);
        }
        public function set perElementOffset(_arg1:Number):void{
            _perElementOffset = _arg1;
        }
        public function resume():void{
            var _local1:int;
            var _local2:int;
            if (((isPlaying) && (isPaused))){
                isPaused = false;
                _local1 = _instances.length;
                _local2 = 0;
                while (_local2 < _local1) {
                    IEffectInstance(_instances[_local2]).resume();
                    _local2++;
                };
            };
        }
        public function set duration(_arg1:Number):void{
            durationExplicitlySet = true;
            _duration = _arg1;
        }
        public function play(_arg1:Array=null, _arg2:Boolean=false):Array{
            var _local6:IEffectInstance;
            if ((((_arg1 == null)) && (!((propertyChangesArray == null))))){
                if (_callValidateNow){
                    LayoutManager.getInstance().validateNow();
                };
                if (!endValuesCaptured){
                    propertyChangesArray = captureValues(propertyChangesArray, false);
                };
                propertyChangesArray = stripUnchangedValues(propertyChangesArray);
                applyStartValues(propertyChangesArray, this.targets);
            };
            var _local3:Array = createInstances(_arg1);
            var _local4:int = _local3.length;
            var _local5:int;
            while (_local5 < _local4) {
                _local6 = IEffectInstance(_local3[_local5]);
                Object(_local6).playReversed = _arg2;
                _local6.startEffect();
                _local5++;
            };
            return (_local3);
        }
        public function captureEndValues():void{
            propertyChangesArray = captureValues(propertyChangesArray, false);
            endValuesCaptured = true;
        }
        protected function filterInstance(_arg1:Array, _arg2:Object):Boolean{
            if (filterObject){
                return (filterObject.filterInstance(_arg1, effectTargetHost, _arg2));
            };
            return (true);
        }
        public function get customFilter():EffectTargetFilter{
            return (_customFilter);
        }
        public function get effectTargetHost():IEffectTargetHost{
            return (_effectTargetHost);
        }
        public function set relevantProperties(_arg1:Array):void{
            _relevantProperties = _arg1;
        }
        public function captureMoreStartValues(_arg1:Array):void{
            var _local2:Array;
            var _local3:int;
            if (_arg1.length > 0){
                _local2 = [];
                _local3 = 0;
                while (_local3 < _arg1.length) {
                    _local2.push(new PropertyChanges(_arg1[_local3]));
                    _local3++;
                };
                _local2 = captureValues(_local2, true);
                propertyChangesArray = propertyChangesArray.concat(_local2);
            };
        }
        public function deleteInstance(_arg1:IEffectInstance):void{
            EventDispatcher(_arg1).removeEventListener(EffectEvent.EFFECT_START, effectStartHandler);
            EventDispatcher(_arg1).removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            var _local2:int = _instances.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (_instances[_local3] === _arg1){
                    _instances.splice(_local3, 1);
                };
                _local3++;
            };
        }
        public function get filter():String{
            return (_filter);
        }
        public function set triggerEvent(_arg1:Event):void{
            _triggerEvent = _arg1;
        }
        public function get target():Object{
            if (_targets.length > 0){
                return (_targets[0]);
            };
            return (null);
        }
        public function get duration():Number{
            return (_duration);
        }
        public function set customFilter(_arg1:EffectTargetFilter):void{
            _customFilter = _arg1;
            filterObject = _arg1;
        }
        public function get perElementOffset():Number{
            return (_perElementOffset);
        }
        public function set effectTargetHost(_arg1:IEffectTargetHost):void{
            _effectTargetHost = _arg1;
        }
        public function get isPlaying():Boolean{
            return (((_instances) && ((_instances.length > 0))));
        }
        protected function effectEndHandler(_arg1:EffectEvent):void{
            var _local2:IEffectInstance = IEffectInstance(_arg1.effectInstance);
            deleteInstance(_local2);
            dispatchEvent(_arg1);
        }
        public function get relevantProperties():Array{
            if (_relevantProperties){
                return (_relevantProperties);
            };
            return (getAffectedProperties());
        }
        public function createInstance(_arg1:Object=null):IEffectInstance{
            var _local6:int;
            var _local7:int;
            if (!_arg1){
                _arg1 = this.target;
            };
            var _local2:IEffectInstance;
            var _local3:PropertyChanges;
            var _local4:Boolean;
            var _local5:Boolean;
            if (propertyChangesArray){
                _local5 = true;
                _local4 = filterInstance(propertyChangesArray, _arg1);
            };
            if (_local4){
                _local2 = IEffectInstance(new instanceClass(_arg1));
                initInstance(_local2);
                if (_local5){
                    _local6 = propertyChangesArray.length;
                    _local7 = 0;
                    while (_local7 < _local6) {
                        if (propertyChangesArray[_local7].target == _arg1){
                            _local2.propertyChanges = propertyChangesArray[_local7];
                        };
                        _local7++;
                    };
                };
                EventDispatcher(_local2).addEventListener(EffectEvent.EFFECT_START, effectStartHandler);
                EventDispatcher(_local2).addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                _instances.push(_local2);
                if (triggerEvent){
                    _local2.initEffect(triggerEvent);
                };
            };
            return (_local2);
        }
        protected function effectStartHandler(_arg1:EffectEvent):void{
            dispatchEvent(_arg1);
        }
        public function getAffectedProperties():Array{
            return ([]);
        }
        public function set relevantStyles(_arg1:Array):void{
            _relevantStyles = _arg1;
        }
        public function get triggerEvent():Event{
            return (_triggerEvent);
        }
        protected function applyValueToTarget(_arg1:Object, _arg2:String, _arg3, _arg4:Object):void{
            var target:* = _arg1;
            var property:* = _arg2;
            var value:* = _arg3;
            var props:* = _arg4;
            if ((property in target)){
                try {
                    if (((((applyActualDimensions) && ((target is IFlexDisplayObject)))) && ((property == "height")))){
                        target.setActualSize(target.width, value);
                    } else {
                        if (((((applyActualDimensions) && ((target is IFlexDisplayObject)))) && ((property == "width")))){
                            target.setActualSize(value, target.height);
                        } else {
                            target[property] = value;
                        };
                    };
                } catch(e:Error) {
                };
            };
        }
        protected function initInstance(_arg1:IEffectInstance):void{
            _arg1.duration = duration;
            Object(_arg1).durationExplicitlySet = durationExplicitlySet;
            _arg1.effect = this;
            _arg1.effectTargetHost = effectTargetHost;
            _arg1.hideFocusRing = hideFocusRing;
            _arg1.repeatCount = repeatCount;
            _arg1.repeatDelay = repeatDelay;
            _arg1.startDelay = startDelay;
            _arg1.suspendBackgroundProcessing = suspendBackgroundProcessing;
        }
        mx_internal function applyStartValues(_arg1:Array, _arg2:Array):void{
            var _local6:int;
            var _local7:int;
            var _local8:Object;
            var _local9:Boolean;
            var _local3:Array = relevantProperties;
            var _local4:int = _arg1.length;
            var _local5:int;
            while (_local5 < _local4) {
                _local8 = _arg1[_local5].target;
                _local9 = false;
                _local6 = _arg2.length;
                _local7 = 0;
                while (_local7 < _local6) {
                    if (_arg2[_local7] == _local8){
                        _local9 = filterInstance(_arg1, _local8);
                        break;
                    };
                    _local7++;
                };
                if (_local9){
                    _local6 = _local3.length;
                    _local7 = 0;
                    while (_local7 < _local6) {
                        if ((((_local3[_local7] in _arg1[_local5].start)) && ((_local3[_local7] in _local8)))){
                            applyValueToTarget(_local8, _local3[_local7], _arg1[_local5].start[_local3[_local7]], _arg1[_local5].start);
                        };
                        _local7++;
                    };
                    _local6 = relevantStyles.length;
                    _local7 = 0;
                    while (_local7 < _local6) {
                        if ((relevantStyles[_local7] in _arg1[_local5].start)){
                            _local8.setStyle(relevantStyles[_local7], _arg1[_local5].start[relevantStyles[_local7]]);
                        };
                        _local7++;
                    };
                };
                _local5++;
            };
        }
        public function end(_arg1:IEffectInstance=null):void{
            var _local2:int;
            var _local3:int;
            var _local4:IEffectInstance;
            if (_arg1){
                _arg1.end();
            } else {
                _local2 = _instances.length;
                _local3 = _local2;
                while (_local3 >= 0) {
                    _local4 = IEffectInstance(_instances[_local3]);
                    if (_local4){
                        _local4.end();
                    };
                    _local3--;
                };
            };
        }
        public function get relevantStyles():Array{
            return (_relevantStyles);
        }
        public function createInstances(_arg1:Array=null):Array{
            var _local6:IEffectInstance;
            if (!_arg1){
                _arg1 = this.targets;
            };
            var _local2:Array = [];
            var _local3:int = _arg1.length;
            var _local4:Number = 0;
            var _local5:int;
            while (_local5 < _local3) {
                _local6 = createInstance(_arg1[_local5]);
                if (_local6){
                    _local6.startDelay = (_local6.startDelay + _local4);
                    _local4 = (_local4 + perElementOffset);
                    _local2.push(_local6);
                };
                _local5++;
            };
            triggerEvent = null;
            return (_local2);
        }
        public function pause():void{
            var _local1:int;
            var _local2:int;
            if (((isPlaying) && (!(isPaused)))){
                isPaused = true;
                _local1 = _instances.length;
                _local2 = 0;
                while (_local2 < _local1) {
                    IEffectInstance(_instances[_local2]).pause();
                    _local2++;
                };
            };
        }
        public function set filter(_arg1:String):void{
            if (!customFilter){
                _filter = _arg1;
                switch (_arg1){
                    case "add":
                    case "remove":
                        filterObject = new AddRemoveEffectTargetFilter();
                        AddRemoveEffectTargetFilter(filterObject).add = (_arg1 == "add");
                        break;
                    case "hide":
                    case "show":
                        filterObject = new HideShowEffectTargetFilter();
                        HideShowEffectTargetFilter(filterObject).show = (_arg1 == "show");
                        break;
                    case "move":
                        filterObject = new EffectTargetFilter();
                        filterObject.filterProperties = ["x", "y"];
                        break;
                    case "resize":
                        filterObject = new EffectTargetFilter();
                        filterObject.filterProperties = ["width", "height"];
                        break;
                    case "addItem":
                        filterObject = new EffectTargetFilter();
                        filterObject.requiredSemantics = {added:true};
                        break;
                    case "removeItem":
                        filterObject = new EffectTargetFilter();
                        filterObject.requiredSemantics = {removed:true};
                        break;
                    case "replacedItem":
                        filterObject = new EffectTargetFilter();
                        filterObject.requiredSemantics = {replaced:true};
                        break;
                    case "replacementItem":
                        filterObject = new EffectTargetFilter();
                        filterObject.requiredSemantics = {replacement:true};
                        break;
                    default:
                        filterObject = null;
                };
            };
        }
        public function reverse():void{
            var _local1:int;
            var _local2:int;
            if (isPlaying){
                _local1 = _instances.length;
                _local2 = 0;
                while (_local2 < _local1) {
                    IEffectInstance(_instances[_local2]).reverse();
                    _local2++;
                };
            };
        }

    }
}//package mx.effects 
