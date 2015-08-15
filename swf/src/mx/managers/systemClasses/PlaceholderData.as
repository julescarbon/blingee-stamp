package mx.managers.systemClasses {
    import flash.events.*;

    public class PlaceholderData {

        public var bridge:IEventDispatcher;
        public var data:Object;
        public var id:String;

        public function PlaceholderData(_arg1:String, _arg2:IEventDispatcher, _arg3:Object){
            this.id = _arg1;
            this.bridge = _arg2;
            this.data = _arg3;
        }
    }
}//package mx.managers.systemClasses 
