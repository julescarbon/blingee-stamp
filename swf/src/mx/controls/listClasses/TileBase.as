package mx.controls.listClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.scrollClasses.*;
    import mx.collections.*;
    import flash.utils.*;
    import flash.ui.*;
    import mx.skins.halo.*;
    import mx.collections.errors.*;

    public class TileBase extends ListBase {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _direction:String = "horizontal";
        private var lastRowCount:int = 0;
        private var _maxRows:int = 0;
        private var bSelectItem:Boolean = false;
        private var bCtrlKey:Boolean = false;
        private var lastColumnCount:int = 0;
        private var lastKey:uint = 0;
        private var _maxColumns:int = 0;
        protected var measuringObjects:Dictionary;
        private var bShiftKey:Boolean = false;

        public function TileBase(){
            itemRenderer = new ClassFactory(TileListItemRenderer);
            setRowHeight(50);
            setColumnWidth(50);
        }
        override public function measureWidthOfItems(_arg1:int=-1, _arg2:int=0):Number{
            var _local3:IListItemRenderer;
            var _local4:Number;
            var _local5:ListData;
            var _local7:Object;
            var _local8:Object;
            var _local9:IFactory;
            var _local6:Boolean;
            if (((collection) && (collection.length))){
                _local7 = iterator.current;
                _local8 = (((_local7 is ItemWrapper)) ? _local7.data : _local7);
                if (!measuringObjects){
                    measuringObjects = new Dictionary(true);
                };
                _local9 = getItemRendererFactory(_local8);
                _local3 = measuringObjects[_local9];
                if (!_local3){
                    _local3 = getMeasuringRenderer(_local8);
                    _local6 = true;
                };
                _local5 = ListData(makeListData(_local8, uid, 0, 0));
                if ((_local3 is IDropInListItemRenderer)){
                    IDropInListItemRenderer(_local3).listData = ((_local8) ? _local5 : null);
                };
                _local3.data = _local8;
                UIComponentGlobals.layoutManager.validateClient(_local3, true);
                _local4 = _local3.getExplicitOrMeasuredWidth();
                if (_local6){
                    _local3.setActualSize(_local4, _local3.getExplicitOrMeasuredHeight());
                    _local6 = false;
                };
            };
            if (((isNaN(_local4)) || ((_local4 == 0)))){
                _local4 = 50;
            };
            return ((_local4 * _arg2));
        }
        override public function indexToItemRenderer(_arg1:int):IListItemRenderer{
            var _local2:int = indexToRow(_arg1);
            if ((((_local2 < verticalScrollPosition)) || ((_local2 >= (verticalScrollPosition + rowCount))))){
                return (null);
            };
            var _local3:int = indexToColumn(_arg1);
            if ((((_local3 < horizontalScrollPosition)) || ((_local3 >= (horizontalScrollPosition + columnCount))))){
                return (null);
            };
            return (listItems[(_local2 - verticalScrollPosition)][(_local3 - horizontalScrollPosition)]);
        }
        public function set direction(_arg1:String):void{
            _direction = _arg1;
            itemsSizeChanged = true;
            offscreenExtraRowsOrColumnsChanged = true;
            if (listContent){
                if (direction == TileBaseDirection.HORIZONTAL){
                    listContent.leftOffset = (listContent.rightOffset = 0);
                    offscreenExtraColumnsLeft = (offscreenExtraColumnsRight = 0);
                } else {
                    listContent.topOffset = (listContent.bottomOffset = 0);
                    offscreenExtraRowsTop = (offscreenExtraRowsBottom = 0);
                };
            };
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("directionChanged"));
        }
        public function get direction():String{
            return (_direction);
        }
        override mx_internal function reconstructDataFromListItems():Array{
            var _local2:int;
            var _local3:int;
            var _local4:IListItemRenderer;
            var _local5:Object;
            if ((((direction == TileBaseDirection.HORIZONTAL)) || (!(listItems)))){
                return (super.reconstructDataFromListItems());
            };
            var _local1:Array = [];
            if (listItems.length > 0){
                _local2 = 0;
                while (_local2 < listItems[0].length) {
                    _local3 = 0;
                    while (_local3 < listItems.length) {
                        if (((listItems[_local3]) && ((listItems[_local3].length > _local2)))){
                            _local4 = (listItems[_local3][_local2] as IListItemRenderer);
                            if (_local4){
                                _local5 = _local4.data;
                                _local1.push(_local5);
                            };
                        };
                        _local3++;
                    };
                    _local2++;
                };
            };
            return (_local1);
        }
        override protected function moveSelectionHorizontally(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:IListItemRenderer;
            var _local7:String;
            var _local8:int;
            var _local9:Boolean;
            var _local10:int;
            var _local11:int;
            var _local16:ScrollEvent;
            var _local12:int = ((listItems[0].length - offscreenExtraColumnsLeft) - offscreenExtraColumnsRight);
            var _local13:int = (((((maxColumns > 0)) && (!((direction == TileBaseDirection.VERTICAL))))) ? maxColumns : _local12);
            var _local14:int = ((displayingPartialRow()) ? 1 : 0);
            var _local15:int = ((displayingPartialColumn()) ? 1 : 0);
            if (!collection){
                return;
            };
            showCaret = true;
            switch (_arg1){
                case Keyboard.LEFT:
                    if (caretIndex > 0){
                        if (direction == TileBaseDirection.HORIZONTAL){
                            caretIndex--;
                        } else {
                            _local10 = indexToRow(caretIndex);
                            _local11 = indexToColumn(caretIndex);
                            if (_local11 == 0){
                                _local10--;
                                _local11 = lastColumnInRow(_local10);
                            } else {
                                _local11--;
                            };
                            caretIndex = Math.min(indicesToIndex(_local10, _local11), (collection.length - 1));
                        };
                        _local10 = indexToRow(caretIndex);
                        _local11 = indexToColumn(caretIndex);
                        if (direction == TileBaseDirection.HORIZONTAL){
                            if (_local10 < verticalScrollPosition){
                                _local4 = (verticalScrollPosition - 1);
                            } else {
                                if (_local10 > ((verticalScrollPosition + rowCount) - _local14)){
                                    _local4 = maxVerticalScrollPosition;
                                };
                            };
                        } else {
                            if (_local11 < horizontalScrollPosition){
                                _local5 = (horizontalScrollPosition - 1);
                            } else {
                                if (_local11 > (((horizontalScrollPosition + _local12) - 1) - _local15)){
                                    _local5 = maxHorizontalScrollPosition;
                                };
                            };
                        };
                    };
                    break;
                case Keyboard.RIGHT:
                    if (caretIndex < (collection.length - 1)){
                        if ((((direction == TileBaseDirection.HORIZONTAL)) || ((caretIndex == -1)))){
                            caretIndex++;
                        } else {
                            _local10 = indexToRow(caretIndex);
                            _local11 = indexToColumn(caretIndex);
                            if (_local11 == lastColumnInRow(_local10)){
                                _local11 = 0;
                                _local10++;
                            } else {
                                _local11++;
                            };
                            caretIndex = Math.min(indicesToIndex(_local10, _local11), (collection.length - 1));
                        };
                        _local10 = indexToRow(caretIndex);
                        _local11 = indexToColumn(caretIndex);
                        if (direction == TileBaseDirection.HORIZONTAL){
                            if ((((_local10 >= ((verticalScrollPosition + rowCount) - _local14))) && ((verticalScrollPosition < maxVerticalScrollPosition)))){
                                _local4 = (verticalScrollPosition + 1);
                            };
                            if (_local10 < verticalScrollPosition){
                                _local4 = _local10;
                            };
                        } else {
                            if ((((_local11 >= ((horizontalScrollPosition + _local12) - _local15))) && ((horizontalScrollPosition < maxHorizontalScrollPosition)))){
                                _local5 = (horizontalScrollPosition + 1);
                            };
                            if (_local11 < horizontalScrollPosition){
                                _local5 = _local11;
                            };
                        };
                    };
                    break;
                case Keyboard.PAGE_UP:
                    if (caretIndex < 0){
                        caretIndex = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
                    };
                    _local10 = indexToRow(caretIndex);
                    _local11 = indexToColumn(caretIndex);
                    if (_local11 > 0){
                        _local11 = Math.max((horizontalScrollPosition - (_local12 - _local15)), 0);
                        _local5 = _local11;
                        caretIndex = indicesToIndex(_local10, _local11);
                    };
                    break;
                case Keyboard.PAGE_DOWN:
                    if (caretIndex < 0){
                        caretIndex = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
                    };
                    _local10 = indexToRow(caretIndex);
                    _local11 = indexToColumn(caretIndex);
                    if (_local11 < maxHorizontalScrollPosition){
                        _local11 = Math.min(((horizontalScrollPosition + _local12) - _local15), indexToColumn((collection.length - 1)));
                        if (_local11 > horizontalScrollPosition){
                            _local5 = Math.min(_local11, maxHorizontalScrollPosition);
                        };
                        caretIndex = indicesToIndex(_local10, _local11);
                    };
                    break;
                case Keyboard.HOME:
                    if (collection.length){
                        caretIndex = 0;
                        _local5 = 0;
                        _local4 = 0;
                    };
                    break;
                case Keyboard.END:
                    if (caretIndex < collection.length){
                        caretIndex = (collection.length - 1);
                        _local5 = maxHorizontalScrollPosition;
                        _local4 = maxVerticalScrollPosition;
                    };
                    break;
            };
            if (!isNaN(_local4)){
                if (_local4 != verticalScrollPosition){
                    _local16 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local16.detail = ScrollEventDetail.THUMB_POSITION;
                    _local16.direction = ScrollEventDirection.VERTICAL;
                    _local16.delta = (_local4 - verticalScrollPosition);
                    _local16.position = _local4;
                    verticalScrollPosition = _local4;
                    dispatchEvent(_local16);
                };
            };
            if (iteratorValid){
                if (!isNaN(_local5)){
                    if (_local5 != horizontalScrollPosition){
                        _local16 = new ScrollEvent(ScrollEvent.SCROLL);
                        _local16.detail = ScrollEventDetail.THUMB_POSITION;
                        _local16.direction = ScrollEventDirection.HORIZONTAL;
                        _local16.delta = (_local5 - horizontalScrollPosition);
                        _local16.position = _local5;
                        horizontalScrollPosition = _local5;
                        dispatchEvent(_local16);
                    };
                };
            };
            if (!iteratorValid){
                keySelectionPending = true;
                return;
            };
            bShiftKey = _arg2;
            bCtrlKey = _arg3;
            lastKey = _arg1;
            finishKeySelection();
        }
        override mx_internal function removeClipMask():void{
        }
        override protected function commitProperties():void{
            super.commitProperties();
            if (itemsNeedMeasurement){
                itemsNeedMeasurement = false;
                if (isNaN(explicitRowHeight)){
                    setRowHeight(measureHeightOfItems(0, 1));
                };
                if (isNaN(explicitColumnWidth)){
                    setColumnWidth(measureWidthOfItems(0, 1));
                };
            };
        }
        override public function scrollToIndex(_arg1:int):Boolean{
            var newVPos:* = 0;
            var newHPos:* = 0;
            var index:* = _arg1;
            var firstIndex:* = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
            var numItemsVisible:* = (((listItems.length - offscreenExtraRowsTop) - offscreenExtraRowsBottom) * ((listItems[0].length - offscreenExtraColumnsLeft) - offscreenExtraColumnsRight));
            if ((((index >= (firstIndex + numItemsVisible))) || ((index < firstIndex)))){
                newVPos = Math.min(indexToRow(index), maxVerticalScrollPosition);
                newHPos = Math.min(indexToColumn(index), maxHorizontalScrollPosition);
                try {
                    iterator.seek(CursorBookmark.FIRST, scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition));
                    super.horizontalScrollPosition = newHPos;
                    super.verticalScrollPosition = newVPos;
                } catch(e:ItemPendingError) {
                };
                return (true);
            };
            return (false);
        }
        override public function createItemRenderer(_arg1:Object):IListItemRenderer{
            var _local2:IFactory;
            var _local3:IListItemRenderer;
            var _local4:Dictionary;
            var _local5:*;
            _local2 = getItemRendererFactory(_arg1);
            if (!_local2){
                if (!_arg1){
                    _local2 = nullItemRenderer;
                };
                if (!_local2){
                    _local2 = itemRenderer;
                };
            };
            if (_local2 == itemRenderer){
                if (((freeItemRenderers) && (freeItemRenderers.length))){
                    _local3 = freeItemRenderers.pop();
                    delete freeItemRenderersByFactory[_local2][_local3];
                };
            } else {
                if (freeItemRenderersByFactory){
                    _local4 = freeItemRenderersByFactory[_local2];
                    if (_local4){
                        for (_local5 in _local4) {
                            _local3 = IListItemRenderer(_local5);
                            delete _local4[_local5];
                            break;
                        };
                    };
                };
            };
            if (!_local3){
                _local3 = _local2.newInstance();
                _local3.styleName = this;
                factoryMap[_local3] = _local2;
            };
            _local3.owner = this;
            return (_local3);
        }
        protected function drawTileBackgrounds():void{
            var _local2:Array;
            var _local5:int;
            var _local6:int;
            var _local7:Number;
            var _local8:Number;
            var _local9:IListItemRenderer;
            var _local10:int;
            var _local11:DisplayObject;
            var _local1:Sprite = Sprite(listContent.getChildByName("tileBGs"));
            if (!_local1){
                _local1 = new FlexSprite();
                _local1.mouseEnabled = false;
                _local1.name = "tileBGs";
                listContent.addChildAt(_local1, 0);
            };
            _local2 = getStyle("alternatingItemColors");
            if (((!(_local2)) || ((_local2.length == 0)))){
                while (_local1.numChildren > _local5) {
                    _local1.removeChildAt((_local1.numChildren - 1));
                };
                return;
            };
            StyleManager.getColorNames(_local2);
            var _local3:int;
            var _local4:int;
            while (_local4 < rowCount) {
                _local6 = 0;
                while (_local6 < columnCount) {
                    _local7 = ((_local4)<(rowCount - 1)) ? rowHeight : Math.min(rowHeight, (listContent.height - ((rowCount - 1) * rowHeight)));
                    _local8 = ((_local6)<(columnCount - 1)) ? columnWidth : Math.min(columnWidth, (listContent.width - ((columnCount - 1) * columnWidth)));
                    _local9 = ((listItems[_local4]) ? listItems[_local4][_local6] : null);
                    _local10 = (((verticalScrollPosition + _local4) * columnCount) + (horizontalScrollPosition + _local6));
                    _local11 = drawTileBackground(_local1, _local4, _local6, _local8, _local7, _local2[(_local10 % _local2.length)], _local9);
                    _local11.y = (_local4 * rowHeight);
                    _local11.x = (_local6 * columnWidth);
                    _local6++;
                };
                _local4++;
            };
            _local5 = (rowCount * columnCount);
            while (_local1.numChildren > _local5) {
                _local1.removeChildAt((_local1.numChildren - 1));
            };
        }
        private function displayingPartialRow():Boolean{
            var _local2:IListItemRenderer;
            var _local1:Array = listItems[((listItems.length - 1) - offscreenExtraRowsBottom)];
            if (((_local1) && ((_local1.length > 0)))){
                _local2 = _local1[0];
                if (((!(_local2)) || (((_local2.y + _local2.height) > (listContent.heightExcludingOffsets - listContent.topOffset))))){
                    return (true);
                };
            };
            return (false);
        }
        override protected function createChildren():void{
            super.createChildren();
            listContent.mask = maskShape;
        }
        override mx_internal function addClipMask(_arg1:Boolean):void{
        }
        override protected function finishKeySelection():void{
            var _local1:String;
            var _local3:int;
            var _local4:int;
            var _local5:IListItemRenderer;
            var _local6:ListEvent;
            var _local2:Boolean;
            if (caretIndex < 0){
                return;
            };
            _local3 = indexToRow(caretIndex);
            _local4 = indexToColumn(caretIndex);
            _local5 = listItems[((_local3 - verticalScrollPosition) + offscreenExtraRowsTop)][((_local4 - horizontalScrollPosition) + offscreenExtraColumnsLeft)];
            if (!bCtrlKey){
                selectItem(_local5, bShiftKey, bCtrlKey);
                _local2 = true;
            };
            if (bCtrlKey){
                _local1 = itemToUID(_local5.data);
                drawItem(visibleData[_local1], !((selectedData[_local1] == null)), false, true);
            };
            if (_local2){
                _local6 = new ListEvent(ListEvent.CHANGE);
                _local6.itemRenderer = _local5;
                _local6.rowIndex = _local3;
                _local6.columnIndex = _local4;
                dispatchEvent(_local6);
            };
        }
        override protected function scrollPositionToIndex(_arg1:int, _arg2:int):int{
            var _local3:int;
            if (iterator){
                if (direction == TileBaseDirection.HORIZONTAL){
                    _local3 = ((_arg2 * columnCount) + _arg1);
                } else {
                    _local3 = ((_arg1 * rowCount) + _arg2);
                };
                return (_local3);
            };
            return (-1);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:IListItemRenderer;
            var _local3:int;
            var _local4:int;
            if (!iteratorValid){
                return;
            };
            if (!collection){
                return;
            };
            switch (_arg1.keyCode){
                case Keyboard.UP:
                case Keyboard.DOWN:
                    moveSelectionVertically(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey);
                    _arg1.stopPropagation();
                    break;
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                    moveSelectionHorizontally(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey);
                    _arg1.stopPropagation();
                    break;
                case Keyboard.END:
                case Keyboard.HOME:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN:
                    if (direction == TileBaseDirection.VERTICAL){
                        moveSelectionHorizontally(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey);
                    } else {
                        moveSelectionVertically(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey);
                    };
                    _arg1.stopPropagation();
                    break;
                case Keyboard.SPACE:
                    if (caretIndex < 0){
                        break;
                    };
                    _local3 = indexToRow(caretIndex);
                    _local4 = indexToColumn(caretIndex);
                    _local2 = listItems[(_local3 - verticalScrollPosition)][(_local4 - horizontalScrollPosition)];
                    selectItem(_local2, _arg1.shiftKey, _arg1.ctrlKey);
                    break;
                default:
                    if (findKey(_arg1.keyCode)){
                        _arg1.stopPropagation();
                    };
            };
        }
        override protected function indexToColumn(_arg1:int):int{
            var _local3:int;
            if (direction == TileBaseDirection.VERTICAL){
                _local3 = (((maxRows > 0)) ? maxRows : rowCount);
                return (Math.floor((_arg1 / _local3)));
            };
            var _local2:int = (((maxColumns > 0)) ? maxColumns : columnCount);
            return ((_arg1 % _local2));
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            if ((((explicitColumnCount > 0)) && (isNaN(explicitColumnWidth)))){
                setColumnWidth(Math.floor((((width - viewMetrics.left) - viewMetrics.right) / explicitColumnCount)));
            };
            if ((((explicitRowCount > 0)) && (isNaN(explicitRowHeight)))){
                setRowHeight(Math.floor((((height - viewMetrics.top) - viewMetrics.bottom) / explicitRowCount)));
            };
            super.updateDisplayList(_arg1, _arg2);
            drawTileBackgrounds();
        }
        override protected function scrollHorizontally(_arg1:int, _arg2:int, _arg3:Boolean):void{
            var _local4:int;
            var _local5:int;
            var _local6:Number;
            var _local7:String;
            var _local8:int;
            var _local9:Number;
            var _local14:int;
            var _local15:int;
            var _local16:int;
            var _local20:int;
            var _local21:int;
            var _local22:IListItemRenderer;
            var _local23:int;
            var _local24:int;
            var _local25:Point;
            var _local26:int;
            var _local27:IListItemRenderer;
            var _local28:int;
            var _local29:int;
            if (_arg2 == 0){
                return;
            };
            removeClipMask();
            var _local10:int = offscreenExtraColumnsRight;
            var _local11:int = offscreenExtraColumnsLeft;
            var _local12:int = (offscreenExtraColumns / 2);
            var _local13:int = (offscreenExtraColumns / 2);
            if (_arg3){
                offscreenExtraColumnsLeft = Math.min(_local12, (offscreenExtraColumnsLeft + _arg2));
                _local14 = (_arg2 - (offscreenExtraColumnsLeft - _local11));
                _local15 = _local14;
            } else {
                _local20 = (((((((((((offscreenExtraColumnsRight == 0)) && (listItems[0]))) && ((listItems[0].length > 0)))) && (listItems[0][(listItems[0].length - 1)]))) && (((listItems[0][(listItems[0].length - 1)].x + columnWidth) < (listContent.widthExcludingOffsets - listContent.leftOffset))))) ? 1 : 0);
                offscreenExtraColumnsLeft = Math.min(_local12, _arg1);
                offscreenExtraColumnsRight = Math.min(((offscreenExtraColumnsRight + _arg2) - _local20), _local13);
                _local14 = (_arg2 - (_local11 - offscreenExtraColumnsLeft));
                _local16 = (((offscreenExtraColumnsLeft - _local11) + _local20) + (offscreenExtraColumnsRight - _local10));
                _local15 = ((_arg2 - (offscreenExtraColumnsRight - _local10)) - _local20);
            };
            var _local17:int = listItems[0].length;
            var _local18:int;
            while (_local18 < _local15) {
                _local21 = 0;
                while (_local21 < rowCount) {
                    _local22 = ((_arg3) ? listItems[_local21][_local18] : listItems[_local21][((_local17 - _local18) - 1)]);
                    if (_local22){
                        delete visibleData[rowMap[_local22.name].uid];
                        removeIndicators(rowMap[_local22.name].uid);
                        addToFreeItemRenderers(_local22);
                        delete rowMap[_local22.name];
                        if (_arg3){
                            listItems[_local21][_local18] = null;
                        } else {
                            listItems[_local21][((_local17 - _local18) - 1)] = null;
                        };
                    };
                    _local21++;
                };
                _local18++;
            };
            if (_arg3){
                _local9 = (_local14 * columnWidth);
                _local6 = 0;
                _local18 = _local14;
                while (_local18 < _local17) {
                    _local21 = 0;
                    while (_local21 < rowCount) {
                        _local27 = listItems[_local21][_local18];
                        if (_local27){
                            _local22 = _local27;
                            _local27.x = (_local22.x - _local9);
                            _local7 = rowMap[_local22.name].uid;
                            listItems[_local21][(_local18 - _local14)] = _local22;
                            rowMap[_local22.name].columnIndex = (rowMap[_local22.name].columnIndex - _local14);
                            moveIndicatorsHorizontally(_local7, -(_local9));
                        } else {
                            listItems[_local21][(_local18 - _local14)] = null;
                        };
                        _local21++;
                    };
                    _local6 = (_local6 + columnWidth);
                    _local18++;
                };
                _local18 = 0;
                while (_local18 < _local14) {
                    _local21 = 0;
                    while (_local21 < rowCount) {
                        listItems[_local21][((_local17 - _local18) - 1)] = null;
                        _local21++;
                    };
                    _local18++;
                };
                _local8 = indicesToIndex(verticalScrollPosition, (((horizontalScrollPosition + _local17) - offscreenExtraColumnsLeft) - _local14));
                seekPositionSafely(_local8);
                _local23 = (_arg2 + (_local13 - _local10));
                _local24 = ((listItems.length) ? (listItems[0].length - _local14) : 0);
                allowRendererStealingDuringLayout = false;
                _local25 = makeRowsAndColumns(_local6, 0, listContent.width, listContent.height, (_local17 - _local14), 0, true, _local23);
                allowRendererStealingDuringLayout = true;
                _local26 = (listItems[0].length - (_local24 + _local25.x));
                if (_local26){
                    _local18 = 0;
                    while (_local18 < listItems.length) {
                        _local21 = 0;
                        while (_local21 < _local26) {
                            listItems[_local18].pop();
                            _local21++;
                        };
                        _local18++;
                    };
                };
                _local8 = indicesToIndex(verticalScrollPosition, (horizontalScrollPosition - offscreenExtraColumnsLeft));
                seekPositionSafely(_local8);
                offscreenExtraColumnsRight = Math.max(0, (_local13 - (((_local25.x < _arg2)) ? (_local23 - _local25.x) : 0)));
            } else {
                if (_local16 < 0){
                    _local29 = (listItems[0].length + _local16);
                    _local21 = 0;
                    while (_local21 < rowCount) {
                        while (listItems[_local21].length > _local29) {
                            listItems[_local21].pop();
                        };
                        _local21++;
                    };
                };
                _local9 = (_local14 * columnWidth);
                if (_local14){
                    _local6 = _local9;
                };
                _local28 = (_local17 + _local16);
                _local18 = ((_local28 - _local14) - 1);
                while (_local18 >= 0) {
                    _local21 = 0;
                    while (_local21 < rowCount) {
                        _local22 = listItems[_local21][_local18];
                        if (_local22){
                            _local22.x = (_local22.x + _local9);
                            _local7 = rowMap[_local22.name].uid;
                            listItems[_local21][(_local18 + _local14)] = _local22;
                            rowMap[_local22.name].columnIndex = (rowMap[_local22.name].columnIndex + _local14);
                            moveIndicatorsHorizontally(_local7, _local9);
                        } else {
                            listItems[_local21][(_local18 + _local14)] = null;
                        };
                        _local21++;
                    };
                    _local18--;
                };
                _local18 = 0;
                while (_local18 < _local14) {
                    _local21 = 0;
                    while (_local21 < rowCount) {
                        listItems[_local21][_local18] = null;
                        _local21++;
                    };
                    _local18++;
                };
                _local8 = indicesToIndex(verticalScrollPosition, (horizontalScrollPosition - offscreenExtraColumnsLeft));
                seekPositionSafely(_local8);
                allowRendererStealingDuringLayout = false;
                makeRowsAndColumns(0, 0, _local6, listContent.height, 0, 0, true, _local14);
                allowRendererStealingDuringLayout = true;
                seekPositionSafely(_local8);
            };
            var _local19:Number = listContent.widthExcludingOffsets;
            listContent.leftOffset = (-(columnWidth) * offscreenExtraColumnsLeft);
            listContent.rightOffset = ((offscreenExtraColumnsRight) ? (((listItems[0][(listItems[0].length - 1)].x + listItems[0][(listItems[0].length - 1)].width) + listContent.leftOffset) - _local19) : 0);
            adjustListContent();
            addClipMask(false);
        }
        override mx_internal function adjustOffscreenRowsAndColumns():void{
            if (direction == TileBaseDirection.VERTICAL){
                offscreenExtraRows = 0;
                offscreenExtraColumns = offscreenExtraRowsOrColumns;
            } else {
                offscreenExtraColumns = 0;
                offscreenExtraRows = offscreenExtraRowsOrColumns;
            };
        }
        override protected function moveSelectionVertically(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:Number;
            var _local5:Number;
            var _local6:IListItemRenderer;
            var _local7:String;
            var _local8:int;
            var _local9:Boolean;
            var _local11:int;
            var _local12:int;
            var _local17:ScrollEvent;
            var _local10:Boolean;
            var _local13:int = ((listItems.length - offscreenExtraRowsTop) - offscreenExtraRowsBottom);
            var _local14:int = (((((maxRows > 0)) && (!((direction == TileBaseDirection.HORIZONTAL))))) ? maxRows : _local13);
            var _local15:int = ((displayingPartialRow()) ? 1 : 0);
            var _local16:int = ((displayingPartialColumn()) ? 1 : 0);
            if (!collection){
                return;
            };
            showCaret = true;
            switch (_arg1){
                case Keyboard.UP:
                    if (caretIndex > 0){
                        if (direction == TileBaseDirection.VERTICAL){
                            caretIndex--;
                        } else {
                            _local11 = indexToRow(caretIndex);
                            _local12 = indexToColumn(caretIndex);
                            if (_local11 == 0){
                                _local12--;
                                _local11 = lastRowInColumn(_local12);
                            } else {
                                _local11--;
                            };
                            caretIndex = Math.min(indicesToIndex(_local11, _local12), (collection.length - 1));
                        };
                        _local11 = indexToRow(caretIndex);
                        _local12 = indexToColumn(caretIndex);
                        if (_local11 < verticalScrollPosition){
                            _local4 = (verticalScrollPosition - 1);
                        };
                        if (_local11 > ((verticalScrollPosition + _local13) - _local15)){
                            _local4 = maxVerticalScrollPosition;
                        };
                        if (_local12 < horizontalScrollPosition){
                            _local5 = (horizontalScrollPosition - 1);
                        };
                    };
                    break;
                case Keyboard.DOWN:
                    if (caretIndex < (collection.length - 1)){
                        if ((((direction == TileBaseDirection.VERTICAL)) || ((caretIndex == -1)))){
                            caretIndex++;
                        } else {
                            _local11 = indexToRow(caretIndex);
                            _local12 = indexToColumn(caretIndex);
                            if (_local11 == lastRowInColumn(_local12)){
                                _local11 = 0;
                                _local12++;
                            } else {
                                _local11++;
                            };
                            caretIndex = Math.min(indicesToIndex(_local11, _local12), (collection.length - 1));
                        };
                        _local11 = indexToRow(caretIndex);
                        _local12 = indexToColumn(caretIndex);
                        if ((((_local11 >= ((verticalScrollPosition + _local13) - _local15))) && ((verticalScrollPosition < maxVerticalScrollPosition)))){
                            _local4 = (verticalScrollPosition + 1);
                        };
                        if (_local11 < verticalScrollPosition){
                            _local4 = _local11;
                        };
                        if (_local12 > ((horizontalScrollPosition + columnCount) - 1)){
                            _local5 = (horizontalScrollPosition + 1);
                        };
                    };
                    break;
                case Keyboard.PAGE_UP:
                    if (caretIndex < 0){
                        caretIndex = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
                    };
                    _local11 = indexToRow(caretIndex);
                    _local12 = indexToColumn(caretIndex);
                    if (verticalScrollPosition > 0){
                        if (_local11 == verticalScrollPosition){
                            _local11 = Math.max((verticalScrollPosition - (_local13 - _local15)), 0);
                            _local4 = _local11;
                        } else {
                            _local11 = verticalScrollPosition;
                        };
                        caretIndex = indicesToIndex(_local11, _local12);
                        break;
                    };
                case Keyboard.HOME:
                    if (collection.length){
                        caretIndex = 0;
                        _local4 = 0;
                        _local5 = 0;
                    };
                    break;
                case Keyboard.PAGE_DOWN:
                    if (caretIndex < 0){
                        caretIndex = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
                    };
                    _local11 = indexToRow(caretIndex);
                    _local12 = indexToColumn(caretIndex);
                    if (_local11 < maxVerticalScrollPosition){
                        if (_local11 == (verticalScrollPosition + (_local13 - _local15))){
                            _local4 = Math.min(((verticalScrollPosition + _local13) - _local15), maxVerticalScrollPosition);
                            _local11 = (verticalScrollPosition + _local13);
                        } else {
                            _local11 = Math.min(((verticalScrollPosition + _local13) - _local15), indexToRow((collection.length - 1)));
                            if (_local11 == ((verticalScrollPosition + _local13) - _local15)){
                                _local4 = Math.min(((verticalScrollPosition + _local13) - _local15), maxVerticalScrollPosition);
                            };
                        };
                        caretIndex = Math.min(indicesToIndex(_local11, _local12), (collection.length - 1));
                        break;
                    };
                case Keyboard.END:
                    if (caretIndex < collection.length){
                        caretIndex = (collection.length - 1);
                        _local4 = maxVerticalScrollPosition;
                        _local5 = maxHorizontalScrollPosition;
                    };
                    break;
            };
            if (!isNaN(_local4)){
                if (_local4 != verticalScrollPosition){
                    _local17 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local17.detail = ScrollEventDetail.THUMB_POSITION;
                    _local17.direction = ScrollEventDirection.VERTICAL;
                    _local17.delta = (_local4 - verticalScrollPosition);
                    _local17.position = _local4;
                    verticalScrollPosition = _local4;
                    dispatchEvent(_local17);
                };
            };
            if (iteratorValid){
                if (!isNaN(_local5)){
                    if (_local5 != horizontalScrollPosition){
                        _local17 = new ScrollEvent(ScrollEvent.SCROLL);
                        _local17.detail = ScrollEventDetail.THUMB_POSITION;
                        _local17.direction = ScrollEventDirection.HORIZONTAL;
                        _local17.delta = (_local5 - horizontalScrollPosition);
                        _local17.position = _local5;
                        horizontalScrollPosition = _local5;
                        dispatchEvent(_local17);
                    };
                };
            };
            if (!iteratorValid){
                keySelectionPending = true;
                return;
            };
            bShiftKey = _arg2;
            bCtrlKey = _arg3;
            lastKey = _arg1;
            finishKeySelection();
        }
        override protected function scrollVertically(_arg1:int, _arg2:int, _arg3:Boolean):void{
            var _local4:int;
            var _local5:int;
            var _local6:Number;
            var _local7:String;
            var _local8:int;
            var _local9:Number;
            var _local14:int;
            var _local15:int;
            var _local16:int;
            var _local21:int;
            var _local22:int;
            var _local23:IListItemRenderer;
            var _local24:int;
            var _local25:Point;
            var _local26:int;
            removeClipMask();
            var _local10:int = offscreenExtraRowsBottom;
            var _local11:int = offscreenExtraRowsTop;
            var _local12:int = (offscreenExtraRows / 2);
            var _local13:int = (offscreenExtraRows / 2);
            if (_arg3){
                offscreenExtraRowsTop = Math.min(_local12, (offscreenExtraRowsTop + _arg2));
                _local14 = (_arg2 - (offscreenExtraRowsTop - _local11));
                _local15 = _local14;
            } else {
                _local21 = (((((((((offscreenExtraRowsBottom == 0)) && (listItems.length))) && (listItems[(listItems.length - 1)][0]))) && (((listItems[(listItems.length - 1)][0].y + rowHeight) < (listContent.heightExcludingOffsets - listContent.topOffset))))) ? 1 : 0);
                offscreenExtraRowsTop = Math.min(_local12, _arg1);
                offscreenExtraRowsBottom = Math.min(((offscreenExtraRowsBottom + _arg2) - _local21), _local13);
                _local14 = (_arg2 - (_local11 - offscreenExtraRowsTop));
                _local16 = (((offscreenExtraRowsTop - _local11) + _local21) + (offscreenExtraRowsBottom - _local10));
                _local15 = ((_arg2 - (offscreenExtraRowsBottom - _local10)) - _local21);
            };
            var _local17:int = listItems.length;
            var _local18:int;
            while (_local18 < _local15) {
                _local5 = ((_arg3) ? listItems[_local18].length : listItems[((_local17 - _local18) - 1)].length);
                _local22 = 0;
                while ((((_local22 < columnCount)) && ((_local22 < _local5)))) {
                    _local23 = ((_arg3) ? listItems[_local18][_local22] : listItems[((_local17 - _local18) - 1)][_local22]);
                    if (_local23){
                        delete visibleData[rowMap[_local23.name].uid];
                        removeIndicators(rowMap[_local23.name].uid);
                        addToFreeItemRenderers(_local23);
                        delete rowMap[_local23.name];
                        if (_arg3){
                            listItems[_local18][_local22] = null;
                        } else {
                            listItems[((_local17 - _local18) - 1)][_local22] = null;
                        };
                    };
                    _local22++;
                };
                _local18++;
            };
            var _local19:int = listItems.length;
            if (_arg3){
                _local9 = (_local14 * rowHeight);
                _local6 = 0;
                _local18 = _local14;
                while (_local18 < _local19) {
                    _local5 = listItems[_local18].length;
                    _local22 = 0;
                    while ((((_local22 < columnCount)) && ((_local22 < _local5)))) {
                        _local23 = listItems[_local18][_local22];
                        listItems[(_local18 - _local14)][_local22] = _local23;
                        if (_local23){
                            _local23.y = (_local23.y - _local9);
                            rowMap[_local23.name].rowIndex = (rowMap[_local23.name].rowIndex - _local14);
                            moveIndicatorsVertically(rowMap[_local23.name].uid, -(_local9));
                        };
                        _local22++;
                    };
                    if (_local5 < columnCount){
                        _local22 = _local5;
                        while (_local22 < columnCount) {
                            listItems[(_local18 - _local14)][_local22] = null;
                            _local22++;
                        };
                    };
                    rowInfo[(_local18 - _local14)] = rowInfo[_local18];
                    rowInfo[(_local18 - _local14)].y = (rowInfo[(_local18 - _local14)].y - _local9);
                    _local6 = (rowInfo[(_local18 - _local14)].y + rowHeight);
                    _local18++;
                };
                listItems.splice(((_local19 - _local14) - 1), _local14);
                rowInfo.splice(((_local19 - _local14) - 1), _local14);
                _local8 = indicesToIndex((((verticalScrollPosition - offscreenExtraRowsTop) + _local19) - _local14), horizontalScrollPosition);
                seekPositionSafely(_local8);
                _local24 = (_arg2 + (_local13 - _local10));
                _local25 = makeRowsAndColumns(0, _local6, listContent.width, (_local6 + (_arg2 * rowHeight)), 0, (_local19 - _local14), true, _local24);
                _local26 = (_local24 - _local25.y);
                while (_local26--) {
                    listItems.pop();
                    rowInfo.pop();
                };
                _local8 = indicesToIndex((verticalScrollPosition - offscreenExtraRowsTop), horizontalScrollPosition);
                seekPositionSafely(_local8);
                offscreenExtraRowsBottom = Math.max(0, (_local13 - (((_local25.y < _arg2)) ? (_local24 - _local25.y) : 0)));
            } else {
                if (_local16 < 0){
                    listItems.splice((listItems.length + _local16), -(_local16));
                    rowInfo.splice((rowInfo.length + _local16), -(_local16));
                } else {
                    if (_local16 > 0){
                        _local18 = 0;
                        while (_local18 < _local16) {
                            listItems[(_local19 + _local18)] = [];
                            _local18++;
                        };
                    };
                };
                _local9 = (_local14 * rowHeight);
                _local6 = rowInfo[_local14].y;
                _local18 = ((listItems.length - 1) - _local14);
                while (_local18 >= 0) {
                    _local5 = listItems[_local18].length;
                    _local22 = 0;
                    while ((((_local22 < columnCount)) && ((_local22 < _local5)))) {
                        _local23 = listItems[_local18][_local22];
                        if (_local23){
                            _local23.y = (_local23.y + _local9);
                            rowMap[_local23.name].rowIndex = (rowMap[_local23.name].rowIndex + _local14);
                            _local7 = rowMap[_local23.name].uid;
                            listItems[(_local18 + _local14)][_local22] = _local23;
                            moveIndicatorsVertically(_local7, _local9);
                        } else {
                            listItems[(_local18 + _local14)][_local22] = null;
                        };
                        _local22++;
                    };
                    rowInfo[(_local18 + _local14)] = rowInfo[_local18];
                    rowInfo[(_local18 + _local14)].y = (rowInfo[(_local18 + _local14)].y + _local9);
                    _local18--;
                };
                _local18 = 0;
                while (_local18 < _local14) {
                    _local22 = 0;
                    while (_local22 < columnCount) {
                        listItems[_local18][_local22] = null;
                        _local22++;
                    };
                    _local18++;
                };
                _local8 = indicesToIndex((verticalScrollPosition - offscreenExtraRowsTop), horizontalScrollPosition);
                seekPositionSafely(_local8);
                allowRendererStealingDuringLayout = false;
                _local25 = makeRowsAndColumns(0, 0, listContent.width, _local6, 0, 0, true, _local14);
                allowRendererStealingDuringLayout = true;
                seekPositionSafely(_local8);
            };
            var _local20:Number = listContent.heightExcludingOffsets;
            listContent.topOffset = (-(rowHeight) * offscreenExtraRowsTop);
            listContent.bottomOffset = ((offscreenExtraRowsBottom) ? (((rowInfo[(rowInfo.length - 1)].y + rowHeight) + listContent.topOffset) - _local20) : 0);
            adjustListContent();
            addClipMask(false);
        }
        override public function showDropFeedback(_arg1:DragEvent):void{
            var _local7:Class;
            var _local8:EdgeMetrics;
            if (!dropIndicator){
                _local7 = getStyle("dropIndicatorSkin");
                if (!_local7){
                    _local7 = ListDropIndicator;
                };
                dropIndicator = IFlexDisplayObject(new (_local7)());
                _local8 = viewMetrics;
                drawFocus(true);
                dropIndicator.x = 2;
                if (direction == TileBaseDirection.HORIZONTAL){
                    dropIndicator.setActualSize((rowHeight - 4), 4);
                    DisplayObject(dropIndicator).rotation = 90;
                } else {
                    dropIndicator.setActualSize((columnWidth - 4), 4);
                };
                dropIndicator.visible = true;
                listContent.addChild(DisplayObject(dropIndicator));
                if (collection){
                    dragScrollingInterval = setInterval(dragScroll, 15);
                };
            };
            var _local2:int = calculateDropIndex(_arg1);
            var _local3:int = indexToRow(_local2);
            var _local4:int = indexToColumn(_local2);
            _local3 = (_local3 - (verticalScrollPosition - offscreenExtraRowsTop));
            _local4 = (_local4 - (horizontalScrollPosition - offscreenExtraColumnsLeft));
            var _local5:Number = listItems.length;
            if (_local3 >= _local5){
                _local3 = (_local5 - 1);
            };
            var _local6:Number = ((_local5) ? listItems[0].length : 0);
            if (_local4 > _local6){
                _local4 = _local6;
            };
            dropIndicator.x = ((((((_local6) && (listItems[_local3].length))) && (listItems[_local3][_local4]))) ? listItems[_local3][_local4].x : (_local4 * columnWidth));
            dropIndicator.y = ((((((_local5) && (listItems[_local3].length))) && (listItems[_local3][0]))) ? listItems[_local3][0].y : (_local3 * rowHeight));
        }
        public function set maxColumns(_arg1:int):void{
            if (_maxColumns != _arg1){
                _maxColumns = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }
        override protected function configureScrollBars():void{
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local1:int = listItems.length;
            if (_local1 == 0){
                return;
            };
            var _local2:int = listItems[0].length;
            if (_local2 == 0){
                return;
            };
            if ((((_local1 > 1)) && (((((_local1 - offscreenExtraRowsTop) - offscreenExtraRowsBottom) * rowHeight) > listContent.heightExcludingOffsets)))){
                _local1--;
            };
            _local1 = (_local1 - (offscreenExtraRowsTop + offscreenExtraRowsBottom));
            if ((((_local2 > 1)) && (((((_local2 - offscreenExtraColumnsLeft) - offscreenExtraColumnsRight) * columnWidth) > listContent.widthExcludingOffsets)))){
                _local2--;
            };
            _local2 = (_local2 - (offscreenExtraColumnsLeft + offscreenExtraColumnsRight));
            var _local3:Object = horizontalScrollBar;
            var _local4:Object = verticalScrollBar;
            if (direction == TileBaseDirection.VERTICAL){
                if (((iteratorValid) && ((horizontalScrollPosition > 0)))){
                    _local8 = 0;
                    while ((((_local2 > 0)) && ((listItems[0][((_local2 + offscreenExtraColumnsLeft) - 1)] == null)))) {
                        _local2--;
                        _local8++;
                    };
                    _local9 = Math.floor((listContent.widthExcludingOffsets / columnWidth));
                    _local10 = Math.max(0, (_local9 - (_local2 + _local8)));
                    if (((_local8) || (_local10))){
                        _local11 = 0;
                        while (_local11 < listItems.length) {
                            while (listItems[_local11].length > (_local2 + offscreenExtraColumnsLeft)) {
                                (listItems[_local11] as Array).pop();
                            };
                            _local11++;
                        };
                        if (!runningDataEffect){
                            horizontalScrollPosition = Math.max(0, (horizontalScrollPosition - (_local8 + _local10)));
                            _local7 = scrollPositionToIndex(Math.max(0, (horizontalScrollPosition - offscreenExtraColumnsLeft)), verticalScrollPosition);
                            seekPositionSafely(_local7);
                            updateList();
                        };
                        return;
                    };
                };
                if (!iteratorValid){
                    _local1 = Math.floor((listContent.heightExcludingOffsets / rowHeight));
                };
                _local5 = (((maxRows > 0)) ? maxRows : _local1);
                _local6 = ((collection) ? Math.ceil((collection.length / _local5)) : _local2);
            } else {
                if (((iteratorValid) && ((verticalScrollPosition > 0)))){
                    _local12 = 0;
                    while ((((_local1 > 0)) && ((((listItems[((_local1 + offscreenExtraRowsTop) - 1)] == null)) || ((listItems[((_local1 + offscreenExtraRowsTop) - 1)][0] == null)))))) {
                        _local1--;
                        _local12++;
                    };
                    if (_local12){
                        while (listItems.length > (_local1 + offscreenExtraRowsTop)) {
                            listItems.pop();
                            rowInfo.pop();
                        };
                        if (!runningDataEffect){
                            verticalScrollPosition = Math.max(0, (verticalScrollPosition - _local12));
                            _local7 = scrollPositionToIndex(horizontalScrollPosition, Math.max(0, (verticalScrollPosition - offscreenExtraRowsTop)));
                            seekPositionSafely(_local7);
                            updateList();
                        };
                        return;
                    };
                };
                if (!iteratorValid){
                    _local2 = Math.floor((listContent.widthExcludingOffsets / columnWidth));
                };
                _local6 = (((maxColumns > 0)) ? maxColumns : _local2);
                _local5 = ((collection) ? Math.ceil((collection.length / _local6)) : _local1);
            };
            maxHorizontalScrollPosition = Math.max(0, (_local6 - _local2));
            maxVerticalScrollPosition = Math.max(0, (_local5 - _local1));
            setScrollBarProperties(_local6, _local2, _local5, _local1);
        }
        override protected function indexToRow(_arg1:int):int{
            var _local3:int;
            if (direction == TileBaseDirection.VERTICAL){
                _local3 = (((maxRows > 0)) ? maxRows : rowCount);
                return ((_arg1 % _local3));
            };
            var _local2:int = (((maxColumns > 0)) ? maxColumns : columnCount);
            return (Math.floor((_arg1 / _local2)));
        }
        private function displayingPartialColumn():Boolean{
            var _local1:IListItemRenderer;
            if (((listItems[0]) && ((listItems[0].length > 0)))){
                _local1 = listItems[0][((listItems[0].length - 1) - offscreenExtraColumnsRight)];
                if (((_local1) && (((_local1.x + _local1.width) > (listContent.widthExcludingOffsets - listContent.leftOffset))))){
                    return (true);
                };
            };
            return (false);
        }
        override protected function scrollHandler(_arg1:Event):void{
            var scrollBar:* = null;
            var pos:* = NaN;
            var delta:* = 0;
            var startIndex:* = 0;
            var o:* = null;
            var bookmark:* = null;
            var event:* = _arg1;
            if ((event is ScrollEvent)){
                if (((!(liveScrolling)) && ((ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)))){
                    return;
                };
                scrollBar = ScrollBar(event.target);
                pos = scrollBar.scrollPosition;
                if (scrollBar == verticalScrollBar){
                    delta = (pos - verticalScrollPosition);
                    super.scrollHandler(event);
                    if ((((Math.abs(delta) >= listItems.length)) || (!(iteratorValid)))){
                        startIndex = indicesToIndex(pos, horizontalScrollPosition);
                        try {
                            iterator.seek(CursorBookmark.FIRST, startIndex);
                            if (!iteratorValid){
                                iteratorValid = true;
                                lastSeekPending = null;
                            };
                        } catch(e:ItemPendingError) {
                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, startIndex);
                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                            iteratorValid = false;
                        };
                        bookmark = iterator.bookmark;
                        clearIndicators();
                        clearVisibleData();
                        makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
                        iterator.seek(bookmark, 0);
                        drawRowBackgrounds();
                    } else {
                        if (delta != 0){
                            scrollVertically(pos, Math.abs(delta), (delta > 0));
                        };
                    };
                } else {
                    delta = (pos - horizontalScrollPosition);
                    super.scrollHandler(event);
                    if ((((Math.abs(delta) >= listItems[0].length)) || (!(iteratorValid)))){
                        startIndex = indicesToIndex(verticalScrollPosition, pos);
                        try {
                            iterator.seek(CursorBookmark.FIRST, startIndex);
                            if (!iteratorValid){
                                iteratorValid = true;
                                lastSeekPending = null;
                            };
                        } catch(e:ItemPendingError) {
                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, startIndex);
                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                            iteratorValid = false;
                        };
                        bookmark = iterator.bookmark;
                        clearIndicators();
                        clearVisibleData();
                        makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
                        iterator.seek(bookmark, 0);
                        drawRowBackgrounds();
                    } else {
                        if (delta != 0){
                            scrollHorizontally(pos, Math.abs(delta), (delta > 0));
                        };
                    };
                };
            };
        }
        mx_internal function purgeMeasuringRenderers():void{
            var _local1:IListItemRenderer;
            for each (_local1 in measuringObjects) {
                if (_local1.parent){
                    _local1.parent.removeChild(DisplayObject(_local1));
                };
            };
            if (!measuringObjects){
                measuringObjects = new Dictionary(true);
            };
        }
        override public function itemRendererToIndex(_arg1:IListItemRenderer):int{
            var _local2:String;
            var _local5:int;
            var _local6:int;
            if (runningDataEffect){
                _local2 = itemToUID(dataItemWrappersByRenderer[_arg1]);
            } else {
                _local2 = itemToUID(_arg1.data);
            };
            var _local3:int = listItems.length;
            var _local4:int;
            while (_local4 < listItems.length) {
                _local5 = listItems[_local4].length;
                _local6 = 0;
                while (_local6 < _local5) {
                    if (((listItems[_local4][_local6]) && ((rowMap[listItems[_local4][_local6].name].uid == _local2)))){
                        if (direction == TileBaseDirection.VERTICAL){
                            return (((((_local6 + horizontalScrollPosition) - offscreenExtraColumnsLeft) * Math.max(maxRows, rowCount)) + _local4));
                        };
                        return (((((_local4 + verticalScrollPosition) - offscreenExtraRowsTop) * Math.max(maxColumns, columnCount)) + _local6));
                    };
                    _local6++;
                };
                _local4++;
            };
            return (-1);
        }
        override public function measureHeightOfItems(_arg1:int=-1, _arg2:int=0):Number{
            var _local3:Number;
            var _local7:Object;
            var _local8:Object;
            var _local9:IFactory;
            var _local10:IListItemRenderer;
            var _local4:Boolean;
            if (((collection) && (collection.length))){
                _local7 = iterator.current;
                _local8 = (((_local7 is ItemWrapper)) ? _local7.data : _local7);
                _local9 = getItemRendererFactory(_local8);
                _local10 = measuringObjects[_local9];
                if (_local10 == null){
                    _local10 = getMeasuringRenderer(_local8);
                    _local4 = true;
                };
                setupRendererFromData(_local10, _local8);
                _local3 = _local10.getExplicitOrMeasuredHeight();
                if (_local4){
                    _local10.setActualSize(_local10.getExplicitOrMeasuredWidth(), _local3);
                    _local4 = false;
                };
            };
            if (((isNaN(_local3)) || ((_local3 == 0)))){
                _local3 = 50;
            };
            var _local5:Number = getStyle("paddingTop");
            var _local6:Number = getStyle("paddingBottom");
            _local3 = (_local3 + (_local5 + _local6));
            return ((_local3 * _arg2));
        }
        mx_internal function getMeasuringRenderer(_arg1:Object):IListItemRenderer{
            var _local2:IListItemRenderer;
            if (!measuringObjects){
                measuringObjects = new Dictionary(true);
            };
            var _local3:IFactory = getItemRendererFactory(_arg1);
            _local2 = measuringObjects[_local3];
            if (!_local2){
                _local2 = createItemRenderer(_arg1);
                _local2.owner = this;
                _local2.name = "hiddenItem";
                _local2.visible = false;
                _local2.styleName = listContent;
                listContent.addChild(DisplayObject(_local2));
                measuringObjects[_local3] = _local2;
            };
            return (_local2);
        }
        private function getPreparedItemRenderer(_arg1:int, _arg2:int, _arg3:Object, _arg4:Object, _arg5:String):IListItemRenderer{
            var _local7:IListItemRenderer;
            var _local8:ListData;
            var _local9:ListData;
            var _local6:IListItemRenderer = listItems[_arg1][_arg2];
            if (_local6){
                if (((runningDataEffect) ? !((dataItemWrappersByRenderer[_local6] == _arg3)) : !((_local6.data == _arg4)))){
                    addToFreeItemRenderers(_local6);
                } else {
                    _local7 = _local6;
                };
            };
            if (!_local7){
                if (allowRendererStealingDuringLayout){
                    _local7 = visibleData[_arg5];
                    if (((!(_local7)) && (!((_arg3 == _arg4))))){
                        _local7 = visibleData[itemToUID(_arg4)];
                    };
                };
                if (_local7){
                    _local9 = ListData(rowMap[_local7.name]);
                    if (_local9){
                        if ((((((direction == TileBaseDirection.HORIZONTAL)) && ((((_local9.rowIndex > _arg1)) || ((((_local9.rowIndex == _arg1)) && ((_local9.columnIndex > _arg2)))))))) || ((((direction == TileBaseDirection.VERTICAL)) && ((((_local9.columnIndex > _arg2)) || ((((_local9.columnIndex == _arg2)) && ((_local9.rowIndex > _arg1)))))))))){
                            listItems[_local9.rowIndex][_local9.columnIndex] = null;
                        } else {
                            _local7 = null;
                        };
                    };
                };
                if (!_local7){
                    _local7 = getReservedOrFreeItemRenderer(_arg3);
                    if (((_local7) && (!(isRendererUnconstrained(_local7))))){
                        _local7.x = 0;
                        _local7.y = 0;
                    };
                };
                if (!_local7){
                    _local7 = createItemRenderer(_arg4);
                };
                _local7.owner = this;
                _local7.styleName = listContent;
                _local7.visible = true;
            };
            _local8 = ListData(makeListData(_arg4, _arg5, _arg1, _arg2));
            rowMap[_local7.name] = _local8;
            if ((_local7 is IDropInListItemRenderer)){
                IDropInListItemRenderer(_local7).listData = ((_arg4) ? _local8 : null);
            };
            _local7.data = _arg4;
            if (_arg3 != _arg4){
                dataItemWrappersByRenderer[_local7] = _arg3;
            };
            if (!_local7.parent){
                listContent.addChild(DisplayObject(_local7));
            };
            _local7.visible = true;
            if (_arg5){
                visibleData[_arg5] = _local7;
            };
            listItems[_arg1][_arg2] = _local7;
            UIComponentGlobals.layoutManager.validateClient(_local7, true);
            return (_local7);
        }
        private function placeAndDrawItemRenderer(_arg1:IListItemRenderer, _arg2:Number, _arg3:Number, _arg4:String):void{
            var _local8:Number;
            var _local5:Boolean;
            var _local6:Boolean;
            var _local7:Boolean;
            _local8 = _arg1.getExplicitOrMeasuredHeight();
            if (((!((_arg1.width == columnWidth))) || (!((_local8 == ((rowHeight - cachedPaddingTop) - cachedPaddingBottom)))))){
                _arg1.setActualSize(columnWidth, ((rowHeight - cachedPaddingTop) - cachedPaddingBottom));
            };
            if (!isRendererUnconstrained(_arg1)){
                _arg1.move(_arg2, (_arg3 + cachedPaddingTop));
            };
            _local5 = !((selectedData[_arg4] == null));
            if (runningDataEffect){
                _local5 = ((_local5) || (!((selectedData[itemToUID(_arg1.data)] == null))));
                _local5 = ((((_local5) && (!(getRendererSemanticValue(_arg1, ModifiedCollectionView.REPLACEMENT))))) && (!(getRendererSemanticValue(_arg1, ModifiedCollectionView.ADDED))));
            };
            _local6 = (highlightUID == _arg4);
            _local7 = (caretUID == _arg4);
            if (_arg4){
                drawItem(_arg1, _local5, _local6, _local7);
            };
        }
        override protected function makeRowsAndColumns(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int, _arg6:int, _arg7:Boolean=false, _arg8:uint=0):Point{
            var _local9:int;
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:Number;
            var _local14:Number;
            var _local15:Object;
            var _local16:Object;
            var _local17:String;
            var _local18:IListItemRenderer;
            var _local19:IListItemRenderer;
            var _local20:Boolean;
            var _local21:Boolean;
            var _local22:int;
            var _local23:Number;
            var _local24:int;
            var _local25:int;
            var _local29:Array;
            var _local26:Boolean;
            var _local27:Boolean;
            var _local28:Boolean;
            if ((((columnWidth == 0)) || ((rowHeight == 0)))){
                return (null);
            };
            invalidateSizeFlag = true;
            allowItemSizeChangeNotification = false;
            if (direction == TileBaseDirection.VERTICAL){
                _local9 = (((maxRows > 0)) ? maxRows : Math.max(Math.floor((listContent.heightExcludingOffsets / rowHeight)), 1));
                _local10 = Math.max(Math.ceil((listContent.widthExcludingOffsets / columnWidth)), 1);
                setRowCount(_local9);
                setColumnCount(_local10);
                _local11 = _arg5;
                _local13 = _arg1;
                _local25 = (_local11 - 1);
                _local20 = ((((!((iterator == null))) && (!(iterator.afterLast)))) && (iteratorValid));
                while (((((_arg7) && (_arg8))) || (((!(_arg7)) && ((_local11 < (_local10 + _arg5))))))) {
                    _local12 = _arg6;
                    _local14 = _arg2;
                    while (_local12 < _local9) {
                        _local21 = _local20;
                        _local15 = ((_local20) ? iterator.current : null);
                        _local16 = (((_local15 is ItemWrapper)) ? _local15.data : _local15);
                        _local20 = moveNextSafely(_local20);
                        if (!listItems[_local12]){
                            listItems[_local12] = [];
                        };
                        if (((_local21) && ((_local14 < _arg4)))){
                            _local17 = itemToUID(_local15);
                            rowInfo[_local12] = new ListRowInfo(_local14, rowHeight, _local17);
                            _local19 = getPreparedItemRenderer(_local12, _local11, _local15, _local16, _local17);
                            placeAndDrawItemRenderer(_local19, _local13, _local14, _local17);
                            _local25 = Math.max(_local11, _local25);
                        } else {
                            _local18 = listItems[_local12][_local11];
                            if (_local18){
                                addToFreeItemRenderers(_local18);
                                listItems[_local12][_local11] = null;
                            };
                            rowInfo[_local12] = new ListRowInfo(_local14, rowHeight, _local17);
                        };
                        _local14 = (_local14 + rowHeight);
                        _local12++;
                    };
                    _local11++;
                    if (_arg6){
                        _local22 = 0;
                        while (_local22 < _arg6) {
                            _local20 = moveNextSafely(_local20);
                            _local22++;
                        };
                    };
                    _local13 = (_local13 + columnWidth);
                };
            } else {
                _local10 = (((maxColumns > 0)) ? maxColumns : Math.max(Math.floor((listContent.widthExcludingOffsets / columnWidth)), 1));
                _local9 = Math.max(Math.ceil((listContent.heightExcludingOffsets / rowHeight)), 1);
                setColumnCount(_local10);
                setRowCount(_local9);
                _local12 = _arg6;
                _local14 = _arg2;
                _local20 = ((((!((iterator == null))) && (!(iterator.afterLast)))) && (iteratorValid));
                _local24 = (_local12 - 1);
                while (((((_arg7) && (_arg8))) || (((!(_arg7)) && ((_local12 < (_local9 + _arg6))))))) {
                    _local11 = _arg5;
                    _local13 = _arg1;
                    rowInfo[_local12] = null;
                    while (_local11 < _local10) {
                        _local21 = _local20;
                        _local15 = ((_local20) ? iterator.current : null);
                        _local16 = (((_local15 is ItemWrapper)) ? _local15.data : _local15);
                        _local20 = moveNextSafely(_local20);
                        if (!listItems[_local12]){
                            listItems[_local12] = [];
                        };
                        if (((_local21) && ((_local13 < _arg3)))){
                            _local17 = itemToUID(_local15);
                            if (!rowInfo[_local12]){
                                rowInfo[_local12] = new ListRowInfo(_local14, rowHeight, _local17);
                            };
                            _local19 = getPreparedItemRenderer(_local12, _local11, _local15, _local16, _local17);
                            placeAndDrawItemRenderer(_local19, _local13, _local14, _local17);
                            _local24 = _local12;
                        } else {
                            if (!rowInfo[_local12]){
                                rowInfo[_local12] = new ListRowInfo(_local14, rowHeight, _local17);
                            };
                            _local18 = listItems[_local12][_local11];
                            if (_local18){
                                addToFreeItemRenderers(_local18);
                                listItems[_local12][_local11] = null;
                            };
                        };
                        _local13 = (_local13 + columnWidth);
                        _local11++;
                    };
                    _local12++;
                    if (_arg5){
                        _local22 = 0;
                        while (_local22 < _arg5) {
                            _local20 = moveNextSafely(_local20);
                            _local22++;
                        };
                    };
                    _local14 = (_local14 + rowHeight);
                };
            };
            if (!_arg7){
                while (listItems.length > (_local9 + offscreenExtraRowsTop)) {
                    _local29 = listItems.pop();
                    rowInfo.pop();
                    _local22 = 0;
                    while (_local22 < _local29.length) {
                        _local18 = _local29[_local22];
                        if (_local18){
                            addToFreeItemRenderers(_local18);
                        };
                        _local22++;
                    };
                };
                if (((listItems.length) && ((listItems[0].length > (_local10 + offscreenExtraColumnsLeft))))){
                    _local22 = 0;
                    while (_local22 < (_local9 + offscreenExtraRowsTop)) {
                        _local29 = listItems[_local22];
                        while (_local29.length > (_local10 + offscreenExtraColumnsLeft)) {
                            _local18 = _local29.pop();
                            if (_local18){
                                addToFreeItemRenderers(_local18);
                            };
                        };
                        _local22++;
                    };
                };
            };
            allowItemSizeChangeNotification = true;
            invalidateSizeFlag = false;
            return (new Point(((_local25 - _arg5) + 1), ((_local24 - _arg6) + 1)));
        }
        private function lastColumnInRow(_arg1:int):int{
            var _local2:int = (((maxRows > 0)) ? maxRows : rowCount);
            var _local3:int = Math.floor(((collection.length - 1) / _local2));
            if (indicesToIndex(_arg1, _local3) >= collection.length){
                _local3--;
            };
            return (_local3);
        }
        override protected function get dragImageOffsets():Point{
            var _local4:String;
            var _local1:Point = new Point(0x2000, 0x2000);
            var _local2:Boolean;
            var _local3:int = listItems.length;
            for (_local4 in visibleData) {
                if (selectedData[_local4]){
                    _local1.x = Math.min(_local1.x, visibleData[_local4].x);
                    _local1.y = Math.min(_local1.y, visibleData[_local4].y);
                    _local2 = true;
                };
            };
            if (_local2){
                return (_local1);
            };
            return (new Point(0, 0));
        }
        public function get maxColumns():int{
            return (_maxColumns);
        }
        public function set maxRows(_arg1:int):void{
            if (_maxRows != _arg1){
                _maxRows = _arg1;
                invalidateSize();
                invalidateDisplayList();
            };
        }
        public function get maxRows():int{
            return (_maxRows);
        }
        private function moveNextSafely(_arg1:Boolean):Boolean{
            var more:* = _arg1;
            if (((iterator) && (more))){
                try {
                    more = iterator.moveNext();
                } catch(e1:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, 0);
                    e1.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    more = false;
                    iteratorValid = false;
                };
            };
            return (more);
        }
        private function lastRowInColumn(_arg1:int):int{
            var _local2:int = (((maxColumns > 0)) ? maxColumns : columnCount);
            var _local3:int = Math.floor(((collection.length - 1) / _local2));
            if ((_arg1 * _local3) > collection.length){
                _local3--;
            };
            return (_local3);
        }
        protected function drawTileBackground(_arg1:Sprite, _arg2:int, _arg3:int, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):DisplayObject{
            var _local9:Shape;
            var _local8:int = ((_arg2 * columnCount) + _arg3);
            if (_local8 < _arg1.numChildren){
                _local9 = Shape(_arg1.getChildAt(_local8));
            } else {
                _local9 = new FlexShape();
                _local9.name = "tileBackground";
                _arg1.addChild(_local9);
            };
            var _local10:Graphics = _local9.graphics;
            _local10.clear();
            _local10.beginFill(_arg6, getStyle("backgroundAlpha"));
            _local10.drawRect(0, 0, _arg4, _arg5);
            _local10.endFill();
            return (_local9);
        }
        override public function calculateDropIndex(_arg1:DragEvent=null):int{
            var _local2:IListItemRenderer;
            var _local3:Point;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            if (_arg1){
                _local3 = new Point(_arg1.localX, _arg1.localY);
                _local3 = DisplayObject(_arg1.target).localToGlobal(_local3);
                _local3 = listContent.globalToLocal(_local3);
                _local4 = listItems.length;
                _local5 = 0;
                while (_local5 < _local4) {
                    if ((((rowInfo[_local5].y <= _local3.y)) && ((_local3.y < (rowInfo[_local5].y + rowInfo[_local5].height))))){
                        _local6 = listItems[_local5].length;
                        _local7 = 0;
                        while (_local7 < _local6) {
                            if (((((listItems[_local5][_local7]) && ((listItems[_local5][_local7].x <= _local3.x)))) && ((_local3.x < (listItems[_local5][_local7].x + listItems[_local5][_local7].width))))){
                                _local2 = listItems[_local5][_local7];
                                if (!DisplayObject(_local2).visible){
                                    _local2 = null;
                                };
                                break;
                            };
                            _local7++;
                        };
                        break;
                    };
                    _local5++;
                };
                if (_local2){
                    lastDropIndex = itemRendererToIndex(_local2);
                } else {
                    lastDropIndex = ((collection) ? collection.length : 0);
                };
            };
            return (lastDropIndex);
        }
        override public function set itemRenderer(_arg1:IFactory):void{
            super.itemRenderer = _arg1;
            purgeMeasuringRenderers();
        }
        mx_internal function setupRendererFromData(_arg1:IListItemRenderer, _arg2:Object):void{
            var _local3:ListData = ListData(makeListData(_arg2, itemToUID(_arg2), 0, 0));
            if ((_arg1 is IDropInListItemRenderer)){
                IDropInListItemRenderer(_arg1).listData = ((_arg2) ? _local3 : null);
            };
            _arg1.data = _arg2;
            UIComponentGlobals.layoutManager.validateClient(_arg1, true);
        }
        protected function makeListData(_arg1:Object, _arg2:String, _arg3:int, _arg4:int):BaseListData{
            return (new ListData(itemToLabel(_arg1), itemToIcon(_arg1), labelField, _arg2, this, _arg3, _arg4));
        }
        override public function indicesToIndex(_arg1:int, _arg2:int):int{
            var _local4:int;
            if (direction == TileBaseDirection.VERTICAL){
                _local4 = (((maxRows > 0)) ? maxRows : rowCount);
                return (((_arg2 * _local4) + _arg1));
            };
            var _local3:int = (((maxColumns > 0)) ? maxColumns : columnCount);
            return (((_arg1 * _local3) + _arg2));
        }
        override protected function adjustListContent(_arg1:Number=-1, _arg2:Number=-1):void{
            var _local3:Boolean;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            var _local8:int;
            var _local9:int;
            super.adjustListContent(_arg1, _arg2);
            if (!collection){
                return;
            };
            var _local7:int = collection.length;
            if (direction == TileBaseDirection.VERTICAL){
                _local5 = (((maxRows > 0)) ? maxRows : Math.max(Math.floor((listContent.heightExcludingOffsets / rowHeight)), 1));
                _local6 = Math.max(Math.ceil((listContent.widthExcludingOffsets / columnWidth)), 1);
                if (_local5 != lastRowCount){
                    _local3 = !(((listContent.widthExcludingOffsets / columnWidth) == Math.ceil((listContent.widthExcludingOffsets / columnWidth))));
                    _local8 = Math.max((Math.ceil((_local7 / _local5)) - _local6), 0);
                    if (_local3){
                        _local8++;
                    };
                    if (horizontalScrollPosition > _local8){
                        $horizontalScrollPosition = _local8;
                    };
                    setRowCount(_local5);
                    setColumnCount(_local6);
                    _local4 = scrollPositionToIndex(Math.max(0, (horizontalScrollPosition - offscreenExtraColumnsLeft)), verticalScrollPosition);
                    seekPositionSafely(_local4);
                };
                lastRowCount = _local5;
            } else {
                _local6 = (((maxColumns > 0)) ? maxColumns : Math.max(Math.floor((listContent.widthExcludingOffsets / columnWidth)), 1));
                _local5 = Math.max(Math.ceil((listContent.heightExcludingOffsets / rowHeight)), 1);
                if (_local6 != lastColumnCount){
                    _local3 = !(((listContent.heightExcludingOffsets / rowHeight) == Math.ceil((listContent.heightExcludingOffsets / rowHeight))));
                    _local9 = Math.max((Math.ceil((_local7 / _local6)) - _local5), 0);
                    if (_local3){
                        _local9++;
                    };
                    if (verticalScrollPosition > _local9){
                        $verticalScrollPosition = _local9;
                    };
                    setRowCount(_local5);
                    setColumnCount(_local6);
                    _local4 = scrollPositionToIndex(horizontalScrollPosition, Math.max(0, (verticalScrollPosition - offscreenExtraRowsTop)));
                    seekPositionSafely(_local4);
                };
                lastColumnCount = _local6;
            };
        }
        override protected function collectionChangeHandler(_arg1:Event):void{
            var _local2:CollectionEvent;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:int;
            if ((_arg1 is CollectionEvent)){
                _local2 = CollectionEvent(_arg1);
                if ((((_local2.location == 0)) || ((_local2.kind == CollectionEventKind.REFRESH)))){
                    itemsNeedMeasurement = true;
                    invalidateProperties();
                };
                if (_local2.kind == CollectionEventKind.REMOVE){
                    _local3 = indicesToIndex(verticalScrollPosition, horizontalScrollPosition);
                    if (_local2.location < _local3){
                        _local3 = (_local3 - _local2.items.length);
                        super.collectionChangeHandler(_arg1);
                        _local4 = 0;
                        _local5 = 0;
                        if (direction == TileBaseDirection.HORIZONTAL){
                            super.verticalScrollPosition = indexToRow(_local3);
                            _local4 = Math.min((offscreenExtraRows / 2), verticalScrollPosition);
                        } else {
                            super.horizontalScrollPosition = indexToColumn(_local3);
                            _local5 = Math.min((offscreenExtraColumns / 2), horizontalScrollPosition);
                        };
                        _local6 = scrollPositionToIndex((horizontalScrollPosition - _local5), (verticalScrollPosition - _local4));
                        seekPositionSafely(_local6);
                        return;
                    };
                };
            };
            super.collectionChangeHandler(_arg1);
        }

    }
}//package mx.controls.listClasses 
