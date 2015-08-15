package mx.managers.systemClasses {
    import flash.display.*;
    import flash.events.*;

    public class StageEventProxy {

        private var listener:Function;

        public function StageEventProxy(_arg1:Function){
            this.listener = _arg1;
        }
        public function stageListener(_arg1:Event):void{
            if ((_arg1.target is Stage)){
                listener(_arg1);
            };
        }

    }
}//package mx.managers.systemClasses 
