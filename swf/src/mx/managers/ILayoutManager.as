package mx.managers {
    import flash.events.*;

    public interface ILayoutManager extends IEventDispatcher {

        function validateNow():void;
        function validateClient(_arg1:ILayoutManagerClient, _arg2:Boolean=false):void;
        function isInvalid():Boolean;
        function invalidateDisplayList(_arg1:ILayoutManagerClient):void;
        function set usePhasedInstantiation(_arg1:Boolean):void;
        function invalidateSize(_arg1:ILayoutManagerClient):void;
        function get usePhasedInstantiation():Boolean;
        function invalidateProperties(_arg1:ILayoutManagerClient):void;

    }
}//package mx.managers 
