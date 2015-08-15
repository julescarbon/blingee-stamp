package mx.managers.layoutClasses {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;

    public class PriorityQueue {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var maxPriority:int = -1;
        private var arrayOfArrays:Array;
        private var minPriority:int = 0;

        public function PriorityQueue(){
            arrayOfArrays = [];
            super();
        }
        public function addObject(_arg1:Object, _arg2:int):void{
            if (!arrayOfArrays[_arg2]){
                arrayOfArrays[_arg2] = [];
            };
            arrayOfArrays[_arg2].push(_arg1);
            if (maxPriority < minPriority){
                minPriority = (maxPriority = _arg2);
            } else {
                if (_arg2 < minPriority){
                    minPriority = _arg2;
                };
                if (_arg2 > maxPriority){
                    maxPriority = _arg2;
                };
            };
        }
        public function removeSmallest():Object{
            var _local1:Object;
            if (minPriority <= maxPriority){
                while (((!(arrayOfArrays[minPriority])) || ((arrayOfArrays[minPriority].length == 0)))) {
                    minPriority++;
                    if (minPriority > maxPriority){
                        return (null);
                    };
                };
                _local1 = arrayOfArrays[minPriority].shift();
                while (((!(arrayOfArrays[minPriority])) || ((arrayOfArrays[minPriority].length == 0)))) {
                    minPriority++;
                    if (minPriority > maxPriority){
                        break;
                    };
                };
            };
            return (_local1);
        }
        public function removeLargestChild(_arg1:ILayoutManagerClient):Object{
            var _local5:int;
            var _local2:Object;
            var _local3:int = maxPriority;
            var _local4:int = _arg1.nestLevel;
            while (_local4 <= _local3) {
                if (((arrayOfArrays[_local3]) && ((arrayOfArrays[_local3].length > 0)))){
                    _local5 = 0;
                    while (_local5 < arrayOfArrays[_local3].length) {
                        if (contains(DisplayObject(_arg1), arrayOfArrays[_local3][_local5])){
                            _local2 = arrayOfArrays[_local3][_local5];
                            arrayOfArrays[_local3].splice(_local5, 1);
                            return (_local2);
                        };
                        _local5++;
                    };
                    _local3--;
                } else {
                    if (_local3 == maxPriority){
                        maxPriority--;
                    };
                    _local3--;
                    if (_local3 < _local4){
                        break;
                    };
                };
            };
            return (_local2);
        }
        public function isEmpty():Boolean{
            return ((minPriority > maxPriority));
        }
        public function removeLargest():Object{
            var _local1:Object;
            if (minPriority <= maxPriority){
                while (((!(arrayOfArrays[maxPriority])) || ((arrayOfArrays[maxPriority].length == 0)))) {
                    maxPriority--;
                    if (maxPriority < minPriority){
                        return (null);
                    };
                };
                _local1 = arrayOfArrays[maxPriority].shift();
                while (((!(arrayOfArrays[maxPriority])) || ((arrayOfArrays[maxPriority].length == 0)))) {
                    maxPriority--;
                    if (maxPriority < minPriority){
                        break;
                    };
                };
            };
            return (_local1);
        }
        public function removeSmallestChild(_arg1:ILayoutManagerClient):Object{
            var _local4:int;
            var _local2:Object;
            var _local3:int = _arg1.nestLevel;
            while (_local3 <= maxPriority) {
                if (((arrayOfArrays[_local3]) && ((arrayOfArrays[_local3].length > 0)))){
                    _local4 = 0;
                    while (_local4 < arrayOfArrays[_local3].length) {
                        if (contains(DisplayObject(_arg1), arrayOfArrays[_local3][_local4])){
                            _local2 = arrayOfArrays[_local3][_local4];
                            arrayOfArrays[_local3].splice(_local4, 1);
                            return (_local2);
                        };
                        _local4++;
                    };
                    _local3++;
                } else {
                    if (_local3 == minPriority){
                        minPriority++;
                    };
                    _local3++;
                    if (_local3 > maxPriority){
                        break;
                    };
                };
            };
            return (_local2);
        }
        public function removeAll():void{
            arrayOfArrays.splice(0);
            minPriority = 0;
            maxPriority = -1;
        }
        private function contains(_arg1:DisplayObject, _arg2:DisplayObject):Boolean{
            var _local3:IChildList;
            if ((_arg1 is IRawChildrenContainer)){
                _local3 = IRawChildrenContainer(_arg1).rawChildren;
                return (_local3.contains(_arg2));
            };
            if ((_arg1 is DisplayObjectContainer)){
                return (DisplayObjectContainer(_arg1).contains(_arg2));
            };
            return ((_arg1 == _arg2));
        }

    }
}//package mx.managers.layoutClasses 
