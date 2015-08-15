package mx.core {
    import flash.text.*;
    import flash.utils.*;

    public class EmbeddedFontRegistry implements IEmbeddedFontRegistry {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var fonts:Object = {};
        private static var instance:IEmbeddedFontRegistry;

        public static function registerFonts(_arg1:Object, _arg2:IFlexModuleFactory):void{
            var _local4:Object;
            var _local5:Object;
            var _local6:String;
            var _local7:Boolean;
            var _local8:Boolean;
            var _local3:IEmbeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            for (_local4 in _arg1) {
                _local5 = _arg1[_local4];
                for (_local6 in _local5) {
                    if (_local5[_local6] == false){
                    } else {
                        if (_local6 == "regular"){
                            _local7 = false;
                            _local8 = false;
                        } else {
                            if (_local6 == "boldItalic"){
                                _local7 = true;
                                _local8 = true;
                            } else {
                                if (_local6 == "bold"){
                                    _local7 = true;
                                    _local8 = false;
                                } else {
                                    if (_local6 == "italic"){
                                        _local7 = false;
                                        _local8 = true;
                                    };
                                };
                            };
                        };
                        _local3.registerFont(new EmbeddedFont(String(_local4), _local7, _local8), _arg2);
                    };
                };
            };
        }
        public static function getInstance():IEmbeddedFontRegistry{
            if (!instance){
                instance = new (EmbeddedFontRegistry)();
            };
            return (instance);
        }
        public static function getFontStyle(_arg1:Boolean, _arg2:Boolean):String{
            var _local3:String = FontStyle.REGULAR;
            if (((_arg1) && (_arg2))){
                _local3 = FontStyle.BOLD_ITALIC;
            } else {
                if (_arg1){
                    _local3 = FontStyle.BOLD;
                } else {
                    if (_arg2){
                        _local3 = FontStyle.ITALIC;
                    };
                };
            };
            return (_local3);
        }
        private static function createFontKey(_arg1:EmbeddedFont):String{
            return ((_arg1.fontName + _arg1.fontStyle));
        }
        private static function createEmbeddedFont(_arg1:String):EmbeddedFont{
            var _local2:String;
            var _local3:Boolean;
            var _local4:Boolean;
            var _local5:int = endsWith(_arg1, FontStyle.REGULAR);
            if (_local5 > 0){
                _local2 = _arg1.substring(0, _local5);
                return (new EmbeddedFont(_local2, false, false));
            };
            _local5 = endsWith(_arg1, FontStyle.BOLD);
            if (_local5 > 0){
                _local2 = _arg1.substring(0, _local5);
                return (new EmbeddedFont(_local2, true, false));
            };
            _local5 = endsWith(_arg1, FontStyle.BOLD_ITALIC);
            if (_local5 > 0){
                _local2 = _arg1.substring(0, _local5);
                return (new EmbeddedFont(_local2, true, true));
            };
            _local5 = endsWith(_arg1, FontStyle.ITALIC);
            if (_local5 > 0){
                _local2 = _arg1.substring(0, _local5);
                return (new EmbeddedFont(_local2, false, true));
            };
            return (new EmbeddedFont("", false, false));
        }
        private static function endsWith(_arg1:String, _arg2:String):int{
            var _local3:int = _arg1.lastIndexOf(_arg2);
            if ((((_local3 > 0)) && (((_local3 + _arg2.length) == _arg1.length)))){
                return (_local3);
            };
            return (-1);
        }

        public function getAssociatedModuleFactory(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):IFlexModuleFactory{
            var _local4:int;
            var _local5:Object;
            var _local3:Dictionary = fonts[createFontKey(_arg1)];
            if (_local3){
                _local4 = _local3[_arg2];
                if (_local4){
                    return (_arg2);
                };
                for (_local5 in _local3) {
                    return ((_local5 as IFlexModuleFactory));
                };
            };
            return (null);
        }
        public function deregisterFont(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):void{
            var _local5:int;
            var _local6:Object;
            var _local3:String = createFontKey(_arg1);
            var _local4:Dictionary = fonts[_local3];
            if (_local4 != null){
                delete _local4[_arg2];
                _local5 = 0;
                for (_local6 in _local4) {
                    _local5++;
                };
                if (_local5 == 0){
                    delete fonts[_local3];
                };
            };
        }
        public function getFonts():Array{
            var _local2:String;
            var _local1:Array = [];
            for (_local2 in fonts) {
                _local1.push(createEmbeddedFont(_local2));
            };
            return (_local1);
        }
        public function registerFont(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):void{
            var _local3:String = createFontKey(_arg1);
            var _local4:Dictionary = fonts[_local3];
            if (!_local4){
                _local4 = new Dictionary(true);
                fonts[_local3] = _local4;
            };
            _local4[_arg2] = 1;
        }

    }
}//package mx.core 
