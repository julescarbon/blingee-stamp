package mx.managers {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.managers.layoutClasses.*;

    public class LayoutManager extends EventDispatcher implements ILayoutManager {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var instance:LayoutManager;

        private var invalidateClientPropertiesFlag:Boolean = false;
        private var invalidateDisplayListQueue:PriorityQueue;
        private var updateCompleteQueue:PriorityQueue;
        private var invalidateDisplayListFlag:Boolean = false;
        private var invalidateClientSizeFlag:Boolean = false;
        private var invalidateSizeQueue:PriorityQueue;
        private var originalFrameRate:Number;
        private var invalidatePropertiesFlag:Boolean = false;
        private var invalidatePropertiesQueue:PriorityQueue;
        private var invalidateSizeFlag:Boolean = false;
        private var callLaterPending:Boolean = false;
        private var _usePhasedInstantiation:Boolean = false;
        private var callLaterObject:UIComponent;
        private var targetLevel:int = 2147483647;

        public function LayoutManager(){
            updateCompleteQueue = new PriorityQueue();
            invalidatePropertiesQueue = new PriorityQueue();
            invalidateSizeQueue = new PriorityQueue();
            invalidateDisplayListQueue = new PriorityQueue();
            super();
        }
        public static function getInstance():LayoutManager{
            if (!instance){
                instance = new (LayoutManager)();
            };
            return (instance);
        }

        public function set usePhasedInstantiation(_arg1:Boolean):void{
            var sm:* = null;
            var stage:* = null;
            var value:* = _arg1;
            if (_usePhasedInstantiation != value){
                _usePhasedInstantiation = value;
                try {
                    sm = SystemManagerGlobals.topLevelSystemManagers[0];
                    stage = SystemManagerGlobals.topLevelSystemManagers[0].stage;
                    if (stage){
                        if (value){
                            originalFrameRate = stage.frameRate;
                            stage.frameRate = 1000;
                        } else {
                            stage.frameRate = originalFrameRate;
                        };
                    };
                } catch(e:SecurityError) {
                };
            };
        }
        private function waitAFrame():void{
            callLaterObject.callLater(doPhasedInstantiation);
        }
        public function validateClient(_arg1:ILayoutManagerClient, _arg2:Boolean=false):void{
            var _local3:ILayoutManagerClient;
            var _local4:int;
            var _local5:Boolean;
            var _local6:int = targetLevel;
            if (targetLevel == int.MAX_VALUE){
                targetLevel = _arg1.nestLevel;
            };
            while (!(_local5)) {
                _local5 = true;
                _local3 = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(_arg1));
                while (_local3) {
                    _local3.validateProperties();
                    if (!_local3.updateCompletePendingFlag){
                        updateCompleteQueue.addObject(_local3, _local3.nestLevel);
                        _local3.updateCompletePendingFlag = true;
                    };
                    _local3 = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(_arg1));
                };
                if (invalidatePropertiesQueue.isEmpty()){
                    invalidatePropertiesFlag = false;
                    invalidateClientPropertiesFlag = false;
                };
                _local3 = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(_arg1));
                while (_local3) {
                    _local3.validateSize();
                    if (!_local3.updateCompletePendingFlag){
                        updateCompleteQueue.addObject(_local3, _local3.nestLevel);
                        _local3.updateCompletePendingFlag = true;
                    };
                    if (invalidateClientPropertiesFlag){
                        _local3 = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(_arg1));
                        if (_local3){
                            invalidatePropertiesQueue.addObject(_local3, _local3.nestLevel);
                            _local5 = false;
                            break;
                        };
                    };
                    _local3 = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(_arg1));
                };
                if (invalidateSizeQueue.isEmpty()){
                    invalidateSizeFlag = false;
                    invalidateClientSizeFlag = false;
                };
                if (!_arg2){
                    _local3 = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(_arg1));
                    while (_local3) {
                        _local3.validateDisplayList();
                        if (!_local3.updateCompletePendingFlag){
                            updateCompleteQueue.addObject(_local3, _local3.nestLevel);
                            _local3.updateCompletePendingFlag = true;
                        };
                        if (invalidateClientPropertiesFlag){
                            _local3 = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallestChild(_arg1));
                            if (_local3){
                                invalidatePropertiesQueue.addObject(_local3, _local3.nestLevel);
                                _local5 = false;
                                break;
                            };
                        };
                        if (invalidateClientSizeFlag){
                            _local3 = ILayoutManagerClient(invalidateSizeQueue.removeLargestChild(_arg1));
                            if (_local3){
                                invalidateSizeQueue.addObject(_local3, _local3.nestLevel);
                                _local5 = false;
                                break;
                            };
                        };
                        _local3 = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallestChild(_arg1));
                    };
                    if (invalidateDisplayListQueue.isEmpty()){
                        invalidateDisplayListFlag = false;
                    };
                };
            };
            if (_local6 == int.MAX_VALUE){
                targetLevel = int.MAX_VALUE;
                if (!_arg2){
                    _local3 = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(_arg1));
                    while (_local3) {
                        if (!_local3.initialized){
                            _local3.initialized = true;
                        };
                        _local3.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
                        _local3.updateCompletePendingFlag = false;
                        _local3 = ILayoutManagerClient(updateCompleteQueue.removeLargestChild(_arg1));
                    };
                };
            };
        }
        private function validateProperties():void{
            var _local1:ILayoutManagerClient = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallest());
            while (_local1) {
                _local1.validateProperties();
                if (!_local1.updateCompletePendingFlag){
                    updateCompleteQueue.addObject(_local1, _local1.nestLevel);
                    _local1.updateCompletePendingFlag = true;
                };
                _local1 = ILayoutManagerClient(invalidatePropertiesQueue.removeSmallest());
            };
            if (invalidatePropertiesQueue.isEmpty()){
                invalidatePropertiesFlag = false;
            };
        }
        public function invalidateProperties(_arg1:ILayoutManagerClient):void{
            if (((!(invalidatePropertiesFlag)) && (ApplicationGlobals.application.systemManager))){
                invalidatePropertiesFlag = true;
                if (!callLaterPending){
                    if (!callLaterObject){
                        callLaterObject = new UIComponent();
                        callLaterObject.systemManager = ApplicationGlobals.application.systemManager;
                        callLaterObject.callLater(waitAFrame);
                    } else {
                        callLaterObject.callLater(doPhasedInstantiation);
                    };
                    callLaterPending = true;
                };
            };
            if (targetLevel <= _arg1.nestLevel){
                invalidateClientPropertiesFlag = true;
            };
            invalidatePropertiesQueue.addObject(_arg1, _arg1.nestLevel);
        }
        public function invalidateDisplayList(_arg1:ILayoutManagerClient):void{
            if (((!(invalidateDisplayListFlag)) && (ApplicationGlobals.application.systemManager))){
                invalidateDisplayListFlag = true;
                if (!callLaterPending){
                    if (!callLaterObject){
                        callLaterObject = new UIComponent();
                        callLaterObject.systemManager = ApplicationGlobals.application.systemManager;
                        callLaterObject.callLater(waitAFrame);
                    } else {
                        callLaterObject.callLater(doPhasedInstantiation);
                    };
                    callLaterPending = true;
                };
            } else {
                if (((!(invalidateDisplayListFlag)) && (!(ApplicationGlobals.application.systemManager)))){
                };
            };
            invalidateDisplayListQueue.addObject(_arg1, _arg1.nestLevel);
        }
        private function validateDisplayList():void{
            var _local1:ILayoutManagerClient = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
            while (_local1) {
                _local1.validateDisplayList();
                if (!_local1.updateCompletePendingFlag){
                    updateCompleteQueue.addObject(_local1, _local1.nestLevel);
                    _local1.updateCompletePendingFlag = true;
                };
                _local1 = ILayoutManagerClient(invalidateDisplayListQueue.removeSmallest());
            };
            if (invalidateDisplayListQueue.isEmpty()){
                invalidateDisplayListFlag = false;
            };
        }
        public function validateNow():void{
            var _local1:int;
            if (!usePhasedInstantiation){
                _local1 = 0;
                while (((callLaterPending) && ((_local1 < 100)))) {
                    doPhasedInstantiation();
                };
            };
        }
        private function validateSize():void{
            var _local1:ILayoutManagerClient = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
            while (_local1) {
                _local1.validateSize();
                if (!_local1.updateCompletePendingFlag){
                    updateCompleteQueue.addObject(_local1, _local1.nestLevel);
                    _local1.updateCompletePendingFlag = true;
                };
                _local1 = ILayoutManagerClient(invalidateSizeQueue.removeLargest());
            };
            if (invalidateSizeQueue.isEmpty()){
                invalidateSizeFlag = false;
            };
        }
        private function doPhasedInstantiation():void{
            var _local1:ILayoutManagerClient;
            if (usePhasedInstantiation){
                if (invalidatePropertiesFlag){
                    validateProperties();
                    ApplicationGlobals.application.dispatchEvent(new Event("validatePropertiesComplete"));
                } else {
                    if (invalidateSizeFlag){
                        validateSize();
                        ApplicationGlobals.application.dispatchEvent(new Event("validateSizeComplete"));
                    } else {
                        if (invalidateDisplayListFlag){
                            validateDisplayList();
                            ApplicationGlobals.application.dispatchEvent(new Event("validateDisplayListComplete"));
                        };
                    };
                };
            } else {
                if (invalidatePropertiesFlag){
                    validateProperties();
                };
                if (invalidateSizeFlag){
                    validateSize();
                };
                if (invalidateDisplayListFlag){
                    validateDisplayList();
                };
            };
            if (((((invalidatePropertiesFlag) || (invalidateSizeFlag))) || (invalidateDisplayListFlag))){
                callLaterObject.callLater(doPhasedInstantiation);
            } else {
                usePhasedInstantiation = false;
                callLaterPending = false;
                _local1 = ILayoutManagerClient(updateCompleteQueue.removeLargest());
                while (_local1) {
                    if (((!(_local1.initialized)) && (_local1.processedDescriptors))){
                        _local1.initialized = true;
                    };
                    _local1.dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
                    _local1.updateCompletePendingFlag = false;
                    _local1 = ILayoutManagerClient(updateCompleteQueue.removeLargest());
                };
                dispatchEvent(new FlexEvent(FlexEvent.UPDATE_COMPLETE));
            };
        }
        public function isInvalid():Boolean{
            return (((((invalidatePropertiesFlag) || (invalidateSizeFlag))) || (invalidateDisplayListFlag)));
        }
        public function get usePhasedInstantiation():Boolean{
            return (_usePhasedInstantiation);
        }
        public function invalidateSize(_arg1:ILayoutManagerClient):void{
            if (((!(invalidateSizeFlag)) && (ApplicationGlobals.application.systemManager))){
                invalidateSizeFlag = true;
                if (!callLaterPending){
                    if (!callLaterObject){
                        callLaterObject = new UIComponent();
                        callLaterObject.systemManager = ApplicationGlobals.application.systemManager;
                        callLaterObject.callLater(waitAFrame);
                    } else {
                        callLaterObject.callLater(doPhasedInstantiation);
                    };
                    callLaterPending = true;
                };
            };
            if (targetLevel <= _arg1.nestLevel){
                invalidateClientSizeFlag = true;
            };
            invalidateSizeQueue.addObject(_arg1, _arg1.nestLevel);
        }

    }
}//package mx.managers 
