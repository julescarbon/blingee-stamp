package mx.styles {
    import flash.events.*;

    public interface IStyleManager {

        function isColorName(_arg1:String):Boolean;
        function registerParentDisplayListInvalidatingStyle(_arg1:String):void;
        function registerInheritingStyle(_arg1:String):void;
        function set stylesRoot(_arg1:Object):void;
        function get typeSelectorCache():Object;
        function styleDeclarationsChanged():void;
        function setStyleDeclaration(_arg1:String, _arg2:CSSStyleDeclaration, _arg3:Boolean):void;
        function isParentDisplayListInvalidatingStyle(_arg1:String):Boolean;
        function isSizeInvalidatingStyle(_arg1:String):Boolean;
        function get inheritingStyles():Object;
        function isValidStyleValue(_arg1):Boolean;
        function isParentSizeInvalidatingStyle(_arg1:String):Boolean;
        function getColorName(_arg1:Object):uint;
        function set typeSelectorCache(_arg1:Object):void;
        function unloadStyleDeclarations(_arg1:String, _arg2:Boolean=true):void;
        function getColorNames(_arg1:Array):void;
        function loadStyleDeclarations(_arg1:String, _arg2:Boolean=true, _arg3:Boolean=false):IEventDispatcher;
        function isInheritingStyle(_arg1:String):Boolean;
        function set inheritingStyles(_arg1:Object):void;
        function get stylesRoot():Object;
        function initProtoChainRoots():void;
        function registerColorName(_arg1:String, _arg2:uint):void;
        function registerParentSizeInvalidatingStyle(_arg1:String):void;
        function registerSizeInvalidatingStyle(_arg1:String):void;
        function clearStyleDeclaration(_arg1:String, _arg2:Boolean):void;
        function isInheritingTextFormatStyle(_arg1:String):Boolean;
        function getStyleDeclaration(_arg1:String):CSSStyleDeclaration;

    }
}//package mx.styles 
