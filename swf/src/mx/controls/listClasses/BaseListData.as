package mx.controls.listClasses {
    import mx.core.*;

    public class BaseListData {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _uid:String;
        public var owner:IUIComponent;
        public var label:String;
        public var rowIndex:int;
        public var columnIndex:int;

        public function BaseListData(_arg1:String, _arg2:String, _arg3:IUIComponent, _arg4:int=0, _arg5:int=0){
            this.label = _arg1;
            this.uid = _arg2;
            this.owner = _arg3;
            this.rowIndex = _arg4;
            this.columnIndex = _arg5;
        }
        public function set uid(_arg1:String):void{
            _uid = _arg1;
        }
        public function get uid():String{
            return (_uid);
        }

    }
}//package mx.controls.listClasses 
