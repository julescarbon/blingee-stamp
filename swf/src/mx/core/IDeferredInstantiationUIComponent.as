package mx.core {

    public interface IDeferredInstantiationUIComponent extends IUIComponent {

        function set cacheHeuristic(_arg1:Boolean):void;
        function createReferenceOnParentDocument(_arg1:IFlexDisplayObject):void;
        function get cachePolicy():String;
        function set id(_arg1:String):void;
        function registerEffects(_arg1:Array):void;
        function executeBindings(_arg1:Boolean=false):void;
        function get id():String;
        function deleteReferenceOnParentDocument(_arg1:IFlexDisplayObject):void;
        function set descriptor(_arg1:UIComponentDescriptor):void;
        function get descriptor():UIComponentDescriptor;

    }
}//package mx.core 
