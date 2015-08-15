package flexlib.events {
    import flash.display.*;
    import flash.events.*;
    import mx.events.*;

    public class TabReorderEvent extends IndexChangedEvent {

        public function TabReorderEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:DisplayObject=null, _arg5:Number=-1, _arg6:Number=-1, _arg7:Event=null){
            super(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7);
        }
    }
}//package flexlib.events 
