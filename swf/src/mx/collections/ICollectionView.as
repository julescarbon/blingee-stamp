package mx.collections {
    import flash.events.*;

    public interface ICollectionView extends IEventDispatcher {

        function set filterFunction(_arg1:Function):void;
        function enableAutoUpdate():void;
        function get length():int;
        function disableAutoUpdate():void;
        function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void;
        function get filterFunction():Function;
        function createCursor():IViewCursor;
        function refresh():Boolean;
        function set sort(_arg1:Sort):void;
        function get sort():Sort;
        function contains(_arg1:Object):Boolean;

    }
}//package mx.collections 
