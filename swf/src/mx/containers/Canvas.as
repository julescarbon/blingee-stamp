package mx.containers {
    import mx.core.*;
    import mx.containers.utilityClasses.*;

    public class Canvas extends Container implements IConstraintLayout {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _constraintColumns:Array;
        private var layoutObject:CanvasLayout;
        private var _constraintRows:Array;

        public function Canvas(){
            layoutObject = new CanvasLayout();
            _constraintColumns = [];
            _constraintRows = [];
            super();
            layoutObject.target = this;
        }
        public function get constraintColumns():Array{
            return (_constraintColumns);
        }
        override mx_internal function get usePadding():Boolean{
            return (false);
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
        public function get constraintRows():Array{
            return (_constraintRows);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            layoutObject.updateDisplayList(_arg1, _arg2);
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
        override protected function measure():void{
            super.measure();
            layoutObject.measure();
        }

    }
}//package mx.containers 
