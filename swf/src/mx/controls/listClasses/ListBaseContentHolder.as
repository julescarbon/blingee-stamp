package mx.controls.listClasses {
    import flash.display.*;
    import mx.core.*;
    import mx.collections.*;

    public class ListBaseContentHolder extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var listItems:Array;
        public var topOffset:Number = 0;
        public var rightOffset:Number = 0;
        private var maskShape:Shape;
        public var selectionLayer:Sprite;
        private var parentList:ListBase;
        public var iterator:IViewCursor;
        public var rowInfo:Array;
        public var bottomOffset:Number = 0;
        public var leftOffset:Number = 0;
        public var visibleData:Object;
        mx_internal var allowItemSizeChangeNotification:Boolean = true;

        public function ListBaseContentHolder(_arg1:ListBase){
            var _local2:Graphics;
            visibleData = {};
            listItems = [];
            rowInfo = [];
            super();
            this.parentList = _arg1;
            setStyle("backgroundColor", "");
            setStyle("borderStyle", "none");
            if (!selectionLayer){
                selectionLayer = new FlexSprite();
                selectionLayer.name = "selectionLayer";
                selectionLayer.mouseEnabled = false;
                addChild(selectionLayer);
                _local2 = selectionLayer.graphics;
                _local2.beginFill(0, 0);
                _local2.drawRect(0, 0, 10, 10);
                _local2.endFill();
            };
        }
        override public function set focusPane(_arg1:Sprite):void{
            var _local2:Graphics;
            if (_arg1){
                if (!maskShape){
                    maskShape = new FlexShape();
                    maskShape.name = "mask";
                    _local2 = maskShape.graphics;
                    _local2.beginFill(0xFFFFFF);
                    _local2.drawRect(-2, -2, (parentList.width + 2), (parentList.height + 2));
                    _local2.endFill();
                    addChild(maskShape);
                };
                maskShape.visible = false;
                _arg1.mask = maskShape;
            } else {
                if (parentList.focusPane.mask == maskShape){
                    parentList.focusPane.mask = null;
                };
            };
            parentList.focusPane = _arg1;
            _arg1.x = x;
            _arg1.y = y;
        }
        public function get heightExcludingOffsets():Number{
            return (((height + topOffset) - bottomOffset));
        }
        public function get widthExcludingOffsets():Number{
            return (((width + leftOffset) - rightOffset));
        }
        override public function invalidateSize():void{
            if (allowItemSizeChangeNotification){
                parentList.invalidateList();
            };
        }
        mx_internal function getParentList():ListBase{
            return (parentList);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Graphics = selectionLayer.graphics;
            _local3.clear();
            if ((((_arg1 > 0)) && ((_arg2 > 0)))){
                _local3.beginFill(0x808080, 0);
                _local3.drawRect(0, 0, _arg1, _arg2);
                _local3.endFill();
            };
            if (maskShape){
                maskShape.width = _arg1;
                maskShape.height = _arg2;
            };
        }

    }
}//package mx.controls.listClasses 
