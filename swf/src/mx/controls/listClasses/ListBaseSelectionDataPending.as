package mx.controls.listClasses {
    import mx.collections.*;

    public class ListBaseSelectionDataPending {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var items:Array;
        public var index:int;
        public var bookmark:CursorBookmark;
        public var offset:int;
        public var useFind:Boolean;

        public function ListBaseSelectionDataPending(_arg1:Boolean, _arg2:int, _arg3:Array, _arg4:CursorBookmark, _arg5:int){
            this.useFind = _arg1;
            this.index = _arg2;
            this.items = _arg3;
            this.bookmark = _arg4;
            this.offset = _arg5;
        }
    }
}//package mx.controls.listClasses 
