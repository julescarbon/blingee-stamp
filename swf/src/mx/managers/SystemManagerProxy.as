package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.utils.*;

    public class SystemManagerProxy extends SystemManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _systemManager:ISystemManager;

        public function SystemManagerProxy(_arg1:ISystemManager){
            _systemManager = _arg1;
            topLevel = true;
            super.addEventListener(MouseEvent.MOUSE_DOWN, proxyMouseDownHandler, true);
        }
        override public function create(... _args):Object{
            return (IFlexModuleFactory(_systemManager).create.apply(this, _args));
        }
        public function get systemManager():ISystemManager{
            return (_systemManager);
        }
        override public function activate(_arg1:IFocusManagerContainer):void{
            var _local3:Boolean;
            var _local4:SWFBridgeEvent;
            var _local2:IEventDispatcher = ((_systemManager.swfBridgeGroup) ? _systemManager.swfBridgeGroup.parentBridge : null);
            if (_local2){
                _local3 = SecurityUtil.hasMutualTrustBetweenParentAndChild(ISWFBridgeProvider(_systemManager));
                _local4 = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_ACTIVATE, false, false, {
                    notifier:_local2,
                    window:((_local3) ? this : NameUtil.displayObjectToString(this))
                });
                _systemManager.getSandboxRoot().dispatchEvent(_local4);
            };
        }
        override public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            super.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
            _systemManager.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function deactivateByProxy(_arg1:IFocusManagerContainer):void{
            if (_arg1){
                _arg1.focusManager.deactivate();
            };
        }
        override public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            super.removeEventListener(_arg1, _arg2, _arg3);
            _systemManager.removeEventListener(_arg1, _arg2, _arg3);
        }
        override public function get document():Object{
            return (findFocusManagerContainer(this));
        }
        public function activateByProxy(_arg1:IFocusManagerContainer):void{
            super.activate(_arg1);
        }
        override public function removeChildBridge(_arg1:IEventDispatcher):void{
            _systemManager.removeChildBridge(_arg1);
        }
        override public function get swfBridgeGroup():ISWFBridgeGroup{
            return (_systemManager.swfBridgeGroup);
        }
        override public function addChildBridge(_arg1:IEventDispatcher, _arg2:DisplayObject):void{
            _systemManager.addChildBridge(_arg1, _arg2);
        }
        override public function useSWFBridge():Boolean{
            return (_systemManager.useSWFBridge());
        }
        override public function get screen():Rectangle{
            return (_systemManager.screen);
        }
        override public function set swfBridgeGroup(_arg1:ISWFBridgeGroup):void{
        }
        private function proxyMouseDownHandler(_arg1:MouseEvent):void{
            if (findFocusManagerContainer(this)){
                SystemManager(_systemManager).dispatchActivatedWindowEvent(this);
            };
        }
        override public function deactivate(_arg1:IFocusManagerContainer):void{
            var _local4:Boolean;
            var _local5:SWFBridgeEvent;
            var _local2:ISystemManager = _systemManager;
            var _local3:IEventDispatcher = ((_local2.swfBridgeGroup) ? _local2.swfBridgeGroup.parentBridge : null);
            if (_local3){
                _local4 = SecurityUtil.hasMutualTrustBetweenParentAndChild(ISWFBridgeProvider(_systemManager));
                _local5 = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_WINDOW_DEACTIVATE, false, false, {
                    notifier:_local3,
                    window:((_local4) ? this : NameUtil.displayObjectToString(this))
                });
                _systemManager.getSandboxRoot().dispatchEvent(_local5);
            };
        }
        override public function set document(_arg1:Object):void{
        }
        override public function getVisibleApplicationRect(_arg1:Rectangle=null):Rectangle{
            return (_systemManager.getVisibleApplicationRect(_arg1));
        }
        override public function getDefinitionByName(_arg1:String):Object{
            return (_systemManager.getDefinitionByName(_arg1));
        }

    }
}//package mx.managers 
