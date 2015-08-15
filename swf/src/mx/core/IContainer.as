package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.text.*;
    import mx.managers.*;

    public interface IContainer extends IUIComponent {

        function set hitArea(_arg1:Sprite):void;
        function swapChildrenAt(_arg1:int, _arg2:int):void;
        function getChildByName(_arg1:String):DisplayObject;
        function get doubleClickEnabled():Boolean;
        function get graphics():Graphics;
        function get useHandCursor():Boolean;
        function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject;
        function set mouseChildren(_arg1:Boolean):void;
        function set creatingContentPane(_arg1:Boolean):void;
        function get textSnapshot():TextSnapshot;
        function getChildIndex(_arg1:DisplayObject):int;
        function set doubleClickEnabled(_arg1:Boolean):void;
        function getObjectsUnderPoint(_arg1:Point):Array;
        function get creatingContentPane():Boolean;
        function setChildIndex(_arg1:DisplayObject, _arg2:int):void;
        function get soundTransform():SoundTransform;
        function set useHandCursor(_arg1:Boolean):void;
        function get numChildren():int;
        function contains(_arg1:DisplayObject):Boolean;
        function get verticalScrollPosition():Number;
        function set defaultButton(_arg1:IFlexDisplayObject):void;
        function swapChildren(_arg1:DisplayObject, _arg2:DisplayObject):void;
        function set horizontalScrollPosition(_arg1:Number):void;
        function get focusManager():IFocusManager;
        function startDrag(_arg1:Boolean=false, _arg2:Rectangle=null):void;
        function set mouseEnabled(_arg1:Boolean):void;
        function getChildAt(_arg1:int):DisplayObject;
        function set soundTransform(_arg1:SoundTransform):void;
        function get tabChildren():Boolean;
        function get tabIndex():int;
        function set focusRect(_arg1:Object):void;
        function get hitArea():Sprite;
        function get mouseChildren():Boolean;
        function removeChildAt(_arg1:int):DisplayObject;
        function get defaultButton():IFlexDisplayObject;
        function stopDrag():void;
        function set tabEnabled(_arg1:Boolean):void;
        function get horizontalScrollPosition():Number;
        function get focusRect():Object;
        function get viewMetrics():EdgeMetrics;
        function set verticalScrollPosition(_arg1:Number):void;
        function get dropTarget():DisplayObject;
        function get mouseEnabled():Boolean;
        function set tabChildren(_arg1:Boolean):void;
        function set buttonMode(_arg1:Boolean):void;
        function get tabEnabled():Boolean;
        function get buttonMode():Boolean;
        function removeChild(_arg1:DisplayObject):DisplayObject;
        function set tabIndex(_arg1:int):void;
        function addChild(_arg1:DisplayObject):DisplayObject;
        function areInaccessibleObjectsUnderPoint(_arg1:Point):Boolean;

    }
}//package mx.core 
