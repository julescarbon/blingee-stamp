package mx.skins.halo {
    import flash.display.*;
    import mx.containers.*;
    import flash.utils.*;
    import mx.skins.*;

    public class LinkSeparator extends ProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var boxes:Object = {};

        private static function isBox(_arg1:Object):Boolean{
            var s:* = null;
            var x:* = null;
            var parent:* = _arg1;
            s = getQualifiedClassName(parent);
            if (boxes[s] == 1){
                return (true);
            };
            if (boxes[s] == 0){
                return (false);
            };
            if (s == "mx.containers::Box"){
                (boxes[s] == 1);
                return (true);
            };
            x = describeType(parent);
            var xmllist:* = x.extendsClass.(@type == "mx.containers::Box");
            if (xmllist.length() == 0){
                boxes[s] = 0;
                return (false);
            };
            boxes[s] = 1;
            return (true);
        }

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:uint = getStyle("separatorColor");
            var _local4:Number = getStyle("separatorWidth");
            var _local5:Boolean;
            var _local6:Graphics = graphics;
            _local6.clear();
            if (_local4 > 0){
                if (isBox(parent)){
                    _local5 = (Object(parent).direction == BoxDirection.VERTICAL);
                };
                _local6.lineStyle(_local4, _local3);
                if (_local5){
                    _local6.moveTo(4, (_arg2 / 2));
                    _local6.lineTo((_arg1 - 4), (_arg2 / 2));
                } else {
                    _local6.moveTo((_arg1 / 2), 6);
                    _local6.lineTo((_arg1 / 2), (_arg2 - 5));
                };
            };
        }

    }
}//package mx.skins.halo 
