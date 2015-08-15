package mx.styles {
    import flash.display.*;
    import mx.core.*;

    public class StyleProtoChain {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function initProtoChainForUIComponentStyleName(_arg1:IStyleClient):void{
            var _local9:CSSStyleDeclaration;
            var _local2:IStyleClient = IStyleClient(_arg1.styleName);
            var _local3:DisplayObject = (_arg1 as DisplayObject);
            var _local4:Object = _local2.nonInheritingStyles;
            if (((!(_local4)) || ((_local4 == UIComponent.STYLE_UNINITIALIZED)))){
                _local4 = StyleManager.stylesRoot;
                if (_local4.effects){
                    _arg1.registerEffects(_local4.effects);
                };
            };
            var _local5:Object = _local2.inheritingStyles;
            if (((!(_local5)) || ((_local5 == UIComponent.STYLE_UNINITIALIZED)))){
                _local5 = StyleManager.stylesRoot;
            };
            var _local6:Array = _arg1.getClassStyleDeclarations();
            var _local7:int = _local6.length;
            if ((_local2 is StyleProxy)){
                if (_local7 == 0){
                    _local4 = addProperties(_local4, _local2, false);
                };
                _local3 = (StyleProxy(_local2).source as DisplayObject);
            };
            var _local8:int;
            while (_local8 < _local7) {
                _local9 = _local6[_local8];
                _local5 = _local9.addStyleToProtoChain(_local5, _local3);
                _local5 = addProperties(_local5, _local2, true);
                _local4 = _local9.addStyleToProtoChain(_local4, _local3);
                _local4 = addProperties(_local4, _local2, false);
                if (_local9.effects){
                    _arg1.registerEffects(_local9.effects);
                };
                _local8++;
            };
            _arg1.inheritingStyles = ((_arg1.styleDeclaration) ? _arg1.styleDeclaration.addStyleToProtoChain(_local5, _local3) : _local5);
            _arg1.nonInheritingStyles = ((_arg1.styleDeclaration) ? _arg1.styleDeclaration.addStyleToProtoChain(_local4, _local3) : _local4);
        }
        private static function addProperties(_arg1:Object, _arg2:IStyleClient, _arg3:Boolean):Object{
            var _local11:CSSStyleDeclaration;
            var _local12:CSSStyleDeclaration;
            var _local4:Object = (((((_arg2 is StyleProxy)) && (!(_arg3)))) ? StyleProxy(_arg2).filterMap : null);
            var _local5:IStyleClient = _arg2;
            while ((_local5 is StyleProxy)) {
                _local5 = StyleProxy(_local5).source;
            };
            var _local6:DisplayObject = (_local5 as DisplayObject);
            var _local7:Array = _arg2.getClassStyleDeclarations();
            var _local8:int = _local7.length;
            var _local9:int;
            while (_local9 < _local8) {
                _local11 = _local7[_local9];
                _arg1 = _local11.addStyleToProtoChain(_arg1, _local6, _local4);
                if (_local11.effects){
                    _arg2.registerEffects(_local11.effects);
                };
                _local9++;
            };
            var _local10:Object = _arg2.styleName;
            if (_local10){
                if (typeof(_local10) == "object"){
                    if ((_local10 is CSSStyleDeclaration)){
                        _local12 = CSSStyleDeclaration(_local10);
                    } else {
                        _arg1 = addProperties(_arg1, IStyleClient(_local10), _arg3);
                    };
                } else {
                    _local12 = StyleManager.getStyleDeclaration(("." + _local10));
                };
                if (_local12){
                    _arg1 = _local12.addStyleToProtoChain(_arg1, _local6, _local4);
                    if (_local12.effects){
                        _arg2.registerEffects(_local12.effects);
                    };
                };
            };
            if (_arg2.styleDeclaration){
                _arg1 = _arg2.styleDeclaration.addStyleToProtoChain(_arg1, _local6, _local4);
            };
            return (_arg1);
        }
        public static function initTextField(_arg1:IUITextField):void{
            var _local3:CSSStyleDeclaration;
            var _local2:Object = _arg1.styleName;
            if (_local2){
                if (typeof(_local2) == "object"){
                    if ((_local2 is CSSStyleDeclaration)){
                        _local3 = CSSStyleDeclaration(_local2);
                    } else {
                        if ((_local2 is StyleProxy)){
                            _arg1.inheritingStyles = IStyleClient(_local2).inheritingStyles;
                            _arg1.nonInheritingStyles = addProperties(StyleManager.stylesRoot, IStyleClient(_local2), false);
                            return;
                        };
                        _arg1.inheritingStyles = IStyleClient(_local2).inheritingStyles;
                        _arg1.nonInheritingStyles = IStyleClient(_local2).nonInheritingStyles;
                        return;
                    };
                } else {
                    _local3 = StyleManager.getStyleDeclaration(("." + _local2));
                };
            };
            var _local4:Object = IStyleClient(_arg1.parent).inheritingStyles;
            var _local5:Object = StyleManager.stylesRoot;
            if (!_local4){
                _local4 = StyleManager.stylesRoot;
            };
            if (_local3){
                _local4 = _local3.addStyleToProtoChain(_local4, DisplayObject(_arg1));
                _local5 = _local3.addStyleToProtoChain(_local5, DisplayObject(_arg1));
            };
            _arg1.inheritingStyles = _local4;
            _arg1.nonInheritingStyles = _local5;
        }

    }
}//package mx.styles 
