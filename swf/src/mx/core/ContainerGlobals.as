package mx.core {
    import flash.display.*;
    import mx.managers.*;

    public class ContainerGlobals {

        public static var focusedContainer:InteractiveObject;

        public static function checkFocus(_arg1:InteractiveObject, _arg2:InteractiveObject):void{
            var _local6:IFocusManager;
            var _local7:IButton;
            var _local3:InteractiveObject = _arg2;
            var _local4:InteractiveObject = _arg2;
            var _local5:IUIComponent;
            if (((!((_arg2 == null))) && ((_arg1 == _arg2)))){
                return;
            };
            while (_local4) {
                if (_local4.parent){
                    _local3 = _local4.parent;
                } else {
                    _local3 = null;
                };
                if ((_local4 is IUIComponent)){
                    _local5 = IUIComponent(_local4);
                };
                _local4 = _local3;
                if (((((_local4) && ((_local4 is IContainer)))) && (IContainer(_local4).defaultButton))){
                    break;
                };
            };
            if (((!((ContainerGlobals.focusedContainer == _local4))) || ((((ContainerGlobals.focusedContainer == null)) && ((_local4 == null)))))){
                if (!_local4){
                    _local4 = InteractiveObject(_local5);
                };
                if (((_local4) && ((_local4 is IContainer)))){
                    _local6 = IContainer(_local4).focusManager;
                    if (!_local6){
                        return;
                    };
                    _local7 = (IContainer(_local4).defaultButton as IButton);
                    if (_local7){
                        ContainerGlobals.focusedContainer = InteractiveObject(_local4);
                        _local6.defaultButton = (_local7 as IButton);
                    } else {
                        ContainerGlobals.focusedContainer = InteractiveObject(_local4);
                        _local6.defaultButton = null;
                    };
                };
            };
        }

    }
}//package mx.core 
