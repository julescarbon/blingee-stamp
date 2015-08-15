package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _CursorManagerStyle {

        private static var _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_31630188:Class = _CursorManagerStyle__embed_css_Assets_swf_mx_skins_cursor_BusyCursor_31630188;

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("CursorManager");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("CursorManager", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.busyCursor = BusyCursor;
                    this.busyCursorBackground = _embed_css_Assets_swf_mx_skins_cursor_BusyCursor_31630188;
                };
            };
        }

    }
}//package 
