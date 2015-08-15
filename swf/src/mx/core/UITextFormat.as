package mx.core {
    import flash.text.*;
    import mx.managers.*;

    public class UITextFormat extends TextFormat {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
        private static var _textFieldFactory:ITextFieldFactory;

        private var systemManager:ISystemManager;
        public var sharpness:Number;
        public var gridFitType:String;
        public var antiAliasType:String;
        public var thickness:Number;
        private var cachedEmbeddedFont:EmbeddedFont = null;
        private var _moduleFactory:IFlexModuleFactory;

        public function UITextFormat(_arg1:ISystemManager, _arg2:String=null, _arg3:Object=null, _arg4:Object=null, _arg5:Object=null, _arg6:Object=null, _arg7:Object=null, _arg8:String=null, _arg9:String=null, _arg10:String=null, _arg11:Object=null, _arg12:Object=null, _arg13:Object=null, _arg14:Object=null){
            this.systemManager = _arg1;
            super(_arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10, _arg11, _arg12, _arg13, _arg14);
        }
        private static function get embeddedFontRegistry():IEmbeddedFontRegistry{
            if (!_embeddedFontRegistry){
                _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            };
            return (_embeddedFontRegistry);
        }
        private static function get textFieldFactory():ITextFieldFactory{
            if (!_textFieldFactory){
                _textFieldFactory = ITextFieldFactory(Singleton.getInstance("mx.core::ITextFieldFactory"));
            };
            return (_textFieldFactory);
        }

        public function set moduleFactory(_arg1:IFlexModuleFactory):void{
            _moduleFactory = _arg1;
        }
        mx_internal function copyFrom(_arg1:TextFormat):void{
            font = _arg1.font;
            size = _arg1.size;
            color = _arg1.color;
            bold = _arg1.bold;
            italic = _arg1.italic;
            underline = _arg1.underline;
            url = _arg1.url;
            target = _arg1.target;
            align = _arg1.align;
            leftMargin = _arg1.leftMargin;
            rightMargin = _arg1.rightMargin;
            indent = _arg1.indent;
            leading = _arg1.leading;
            letterSpacing = _arg1.letterSpacing;
            blockIndent = _arg1.blockIndent;
            bullet = _arg1.bullet;
            display = _arg1.display;
            indent = _arg1.indent;
            kerning = _arg1.kerning;
            tabStops = _arg1.tabStops;
        }
        private function getEmbeddedFont(_arg1:String, _arg2:Boolean, _arg3:Boolean):EmbeddedFont{
            if (cachedEmbeddedFont){
                if ((((cachedEmbeddedFont.fontName == _arg1)) && ((cachedEmbeddedFont.fontStyle == EmbeddedFontRegistry.getFontStyle(_arg2, _arg3))))){
                    return (cachedEmbeddedFont);
                };
            };
            cachedEmbeddedFont = new EmbeddedFont(_arg1, _arg2, _arg3);
            return (cachedEmbeddedFont);
        }
        public function measureText(_arg1:String, _arg2:Boolean=true):TextLineMetrics{
            return (measure(_arg1, false, _arg2));
        }
        private function measure(_arg1:String, _arg2:Boolean, _arg3:Boolean):TextLineMetrics{
            if (!_arg1){
                _arg1 = "";
            };
            var _local4:Boolean;
            var _local5:IFlexModuleFactory = embeddedFontRegistry.getAssociatedModuleFactory(getEmbeddedFont(font, bold, italic), moduleFactory);
            _local4 = !((_local5 == null));
            if (_local5 == null){
                _local5 = systemManager;
            };
            var _local6:TextField;
            _local6 = TextField(textFieldFactory.createTextField(_local5));
            if (_arg2){
                _local6.htmlText = "";
            } else {
                _local6.text = "";
            };
            _local6.defaultTextFormat = this;
            if (font){
                _local6.embedFonts = ((_local4) || (((!((systemManager == null))) && (systemManager.isFontFaceEmbedded(this)))));
            } else {
                _local6.embedFonts = false;
            };
            _local6.antiAliasType = antiAliasType;
            _local6.gridFitType = gridFitType;
            _local6.sharpness = sharpness;
            _local6.thickness = thickness;
            if (_arg2){
                _local6.htmlText = _arg1;
            } else {
                _local6.text = _arg1;
            };
            var _local7:TextLineMetrics = _local6.getLineMetrics(0);
            if (indent != null){
                _local7.width = (_local7.width + indent);
            };
            if (_arg3){
                _local7.width = Math.ceil(_local7.width);
                _local7.height = Math.ceil(_local7.height);
            };
            return (_local7);
        }
        public function measureHTMLText(_arg1:String, _arg2:Boolean=true):TextLineMetrics{
            return (measure(_arg1, true, _arg2));
        }
        public function get moduleFactory():IFlexModuleFactory{
            return (_moduleFactory);
        }

    }
}//package mx.core 
