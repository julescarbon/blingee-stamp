package mx.modules {
    import mx.core.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public interface IModuleInfo extends IEventDispatcher {

        function get ready():Boolean;
        function get loaded():Boolean;
        function load(_arg1:ApplicationDomain=null, _arg2:SecurityDomain=null, _arg3:ByteArray=null):void;
        function release():void;
        function get error():Boolean;
        function get data():Object;
        function publish(_arg1:IFlexModuleFactory):void;
        function get factory():IFlexModuleFactory;
        function set data(_arg1:Object):void;
        function get url():String;
        function get setup():Boolean;
        function unload():void;

    }
}//package mx.modules 
