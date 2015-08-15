package mx.styles {
    import flash.events.*;
    import flash.system.*;

    public interface IStyleManager2 extends IStyleManager {

        function get selectors():Array;
        function loadStyleDeclarations2(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher;

    }
}//package mx.styles 
