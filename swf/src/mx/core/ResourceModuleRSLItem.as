package mx.core {
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;

    public class ResourceModuleRSLItem extends RSLItem {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function ResourceModuleRSLItem(_arg1:String){
            super(_arg1);
        }
        private function resourceErrorHandler(_arg1:ResourceEvent):void{
            var _local2:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
            _local2.text = _arg1.errorText;
            super.itemErrorHandler(_local2);
        }
        override public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void{
            chainedProgressHandler = _arg1;
            chainedCompleteHandler = _arg2;
            chainedIOErrorHandler = _arg3;
            chainedSecurityErrorHandler = _arg4;
            chainedRSLErrorHandler = _arg5;
            var _local6:IResourceManager = ResourceManager.getInstance();
            var _local7:IEventDispatcher = _local6.loadResourceModule(url);
            _local7.addEventListener(ResourceEvent.PROGRESS, itemProgressHandler);
            _local7.addEventListener(ResourceEvent.COMPLETE, itemCompleteHandler);
            _local7.addEventListener(ResourceEvent.ERROR, resourceErrorHandler);
        }

    }
}//package mx.core 
