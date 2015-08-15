package mx.managers {

    public interface IHistoryManager {

        function registered():void;
        function register(_arg1:IHistoryManagerClient):void;
        function registerHandshake():void;
        function load(_arg1:Object):void;
        function loadInitialState():void;
        function unregister(_arg1:IHistoryManagerClient):void;
        function save():void;

    }
}//package mx.managers 
