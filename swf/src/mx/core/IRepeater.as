package mx.core {

    public interface IRepeater {

        function get container():IContainer;
        function set startingIndex(_arg1:int):void;
        function get startingIndex():int;
        function set recycleChildren(_arg1:Boolean):void;
        function get currentItem():Object;
        function get count():int;
        function get recycleChildren():Boolean;
        function executeChildBindings():void;
        function set dataProvider(_arg1:Object):void;
        function initializeRepeater(_arg1:IContainer, _arg2:Boolean):void;
        function get currentIndex():int;
        function get dataProvider():Object;
        function set count(_arg1:int):void;

    }
}//package mx.core 
