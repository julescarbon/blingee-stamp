package mx.core {

    public class ComponentDescriptor {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var events:Object;
        public var type:Class;
        public var document:Object;
        private var _properties:Object;
        public var propertiesFactory:Function;
        public var id:String;

        public function ComponentDescriptor(_arg1:Object){
            var _local2:String;
            super();
            for (_local2 in _arg1) {
                this[_local2] = _arg1[_local2];
            };
        }
        public function toString():String{
            return (("ComponentDescriptor_" + id));
        }
        public function invalidateProperties():void{
            _properties = null;
        }
        public function get properties():Object{
            var _local1:Array;
            var _local2:int;
            var _local3:int;
            if (_properties){
                return (_properties);
            };
            if (propertiesFactory != null){
                _properties = propertiesFactory.call(document);
            };
            if (_properties){
                _local1 = _properties.childDescriptors;
                if (_local1){
                    _local2 = _local1.length;
                    _local3 = 0;
                    while (_local3 < _local2) {
                        _local1[_local3].document = document;
                        _local3++;
                    };
                };
            } else {
                _properties = {};
            };
            return (_properties);
        }

    }
}//package mx.core 
