package {
    import mx.core.*;
    import mx.styles.*;
    import mx.skins.halo.*;

    public class _DragManagerStyle {

        private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_2095422283:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragLink_2095422283;
        private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_2095397026:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragMove_2095397026;
        private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_611102944:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragReject_611102944;
        private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2096733126:Class = _DragManagerStyle__embed_css_Assets_swf_mx_skins_cursor_DragCopy_2096733126;

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var style:* = StyleManager.getStyleDeclaration("DragManager");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("DragManager", style, false);
            };
            if (style.defaultFactory == null){
                style.defaultFactory = function ():void{
                    this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_611102944;
                    this.defaultDragImageSkin = DefaultDragImage;
                    this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_2095397026;
                    this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2096733126;
                    this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_2095422283;
                };
            };
        }

    }
}//package 
