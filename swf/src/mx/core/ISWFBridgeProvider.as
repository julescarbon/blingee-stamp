package mx.core {
    import flash.events.*;

    public interface ISWFBridgeProvider {

        function get childAllowsParent():Boolean;
        function get swfBridge():IEventDispatcher;
        function get parentAllowsChild():Boolean;

    }
}//package mx.core 
