package mx.core {
    import flash.display.*;
    import mx.managers.*;

    public interface IUIComponent extends IFlexDisplayObject {

        function set focusPane(_arg1:Sprite):void;
        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;
        function set isPopUp(_arg1:Boolean):void;
        function get explicitMinHeight():Number;
        function get percentWidth():Number;
        function get isPopUp():Boolean;
        function get owner():DisplayObjectContainer;
        function get percentHeight():Number;
        function get baselinePosition():Number;
        function owns(_arg1:DisplayObject):Boolean;
        function initialize():void;
        function get maxWidth():Number;
        function get minWidth():Number;
        function getExplicitOrMeasuredWidth():Number;
        function get explicitMaxWidth():Number;
        function get explicitMaxHeight():Number;
        function set percentHeight(_arg1:Number):void;
        function get minHeight():Number;
        function set percentWidth(_arg1:Number):void;
        function get document():Object;
        function get focusPane():Sprite;
        function getExplicitOrMeasuredHeight():Number;
        function set tweeningProperties(_arg1:Array):void;
        function set explicitWidth(_arg1:Number):void;
        function set measuredMinHeight(_arg1:Number):void;
        function get explicitMinWidth():Number;
        function get tweeningProperties():Array;
        function get maxHeight():Number;
        function set owner(_arg1:DisplayObjectContainer):void;
        function set includeInLayout(_arg1:Boolean):void;
        function setVisible(_arg1:Boolean, _arg2:Boolean=false):void;
        function parentChanged(_arg1:DisplayObjectContainer):void;
        function get explicitWidth():Number;
        function get measuredMinHeight():Number;
        function set measuredMinWidth(_arg1:Number):void;
        function set explicitHeight(_arg1:Number):void;
        function get includeInLayout():Boolean;
        function get measuredMinWidth():Number;
        function get explicitHeight():Number;
        function set systemManager(_arg1:ISystemManager):void;
        function set document(_arg1:Object):void;
        function get systemManager():ISystemManager;

    }
}//package mx.core 
