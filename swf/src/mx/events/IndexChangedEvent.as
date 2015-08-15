package mx.events {
    import flash.display.*;
    import flash.events.*;

    public class IndexChangedEvent extends Event {

        public static const HEADER_SHIFT:String = "headerShift";
        public static const CHANGE:String = "change";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const CHILD_INDEX_CHANGE:String = "childIndexChange";

        public var newIndex:Number;
        public var triggerEvent:Event;
        public var relatedObject:DisplayObject;
        public var oldIndex:Number;

        public function IndexChangedEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:DisplayObject=null, _arg5:Number=-1, _arg6:Number=-1, _arg7:Event=null){
            super(_arg1, _arg2, _arg3);
            this.relatedObject = _arg4;
            this.oldIndex = _arg5;
            this.newIndex = _arg6;
            this.triggerEvent = _arg7;
        }
        override public function clone():Event{
            return (new IndexChangedEvent(type, bubbles, cancelable, relatedObject, oldIndex, newIndex, triggerEvent));
        }

    }
}//package mx.events 
