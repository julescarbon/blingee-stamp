package mx.events {
    import flash.events.*;

    public class CollectionEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const COLLECTION_CHANGE:String = "collectionChange";

        public var kind:String;
        public var location:int;
        public var items:Array;
        public var oldLocation:int;

        public function CollectionEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:int=-1, _arg6:int=-1, _arg7:Array=null){
            super(_arg1, _arg2, _arg3);
            this.kind = _arg4;
            this.location = _arg5;
            this.oldLocation = _arg6;
            this.items = ((_arg7) ? _arg7 : []);
        }
        override public function toString():String{
            return (formatToString("CollectionEvent", "kind", "location", "oldLocation", "type", "bubbles", "cancelable", "eventPhase"));
        }
        override public function clone():Event{
            return (new CollectionEvent(type, bubbles, cancelable, kind, location, oldLocation, items));
        }

    }
}//package mx.events 
