package mx.collections {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import flash.utils.*;
    import mx.collections.errors.*;

    public class ModifiedCollectionView implements ICollectionView {

        public static const REPLACEMENT:String = "replacement";
        public static const REPLACED:String = "replaced";
        public static const REMOVED:String = "removed";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const ADDED:String = "added";

        private var addedItems:Dictionary;
        private var _showPreserved:Boolean = false;
        private var list:ICollectionView;
        private var deltaLength:int = 0;
        private var resourceManager:IResourceManager;
        private var removedItems:Dictionary;
        private var itemWrappersByIndex:Array;
        private var replacementItems:Dictionary;
        private var deltas:Array;
        private var replacedItems:Dictionary;
        private var itemWrappersByCollectionMod:Dictionary;

        public function ModifiedCollectionView(_arg1:ICollectionView){
            resourceManager = ResourceManager.getInstance();
            deltas = [];
            removedItems = new Dictionary(true);
            addedItems = new Dictionary(true);
            replacedItems = new Dictionary(true);
            replacementItems = new Dictionary(true);
            itemWrappersByIndex = [];
            itemWrappersByCollectionMod = new Dictionary(true);
            super();
            this.list = _arg1;
        }
        mx_internal function getBookmarkIndex(_arg1:CursorBookmark):int{
            var _local3:String;
            if (((!((_arg1 is ModifiedCollectionViewBookmark))) || (!((ModifiedCollectionViewBookmark(_arg1).view == this))))){
                _local3 = resourceManager.getString("collections", "bookmarkNotFound");
                throw (new CollectionViewError(_local3));
            };
            var _local2:ModifiedCollectionViewBookmark = ModifiedCollectionViewBookmark(_arg1);
            return (_local2.index);
        }
        public function willTrigger(_arg1:String):Boolean{
            return (false);
        }
        private function removeModification(_arg1:CollectionModification):Boolean{
            var _local2:int;
            while (_local2 < deltas.length) {
                if (deltas[_local2] == _arg1){
                    deltas.splice(_local2, 1);
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        mx_internal function getWrappedItemUsingCursor(_arg1:ModifiedCollectionViewCursor, _arg2:int):Object{
            var _local6:CollectionModification;
            var _local9:Object;
            var _local3:int = _arg2;
            var _local4:Object;
            var _local5:CollectionModification;
            var _local7:Boolean;
            var _local8:int;
            while (_local8 < deltas.length) {
                _local6 = deltas[_local8];
                if (_local3 < _local6.index){
                    break;
                };
                if (_local6.modificationType == CollectionModification.REPLACE){
                    if ((((((_local3 == _local6.index)) && (_local6.showOldReplace))) && (_showPreserved))){
                        _local5 = _local6;
                        break;
                    };
                    if ((((((((_local3 == (_local6.index + 1))) && (_local6.showOldReplace))) && (_local6.showNewReplace))) && (_showPreserved))){
                        _local3--;
                        _local7 = true;
                        break;
                    };
                    if ((((_local3 == _local6.index)) && (((((!(_local6.showOldReplace)) && (_local6.showNewReplace))) || (!(_showPreserved)))))){
                        _local7 = true;
                        break;
                    };
                    _local3 = (_local3 - _local6.modCount);
                } else {
                    if (isActive(_local6)){
                        if ((((_local3 == _local6.index)) && (_local6.isRemove))){
                            _local5 = _local6;
                            break;
                        };
                        if (_local3 >= _local6.index){
                            _local3 = (_local3 - _local6.modCount);
                        };
                    };
                };
                _local8++;
            };
            if (_local5){
                _local4 = _local5.item;
            } else {
                _arg1.internalCursor.seek(CursorBookmark.CURRENT, (_local3 - _arg1.internalIndex));
                _local4 = _arg1.internalCursor.current;
                _arg1.internalIndex = _local3;
            };
            if (((((_local6) && ((_local3 == _local6.index)))) && ((_local6.modificationType == CollectionModification.ADD)))){
                _local9 = getUniqueItemWrapper(_local4, _local6, _local3);
            } else {
                _local9 = getUniqueItemWrapper(_local4, _local5, _local3);
            };
            return (_local9);
        }
        public function contains(_arg1:Object):Boolean{
            return (false);
        }
        private function integrateReplacedElements(_arg1:CollectionEvent, _arg2:int, _arg3:int):void{
            var _local9:Object;
            var _local10:Object;
            var _local11:CollectionModification;
            var _local12:CollectionModification;
            var _local4:int;
            var _local5:int;
            var _local6:Boolean;
            var _local7:int = _arg1.items.length;
            var _local8:int;
            while ((((_local4 < deltas.length)) && ((_local5 < _local7)))) {
                _local9 = PropertyChangeEvent(_arg1.items[_local5]).oldValue;
                _local10 = PropertyChangeEvent(_arg1.items[_local5]).newValue;
                _local11 = CollectionModification(deltas[_local4]);
                _local12 = new CollectionModification((_arg1.location + _local5), _local9, CollectionModification.REPLACE);
                if (((((_local11.isRemove) && ((_local11.index <= _local12.index)))) || (((!(_local11.isRemove)) && ((_local11.index < _local12.index)))))){
                    _local4++;
                } else {
                    if ((((((_local11.modificationType == CollectionModification.ADD)) || ((_local11.modificationType == CollectionModification.REPLACE)))) && ((_local11.index == _local12.index)))){
                        _local4++;
                        _local5++;
                    } else {
                        deltas.splice((_local4 + _local5), 0, _local12);
                        replacedItems[getUniqueItemWrapper(_local9, _local12, (_arg1.location + _local5))] = _local12;
                        replacementItems[getUniqueItemWrapper(_local10, _local12, (_arg1.location + _local5), true)] = _local12;
                        _local5++;
                        _local4++;
                    };
                };
            };
            while (_local5 < _local7) {
                _local9 = PropertyChangeEvent(_arg1.items[_local5]).oldValue;
                _local10 = PropertyChangeEvent(_arg1.items[_local5]).newValue;
                _local12 = new CollectionModification((_arg1.location + _local5), _local9, CollectionModification.REPLACE);
                deltas.push(_local12);
                replacedItems[getUniqueItemWrapper(_local9, _local12, (_arg1.location + _local5))] = _local12;
                replacementItems[getUniqueItemWrapper(_local10, _local12, (_arg1.location + _local5), true)] = _local12;
                _local5++;
            };
        }
        mx_internal function getBookmark(_arg1:ModifiedCollectionViewCursor):ModifiedCollectionViewBookmark{
            var _local4:String;
            var _local2:int = _arg1.currentIndex;
            if ((((_local2 < 0)) || ((_local2 > length)))){
                _local4 = resourceManager.getString("collections", "invalidIndex", [_local2]);
                throw (new CollectionViewError(_local4));
            };
            var _local3:Object = _arg1.current;
            return (new ModifiedCollectionViewBookmark(_local3, this, 0, _local2, _arg1.internalCursor.bookmark, _arg1.internalIndex));
        }
        public function get sort():Sort{
            return (null);
        }
        public function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void{
        }
        public function processCollectionEvent(_arg1:CollectionEvent, _arg2:int, _arg3:int):void{
            switch (_arg1.kind){
                case CollectionEventKind.ADD:
                    integrateAddedElements(_arg1, _arg2, _arg3);
                    break;
                case CollectionEventKind.REMOVE:
                    integrateRemovedElements(_arg1, _arg2, _arg3);
                    break;
                case CollectionEventKind.REPLACE:
                    integrateReplacedElements(_arg1, _arg2, _arg3);
                    break;
            };
        }
        public function get showPreservedState():Boolean{
            return (_showPreserved);
        }
        public function getSemantics(_arg1:ItemWrapper):String{
            if (removedItems[_arg1]){
                return (ModifiedCollectionView.REMOVED);
            };
            if (addedItems[_arg1]){
                return (ModifiedCollectionView.ADDED);
            };
            if (replacedItems[_arg1]){
                return (ModifiedCollectionView.REPLACED);
            };
            if (replacementItems[_arg1]){
                return (ModifiedCollectionView.REPLACEMENT);
            };
            return (null);
        }
        private function getUniqueItemWrapper(_arg1:Object, _arg2:CollectionModification, _arg3:int, _arg4:Boolean=false):Object{
            if (((_arg2) && (((_arg2.isRemove) || ((((_arg2.modificationType == CollectionModification.REPLACE)) && (!(_arg4)))))))){
                if (!itemWrappersByCollectionMod[_arg2]){
                    itemWrappersByCollectionMod[_arg2] = new ItemWrapper(_arg1);
                };
                return (itemWrappersByCollectionMod[_arg2]);
            };
            if (((_arg2) && ((_arg2.modificationType == CollectionModification.ADD)))){
                _arg3 = _arg2.index;
            };
            if (!itemWrappersByIndex[_arg3]){
                itemWrappersByIndex[_arg3] = new ItemWrapper(_arg1);
            };
            return (itemWrappersByIndex[_arg3]);
        }
        public function enableAutoUpdate():void{
        }
        public function set sort(_arg1:Sort):void{
        }
        public function removeItem(_arg1:ItemWrapper):void{
            var _local2:CollectionModification = (removedItems[_arg1] as CollectionModification);
            if (!_local2){
                _local2 = (replacedItems[_arg1] as CollectionModification);
                if (_local2){
                    delete replacedItems[_arg1];
                    _local2.stopShowingReplacedValue();
                    deltaLength--;
                    if (_local2.modCount == 0){
                        removeModification(_local2);
                    };
                };
            } else {
                if (removeModification(_local2)){
                    delete removedItems[_arg1];
                    deltaLength--;
                };
            };
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
        }
        private function integrateRemovedElements(_arg1:CollectionEvent, _arg2:int, _arg3:int):void{
            var _local9:CollectionModification;
            var _local10:CollectionModification;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int = _arg1.items.length;
            var _local8:int;
            while ((((_local4 < deltas.length)) && ((_local5 < _local7)))) {
                _local9 = CollectionModification(deltas[_local4]);
                _local10 = new CollectionModification(_arg1.location, _arg1.items[_local5], CollectionModification.REMOVE);
                removedItems[getUniqueItemWrapper(_arg1.items[_local5], _local10, 0)] = _local10;
                if (_local8 != 0){
                    _local9.index = (_local9.index + _local8);
                };
                if (((((_local9.isRemove) && ((_local9.index <= _local10.index)))) || (((!(_local9.isRemove)) && ((_local9.index < _local10.index)))))){
                    _local4++;
                } else {
                    if (((!(_local9.isRemove)) && ((_local9.index == _local10.index)))){
                        deltas.splice((_local4 + _local5), 1);
                    } else {
                        deltas.splice((_local4 + _local5), 0, _local10);
                        _local4++;
                    };
                    _local8--;
                    _local5++;
                };
            };
            while (_local4 < deltas.length) {
                var _temp1 = _local4;
                _local4 = (_local4 + 1);
                _local9 = CollectionModification(deltas[_temp1]);
                CollectionModification(deltas[_temp1]).index = (_local9.index + _local8);
            };
            while (_local5 < _local7) {
                _local10 = new CollectionModification(_arg1.location, _arg1.items[_local5], CollectionModification.REMOVE);
                deltas.push(_local10);
                removedItems[getUniqueItemWrapper(_arg1.items[_local5], _local10, 0)] = _local10;
                _local5++;
            };
            deltaLength = (deltaLength + (_arg1.items.length - _local6));
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (false);
        }
        private function isActive(_arg1:CollectionModification):Boolean{
            return (_showPreserved);
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
        }
        public function refresh():Boolean{
            return (false);
        }
        public function addItem(_arg1:ItemWrapper):void{
            var _local2:CollectionModification = (addedItems[_arg1] as CollectionModification);
            if (!_local2){
                _local2 = (replacementItems[_arg1] as CollectionModification);
                if (_local2){
                    _local2.startShowingReplacementValue();
                    deltaLength++;
                    if (_local2.modCount == 0){
                        removeModification(_local2);
                    };
                };
            } else {
                if (removeModification(_local2)){
                    deltaLength++;
                };
            };
        }
        public function get length():int{
            return ((list.length + ((_showPreserved) ? deltaLength : 0)));
        }
        public function set filterFunction(_arg1:Function):void{
        }
        public function set showPreservedState(_arg1:Boolean):void{
            _showPreserved = _arg1;
        }
        public function createCursor():IViewCursor{
            var _local1:IViewCursor = list.createCursor();
            var _local2:Object = _local1.current;
            return (new ModifiedCollectionViewCursor(this, _local1, _local2));
        }
        private function integrateAddedElements(_arg1:CollectionEvent, _arg2:int, _arg3:int):void{
            var _local9:CollectionModification;
            var _local10:CollectionModification;
            var _local4:int;
            var _local5:int;
            var _local6:Boolean;
            var _local7:int = _arg1.items.length;
            var _local8:int;
            while ((((_local4 < deltas.length)) && ((_local5 < _local7)))) {
                _local9 = CollectionModification(deltas[_local4]);
                _local10 = new CollectionModification((_arg1.location + _local5), null, CollectionModification.ADD);
                addedItems[getUniqueItemWrapper(_arg1.items[_local5], _local10, 0)] = _local10;
                if (((((_local9.isRemove) && ((_local9.index <= _local10.index)))) || (((!(_local9.isRemove)) && ((_local9.index < _local10.index)))))){
                    _local4++;
                } else {
                    deltas.splice((_local4 + _local5), 0, _local10);
                    _local8++;
                    _local5++;
                    _local4++;
                };
            };
            while (_local4 < deltas.length) {
                var _temp1 = _local4;
                _local4 = (_local4 + 1);
                _local9 = CollectionModification(deltas[_temp1]);
                CollectionModification(deltas[_temp1]).index = (_local9.index + _local8);
            };
            while (_local5 < _local7) {
                _local10 = new CollectionModification((_arg1.location + _local5), null, CollectionModification.ADD);
                deltas.push(_local10);
                addedItems[getUniqueItemWrapper(_arg1.items[_local5], _local10, 0)] = _local10;
                _local5++;
            };
            deltaLength = (deltaLength - _arg1.items.length);
        }
        public function disableAutoUpdate():void{
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (false);
        }
        public function get filterFunction():Function{
            return (null);
        }

    }
}//package mx.collections 

import flash.events.*;
import mx.events.*;
import mx.resources.*;
import mx.collections.errors.*;

class ModifiedCollectionViewBookmark extends CursorBookmark {

    mx_internal var viewRevision:int;
    mx_internal var index:int;
    mx_internal var internalBookmark:CursorBookmark;
    mx_internal var view:ModifiedCollectionView;
    mx_internal var internalIndex:int;

    public function ModifiedCollectionViewBookmark(_arg1:Object, _arg2:ModifiedCollectionView, _arg3:int, _arg4:int, _arg5:CursorBookmark, _arg6:int){
        super(_arg1);
        this.view = _arg2;
        this.viewRevision = _arg3;
        this.index = _arg4;
        this.internalBookmark = _arg5;
        this.internalIndex = _arg6;
    }
    override public function getViewIndex():int{
        return (view.getBookmarkIndex(this));
    }

}
class ModifiedCollectionViewCursor extends EventDispatcher implements IViewCursor {

    private static const BEFORE_FIRST_INDEX:int = -1;
    private static const AFTER_LAST_INDEX:int = -2;

    private var _view:ModifiedCollectionView;
    private var resourceManager:IResourceManager;
    public var internalIndex:int;
    mx_internal var currentIndex:int;
    public var internalCursor:IViewCursor;
    private var invalid:Boolean;
    private var currentValue:Object;

    public function ModifiedCollectionViewCursor(_arg1:ModifiedCollectionView, _arg2:IViewCursor, _arg3:Object){
        var view:* = _arg1;
        var cursor:* = _arg2;
        var current:* = _arg3;
        resourceManager = ResourceManager.getInstance();
        super();
        _view = view;
        internalCursor = cursor;
        if (((cursor.beforeFirst) && (!(current)))){
            internalIndex = BEFORE_FIRST_INDEX;
        } else {
            if (((cursor.afterLast) && (!(current)))){
                internalIndex = AFTER_LAST_INDEX;
            } else {
                internalIndex = 0;
            };
        };
        currentIndex = (((view.length > 0)) ? 0 : AFTER_LAST_INDEX);
        if (currentIndex == 0){
            try {
                setCurrent(current, false);
            } catch(e:ItemPendingError) {
                currentIndex = BEFORE_FIRST_INDEX;
                setCurrent(null, false);
            };
        };
    }
    public function findAny(_arg1:Object):Boolean{
        return (false);
    }
    public function findFirst(_arg1:Object):Boolean{
        return (false);
    }
    public function seek(_arg1:CursorBookmark, _arg2:int=0, _arg3:int=0):void{
        var message:* = null;
        var mcvBookmark:* = null;
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
            internalIndex = 0;
            internalCursor.seek(CursorBookmark.FIRST);
        } else {
            if (bookmark == CursorBookmark.LAST){
                newIndex = (view.length - 1);
                internalCursor.seek(CursorBookmark.LAST);
            } else {
                if (bookmark != CursorBookmark.CURRENT){
                    try {
                        mcvBookmark = (bookmark as ModifiedCollectionViewBookmark);
                        newIndex = ModifiedCollectionView(view).getBookmarkIndex(bookmark);
                        if (((!(mcvBookmark)) || ((newIndex < 0)))){
                            setCurrent(null);
                            message = resourceManager.getString("collections", "bookmarkInvalid");
                            throw (new CursorError(message));
                        };
                        internalIndex = mcvBookmark.internalIndex;
                        internalCursor.seek(mcvBookmark.internalBookmark);
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
                newCurrent = ModifiedCollectionView(view).getWrappedItemUsingCursor(this, newIndex);
                currentIndex = newIndex;
            };
        };
        setCurrent(newCurrent);
    }
    public function insert(_arg1:Object):void{
    }
    public function get afterLast():Boolean{
        checkValid();
        return ((((currentIndex == AFTER_LAST_INDEX)) || ((view.length == 0))));
    }
    public function remove():Object{
        return (null);
    }
    private function checkValid():void{
        var _local1:String;
        if (invalid){
            _local1 = resourceManager.getString("collections", "invalidCursor");
            throw (new CursorError(_local1));
        };
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
            setCurrent(ModifiedCollectionView(view).getWrappedItemUsingCursor(this, _local1));
        };
        currentIndex = _local1;
        return (!(beforeFirst));
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
            setCurrent(ModifiedCollectionView(view).getWrappedItemUsingCursor(this, _local1));
        };
        currentIndex = _local1;
        return (!(afterLast));
    }
    public function findLast(_arg1:Object):Boolean{
        return (false);
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
        return (ModifiedCollectionView(view).getBookmark(this));
    }
    public function get current():Object{
        checkValid();
        return (currentValue);
    }
    private function setCurrent(_arg1:Object, _arg2:Boolean=true):void{
        currentValue = _arg1;
        if (_arg2){
            dispatchEvent(new FlexEvent(FlexEvent.CURSOR_UPDATE));
        };
    }

}
class CollectionModification {

    public static const ADD:String = "add";
    public static const REPLACE:String = "replace";
    public static const REMOVE:String = "remove";

    public var showOldReplace:Boolean = true;
    private var _modCount:int = 0;
    public var showNewReplace:Boolean = false;
    public var index:int;
    public var modificationType:String = null;
    public var item:Object = null;

    public function CollectionModification(_arg1:int, _arg2:Object, _arg3:String){
        this.index = _arg1;
        this.modificationType = _arg3;
        if (_arg3 != CollectionModification.ADD){
            this.item = _arg2;
        };
        if (_arg3 == CollectionModification.REMOVE){
            _modCount = 1;
        } else {
            if (_arg3 == CollectionModification.ADD){
                _modCount = -1;
            };
        };
    }
    public function startShowingReplacementValue():void{
        showNewReplace = true;
        _modCount++;
    }
    public function get modCount():int{
        return (_modCount);
    }
    public function get isRemove():Boolean{
        return ((modificationType == CollectionModification.REMOVE));
    }
    public function stopShowingReplacedValue():void{
        showOldReplace = false;
        _modCount--;
    }

}
