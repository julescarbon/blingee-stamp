package mx.core {
    import flash.display.*;
    import flash.geom.*;

    public interface IChildList {

        function get numChildren():int;
        function removeChild(_arg1:DisplayObject):DisplayObject;
        function getChildByName(_arg1:String):DisplayObject;
        function removeChildAt(_arg1:int):DisplayObject;
        function getChildIndex(_arg1:DisplayObject):int;
        function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject;
        function getObjectsUnderPoint(_arg1:Point):Array;
        function setChildIndex(_arg1:DisplayObject, _arg2:int):void;
        function getChildAt(_arg1:int):DisplayObject;
        function addChild(_arg1:DisplayObject):DisplayObject;
        function contains(_arg1:DisplayObject):Boolean;

    }
}//package mx.core 
