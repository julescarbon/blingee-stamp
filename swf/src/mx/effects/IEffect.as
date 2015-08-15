package mx.effects {
    import flash.events.*;

    public interface IEffect extends IAbstractEffect {

        function captureMoreStartValues(_arg1:Array):void;
        function get triggerEvent():Event;
        function set targets(_arg1:Array):void;
        function captureStartValues():void;
        function get hideFocusRing():Boolean;
        function get customFilter():EffectTargetFilter;
        function get effectTargetHost():IEffectTargetHost;
        function set triggerEvent(_arg1:Event):void;
        function set hideFocusRing(_arg1:Boolean):void;
        function captureEndValues():void;
        function get target():Object;
        function set customFilter(_arg1:EffectTargetFilter):void;
        function get duration():Number;
        function get perElementOffset():Number;
        function get targets():Array;
        function set effectTargetHost(_arg1:IEffectTargetHost):void;
        function get relevantStyles():Array;
        function set relevantProperties(_arg1:Array):void;
        function set target(_arg1:Object):void;
        function get className():String;
        function get isPlaying():Boolean;
        function deleteInstance(_arg1:IEffectInstance):void;
        function set duration(_arg1:Number):void;
        function createInstances(_arg1:Array=null):Array;
        function end(_arg1:IEffectInstance=null):void;
        function set perElementOffset(_arg1:Number):void;
        function resume():void;
        function stop():void;
        function set filter(_arg1:String):void;
        function createInstance(_arg1:Object=null):IEffectInstance;
        function play(_arg1:Array=null, _arg2:Boolean=false):Array;
        function pause():void;
        function get relevantProperties():Array;
        function get filter():String;
        function reverse():void;
        function getAffectedProperties():Array;
        function set relevantStyles(_arg1:Array):void;

    }
}//package mx.effects 
