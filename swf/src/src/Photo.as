package src {
    import flash.events.*;
    import mx.events.*;

    public class Photo implements IEventDispatcher {

        private var _bindingEventDispatcher:EventDispatcher;
        private var _423418668isLocked:Boolean = false;
        private var _1330532588thumbnail:String;
        private var _3373707name:String;
        private var _1724546052description:String;
        private var _1813949571displaySource:String;
        private var _3355id:Number;
        private var _896505829source:String;

        public function Photo(_arg1:XML){
            _bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
            super();
            Fill(_arg1);
        }
        public function dispatchEvent(_arg1:Event):Boolean{
            return (_bindingEventDispatcher.dispatchEvent(_arg1));
        }
        public function set displaySource(_arg1:String):void{
            var _local2:Object = this._1813949571displaySource;
            if (_local2 !== _arg1){
                this._1813949571displaySource = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "displaySource", _local2, _arg1));
            };
        }
        public function hasEventListener(_arg1:String):Boolean{
            return (_bindingEventDispatcher.hasEventListener(_arg1));
        }
        public function get displaySource():String{
            return (this._1813949571displaySource);
        }
        public function set id(_arg1:Number):void{
            var _local2:Object = this._3355id;
            if (_local2 !== _arg1){
                this._3355id = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "id", _local2, _arg1));
            };
        }
        public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void{
            _bindingEventDispatcher.removeEventListener(_arg1, _arg2, _arg3);
        }
        public function get name():String{
            return (this._3373707name);
        }
        public function get isLocked():Boolean{
            return (this._423418668isLocked);
        }
        public function set name(_arg1:String):void{
            var _local2:Object = this._3373707name;
            if (_local2 !== _arg1){
                this._3373707name = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "name", _local2, _arg1));
            };
        }
        public function set thumbnail(_arg1:String):void{
            var _local2:Object = this._1330532588thumbnail;
            if (_local2 !== _arg1){
                this._1330532588thumbnail = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumbnail", _local2, _arg1));
            };
        }
        public function get source():String{
            return (this._896505829source);
        }
        public function willTrigger(_arg1:String):Boolean{
            return (_bindingEventDispatcher.willTrigger(_arg1));
        }
        public function get id():Number{
            return (this._3355id);
        }
        protected function Fill(_arg1:XML):void{
            this.id = Number(_arg1.@id);
            this.name = _arg1.@name;
            this.description = _arg1.@description;
            this.source = _arg1.@swfHref;
            this.thumbnail = _arg1.@thumbHref;
            if ((((this.thumbnail == null)) || ((this.thumbnail.length == 0)))){
                this.thumbnail = this.source;
            };
        }
        public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void{
            _bindingEventDispatcher.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
        public function set isLocked(_arg1:Boolean):void{
            var _local2:Object = this._423418668isLocked;
            if (_local2 !== _arg1){
                this._423418668isLocked = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "isLocked", _local2, _arg1));
            };
        }
        public function set source(_arg1:String):void{
            var _local2:Object = this._896505829source;
            if (_local2 !== _arg1){
                this._896505829source = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "source", _local2, _arg1));
            };
        }
        public function set description(_arg1:String):void{
            var _local2:Object = this._1724546052description;
            if (_local2 !== _arg1){
                this._1724546052description = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "description", _local2, _arg1));
            };
        }
        public function get thumbnail():String{
            return (this._1330532588thumbnail);
        }
        public function get description():String{
            return (this._1724546052description);
        }

    }
}//package src 
