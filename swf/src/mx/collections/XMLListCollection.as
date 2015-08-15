package mx.collections {

    public class XMLListCollection extends ListCollectionView {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public function XMLListCollection(_arg1:XMLList=null){
            this.source = _arg1;
        }
        public function child(_arg1:Object):XMLList{
            var propertyName:* = _arg1;
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.child(propertyName));
            }));
        }
        private function execXMLListFunction(_arg1:Function):XMLList{
            var _local2:int;
            var _local3:XMLList;
            var _local4:int;
            var _local5:Object;
            if (!localIndex){
                return (_arg1(source));
            };
            _local2 = localIndex.length;
            _local3 = new XMLList("");
            _local4 = 0;
            while (_local4 < _local2) {
                _local5 = localIndex[_local4];
                _local3 = (_local3 + _arg1(_local5));
                _local4++;
            };
            return (_local3);
        }
        override public function toString():String{
            var _local1:String;
            var _local2:int;
            if (!localIndex){
                return (source.toString());
            };
            _local1 = "";
            _local2 = 0;
            while (_local2 < localIndex.length) {
                if (_local2 > 0){
                    _local1 = (_local1 + "\n");
                };
                _local1 = (_local1 + localIndex[_local2].toString());
                _local2++;
            };
            return (_local1);
        }
        public function text():XMLList{
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.text());
            }));
        }
        public function toXMLString():String{
            var _local1:String;
            var _local2:int;
            if (!localIndex){
                return (source.toXMLString());
            };
            _local1 = "";
            _local2 = 0;
            while (_local2 < localIndex.length) {
                if (_local2 > 0){
                    _local1 = (_local1 + "\n");
                };
                _local1 = (_local1 + localIndex[_local2].toXMLString());
                _local2++;
            };
            return (_local1);
        }
        public function copy():XMLList{
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (XMLList(_arg1.copy()));
            }));
        }
        public function set source(_arg1:XMLList):void{
            if (list){
                XMLListAdapter(list).source = null;
            };
            list = new XMLListAdapter(_arg1);
        }
        public function attributes():XMLList{
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.attributes());
            }));
        }
        public function get source():XMLList{
            return (((list) ? XMLListAdapter(list).source : null));
        }
        public function attribute(_arg1:Object):XMLList{
            var attributeName:* = _arg1;
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.attribute(attributeName));
            }));
        }
        public function descendants(_arg1:Object="*"):XMLList{
            var name:String = _arg1;
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.descendants(name));
            }));
        }
        public function elements(_arg1:String="*"):XMLList{
            var name:String = _arg1;
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.elements(name));
            }));
        }
        public function children():XMLList{
            return (execXMLListFunction(function (_arg1:Object):XMLList{
                return (_arg1.children());
            }));
        }

    }
}//package mx.collections 
