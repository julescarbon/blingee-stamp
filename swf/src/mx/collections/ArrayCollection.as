package mx.collections {
    import flash.utils.*;

    public class ArrayCollection extends ListCollectionView implements IExternalizable {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function ArrayCollection(_arg1:Array=null){
            this.source = _arg1;
        }
        public function set source(_arg1:Array):void{
            list = new ArrayList(_arg1);
        }
        public function readExternal(_arg1:IDataInput):void{
            if ((list is IExternalizable)){
                IExternalizable(list).readExternal(_arg1);
            } else {
                source = (_arg1.readObject() as Array);
            };
        }
        public function writeExternal(_arg1:IDataOutput):void{
            if ((list is IExternalizable)){
                IExternalizable(list).writeExternal(_arg1);
            } else {
                _arg1.writeObject(source);
            };
        }
        public function get source():Array{
            if (((list) && ((list is ArrayList)))){
                return (ArrayList(list).source);
            };
            return (null);
        }

    }
}//package mx.collections 
