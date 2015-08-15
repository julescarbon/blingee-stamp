package mx.styles {

    public interface IStyleClient extends ISimpleStyleClient {

        function regenerateStyleCache(_arg1:Boolean):void;
        function get className():String;
        function clearStyle(_arg1:String):void;
        function getClassStyleDeclarations():Array;
        function get inheritingStyles():Object;
        function set nonInheritingStyles(_arg1:Object):void;
        function setStyle(_arg1:String, _arg2):void;
        function get styleDeclaration():CSSStyleDeclaration;
        function set styleDeclaration(_arg1:CSSStyleDeclaration):void;
        function get nonInheritingStyles():Object;
        function set inheritingStyles(_arg1:Object):void;
        function getStyle(_arg1:String);
        function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void;
        function registerEffects(_arg1:Array):void;

    }
}//package mx.styles 
