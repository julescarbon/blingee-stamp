package mx.core {
    import flash.events.*;

    public class RSLListLoader {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var chainedSecurityErrorHandler:Function;
        private var chainedIOErrorHandler:Function;
        private var rslList:Array;
        private var chainedRSLErrorHandler:Function;
        private var chainedCompleteHandler:Function;
        private var currentIndex:int = 0;
        private var chainedProgressHandler:Function;

        public function RSLListLoader(_arg1:Array){
            rslList = [];
            super();
            this.rslList = _arg1;
        }
        private function loadNext():void{
            if (!isDone()){
                currentIndex++;
                if (currentIndex < rslList.length){
                    rslList[currentIndex].load(chainedProgressHandler, listCompleteHandler, listIOErrorHandler, listSecurityErrorHandler, chainedRSLErrorHandler);
                };
            };
        }
        public function getIndex():int{
            return (currentIndex);
        }
        public function load(_arg1:Function, _arg2:Function, _arg3:Function, _arg4:Function, _arg5:Function):void{
            chainedProgressHandler = _arg1;
            chainedCompleteHandler = _arg2;
            chainedIOErrorHandler = _arg3;
            chainedSecurityErrorHandler = _arg4;
            chainedRSLErrorHandler = _arg5;
            currentIndex = -1;
            loadNext();
        }
        private function listCompleteHandler(_arg1:Event):void{
            if (chainedCompleteHandler != null){
                chainedCompleteHandler(_arg1);
            };
            loadNext();
        }
        public function isDone():Boolean{
            return ((currentIndex >= rslList.length));
        }
        private function listSecurityErrorHandler(_arg1:Event):void{
            if (chainedSecurityErrorHandler != null){
                chainedSecurityErrorHandler(_arg1);
            };
        }
        public function getItemCount():int{
            return (rslList.length);
        }
        public function getItem(_arg1:int):RSLItem{
            if ((((_arg1 < 0)) || ((_arg1 >= rslList.length)))){
                return (null);
            };
            return (rslList[_arg1]);
        }
        private function listIOErrorHandler(_arg1:Event):void{
            if (chainedIOErrorHandler != null){
                chainedIOErrorHandler(_arg1);
            };
        }

    }
}//package mx.core 
