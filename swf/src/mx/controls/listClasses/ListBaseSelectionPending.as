package mx.controls.listClasses {
    import mx.collections.*;

    public class ListBaseSelectionPending {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var offset:int;
        public var stopData:Object;
        public var index:int;
        public var placeHolder:CursorBookmark;
        public var bookmark:CursorBookmark;
        public var incrementing:Boolean;
        public var transition:Boolean;

        public function ListBaseSelectionPending(_arg1:Boolean, _arg2:int, _arg3:Object, _arg4:Boolean, _arg5:CursorBookmark, _arg6:CursorBookmark, _arg7:int){
            this.incrementing = _arg1;
            this.index = _arg2;
            this.stopData = _arg3;
            this.transition = _arg4;
            this.placeHolder = _arg5;
            this.bookmark = _arg6;
            this.offset = _arg7;
        }
    }
}//package mx.controls.listClasses 
