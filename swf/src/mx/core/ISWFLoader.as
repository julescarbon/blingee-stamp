package mx.core {
    import flash.geom.*;

    public interface ISWFLoader extends ISWFBridgeProvider {

        function getVisibleApplicationRect(_arg1:Boolean=false):Rectangle;
        function set loadForCompatibility(_arg1:Boolean):void;
        function get loadForCompatibility():Boolean;

    }
}//package mx.core 
