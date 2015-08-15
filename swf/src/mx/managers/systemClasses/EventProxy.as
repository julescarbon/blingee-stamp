package mx.managers.systemClasses {
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class EventProxy extends EventDispatcher {

        private var systemManager:ISystemManager;

        public function EventProxy(_arg1:ISystemManager){
            this.systemManager = _arg1;
        }
        public function marshalListener(_arg1:Event):void{
            var _local2:MouseEvent;
            var _local3:SandboxMouseEvent;
            if ((_arg1 is MouseEvent)){
                _local2 = (_arg1 as MouseEvent);
                _local3 = new SandboxMouseEvent(EventUtil.mouseEventMap[_arg1.type], false, false, _local2.ctrlKey, _local2.altKey, _local2.shiftKey, _local2.buttonDown);
                systemManager.dispatchEventFromSWFBridges(_local3, null, true, true);
            };
        }

    }
}//package mx.managers.systemClasses 
