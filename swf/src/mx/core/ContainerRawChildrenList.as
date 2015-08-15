package mx.core {
    import flash.display.*;
    import flash.geom.*;

    public class ContainerRawChildrenList implements IChildList {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var owner:Container;

        public function ContainerRawChildrenList(_arg1:Container){
            this.owner = _arg1;
        }
        public function addChild(_arg1:DisplayObject):DisplayObject{
            return (owner.mx_internal::rawChildren_addChild(_arg1));
        }
        public function getChildIndex(_arg1:DisplayObject):int{
            return (owner.mx_internal::rawChildren_getChildIndex(_arg1));
        }
        public function setChildIndex(_arg1:DisplayObject, _arg2:int):void{
            var _local3 = owner;
            _local3.mx_internal::rawChildren_setChildIndex(_arg1, _arg2);
        }
        public function getChildByName(_arg1:String):DisplayObject{
            return (owner.mx_internal::rawChildren_getChildByName(_arg1));
        }
        public function removeChildAt(_arg1:int):DisplayObject{
            return (owner.mx_internal::rawChildren_removeChildAt(_arg1));
        }
        public function get numChildren():int{
            return (owner.mx_internal::$numChildren);
        }
        public function addChildAt(_arg1:DisplayObject, _arg2:int):DisplayObject{
            return (owner.mx_internal::rawChildren_addChildAt(_arg1, _arg2));
        }
        public function getObjectsUnderPoint(_arg1:Point):Array{
            return (owner.mx_internal::rawChildren_getObjectsUnderPoint(_arg1));
        }
        public function contains(_arg1:DisplayObject):Boolean{
            return (owner.mx_internal::rawChildren_contains(_arg1));
        }
        public function removeChild(_arg1:DisplayObject):DisplayObject{
            return (owner.mx_internal::rawChildren_removeChild(_arg1));
        }
        public function getChildAt(_arg1:int):DisplayObject{
            return (owner.mx_internal::rawChildren_getChildAt(_arg1));
        }

    }
}//package mx.core 
