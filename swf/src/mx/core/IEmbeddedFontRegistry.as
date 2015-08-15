package mx.core {

    public interface IEmbeddedFontRegistry {

        function getAssociatedModuleFactory(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):IFlexModuleFactory;
        function registerFont(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):void;
        function deregisterFont(_arg1:EmbeddedFont, _arg2:IFlexModuleFactory):void;
        function getFonts():Array;

    }
}//package mx.core 
