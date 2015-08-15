package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.automation.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;
    import mx.utils.*;

    public class PopUpManagerImpl implements IPopUpManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:IPopUpManager;

        private var popupInfo:Array;
        mx_internal var modalWindowClass:Class;

        public function PopUpManagerImpl(){
            var _local1:ISystemManager = ISystemManager(SystemManagerGlobals.topLevelSystemManagers[0]);
            _local1.addEventListener(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST, createModalWindowRequestHandler, false, 0, true);
            _local1.addEventListener(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST, showModalWindowRequest, false, 0, true);
            _local1.addEventListener(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST, hideModalWindowRequest, false, 0, true);
        }
        private static function nonmodalMouseWheelOutsideHandler(_arg1:DisplayObject, _arg2:MouseEvent):void{
            if (_arg1.hitTestPoint(_arg2.stageX, _arg2.stageY, true)){
            } else {
                if ((_arg1 is IUIComponent)){
                    if (IUIComponent(_arg1).owns(DisplayObject(_arg2.target))){
                        return;
                    };
                };
                dispatchMouseWheelOutsideEvent(_arg1, _arg2);
            };
        }
        private static function dispatchMouseWheelOutsideEvent(_arg1:DisplayObject, _arg2:MouseEvent):void{
            if (!_arg1){
                return;
            };
            var _local3:MouseEvent = new FlexMouseEvent(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE);
            var _local4:Point = _arg1.globalToLocal(new Point(_arg2.stageX, _arg2.stageY));
            _local3.localX = _local4.x;
            _local3.localY = _local4.y;
            _local3.buttonDown = _arg2.buttonDown;
            _local3.shiftKey = _arg2.shiftKey;
            _local3.altKey = _arg2.altKey;
            _local3.ctrlKey = _arg2.ctrlKey;
            _local3.delta = _arg2.delta;
            _local3.relatedObject = InteractiveObject(_arg2.target);
            _arg1.dispatchEvent(_local3);
        }
        mx_internal static function updateModalMask(_arg1:ISystemManager, _arg2:DisplayObject, _arg3:IUIComponent, _arg4:Rectangle, _arg5:Sprite):void{
            var _local7:Rectangle;
            var _local8:Point;
            var _local9:Rectangle;
            var _local6:Rectangle = _arg2.getBounds(DisplayObject(_arg1));
            if ((_arg3 is ISWFLoader)){
                _local7 = ISWFLoader(_arg3).getVisibleApplicationRect();
                _local8 = new Point(_local7.x, _local7.y);
                _local8 = DisplayObject(_arg1).globalToLocal(_local8);
                _local7.x = _local8.x;
                _local7.y = _local8.y;
            } else {
                if (!_arg3){
                    _local7 = _local6.clone();
                } else {
                    _local7 = DisplayObject(_arg3).getBounds(DisplayObject(_arg1));
                };
            };
            if (_arg4){
                _local8 = new Point(_arg4.x, _arg4.y);
                _local8 = DisplayObject(_arg1).globalToLocal(_local8);
                _local9 = new Rectangle(_local8.x, _local8.y, _arg4.width, _arg4.height);
                _local7 = _local7.intersection(_local9);
            };
            _arg5.graphics.clear();
            _arg5.graphics.beginFill(0);
            if (_local7.y > _local6.y){
                _arg5.graphics.drawRect(_local6.x, _local6.y, _local6.width, (_local7.y - _local6.y));
            };
            if (_local6.x < _local7.x){
                _arg5.graphics.drawRect(_local6.x, _local7.y, (_local7.x - _local6.x), _local7.height);
            };
            if ((_local6.x + _local6.width) > (_local7.x + _local7.width)){
                _arg5.graphics.drawRect((_local7.x + _local7.width), _local7.y, (((_local6.x + _local6.width) - _local7.x) - _local7.width), _local7.height);
            };
            if ((_local7.y + _local7.height) < (_local6.y + _local6.height)){
                _arg5.graphics.drawRect(_local6.x, (_local7.y + _local7.height), _local6.width, (((_local6.y + _local6.height) - _local7.y) - _local7.height));
            };
            _arg5.graphics.endFill();
        }
        private static function dispatchMouseDownOutsideEvent(_arg1:DisplayObject, _arg2:MouseEvent):void{
            if (!_arg1){
                return;
            };
            var _local3:MouseEvent = new FlexMouseEvent(FlexMouseEvent.MOUSE_DOWN_OUTSIDE);
            var _local4:Point = _arg1.globalToLocal(new Point(_arg2.stageX, _arg2.stageY));
            _local3.localX = _local4.x;
            _local3.localY = _local4.y;
            _local3.buttonDown = _arg2.buttonDown;
            _local3.shiftKey = _arg2.shiftKey;
            _local3.altKey = _arg2.altKey;
            _local3.ctrlKey = _arg2.ctrlKey;
            _local3.delta = _arg2.delta;
            _local3.relatedObject = InteractiveObject(_arg2.target);
            _arg1.dispatchEvent(_local3);
        }
        public static function getInstance():IPopUpManager{
            if (!instance){
                instance = new (PopUpManagerImpl)();
            };
            return (instance);
        }
        private static function nonmodalMouseDownOutsideHandler(_arg1:DisplayObject, _arg2:MouseEvent):void{
            if (_arg1.hitTestPoint(_arg2.stageX, _arg2.stageY, true)){
            } else {
                if ((_arg1 is IUIComponent)){
                    if (IUIComponent(_arg1).owns(DisplayObject(_arg2.target))){
                        return;
                    };
                };
                dispatchMouseDownOutsideEvent(_arg1, _arg2);
            };
        }

        private function showModalWindow(_arg1:PopUpData, _arg2:ISystemManager, _arg3:Boolean=true):void{
            var _local4:IStyleClient = (_arg1.owner as IStyleClient);
            var _local5:Number = 0;
            var _local6:Number = 0;
            if (!isNaN(_arg1.modalTransparencyDuration)){
                _local5 = _arg1.modalTransparencyDuration;
            } else {
                if (_local4){
                    _local5 = _local4.getStyle("modalTransparencyDuration");
                    _arg1.modalTransparencyDuration = _local5;
                };
            };
            if (!isNaN(_arg1.modalTransparency)){
                _local6 = _arg1.modalTransparency;
            } else {
                if (_local4){
                    _local6 = _local4.getStyle("modalTransparency");
                    _arg1.modalTransparency = _local6;
                };
            };
            _arg1.modalWindow.alpha = _local6;
            var _local7:Number = 0;
            if (!isNaN(_arg1.modalTransparencyBlur)){
                _local7 = _arg1.modalTransparencyBlur;
            } else {
                if (_local4){
                    _local7 = _local4.getStyle("modalTransparencyBlur");
                    _arg1.modalTransparencyBlur = _local7;
                };
            };
            var _local8:Number = 0xFFFFFF;
            if (!isNaN(_arg1.modalTransparencyColor)){
                _local8 = _arg1.modalTransparencyColor;
            } else {
                if (_local4){
                    _local8 = _local4.getStyle("modalTransparencyColor");
                    _arg1.modalTransparencyColor = _local8;
                };
            };
            if ((_arg2 is SystemManagerProxy)){
                _arg2 = SystemManagerProxy(_arg2).systemManager;
            };
            var _local9:DisplayObject = _arg2.getSandboxRoot();
            showModalWindowInternal(_arg1, _local5, _local6, _local8, _local7, _arg2, _local9);
            if (((_arg3) && (_arg2.useSWFBridge()))){
                dispatchModalWindowRequest(SWFBridgeRequest.SHOW_MODAL_WINDOW_REQUEST, _arg2, _local9, _arg1, true);
            };
        }
        private function popupShowHandler(_arg1:FlexEvent):void{
            var _local2:PopUpData = findPopupInfoByOwner(_arg1.target);
            if (_local2){
                showModalWindow(_local2, getTopLevelSystemManager(_local2.parent));
            };
        }
        public function bringToFront(_arg1:IFlexDisplayObject):void{
            var _local2:PopUpData;
            var _local3:ISystemManager;
            var _local4:InterManagerRequest;
            if (((_arg1) && (_arg1.parent))){
                _local2 = findPopupInfoByOwner(_arg1);
                if (_local2){
                    _local3 = ISystemManager(_arg1.parent);
                    if ((_local3 is SystemManagerProxy)){
                        _local4 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "bringToFront", {
                            topMost:_local2.topMost,
                            popUp:_local3
                        });
                        _local3.getSandboxRoot().dispatchEvent(_local4);
                    } else {
                        if (_local2.topMost){
                            _local3.popUpChildren.setChildIndex(DisplayObject(_arg1), (_local3.popUpChildren.numChildren - 1));
                        } else {
                            _local3.setChildIndex(DisplayObject(_arg1), (_local3.numChildren - 1));
                        };
                    };
                };
            };
        }
        public function centerPopUp(_arg1:IFlexDisplayObject):void{
            var _local3:ISystemManager;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Rectangle;
            var _local11:Rectangle;
            var _local12:Point;
            var _local13:Point;
            var _local14:Boolean;
            var _local15:DisplayObject;
            var _local16:InterManagerRequest;
            var _local17:Point;
            if ((_arg1 is IInvalidating)){
                IInvalidating(_arg1).validateNow();
            };
            var _local2:PopUpData = findPopupInfoByOwner(_arg1);
            if (((_local2) && (_local2.parent))){
                _local3 = _local2.systemManager;
                _local12 = new Point();
                _local15 = _local3.getSandboxRoot();
                if (_local3 != _local15){
                    _local16 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "isTopLevelRoot");
                    _local15.dispatchEvent(_local16);
                    _local14 = Boolean(_local16.value);
                } else {
                    _local14 = _local3.isTopLevelRoot();
                };
                if (_local14){
                    _local10 = _local3.screen;
                    _local6 = _local10.width;
                    _local7 = _local10.height;
                } else {
                    if (_local3 != _local15){
                        _local16 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "getVisibleApplicationRect");
                        _local15.dispatchEvent(_local16);
                        _local11 = Rectangle(_local16.value);
                    } else {
                        _local11 = _local3.getVisibleApplicationRect();
                    };
                    _local12 = new Point(_local11.x, _local11.y);
                    _local12 = DisplayObject(_local3).globalToLocal(_local12);
                    _local6 = _local11.width;
                    _local7 = _local11.height;
                };
                if ((_local2.parent is UIComponent)){
                    _local11 = UIComponent(_local2.parent).getVisibleRect();
                    _local17 = _local2.parent.globalToLocal(_local11.topLeft);
                    _local12.x = (_local12.x + _local17.x);
                    _local12.y = (_local12.y + _local17.y);
                    _local8 = _local11.width;
                    _local9 = _local11.height;
                } else {
                    _local8 = _local2.parent.width;
                    _local9 = _local2.parent.height;
                };
                _local4 = Math.max(0, ((Math.min(_local6, _local8) - _arg1.width) / 2));
                _local5 = Math.max(0, ((Math.min(_local7, _local9) - _arg1.height) / 2));
                _local13 = new Point(_local12.x, _local12.y);
                _local13 = _local2.parent.localToGlobal(_local13);
                _local13 = _arg1.parent.globalToLocal(_local13);
                _arg1.move((Math.round(_local4) + _local13.x), (Math.round(_local5) + _local13.y));
            };
        }
        private function showModalWindowRequest(_arg1:Event):void{
            var _local2:SWFBridgeRequest = SWFBridgeRequest.marshal(_arg1);
            if ((_arg1 is SWFBridgeRequest)){
                _local2 = SWFBridgeRequest(_arg1);
            } else {
                _local2 = SWFBridgeRequest.marshal(_arg1);
            };
            var _local3:ISystemManager = getTopLevelSystemManager(DisplayObject(ApplicationGlobals.application));
            var _local4:DisplayObject = _local3.getSandboxRoot();
            var _local5:PopUpData = findHighestRemoteModalPopupInfo();
            _local5.excludeRect = Rectangle(_local2.data);
            _local5.modalTransparency = _local2.data.transparency;
            _local5.modalTransparencyBlur = 0;
            _local5.modalTransparencyColor = _local2.data.transparencyColor;
            _local5.modalTransparencyDuration = _local2.data.transparencyDuration;
            if (((_local5.owner) || (_local5.parent))){
                throw (new Error());
            };
            showModalWindow(_local5, _local3);
        }
        private function hideOwnerHandler(_arg1:FlexEvent):void{
            var _local2:PopUpData = findPopupInfoByOwner(_arg1.target);
            if (_local2){
                removeMouseOutEventListeners(_local2);
            };
        }
        private function fadeOutDestroyEffectEndHandler(_arg1:EffectEvent):void{
            var _local4:ISystemManager;
            effectEndHandler(_arg1);
            var _local2:DisplayObject = DisplayObject(_arg1.effectInstance.target);
            var _local3:DisplayObject = _local2.mask;
            if (_local3){
                _local2.mask = null;
                _local4.popUpChildren.removeChild(_local3);
            };
            if ((_local2.parent is ISystemManager)){
                _local4 = ISystemManager(_local2.parent);
                if (_local4.popUpChildren.contains(_local2)){
                    _local4.popUpChildren.removeChild(_local2);
                } else {
                    _local4.removeChild(_local2);
                };
            } else {
                if (_local2.parent){
                    _local2.parent.removeChild(_local2);
                };
            };
        }
        private function createModalWindowRequestHandler(_arg1:Event):void{
            var _local2:SWFBridgeRequest;
            if ((_arg1 is SWFBridgeRequest)){
                _local2 = SWFBridgeRequest(_arg1);
            } else {
                _local2 = SWFBridgeRequest.marshal(_arg1);
            };
            var _local3:ISystemManager = getTopLevelSystemManager(DisplayObject(ApplicationGlobals.application));
            var _local4:DisplayObject = _local3.getSandboxRoot();
            var _local5:PopUpData = new PopUpData();
            _local5.isRemoteModalWindow = true;
            _local5.systemManager = _local3;
            _local5.modalTransparency = _local2.data.transparency;
            _local5.modalTransparencyBlur = 0;
            _local5.modalTransparencyColor = _local2.data.transparencyColor;
            _local5.modalTransparencyDuration = _local2.data.transparencyDuration;
            _local5.exclude = (_local3.swfBridgeGroup.getChildBridgeProvider(_local2.requestor) as IUIComponent);
            _local5.useExclude = _local2.data.useExclude;
            _local5.excludeRect = Rectangle(_local2.data.excludeRect);
            if (!popupInfo){
                popupInfo = [];
            };
            popupInfo.push(_local5);
            createModalWindow(null, _local5, _local3.popUpChildren, _local2.data.show, _local3, _local4);
        }
        private function showOwnerHandler(_arg1:FlexEvent):void{
            var _local2:PopUpData = findPopupInfoByOwner(_arg1.target);
            if (_local2){
                addMouseOutEventListeners(_local2);
            };
        }
        private function addMouseOutEventListeners(_arg1:PopUpData):void{
            var _local2:DisplayObject = _arg1.systemManager.getSandboxRoot();
            if (_arg1.modalWindow){
                _arg1.modalWindow.addEventListener(MouseEvent.MOUSE_DOWN, _arg1.mouseDownOutsideHandler);
                _arg1.modalWindow.addEventListener(MouseEvent.MOUSE_WHEEL, _arg1.mouseWheelOutsideHandler, true);
            } else {
                _local2.addEventListener(MouseEvent.MOUSE_DOWN, _arg1.mouseDownOutsideHandler);
                _local2.addEventListener(MouseEvent.MOUSE_WHEEL, _arg1.mouseWheelOutsideHandler, true);
            };
            _local2.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, _arg1.marshalMouseOutsideHandler);
            _local2.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, _arg1.marshalMouseOutsideHandler, true);
        }
        private function fadeInEffectEndHandler(_arg1:EffectEvent):void{
            var _local4:PopUpData;
            effectEndHandler(_arg1);
            var _local2:int = popupInfo.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = popupInfo[_local3];
                if (((_local4.owner) && ((_local4.modalWindow == _arg1.effectInstance.target)))){
                    IUIComponent(_local4.owner).setVisible(true, true);
                    break;
                };
                _local3++;
            };
        }
        private function hideModalWindowRequest(_arg1:Event):void{
            var _local2:SWFBridgeRequest;
            if ((_arg1 is SWFBridgeRequest)){
                _local2 = SWFBridgeRequest(_arg1);
            } else {
                _local2 = SWFBridgeRequest.marshal(_arg1);
            };
            var _local3:ISystemManager = getTopLevelSystemManager(DisplayObject(ApplicationGlobals.application));
            var _local4:DisplayObject = _local3.getSandboxRoot();
            var _local5:PopUpData = findHighestRemoteModalPopupInfo();
            if (((((!(_local5)) || (_local5.owner))) || (_local5.parent))){
                throw (new Error());
            };
            hideModalWindow(_local5, _local2.data.remove);
            if (_local2.data.remove){
                popupInfo.splice(popupInfo.indexOf(_local5), 1);
                _local3.numModalWindows--;
            };
        }
        private function getTopLevelSystemManager(_arg1:DisplayObject):ISystemManager{
            var _local2:DisplayObjectContainer;
            var _local3:ISystemManager;
            if ((_arg1.parent is SystemManagerProxy)){
                _local2 = DisplayObjectContainer(SystemManagerProxy(_arg1.parent).systemManager);
            } else {
                if ((((_arg1 is IUIComponent)) && ((IUIComponent(_arg1).systemManager is SystemManagerProxy)))){
                    _local2 = DisplayObjectContainer(SystemManagerProxy(IUIComponent(_arg1).systemManager).systemManager);
                } else {
                    _local2 = DisplayObjectContainer(_arg1.root);
                };
            };
            if (((((!(_local2)) || ((_local2 is Stage)))) && ((_arg1 is IUIComponent)))){
                _local2 = DisplayObjectContainer(IUIComponent(_arg1).systemManager);
            };
            if ((_local2 is ISystemManager)){
                _local3 = ISystemManager(_local2);
                if (!_local3.isTopLevel()){
                    _local3 = _local3.topLevelSystemManager;
                };
            };
            return (_local3);
        }
        private function hideModalWindow(_arg1:PopUpData, _arg2:Boolean=false):void{
            var _local6:Fade;
            var _local7:Number;
            var _local8:Blur;
            var _local9:DisplayObject;
            var _local10:SWFBridgeRequest;
            var _local11:IEventDispatcher;
            var _local12:IEventDispatcher;
            var _local13:InterManagerRequest;
            if (((_arg2) && (_arg1.exclude))){
                _arg1.exclude.removeEventListener(Event.RESIZE, _arg1.resizeHandler);
                _arg1.exclude.removeEventListener(MoveEvent.MOVE, _arg1.resizeHandler);
            };
            var _local3:IStyleClient = (_arg1.owner as IStyleClient);
            var _local4:Number = 0;
            if (_local3){
                _local4 = _local3.getStyle("modalTransparencyDuration");
            };
            endEffects(_arg1);
            if (_local4){
                _local6 = new Fade(_arg1.modalWindow);
                _local6.alphaFrom = _arg1.modalWindow.alpha;
                _local6.alphaTo = 0;
                _local6.duration = _local4;
                _local6.addEventListener(EffectEvent.EFFECT_END, ((_arg2) ? fadeOutDestroyEffectEndHandler : fadeOutCloseEffectEndHandler));
                _arg1.modalWindow.visible = true;
                _arg1.fade = _local6;
                _local6.play();
                _local7 = _local3.getStyle("modalTransparencyBlur");
                if (_local7){
                    _local8 = new Blur(_arg1.blurTarget);
                    new Blur(_arg1.blurTarget).blurXFrom = (_local8.blurYFrom = _local7);
                    _local8.blurXTo = (_local8.blurYTo = 0);
                    _local8.duration = _local4;
                    _local8.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                    _arg1.blur = _local8;
                    _local8.play();
                };
            } else {
                _arg1.modalWindow.visible = false;
            };
            var _local5:ISystemManager = ISystemManager(ApplicationGlobals.application.systemManager);
            if (_local5.useSWFBridge()){
                _local9 = _local5.getSandboxRoot();
                if (((!(_arg1.isRemoteModalWindow)) && (!((_local5 == _local9))))){
                    _local13 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "isTopLevelRoot");
                    _local9.dispatchEvent(_local13);
                    if (Boolean(_local13.value)){
                        return;
                    };
                };
                _local10 = new SWFBridgeRequest(SWFBridgeRequest.HIDE_MODAL_WINDOW_REQUEST, false, false, null, {
                    skip:((!(_arg1.isRemoteModalWindow)) && (!((_local5 == _local9)))),
                    show:false,
                    remove:_arg2
                });
                _local11 = _local5.swfBridgeGroup.parentBridge;
                _local10.requestor = _local11;
                _local11.dispatchEvent(_local10);
            };
        }
        private function popupHideHandler(_arg1:FlexEvent):void{
            var _local2:PopUpData = findPopupInfoByOwner(_arg1.target);
            if (_local2){
                hideModalWindow(_local2);
            };
        }
        private function showModalWindowInternal(_arg1:PopUpData, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:ISystemManager, _arg7:DisplayObject):void{
            var _local8:Fade;
            var _local9:Number;
            var _local10:Object;
            var _local11:Blur;
            var _local12:InterManagerRequest;
            endEffects(_arg1);
            if (_arg2){
                _local8 = new Fade(_arg1.modalWindow);
                _local8.alphaFrom = 0;
                _local8.alphaTo = _arg3;
                _local8.duration = _arg2;
                _local8.addEventListener(EffectEvent.EFFECT_END, fadeInEffectEndHandler);
                _arg1.modalWindow.alpha = 0;
                _arg1.modalWindow.visible = true;
                _arg1.fade = _local8;
                if (_arg1.owner){
                    IUIComponent(_arg1.owner).setVisible(false, true);
                };
                _local8.play();
                _local9 = _arg5;
                if (_local9){
                    if (_arg6 != _arg7){
                        _local12 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "application", _local10);
                        _arg7.dispatchEvent(_local12);
                        _arg1.blurTarget = _local12.value;
                    } else {
                        _arg1.blurTarget = ApplicationGlobals.application;
                    };
                    _local11 = new Blur(_arg1.blurTarget);
                    new Blur(_arg1.blurTarget).blurXFrom = (_local11.blurYFrom = 0);
                    _local11.blurXTo = (_local11.blurYTo = _local9);
                    _local11.duration = _arg2;
                    _local11.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                    _arg1.blur = _local11;
                    _local11.play();
                };
            } else {
                if (_arg1.owner){
                    IUIComponent(_arg1.owner).setVisible(true, true);
                };
                _arg1.modalWindow.visible = true;
            };
        }
        private function effectEndHandler(_arg1:EffectEvent):void{
            var _local4:PopUpData;
            var _local5:IEffect;
            var _local2:int = popupInfo.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = popupInfo[_local3];
                _local5 = _arg1.effectInstance.effect;
                if (_local5 == _local4.fade){
                    _local4.fade = null;
                } else {
                    if (_local5 == _local4.blur){
                        _local4.blur = null;
                    };
                };
                _local3++;
            };
        }
        private function createModalWindow(_arg1:DisplayObject, _arg2:PopUpData, _arg3:IChildList, _arg4:Boolean, _arg5:ISystemManager, _arg6:DisplayObject):void{
            var _local7:IFlexDisplayObject;
            var _local10:Sprite;
            var _local11:SystemManagerProxy;
            var _local12:ISystemManager;
            _local7 = IFlexDisplayObject(_arg2.owner);
            var _local8:IStyleClient = (_local7 as IStyleClient);
            var _local9:Number = 0;
            if (modalWindowClass){
                _local10 = new modalWindowClass();
            } else {
                _local10 = new FlexSprite();
                _local10.name = "modalWindow";
            };
            if (((!(_arg5)) && (_arg1))){
                _arg5 = IUIComponent(_arg1).systemManager;
            };
            if ((_arg5 is SystemManagerProxy)){
                _local11 = SystemManagerProxy(_arg5);
                _local12 = _local11.systemManager;
            } else {
                _local12 = _arg5;
            };
            _local12.numModalWindows++;
            if (_local7){
                _arg3.addChildAt(_local10, _arg3.getChildIndex(DisplayObject(_local7)));
            } else {
                _arg3.addChild(_local10);
            };
            if ((_local7 is IAutomationObject)){
                IAutomationObject(_local7).showInAutomationHierarchy = true;
            };
            if (!isNaN(_arg2.modalTransparency)){
                _local10.alpha = _arg2.modalTransparency;
            } else {
                if (_local8){
                    _local10.alpha = _local8.getStyle("modalTransparency");
                } else {
                    _local10.alpha = 0;
                };
            };
            _arg2.modalTransparency = _local10.alpha;
            _local10.tabEnabled = false;
            var _local13:Rectangle = _local12.screen;
            var _local14:Graphics = _local10.graphics;
            var _local15:Number = 0xFFFFFF;
            if (!isNaN(_arg2.modalTransparencyColor)){
                _local15 = _arg2.modalTransparencyColor;
            } else {
                if (_local8){
                    _local15 = _local8.getStyle("modalTransparencyColor");
                    _arg2.modalTransparencyColor = _local15;
                };
            };
            _local14.clear();
            _local14.beginFill(_local15, 100);
            _local14.drawRect(_local13.x, _local13.y, _local13.width, _local13.height);
            _local14.endFill();
            _arg2.modalWindow = _local10;
            if (_arg2.exclude){
                _arg2.modalMask = new Sprite();
                updateModalMask(_local12, _local10, ((_arg2.useExclude) ? _arg2.exclude : null), _arg2.excludeRect, _arg2.modalMask);
                _local10.mask = _arg2.modalMask;
                _arg3.addChild(_arg2.modalMask);
                _arg2.exclude.addEventListener(Event.RESIZE, _arg2.resizeHandler);
                _arg2.exclude.addEventListener(MoveEvent.MOVE, _arg2.resizeHandler);
            };
            _arg2._mouseDownOutsideHandler = dispatchMouseDownOutsideEvent;
            _arg2._mouseWheelOutsideHandler = dispatchMouseWheelOutsideEvent;
            _local12.addEventListener(Event.RESIZE, _arg2.resizeHandler);
            if (_local7){
                _local7.addEventListener(FlexEvent.SHOW, popupShowHandler);
                _local7.addEventListener(FlexEvent.HIDE, popupHideHandler);
            };
            if (_arg4){
                showModalWindow(_arg2, _arg5, false);
            } else {
                _local7.visible = _arg4;
            };
            if (_local12.useSWFBridge()){
                if (_local8){
                    _arg2.modalTransparencyDuration = _local8.getStyle("modalTransparencyDuration");
                    _arg2.modalTransparencyBlur = _local8.getStyle("modalTransparencyBlur");
                };
                dispatchModalWindowRequest(SWFBridgeRequest.CREATE_MODAL_WINDOW_REQUEST, _local12, _arg6, _arg2, _arg4);
            };
        }
        private function findPopupInfoByOwner(_arg1:Object):PopUpData{
            var _local4:PopUpData;
            var _local2:int = popupInfo.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = popupInfo[_local3];
                if (_local4.owner == _arg1){
                    return (_local4);
                };
                _local3++;
            };
            return (null);
        }
        private function popupRemovedHandler(_arg1:Event):void{
            var _local4:PopUpData;
            var _local5:DisplayObject;
            var _local6:DisplayObject;
            var _local7:DisplayObject;
            var _local8:ISystemManager;
            var _local9:ISystemManager;
            var _local10:IEventDispatcher;
            var _local11:SWFBridgeRequest;
            var _local2:int = popupInfo.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = popupInfo[_local3];
                _local5 = _local4.owner;
                if (_local5 == _arg1.target){
                    _local6 = _local4.parent;
                    _local7 = _local4.modalWindow;
                    _local8 = _local4.systemManager;
                    if ((_local8 is SystemManagerProxy)){
                        _local9 = SystemManagerProxy(_local8).systemManager;
                    } else {
                        _local9 = _local8;
                    };
                    if (!_local8.isTopLevel()){
                        _local8 = _local8.topLevelSystemManager;
                    };
                    if ((_local5 is IUIComponent)){
                        IUIComponent(_local5).isPopUp = false;
                    };
                    if ((_local5 is IFocusManagerContainer)){
                        _local8.removeFocusManager(IFocusManagerContainer(_local5));
                    };
                    _local5.removeEventListener(Event.REMOVED, popupRemovedHandler);
                    if ((_local8 is SystemManagerProxy)){
                        _local10 = _local9.swfBridgeGroup.parentBridge;
                        _local11 = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_REQUEST, false, false, _local10, {
                            window:DisplayObject(_local8),
                            parent:_local4.parent,
                            modal:!((_local4.modalWindow == null))
                        });
                        _local9.getSandboxRoot().dispatchEvent(_local11);
                    } else {
                        if (_local8.useSWFBridge()){
                            _local11 = new SWFBridgeRequest(SWFBridgeRequest.REMOVE_POP_UP_PLACE_HOLDER_REQUEST, false, false, null, {window:DisplayObject(_local5)});
                            _local11.requestor = _local8.swfBridgeGroup.parentBridge;
                            _local11.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(_local5));
                            _local8.dispatchEvent(_local11);
                        };
                    };
                    if (_local4.owner){
                        _local4.owner.removeEventListener(FlexEvent.SHOW, showOwnerHandler);
                        _local4.owner.removeEventListener(FlexEvent.HIDE, hideOwnerHandler);
                    };
                    removeMouseOutEventListeners(_local4);
                    if (_local7){
                        _local9.removeEventListener(Event.RESIZE, _local4.resizeHandler);
                        _local5.removeEventListener(FlexEvent.SHOW, popupShowHandler);
                        _local5.removeEventListener(FlexEvent.HIDE, popupHideHandler);
                        hideModalWindow(_local4, true);
                        _local9.numModalWindows--;
                    };
                    popupInfo.splice(_local3, 1);
                    break;
                };
                _local3++;
            };
        }
        private function fadeOutCloseEffectEndHandler(_arg1:EffectEvent):void{
            effectEndHandler(_arg1);
            DisplayObject(_arg1.effectInstance.target).visible = false;
        }
        private function endEffects(_arg1:PopUpData):void{
            if (_arg1.fade){
                _arg1.fade.end();
                _arg1.fade = null;
            };
            if (_arg1.blur){
                _arg1.blur.end();
                _arg1.blur = null;
            };
        }
        public function removePopUp(_arg1:IFlexDisplayObject):void{
            var _local2:PopUpData;
            var _local3:ISystemManager;
            var _local4:IUIComponent;
            if (((_arg1) && (_arg1.parent))){
                _local2 = findPopupInfoByOwner(_arg1);
                if (_local2){
                    _local3 = _local2.systemManager;
                    if (!_local3){
                        _local4 = (_arg1 as IUIComponent);
                        if (_local4){
                            _local3 = ISystemManager(_local4.systemManager);
                        } else {
                            return;
                        };
                    };
                    if (_local2.topMost){
                        _local3.popUpChildren.removeChild(DisplayObject(_arg1));
                    } else {
                        _local3.removeChild(DisplayObject(_arg1));
                    };
                };
            };
        }
        public function addPopUp(_arg1:IFlexDisplayObject, _arg2:DisplayObject, _arg3:Boolean=false, _arg4:String=null):void{
            var _local7:IChildList;
            var _local8:Boolean;
            var _local5:Boolean = _arg1.visible;
            if ((((((_arg2 is IUIComponent)) && ((_arg1 is IUIComponent)))) && ((IUIComponent(_arg1).document == null)))){
                IUIComponent(_arg1).document = IUIComponent(_arg2).document;
            };
            if ((((((((_arg2 is IUIComponent)) && ((IUIComponent(_arg2).document is IFlexModule)))) && ((_arg1 is UIComponent)))) && ((UIComponent(_arg1).moduleFactory == null)))){
                UIComponent(_arg1).moduleFactory = IFlexModule(IUIComponent(_arg2).document).moduleFactory;
            };
            var _local6:ISystemManager = getTopLevelSystemManager(_arg2);
            if (!_local6){
                _local6 = ISystemManager(SystemManagerGlobals.topLevelSystemManagers[0]);
                if (_local6.getSandboxRoot() != _arg2){
                    return;
                };
            };
            var _local9:ISystemManager = _local6;
            var _local10:DisplayObject = _local6.getSandboxRoot();
            var _local11:SWFBridgeRequest;
            if (_local6.useSWFBridge()){
                if (_local10 != _local6){
                    _local9 = new SystemManagerProxy(_local6);
                    _local11 = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_REQUEST, false, false, _local6.swfBridgeGroup.parentBridge, {
                        window:DisplayObject(_local9),
                        parent:_arg2,
                        modal:_arg3,
                        childList:_arg4
                    });
                    _local10.dispatchEvent(_local11);
                } else {
                    _local9 = _local6;
                };
            };
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).isPopUp = true;
            };
            if (((!(_arg4)) || ((_arg4 == PopUpManagerChildList.PARENT)))){
                _local8 = _local9.popUpChildren.contains(_arg2);
            } else {
                _local8 = (_arg4 == PopUpManagerChildList.POPUP);
            };
            _local7 = ((_local8) ? _local9.popUpChildren : _local9);
            _local7.addChild(DisplayObject(_arg1));
            _arg1.visible = false;
            if (!popupInfo){
                popupInfo = [];
            };
            var _local12:PopUpData = new PopUpData();
            _local12.owner = DisplayObject(_arg1);
            _local12.topMost = _local8;
            _local12.systemManager = _local9;
            popupInfo.push(_local12);
            if ((_arg1 is IFocusManagerContainer)){
                if (IFocusManagerContainer(_arg1).focusManager){
                    _local9.addFocusManager(IFocusManagerContainer(_arg1));
                } else {
                    IFocusManagerContainer(_arg1).focusManager = new FocusManager(IFocusManagerContainer(_arg1), true);
                };
            };
            if (((((!(_local6.isTopLevelRoot())) && (_local10))) && ((_local6 == _local10)))){
                _local11 = new SWFBridgeRequest(SWFBridgeRequest.ADD_POP_UP_PLACE_HOLDER_REQUEST, false, false, null, {window:DisplayObject(_arg1)});
                _local11.requestor = _local6.swfBridgeGroup.parentBridge;
                _local11.data.placeHolderId = NameUtil.displayObjectToString(DisplayObject(_arg1));
                _local6.dispatchEvent(_local11);
            };
            if ((_arg1 is IAutomationObject)){
                IAutomationObject(_arg1).showInAutomationHierarchy = true;
            };
            if ((_arg1 is ILayoutManagerClient)){
                UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(_arg1), true);
            };
            _local12.parent = _arg2;
            if ((_arg1 is IUIComponent)){
                IUIComponent(_arg1).setActualSize(IUIComponent(_arg1).getExplicitOrMeasuredWidth(), IUIComponent(_arg1).getExplicitOrMeasuredHeight());
            };
            if (_arg3){
                createModalWindow(_arg2, _local12, _local7, _local5, _local9, _local10);
            } else {
                _local12._mouseDownOutsideHandler = nonmodalMouseDownOutsideHandler;
                _local12._mouseWheelOutsideHandler = nonmodalMouseWheelOutsideHandler;
                _arg1.visible = _local5;
            };
            _local12.owner.addEventListener(FlexEvent.SHOW, showOwnerHandler);
            _local12.owner.addEventListener(FlexEvent.HIDE, hideOwnerHandler);
            addMouseOutEventListeners(_local12);
            _arg1.addEventListener(Event.REMOVED, popupRemovedHandler);
            if ((((_arg1 is IFocusManagerContainer)) && (_local5))){
                if (((!((_local9 is SystemManagerProxy))) && (_local9.useSWFBridge()))){
                    SystemManager(_local9).dispatchActivatedWindowEvent(DisplayObject(_arg1));
                } else {
                    _local9.activate(IFocusManagerContainer(_arg1));
                };
            };
        }
        private function dispatchModalWindowRequest(_arg1:String, _arg2:ISystemManager, _arg3:DisplayObject, _arg4:PopUpData, _arg5:Boolean):void{
            var _local8:InterManagerRequest;
            if (((!(_arg4.isRemoteModalWindow)) && (!((_arg2 == _arg3))))){
                _local8 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "isTopLevelRoot");
                _arg3.dispatchEvent(_local8);
                if (Boolean(_local8.value)){
                    return;
                };
            };
            var _local6:SWFBridgeRequest = new SWFBridgeRequest(_arg1, false, false, null, {
                skip:((!(_arg4.isRemoteModalWindow)) && (!((_arg2 == _arg3)))),
                useExclude:_arg4.useExclude,
                show:_arg5,
                remove:false,
                transparencyDuration:_arg4.modalTransparencyDuration,
                transparency:_arg4.modalTransparency,
                transparencyColor:_arg4.modalTransparencyColor,
                transparencyBlur:_arg4.modalTransparencyBlur
            });
            var _local7:IEventDispatcher = _arg2.swfBridgeGroup.parentBridge;
            _local6.requestor = _local7;
            _local7.dispatchEvent(_local6);
        }
        public function createPopUp(_arg1:DisplayObject, _arg2:Class, _arg3:Boolean=false, _arg4:String=null):IFlexDisplayObject{
            var _local5:IUIComponent = new (_arg2)();
            addPopUp(_local5, _arg1, _arg3, _arg4);
            return (_local5);
        }
        private function removeMouseOutEventListeners(_arg1:PopUpData):void{
            var _local2:DisplayObject = _arg1.systemManager.getSandboxRoot();
            if (_arg1.modalWindow){
                _arg1.modalWindow.removeEventListener(MouseEvent.MOUSE_DOWN, _arg1.mouseDownOutsideHandler);
                _arg1.modalWindow.removeEventListener(MouseEvent.MOUSE_WHEEL, _arg1.mouseWheelOutsideHandler, true);
            } else {
                _local2.removeEventListener(MouseEvent.MOUSE_DOWN, _arg1.mouseDownOutsideHandler);
                _local2.removeEventListener(MouseEvent.MOUSE_WHEEL, _arg1.mouseWheelOutsideHandler, true);
            };
            _local2.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, _arg1.marshalMouseOutsideHandler);
            _local2.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, _arg1.marshalMouseOutsideHandler, true);
        }
        private function findHighestRemoteModalPopupInfo():PopUpData{
            var _local3:PopUpData;
            var _local1:int = (popupInfo.length - 1);
            var _local2:int = _local1;
            while (_local2 >= 0) {
                _local3 = popupInfo[_local2];
                if (_local3.isRemoteModalWindow){
                    return (_local3);
                };
                _local2--;
            };
            return (null);
        }

    }
}//package mx.managers 

