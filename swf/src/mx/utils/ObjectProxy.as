package mx.utils {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import flash.utils.*;

    public dynamic class ObjectProxy extends Proxy implements IExternalizable, IPropertyChangeNotifier {

        private var _id:String;
        protected var notifiers:Object;
        protected var propertyList:Array;
        private var _proxyLevel:int;
        private var _type:QName;
        protected var dispatcher:EventDispatcher;
        protected var proxyClass:Class;
        private var _item:Object;

        public function ObjectProxy(_arg1:Object=null, _arg2:String=null, _arg3:int=-1){
            proxyClass = ObjectProxy;
            super();
            if (!_arg1){
                _arg1 = {};
            };
            _item = _arg1;
            _proxyLevel = _arg3;
            notifiers = {};
            dispatcher = new EventDispatcher(this);
            if (_arg2){
                _id = _arg2;
            };
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (dispatcher.dispatchEvent(_arg1));
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (dispatcher.hasEventListener(_arg1));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function setProperty(_arg1, _arg2):void{
            var _local4:IPropertyChangeNotifier;
            var _local5:PropertyChangeEvent;
            var _local3:* = _item[_arg1];
            if (_local3 !== _arg2){
                _item[_arg1] = _arg2;
                _local4 = IPropertyChangeNotifier(notifiers[_arg1]);
                if (_local4){
                    _local4.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
                    delete notifiers[_arg1];
                };
                if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)){
                    if ((_arg1 is QName)){
                        _arg1 = QName(_arg1).localName;
                    };
                    _local5 = PropertyChangeEvent.createUpdateEvent(this, _arg1.toString(), _local3, _arg2);
                    dispatcher.dispatchEvent(_local5);
                };
            };
        }
        public function willTrigger(_arg1:String):Boolean{
            return (dispatcher.willTrigger(_arg1));
        }
        public function readExternal(_arg1:IDataInput):void{
            var _local2:Object = _arg1.readObject();
            _item = _local2;
        }
        public function writeExternal(_arg1:IDataOutput):void{
            _arg1.writeObject(_item);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function getProperty(_arg1){
            var _local2:*;
            if (notifiers[_arg1.toString()]){
                return (notifiers[_arg1]);
            };
            _local2 = _item[_arg1];
            if (_local2){
                if ((((_proxyLevel == 0)) || (ObjectUtil.isSimple(_local2)))){
                    return (_local2);
                };
                _local2 = getComplexProperty(_arg1, _local2);
            };
            return (_local2);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function hasProperty(_arg1):Boolean{
            return ((_arg1 in _item));
        }
        public function get uid():String{
            if (_id === null){
                _id = UIDUtil.createUID();
            };
            return (_id);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextNameIndex(_arg1:int):int{
            if (_arg1 == 0){
                setupPropertyList();
            };
            if (_arg1 < propertyList.length){
                return ((_arg1 + 1));
            };
            return (0);
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            dispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextName(_arg1:int):String{
            return (propertyList[(_arg1 - 1)]);
        }
        public function set uid(_arg1:String):void{
            _id = _arg1;
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function callProperty(_arg1, ... _args){
            return (_item[_arg1].apply(_item, _args));
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            dispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        protected function setupPropertyList():void{
            var _local1:String;
            if (getQualifiedClassName(_item) == "Object"){
                propertyList = [];
                for (_local1 in _item) {
                    propertyList.push(_local1);
                };
            } else {
                propertyList = ObjectUtil.getClassInfo(_item, null, {
                    includeReadOnly:true,
                    uris:["*"]
                }).properties;
            };
        }
        object_proxy function getComplexProperty(_arg1, _arg2){
            if ((_arg2 is IPropertyChangeNotifier)){
                _arg2.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
                notifiers[_arg1] = _arg2;
                return (_arg2);
            };
            if (getQualifiedClassName(_arg2) == "Object"){
                _arg2 = new proxyClass(_item[_arg1], null, (((_proxyLevel > 0)) ? (_proxyLevel - 1) : _proxyLevel));
                _arg2.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
                notifiers[_arg1] = _arg2;
                return (_arg2);
            };
            return (_arg2);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function deleteProperty(_arg1):Boolean{
            var _local5:PropertyChangeEvent;
            var _local2:IPropertyChangeNotifier = IPropertyChangeNotifier(notifiers[_arg1]);
            if (_local2){
                _local2.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
                delete notifiers[_arg1];
            };
            var _local3:* = _item[_arg1];
            var _local4 = delete _item[_arg1];
            if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)){
                _local5 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                _local5.kind = PropertyChangeEventKind.DELETE;
                _local5.property = _arg1;
                _local5.oldValue = _local3;
                _local5.source = this;
                dispatcher.dispatchEvent(_local5);
            };
            return (_local4);
        }
        object_proxy function get type():QName{
            return (_type);
        }
        object_proxy function set type(_arg1:QName):void{
            _type = _arg1;
        }
        public function propertyChangeHandler(_arg1:PropertyChangeEvent):void{
            dispatcher.dispatchEvent(_arg1);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextValue(_arg1:int){
            return (_item[propertyList[(_arg1 - 1)]]);
        }
        object_proxy function get object():Object{
            return (_item);
        }

    }
}//package mx.utils 
