package mx.core {
    import flash.events.*;

    public interface ISWFBridgeGroup {

        function getChildBridgeProvider(_arg1:IEventDispatcher):ISWFBridgeProvider;
        function removeChildBridge(_arg1:IEventDispatcher):void;
        function get parentBridge():IEventDispatcher;
        function addChildBridge(_arg1:IEventDispatcher, _arg2:ISWFBridgeProvider):void;
        function set parentBridge(_arg1:IEventDispatcher):void;
        function containsBridge(_arg1:IEventDispatcher):Boolean;
        function getChildBridges():Array;

    }
}//package mx.core 