import flash.display.*;
import flash.geom.*;
import mx.core.*;
import flash.events.*;
import mx.events.*;
import mx.effects.*;

class PopUpData {

    public var fade:Effect;
    public var modalTransparencyColor:Number;
    public var exclude:IUIComponent;
    public var isRemoteModalWindow:Boolean;
    public var useExclude:Boolean;
    public var blurTarget:Object;
    public var modalTransparencyDuration:Number;
    public var _mouseWheelOutsideHandler:Function;
    public var excludeRect:Rectangle;
    public var modalTransparency:Number;
    public var blur:Effect;
    public var parent:DisplayObject;
    public var modalTransparencyBlur:Number;
    public var _mouseDownOutsideHandler:Function;
    public var owner:DisplayObject;
    public var topMost:Boolean;
    public var modalMask:Sprite;
    public var modalWindow:DisplayObject;
    public var systemManager:ISystemManager;

    public function PopUpData(){
        useExclude = true;
    }
    public function marshalMouseOutsideHandler(_arg1:Event):void{
        if (!(_arg1 is SandboxMouseEvent)){
            _arg1 = SandboxMouseEvent.marshal(_arg1);
        };
        if (owner){
            owner.dispatchEvent(_arg1);
        };
    }
    public function mouseDownOutsideHandler(_arg1:MouseEvent):void{
        _mouseDownOutsideHandler(owner, _arg1);
    }
    public function mouseWheelOutsideHandler(_arg1:MouseEvent):void{
        _mouseWheelOutsideHandler(owner, _arg1);
    }
    public function resizeHandler(_arg1:Event):void{
        var _local2:Rectangle;
        if (((((owner) && ((owner.stage == DisplayObject(_arg1.target).stage)))) || (((modalWindow) && ((modalWindow.stage == DisplayObject(_arg1.target).stage)))))){
            _local2 = systemManager.screen;
            modalWindow.width = _local2.width;
            modalWindow.height = _local2.height;
            modalWindow.x = _local2.x;
            modalWindow.y = _local2.y;
            if (modalMask){
                PopUpManagerImpl.updateModalMask(systemManager, modalWindow, exclude, excludeRect, modalMask);
            };
        };
    }

}
