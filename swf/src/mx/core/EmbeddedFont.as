package mx.core {

    public class EmbeddedFont {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _fontName:String;
        private var _fontStyle:String;

        public function EmbeddedFont(_arg1:String, _arg2:Boolean, _arg3:Boolean){
            _fontName = _arg1;
            _fontStyle = EmbeddedFontRegistry.getFontStyle(_arg2, _arg3);
        }
        public function get fontStyle():String{
            return (_fontStyle);
        }
        public function get fontName():String{
            return (_fontName);
        }

    }
}//package mx.core 
