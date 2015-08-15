package mx.utils {
    import mx.collections.*;
    import flash.utils.*;
    import flash.xml.*;

    public class ObjectUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var defaultToStringExcludes:Array = ["password", "credentials"];
        private static var CLASS_INFO_CACHE:Object = {};
        private static var refCount:int = 0;

        public static function isSimple(_arg1:Object):Boolean{
            var _local2 = typeof(_arg1);
            switch (_local2){
                case "number":
                case "string":
                case "boolean":
                    return (true);
                case "object":
                    return ((((_arg1 is Date)) || ((_arg1 is Array))));
            };
            return (false);
        }
        private static function internalToString(_arg1:Object, _arg2:int=0, _arg3:Dictionary=null, _arg4:Array=null, _arg5:Array=null):String{
            var str:* = null;
            var classInfo:* = null;
            var properties:* = null;
            var id:* = null;
            var isArray:* = false;
            var isDict:* = false;
            var prop:* = undefined;
            var j:* = 0;
            var value:* = _arg1;
            var indent:int = _arg2;
            var refs = _arg3;
            var namespaceURIs = _arg4;
            var exclude = _arg5;
            var type:* = (((value == null)) ? "null" : typeof(value));
            switch (type){
                case "boolean":
                case "number":
                    return (value.toString());
                case "string":
                    return ((("\"" + value.toString()) + "\""));
                case "object":
                    if ((value is Date)){
                        return (value.toString());
                    };
                    if ((value is XMLNode)){
                        return (value.toString());
                    };
                    if ((value is Class)){
                        return ((("(" + getQualifiedClassName(value)) + ")"));
                    };
                    classInfo = getClassInfo(value, exclude, {
                        includeReadOnly:true,
                        uris:namespaceURIs
                    });
                    properties = classInfo.properties;
                    str = (("(" + classInfo.name) + ")");
                    if (refs == null){
                        refs = new Dictionary(true);
                    };
                    id = refs[value];
                    if (id != null){
                        str = (str + ("#" + int(id)));
                        return (str);
                    };
                    if (value != null){
                        str = (str + ("#" + refCount.toString()));
                        refs[value] = refCount;
                        refCount++;
                    };
                    isArray = (value is Array);
                    isDict = (value is Dictionary);
                    indent = (indent + 2);
                    j = 0;
                    while (j < properties.length) {
                        str = newline(str, indent);
                        prop = properties[j];
                        if (isArray){
                            str = (str + "[");
                        } else {
                            if (isDict){
                                str = (str + "{");
                            };
                        };
                        if (isDict){
                            str = (str + internalToString(prop, indent, refs, namespaceURIs, exclude));
                        } else {
                            str = (str + prop.toString());
                        };
                        if (isArray){
                            str = (str + "] ");
                        } else {
                            if (isDict){
                                str = (str + "} = ");
                            } else {
                                str = (str + " = ");
                            };
                        };
                        try {
                            str = (str + internalToString(value[prop], indent, refs, namespaceURIs, exclude));
                        } catch(e:Error) {
                            str = (str + "?");
                        };
                        j = (j + 1);
                    };
                    indent = (indent - 2);
                    return (str);
                case "xml":
                    return (value.toString());
                default:
                    return ((("(" + type) + ")"));
            };
        }
        public static function getClassInfo(_arg1:Object, _arg2:Array=null, _arg3:Object=null):Object{
            var n:* = 0;
            var i:* = 0;
            var result:* = null;
            var cacheKey:* = null;
            var className:* = null;
            var classAlias:* = null;
            var properties:* = null;
            var prop:* = null;
            var metadataInfo:* = null;
            var classInfo:* = null;
            var numericIndex:* = false;
            var key:* = undefined;
            var p:* = null;
            var pi:* = NaN;
            var uris:* = null;
            var uri:* = null;
            var qName:* = null;
            var j:* = 0;
            var obj:* = _arg1;
            var excludes = _arg2;
            var options = _arg3;
            if ((obj is ObjectProxy)){
                obj = ObjectProxy(obj).object_proxy::object;
            };
            if (options == null){
                options = {
                    includeReadOnly:true,
                    uris:null,
                    includeTransient:true
                };
            };
            var propertyNames:* = [];
            var dynamic:* = false;
            if (typeof(obj) == "xml"){
                className = "XML";
                properties = obj.text();
                if (properties.length()){
                    propertyNames.push("*");
                };
                properties = obj.attributes();
            } else {
                classInfo = DescribeTypeCache.describeType(obj).typeDescription;
                className = classInfo.@name.toString();
                classAlias = classInfo.@alias.toString();
                dynamic = (classInfo.@isDynamic.toString() == "true");
                if (options.includeReadOnly){
                    properties = (classInfo..accessor.(@access != "writeonly") + classInfo..variable);
                } else {
                    properties = (classInfo..accessor.(@access == "readwrite") + classInfo..variable);
                };
                numericIndex = false;
            };
            if (!dynamic){
                cacheKey = getCacheKey(obj, excludes, options);
                result = CLASS_INFO_CACHE[cacheKey];
                if (result != null){
                    return (result);
                };
            };
            result = {};
            result["name"] = className;
            result["alias"] = classAlias;
            result["properties"] = propertyNames;
            result["dynamic"] = dynamic;
            var _local5 = recordMetadata(properties);
            metadataInfo = _local5;
            result["metadata"] = _local5;
            var excludeObject:* = {};
            if (excludes){
                n = excludes.length;
                i = 0;
                while (i < n) {
                    excludeObject[excludes[i]] = 1;
                    i = (i + 1);
                };
            };
            var isArray:* = (className == "Array");
            var isDict:* = (className == "flash.utils::Dictionary");
            if (isDict){
                for (key in obj) {
                    propertyNames.push(key);
                };
            } else {
                if (dynamic){
                    for (p in obj) {
                        if (excludeObject[p] != 1){
                            if (isArray){
                                pi = parseInt(p);
                                if (isNaN(pi)){
                                    propertyNames.push(new QName("", p));
                                } else {
                                    propertyNames.push(pi);
                                };
                            } else {
                                propertyNames.push(new QName("", p));
                            };
                        };
                    };
                    numericIndex = ((isArray) && (!(isNaN(Number(p)))));
                };
            };
            if (((((isArray) || (isDict))) || ((className == "Object")))){
            } else {
                if (className == "XML"){
                    n = properties.length();
                    i = 0;
                    while (i < n) {
                        p = properties[i].name();
                        if (excludeObject[p] != 1){
                            propertyNames.push(new QName("", ("@" + p)));
                        };
                        i = (i + 1);
                    };
                } else {
                    n = properties.length();
                    uris = options.uris;
                    i = 0;
                    while (i < n) {
                        prop = properties[i];
                        p = prop.@name.toString();
                        uri = prop.@uri.toString();
                        if (excludeObject[p] == 1){
                        } else {
                            if (((!(options.includeTransient)) && (internalHasMetadata(metadataInfo, p, "Transient")))){
                            } else {
                                if (uris != null){
                                    if ((((uris.length == 1)) && ((uris[0] == "*")))){
                                        qName = new QName(uri, p);
                                        try {
                                            obj[qName];
                                            propertyNames.push();
                                        } catch(e:Error) {
                                        };
                                    } else {
                                        j = 0;
                                        while (j < uris.length) {
                                            uri = uris[j];
                                            if (prop.@uri.toString() == uri){
                                                qName = new QName(uri, p);
                                                try {
                                                    obj[qName];
                                                    propertyNames.push(qName);
                                                } catch(e:Error) {
                                                };
                                            };
                                            j = (j + 1);
                                        };
                                    };
                                } else {
                                    if (uri.length == 0){
                                        qName = new QName(uri, p);
                                        try {
                                            obj[qName];
                                            propertyNames.push(qName);
                                        } catch(e:Error) {
                                        };
                                    };
                                };
                            };
                        };
                        i = (i + 1);
                    };
                };
            };
            propertyNames.sort((Array.CASEINSENSITIVE | ((numericIndex) ? Array.NUMERIC : 0)));
            if (!isDict){
                i = 0;
                while (i < (propertyNames.length - 1)) {
                    if (propertyNames[i].toString() == propertyNames[(i + 1)].toString()){
                        propertyNames.splice(i, 1);
                        i = (i - 1);
                    };
                    i = (i + 1);
                };
            };
            if (!dynamic){
                cacheKey = getCacheKey(obj, excludes, options);
                CLASS_INFO_CACHE[cacheKey] = result;
            };
            return (result);
        }
        private static function arrayCompare(_arg1:Array, _arg2:Array, _arg3:int, _arg4:int, _arg5:Dictionary):int{
            var _local7:Object;
            var _local6:int;
            if (_arg1.length != _arg2.length){
                if (_arg1.length < _arg2.length){
                    _local6 = -1;
                } else {
                    _local6 = 1;
                };
            } else {
                for (_local7 in _arg1) {
                    if (_arg2.hasOwnProperty(_local7)){
                        _local6 = internalCompare(_arg1[_local7], _arg2[_local7], _arg3, _arg4, _arg5);
                        if (_local6 != 0){
                            return (_local6);
                        };
                    } else {
                        return (-1);
                    };
                };
                for (_local7 in _arg2) {
                    if (!_arg1.hasOwnProperty(_local7)){
                        return (1);
                    };
                };
            };
            return (_local6);
        }
        public static function stringCompare(_arg1:String, _arg2:String, _arg3:Boolean=false):int{
            if ((((_arg1 == null)) && ((_arg2 == null)))){
                return (0);
            };
            if (_arg1 == null){
                return (1);
            };
            if (_arg2 == null){
                return (-1);
            };
            if (_arg3){
                _arg1 = _arg1.toLocaleLowerCase();
                _arg2 = _arg2.toLocaleLowerCase();
            };
            var _local4:int = _arg1.localeCompare(_arg2);
            if (_local4 < -1){
                _local4 = -1;
            } else {
                if (_local4 > 1){
                    _local4 = 1;
                };
            };
            return (_local4);
        }
        public static function dateCompare(_arg1:Date, _arg2:Date):int{
            if ((((_arg1 == null)) && ((_arg2 == null)))){
                return (0);
            };
            if (_arg1 == null){
                return (1);
            };
            if (_arg2 == null){
                return (-1);
            };
            var _local3:Number = _arg1.getTime();
            var _local4:Number = _arg2.getTime();
            if (_local3 < _local4){
                return (-1);
            };
            if (_local3 > _local4){
                return (1);
            };
            return (0);
        }
        public static function numericCompare(_arg1:Number, _arg2:Number):int{
            if (((isNaN(_arg1)) && (isNaN(_arg2)))){
                return (0);
            };
            if (isNaN(_arg1)){
                return (1);
            };
            if (isNaN(_arg2)){
                return (-1);
            };
            if (_arg1 < _arg2){
                return (-1);
            };
            if (_arg1 > _arg2){
                return (1);
            };
            return (0);
        }
        private static function newline(_arg1:String, _arg2:int=0):String{
            var _local3:String = _arg1;
            _local3 = (_local3 + "\n");
            var _local4:int;
            while (_local4 < _arg2) {
                _local3 = (_local3 + " ");
                _local4++;
            };
            return (_local3);
        }
        private static function recordMetadata(_arg1:XMLList):Object{
            var prop:* = null;
            var propName:* = null;
            var metadataList:* = null;
            var metadata:* = null;
            var md:* = null;
            var mdName:* = null;
            var argsList:* = null;
            var value:* = null;
            var arg:* = null;
            var existing:* = null;
            var argKey:* = null;
            var argValue:* = null;
            var existingArray:* = null;
            var properties:* = _arg1;
            var result:* = null;
            try {
                for each (prop in properties) {
                    propName = prop.attribute("name").toString();
                    metadataList = prop.metadata;
                    if (metadataList.length() > 0){
                        if (result == null){
                            result = {};
                        };
                        metadata = {};
                        result[propName] = metadata;
                        for each (md in metadataList) {
                            mdName = md.attribute("name").toString();
                            argsList = md.arg;
                            value = {};
                            for each (arg in argsList) {
                                argKey = arg.attribute("key").toString();
                                if (argKey != null){
                                    argValue = arg.attribute("value").toString();
                                    value[argKey] = argValue;
                                };
                            };
                            existing = metadata[mdName];
                            if (existing != null){
                                if ((existing is Array)){
                                    existingArray = (existing as Array);
                                } else {
                                    existingArray = [];
                                };
                                existingArray.push(value);
                                existing = existingArray;
                            } else {
                                existing = value;
                            };
                            metadata[mdName] = existing;
                        };
                    };
                };
            } catch(e:Error) {
            };
            return (result);
        }
        public static function compare(_arg1:Object, _arg2:Object, _arg3:int=-1):int{
            return (internalCompare(_arg1, _arg2, 0, _arg3, new Dictionary(true)));
        }
        private static function listCompare(_arg1:IList, _arg2:IList, _arg3:int, _arg4:int, _arg5:Dictionary):int{
            var _local7:int;
            var _local6:int;
            if (_arg1.length != _arg2.length){
                if (_arg1.length < _arg2.length){
                    _local6 = -1;
                } else {
                    _local6 = 1;
                };
            } else {
                _local7 = 0;
                while (_local7 < _arg1.length) {
                    _local6 = internalCompare(_arg1.getItemAt(_local7), _arg2.getItemAt(_local7), (_arg3 + 1), _arg4, _arg5);
                    if (_local6 != 0){
                        _local7 = _arg1.length;
                    };
                    _local7++;
                };
            };
            return (_local6);
        }
        private static function internalCompare(_arg1:Object, _arg2:Object, _arg3:int, _arg4:int, _arg5:Dictionary):int{
            var _local9:int;
            var _local10:Boolean;
            var _local11:Boolean;
            var _local12:Array;
            var _local13:Array;
            var _local14:QName;
            var _local15:Object;
            var _local16:Object;
            var _local17:int;
            if ((((_arg1 == null)) && ((_arg2 == null)))){
                return (0);
            };
            if (_arg1 == null){
                return (1);
            };
            if (_arg2 == null){
                return (-1);
            };
            if ((_arg1 is ObjectProxy)){
                _arg1 = ObjectProxy(_arg1).object_proxy::object;
            };
            if ((_arg2 is ObjectProxy)){
                _arg2 = ObjectProxy(_arg2).object_proxy::object;
            };
            var _local6 = typeof(_arg1);
            var _local7 = typeof(_arg2);
            var _local8:int;
            if (_local6 == _local7){
                switch (_local6){
                    case "boolean":
                        _local8 = numericCompare(Number(_arg1), Number(_arg2));
                        break;
                    case "number":
                        _local8 = numericCompare((_arg1 as Number), (_arg2 as Number));
                        break;
                    case "string":
                        _local8 = stringCompare((_arg1 as String), (_arg2 as String));
                        break;
                    case "object":
                        _local9 = (((_arg4 > 0)) ? (_arg4 - 1) : _arg4);
                        _local10 = _arg5[_arg1];
                        _local11 = _arg5[_arg2];
                        if (((_local10) && (!(_local11)))){
                            return (1);
                        };
                        if (((_local11) && (!(_local10)))){
                            return (-1);
                        };
                        if (((_local11) && (_local10))){
                            return (0);
                        };
                        _arg5[_arg1] = true;
                        _arg5[_arg2] = true;
                        if (((!((_arg4 == -1))) && ((_arg3 > _arg4)))){
                            _local8 = stringCompare(_arg1.toString(), _arg2.toString());
                        } else {
                            if ((((_arg1 is Array)) && ((_arg2 is Array)))){
                                _local8 = arrayCompare((_arg1 as Array), (_arg2 as Array), _arg3, _arg4, _arg5);
                            } else {
                                if ((((_arg1 is Date)) && ((_arg2 is Date)))){
                                    _local8 = dateCompare((_arg1 as Date), (_arg2 as Date));
                                } else {
                                    if ((((_arg1 is IList)) && ((_arg2 is IList)))){
                                        _local8 = listCompare((_arg1 as IList), (_arg2 as IList), _arg3, _arg4, _arg5);
                                    } else {
                                        if ((((_arg1 is ByteArray)) && ((_arg2 is ByteArray)))){
                                            _local8 = byteArrayCompare((_arg1 as ByteArray), (_arg2 as ByteArray));
                                        } else {
                                            if (getQualifiedClassName(_arg1) == getQualifiedClassName(_arg2)){
                                                _local12 = getClassInfo(_arg1).properties;
                                                if (getQualifiedClassName(_arg1) == "Object"){
                                                    _local13 = getClassInfo(_arg2).properties;
                                                    _local8 = arrayCompare(_local12, _local13, _arg3, _local9, _arg5);
                                                };
                                                if (_local8 != 0){
                                                    return (_local8);
                                                };
                                                _local17 = 0;
                                                while (_local17 < _local12.length) {
                                                    _local14 = _local12[_local17];
                                                    _local15 = _arg1[_local14];
                                                    _local16 = _arg2[_local14];
                                                    _local8 = internalCompare(_local15, _local16, (_arg3 + 1), _local9, _arg5);
                                                    if (_local8 != 0){
                                                        _local17 = _local12.length;
                                                    };
                                                    _local17++;
                                                };
                                            } else {
                                                return (1);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                        break;
                };
            } else {
                return (stringCompare(_local6, _local7));
            };
            return (_local8);
        }
        public static function hasMetadata(_arg1:Object, _arg2:String, _arg3:String, _arg4:Array=null, _arg5:Object=null):Boolean{
            var _local6:Object = getClassInfo(_arg1, _arg4, _arg5);
            var _local7:Object = _local6["metadata"];
            return (internalHasMetadata(_local7, _arg2, _arg3));
        }
        private static function internalHasMetadata(_arg1:Object, _arg2:String, _arg3:String):Boolean{
            var _local4:Object;
            if (_arg1 != null){
                _local4 = _arg1[_arg2];
                if (_local4 != null){
                    if (_local4[_arg3] != null){
                        return (true);
                    };
                };
            };
            return (false);
        }
        public static function toString(_arg1:Object, _arg2:Array=null, _arg3:Array=null):String{
            if (_arg3 == null){
                _arg3 = defaultToStringExcludes;
            };
            refCount = 0;
            return (internalToString(_arg1, 0, null, _arg2, _arg3));
        }
        private static function byteArrayCompare(_arg1:ByteArray, _arg2:ByteArray):int{
            var _local4:int;
            var _local3:int;
            if (_arg1.length != _arg2.length){
                if (_arg1.length < _arg2.length){
                    _local3 = -1;
                } else {
                    _local3 = 1;
                };
            } else {
                _arg1.position = 0;
                _arg2.position = 0;
                _local4 = 0;
                while (_local4 < _arg1.length) {
                    _local3 = numericCompare(_arg1.readByte(), _arg2.readByte());
                    if (_local3 != 0){
                        _local4 = _arg1.length;
                    };
                    _local4++;
                };
            };
            return (_local3);
        }
        public static function copy(_arg1:Object):Object{
            var _local2:ByteArray = new ByteArray();
            _local2.writeObject(_arg1);
            _local2.position = 0;
            var _local3:Object = _local2.readObject();
            return (_local3);
        }
        private static function getCacheKey(_arg1:Object, _arg2:Array=null, _arg3:Object=null):String{
            var _local5:uint;
            var _local6:String;
            var _local7:String;
            var _local8:String;
            var _local4:String = getQualifiedClassName(_arg1);
            if (_arg2 != null){
                _local5 = 0;
                while (_local5 < _arg2.length) {
                    _local6 = (_arg2[_local5] as String);
                    if (_local6 != null){
                        _local4 = (_local4 + _local6);
                    };
                    _local5++;
                };
            };
            if (_arg3 != null){
                for (_local7 in _arg3) {
                    _local4 = (_local4 + _local7);
                    _local8 = (_arg3[_local7] as String);
                    if (_local8 != null){
                        _local4 = (_local4 + _local8);
                    };
                };
            };
            return (_local4);
        }

    }
}//package mx.utils 
