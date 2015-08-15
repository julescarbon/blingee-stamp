package mx.collections {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.utils.*;
    import mx.utils.*;

    public class ArrayList extends EventDispatcher implements IList, IExternalizable, IPropertyChangeNotifier {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _source:Array;
        private var _dispatchEvents:int = 0;
        private var _uid:String;
        private var resourceManager:IResourceManager;

        public function ArrayList(_arg1:Array=null){
            resourceManager = ResourceManager.getInstance();
            super();
            disableEvents();
            this.source = _arg1;
            enableEvents();
            _uid = UIDUtil.createUID();
        }
        public function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void{
            var _local5:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _local5.kind = PropertyChangeEventKind.UPDATE;
            _local5.source = _arg1;
            _local5.property = _arg2;
            _local5.oldValue = _arg3;
            _local5.newValue = _arg4;
            itemUpdateHandler(_local5);
        }
        public function readExternal(_arg1:IDataInput):void{
            source = _arg1.readObject();
        }
        private function internalDispatchEvent(_arg1:String, _arg2:Object=null, _arg3:int=-1):void{
            var _local4:CollectionEvent;
            var _local5:PropertyChangeEvent;
            if (_dispatchEvents == 0){
                if (hasEventListener(CollectionEvent.COLLECTION_CHANGE)){
                    _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local4.kind = _arg1;
                    _local4.items.push(_arg2);
                    _local4.location = _arg3;
                    dispatchEvent(_local4);
                };
                if (((hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) && ((((_arg1 == CollectionEventKind.ADD)) || ((_arg1 == CollectionEventKind.REMOVE)))))){
                    _local5 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                    _local5.property = _arg3;
                    if (_arg1 == CollectionEventKind.ADD){
                        _local5.newValue = _arg2;
                    } else {
                        _local5.oldValue = _arg2;
                    };
                    dispatchEvent(_local5);
                };
            };
        }
        public function removeAll():void{
            var _local1:int;
            var _local2:int;
            if (length > 0){
                _local1 = length;
                _local2 = 0;
                while (_local2 < _local1) {
                    stopTrackUpdates(source[_local2]);
                    _local2++;
                };
                source.splice(0, length);
                internalDispatchEvent(CollectionEventKind.RESET);
            };
        }
        public function removeItemAt(_arg1:int):Object{
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            var _local2:Object = source.splice(_arg1, 1)[0];
            stopTrackUpdates(_local2);
            internalDispatchEvent(CollectionEventKind.REMOVE, _local2, _arg1);
            return (_local2);
        }
        public function get uid():String{
            return (_uid);
        }
        public function getItemIndex(_arg1:Object):int{
            return (ArrayUtil.getItemIndex(_arg1, source));
        }
        public function writeExternal(_arg1:IDataOutput):void{
            _arg1.writeObject(_source);
        }
        public function addItem(_arg1:Object):void{
            addItemAt(_arg1, length);
        }
        public function toArray():Array{
            return (source.concat());
        }
        private function disableEvents():void{
            _dispatchEvents--;
        }
        public function get source():Array{
            return (_source);
        }
        public function getItemAt(_arg1:int, _arg2:int=0):Object{
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            return (source[_arg1]);
        }
        public function set uid(_arg1:String):void{
            _uid = _arg1;
        }
        public function setItemAt(_arg1:Object, _arg2:int):Object{
            var _local4:String;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:PropertyChangeEvent;
            var _local8:CollectionEvent;
            if ((((_arg2 < 0)) || ((_arg2 >= length)))){
                _local4 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:Object = source[_arg2];
            source[_arg2] = _arg1;
            stopTrackUpdates(_local3);
            startTrackUpdates(_arg1);
            if (_dispatchEvents == 0){
                _local5 = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
                _local6 = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
                if (((_local5) || (_local6))){
                    _local7 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                    _local7.kind = PropertyChangeEventKind.UPDATE;
                    _local7.oldValue = _local3;
                    _local7.newValue = _arg1;
                    _local7.property = _arg2;
                };
                if (_local5){
                    _local8 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local8.kind = CollectionEventKind.REPLACE;
                    _local8.location = _arg2;
                    _local8.items.push(_local7);
                    dispatchEvent(_local8);
                };
                if (_local6){
                    dispatchEvent(_local7);
                };
            };
            return (_local3);
        }
        public function get length():int{
            if (source){
                return (source.length);
            };
            return (0);
        }
        protected function stopTrackUpdates(_arg1:Object):void{
            if (((_arg1) && ((_arg1 is IEventDispatcher)))){
                IEventDispatcher(_arg1).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, itemUpdateHandler);
            };
        }
        protected function itemUpdateHandler(_arg1:PropertyChangeEvent):void{
            var _local2:PropertyChangeEvent;
            var _local3:uint;
            internalDispatchEvent(CollectionEventKind.UPDATE, _arg1);
            if ((((_dispatchEvents == 0)) && (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)))){
                _local2 = PropertyChangeEvent(_arg1.clone());
                _local3 = getItemIndex(_arg1.target);
                _local2.property = ((_local3.toString() + ".") + _arg1.property);
                dispatchEvent(_local2);
            };
        }
        public function addItemAt(_arg1:Object, _arg2:int):void{
            var _local3:String;
            if ((((_arg2 < 0)) || ((_arg2 > length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local3));
            };
            source.splice(_arg2, 0, _arg1);
            startTrackUpdates(_arg1);
            internalDispatchEvent(CollectionEventKind.ADD, _arg1, _arg2);
        }
        public function removeItem(_arg1:Object):Boolean{
            var _local2:int = getItemIndex(_arg1);
            var _local3 = (_local2 >= 0);
            if (_local3){
                removeItemAt(_local2);
            };
            return (_local3);
        }
        protected function startTrackUpdates(_arg1:Object):void{
            if (((_arg1) && ((_arg1 is IEventDispatcher)))){
                IEventDispatcher(_arg1).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, itemUpdateHandler, false, 0, true);
            };
        }
        override public function toString():String{
            if (source){
                return (source.toString());
            };
            return (getQualifiedClassName(this));
        }
        private function enableEvents():void{
            _dispatchEvents++;
            if (_dispatchEvents > 0){
                _dispatchEvents = 0;
            };
        }
        public function set source(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            var _local4:CollectionEvent;
            if (((_source) && (_source.length))){
                _local3 = _source.length;
                _local2 = 0;
                while (_local2 < _local3) {
                    stopTrackUpdates(_source[_local2]);
                    _local2++;
                };
            };
            _source = ((_arg1) ? _arg1 : []);
            _local3 = _source.length;
            _local2 = 0;
            while (_local2 < _local3) {
                startTrackUpdates(_source[_local2]);
                _local2++;
            };
            if (_dispatchEvents == 0){
                _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local4.kind = CollectionEventKind.RESET;
                dispatchEvent(_local4);
            };
        }

    }
}//package mx.collections 
