package mx.managers {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;

    public interface IFocusManager {

        function get focusPane():Sprite;
        function getFocus():IFocusManagerComponent;
        function deactivate():void;
        function set defaultButton(_arg1:IButton):void;
        function set focusPane(_arg1:Sprite):void;
        function set showFocusIndicator(_arg1:Boolean):void;
        function moveFocus(_arg1:String, _arg2:DisplayObject=null):void;
        function addSWFBridge(_arg1:IEventDispatcher, _arg2:DisplayObject):void;
        function removeSWFBridge(_arg1:IEventDispatcher):void;
        function get defaultButtonEnabled():Boolean;
        function findFocusManagerComponent(_arg1:InteractiveObject):IFocusManagerComponent;
        function get nextTabIndex():int;
        function get defaultButton():IButton;
        function get showFocusIndicator():Boolean;
        function setFocus(_arg1:IFocusManagerComponent):void;
        function activate():void;
        function showFocus():void;
        function set defaultButtonEnabled(_arg1:Boolean):void;
        function hideFocus():void;
        function getNextFocusManagerComponent(_arg1:Boolean=false):IFocusManagerComponent;

    }
}//package mx.managers 
