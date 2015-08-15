package mx.managers {
    import flash.events.*;

    public interface IBrowserManager extends IEventDispatcher {

        function get fragment():String;
        function get base():String;
        function setFragment(_arg1:String):void;
        function setTitle(_arg1:String):void;
        function init(_arg1:String=null, _arg2:String=null):void;
        function get title():String;
        function initForHistoryManager():void;
        function get url():String;

    }
}//package mx.managers 
