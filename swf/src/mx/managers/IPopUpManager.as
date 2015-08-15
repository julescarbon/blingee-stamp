package mx.managers {
    import flash.display.*;
    import mx.core.*;

    public interface IPopUpManager {

        function createPopUp(_arg1:DisplayObject, _arg2:Class, _arg3:Boolean=false, _arg4:String=null):IFlexDisplayObject;
        function centerPopUp(_arg1:IFlexDisplayObject):void;
        function removePopUp(_arg1:IFlexDisplayObject):void;
        function addPopUp(_arg1:IFlexDisplayObject, _arg2:DisplayObject, _arg3:Boolean=false, _arg4:String=null):void;
        function bringToFront(_arg1:IFlexDisplayObject):void;

    }
}//package mx.managers 
