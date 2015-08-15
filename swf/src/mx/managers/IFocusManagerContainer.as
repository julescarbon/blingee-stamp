package mx.managers {
    import flash.display.*;
    import flash.events.*;

    public interface IFocusManagerContainer extends IEventDispatcher {

        function set focusManager(_arg1:IFocusManager):void;
        function get focusManager():IFocusManager;
        function get systemManager():ISystemManager;
        function contains(_arg1:DisplayObject):Boolean;

    }
}//package mx.managers 
