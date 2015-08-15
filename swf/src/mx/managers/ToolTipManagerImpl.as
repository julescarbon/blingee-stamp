package mx.managers {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.effects.*;
    import flash.utils.*;
    import mx.validators.*;

    public class ToolTipManagerImpl extends EventDispatcher implements IToolTipManager2 {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:IToolTipManager2;

        private var _enabled:Boolean = true;
        private var _showDelay:Number = 500;
        private var _hideEffect:IAbstractEffect;
        mx_internal var hideTimer:Timer;
        private var _scrubDelay:Number = 100;
        private var _toolTipClass:Class;
        mx_internal var showTimer:Timer;
        private var sandboxRoot:IEventDispatcher = null;
        mx_internal var currentText:String;
        private var _currentToolTip:DisplayObject;
        mx_internal var scrubTimer:Timer;
        mx_internal var previousTarget:DisplayObject;
        private var _currentTarget:DisplayObject;
        private var systemManager:ISystemManager = null;
        private var _showEffect:IAbstractEffect;
        private var _hideDelay:Number = 10000;
        mx_internal var initialized:Boolean = false;
        mx_internal var isError:Boolean;

        public function ToolTipManagerImpl(){
            _toolTipClass = ToolTip;
            super();
            if (instance){
                throw (new Error("Instance already exists."));
            };
            this.systemManager = (SystemManagerGlobals.topLevelSystemManagers[0] as ISystemManager);
            sandboxRoot = this.systemManager.getSandboxRoot();
            sandboxRoot.addEventListener(InterManagerRequest.TOOLTIP_MANAGER_REQUEST, marshalToolTipManagerHandler, false, 0, true);
            var _local1:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
            _local1.name = "update";
            sandboxRoot.dispatchEvent(_local1);
        }
        public static function getInstance():IToolTipManager2{
            if (!instance){
                instance = new (ToolTipManagerImpl)();
            };
            return (instance);
        }

        mx_internal function systemManager_mouseDownHandler(_arg1:MouseEvent):void{
            reset();
        }
        public function set showDelay(_arg1:Number):void{
            _showDelay = _arg1;
        }
        mx_internal function showTimer_timerHandler(_arg1:TimerEvent):void{
            if (currentTarget){
                createTip();
                initializeTip();
                positionTip();
                showTip();
            };
        }
        mx_internal function hideEffectEnded():void{
            var _local1:ToolTipEvent;
            reset();
            if (previousTarget){
                _local1 = new ToolTipEvent(ToolTipEvent.TOOL_TIP_END);
                _local1.toolTip = currentToolTip;
                previousTarget.dispatchEvent(_local1);
            };
        }
        public function set scrubDelay(_arg1:Number):void{
            _scrubDelay = _arg1;
        }
        public function get currentToolTip():IToolTip{
            return ((_currentToolTip as IToolTip));
        }
        private function mouseIsOver(_arg1:DisplayObject):Boolean{
            if (((!(_arg1)) || (!(_arg1.stage)))){
                return (false);
            };
            if ((((_arg1.stage.mouseX == 0)) && ((_arg1.stage.mouseY == 0)))){
                return (false);
            };
            return (_arg1.hitTestPoint(_arg1.stage.mouseX, _arg1.stage.mouseY, true));
        }
        mx_internal function toolTipMouseOutHandler(_arg1:MouseEvent):void{
            checkIfTargetChanged(_arg1.relatedObject);
        }
        public function get enabled():Boolean{
            return (_enabled);
        }
        public function createToolTip(_arg1:String, _arg2:Number, _arg3:Number, _arg4:String=null, _arg5:IUIComponent=null):IToolTip{
            var _local6:ToolTip = new ToolTip();
            var _local7:ISystemManager = ((_arg5) ? (_arg5.systemManager as ISystemManager) : (ApplicationGlobals.application.systemManager as ISystemManager));
            _local7.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", (_local6 as DisplayObject));
            if (_arg4){
                _local6.setStyle("styleName", "errorTip");
                _local6.setStyle("borderStyle", _arg4);
            };
            _local6.text = _arg1;
            sizeTip(_local6);
            _local6.move(_arg2, _arg3);
            return ((_local6 as IToolTip));
        }
        mx_internal function reset():void{
            var _local1:ISystemManager;
            showTimer.reset();
            hideTimer.reset();
            if (currentToolTip){
                if (((showEffect) || (hideEffect))){
                    currentToolTip.removeEventListener(EffectEvent.EFFECT_END, effectEndHandler);
                };
                EffectManager.endEffectsForTarget(currentToolTip);
                _local1 = (currentToolTip.systemManager as ISystemManager);
                _local1.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", (currentToolTip as DisplayObject));
                currentToolTip = null;
                scrubTimer.delay = scrubDelay;
                scrubTimer.reset();
                if (scrubDelay > 0){
                    scrubTimer.delay = scrubDelay;
                    scrubTimer.start();
                };
            };
        }
        public function set currentToolTip(_arg1:IToolTip):void{
            _currentToolTip = (_arg1 as DisplayObject);
            var _local2:InterManagerRequest = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
            _local2.name = "currentToolTip";
            _local2.value = _arg1;
            sandboxRoot.dispatchEvent(_local2);
        }
        public function get toolTipClass():Class{
            return (_toolTipClass);
        }
        private function hideImmediately(_arg1:DisplayObject):void{
            checkIfTargetChanged(null);
        }
        mx_internal function showTip():void{
            var _local2:ISystemManager;
            var _local1:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
            _local1.toolTip = currentToolTip;
            currentTarget.dispatchEvent(_local1);
            if (isError){
                currentTarget.addEventListener("change", changeHandler);
            } else {
                _local2 = getSystemManager(currentTarget);
                _local2.addEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
            };
            currentToolTip.visible = true;
            if (!showEffect){
                showEffectEnded();
            };
        }
        mx_internal function effectEndHandler(_arg1:EffectEvent):void{
            if (_arg1.effectInstance.effect == showEffect){
                showEffectEnded();
            } else {
                if (_arg1.effectInstance.effect == hideEffect){
                    hideEffectEnded();
                };
            };
        }
        public function get hideDelay():Number{
            return (_hideDelay);
        }
        public function get currentTarget():DisplayObject{
            return (_currentTarget);
        }
        mx_internal function showEffectEnded():void{
            var _local1:ToolTipEvent;
            if (hideDelay == 0){
                hideTip();
            } else {
                if (hideDelay < Infinity){
                    hideTimer.delay = hideDelay;
                    hideTimer.start();
                };
            };
            if (currentTarget){
                _local1 = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOWN);
                _local1.toolTip = currentToolTip;
                currentTarget.dispatchEvent(_local1);
            };
        }
        public function get hideEffect():IAbstractEffect{
            return (_hideEffect);
        }
        mx_internal function changeHandler(_arg1:Event):void{
            reset();
        }
        public function set enabled(_arg1:Boolean):void{
            _enabled = _arg1;
        }
        mx_internal function errorTipMouseOverHandler(_arg1:MouseEvent):void{
            checkIfTargetChanged(DisplayObject(_arg1.target));
        }
        public function get showDelay():Number{
            return (_showDelay);
        }
        public function get scrubDelay():Number{
            return (_scrubDelay);
        }
        public function registerErrorString(_arg1:DisplayObject, _arg2:String, _arg3:String):void{
            if (((!(_arg2)) && (_arg3))){
                _arg1.addEventListener(MouseEvent.MOUSE_OVER, errorTipMouseOverHandler);
                _arg1.addEventListener(MouseEvent.MOUSE_OUT, errorTipMouseOutHandler);
                if (mouseIsOver(_arg1)){
                    showImmediately(_arg1);
                };
            } else {
                if (((_arg2) && (!(_arg3)))){
                    _arg1.removeEventListener(MouseEvent.MOUSE_OVER, errorTipMouseOverHandler);
                    _arg1.removeEventListener(MouseEvent.MOUSE_OUT, errorTipMouseOutHandler);
                    if (mouseIsOver(_arg1)){
                        hideImmediately(_arg1);
                    };
                };
            };
        }
        mx_internal function initialize():void{
            if (!showTimer){
                showTimer = new Timer(0, 1);
                showTimer.addEventListener(TimerEvent.TIMER, showTimer_timerHandler);
            };
            if (!hideTimer){
                hideTimer = new Timer(0, 1);
                hideTimer.addEventListener(TimerEvent.TIMER, hideTimer_timerHandler);
            };
            if (!scrubTimer){
                scrubTimer = new Timer(0, 1);
            };
            initialized = true;
        }
        public function destroyToolTip(_arg1:IToolTip):void{
            var _local2:ISystemManager = (_arg1.systemManager as ISystemManager);
            _local2.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", DisplayObject(_arg1));
        }
        mx_internal function checkIfTargetChanged(_arg1:DisplayObject):void{
            if (!enabled){
                return;
            };
            findTarget(_arg1);
            if (currentTarget != previousTarget){
                targetChanged();
                previousTarget = currentTarget;
            };
        }
        private function marshalToolTipManagerHandler(_arg1:Event):void{
            var _local2:InterManagerRequest;
            if ((_arg1 is InterManagerRequest)){
                return;
            };
            var _local3:Object = _arg1;
            switch (_local3.name){
                case "currentToolTip":
                    _currentToolTip = _local3.value;
                    break;
                case ToolTipEvent.TOOL_TIP_HIDE:
                    if ((_currentToolTip is IToolTip)){
                        hideTip();
                    };
                    break;
                case "update":
                    _arg1.stopImmediatePropagation();
                    _local2 = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
                    _local2.name = "currentToolTip";
                    _local2.value = _currentToolTip;
                    sandboxRoot.dispatchEvent(_local2);
            };
        }
        public function set toolTipClass(_arg1:Class):void{
            _toolTipClass = _arg1;
        }
        private function getGlobalBounds(_arg1:DisplayObject, _arg2:DisplayObject):Rectangle{
            var _local3:Point = new Point(0, 0);
            _local3 = _arg1.localToGlobal(_local3);
            _local3 = _arg2.globalToLocal(_local3);
            return (new Rectangle(_local3.x, _local3.y, _arg1.width, _arg1.height));
        }
        mx_internal function positionTip():void{
            var _local1:Number;
            var _local2:Number;
            var _local5:Rectangle;
            var _local6:Point;
            var _local7:IToolTip;
            var _local8:Number;
            var _local9:Number;
            var _local10:ISystemManager;
            var _local11:Number;
            var _local12:Number;
            var _local3:Number = currentToolTip.screen.width;
            var _local4:Number = currentToolTip.screen.height;
            if (isError){
                _local5 = getGlobalBounds(currentTarget, currentToolTip.root);
                _local1 = (_local5.right + 4);
                _local2 = (_local5.top - 1);
                if ((_local1 + currentToolTip.width) > _local3){
                    _local8 = NaN;
                    _local9 = NaN;
                    _local1 = (_local5.left - 2);
                    if (((_local1 + currentToolTip.width) + 4) > _local3){
                        _local8 = ((_local3 - _local1) - 4);
                        _local9 = Object(toolTipClass).maxWidth;
                        Object(toolTipClass).maxWidth = _local8;
                        if ((currentToolTip is IStyleClient)){
                            IStyleClient(currentToolTip).setStyle("borderStyle", "errorTipAbove");
                        };
                        currentToolTip["text"] = currentToolTip["text"];
                        Object(toolTipClass).maxWidth = _local9;
                    } else {
                        if ((currentToolTip is IStyleClient)){
                            IStyleClient(currentToolTip).setStyle("borderStyle", "errorTipAbove");
                        };
                        currentToolTip["text"] = currentToolTip["text"];
                    };
                    if ((currentToolTip.height + 2) < _local5.top){
                        _local2 = (_local5.top - (currentToolTip.height + 2));
                    } else {
                        _local2 = (_local5.bottom + 2);
                        if (!isNaN(_local8)){
                            Object(toolTipClass).maxWidth = _local8;
                        };
                        if ((currentToolTip is IStyleClient)){
                            IStyleClient(currentToolTip).setStyle("borderStyle", "errorTipBelow");
                        };
                        currentToolTip["text"] = currentToolTip["text"];
                        if (!isNaN(_local9)){
                            Object(toolTipClass).maxWidth = _local9;
                        };
                    };
                };
                sizeTip(currentToolTip);
                _local6 = new Point(_local1, _local2);
                _local7 = currentToolTip;
                _local1 = _local6.x;
                _local2 = _local6.y;
            } else {
                _local10 = getSystemManager(currentTarget);
                _local1 = (DisplayObject(_local10).mouseX + 11);
                _local2 = (DisplayObject(_local10).mouseY + 22);
                _local11 = currentToolTip.width;
                if ((_local1 + _local11) > _local3){
                    _local1 = (_local3 - _local11);
                };
                _local12 = currentToolTip.height;
                if ((_local2 + _local12) > _local4){
                    _local2 = (_local4 - _local12);
                };
                _local6 = new Point(_local1, _local2);
                _local6 = DisplayObject(_local10).localToGlobal(_local6);
                _local6 = DisplayObject(sandboxRoot).globalToLocal(_local6);
                _local1 = _local6.x;
                _local2 = _local6.y;
            };
            currentToolTip.move(_local1, _local2);
        }
        mx_internal function errorTipMouseOutHandler(_arg1:MouseEvent):void{
            checkIfTargetChanged(_arg1.relatedObject);
        }
        mx_internal function findTarget(_arg1:DisplayObject):void{
            while (_arg1) {
                if ((_arg1 is IValidatorListener)){
                    currentText = IValidatorListener(_arg1).errorString;
                    if (((!((currentText == null))) && (!((currentText == ""))))){
                        currentTarget = _arg1;
                        isError = true;
                        return;
                    };
                };
                if ((_arg1 is IToolTipManagerClient)){
                    currentText = IToolTipManagerClient(_arg1).toolTip;
                    if (currentText != null){
                        currentTarget = _arg1;
                        isError = false;
                        return;
                    };
                };
                _arg1 = _arg1.parent;
            };
            currentText = null;
            currentTarget = null;
        }
        public function registerToolTip(_arg1:DisplayObject, _arg2:String, _arg3:String):void{
            if (((!(_arg2)) && (_arg3))){
                _arg1.addEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
                _arg1.addEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
                if (mouseIsOver(_arg1)){
                    showImmediately(_arg1);
                };
            } else {
                if (((_arg2) && (!(_arg3)))){
                    _arg1.removeEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
                    _arg1.removeEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
                    if (mouseIsOver(_arg1)){
                        hideImmediately(_arg1);
                    };
                };
            };
        }
        private function showImmediately(_arg1:DisplayObject):void{
            var _local2:Number = ToolTipManager.showDelay;
            ToolTipManager.showDelay = 0;
            checkIfTargetChanged(_arg1);
            ToolTipManager.showDelay = _local2;
        }
        public function set hideDelay(_arg1:Number):void{
            _hideDelay = _arg1;
        }
        private function getSystemManager(_arg1:DisplayObject):ISystemManager{
            return ((((_arg1 is IUIComponent)) ? IUIComponent(_arg1).systemManager : null));
        }
        public function set currentTarget(_arg1:DisplayObject):void{
            _currentTarget = _arg1;
        }
        public function sizeTip(_arg1:IToolTip):void{
            if ((_arg1 is IInvalidating)){
                IInvalidating(_arg1).validateNow();
            };
            _arg1.setActualSize(_arg1.getExplicitOrMeasuredWidth(), _arg1.getExplicitOrMeasuredHeight());
        }
        public function set showEffect(_arg1:IAbstractEffect):void{
            _showEffect = (_arg1 as IAbstractEffect);
        }
        mx_internal function targetChanged():void{
            var _local1:ToolTipEvent;
            var _local2:InterManagerRequest;
            if (!initialized){
                initialize();
            };
            if (((previousTarget) && (currentToolTip))){
                if ((currentToolTip is IToolTip)){
                    _local1 = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
                    _local1.toolTip = currentToolTip;
                    previousTarget.dispatchEvent(_local1);
                } else {
                    _local2 = new InterManagerRequest(InterManagerRequest.TOOLTIP_MANAGER_REQUEST);
                    _local2.name = ToolTipEvent.TOOL_TIP_HIDE;
                    sandboxRoot.dispatchEvent(_local2);
                };
            };
            reset();
            if (currentTarget){
                if (currentText == ""){
                    return;
                };
                _local1 = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
                currentTarget.dispatchEvent(_local1);
                if ((((showDelay == 0)) || (scrubTimer.running))){
                    createTip();
                    initializeTip();
                    positionTip();
                    showTip();
                } else {
                    showTimer.delay = showDelay;
                    showTimer.start();
                };
            };
        }
        public function set hideEffect(_arg1:IAbstractEffect):void{
            _hideEffect = (_arg1 as IAbstractEffect);
        }
        mx_internal function hideTimer_timerHandler(_arg1:TimerEvent):void{
            hideTip();
        }
        mx_internal function initializeTip():void{
            if ((currentToolTip is IToolTip)){
                IToolTip(currentToolTip).text = currentText;
            };
            if (((isError) && ((currentToolTip is IStyleClient)))){
                IStyleClient(currentToolTip).setStyle("styleName", "errorTip");
            };
            sizeTip(currentToolTip);
            if ((currentToolTip is IStyleClient)){
                if (showEffect){
                    IStyleClient(currentToolTip).setStyle("showEffect", showEffect);
                };
                if (hideEffect){
                    IStyleClient(currentToolTip).setStyle("hideEffect", hideEffect);
                };
            };
            if (((showEffect) || (hideEffect))){
                currentToolTip.addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            };
        }
        public function get showEffect():IAbstractEffect{
            return (_showEffect);
        }
        mx_internal function toolTipMouseOverHandler(_arg1:MouseEvent):void{
            checkIfTargetChanged(DisplayObject(_arg1.target));
        }
        mx_internal function hideTip():void{
            var _local1:ToolTipEvent;
            var _local2:ISystemManager;
            if (previousTarget){
                _local1 = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
                _local1.toolTip = currentToolTip;
                previousTarget.dispatchEvent(_local1);
            };
            if (currentToolTip){
                currentToolTip.visible = false;
            };
            if (isError){
                if (currentTarget){
                    currentTarget.removeEventListener("change", changeHandler);
                };
            } else {
                if (previousTarget){
                    _local2 = getSystemManager(previousTarget);
                    _local2.removeEventListener(MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler);
                };
            };
            if (!hideEffect){
                hideEffectEnded();
            };
        }
        mx_internal function createTip():void{
            var _local1:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_CREATE);
            currentTarget.dispatchEvent(_local1);
            if (_local1.toolTip){
                currentToolTip = _local1.toolTip;
            } else {
                currentToolTip = new toolTipClass();
            };
            currentToolTip.visible = false;
            var _local2:ISystemManager = (getSystemManager(currentTarget) as ISystemManager);
            _local2.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", (currentToolTip as DisplayObject));
        }

    }
}//package mx.managers 
