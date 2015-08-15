package mx.utils {
    import flash.display.*;
    import mx.core.*;
    import flash.utils.*;

    public class NameUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var counter:int = 0;

        public static function displayObjectToString(_arg1:DisplayObject):String{
            var result:* = null;
            var o:* = null;
            var s:* = null;
            var indices:* = null;
            var displayObject:* = _arg1;
            try {
                o = displayObject;
                while (o != null) {
                    if (((((o.parent) && (o.stage))) && ((o.parent == o.stage)))){
                        break;
                    };
                    s = o.name;
                    if ((o is IRepeaterClient)){
                        indices = IRepeaterClient(o).instanceIndices;
                        if (indices){
                            s = (s + (("[" + indices.join("][")) + "]"));
                        };
                    };
                    result = (((result == null)) ? s : ((s + ".") + result));
                    o = o.parent;
                };
            } catch(e:SecurityError) {
            };
            return (result);
        }
        public static function createUniqueName(_arg1:Object):String{
            if (!_arg1){
                return (null);
            };
            var _local2:String = getQualifiedClassName(_arg1);
            var _local3:int = _local2.indexOf("::");
            if (_local3 != -1){
                _local2 = _local2.substr((_local3 + 2));
            };
            var _local4:int = _local2.charCodeAt((_local2.length - 1));
            if ((((_local4 >= 48)) && ((_local4 <= 57)))){
                _local2 = (_local2 + "_");
            };
            return ((_local2 + counter++));
        }

    }
}//package mx.utils 
