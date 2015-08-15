package mx.managers {
    import mx.core.*;
    import flash.events.*;

    public interface IDragManager {

        function showFeedback(_arg1:String):void;
        function doDrag(_arg1:IUIComponent, _arg2:DragSource, _arg3:MouseEvent, _arg4:IFlexDisplayObject=null, _arg5:Number=0, _arg6:Number=0, _arg7:Number=0.5, _arg8:Boolean=true):void;
        function get isDragging():Boolean;
        function getFeedback():String;
        function acceptDragDrop(_arg1:IUIComponent):void;
        function endDrag():void;

    }
}//package mx.managers 
