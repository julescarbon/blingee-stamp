package mx.collections {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.utils.*;
    import mx.utils.*;
    import mx.collections.errors.*;

    public class ListCollectionView extends Proxy implements ICollectionView, IList, IMXMLObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var autoUpdateCounter:int;
        private var _list:IList;
        private var _filterFunction:Function;
        protected var localIndex:Array;
        mx_internal var dispatchResetEvent:Boolean = true;
        private var pendingUpdates:Array;
        private var resourceManager:IResourceManager;
        private var eventDispatcher:EventDispatcher;
        private var revision:int;
        private var _sort:Sort;

        public function ListCollectionView(_arg1:IList=null){
            resourceManager = ResourceManager.getInstance();
            super();
            eventDispatcher = new EventDispatcher(this);
            this.list = _arg1;
        }
        private function handlePendingUpdates():void{
            var _local1:Array;
            var _local2:CollectionEvent;
            var _local3:int;
            var _local4:CollectionEvent;
            var _local5:int;
            if (pendingUpdates){
                _local1 = pendingUpdates;
                pendingUpdates = null;
                _local3 = 0;
                while (_local3 < _local1.length) {
                    _local4 = _local1[_local3];
                    if (_local4.kind == CollectionEventKind.UPDATE){
                        if (!_local2){
                            _local2 = _local4;
                        } else {
                            _local5 = 0;
                            while (_local5 < _local4.items.length) {
                                _local2.items.push(_local4.items[_local5]);
                                _local5++;
                            };
                        };
                    } else {
                        listChangeHandler(_local4);
                    };
                    _local3++;
                };
                if (_local2){
                    listChangeHandler(_local2);
                };
            };
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            eventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        private function replaceItemsInView(_arg1:Array, _arg2:int, _arg3:Boolean=true):void{
            var _local4:int;
            var _local5:Array;
            var _local6:Array;
            var _local7:int;
            var _local8:PropertyChangeEvent;
            var _local9:CollectionEvent;
            if (localIndex){
                _local4 = _arg1.length;
                _local5 = [];
                _local6 = [];
                _local7 = 0;
                while (_local7 < _local4) {
                    _local8 = _arg1[_local7];
                    _local5.push(_local8.oldValue);
                    _local6.push(_local8.newValue);
                    _local7++;
                };
                removeItemsFromView(_local5, _arg2, _arg3);
                addItemsToView(_local6, _arg2, _arg3);
            } else {
                _local9 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local9.kind = CollectionEventKind.REPLACE;
                _local9.location = _arg2;
                _local9.items = _arg1;
                dispatchEvent(_local9);
            };
        }
        public function willTrigger(_arg1:String):Boolean{
            return (eventDispatcher.willTrigger(_arg1));
        }
        private function getFilteredItemIndex(_arg1:Object):int{
            var _local4:Object;
            var _local5:int;
            var _local6:int;
            var _local2:int = list.getItemIndex(_arg1);
            if (_local2 == 0){
                return (0);
            };
            var _local3:int = (_local2 - 1);
            while (_local3 >= 0) {
                _local4 = list.getItemAt(_local3);
                if (filterFunction(_local4)){
                    _local5 = localIndex.length;
                    _local6 = 0;
                    while (_local6 < _local5) {
                        if (localIndex[_local6] == _local4){
                            return ((_local6 + 1));
                        };
                        _local6++;
                    };
                };
                _local3--;
            };
            return (0);
        }
        mx_internal function findItem(_arg1:Object, _arg2:String, _arg3:Boolean=false):int{
            var _local4:String;
            if (!sort){
                _local4 = resourceManager.getString("collections", "itemNotFound");
                throw (new CollectionViewError(_local4));
            };
            if (localIndex.length == 0){
                return (((_arg3) ? 0 : -1));
            };
            return (sort.findItem(localIndex, _arg1, _arg2, _arg3));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextName(_arg1:int):String{
            return ((_arg1 - 1).toString());
        }
        public function removeAll():void{
            var _local2:int;
            var _local1:int = length;
            if (_local1 > 0){
                if (localIndex){
                    _local2 = (_local1 - 1);
                    while (_local2 >= 0) {
                        removeItemAt(_local2);
                        _local2--;
                    };
                } else {
                    list.removeAll();
                };
            };
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function hasProperty(_arg1):Boolean{
            var n:* = NaN;
            var name:* = _arg1;
            if ((name is QName)){
                name = name.localName;
            };
            var index:* = -1;
            try {
                n = parseInt(String(name));
                if (!isNaN(n)){
                    index = int(n);
                };
            } catch(e:Error) {
            };
            if (index == -1){
                return (false);
            };
            return ((((index >= 0)) && ((index < length))));
        }
        public function getItemAt(_arg1:int, _arg2:int=0):Object{
            var _local3:String;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            if (localIndex){
                return (localIndex[_arg1]);
            };
            if (list){
                return (list.getItemAt(_arg1, _arg2));
            };
            return (null);
        }
        private function moveItemInView(_arg1:Object, _arg2:Boolean=true, _arg3:Array=null):void{
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:CollectionEvent;
            if (localIndex){
                _local4 = -1;
                _local5 = 0;
                while (_local5 < localIndex.length) {
                    if (localIndex[_local5] == _arg1){
                        _local4 = _local5;
                        break;
                    };
                    _local5++;
                };
                if (_local4 > -1){
                    localIndex.splice(_local4, 1);
                };
                _local6 = addItemsToView([_arg1], _local4, false);
                if (_arg2){
                    _local7 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                    _local7.items.push(_arg1);
                    if (((((_arg3) && ((_local6 == _local4)))) && ((_local6 > -1)))){
                        _arg3.push(_arg1);
                        return;
                    };
                    if ((((_local6 > -1)) && ((_local4 > -1)))){
                        _local7.kind = CollectionEventKind.MOVE;
                        _local7.location = _local6;
                        _local7.oldLocation = _local4;
                    } else {
                        if (_local6 > -1){
                            _local7.kind = CollectionEventKind.ADD;
                            _local7.location = _local6;
                        } else {
                            if (_local4 > -1){
                                _local7.kind = CollectionEventKind.REMOVE;
                                _local7.location = _local4;
                            } else {
                                _arg2 = false;
                            };
                        };
                    };
                    if (_arg2){
                        dispatchEvent(_local7);
                    };
                };
            };
        }
        public function contains(_arg1:Object):Boolean{
            return (!((getItemIndex(_arg1) == -1)));
        }
        public function get sort():Sort{
            return (_sort);
        }
        private function removeItemsFromView(_arg1:Array, _arg2:int, _arg3:Boolean=true):void{
            var _local6:int;
            var _local7:Object;
            var _local8:int;
            var _local9:CollectionEvent;
            var _local4:Array = ((localIndex) ? [] : _arg1);
            var _local5:int = _arg2;
            if (localIndex){
                _local6 = 0;
                while (_local6 < _arg1.length) {
                    _local7 = _arg1[_local6];
                    _local8 = getItemIndex(_local7);
                    if (_local8 > -1){
                        localIndex.splice(_local8, 1);
                        _local4.push(_local7);
                        _local5 = _local8;
                    };
                    _local6++;
                };
            };
            if (((_arg3) && ((_local4.length > 0)))){
                _local9 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local9.kind = CollectionEventKind.REMOVE;
                _local9.location = ((((!(localIndex)) || ((_local4.length == 1)))) ? _local5 : -1);
                _local9.items = _local4;
                dispatchEvent(_local9);
            };
        }
        public function get list():IList{
            return (_list);
        }
        public function addItemAt(_arg1:Object, _arg2:int):void{
            var _local4:String;
            if ((((((_arg2 < 0)) || (!(list)))) || ((_arg2 > length)))){
                _local4 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:int = _arg2;
            if (((localIndex) && (sort))){
                _local3 = list.length;
            } else {
                if (((localIndex) && (!((filterFunction == null))))){
                    if (_local3 == localIndex.length){
                        _local3 = list.length;
                    } else {
                        _local3 = list.getItemIndex(localIndex[_arg2]);
                    };
                };
            };
            list.addItemAt(_arg1, _local3);
        }
        public function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void{
            list.itemUpdated(_arg1, _arg2, _arg3, _arg4);
        }
        private function populateLocalIndex():void{
            if (list){
                localIndex = list.toArray();
            } else {
                localIndex = [];
            };
        }
        private function handlePropertyChangeEvents(_arg1:Array):void{
            var _local3:Array;
            var _local4:Object;
            var _local5:int;
            var _local6:Array;
            var _local7:int;
            var _local8:PropertyChangeEvent;
            var _local9:Object;
            var _local10:Boolean;
            var _local11:int;
            var _local12:int;
            var _local13:CollectionEvent;
            var _local2:Array = _arg1;
            if (((sort) || (!((filterFunction == null))))){
                _local3 = [];
                _local5 = 0;
                while (_local5 < _arg1.length) {
                    _local8 = _arg1[_local5];
                    if (_local8.target){
                        _local9 = _local8.target;
                        _local10 = !((_local8.target == _local8.source));
                    } else {
                        _local9 = _local8.source;
                        _local10 = false;
                    };
                    _local11 = 0;
                    while (_local11 < _local3.length) {
                        if (_local3[_local11].item == _local9){
                            break;
                        };
                        _local11++;
                    };
                    if (_local11 < _local3.length){
                        _local4 = _local3[_local11];
                    } else {
                        _local4 = {
                            item:_local9,
                            move:_local10,
                            event:_local8
                        };
                        _local3.push(_local4);
                    };
                    _local4.move = ((((((_local4.move) || (filterFunction))) || (!(_local8.property)))) || (((sort) && (sort.propertyAffectsSort(String(_local8.property))))));
                    _local5++;
                };
                _local2 = [];
                _local5 = 0;
                while (_local5 < _local3.length) {
                    _local4 = _local3[_local5];
                    if (_local4.move){
                        moveItemInView(_local4.item, _local4.item, _local2);
                    } else {
                        _local2.push(_local4.item);
                    };
                    _local5++;
                };
                _local6 = [];
                _local7 = 0;
                while (_local7 < _local2.length) {
                    _local12 = 0;
                    while (_local12 < _local3.length) {
                        if (_local2[_local7] == _local3[_local12].item){
                            _local6.push(_local3[_local12].event);
                        };
                        _local12++;
                    };
                    _local7++;
                };
                _local2 = _local6;
            };
            if (_local2.length > 0){
                _local13 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local13.kind = CollectionEventKind.UPDATE;
                _local13.items = _local2;
                dispatchEvent(_local13);
            };
        }
        public function set sort(_arg1:Sort):void{
            _sort = _arg1;
            dispatchEvent(new Event("sortChanged"));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextValue(_arg1:int){
            return (getItemAt((_arg1 - 1)));
        }
        public function setItemAt(_arg1:Object, _arg2:int):Object{
            var _local4:String;
            var _local5:Object;
            if ((((((_arg2 < 0)) || (!(list)))) || ((_arg2 >= length)))){
                _local4 = resourceManager.getString("collections", "outOfBounds", [_arg2]);
                throw (new RangeError(_local4));
            };
            var _local3:int = _arg2;
            if (localIndex){
                if (_arg2 > localIndex.length){
                    _local3 = list.length;
                } else {
                    _local5 = localIndex[_arg2];
                    _local3 = list.getItemIndex(_local5);
                };
            };
            return (list.setItemAt(_arg1, _local3));
        }
        mx_internal function getBookmark(_arg1:int):ListCollectionViewBookmark{
            var value:* = null;
            var message:* = null;
            var index:* = _arg1;
            if ((((index < 0)) || ((index > length)))){
                message = resourceManager.getString("collections", "invalidIndex", [index]);
                throw (new CollectionViewError(message));
            };
            try {
                value = getItemAt(index);
            } catch(e:Error) {
                value = null;
            };
            return (new ListCollectionViewBookmark(value, this, revision, index));
        }
        private function addItemsToView(_arg1:Array, _arg2:int, _arg3:Boolean=true):int{
            var _local7:int;
            var _local8:int;
            var _local9:Object;
            var _local10:String;
            var _local11:CollectionEvent;
            var _local4:Array = ((localIndex) ? [] : _arg1);
            var _local5:int = _arg2;
            var _local6:Boolean;
            if (localIndex){
                _local7 = _arg2;
                _local8 = 0;
                while (_local8 < _arg1.length) {
                    _local9 = _arg1[_local8];
                    if ((((filterFunction == null)) || (filterFunction(_local9)))){
                        if (sort){
                            _local7 = findItem(_local9, Sort.ANY_INDEX_MODE, true);
                            if (_local6){
                                _local5 = _local7;
                                _local6 = false;
                            };
                        } else {
                            _local7 = getFilteredItemIndex(_local9);
                            if (_local6){
                                _local5 = _local7;
                                _local6 = false;
                            };
                        };
                        if (((((sort) && (sort.unique))) && ((sort.compareFunction(_local9, localIndex[_local7]) == 0)))){
                            _local10 = resourceManager.getString("collections", "incorrectAddition");
                            throw (new CollectionViewError(_local10));
                        };
                        var _temp1 = _local7;
                        _local7 = (_local7 + 1);
                        localIndex.splice(_temp1, 0, _local9);
                        _local4.push(_local9);
                    } else {
                        _local5 = -1;
                    };
                    _local8++;
                };
            };
            if (((localIndex) && ((_local4.length > 1)))){
                _local5 = -1;
            };
            if (((_arg3) && ((_local4.length > 0)))){
                _local11 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local11.kind = CollectionEventKind.ADD;
                _local11.location = _local5;
                _local11.items = _local4;
                dispatchEvent(_local11);
            };
            return (_local5);
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (eventDispatcher.dispatchEvent(_arg1));
        }
        public function set list(_arg1:IList):void{
            var _local2:Boolean;
            var _local3:Boolean;
            if (_list != _arg1){
                if (_list){
                    _list.removeEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler);
                    _local2 = (_list.length > 0);
                };
                _list = _arg1;
                if (_list){
                    _list.addEventListener(CollectionEvent.COLLECTION_CHANGE, listChangeHandler, false, 0, true);
                    _local3 = (_list.length > 0);
                };
                if (((_local2) || (_local3))){
                    reset();
                };
                dispatchEvent(new Event("listChanged"));
            };
        }
        mx_internal function getBookmarkIndex(_arg1:CursorBookmark):int{
            var _local3:String;
            if (((!((_arg1 is ListCollectionViewBookmark))) || (!((ListCollectionViewBookmark(_arg1).view == this))))){
                _local3 = resourceManager.getString("collections", "bookmarkNotFound");
                throw (new CollectionViewError(_local3));
            };
            var _local2:ListCollectionViewBookmark = ListCollectionViewBookmark(_arg1);
            if (_local2.viewRevision != revision){
                if ((((((_local2.index < 0)) || ((_local2.index >= length)))) || (!((getItemAt(_local2.index) == _local2.value))))){
                    _local2.index = getItemIndex(_local2.value);
                };
                _local2.viewRevision = revision;
            };
            return (_local2.index);
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            eventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function getItemIndex(_arg1:Object):int{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            if (sort){
                _local3 = sort.findItem(localIndex, _arg1, Sort.FIRST_INDEX_MODE);
                if (_local3 == -1){
                    return (-1);
                };
                _local4 = sort.findItem(localIndex, _arg1, Sort.LAST_INDEX_MODE);
                _local2 = _local3;
                while (_local2 <= _local4) {
                    if (localIndex[_local2] == _arg1){
                        return (_local2);
                    };
                    _local2++;
                };
                return (-1);
            };
            if (filterFunction != null){
                _local5 = localIndex.length;
                _local2 = 0;
                while (_local2 < _local5) {
                    if (localIndex[_local2] == _arg1){
                        return (_local2);
                    };
                    _local2++;
                };
                return (-1);
            };
            return (list.getItemIndex(_arg1));
        }
        public function removeItemAt(_arg1:int):Object{
            var _local3:String;
            var _local4:Object;
            if ((((_arg1 < 0)) || ((_arg1 >= length)))){
                _local3 = resourceManager.getString("collections", "outOfBounds", [_arg1]);
                throw (new RangeError(_local3));
            };
            var _local2:int = _arg1;
            if (localIndex){
                _local4 = localIndex[_arg1];
                _local2 = list.getItemIndex(_local4);
            };
            return (list.removeItemAt(_local2));
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function getProperty(_arg1){
            var n:* = NaN;
            var message:* = null;
            var name:* = _arg1;
            if ((name is QName)){
                name = name.localName;
            };
            var index:* = -1;
            try {
                n = parseInt(String(name));
                if (!isNaN(n)){
                    index = int(n);
                };
            } catch(e:Error) {
            };
            if (index == -1){
                message = resourceManager.getString("collections", "unknownProperty", [name]);
                throw (new Error(message));
            };
            return (getItemAt(index));
        }
        public function enableAutoUpdate():void{
            if (autoUpdateCounter > 0){
                autoUpdateCounter--;
                if (autoUpdateCounter == 0){
                    handlePendingUpdates();
                };
            };
        }
        mx_internal function reset():void{
            var _local1:CollectionEvent;
            internalRefresh(false);
            if (dispatchResetEvent){
                _local1 = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                _local1.kind = CollectionEventKind.RESET;
                dispatchEvent(_local1);
            };
        }
        public function toArray():Array{
            var _local1:Array;
            if (localIndex){
                _local1 = localIndex.concat();
            } else {
                _local1 = list.toArray();
            };
            return (_local1);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function callProperty(_arg1, ... _args){
            return (null);
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            refresh();
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function setProperty(_arg1, _arg2):void{
            var n:* = NaN;
            var message:* = null;
            var name:* = _arg1;
            var value:* = _arg2;
            if ((name is QName)){
                name = name.localName;
            };
            var index:* = -1;
            try {
                n = parseInt(String(name));
                if (!isNaN(n)){
                    index = int(n);
                };
            } catch(e:Error) {
            };
            if (index == -1){
                message = resourceManager.getString("collections", "unknownProperty", [name]);
                throw (new Error(message));
            };
            setItemAt(value, index);
        }
        public function addItem(_arg1:Object):void{
            addItemAt(_arg1, length);
        }
        private function internalRefresh(_arg1:Boolean):Boolean{
            var tmp:* = null;
            var len:* = 0;
            var i:* = 0;
            var item:* = null;
            var refreshEvent:* = null;
            var dispatch:* = _arg1;
            if (((sort) || (!((filterFunction == null))))){
                try {
                    populateLocalIndex();
                } catch(pending:ItemPendingError) {
                    pending.addResponder(new ItemResponder(function (_arg1:Object, _arg2:Object=null):void{
                        internalRefresh(dispatch);
                    }, function (_arg1:Object, _arg2:Object=null):void{
                    }));
                    return (false);
                };
                if (filterFunction != null){
                    tmp = [];
                    len = localIndex.length;
                    i = 0;
                    while (i < len) {
                        item = localIndex[i];
                        if (filterFunction(item)){
                            tmp.push(item);
                        };
                        i = (i + 1);
                    };
                    localIndex = tmp;
                };
                if (sort){
                    sort.sort(localIndex);
                    dispatch = true;
                };
            } else {
                if (localIndex){
                    localIndex = null;
                };
            };
            revision++;
            pendingUpdates = null;
            if (dispatch){
                refreshEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                refreshEvent.kind = CollectionEventKind.REFRESH;
                dispatchEvent(refreshEvent);
            };
            return (true);
        }
        public function set filterFunction(_arg1:Function):void{
            _filterFunction = _arg1;
            dispatchEvent(new Event("filterFunctionChanged"));
        }
        public function refresh():Boolean{
            return (internalRefresh(true));
        }
        public function get filterFunction():Function{
            return (_filterFunction);
        }
        public function createCursor():IViewCursor{
            return (new ListCollectionViewCursor(this));
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (eventDispatcher.hasEventListener(_arg1));
        }
        public function get length():int{
            if (localIndex){
                return (localIndex.length);
            };
            if (list){
                return (list.length);
            };
            return (0);
        }
        override "http://www.adobe.com/2006/actionscript/flash/proxy"?? function nextNameIndex(_arg1:int):int{
            return ((((_arg1 < length)) ? (_arg1 + 1) : 0));
        }
        public function disableAutoUpdate():void{
            autoUpdateCounter++;
        }
        public function toString():String{
            if (localIndex){
                return (ObjectUtil.toString(localIndex));
            };
            if (((list) && (Object(list).toString))){
                return (Object(list).toString());
            };
            return (getQualifiedClassName(this));
        }
        private function listChangeHandler(_arg1:CollectionEvent):void{
            if (autoUpdateCounter > 0){
                if (!pendingUpdates){
                    pendingUpdates = [];
                };
                pendingUpdates.push(_arg1);
            } else {
                switch (_arg1.kind){
                    case CollectionEventKind.ADD:
                        addItemsToView(_arg1.items, _arg1.location);
                        break;
                    case CollectionEventKind.RESET:
                        reset();
                        break;
                    case CollectionEventKind.REMOVE:
                        removeItemsFromView(_arg1.items, _arg1.location);
                        break;
                    case CollectionEventKind.REPLACE:
                        replaceItemsInView(_arg1.items, _arg1.location);
                        break;
                    case CollectionEventKind.UPDATE:
                        handlePropertyChangeEvents(_arg1.items);
                        break;
                    default:
                        dispatchEvent(_arg1);
                };
            };
        }

    }
}//package mx.collections 

import flash.events.*;
import mx.events.*;
import mx.resources.*;
import mx.collections.errors.*;

class ListCollectionViewBookmark extends CursorBookmark {

    mx_internal var viewRevision:int;
    mx_internal var index:int;
    mx_internal var view:ListCollectionView;

    public function ListCollectionViewBookmark(_arg1:Object, _arg2:ListCollectionView, _arg3:int, _arg4:int){
        super(_arg1);
        this.view = _arg2;
        this.viewRevision = _arg3;
        this.index = _arg4;
    }
    override public function getViewIndex():int{
        return (view.getBookmarkIndex(this));
    }

}
class ListCollectionViewCursor extends EventDispatcher implements IViewCursor {

    private static const BEFORE_FIRST_INDEX:int = -1;
    private static const AFTER_LAST_INDEX:int = -2;

    private var _view:ListCollectionView;
    private var invalid:Boolean;
    private var resourceManager:IResourceManager;
    private var currentIndex:int;
    private var currentValue:Object;

    public function ListCollectionViewCursor(_arg1:ListCollectionView){
        var view:* = _arg1;
        resourceManager = ResourceManager.getInstance();
        super();
        _view = view;
        _view.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionEventHandler, false, 0, true);
        currentIndex = (((view.length > 0)) ? 0 : AFTER_LAST_INDEX);
        if (currentIndex == 0){
            try {
                setCurrent(view.getItemAt(0), false);
            } catch(e:ItemPendingError) {
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null, false);
            };
        };
    }
    public function findAny(_arg1:Object):Boolean{
        var index:* = 0;
        var values:* = _arg1;
        checkValid();
        var lcView:* = ListCollectionView(view);
        try {
            index = lcView.findItem(values, Sort.ANY_INDEX_MODE);
        } catch(e:SortError) {
            throw (new CursorError(e.message));
        };
        if (index > -1){
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        };
        return ((index > -1));
    }
    public function remove():Object{
        var oldIndex:* = 0;
        var message:* = null;
        if (((beforeFirst) || (afterLast))){
            message = resourceManager.getString("collections", "invalidRemove");
            throw (new CursorError(message));
        };
        oldIndex = currentIndex;
        currentIndex++;
        if (currentIndex >= view.length){
            currentIndex = AFTER_LAST_INDEX;
            setCurrent(null);
        } else {
            try {
                setCurrent(ListCollectionView(view).getItemAt(currentIndex));
            } catch(e:ItemPendingError) {
                setCurrent(null, false);
                ListCollectionView(view).removeItemAt(oldIndex);
                throw (e);
            };
        };
        var removed:* = ListCollectionView(view).removeItemAt(oldIndex);
        return (removed);
    }
    private function setCurrent(_arg1:Object, _arg2:Boolean=true):void{
        currentValue = _arg1;
        if (_arg2){
            dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
        };
    }
    public function seek(_arg1:CursorBookmark, _arg2:int=0, _arg3:int=0):void{
        var message:* = null;
        var bookmark:* = _arg1;
        var offset:int = _arg2;
        var prefetch:int = _arg3;
        checkValid();
        if (view.length == 0){
            currentIndex = AFTER_LAST_INDEX;
            setCurrent(null, false);
            return;
        };
        var newIndex:* = currentIndex;
        if (bookmark == CursorBookmark.FIRST){
            newIndex = 0;
        } else {
            if (bookmark == CursorBookmark.LAST){
                newIndex = (view.length - 1);
            } else {
                if (bookmark != CursorBookmark.CURRENT){
                    try {
                        newIndex = ListCollectionView(view).getBookmarkIndex(bookmark);
                        if (newIndex < 0){
                            setCurrent(null);
                            message = resourceManager.getString("collections", "bookmarkInvalid");
                            throw (new CursorError(message));
                        };
                    } catch(bmError:CollectionViewError) {
                        message = resourceManager.getString("collections", "bookmarkInvalid");
                        throw (new CursorError(message));
                    };
                };
            };
        };
        newIndex = (newIndex + offset);
        var newCurrent:* = null;
        if (newIndex >= view.length){
            currentIndex = AFTER_LAST_INDEX;
        } else {
            if (newIndex < 0){
                currentIndex = BEFORE_FIRST_INDEX;
            } else {
                newCurrent = ListCollectionView(view).getItemAt(newIndex, prefetch);
                currentIndex = newIndex;
            };
        };
        setCurrent(newCurrent);
    }
    public function insert(_arg1:Object):void{
        var _local2:int;
        var _local3:String;
        if (afterLast){
            _local2 = view.length;
        } else {
            if (beforeFirst){
                if (view.length > 0){
                    _local3 = resourceManager.getString("collections", "invalidInsert");
                    throw (new CursorError(_local3));
                };
                _local2 = 0;
            } else {
                _local2 = currentIndex;
            };
        };
        ListCollectionView(view).addItemAt(_arg1, _local2);
    }
    public function get afterLast():Boolean{
        checkValid();
        return ((((currentIndex == AFTER_LAST_INDEX)) || ((view.length == 0))));
    }
    private function checkValid():void{
        var _local1:String;
        if (invalid){
            _local1 = resourceManager.getString("collections", "invalidCursor");
            throw (new CursorError(_local1));
        };
    }
    private function collectionEventHandler(_arg1:CollectionEvent):void{
        var event:* = _arg1;
        switch (event.kind){
            case CollectionEventKind.ADD:
                if (event.location <= currentIndex){
                    currentIndex = (currentIndex + event.items.length);
                };
                break;
            case CollectionEventKind.REMOVE:
                if (event.location < currentIndex){
                    currentIndex = (currentIndex - event.items.length);
                } else {
                    if (event.location == currentIndex){
                        if (currentIndex < view.length){
                            try {
                                setCurrent(ListCollectionView(view).getItemAt(currentIndex));
                            } catch(error:ItemPendingError) {
                                setCurrent(null, false);
                            };
                        } else {
                            currentIndex = AFTER_LAST_INDEX;
                            setCurrent(null);
                        };
                    };
                };
                break;
            case CollectionEventKind.MOVE:
                if (event.oldLocation == currentIndex){
                    currentIndex = event.location;
                } else {
                    if (event.oldLocation < currentIndex){
                        currentIndex = (currentIndex - event.items.length);
                    };
                    if (event.location <= currentIndex){
                        currentIndex = (currentIndex + event.items.length);
                    };
                };
                break;
            case CollectionEventKind.REFRESH:
                if (!((beforeFirst) || (afterLast))){
                    currentIndex = ListCollectionView(view).getItemIndex(currentValue);
                    if (currentIndex == -1){
                        setCurrent(null);
                    };
                };
                break;
            case CollectionEventKind.REPLACE:
                if (event.location == currentIndex){
                    try {
                        setCurrent(ListCollectionView(view).getItemAt(currentIndex));
                    } catch(error:ItemPendingError) {
                        setCurrent(null, false);
                    };
                };
                break;
            case CollectionEventKind.RESET:
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null);
                break;
        };
    }
    public function moveNext():Boolean{
        if (afterLast){
            return (false);
        };
        var _local1:int = ((beforeFirst) ? 0 : (currentIndex + 1));
        if (_local1 >= view.length){
            _local1 = AFTER_LAST_INDEX;
            setCurrent(null);
        } else {
            setCurrent(ListCollectionView(view).getItemAt(_local1));
        };
        currentIndex = _local1;
        return (!(afterLast));
    }
    public function get view():ICollectionView{
        checkValid();
        return (_view);
    }
    public function movePrevious():Boolean{
        if (beforeFirst){
            return (false);
        };
        var _local1:int = ((afterLast) ? (view.length - 1) : (currentIndex - 1));
        if (_local1 == -1){
            _local1 = BEFORE_FIRST_INDEX;
            setCurrent(null);
        } else {
            setCurrent(ListCollectionView(view).getItemAt(_local1));
        };
        currentIndex = _local1;
        return (!(beforeFirst));
    }
    public function findLast(_arg1:Object):Boolean{
        var index:* = 0;
        var values:* = _arg1;
        checkValid();
        var lcView:* = ListCollectionView(view);
        try {
            index = lcView.findItem(values, Sort.LAST_INDEX_MODE);
        } catch(sortError:SortError) {
            throw (new CursorError(sortError.message));
        };
        if (index > -1){
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        };
        return ((index > -1));
    }
    public function get beforeFirst():Boolean{
        checkValid();
        return ((((currentIndex == BEFORE_FIRST_INDEX)) || ((view.length == 0))));
    }
    public function get bookmark():CursorBookmark{
        checkValid();
        if ((((view.length == 0)) || (beforeFirst))){
            return (CursorBookmark.FIRST);
        };
        if (afterLast){
            return (CursorBookmark.LAST);
        };
        return (ListCollectionView(view).getBookmark(currentIndex));
    }
    public function findFirst(_arg1:Object):Boolean{
        var index:* = 0;
        var values:* = _arg1;
        checkValid();
        var lcView:* = ListCollectionView(view);
        try {
            index = lcView.findItem(values, Sort.FIRST_INDEX_MODE);
        } catch(sortError:SortError) {
            throw (new CursorError(sortError.message));
        };
        if (index > -1){
            currentIndex = index;
            setCurrent(lcView.getItemAt(currentIndex));
        };
        return ((index > -1));
    }
    public function get current():Object{
        checkValid();
        return (currentValue);
    }

}
