package src {
    import flash.events.*;
    import mx.events.*;
    import mx.collections.*;

    public class Gallery implements IEventDispatcher {

        public static const TYPE_INK_SET:Number = 2;
        public static const TYPE_GOODIE_BAG:Number = 1;
        public static const TYPE_DEFAULT:Number = 0;

        private var _3373707name:String;
        private var _3575610type:Number;
        private var _1191572123selected:int;
        private var _1724546052description:String;
        private var _bindingEventDispatcher:EventDispatcher;
        private var _989034367photos:ArrayCollection;

        public function Gallery(_arg1:XML){
            _bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            photos = new ArrayCollection();
            Fill(_arg1);
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (_bindingEventDispatcher.dispatchEvent(_arg1));
        }
        public function get photos():ArrayCollection{
            return (this._989034367photos);
        }
        public function set photos(_arg1:ArrayCollection):void{
            var _local2:Object = this._989034367photos;
            if (_local2 !== _arg1){
                this._989034367photos = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "photos", _local2, _arg1));
            };
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (_bindingEventDispatcher.hasEventListener(_arg1));
        }
        public function willTrigger(_arg1:String):Boolean{
            return (_bindingEventDispatcher.willTrigger(_arg1));
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            _bindingEventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        public function get name():String{
            return (this._3373707name);
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            _bindingEventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function set name(_arg1:String):void{
            var _local2:Object = this._3373707name;
            if (_local2 !== _arg1){
                this._3373707name = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", _local2, _arg1));
            };
        }
        public function get selected():int{
            return (this._1191572123selected);
        }
        protected function Fill(_arg1:XML):void{
            var _local2:XML;
            var _local3:Photo;
            this.name = _arg1.@name;
            this.description = _arg1.@description;
            this.type = ((null)==_arg1.@type) ? TYPE_DEFAULT : Number(_arg1.@type);
            this.selected = 0;
            for each (_local2 in _arg1.Blingee) {
                _local3 = new Photo(_local2);
                photos.addItem(_local3);
            };
        }
        public function get isGoodieBag():Boolean{
            return ((TYPE_GOODIE_BAG == this.type));
        }
        public function get isInkSet():Boolean{
            return ((TYPE_INK_SET == this.type));
        }
        public function set type(_arg1:Number):void{
            var _local2:Object = this._3575610type;
            if (_local2 !== _arg1){
                this._3575610type = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "type", _local2, _arg1));
            };
        }
        public function set selected(_arg1:int):void{
            var _local2:Object = this._1191572123selected;
            if (_local2 !== _arg1){
                this._1191572123selected = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", _local2, _arg1));
            };
        }
        public function set description(_arg1:String):void{
            var _local2:Object = this._1724546052description;
            if (_local2 !== _arg1){
                this._1724546052description = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", _local2, _arg1));
            };
        }
        public function get type():Number{
            return (this._3575610type);
        }
        public function get description():String{
            return (this._1724546052description);
        }

    }
}//package src 
