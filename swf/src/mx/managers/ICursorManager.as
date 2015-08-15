package mx.managers {

    public interface ICursorManager {

        function removeAllCursors():void;
        function set currentCursorYOffset(_arg1:Number):void;
        function removeBusyCursor():void;
        function unRegisterToUseBusyCursor(_arg1:Object):void;
        function hideCursor():void;
        function get currentCursorID():int;
        function registerToUseBusyCursor(_arg1:Object):void;
        function setBusyCursor():void;
        function showCursor():void;
        function set currentCursorID(_arg1:int):void;
        function setCursor(_arg1:Class, _arg2:int=2, _arg3:Number=0, _arg4:Number=0):int;
        function removeCursor(_arg1:int):void;
        function get currentCursorXOffset():Number;
        function get currentCursorYOffset():Number;
        function set currentCursorXOffset(_arg1:Number):void;

    }
}//package mx.managers 
