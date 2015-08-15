package mx.states {
    import flash.events.*;
    import mx.events.*;

    public class State extends EventDispatcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var basedOn:String;
        private var initialized:Boolean = false;
        public var overrides:Array;
        public var name:String;

        public function State(){
            overrides = [];
            super();
        }
        mx_internal function initialize():void{
            var _local1:int;
            if (!initialized){
                initialized = true;
                _local1 = 0;
                while (_local1 < overrides.length) {
                    IOverride(overrides[_local1]).initialize();
                    _local1++;
                };
            };
        }
        mx_internal function dispatchExitState():void{
            dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
        }
        mx_internal function dispatchEnterState():void{
            dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
        }

    }
}//package mx.states 
