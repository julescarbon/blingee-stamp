package mx.controls.listClasses {
    import mx.core.*;

    public class ListData extends BaseListData {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var icon:Class;
        public var labelField:String;

        public function ListData(_arg1:String, _arg2:Class, _arg3:String, _arg4:String, _arg5:IUIComponent, _arg6:int=0, _arg7:int=0){
            super(_arg1, _arg4, _arg5, _arg6, _arg7);
            this.icon = _arg2;
            this.labelField = _arg3;
        }
    }
}//package mx.controls.listClasses 
