package src {
    import flash.events.*;
    import mx.events.*;

    public class Layer implements IEventDispatcher {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _95472323depth:int;
        private var _106642994photo:Photo;
        private var _720898032motionType:int;
        private var _983572238toolType:int;
        private var _1267206133opacity:int;
        private var _3355id:int;

        public function Layer(_arg1:int, _arg2:Photo, _arg3:int, _arg4:int, _arg5:int){
            _bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            id = _arg1;
            photo = _arg2;
            toolType = _arg3;
            depth = _arg4;
            opacity = _arg5;
            motionType = 0;
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (_bindingEventDispatcher.dispatchEvent(_arg1));
        }
        public function get depth():int{
            return (this._95472323depth);
        }
        public function get opacity():int{
            return (this._1267206133opacity);
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (_bindingEventDispatcher.hasEventListener(_arg1));
        }
        public function set depth(_arg1:int):void{
            var _local2:Object = this._95472323depth;
            if (_local2 !== _arg1){
                this._95472323depth = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "depth", _local2, _arg1));
            };
        }
        public function get motionType():int{
            return (this._720898032motionType);
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            _bindingEventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            _bindingEventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function willTrigger(_arg1:String):Boolean{
            return (_bindingEventDispatcher.willTrigger(_arg1));
        }
        public function set opacity(_arg1:int):void{
            var _local2:Object = this._1267206133opacity;
            if (_local2 !== _arg1){
                this._1267206133opacity = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "opacity", _local2, _arg1));
            };
        }
        public function get id():int{
            return (this._3355id);
        }
        public function set motionType(_arg1:int):void{
            var _local2:Object = this._720898032motionType;
            if (_local2 !== _arg1){
                this._720898032motionType = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "motionType", _local2, _arg1));
            };
        }
        public function set photo(_arg1:Photo):void{
            var _local2:Object = this._106642994photo;
            if (_local2 !== _arg1){
                this._106642994photo = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "photo", _local2, _arg1));
            };
        }
        public function set toolType(_arg1:int):void{
            var _local2:Object = this._983572238toolType;
            if (_local2 !== _arg1){
                this._983572238toolType = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "toolType", _local2, _arg1));
            };
        }
        public function get photo():Photo{
            return (this._106642994photo);
        }
        public function set id(_arg1:int):void{
            var _local2:Object = this._3355id;
            if (_local2 !== _arg1){
                this._3355id = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", _local2, _arg1));
            };
        }
        public function get toolType():int{
            return (this._983572238toolType);
        }

    }
}//package src 
