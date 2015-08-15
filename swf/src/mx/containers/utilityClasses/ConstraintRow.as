package mx.containers.utilityClasses {
    import mx.core.*;
    import flash.events.*;

    public class ConstraintRow extends EventDispatcher implements IMXMLObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _container:IInvalidating;
        mx_internal var _height:Number;
        private var _explicitMinHeight:Number;
        private var _y:Number;
        private var _percentHeight:Number;
        private var _explicitMaxHeight:Number;
        mx_internal var contentSize:Boolean = false;
        private var _explicitHeight:Number;
        private var _id:String;

        public function get container():IInvalidating{
            return (_container);
        }
        public function set container(_arg1:IInvalidating):void{
            _container = _arg1;
        }
        public function set y(_arg1:Number):void{
            if (_arg1 != _y){
                _y = _arg1;
                dispatchEvent(new Event("yChanged"));
            };
        }
        public function set height(_arg1:Number):void{
            if (explicitHeight != _arg1){
                explicitHeight = _arg1;
                if (_height != _arg1){
                    _height = _arg1;
                    if (container){
                        container.invalidateSize();
                        container.invalidateDisplayList();
                    };
                    dispatchEvent(new Event("heightChanged"));
                };
            };
        }
        public function set maxHeight(_arg1:Number):void{
            if (_explicitMaxHeight != _arg1){
                _explicitMaxHeight = _arg1;
                if (container){
                    container.invalidateSize();
                    container.invalidateDisplayList();
                };
                dispatchEvent(new Event("maxHeightChanged"));
            };
        }
        public function setActualHeight(_arg1:Number):void{
            if (_height != _arg1){
                _height = _arg1;
                dispatchEvent(new Event("heightChanged"));
            };
        }
        public function get minHeight():Number{
            return (_explicitMinHeight);
        }
        public function get id():String{
            return (_id);
        }
        public function set percentHeight(_arg1:Number):void{
            if (_percentHeight == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _explicitHeight = NaN;
            };
            _percentHeight = _arg1;
            if (container){
                container.invalidateSize();
                container.invalidateDisplayList();
            };
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            this.id = _arg2;
            if (((!(this.height)) && (!(this.percentHeight)))){
                contentSize = true;
            };
        }
        public function get percentHeight():Number{
            return (_percentHeight);
        }
        public function get height():Number{
            return (_height);
        }
        public function get maxHeight():Number{
            return (_explicitMaxHeight);
        }
        public function set minHeight(_arg1:Number):void{
            if (_explicitMinHeight != _arg1){
                _explicitMinHeight = _arg1;
                if (container){
                    container.invalidateSize();
                    container.invalidateDisplayList();
                };
                dispatchEvent(new Event("minHeightChanged"));
            };
        }
        public function set id(_arg1:String):void{
            _id = _arg1;
        }
        public function get y():Number{
            return (_y);
        }
        public function get explicitHeight():Number{
            return (_explicitHeight);
        }
        public function set explicitHeight(_arg1:Number):void{
            if (_explicitHeight == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _percentHeight = NaN;
            };
            _explicitHeight = _arg1;
            if (container){
                container.invalidateSize();
                container.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitHeightChanged"));
        }

    }
}//package mx.containers.utilityClasses 
