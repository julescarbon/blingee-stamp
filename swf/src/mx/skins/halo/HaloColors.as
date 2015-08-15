package mx.skins.halo {
    import mx.utils.*;

    public class HaloColors {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var cache:Object = {};

        public static function getCacheKey(... _args):String{
            return (_args.join(","));
        }
        public static function addHaloColors(_arg1:Object, _arg2:uint, _arg3:uint, _arg4:uint):void{
            var _local5:String = getCacheKey(_arg2, _arg3, _arg4);
            var _local6:Object = cache[_local5];
            if (!_local6){
                _local6 = (cache[_local5] = {});
                _local6.themeColLgt = ColorUtil.adjustBrightness(_arg2, 100);
                _local6.themeColDrk1 = ColorUtil.adjustBrightness(_arg2, -75);
                _local6.themeColDrk2 = ColorUtil.adjustBrightness(_arg2, -25);
                _local6.fillColorBright1 = ColorUtil.adjustBrightness2(_arg3, 15);
                _local6.fillColorBright2 = ColorUtil.adjustBrightness2(_arg4, 15);
                _local6.fillColorPress1 = ColorUtil.adjustBrightness2(_arg2, 85);
                _local6.fillColorPress2 = ColorUtil.adjustBrightness2(_arg2, 60);
                _local6.bevelHighlight1 = ColorUtil.adjustBrightness2(_arg3, 40);
                _local6.bevelHighlight2 = ColorUtil.adjustBrightness2(_arg4, 40);
            };
            _arg1.themeColLgt = _local6.themeColLgt;
            _arg1.themeColDrk1 = _local6.themeColDrk1;
            _arg1.themeColDrk2 = _local6.themeColDrk2;
            _arg1.fillColorBright1 = _local6.fillColorBright1;
            _arg1.fillColorBright2 = _local6.fillColorBright2;
            _arg1.fillColorPress1 = _local6.fillColorPress1;
            _arg1.fillColorPress2 = _local6.fillColorPress2;
            _arg1.bevelHighlight1 = _local6.bevelHighlight1;
            _arg1.bevelHighlight2 = _local6.bevelHighlight2;
        }

    }
}//package mx.skins.halo 
