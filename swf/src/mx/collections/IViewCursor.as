package mx.collections {
    import flash.events.*;

    public interface IViewCursor extends IEventDispatcher {

        function get current():Object;
        function moveNext():Boolean;
        function get view():ICollectionView;
        function movePrevious():Boolean;
        function remove():Object;
        function findLast(_arg1:Object):Boolean;
        function get beforeFirst():Boolean;
        function get afterLast():Boolean;
        function findAny(_arg1:Object):Boolean;
        function get bookmark():CursorBookmark;
        function findFirst(_arg1:Object):Boolean;
        function seek(_arg1:CursorBookmark, _arg2:int=0, _arg3:int=0):void;
        function insert(_arg1:Object):void;

    }
}//package mx.collections 
