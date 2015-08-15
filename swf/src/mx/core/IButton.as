package mx.core {

    public interface IButton extends IUIComponent {

        function get emphasized():Boolean;
        function set emphasized(_arg1:Boolean):void;
        function callLater(_arg1:Function, _arg2:Array=null):void;

    }
}//package mx.core 
