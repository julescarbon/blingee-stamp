package mx.managers {
    import flash.events.*;

    public interface ILayoutManagerClient extends IEventDispatcher {

        function get updateCompletePendingFlag():Boolean;
        function set updateCompletePendingFlag(_arg1:Boolean):void;
        function set initialized(_arg1:Boolean):void;
        function validateProperties():void;
        function validateDisplayList():void;
        function get nestLevel():int;
        function get initialized():Boolean;
        function get processedDescriptors():Boolean;
        function validateSize(_arg1:Boolean=false):void;
        function set nestLevel(_arg1:int):void;
        function set processedDescriptors(_arg1:Boolean):void;

    }
}//package mx.managers 
