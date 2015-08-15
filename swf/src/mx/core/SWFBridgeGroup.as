package mx.core {
    import mx.managers.*;
    import flash.events.*;
    import flash.utils.*;

    public class SWFBridgeGroup implements ISWFBridgeGroup {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _parentBridge:IEventDispatcher;
        private var _childBridges:Dictionary;
        private var _groupOwner:ISystemManager;

        public function SWFBridgeGroup(_arg1:ISystemManager){
            _groupOwner = _arg1;
        }
        public function getChildBridgeProvider(_arg1:IEventDispatcher):ISWFBridgeProvider{
            if (!_childBridges){
                return (null);
            };
            return (ISWFBridgeProvider(_childBridges[_arg1]));
        }
        public function removeChildBridge(_arg1:IEventDispatcher):void{
            var _local2:Object;
            if (((!(_childBridges)) || (!(_arg1)))){
                return;
            };
            for (_local2 in _childBridges) {
                if (_local2 == _arg1){
                    delete _childBridges[_local2];
                };
            };
        }
        public function get parentBridge():IEventDispatcher{
            return (_parentBridge);
        }
        public function containsBridge(_arg1:IEventDispatcher):Boolean{
            var _local2:Object;
            if (((parentBridge) && ((parentBridge == _arg1)))){
                return (true);
            };
            for (_local2 in _childBridges) {
                if (_arg1 == _local2){
                    return (true);
                };
            };
            return (false);
        }
        public function set parentBridge(_arg1:IEventDispatcher):void{
            _parentBridge = _arg1;
        }
        public function addChildBridge(_arg1:IEventDispatcher, _arg2:ISWFBridgeProvider):void{
            if (!_childBridges){
                _childBridges = new Dictionary();
            };
            _childBridges[_arg1] = _arg2;
        }
        public function getChildBridges():Array{
            var _local2:Object;
            var _local1:Array = [];
            for (_local2 in _childBridges) {
                _local1.push(_local2);
            };
            return (_local1);
        }

    }
}//package mx.core 
