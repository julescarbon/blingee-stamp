package mx.logging {

    public interface ILoggingTarget {

        function addLogger(_arg1:ILogger):void;
        function removeLogger(_arg1:ILogger):void;
        function get level():int;
        function set filters(_arg1:Array):void;
        function set level(_arg1:int):void;
        function get filters():Array;

    }
}//package mx.logging 
