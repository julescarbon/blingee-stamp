package mx.collections {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.utils.*;
    import mx.utils.*;

    public class XMLListAdapter extends EventDispatcher implements IList, IXMLNotifiable {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var uidCounter:int = 0;
        private var _dispatchEvents:int = 0;
        private var _busy:int = 0;
        private var seedUID:String;
        private var _source:XMLList;
        private var resourceManager:IResourceManager;

        public function XMLListAdapter(_arg1:XMLList=null){
            resourceManager = ResourceManager.getInstance();
            super();
            disableEvents();
            this.source = _arg1;
            enableEvents();
        }
        public function setItemAt(_arg1:Object, _arg2:int):Object{
            var _local4:String;
            var _local5:CollectionEvent;
            var _local6:PropertyChangeEvent;
            if ((((_arg2 < 0)) || ((_arg2 >= length)))){
                _local4 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:Object = source[_arg2];
            source[_arg2] = _arg1;
            stopTrackUpdates(_local3);
            startTrackUpdates(_arg1, (seedUID + uidCounter.toString()));
            uidCounter++;
            if (_dispatchEvents == 0){
                _local5 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local5.kind = CollectionEventKind.REPLACE;
                _local6 = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                _local6.kind = PropertyChangeEventKind.UPDATE;
                _local6.oldValue = _local3;
                _local6.newValue = _arg1;
                _local5.location = _arg2;
                _local5.items.push(_local6);
                dispatchEvent(_local5);
            };
            return (_local3);
        }
        protected function startTrackUpdates(_arg1:Object, _arg2:String):void{
            XMLNotifier.getInstance().watchXML(_arg1, this, _arg2);
        }
        public function removeAll():void{
            var _local1:int;
            var _local2:CollectionEvent;
            if (length > 0){
                _local1 = (length - 1);
                while (_local1 >= 0) {
                    stopTrackUpdates(source[_local1]);
                    delete source[_local1];
                    _local1--;
                };
                if (_dispatchEvents == 0){
                    _local2 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local2.kind = CollectionEventKind.RESET;
                    dispatchEvent(_local2);
                };
            };
        }
        protected function itemUpdateHandler(_arg1:PropertyChangeEvent):void{
            var _local2:CollectionEvent;
            if (_dispatchEvents == 0){
                _local2 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local2.kind = CollectionEventKind.UPDATE;
                _local2.items.push(_arg1);
                dispatchEvent(_local2);
            };
        }
        public function getItemIndex(_arg1:Object):int{
            var _local2:int;
            var _local3:int;
            var _local4:Object;
            if ((((_arg1 is XML)) && (source.contains(XML(_arg1))))){
                _local2 = length;
                _local3 = 0;
                while (_local3 < _local2) {
                    _local4 = source[_local3];
                    if (_local4 === _arg1){
                        return (_local3);
                    };
                    _local3++;
                };
            };
            return (-1);
        }
        public function removeItemAt(_arg1:int):Object{
            var _local3:String;
            var _local4:CollectionEvent;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            setBusy();
            var _local2:Object = source[_arg1];
            delete source[_arg1];
            stopTrackUpdates(_local2);
            if (_dispatchEvents == 0){
                _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local4.kind = CollectionEventKind.REMOVE;
                _local4.location = _arg1;
                _local4.items.push(_local2);
                dispatchEvent(_local4);
            };
            clearBusy();
            return (_local2);
        }
        public function addItem(_arg1:Object):void{
            addItemAt(_arg1, length);
        }
        public function get source():XMLList{
            return (_source);
        }
        public function toArray():Array{
            var _local1:XMLList = source;
            var _local2:int = _local1.length();
            var _local3:Array = [];
            var _local4:int;
            while (_local4 < _local2) {
                _local3[_local4] = _local1[_local4];
                _local4++;
            };
            return (_local3);
        }
        protected function disableEvents():void{
            _dispatchEvents--;
        }
        public function xmlNotification(_arg1:Object, _arg2:String, _arg3:Object, _arg4:Object, _arg5:Object):void{
            var _local6:String;
            var _local7:Object;
            var _local8:Object;
            var _local9:*;
            var _local10:*;
            if (_arg1 === _arg3){
                switch (_arg2){
                    case "attributeAdded":
                        _local6 = ("@" + String(_arg4));
                        _local8 = _arg5;
                        break;
                    case "attributeChanged":
                        _local6 = ("@" + String(_arg4));
                        _local7 = _arg5;
                        _local8 = _arg3[_local6];
                        break;
                    case "attributeRemoved":
                        _local6 = ("@" + String(_arg4));
                        _local7 = _arg5;
                        break;
                    case "nodeAdded":
                        _local6 = _arg4.localName();
                        _local8 = _arg4;
                        break;
                    case "nodeChanged":
                        _local6 = _arg4.localName();
                        _local7 = _arg5;
                        _local8 = _arg4;
                        break;
                    case "nodeRemoved":
                        _local6 = _arg4.localName();
                        _local7 = _arg4;
                        break;
                    case "textSet":
                        _local6 = String(_arg4);
                        _local8 = String(_arg3[_local6]);
                        _local7 = _arg5;
                        break;
                };
            } else {
                if (_arg2 == "textSet"){
                    _local9 = _arg3.parent();
                    if (_local9 != undefined){
                        _local10 = _local9.parent();
                        if (_local10 === _arg1){
                            _local6 = _local9.name().toString();
                            _local8 = _arg4;
                            _local7 = _arg5;
                        };
                    };
                };
            };
            itemUpdated(_arg1, _local6, _local7, _local8);
        }
        public function addItemAt(_arg1:Object, _arg2:int):void{
            var _local3:String;
            var _local4:CollectionEvent;
            if ((((_arg2 < 0)) || ((_arg2 > length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local3));
            };
            if (((!((_arg1 is XML))) && (!((((_arg1 is XMLList)) && ((_arg1.length() == 1))))))){
                _local3 = resourceManager.getString("collections", "invalidType");
                throw (new Error(_local3));
            };
            setBusy();
            if (_arg2 == 0){
                source[0] = (((length > 0)) ? (_arg1 + source[0]) : _arg1);
            } else {
                source[(_arg2 - 1)] = (source[(_arg2 - 1)] + _arg1);
            };
            startTrackUpdates(_arg1, (seedUID + uidCounter.toString()));
            uidCounter++;
            if (_dispatchEvents == 0){
                _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local4.kind = CollectionEventKind.ADD;
                _local4.items.push(_arg1);
                _local4.location = _arg2;
                dispatchEvent(_local4);
            };
            clearBusy();
        }
        public function getItemAt(_arg1:int, _arg2:int=0):Object{
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            return (source[_arg1]);
        }
        override public function toString():String{
            if (source){
                return (source.toString());
            };
            return (getQualifiedClassName(this));
        }
        public function get length():int{
            return (source.length());
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
        protected function stopTrackUpdates(_arg1:Object):void{
            XMLNotifier.getInstance().unwatchXML(_arg1, this);
        }
        private function clearBusy():void{
            _busy++;
            if (_busy > 0){
                _busy = 0;
            };
        }
        public function set source(_arg1:XMLList):void{
            var _local2:int;
            var _local3:int;
            var _local4:CollectionEvent;
            if (((_source) && (_source.length()))){
                _local3 = _source.length();
                _local2 = 0;
                while (_local2 < _local3) {
                    stopTrackUpdates(_source[_local2]);
                    _local2++;
                };
            };
            _source = ((_arg1) ? _arg1 : XMLList(new XMLList("")));
            seedUID = UIDUtil.createUID();
            uidCounter = 0;
            _local3 = _source.length();
            _local2 = 0;
            while (_local2 < _local3) {
                startTrackUpdates(_source[_local2], (seedUID + uidCounter.toString()));
                uidCounter++;
                _local2++;
            };
            if (_dispatchEvents == 0){
                _local4 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local4.kind = CollectionEventKind.RESET;
                dispatchEvent(_local4);
            };
        }
        public function busy():Boolean{
            return (!((_busy == 0)));
        }
        private function setBusy():void{
            _busy--;
        }
        protected function enableEvents():void{
            _dispatchEvents++;
            if (_dispatchEvents > 0){
                _dispatchEvents = 0;
            };
        }

    }
}//package mx.collections 
