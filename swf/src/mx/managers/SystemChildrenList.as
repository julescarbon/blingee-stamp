package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;

    public class SystemChildrenList implements IChildList {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var lowerBoundReference:QName;
        private var upperBoundReference:QName;
        private var owner:SystemManager;

        public function SystemChildrenList(_arg1:SystemManager, _arg2:QName, _arg3:QName){
            this.owner = _arg1;
            this.lowerBoundReference = _arg2;
            this.upperBoundReference = _arg3;
        }
        public function getChildAt(_arg1:int):DisplayObject{
            var _local2:DisplayObject = owner.mx_internal::rawChildren_getChildAt((owner[lowerBoundReference] + _arg1));
            return (_local2);
        }
        public function getChildByName(_arg1:String):DisplayObject{
            return (owner.mx_internal::rawChildren_getChildByName(_arg1));
        }
        public function removeChildAt(_arg1:int):DisplayObject{
            var _local2:DisplayObject = owner.mx_internal::rawChildren_removeChildAt((_arg1 + owner[lowerBoundReference]));
            var _local3 = owner;
            var _local4 = upperBoundReference;
            var _local5 = (_local3[_local4] - 1);
            _local3[_local4] = _local5;
            return (_local2);
        }
        public function getChildIndex(_arg1:DisplayObject):int{
            var _local2:int = owner.mx_internal::rawChildren_getChildIndex(_arg1);
            _local2 = (_local2 - owner[lowerBoundReference]);
            return (_local2);
        }
        public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            var _local3 = owner;
            _local3.mx_internal::rawChildren_addChildAt(_arg1, (owner[lowerBoundReference] + _arg2));
            _local3 = owner;
            var _local4 = upperBoundReference;
            var _local5 = (_local3[_local4] + 1);
            _local3[_local4] = _local5;
            return (_arg1);
        }
        public function getObjectsUnderPoint(_arg1:Point):Array{
            return (owner.mx_internal::rawChildren_getObjectsUnderPoint(_arg1));
        }
        public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            var _local3 = owner;
            _local3.mx_internal::rawChildren_setChildIndex(_arg1, (owner[lowerBoundReference] + _arg2));
        }
        public function get numChildren():int{
            return ((owner[upperBoundReference] - owner[lowerBoundReference]));
        }
        public function contains(_arg1:DisplayObject):Boolean{
            var _local2:int;
            if (((!((_arg1 == owner))) && (owner.mx_internal::rawChildren_contains(_arg1)))){
                while (_arg1.parent != owner) {
                    _arg1 = _arg1.parent;
                };
                _local2 = owner.mx_internal::rawChildren_getChildIndex(_arg1);
                if ((((_local2 >= owner[lowerBoundReference])) && ((_local2 < owner[upperBoundReference])))){
                    return (true);
                };
            };
            return (false);
        }
        public function removeChild(_arg1:DisplayObject):DisplayObject{
            var _local2:int = owner.mx_internal::rawChildren_getChildIndex(_arg1);
            if ((((owner[lowerBoundReference] <= _local2)) && ((_local2 < owner[upperBoundReference])))){
                var _local3 = owner;
                _local3.mx_internal::rawChildren_removeChild(_arg1);
                _local3 = owner;
                var _local4 = upperBoundReference;
                var _local5 = (_local3[_local4] - 1);
                _local3[_local4] = _local5;
            };
            return (_arg1);
        }
        public function addChild(_arg1:DisplayObject):DisplayObject{
            var _local2 = owner;
            _local2.mx_internal::rawChildren_addChildAt(_arg1, owner[upperBoundReference]);
            _local2 = owner;
            var _local3 = upperBoundReference;
            var _local4 = (_local2[_local3] + 1);
            _local2[_local3] = _local4;
            return (_arg1);
        }

    }
}//package mx.managers 
