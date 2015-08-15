package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.text.*;
    import flash.events.*;

    public interface ISystemManager extends IEventDispatcher, IChildList, IFlexModuleFactory {

        function set focusPane(_arg1:Sprite):void;
        function get toolTipChildren():IChildList;
        function useSWFBridge():Boolean;
        function isFontFaceEmbedded(_arg1:TextFormat):Boolean;
        function deployMouseShields(_arg1:Boolean):void;
        function get rawChildren():IChildList;
        function get topLevelSystemManager():ISystemManager;
        function dispatchEventFromSWFBridges(_arg1:Event, _arg2:IEventDispatcher=null, _arg3:Boolean=false, _arg4:Boolean=false):void;
        function getSandboxRoot():DisplayObject;
        function get swfBridgeGroup():ISWFBridgeGroup;
        function removeFocusManager(_arg1:IFocusManagerContainer):void;
        function addChildToSandboxRoot(_arg1:String, _arg2:DisplayObject):void;
        function get document():Object;
        function get focusPane():Sprite;
        function get loaderInfo():LoaderInfo;
        function addChildBridge(_arg1:IEventDispatcher, _arg2:DisplayObject):void;
        function getTopLevelRoot():DisplayObject;
        function removeChildBridge(_arg1:IEventDispatcher):void;
        function isDisplayObjectInABridgedApplication(_arg1:DisplayObject):Boolean;
        function get popUpChildren():IChildList;
        function get screen():Rectangle;
        function removeChildFromSandboxRoot(_arg1:String, _arg2:DisplayObject):void;
        function getDefinitionByName(_arg1:String):Object;
        function activate(_arg1:IFocusManagerContainer):void;
        function deactivate(_arg1:IFocusManagerContainer):void;
        function get cursorChildren():IChildList;
        function set document(_arg1:Object):void;
        function get embeddedFontList():Object;
        function set numModalWindows(_arg1:int):void;
        function isTopLevel():Boolean;
        function isTopLevelRoot():Boolean;
        function get numModalWindows():int;
        function addFocusManager(_arg1:IFocusManagerContainer):void;
        function get stage():Stage;
        function getVisibleApplicationRect(_arg1:Rectangle=null):Rectangle;

    }
}//package mx.managers 
