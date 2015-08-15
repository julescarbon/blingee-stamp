package mx.logging {
    import flash.events.*;

    public interface ILogger extends IEventDispatcher {

        function debug(_arg1:String, ... _args):void;
        function fatal(_arg1:String, ... _args):void;
        function get category():String;
        function warn(_arg1:String, ... _args):void;
        function error(_arg1:String, ... _args):void;
        function log(_arg1:int, _arg2:String, ... _args):void;
        function info(_arg1:String, ... _args):void;

    }
}//package mx.logging 
