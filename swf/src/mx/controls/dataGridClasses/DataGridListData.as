package mx.controls.dataGridClasses {
    import mx.core.*;
    import mx.controls.listClasses.*;

    public class DataGridListData extends BaseListData {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var dataField:String;

        public function DataGridListData(_arg1:String, _arg2:String, _arg3:int, _arg4:String, _arg5:IUIComponent, _arg6:int=0){
            super(_arg1, _arg4, _arg5, _arg6, _arg3);
            this.dataField = _arg2;
        }
    }
}//package mx.controls.dataGridClasses 
