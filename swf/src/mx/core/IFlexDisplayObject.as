package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.accessibility.*;

    public interface IFlexDisplayObject extends IBitmapDrawable, IEventDispatcher {

        function get visible():Boolean;
        function get rotation():Number;
        function localToGlobal(_arg1:Point):Point;
        function get name():String;
        function set width(_arg1:Number):void;
        function get measuredHeight():Number;
        function get blendMode():String;
        function get scale9Grid():Rectangle;
        function set name(_arg1:String):void;
        function set scaleX(_arg1:Number):void;
        function set scaleY(_arg1:Number):void;
        function get measuredWidth():Number;
        function get accessibilityProperties():AccessibilityProperties;
        function set scrollRect(_arg1:Rectangle):void;
        function get cacheAsBitmap():Boolean;
        function globalToLocal(_arg1:Point):Point;
        function get height():Number;
        function set blendMode(_arg1:String):void;
        function get parent():DisplayObjectContainer;
        function getBounds(_arg1:DisplayObject):Rectangle;
        function get opaqueBackground():Object;
        function set scale9Grid(_arg1:Rectangle):void;
        function setActualSize(_arg1:Number, _arg2:Number):void;
        function set alpha(_arg1:Number):void;
        function set accessibilityProperties(_arg1:AccessibilityProperties):void;
        function get width():Number;
        function hitTestPoint(_arg1:Number, _arg2:Number, _arg3:Boolean=false):Boolean;
        function set cacheAsBitmap(_arg1:Boolean):void;
        function get scaleX():Number;
        function get scaleY():Number;
        function get scrollRect():Rectangle;
        function get mouseX():Number;
        function get mouseY():Number;
        function set height(_arg1:Number):void;
        function set mask(_arg1:DisplayObject):void;
        function getRect(_arg1:DisplayObject):Rectangle;
        function get alpha():Number;
        function set transform(_arg1:Transform):void;
        function move(_arg1:Number, _arg2:Number):void;
        function get loaderInfo():LoaderInfo;
        function get root():DisplayObject;
        function hitTestObject(_arg1:DisplayObject):Boolean;
        function set opaqueBackground(_arg1:Object):void;
        function set visible(_arg1:Boolean):void;
        function get mask():DisplayObject;
        function set x(_arg1:Number):void;
        function set y(_arg1:Number):void;
        function get transform():Transform;
        function set filters(_arg1:Array):void;
        function get x():Number;
        function get y():Number;
        function get filters():Array;
        function set rotation(_arg1:Number):void;
        function get stage():Stage;

    }
}//package mx.core 
