package mx.managers {
    import flash.display.*;
    import mx.core.*;
    import mx.effects.*;

    public interface IToolTipManager2 {

        function registerToolTip(_arg1:DisplayObject, _arg2:String, _arg3:String):void;
        function get enabled():Boolean;
        function set enabled(_arg1:Boolean):void;
        function get scrubDelay():Number;
        function set hideEffect(_arg1:IAbstractEffect):void;
        function createToolTip(_arg1:String, _arg2:Number, _arg3:Number, _arg4:String=null, _arg5:IUIComponent=null):IToolTip;
        function set scrubDelay(_arg1:Number):void;
        function set hideDelay(_arg1:Number):void;
        function get currentTarget():DisplayObject;
        function set showDelay(_arg1:Number):void;
        function get showDelay():Number;
        function get showEffect():IAbstractEffect;
        function get hideDelay():Number;
        function get currentToolTip():IToolTip;
        function get hideEffect():IAbstractEffect;
        function set currentToolTip(_arg1:IToolTip):void;
        function get toolTipClass():Class;
        function registerErrorString(_arg1:DisplayObject, _arg2:String, _arg3:String):void;
        function destroyToolTip(_arg1:IToolTip):void;
        function set toolTipClass(_arg1:Class):void;
        function sizeTip(_arg1:IToolTip):void;
        function set currentTarget(_arg1:DisplayObject):void;
        function set showEffect(_arg1:IAbstractEffect):void;

    }
}//package mx.managers 
