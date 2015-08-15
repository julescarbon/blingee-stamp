package mx.events {
    import flash.events.*;
    import mx.controls.listClasses.*;

    public class ListEvent extends Event {

        public static const ITEM_ROLL_OUT:String = "itemRollOut";
        public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
        public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";
        public static const ITEM_ROLL_OVER:String = "itemRollOver";
        public static const ITEM_EDIT_END:String = "itemEditEnd";
        public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";
        public static const CHANGE:String = "change";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const ITEM_FOCUS_OUT:String = "itemFocusOut";
        public static const ITEM_CLICK:String = "itemClick";
        public static const ITEM_FOCUS_IN:String = "itemFocusIn";

        public var reason:String;
        public var itemRenderer:IListItemRenderer;
        public var rowIndex:int;
        public var columnIndex:int;

        public function ListEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:int=-1, _arg5:int=-1, _arg6:String=null, _arg7:IListItemRenderer=null){
            super(_arg1, _arg2, _arg3);
            this.columnIndex = _arg4;
            this.rowIndex = _arg5;
            this.reason = _arg6;
            this.itemRenderer = _arg7;
        }
        override public function clone():Event{
            return (new ListEvent(type, bubbles, cancelable, columnIndex, rowIndex, reason, itemRenderer));
        }

    }
}//package mx.events 
