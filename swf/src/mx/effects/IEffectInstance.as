package mx.effects {
    import flash.events.*;
    import mx.effects.effectClasses.*;

    public interface IEffectInstance {

        function get playheadTime():Number;
        function get triggerEvent():Event;
        function set triggerEvent(_arg1:Event):void;
        function get hideFocusRing():Boolean;
        function initEffect(_arg1:Event):void;
        function set startDelay(_arg1:int):void;
        function get effectTargetHost():IEffectTargetHost;
        function finishEffect():void;
        function set hideFocusRing(_arg1:Boolean):void;
        function finishRepeat():void;
        function set repeatDelay(_arg1:int):void;
        function get effect():IEffect;
        function startEffect():void;
        function get duration():Number;
        function get target():Object;
        function get startDelay():int;
        function stop():void;
        function set effectTargetHost(_arg1:IEffectTargetHost):void;
        function set propertyChanges(_arg1:PropertyChanges):void;
        function set effect(_arg1:IEffect):void;
        function get className():String;
        function set duration(_arg1:Number):void;
        function set target(_arg1:Object):void;
        function end():void;
        function resume():void;
        function get propertyChanges():PropertyChanges;
        function set repeatCount(_arg1:int):void;
        function reverse():void;
        function get repeatCount():int;
        function pause():void;
        function get repeatDelay():int;
        function set suspendBackgroundProcessing(_arg1:Boolean):void;
        function play():void;
        function get suspendBackgroundProcessing():Boolean;

    }
}//package mx.effects 
