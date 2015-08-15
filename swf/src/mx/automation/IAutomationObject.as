package mx.automation {
    import flash.events.*;

    public interface IAutomationObject {

        function createAutomationIDPart(_arg1:IAutomationObject):Object;
        function get automationName():String;
        function get showInAutomationHierarchy():Boolean;
        function set automationName(_arg1:String):void;
        function getAutomationChildAt(_arg1:int):IAutomationObject;
        function get automationDelegate():Object;
        function get automationTabularData():Object;
        function resolveAutomationIDPart(_arg1:Object):Array;
        function replayAutomatableEvent(_arg1:Event):Boolean;
        function set automationDelegate(_arg1:Object):void;
        function get automationValue():Array;
        function get numAutomationChildren():int;
        function set showInAutomationHierarchy(_arg1:Boolean):void;

    }
}//package mx.automation 
