package mx.binding {
    import flash.utils.*;
    import mx.collections.errors.*;

    public class Binding {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal var destFunc:Function;
        mx_internal var srcFunc:Function;
        mx_internal var destString:String;
        mx_internal var document:Object;
        private var hasHadValue:Boolean;
        mx_internal var disabledRequests:Dictionary;
        mx_internal var isExecuting:Boolean;
        mx_internal var isHandlingEvent:Boolean;
        public var twoWayCounterpart:Binding;
        private var wrappedFunctionSuccessful:Boolean;
        mx_internal var _isEnabled:Boolean;
        public var uiComponentWatcher:int;
        private var lastValue:Object;

        public function Binding(_arg1:Object, _arg2:Function, _arg3:Function, _arg4:String){
            this.document = _arg1;
            this.srcFunc = _arg2;
            this.destFunc = _arg3;
            this.destString = _arg4;
            _isEnabled = true;
            isExecuting = false;
            isHandlingEvent = false;
            hasHadValue = false;
            uiComponentWatcher = -1;
            BindingManager.addBinding(_arg1, _arg4, this);
        }
        private function registerDisabledExecute(_arg1:Object):void{
            if (_arg1 != null){
                disabledRequests = ((disabledRequests)!=null) ? disabledRequests : new Dictionary(true);
                disabledRequests[_arg1] = true;
            };
        }
        protected function wrapFunctionCall(_arg1:Object, _arg2:Function, _arg3:Object=null, ... _args):Object{
            var result:* = null;
            var thisArg:* = _arg1;
            var wrappedFunction:* = _arg2;
            var object = _arg3;
            var args:* = _args;
            wrappedFunctionSuccessful = false;
            try {
                result = wrappedFunction.apply(thisArg, args);
                wrappedFunctionSuccessful = true;
                return (result);
            } catch(itemPendingError:ItemPendingError) {
                itemPendingError.addResponder(new EvalBindingResponder(this, object));
                if (BindingManager.debugDestinationStrings[destString]){
                    trace(((("Binding: destString = " + destString) + ", error = ") + itemPendingError));
                };
            } catch(rangeError:RangeError) {
                if (BindingManager.debugDestinationStrings[destString]){
                    trace(((("Binding: destString = " + destString) + ", error = ") + rangeError));
                };
            } catch(error:Error) {
                if (((((((((!((error.errorID == 1006))) && (!((error.errorID == 1009))))) && (!((error.errorID == 1010))))) && (!((error.errorID == 1055))))) && (!((error.errorID == 1069))))){
                    throw (error);
                };
                if (BindingManager.debugDestinationStrings[destString]){
                    trace(((("Binding: destString = " + destString) + ", error = ") + error));
                };
            };
            return (null);
        }
        public function watcherFired(_arg1:Boolean, _arg2:int):void{
            var commitEvent:* = _arg1;
            var cloneIndex:* = _arg2;
            if (isHandlingEvent){
                return;
            };
            try {
                isHandlingEvent = true;
                execute(cloneIndex);
            } finally {
                isHandlingEvent = false;
            };
        }
        private function nodeSeqEqual(_arg1:XMLList, _arg2:XMLList):Boolean{
            var _local4:uint;
            var _local3:uint = _arg1.length();
            if (_local3 == _arg2.length()){
                _local4 = 0;
                while ((((_local4 < _local3)) && ((_arg1[_local4] === _arg2[_local4])))) {
                    _local4++;
                };
                return ((_local4 == _local3));
            };
            return (false);
        }
        mx_internal function set isEnabled(_arg1:Boolean):void{
            _isEnabled = _arg1;
            if (_arg1){
                processDisabledRequests();
            };
        }
        private function processDisabledRequests():void{
            var _local1:Object;
            if (disabledRequests != null){
                for (_local1 in disabledRequests) {
                    execute(_local1);
                };
                disabledRequests = null;
            };
        }
        public function execute(_arg1:Object=null):void{
            var o = _arg1;
            if (!isEnabled){
                if (o != null){
                    registerDisabledExecute(o);
                };
                return;
            };
            if (((isExecuting) || (((twoWayCounterpart) && (twoWayCounterpart.isExecuting))))){
                hasHadValue = true;
                return;
            };
            try {
                isExecuting = true;
                wrapFunctionCall(this, innerExecute, o);
            } finally {
                isExecuting = false;
            };
        }
        mx_internal function get isEnabled():Boolean{
            return (_isEnabled);
        }
        private function innerExecute():void{
            var _local1:Object = wrapFunctionCall(document, srcFunc);
            if (BindingManager.debugDestinationStrings[destString]){
                trace(((("Binding: destString = " + destString) + ", srcFunc result = ") + _local1));
            };
            if (((hasHadValue) || (wrappedFunctionSuccessful))){
                if (((!((((((lastValue is XML)) && (lastValue.hasComplexContent()))) && ((lastValue === _local1))))) && (!((((((((lastValue is XMLList)) && (lastValue.hasComplexContent()))) && ((_local1 is XMLList)))) && (nodeSeqEqual((lastValue as XMLList), (_local1 as XMLList)))))))){
                    destFunc.call(document, _local1);
                    lastValue = _local1;
                    hasHadValue = true;
                };
            };
        }

    }
}//package mx.binding 
