package mx.containers.utilityClasses {
    import mx.core.*;
    import flash.events.*;

    public class ConstraintColumn extends EventDispatcher implements IMXMLObject {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _container:IInvalidating;
        private var _explicitMinWidth:Number;
        mx_internal var _width:Number;
        mx_internal var contentSize:Boolean = false;
        private var _percentWidth:Number;
        private var _explicitWidth:Number;
        private var _explicitMaxWidth:Number;
        private var _x:Number;
        private var _id:String;

        public function get container():IInvalidating{
            return (_container);
        }
        public function get width():Number{
            return (_width);
        }
        public function get percentWidth():Number{
            return (_percentWidth);
        }
        public function set container(_arg1:IInvalidating):void{
            _container = _arg1;
        }
        public function set maxWidth(_arg1:Number):void{
            if (_explicitMaxWidth != _arg1){
                _explicitMaxWidth = _arg1;
                if (container){
                    container.invalidateSize();
                    container.invalidateDisplayList();
                };
                dispatchEvent(new Event("maxWidthChanged"));
            };
        }
        public function set width(_arg1:Number):void{
            if (explicitWidth != _arg1){
                explicitWidth = _arg1;
                if (_width != _arg1){
                    _width = _arg1;
                    if (container){
                        container.invalidateSize();
                        container.invalidateDisplayList();
                    };
                    dispatchEvent(new Event("widthChanged"));
                };
            };
        }
        public function get maxWidth():Number{
            return (_explicitMaxWidth);
        }
        public function get minWidth():Number{
            return (_explicitMinWidth);
        }
        public function get id():String{
            return (_id);
        }
        public function initialized(_arg1:Object, _arg2:String):void{
            this.id = _arg2;
            if (((!(this.width)) && (!(this.percentWidth)))){
                contentSize = true;
            };
        }
        public function set explicitWidth(_arg1:Number):void{
            if (_explicitWidth == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _percentWidth = NaN;
            };
            _explicitWidth = _arg1;
            if (container){
                container.invalidateSize();
                container.invalidateDisplayList();
            };
            dispatchEvent(new Event("explicitWidthChanged"));
        }
        public function setActualWidth(_arg1:Number):void{
            if (_width != _arg1){
                _width = _arg1;
                dispatchEvent(new Event("widthChanged"));
            };
        }
        public function set minWidth(_arg1:Number):void{
            if (_explicitMinWidth != _arg1){
                _explicitMinWidth = _arg1;
                if (container){
                    container.invalidateSize();
                    container.invalidateDisplayList();
                };
                dispatchEvent(new Event("minWidthChanged"));
            };
        }
        public function set percentWidth(_arg1:Number):void{
            if (_percentWidth == _arg1){
                return;
            };
            if (!isNaN(_arg1)){
                _explicitWidth = NaN;
            };
            _percentWidth = _arg1;
            if (container){
                container.invalidateSize();
                container.invalidateDisplayList();
            };
            dispatchEvent(new Event("percentWidthChanged"));
        }
        public function set x(_arg1:Number):void{
            if (_arg1 != _x){
                _x = _arg1;
                dispatchEvent(new Event("xChanged"));
            };
        }
        public function get explicitWidth():Number{
            return (_explicitWidth);
        }
        public function set id(_arg1:String):void{
            _id = _arg1;
        }
        public function get x():Number{
            return (_x);
        }

    }
}//package mx.containers.utilityClasses 
