package mx.events {
    import flash.events.*;

    public class PropertyChangeEvent extends Event {

        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const PROPERTY_CHANGE:String = "propertyChange";

        public var newValue:Object;
        public var kind:String;
        public var property:Object;
        public var oldValue:Object;
        public var source:Object;

        public function PropertyChangeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:Object=null, _arg6:Object=null, _arg7:Object=null, _arg8:Object=null){
            super(_arg1, _arg2, _arg3);
            this.kind = _arg4;
            this.property = _arg5;
            this.oldValue = _arg6;
            this.newValue = _arg7;
            this.source = _arg8;
        }
        public static function createUpdateEvent(_arg1:Object, _arg2:Object, _arg3:Object, _arg4:Object):PropertyChangeEvent{
            var _local5:PropertyChangeEvent = new PropertyChangeEvent(PROPERTY_CHANGE);
            _local5.kind = PropertyChangeEventKind.UPDATE;
            _local5.oldValue = _arg3;
            _local5.newValue = _arg4;
            _local5.source = _arg1;
            _local5.property = _arg2;
            return (_local5);
        }

        override public function clone():Event{
            return (new PropertyChangeEvent(type, bubbles, cancelable, kind, property, oldValue, newValue, source));
        }

    }
}//package mx.events 
