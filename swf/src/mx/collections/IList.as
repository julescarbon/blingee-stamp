package mx.collections {
    import flash.events.*;

    public interface IList extends IEventDispatcher {

        function addItem(_arg1:Object):void;
        function get length():int;
        function addItemAt(_arg1:Object, _arg2:int):void;
        function itemUpdated(_arg1:Object, _arg2:Object=null, _arg3:Object=null, _arg4:Object=null):void;
        function getItemIndex(_arg1:Object):int;
        function removeItemAt(_arg1:int):Object;
        function getItemAt(_arg1:int, _arg2:int=0):Object;
        function removeAll():void;
        function toArray():Array;
        function setItemAt(_arg1:Object, _arg2:int):Object;

    }
}//package mx.collections 
