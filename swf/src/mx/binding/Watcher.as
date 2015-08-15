package mx.binding {
    import mx.collections.errors.*;

    public class Watcher {

        mx_internal static const VERSION:String = "3.2.0.3958";

        protected var children:Array;
        public var value:Object;
        protected var cloneIndex:int;
        protected var listeners:Array;

        public function Watcher(_arg1:Array=null){
            this.listeners = _arg1;
        }
        public function removeChildren(_arg1:int):void{
            children.splice(_arg1);
        }
        public function updateChildren():void{
            var _local1:int;
            var _local2:int;
            if (children){
                _local1 = children.length;
                _local2 = 0;
                while (_local2 < _local1) {
                    children[_local2].updateParent(this);
                    _local2++;
                };
            };
        }
        protected function shallowClone():Watcher{
            return (new Watcher());
        }
        protected function wrapUpdate(_arg1:Function):void{
            var wrappedFunction:* = _arg1;
            try {
                wrappedFunction.apply(this);
            } catch(itemPendingError:ItemPendingError) {
                value = null;
            } catch(rangeError:RangeError) {
                value = null;
            } catch(error:Error) {
                if (((((((((!((error.errorID == 1006))) && (!((error.errorID == 1009))))) && (!((error.errorID == 1010))))) && (!((error.errorID == 1055))))) && (!((error.errorID == 1069))))){
                    throw (error);
                };
            };
        }
        private function valueChanged(_arg1:Object):Boolean{
            if ((((_arg1 == null)) && ((value == null)))){
                return (false);
            };
            var _local2 = typeof(value);
            if (_local2 == "string"){
                if ((((_arg1 == null)) && ((value == "")))){
                    return (false);
                };
                return (!((_arg1 == value)));
            };
            if (_local2 == "number"){
                if ((((_arg1 == null)) && ((value == 0)))){
                    return (false);
                };
                return (!((_arg1 == value)));
            };
            if (_local2 == "boolean"){
                if ((((_arg1 == null)) && ((value == false)))){
                    return (false);
                };
                return (!((_arg1 == value)));
            };
            return (true);
        }
        public function notifyListeners(_arg1:Boolean):void{
            var _local2:int;
            var _local3:int;
            if (listeners){
                _local2 = listeners.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    listeners[_local3].watcherFired(_arg1, cloneIndex);
                    _local3++;
                };
            };
        }
        protected function deepClone(_arg1:int):Watcher{
            var _local3:int;
            var _local4:int;
            var _local5:Watcher;
            var _local2:Watcher = shallowClone();
            _local2.cloneIndex = _arg1;
            if (listeners){
                _local2.listeners = listeners.concat();
            };
            if (children){
                _local3 = children.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local5 = children[_local4].deepClone(_arg1);
                    _local2.addChild(_local5);
                    _local4++;
                };
            };
            return (_local2);
        }
        public function updateParent(_arg1:Object):void{
        }
        public function addChild(_arg1:Watcher):void{
            if (!children){
                children = [_arg1];
            } else {
                children.push(_arg1);
            };
            _arg1.updateParent(this);
        }

    }
}//package mx.binding 
