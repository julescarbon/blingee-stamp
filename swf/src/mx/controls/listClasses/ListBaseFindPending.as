package mx.controls.listClasses {
    import mx.collections.*;

    public class ListBaseFindPending {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var currentIndex:int;
        public var stopIndex:int;
        public var startingBookmark:CursorBookmark;
        public var searchString:String;
        public var offset:int;
        public var bookmark:CursorBookmark;

        public function ListBaseFindPending(_arg1:String, _arg2:CursorBookmark, _arg3:CursorBookmark, _arg4:int, _arg5:int, _arg6:int){
            this.searchString = _arg1;
            this.startingBookmark = _arg2;
            this.bookmark = _arg3;
            this.offset = _arg4;
            this.currentIndex = _arg5;
            this.stopIndex = _arg6;
        }
    }
}//package mx.controls.listClasses 
