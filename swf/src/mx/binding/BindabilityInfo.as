package mx.binding {
    import mx.events.*;

    public class BindabilityInfo {

        public static const METHOD:String = "method";
        public static const ACCESSOR:String = "accessor";
        public static const CHANGE_EVENT:String = "ChangeEvent";
        public static const NON_COMMITTING_CHANGE_EVENT:String = "NonCommittingChangeEvent";
        public static const BINDABLE:String = "Bindable";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const MANAGED:String = "Managed";

        private var classChangeEvents:Object;
        private var typeDescription:XML;
        private var childChangeEvents:Object;

        public function BindabilityInfo(_arg1:XML){
            childChangeEvents = {};
            super();
            this.typeDescription = _arg1;
        }
        private function addChangeEvents(_arg1:XMLList, _arg2:Object, _arg3:Boolean):void{
            var _local4:XML;
            var _local5:XMLList;
            var _local6:String;
            for each (_local4 in _arg1) {
                _local5 = _local4.arg;
                if (_local5.length() > 0){
                    _local6 = _local5[0].@value;
                    _arg2[_local6] = _arg3;
                } else {
                    trace((("warning: unconverted Bindable metadata in class '" + typeDescription.@name) + "'"));
                };
            };
        }
        private function getClassChangeEvents():Object{
            if (!classChangeEvents){
                classChangeEvents = {};
                addBindabilityEvents(typeDescription.metadata, classChangeEvents);
                if (typeDescription.metadata.(@name == MANAGED).length() > 0){
                    classChangeEvents[PropertyChangeEvent.PROPERTY_CHANGE] = true;
                };
            };
            return (classChangeEvents);
        }
        private function addBindabilityEvents(_arg1:XMLList, _arg2:Object):void{
            var metadata:* = _arg1;
            var eventListObj:* = _arg2;
            addChangeEvents(metadata.(@name == BINDABLE), eventListObj, true);
            addChangeEvents(metadata.(@name == CHANGE_EVENT), eventListObj, true);
            addChangeEvents(metadata.(@name == NON_COMMITTING_CHANGE_EVENT), eventListObj, false);
        }
        private function copyProps(_arg1:Object, _arg2:Object):Object{
            var _local3:String;
            for (_local3 in _arg1) {
                _arg2[_local3] = _arg1[_local3];
            };
            return (_arg2);
        }
        public function getChangeEvents(_arg1:String):Object{
            var childDesc:* = null;
            var numChildren:* = 0;
            var childName:* = _arg1;
            var changeEvents:* = childChangeEvents[childName];
            if (!changeEvents){
                changeEvents = copyProps(getClassChangeEvents(), {});
                childDesc = (typeDescription.accessor.(@name == childName) + typeDescription.method.(@name == childName));
                numChildren = childDesc.length();
                if (numChildren == 0){
                    if (!typeDescription.@dynamic){
                        trace((((("warning: no describeType entry for '" + childName) + "' on non-dynamic type '") + typeDescription.@name) + "'"));
                    };
                } else {
                    if (numChildren > 1){
                        trace(((((("warning: multiple describeType entries for '" + childName) + "' on type '") + typeDescription.@name) + "':\n") + childDesc));
                    };
                    addBindabilityEvents(childDesc.metadata, changeEvents);
                };
                childChangeEvents[childName] = changeEvents;
            };
            return (changeEvents);
        }

    }
}//package mx.binding 
