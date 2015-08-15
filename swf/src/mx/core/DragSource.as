package mx.core {

    public class DragSource {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var formatHandlers:Object;
        private var dataHolder:Object;
        private var _formats:Array;

        public function DragSource(){
            dataHolder = {};
            formatHandlers = {};
            _formats = [];
            super();
        }
        public function hasFormat(_arg1:String):Boolean{
            var _local2:int = _formats.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (_formats[_local3] == _arg1){
                    return (true);
                };
                _local3++;
            };
            return (false);
        }
        public function addData(_arg1:Object, _arg2:String):void{
            _formats.push(_arg2);
            dataHolder[_arg2] = _arg1;
        }
        public function dataForFormat(_arg1:String):Object{
            var _local2:Object = dataHolder[_arg1];
            if (_local2){
                return (_local2);
            };
            if (formatHandlers[_arg1]){
                return (formatHandlers[_arg1]());
            };
            return (null);
        }
        public function addHandler(_arg1:Function, _arg2:String):void{
            _formats.push(_arg2);
            formatHandlers[_arg2] = _arg1;
        }
        public function get formats():Array{
            return (_formats);
        }

    }
}//package mx.core 
