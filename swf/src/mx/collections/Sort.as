package mx.collections {
    import flash.events.*;
    import mx.resources.*;
    import mx.utils.*;
    import mx.collections.errors.*;

    public class Sort extends EventDispatcher {

        public static const ANY_INDEX_MODE:String = "any";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const LAST_INDEX_MODE:String = "last";
        public static const FIRST_INDEX_MODE:String = "first";

        private var noFieldsDescending:Boolean = false;
        private var usingCustomCompareFunction:Boolean;
        private var defaultEmptyField:SortField;
        private var _fields:Array;
        private var _compareFunction:Function;
        private var _unique:Boolean;
        private var fieldList:Array;
        private var resourceManager:IResourceManager;

        public function Sort(){
            resourceManager = ResourceManager.getInstance();
            fieldList = [];
            super();
        }
        public function get unique():Boolean{
            return (_unique);
        }
        public function get compareFunction():Function{
            return (((usingCustomCompareFunction) ? _compareFunction : internalCompare));
        }
        public function set unique(_arg1:Boolean):void{
            _unique = _arg1;
        }
        public function sort(_arg1:Array):void{
            const fixedCompareFunction:* = null;
            var message:* = null;
            var uniqueRet1:* = null;
            var fields:* = null;
            var i:* = 0;
            var sortArgs:* = null;
            var uniqueRet2:* = null;
            var items:* = _arg1;
            if (((!(items)) || ((items.length <= 1)))){
                return;
            };
            if (usingCustomCompareFunction){
                fixedCompareFunction = function (_arg1:Object, _arg2:Object):int{
                    return (compareFunction(_arg1, _arg2, _fields));
                };
                if (unique){
                    uniqueRet1 = items.sort(fixedCompareFunction, Array.UNIQUESORT);
                    if (uniqueRet1 == 0){
                        message = resourceManager.getString("collections", "nonUnique");
                        throw (new SortError(message));
                    };
                } else {
                    items.sort(fixedCompareFunction);
                };
            } else {
                fields = this.fields;
                if (((fields) && ((fields.length > 0)))){
                    sortArgs = initSortFields(items[0], true);
                    if (unique){
                        if (((sortArgs) && ((fields.length == 1)))){
                            uniqueRet2 = items.sortOn(sortArgs.fields[0], (sortArgs.options[0] | Array.UNIQUESORT));
                        } else {
                            uniqueRet2 = items.sort(internalCompare, Array.UNIQUESORT);
                        };
                        if (uniqueRet2 == 0){
                            message = resourceManager.getString("collections", "nonUnique");
                            throw (new SortError(message));
                        };
                    } else {
                        if (sortArgs){
                            items.sortOn(sortArgs.fields, sortArgs.options);
                        } else {
                            items.sort(internalCompare);
                        };
                    };
                } else {
                    items.sort(internalCompare);
                };
            };
        }
        public function propertyAffectsSort(_arg1:String):Boolean{
            var _local3:SortField;
            if (((usingCustomCompareFunction) || (!(fields)))){
                return (true);
            };
            var _local2:int;
            while (_local2 < fields.length) {
                _local3 = fields[_local2];
                if ((((_local3.name == _arg1)) || (_local3.usingCustomCompareFunction))){
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        private function internalCompare(_arg1:Object, _arg2:Object, _arg3:Array=null):int{
            var _local5:int;
            var _local6:int;
            var _local7:SortField;
            var _local4:int;
            if (!_fields){
                _local4 = noFieldsCompare(_arg1, _arg2);
            } else {
                _local5 = 0;
                _local6 = ((_arg3) ? _arg3.length : _fields.length);
                while ((((_local4 == 0)) && ((_local5 < _local6)))) {
                    _local7 = SortField(_fields[_local5]);
                    _local4 = _local7.internalCompare(_arg1, _arg2);
                    _local5++;
                };
            };
            return (_local4);
        }
        public function reverse():void{
            var _local1:int;
            if (fields){
                _local1 = 0;
                while (_local1 < fields.length) {
                    SortField(fields[_local1]).reverse();
                    _local1++;
                };
            };
            noFieldsDescending = !(noFieldsDescending);
        }
        private function noFieldsCompare(_arg1:Object, _arg2:Object, _arg3:Array=null):int{
            var message:* = null;
            var a:* = _arg1;
            var b:* = _arg2;
            var fields = _arg3;
            if (!defaultEmptyField){
                defaultEmptyField = new SortField();
                try {
                    defaultEmptyField.initCompare(a);
                } catch(e:SortError) {
                    message = resourceManager.getString("collections", "noComparator", [a]);
                    throw (new SortError(message));
                };
            };
            var result:* = defaultEmptyField.compareFunction(a, b);
            if (noFieldsDescending){
                result = (result * -1);
            };
            return (result);
        }
        public function findItem(_arg1:Array, _arg2:Object, _arg3:String, _arg4:Boolean=false, _arg5:Function=null):int{
            var compareForFind:* = null;
            var fieldsForCompare:* = null;
            var message:* = null;
            var index:* = 0;
            var fieldName:* = null;
            var hadPreviousFieldName:* = false;
            var i:* = 0;
            var hasFieldName:* = false;
            var objIndex:* = 0;
            var match:* = false;
            var prevCompare:* = 0;
            var nextCompare:* = 0;
            var items:* = _arg1;
            var values:* = _arg2;
            var mode:* = _arg3;
            var returnInsertionIndex:Boolean = _arg4;
            var compareFunction = _arg5;
            if (!items){
                message = resourceManager.getString("collections", "noItems");
                throw (new SortError(message));
            };
            if (items.length == 0){
                return (((returnInsertionIndex) ? 1 : -1));
            };
            if (compareFunction == null){
                compareForFind = this.compareFunction;
                if (((values) && ((fieldList.length > 0)))){
                    fieldsForCompare = [];
                    hadPreviousFieldName = true;
                    i = 0;
                    while (i < fieldList.length) {
                        fieldName = fieldList[i];
                        if (fieldName){
                            try {
                                hasFieldName = !((values[fieldName] === undefined));
                            } catch(e:Error) {
                                hasFieldName = false;
                            };
                            if (hasFieldName){
                                if (!hadPreviousFieldName){
                                    message = resourceManager.getString("collections", "findCondition", [fieldName]);
                                    throw (new SortError(message));
                                };
                                fieldsForCompare.push(fieldName);
                            } else {
                                hadPreviousFieldName = false;
                            };
                        } else {
                            fieldsForCompare.push(null);
                        };
                        i = (i + 1);
                    };
                    if (fieldsForCompare.length == 0){
                        message = resourceManager.getString("collections", "findRestriction");
                        throw (new SortError(message));
                    };
                    try {
                        initSortFields(items[0]);
                    } catch(initSortError:SortError) {
                    };
                };
            } else {
                compareForFind = compareFunction;
            };
            var found:* = false;
            var objFound:* = false;
            index = 0;
            var lowerBound:* = 0;
            var upperBound:* = (items.length - 1);
            var obj:* = null;
            var direction:* = 1;
            while (((!(objFound)) && ((lowerBound <= upperBound)))) {
                index = Math.round(((lowerBound + upperBound) / 2));
                obj = items[index];
                direction = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                switch (direction){
                    case -1:
                        upperBound = (index - 1);
                        break;
                    case 0:
                        objFound = true;
                        switch (mode){
                            case ANY_INDEX_MODE:
                                found = true;
                                break;
                            case FIRST_INDEX_MODE:
                                found = (index == lowerBound);
                                objIndex = (index - 1);
                                match = true;
                                while (((((match) && (!(found)))) && ((objIndex >= lowerBound)))) {
                                    obj = items[objIndex];
                                    prevCompare = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                                    match = (prevCompare == 0);
                                    if (((!(match)) || (((match) && ((objIndex == lowerBound)))))){
                                        found = true;
                                        index = (objIndex + ((match) ? 0 : 1));
                                    };
                                    objIndex = (objIndex - 1);
                                };
                                break;
                            case LAST_INDEX_MODE:
                                found = (index == upperBound);
                                objIndex = (index + 1);
                                match = true;
                                while (((((match) && (!(found)))) && ((objIndex <= upperBound)))) {
                                    obj = items[objIndex];
                                    nextCompare = ((fieldsForCompare) ? compareForFind(values, obj, fieldsForCompare) : compareForFind(values, obj));
                                    match = (nextCompare == 0);
                                    if (((!(match)) || (((match) && ((objIndex == upperBound)))))){
                                        found = true;
                                        index = (objIndex - ((match) ? 0 : 1));
                                    };
                                    objIndex = (objIndex + 1);
                                };
                                break;
                            default:
                                message = resourceManager.getString("collections", "unknownMode");
                                throw (new SortError(message));
                        };
                        break;
                    case 1:
                        lowerBound = (index + 1);
                        break;
                };
            };
            if (((!(found)) && (!(returnInsertionIndex)))){
                return (-1);
            };
            return (((direction)>0) ? (index + 1) : index);
        }
        private function initSortFields(_arg1:Object, _arg2:Boolean=false):Object{
            var _local4:int;
            var _local5:SortField;
            var _local6:int;
            var _local3:Object;
            _local4 = 0;
            while (_local4 < fields.length) {
                SortField(fields[_local4]).initCompare(_arg1);
                _local4++;
            };
            if (_arg2){
                _local3 = {
                    fields:[],
                    options:[]
                };
                _local4 = 0;
                while (_local4 < fields.length) {
                    _local5 = fields[_local4];
                    _local6 = _local5.getArraySortOnOptions();
                    if (_local6 == -1){
                        return (null);
                    };
                    _local3.fields.push(_local5.name);
                    _local3.options.push(_local6);
                    _local4++;
                };
            };
            return (_local3);
        }
        public function set fields(_arg1:Array):void{
            var _local2:SortField;
            var _local3:int;
            _fields = _arg1;
            fieldList = [];
            if (_fields){
                _local3 = 0;
                while (_local3 < _fields.length) {
                    _local2 = SortField(_fields[_local3]);
                    fieldList.push(_local2.name);
                    _local3++;
                };
            };
            dispatchEvent(new Event("fieldsChanged"));
        }
        public function get fields():Array{
            return (_fields);
        }
        public function set compareFunction(_arg1:Function):void{
            _compareFunction = _arg1;
            usingCustomCompareFunction = !((_compareFunction == null));
        }
        override public function toString():String{
            return (ObjectUtil.toString(this));
        }

    }
}//package mx.collections 
