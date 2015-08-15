package mx.controls.listClasses {
    import flash.display.*;
    import mx.core.*;

    public class ListItemDragProxy extends UIComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        override protected function createChildren():void{
            var _local4:IListItemRenderer;
            var _local5:IListItemRenderer;
            var _local6:ListBaseContentHolder;
            var _local7:BaseListData;
            super.createChildren();
            var _local1:Array = ListBase(owner).selectedItems;
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = ListBase(owner).itemToItemRenderer(_local1[_local3]);
                if (!_local4){
                } else {
                    _local5 = ListBase(owner).createItemRenderer(_local1[_local3]);
                    _local5.styleName = ListBase(owner);
                    if ((_local5 is IDropInListItemRenderer)){
                        _local7 = IDropInListItemRenderer(_local4).listData;
                        IDropInListItemRenderer(_local5).listData = ((_local1[_local3]) ? _local7 : null);
                    };
                    _local5.data = _local1[_local3];
                    addChild(DisplayObject(_local5));
                    _local6 = (_local4.parent as ListBaseContentHolder);
                    _local5.setActualSize(_local4.width, _local4.height);
                    _local5.x = (_local4.x + _local6.leftOffset);
                    _local5.y = (_local4.y + _local6.topOffset);
                    measuredHeight = Math.max(measuredHeight, (_local5.y + _local5.height));
                    measuredWidth = Math.max(measuredWidth, (_local5.x + _local5.width));
                    _local5.visible = true;
                };
                _local3++;
            };
            invalidateDisplayList();
        }
        override protected function measure():void{
            var _local3:IListItemRenderer;
            super.measure();
            var _local1:Number = 0;
            var _local2:Number = 0;
            var _local4:int;
            while (_local4 < numChildren) {
                _local3 = (getChildAt(_local4) as IListItemRenderer);
                if (_local3){
                    _local1 = Math.max(_local1, (_local3.x + _local3.width));
                    _local2 = Math.max(_local2, (_local3.y + _local3.height));
                };
                _local4++;
            };
            measuredWidth = (measuredMinWidth = _local1);
            measuredHeight = (measuredMinHeight = _local2);
        }

    }
}//package mx.controls.listClasses 
