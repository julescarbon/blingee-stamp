package mx.resources {
    import flash.events.*;
    import flash.system.*;

    public interface IResourceManager extends IEventDispatcher {

        function loadResourceModule(_arg1:String, _arg2:Boolean=true, _arg3:ApplicationDomain=null, _arg4:SecurityDomain=null):IEventDispatcher;
        function getBoolean(_arg1:String, _arg2:String, _arg3:String=null):Boolean;
        function getClass(_arg1:String, _arg2:String, _arg3:String=null):Class;
        function getLocales():Array;
        function removeResourceBundlesForLocale(_arg1:String):void;
        function getResourceBundle(_arg1:String, _arg2:String):IResourceBundle;
        function get localeChain():Array;
        function getInt(_arg1:String, _arg2:String, _arg3:String=null):int;
        function update():void;
        function set localeChain(_arg1:Array):void;
        function getUint(_arg1:String, _arg2:String, _arg3:String=null):uint;
        function addResourceBundle(_arg1:IResourceBundle):void;
        function getStringArray(_arg1:String, _arg2:String, _arg3:String=null):Array;
        function getBundleNamesForLocale(_arg1:String):Array;
        function removeResourceBundle(_arg1:String, _arg2:String):void;
        function getObject(_arg1:String, _arg2:String, _arg3:String=null);
        function getString(_arg1:String, _arg2:String, _arg3:Array=null, _arg4:String=null):String;
        function installCompiledResourceBundles(_arg1:ApplicationDomain, _arg2:Array, _arg3:Array):void;
        function unloadResourceModule(_arg1:String, _arg2:Boolean=true):void;
        function getPreferredLocaleChain():Array;
        function findResourceBundleWithResource(_arg1:String, _arg2:String):IResourceBundle;
        function initializeLocaleChain(_arg1:Array):void;
        function getNumber(_arg1:String, _arg2:String, _arg3:String=null):Number;

    }
}//package mx.resources 
