package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.containers.*;
    import mx.controls.alertClasses.*;

    public class Alert extends Panel {

        public static const NONMODAL:uint = 0x8000;
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const NO:uint = 2;
        public static const YES:uint = 1;
        public static const OK:uint = 4;
        public static const CANCEL:uint = 8;

        mx_internal static var createAccessibilityImplementation:Function;
        private static var cancelLabelOverride:String;
        private static var _resourceManager:IResourceManager;
        public static var buttonHeight:Number = 22;
        private static var noLabelOverride:String;
        private static var _yesLabel:String;
        private static var yesLabelOverride:String;
        public static var buttonWidth:Number = (((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) ? 60 : 65);
;
        private static var _okLabel:String;
        private static var initialized:Boolean = false;
        private static var _cancelLabel:String;
        private static var okLabelOverride:String;
        private static var _noLabel:String;

        mx_internal var alertForm:AlertForm;
        public var defaultButtonFlag:uint = 4;
        public var text:String = "";
        public var buttonFlags:uint = 4;
        public var iconClass:Class;

        public function Alert(){
            title = "";
        }
        private static function initialize():void{
            if (!initialized){
                resourceManager.addEventListener(Event.CHANGE, static_resourceManager_changeHandler, false, 0, true);
                static_resourcesChanged();
                initialized = true;
            };
        }
        private static function static_resourcesChanged():void{
            cancelLabel = cancelLabelOverride;
            noLabel = noLabelOverride;
            okLabel = okLabelOverride;
            yesLabel = yesLabelOverride;
        }
        public static function get cancelLabel():String{
            initialize();
            return (_cancelLabel);
        }
        public static function set yesLabel(_arg1:String):void{
            yesLabelOverride = _arg1;
            _yesLabel = ((_arg1)!=null) ? _arg1 : resourceManager.getString("controls", "yesLabel");
        }
        private static function static_creationCompleteHandler(_arg1:FlexEvent):void{
            if ((((_arg1.target is IFlexDisplayObject)) && ((_arg1.eventPhase == EventPhase.AT_TARGET)))){
                _arg1.target.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
                PopUpManager.centerPopUp(IFlexDisplayObject(_arg1.target));
            };
        }
        public static function get noLabel():String{
            initialize();
            return (_noLabel);
        }
        public static function set cancelLabel(_arg1:String):void{
            cancelLabelOverride = _arg1;
            _cancelLabel = ((_arg1)!=null) ? _arg1 : resourceManager.getString("controls", "cancelLabel");
        }
        private static function get resourceManager():IResourceManager{
            if (!_resourceManager){
                _resourceManager = ResourceManager.getInstance();
            };
            return (_resourceManager);
        }
        public static function get yesLabel():String{
            initialize();
            return (_yesLabel);
        }
        public static function set noLabel(_arg1:String):void{
            noLabelOverride = _arg1;
            _noLabel = ((_arg1)!=null) ? _arg1 : resourceManager.getString("controls", "noLabel");
        }
        private static function static_resourceManager_changeHandler(_arg1:Event):void{
            static_resourcesChanged();
        }
        public static function set okLabel(_arg1:String):void{
            okLabelOverride = _arg1;
            _okLabel = ((_arg1)!=null) ? _arg1 : resourceManager.getString("controls", "okLabel");
        }
        public static function get okLabel():String{
            initialize();
            return (_okLabel);
        }
        public static function show(_arg1:String="", _arg2:String="", _arg3:uint=4, _arg4:Sprite=null, _arg5:Function=null, _arg6:Class=null, _arg7:uint=4):Alert{
            var _local10:ISystemManager;
            var _local8:Boolean = (((_arg3 & Alert.NONMODAL)) ? false : true);
            if (!_arg4){
                _local10 = ISystemManager(Application.application.systemManager);
                if (_local10.useSWFBridge()){
                    _arg4 = Sprite(_local10.getSandboxRoot());
                } else {
                    _arg4 = Sprite(Application.application);
                };
            };
            var _local9:Alert = new (Alert)();
            if ((((((((_arg3 & Alert.OK)) || ((_arg3 & Alert.CANCEL)))) || ((_arg3 & Alert.YES)))) || ((_arg3 & Alert.NO)))){
                _local9.buttonFlags = _arg3;
            };
            if ((((((((_arg7 == Alert.OK)) || ((_arg7 == Alert.CANCEL)))) || ((_arg7 == Alert.YES)))) || ((_arg7 == Alert.NO)))){
                _local9.defaultButtonFlag = _arg7;
            };
            _local9.text = _arg1;
            _local9.title = _arg2;
            _local9.iconClass = _arg6;
            if (_arg5 != null){
                _local9.addEventListener(CloseEvent.CLOSE, _arg5);
            };
            if ((_arg4 is UIComponent)){
                _local9.moduleFactory = UIComponent(_arg4).moduleFactory;
            };
            PopUpManager.addPopUp(_local9, _arg4, _local8);
            _local9.setActualSize(_local9.getExplicitOrMeasuredWidth(), _local9.getExplicitOrMeasuredHeight());
            _local9.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
            return (_local9);
        }

        override public function styleChanged(_arg1:String):void{
            var _local2:String;
            super.styleChanged(_arg1);
            if (_arg1 == "messageStyleName"){
                _local2 = getStyle("messageStyleName");
                styleName = _local2;
            };
            if (alertForm){
                alertForm.styleChanged(_arg1);
            };
        }
        override protected function measure():void{
            super.measure();
            var _local1:EdgeMetrics = viewMetrics;
            measuredWidth = Math.max(measuredWidth, ((alertForm.getExplicitOrMeasuredWidth() + _local1.left) + _local1.right));
            measuredHeight = ((alertForm.getExplicitOrMeasuredHeight() + _local1.top) + _local1.bottom);
        }
        override protected function resourcesChanged():void{
            super.resourcesChanged();
            static_resourcesChanged();
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:EdgeMetrics = viewMetrics;
            alertForm.setActualSize(((((_arg1 - _local3.left) - _local3.right) - getStyle("paddingLeft")) - getStyle("paddingRight")), ((((_arg2 - _local3.top) - _local3.bottom) - getStyle("paddingTop")) - getStyle("paddingBottom")));
        }
        override protected function createChildren():void{
            super.createChildren();
            var _local1:String = getStyle("messageStyleName");
            if (_local1){
                styleName = _local1;
            };
            if (!alertForm){
                alertForm = new AlertForm();
                alertForm.styleName = this;
                addChild(alertForm);
            };
        }
        override protected function initializeAccessibility():void{
            if (Alert.createAccessibilityImplementation != null){
                Alert.createAccessibilityImplementation(this);
            };
        }

    }
}//package mx.controls 
