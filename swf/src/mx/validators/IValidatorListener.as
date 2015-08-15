package mx.validators {
    import mx.events.*;

    public interface IValidatorListener {

        function set errorString(_arg1:String):void;
        function get validationSubField():String;
        function validationResultHandler(_arg1:ValidationResultEvent):void;
        function set validationSubField(_arg1:String):void;
        function get errorString():String;

    }
}//package mx.validators 
