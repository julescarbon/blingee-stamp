package mx.core {

    public interface IRepeaterClient {

        function get instanceIndices():Array;
        function set instanceIndices(_arg1:Array):void;
        function get isDocument():Boolean;
        function set repeaters(_arg1:Array):void;
        function initializeRepeaterArrays(_arg1:IRepeaterClient):void;
        function get repeaters():Array;
        function set repeaterIndices(_arg1:Array):void;
        function get repeaterIndices():Array;

    }
}//package mx.core 
