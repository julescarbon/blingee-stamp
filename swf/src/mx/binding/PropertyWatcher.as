package mx.binding {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.utils.*;
    import mx.utils.*;

    public class PropertyWatcher extends Watcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        protected var propertyGetter:Function;
        private var parentObj:Object;
        protected var events:Object;
        private var useRTTI:Boolean;
        private var _propertyName:String;

        public function PropertyWatcher(_arg1:String, _arg2:Object, _arg3:Array, _arg4:Function=null){
            super(_arg3);
            _propertyName = _arg1;
            this.events = _arg2;
            this.propertyGetter = _arg4;
            useRTTI = !(_arg2);
        }
        private function eventNamesToString():String{
            var _local2:String;
            var _local1 = " ";
            for (_local2 in events) {
                _local1 = (_local1 + (_local2 + " "));
            };
            return (_local1);
        }
        override public function updateParent(_arg1:Object):void{
            var _local2:String;
            var _local3:BindabilityInfo;
            if (((parentObj) && ((parentObj is IEventDispatcher)))){
                for (_local2 in events) {
                    parentObj.removeEventListener(_local2, eventHandler);
                };
            };
            if ((_arg1 is Watcher)){
                parentObj = _arg1.value;
            } else {
                parentObj = _arg1;
            };
            if (parentObj){
                if (useRTTI){
                    events = {};
                    if ((parentObj is IEventDispatcher)){
                        _local3 = DescribeTypeCache.describeType(parentObj).bindabilityInfo;
                        events = _local3.getChangeEvents(_propertyName);
                        if (objectIsEmpty(events)){
                            trace((((("warning: unable to bind to property '" + _propertyName) + "' on class '") + getQualifiedClassName(parentObj)) + "'"));
                        } else {
                            addParentEventListeners();
                        };
                    } else {
                        trace((((("warning: unable to bind to property '" + _propertyName) + "' on class '") + getQualifiedClassName(parentObj)) + "' (class is not an IEventDispatcher)"));
                    };
                } else {
                    if ((parentObj is IEventDispatcher)){
                        addParentEventListeners();
                    };
                };
            };
            wrapUpdate(updateProperty);
        }
        private function objectIsEmpty(_arg1:Object):Boolean{
            var _local2:String;
            for (_local2 in _arg1) {
                return (false);
            };
            return (true);
        }
        override protected function shallowClone():Watcher{
            var _local1:PropertyWatcher = new PropertyWatcher(_propertyName, events, listeners, propertyGetter);
            return (_local1);
        }
        private function traceInfo():String{
            return ((((((("Watcher(" + getQualifiedClassName(parentObj)) + ".") + _propertyName) + "): events = [") + eventNamesToString()) + ((useRTTI) ? "] (RTTI)" : "]")));
        }
        public function get propertyName():String{
            return (_propertyName);
        }
        private function addParentEventListeners():void{
            var _local1:String;
            for (_local1 in events) {
                if (_local1 != "__NoChangeEvent__"){
                    parentObj.addEventListener(_local1, eventHandler, false, EventPriority.BINDING, true);
                };
            };
        }
        private function updateProperty():void{
            if (parentObj){
                if (_propertyName == "this"){
                    value = parentObj;
                } else {
                    if (propertyGetter != null){
                        value = propertyGetter.apply(parentObj, [_propertyName]);
                    } else {
                        value = parentObj[_propertyName];
                    };
                };
            } else {
                value = null;
            };
            updateChildren();
        }
        public function eventHandler(_arg1:Event):void{
            var _local2:Object;
            if ((_arg1 is PropertyChangeEvent)){
                _local2 = PropertyChangeEvent(_arg1).property;
                if (_local2 != _propertyName){
                    return;
                };
            };
            wrapUpdate(updateProperty);
            notifyListeners(events[_arg1.type]);
        }

    }
}//package mx.binding 
