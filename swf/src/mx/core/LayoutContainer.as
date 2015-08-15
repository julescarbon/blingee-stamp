package mx.core {
    import flash.events.*;
    import mx.containers.*;
    import mx.containers.utilityClasses.*;

    public class LayoutContainer extends Container implements IConstraintLayout {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var useProgressiveLayout:Boolean = false;

        private var _constraintColumns:Array;
        protected var layoutObject:Layout;
        private var _layout:String = "vertical";
        private var processingCreationQueue:Boolean = false;
        protected var boxLayoutClass:Class;
        private var resizeHandlerAdded:Boolean = false;
        private var preloadObj:Object;
        private var creationQueue:Array;
        private var _constraintRows:Array;
        protected var canvasLayoutClass:Class;

        public function LayoutContainer(){
            layoutObject = new BoxLayout();
            canvasLayoutClass = CanvasLayout;
            boxLayoutClass = BoxLayout;
            creationQueue = [];
            _constraintColumns = [];
            _constraintRows = [];
            super();
            layoutObject.target = this;
        }
        public function get constraintColumns():Array{
            return (_constraintColumns);
        }
        override mx_internal function get usePadding():Boolean{
            return (!((layout == ContainerLayout.ABSOLUTE)));
        }
        override protected function layoutChrome(_arg1:Number, _arg2:Number):void{
            super.layoutChrome(_arg1, _arg2);
            if (!doingLayout){
                createBorder();
            };
        }
        public function set constraintColumns(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            if (_arg1 != _constraintColumns){
                _local2 = _arg1.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    ConstraintColumn(_arg1[_local3]).container = this;
                    _local3++;
                };
                _constraintColumns = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }
        public function set layout(_arg1:String):void{
            if (_layout != _arg1){
                _layout = _arg1;
                if (layoutObject){
                    layoutObject.target = null;
                };
                if (_layout == ContainerLayout.ABSOLUTE){
                    layoutObject = new canvasLayoutClass();
                } else {
                    layoutObject = new boxLayoutClass();
                    if (_layout == ContainerLayout.VERTICAL){
                        BoxLayout(layoutObject).direction = BoxDirection.VERTICAL;
                    } else {
                        BoxLayout(layoutObject).direction = BoxDirection.HORIZONTAL;
                    };
                };
                if (layoutObject){
                    layoutObject.target = this;
                };
                invalidateSize();
                invalidateDisplayList();
                dispatchEvent(new Event("layoutChanged"));
            };
        }
        public function get constraintRows():Array{
            return (_constraintRows);
        }
        override protected function measure():void{
            super.measure();
            layoutObject.measure();
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            layoutObject.updateDisplayList(_arg1, _arg2);
            createBorder();
        }
        public function get layout():String{
            return (_layout);
        }
        public function set constraintRows(_arg1:Array):void{
            var _local2:int;
            var _local3:int;
            if (_arg1 != _constraintRows){
                _local2 = _arg1.length;
                _local3 = 0;
                while (_local3 < _local2) {
                    ConstraintRow(_arg1[_local3]).container = this;
                    _local3++;
                };
                _constraintRows = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }

    }
}//package mx.core 
