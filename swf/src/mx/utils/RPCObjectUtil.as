package mx.utils {
    import flash.utils.*;
    import flash.xml.*;

    public class RPCObjectUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var defaultToStringExcludes:Array = ["password", "credentials"];
        private static var CLASS_INFO_CACHE:Object = {};
        private static var refCount:int = 0;

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
        public static function toString(_arg1:Object, _arg2:Array=null, _arg3:Array=null):String{
            if (_arg3 == null){
                _arg3 = defaultToStringExcludes;
            };
            refCount = 0;
            return (internalToString(_arg1, 0, null, _arg2, _arg3));
        }
        private static function internalToString(_arg1:Object, _arg2:int=0, _arg3:Dictionary=null, _arg4:Array=null, _arg5:Array=null):String{
            var str:* = null;
            var classInfo:* = null;
            var properties:* = null;
            var id:* = null;
            var isArray:* = false;
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
                    indent = (indent + 2);
                    j = 0;
                    while (j < properties.length) {
                        str = newline(str, indent);
                        prop = properties[j];
                        if (isArray){
                            str = (str + "[");
                        };
                        str = (str + prop.toString());
                        if (isArray){
                            str = (str + "] ");
                        } else {
                            str = (str + " = ");
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
            var p:* = null;
            var pi:* = NaN;
            var uris:* = null;
            var uri:* = null;
            var qName:* = null;
            var j:* = 0;
            var obj:* = _arg1;
            var excludes = _arg2;
            var options = _arg3;
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
                classInfo = describeType(obj);
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
            if ((((className == "Object")) || (isArray))){
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
            i = 0;
            while (i < (propertyNames.length - 1)) {
                if (propertyNames[i].toString() == propertyNames[(i + 1)].toString()){
                    propertyNames.splice(i, 1);
                    i = (i - 1);
                };
                i = (i + 1);
            };
            if (!dynamic){
                cacheKey = getCacheKey(obj, excludes, options);
                CLASS_INFO_CACHE[cacheKey] = result;
            };
            return (result);
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

    }
}//package mx.utils 
