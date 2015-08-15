package mx.preloaders {
    import flash.display.*;
    import flash.events.*;

    public interface IPreloaderDisplay extends IEventDispatcher {

        function set backgroundAlpha(_arg1:Number):void;
        function get stageHeight():Number;
        function get stageWidth():Number;
        function set backgroundColor(_arg1:uint):void;
        function set preloader(_arg1:Sprite):void;
        function get backgroundImage():Object;
        function get backgroundSize():String;
        function get backgroundAlpha():Number;
        function set stageHeight(_arg1:Number):void;
        function get backgroundColor():uint;
        function set stageWidth(_arg1:Number):void;
        function set backgroundImage(_arg1:Object):void;
        function set backgroundSize(_arg1:String):void;
        function initialize():void;

    }
}//package mx.preloaders 
