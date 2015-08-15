package mx.events {
    import flash.display.*;
    import flash.events.*;

    public class ItemClickEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const ITEM_CLICK:String = "itemClick";

        public var relatedObject:InteractiveObject;
        public var index:int;
        public var label:String;
        public var item:Object;

        public function ItemClickEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:int=-1, _arg6:InteractiveObject=null, _arg7:Object=null){
            super(_arg1, _arg2, _arg3);
            this.label = _arg4;
            this.index = _arg5;
            this.relatedObject = _arg6;
            this.item = _arg7;
        }
        override public function clone():Event{
            return (new ItemClickEvent(type, bubbles, cancelable, label, index, relatedObject, item));
        }

    }
}//package mx.events 
