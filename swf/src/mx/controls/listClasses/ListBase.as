package mx.controls.listClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;
    import mx.collections.*;
    import flash.utils.*;
    import mx.utils.*;
    import flash.ui.*;
    import mx.skins.halo.*;
    import mx.collections.errors.*;
    import mx.controls.dataGridClasses.*;

    public class ListBase extends ScrollControlBase implements IDataRenderer, IFocusManagerComponent, IListItemRenderer, IDropInListItemRenderer, IEffectTargetHost {

        mx_internal static const DRAG_THRESHOLD:int = 4;
        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;
        private static var _listContentStyleFilters:Object = null;

        private var _labelField:String = "label";
        private var trackedRenderers:Array;
        mx_internal var bSelectionChanged:Boolean = false;
        protected var offscreenExtraColumnsLeft:int = 0;
        protected var selectionTweens:Object;
        protected var caretItemRenderer:IListItemRenderer;
        protected var actualIterator:IViewCursor;
        protected var iteratorValid:Boolean = true;
        private var bSelectItem:Boolean = false;
        private var _allowMultipleSelection:Boolean = false;
        protected var cachedItemsChangeEffect:IEffect = null;
        private var lastSelectionData:ListBaseSelectionData;
        protected var iterator:IViewCursor;
        protected var rendererChanged:Boolean = false;
        protected var unconstrainedRenderers:Dictionary;
        protected var freeItemRenderersByFactory:Dictionary;
        private var columnWidthChanged:Boolean = false;
        protected var explicitColumnCount:int = -1;
        private var _data:Object;
        private var bSelectedItemsChanged:Boolean = false;
        protected var defaultRowCount:int = 4;
        private var _rowCount:int = -1;
        protected var offscreenExtraRowsTop:int = 0;
        private var _dataTipField:String = "label";
        private var cachedPaddingTopInvalid:Boolean = true;
        protected var selectedData:Object;
        private var _labelFunction:Function;
        mx_internal var listType:String = "grid";
        private var cachedPaddingBottomInvalid:Boolean = true;
        protected var runningDataEffect:Boolean = false;
        protected var runDataEffectNextUpdate:Boolean = false;
        private var bShiftKey:Boolean = false;
        private var columnCountChanged:Boolean = true;
        protected var rowMap:Object;
        mx_internal var _selectedIndex:int = -1;
        mx_internal var collectionIterator:IViewCursor;
        protected var lastDropIndex:int;
        private var bCtrlKey:Boolean = false;
        private var oldUnscaledHeight:Number;
        protected var explicitColumnWidth:Number;
        private var _dataTipFunction:Function;
        private var _iconFunction:Function;
        protected var dataItemWrappersByRenderer:Dictionary;
        protected var itemsNeedMeasurement:Boolean = true;
        protected var offscreenExtraRowsBottom:int = 0;
        protected var modifiedCollectionView:ModifiedCollectionView;
        private var _columnCount:int = -1;
        private var rowCountChanged:Boolean = true;
        protected var wordWrapChanged:Boolean = false;
        protected var explicitRowCount:int = -1;
        protected var offscreenExtraRows:int = 0;
        private var _dragEnabled:Boolean = false;
        private var bSortItemPending:Boolean = false;
        protected var caretIndicator:Sprite;
        protected var caretUID:String;
        protected var caretBookmark:CursorBookmark;
        public var allowDragSelection:Boolean = false;
        mx_internal var allowRendererStealingDuringLayout:Boolean = true;
        private var _selectable:Boolean = true;
        protected var listContent:ListBaseContentHolder;
        private var _showDataTips:Boolean = false;
        private var _variableRowHeight:Boolean = false;
        private var cachedVerticalAlignInvalid:Boolean = true;
        private var _dragMoveEnabled:Boolean = false;
        private var _rowHeight:Number;
        private var _selectedItem:Object;
        public var menuSelectionMode:Boolean = false;
        mx_internal var cachedPaddingTop:Number;
        private var _selectedIndices:Array;
        private var _columnWidth:Number;
        protected var defaultColumnCount:int = 4;
        private var rendererTrackingSuspended:Boolean = false;
        private var oldUnscaledWidth:Number;
        private var _nullItemRenderer:IFactory;
        mx_internal var bColumnScrolling:Boolean = true;
        protected var showCaret:Boolean;
        private var firstSelectionData:ListBaseSelectionData;
        private var mouseDownItem:IListItemRenderer;
        protected var collection:ICollectionView;
        protected var offscreenExtraRowsOrColumnsChanged:Boolean = false;
        private var _offscreenExtraRowsOrColumns:int = 0;
        private var _iconField:String = "icon";
        protected var dataEffectCompleted:Boolean = false;
        private var bSelectedItemChanged:Boolean = false;
        private var _listData:BaseListData;
        mx_internal var bSelectOnRelease:Boolean;
        protected var actualCollection:ICollectionView;
        mx_internal var lastHighlightItemRenderer:IListItemRenderer;
        private var _itemRenderer:IFactory;
        private var itemMaskFreeList:Array;
        protected var keySelectionPending:Boolean = false;
        private var mouseDownPoint:Point;
        protected var selectionIndicators:Object;
        protected var highlightUID:String;
        mx_internal var dragScrollingInterval:int = 0;
        protected var anchorBookmark:CursorBookmark;
        protected var caretIndex:int = -1;
        protected var offscreenExtraColumnsRight:int = 0;
        private var approximate:Boolean = false;
        protected var anchorIndex:int = -1;
        protected var selectionLayer:Sprite;
        protected var freeItemRenderers:Array;
        mx_internal var bSelectedIndexChanged:Boolean = false;
        mx_internal var cachedVerticalAlign:String;
        private var lastHighlightItemIndices:Point;
        mx_internal var lastHighlightItemRendererAtIndices:IListItemRenderer;
        protected var lastSeekPending:ListBaseSeekPending;
        private var bSelectedIndicesChanged:Boolean = false;
        private var _dropEnabled:Boolean = false;
        protected var itemsSizeChanged:Boolean = false;
        mx_internal var isPressed:Boolean = false;
        private var IS_ITEM_STYLE:Object;
        mx_internal var cachedPaddingBottom:Number;
        protected var highlightIndicator:Sprite;
        private var verticalScrollPositionPending:Number;
        protected var explicitRowHeight:Number;
        protected var highlightItemRenderer:IListItemRenderer;
        private var rowHeightChanged:Boolean = false;
        mx_internal var lastDragEvent:DragEvent;
        private var _wordWrap:Boolean = false;
        private var horizontalScrollPositionPending:Number;
        mx_internal var dropIndicator:IFlexDisplayObject;
        private var _selectedItems:Array;
        protected var offscreenExtraColumns:int = 0;
        private var lastKey:uint = 0;
        protected var factoryMap:Dictionary;
        protected var reservedItemRenderers:Object;

        public function ListBase(){
            IS_ITEM_STYLE = {
                alternatingItemColors:true,
                backgroundColor:true,
                backgroundDisabledColor:true,
                color:true,
                rollOverColor:true,
                selectionColor:true,
                selectionDisabledColor:true,
                styleName:true,
                textColor:true,
                textRollOverColor:true,
                textSelectedColor:true
            };
            rowMap = {};
            freeItemRenderers = [];
            reservedItemRenderers = {};
            unconstrainedRenderers = new Dictionary();
            dataItemWrappersByRenderer = new Dictionary(true);
            selectedData = {};
            selectionIndicators = {};
            selectionTweens = {};
            trackedRenderers = [];
            super();
            tabEnabled = true;
            factoryMap = new Dictionary(true);
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            addEventListener(MouseEvent.CLICK, mouseClickHandler);
            addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
            invalidateProperties();
        }
        public function get iconField():String{
            return (_iconField);
        }
        public function set iconField(_arg1:String):void{
            _iconField = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("iconFieldChanged"));
        }
        mx_internal function getItemUID(_arg1:Object):String{
            return (itemToUID(_arg1));
        }
        public function measureWidthOfItems(_arg1:int=-1, _arg2:int=0):Number{
            return (NaN);
        }
        private function terminateSelectionTracking():void{
            var _local2:IListItemRenderer;
            var _local1:int;
            while (_local1 < trackedRenderers.length) {
                _local2 = (trackedRenderers[_local1] as IListItemRenderer);
                _local2.removeEventListener(MoveEvent.MOVE, rendererMoveHandler);
                _local1++;
            };
            trackedRenderers = [];
        }
        public function get columnWidth():Number{
            return (_columnWidth);
        }
        public function createItemRenderer(_arg1:Object):IListItemRenderer{
            return (null);
        }
        protected function clearSelected(_arg1:Boolean=false):void{
            var _local2:String;
            var _local3:Object;
            var _local4:IListItemRenderer;
            for (_local2 in selectedData) {
                _local3 = selectedData[_local2].data;
                removeSelectionData(_local2);
                _local4 = UIDToItemRenderer(itemToUID(_local3));
                if (_local4){
                    drawItem(_local4, false, (_local2 == highlightUID), false, _arg1);
                };
            };
            clearSelectionData();
            _selectedIndex = -1;
            _selectedItem = null;
            caretIndex = -1;
            anchorIndex = -1;
            caretBookmark = null;
            anchorBookmark = null;
        }
        protected function addToRowArrays():void{
            listItems.splice(0, 0, null);
            rowInfo.splice(0, 0, null);
        }
        public function get nullItemRenderer():IFactory{
            return (_nullItemRenderer);
        }
        public function get showDataTips():Boolean{
            return (_showDataTips);
        }
        public function set columnWidth(_arg1:Number):void{
            explicitColumnWidth = _arg1;
            if (_columnWidth != _arg1){
                setColumnWidth(_arg1);
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                dispatchEvent(new Event("columnWidthChanged"));
            };
        }
        protected function scrollHorizontally(_arg1:int, _arg2:int, _arg3:Boolean):void{
        }
        protected function drawHighlightIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            var _local8:Graphics = Sprite(_arg1).graphics;
            _local8.clear();
            _local8.beginFill(_arg6);
            _local8.drawRect(0, 0, _arg4, _arg5);
            _local8.endFill();
            _arg1.x = _arg2;
            _arg1.y = _arg3;
        }
        override public function get verticalScrollPosition():Number{
            if (!isNaN(verticalScrollPositionPending)){
                return (verticalScrollPositionPending);
            };
            return (super.verticalScrollPosition);
        }
        protected function drawCaretIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            var _local8:Graphics = Sprite(_arg1).graphics;
            _local8.clear();
            _local8.lineStyle(1, _arg6, 1);
            _local8.drawRect(0, 0, (_arg4 - 1), (_arg5 - 1));
            _arg1.x = _arg2;
            _arg1.y = _arg3;
        }
        private function makeAdditionalRows(_arg1:int):void{
            var cursorPos:* = null;
            var rowIndex:* = _arg1;
            if (iterator){
                cursorPos = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.CURRENT, listItems.length);
                } catch(e:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, listItems.length);
                    e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                };
            };
            var curY:* = (rowInfo[rowIndex].y + rowInfo[rowIndex].height);
            makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, (rowIndex + 1));
            seekPositionIgnoreError(iterator, cursorPos);
        }
        public function set showDataTips(_arg1:Boolean):void{
            _showDataTips = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("showDataTipsChanged"));
        }
        public function set nullItemRenderer(_arg1:IFactory):void{
            _nullItemRenderer = _arg1;
            invalidateSize();
            invalidateDisplayList();
            itemsSizeChanged = true;
            rendererChanged = true;
            dispatchEvent(new Event("nullItemRendererChanged"));
        }
        protected function moveIndicatorsHorizontally(_arg1:String, _arg2:Number):void{
            if (_arg1 != null){
                if (selectionIndicators[_arg1]){
                    selectionIndicators[_arg1].x = (selectionIndicators[_arg1].x + _arg2);
                };
                if (highlightUID == _arg1){
                    highlightIndicator.x = (highlightIndicator.x + _arg2);
                };
                if (caretUID == _arg1){
                    caretIndicator.x = (caretIndicator.x + _arg2);
                };
            };
        }
        private function seekPreviousSafely(_arg1:IViewCursor, _arg2:int):Boolean{
            var iterator:* = _arg1;
            var pos:* = _arg2;
            try {
                iterator.movePrevious();
            } catch(e:ItemPendingError) {
                lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos);
                e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                iteratorValid = false;
            };
            return (iteratorValid);
        }
        public function measureHeightOfItems(_arg1:int=-1, _arg2:int=0):Number{
            return (NaN);
        }
        public function get selectedItem():Object{
            return (_selectedItem);
        }
        protected function mouseMoveHandler(_arg1:MouseEvent):void{
            var _local2:Point;
            var _local3:IListItemRenderer;
            var _local4:DragEvent;
            var _local5:BaseListData;
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            _local2 = new Point(_arg1.localX, _arg1.localY);
            _local2 = DisplayObject(_arg1.target).localToGlobal(_local2);
            _local2 = globalToLocal(_local2);
            if (((((isPressed) && (mouseDownPoint))) && ((((Math.abs((mouseDownPoint.x - _local2.x)) > DRAG_THRESHOLD)) || ((Math.abs((mouseDownPoint.y - _local2.y)) > DRAG_THRESHOLD)))))){
                if (((((dragEnabled) && (!(DragManager.isDragging)))) && (mouseDownPoint))){
                    _local4 = new DragEvent(DragEvent.DRAG_START);
                    _local4.dragInitiator = this;
                    _local4.localX = mouseDownPoint.x;
                    _local4.localY = mouseDownPoint.y;
                    _local4.buttonDown = true;
                    dispatchEvent(_local4);
                };
            };
            _local3 = mouseEventToItemRenderer(_arg1);
            if (((_local3) && (highlightItemRenderer))){
                _local5 = rowMap[_local3.name];
                if (((((highlightItemRenderer) && (highlightUID))) && (!((_local5.uid == highlightUID))))){
                    if (!isPressed){
                        if (((getStyle("useRollOver")) && (!((highlightItemRenderer.data == null))))){
                            clearHighlight(highlightItemRenderer);
                        };
                    };
                };
            } else {
                if (((!(_local3)) && (highlightItemRenderer))){
                    if (!isPressed){
                        if (((getStyle("useRollOver")) && (highlightItemRenderer.data))){
                            clearHighlight(highlightItemRenderer);
                        };
                    };
                };
            };
            if (((_local3) && (!(highlightItemRenderer)))){
                mouseOverHandler(_arg1);
            };
        }
        public function get selectable():Boolean{
            return (_selectable);
        }
        protected function seekPendingFailureHandler(_arg1:Object, _arg2:ListBaseSeekPending):void{
        }
        override public function set verticalScrollPosition(_arg1:Number):void{
            var _local5:int;
            var _local6:Boolean;
            if ((((((listItems.length == 0)) || (!(dataProvider)))) || (!(isNaN(verticalScrollPositionPending))))){
                verticalScrollPositionPending = _arg1;
                if (dataProvider){
                    invalidateDisplayList();
                };
                return;
            };
            verticalScrollPositionPending = NaN;
            var _local2:int = super.verticalScrollPosition;
            super.verticalScrollPosition = _arg1;
            removeClipMask();
            var _local3:int = offscreenExtraRowsTop;
            var _local4:int = offscreenExtraRowsBottom;
            if (_local2 != _arg1){
                _local5 = (_arg1 - _local2);
                _local6 = (_local5 > 0);
                _local5 = Math.abs(_local5);
                if ((((_local5 >= (rowInfo.length - offscreenExtraRows))) || (!(iteratorValid)))){
                    clearIndicators();
                    clearVisibleData();
                    makeRowsAndColumnsWithExtraRows(oldUnscaledWidth, oldUnscaledHeight);
                } else {
                    scrollVertically(_arg1, _local5, _local6);
                    adjustListContent(oldUnscaledWidth, oldUnscaledHeight);
                };
                if (variableRowHeight){
                    configureScrollBars();
                };
                drawRowBackgrounds();
            };
            addClipMask(((!((offscreenExtraRowsTop == _local3))) || (!((offscreenExtraRowsBottom == _local4)))));
        }
        override public function get horizontalScrollPosition():Number{
            if (!isNaN(horizontalScrollPositionPending)){
                return (horizontalScrollPositionPending);
            };
            return (super.horizontalScrollPosition);
        }
        protected function itemRendererToIndices(_arg1:IListItemRenderer):Point{
            if (((!(_arg1)) || (!((_arg1.name in rowMap))))){
                return (null);
            };
            var _local2:int = rowMap[_arg1.name].rowIndex;
            var _local3:int = listItems[_local2].length;
            var _local4:int;
            while (_local4 < _local3) {
                if (listItems[_local2][_local4] == _arg1){
                    break;
                };
                _local4++;
            };
            return (new Point((_local4 + horizontalScrollPosition), ((_local2 + verticalScrollPosition) + offscreenExtraRowsTop)));
        }
        private function reduceRows(_arg1:int):void{
            var _local2:int;
            var _local3:int;
            var _local4:String;
            while (_arg1 >= 0) {
                if (rowInfo[_arg1].y >= listContent.height){
                    _local2 = listItems[_arg1].length;
                    _local3 = 0;
                    while (_local3 < _local2) {
                        addToFreeItemRenderers(listItems[_arg1][_local3]);
                        _local3++;
                    };
                    _local4 = rowInfo[_arg1].uid;
                    delete visibleData[_local4];
                    removeIndicators(_local4);
                    listItems.pop();
                    rowInfo.pop();
                    _arg1--;
                } else {
                    break;
                };
            };
        }
        public function get dragMoveEnabled():Boolean{
            return (_dragMoveEnabled);
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Point;
            var _local4:ListEvent;
            if (!selectable){
                return;
            };
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
                    moveSelectionVertically(_arg1.keyCode, _arg1.shiftKey, _arg1.ctrlKey);
                    _arg1.stopPropagation();
                    break;
                case Keyboard.SPACE:
                    if (((((!((caretIndex == -1))) && (((caretIndex - verticalScrollPosition) >= 0)))) && (((caretIndex - verticalScrollPosition) < listItems.length)))){
                        _local2 = listItems[(caretIndex - verticalScrollPosition)][0];
                        if (selectItem(_local2, _arg1.shiftKey, _arg1.ctrlKey)){
                            _local3 = itemRendererToIndices(_local2);
                            _local4 = new ListEvent(ListEvent.CHANGE);
                            if (_local3){
                                _local4.columnIndex = _local3.x;
                                _local4.rowIndex = _local3.y;
                            };
                            _local4.itemRenderer = _local2;
                            dispatchEvent(_local4);
                        };
                    };
                    break;
                default:
                    if (findKey(_arg1.keyCode)){
                        _arg1.stopPropagation();
                    };
            };
        }
        protected function reKeyVisibleData():void{
            var _local2:Object;
            var _local1:Object = {};
            for each (_local2 in visibleData) {
                if (_local2.data){
                    _local1[itemToUID(_local2.data)] = _local2;
                };
            };
            listContent.visibleData = _local1;
        }
        protected function copySelectedItems(_arg1:Boolean=true):Array{
            var _local2:Array = [];
            var _local3:ListBaseSelectionData = firstSelectionData;
            while (_local3 != null) {
                if (_arg1){
                    _local2.push(_local3.data);
                } else {
                    _local2.push(_local3.index);
                };
                _local3 = _local3.nextSelectionData;
            };
            return (_local2);
        }
        public function invalidateList():void{
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        protected function moveIndicatorsVertically(_arg1:String, _arg2:Number):void{
            if (_arg1 != null){
                if (selectionIndicators[_arg1]){
                    selectionIndicators[_arg1].y = (selectionIndicators[_arg1].y + _arg2);
                };
                if (highlightUID == _arg1){
                    highlightIndicator.y = (highlightIndicator.y + _arg2);
                };
                if (caretUID == _arg1){
                    caretIndicator.y = (caretIndicator.y + _arg2);
                };
            };
        }
        public function indexToItemRenderer(_arg1:int):IListItemRenderer{
            var _local2:int = (verticalScrollPosition - offscreenExtraRowsTop);
            if ((((_arg1 < _local2)) || ((_arg1 >= (_local2 + listItems.length))))){
                return (null);
            };
            return (listItems[(_arg1 - _local2)][0]);
        }
        protected function get dragImage():IUIComponent{
            var _local1:ListItemDragProxy = new ListItemDragProxy();
            _local1.owner = this;
            _local1.moduleFactory = moduleFactory;
            return (_local1);
        }
        protected function copyItemWithUID(_arg1:Object):Object{
            var _local2:Object;
            _local2 = ObjectUtil.copy(_arg1);
            if ((_local2 is IUID)){
                IUID(_local2).uid = UIDUtil.createUID();
            } else {
                if ((((_local2 is Object)) && (("mx_internal_uid" in _local2)))){
                    _local2.mx_internal_uid = UIDUtil.createUID();
                };
            };
            return (_local2);
        }
        public function get selectedIndices():Array{
            if (bSelectedIndicesChanged){
                return (_selectedIndices);
            };
            return (copySelectedItems(false));
        }
        public function get variableRowHeight():Boolean{
            return (_variableRowHeight);
        }
        protected function mouseDoubleClickHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Point;
            var _local4:ListEvent;
            _local2 = mouseEventToItemRenderer(_arg1);
            if (!_local2){
                return;
            };
            _local3 = itemRendererToIndices(_local2);
            if (_local3){
                _local4 = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
                _local4.columnIndex = _local3.x;
                _local4.rowIndex = _local3.y;
                _local4.itemRenderer = _local2;
                dispatchEvent(_local4);
            };
        }
        mx_internal function selectionDataPendingResultHandler(_arg1:Object, _arg2:ListBaseSelectionDataPending):void{
            if (_arg2.bookmark){
                collectionIterator.seek(_arg2.bookmark, _arg2.offset);
            };
            setSelectionDataLoop(_arg2.items, _arg2.index, _arg2.useFind);
        }
        public function set selectedItem(_arg1:Object):void{
            if (((!(collection)) || ((collection.length == 0)))){
                _selectedItem = _arg1;
                bSelectedItemChanged = true;
                bSelectionChanged = true;
                invalidateDisplayList();
                return;
            };
            commitSelectedItem(_arg1);
        }
        private function adjustScrollPosition():void{
            var _local2:Number;
            var _local3:Number;
            var _local4:int;
            var _local1:Boolean;
            if (!isNaN(horizontalScrollPositionPending)){
                _local1 = true;
                _local2 = Math.min(horizontalScrollPositionPending, maxHorizontalScrollPosition);
                horizontalScrollPositionPending = NaN;
                super.horizontalScrollPosition = _local2;
            };
            if (!isNaN(verticalScrollPositionPending)){
                _local1 = true;
                _local3 = Math.min(verticalScrollPositionPending, maxVerticalScrollPosition);
                verticalScrollPositionPending = NaN;
                super.verticalScrollPosition = _local3;
            };
            if (_local1){
                _local4 = scrollPositionToIndex(horizontalScrollPosition, (verticalScrollPosition - offscreenExtraRowsTop));
                seekPositionSafely(_local4);
            };
        }
        protected function indexToColumn(_arg1:int):int{
            return (0);
        }
        protected function itemToUID(_arg1:Object):String{
            if (_arg1 == null){
                return ("null");
            };
            return (UIDUtil.getUID(_arg1));
        }
        protected function dragEnterHandler(_arg1:DragEvent):void{
            if (_arg1.isDefaultPrevented()){
                return;
            };
            lastDragEvent = _arg1;
            if (((((enabled) && (iteratorValid))) && (_arg1.dragSource.hasFormat("items")))){
                DragManager.acceptDragDrop(this);
                DragManager.showFeedback(((_arg1.ctrlKey) ? DragManager.COPY : DragManager.MOVE));
                showDropFeedback(_arg1);
                return;
            };
            hideDropFeedback(_arg1);
            DragManager.showFeedback(DragManager.NONE);
        }
        public function set selectable(_arg1:Boolean):void{
            _selectable = _arg1;
        }
        protected function moveRowVertically(_arg1:int, _arg2:int, _arg3:Number):void{
            var _local4:IListItemRenderer;
            var _local5:int;
            while (_local5 < _arg2) {
                _local4 = listItems[_arg1][_local5];
                listItems[_arg1][_local5].move(_local4.x, (_local4.y + _arg3));
                _local5++;
            };
            rowInfo[_arg1].y = (rowInfo[_arg1].y + _arg3);
        }
        override public function set horizontalScrollPosition(_arg1:Number):void{
            var _local3:int;
            var _local4:Boolean;
            if ((((((listItems.length == 0)) || (!(dataProvider)))) || (!(isNaN(horizontalScrollPositionPending))))){
                horizontalScrollPositionPending = _arg1;
                if (dataProvider){
                    invalidateDisplayList();
                };
                return;
            };
            horizontalScrollPositionPending = NaN;
            var _local2:int = super.horizontalScrollPosition;
            super.horizontalScrollPosition = _arg1;
            removeClipMask();
            if (_local2 != _arg1){
                if (itemsSizeChanged){
                    return;
                };
                _local3 = (_arg1 - _local2);
                _local4 = (_local3 > 0);
                _local3 = Math.abs(_local3);
                if (((bColumnScrolling) && ((_local3 >= columnCount)))){
                    clearIndicators();
                    clearVisibleData();
                    makeRowsAndColumnsWithExtraColumns(oldUnscaledWidth, oldUnscaledHeight);
                    drawRowBackgrounds();
                } else {
                    scrollHorizontally(_arg1, _local3, _local4);
                };
            };
            addClipMask(false);
        }
        public function set dragMoveEnabled(_arg1:Boolean):void{
            _dragMoveEnabled = _arg1;
        }
        public function isItemHighlighted(_arg1:Object):Boolean{
            if (_arg1 == null){
                return (false);
            };
            var _local2:Boolean = ((highlightIndicator) && (!((highlightIndicator.parent.getChildIndex(highlightIndicator) == (highlightIndicator.parent.numChildren - 1)))));
            if ((_arg1 is String)){
                return ((((_arg1 == highlightUID)) && (!(_local2))));
            };
            return ((((itemToUID(_arg1) == highlightUID)) && (!(_local2))));
        }
        override protected function mouseWheelHandler(_arg1:MouseEvent):void{
            var _local2:Number;
            var _local3:int;
            var _local4:ScrollEvent;
            if (((verticalScrollBar) && (verticalScrollBar.visible))){
                _arg1.stopPropagation();
                _local2 = verticalScrollPosition;
                _local3 = verticalScrollPosition;
                _local3 = (_local3 - (_arg1.delta * verticalScrollBar.lineScrollSize));
                _local3 = Math.max(0, Math.min(_local3, verticalScrollBar.maxScrollPosition));
                verticalScrollPosition = _local3;
                if (_local2 != verticalScrollPosition){
                    _local4 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local4.direction = ScrollEventDirection.VERTICAL;
                    _local4.position = verticalScrollPosition;
                    _local4.delta = (verticalScrollPosition - _local2);
                    dispatchEvent(_local4);
                };
            };
        }
        protected function restoreRowArrays(_arg1:int):void{
            rowInfo.splice(0, _arg1);
            listItems.splice(0, _arg1);
        }
        public function set labelField(_arg1:String):void{
            _labelField = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("labelFieldChanged"));
        }
        private function seekPositionIgnoreError(_arg1:IViewCursor, _arg2:CursorBookmark):void{
            var iterator:* = _arg1;
            var cursorPos:* = _arg2;
            if (iterator){
                try {
                    iterator.seek(cursorPos, 0);
                } catch(e:ItemPendingError) {
                };
            };
        }
        protected function finishDataChangeEffect(_arg1:EffectEvent):void{
            collection = actualCollection;
            actualCollection = null;
            modifiedCollectionView = null;
            listContent.iterator = (iterator = actualIterator);
            runningDataEffect = false;
            unconstrainedRenderers = new Dictionary();
            terminateSelectionTracking();
            reKeyVisibleData();
            var _local2:int = scrollPositionToIndex((horizontalScrollPosition - offscreenExtraColumnsLeft), (verticalScrollPosition - offscreenExtraRowsTop));
            iterator.seek(CursorBookmark.FIRST, _local2);
            callLater(cleanupAfterDataChangeEffect);
        }
        public function set offscreenExtraRowsOrColumns(_arg1:int):void{
            _arg1 = Math.max(_arg1, 0);
            if ((_arg1 % 2)){
                _arg1++;
            };
            if (_offscreenExtraRowsOrColumns == _arg1){
                return;
            };
            _offscreenExtraRowsOrColumns = _arg1;
            offscreenExtraRowsOrColumnsChanged = true;
            invalidateProperties();
        }
        mx_internal function clearHighlight(_arg1:IListItemRenderer):void{
            var _local4:ListEvent;
            var _local2:String = itemToUID(_arg1.data);
            drawItem(UIDToItemRenderer(_local2), isItemSelected(_arg1.data), false, (_local2 == caretUID));
            var _local3:Point = itemRendererToIndices(_arg1);
            if (((_local3) && (lastHighlightItemIndices))){
                _local4 = new ListEvent(ListEvent.ITEM_ROLL_OUT);
                _local4.columnIndex = lastHighlightItemIndices.x;
                _local4.rowIndex = lastHighlightItemIndices.y;
                _local4.itemRenderer = lastHighlightItemRendererAtIndices;
                dispatchEvent(_local4);
                lastHighlightItemIndices = null;
            };
        }
        public function set wordWrap(_arg1:Boolean):void{
            if (_arg1 == _wordWrap){
                return;
            };
            _wordWrap = _arg1;
            wordWrapChanged = true;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("wordWrapChanged"));
        }
        private function shiftSelectionLoop(_arg1:Boolean, _arg2:int, _arg3:Object, _arg4:Boolean, _arg5:CursorBookmark):void{
            var data:* = null;
            var uid:* = null;
            var incr:* = _arg1;
            var index:* = _arg2;
            var stopData:* = _arg3;
            var transition:* = _arg4;
            var placeHolder:* = _arg5;
            try {
                do  {
                    data = iterator.current;
                    uid = itemToUID(data);
                    insertSelectionDataBefore(uid, new ListBaseSelectionData(data, index, approximate), firstSelectionData);
                    if (UIDToItemRenderer(uid)){
                        drawItem(UIDToItemRenderer(uid), true, (uid == highlightUID), false, transition);
                    };
                    if (data === stopData){
                        if (UIDToItemRenderer(uid)){
                            drawItem(UIDToItemRenderer(uid), true, (uid == highlightUID), true, transition);
                        };
                        break;
                    };
                    if (incr){
                        index = (index + 1);
                    } else {
                        index = (index - 1);
                    };
                } while (((incr) ? iterator.moveNext() : iterator.movePrevious()));
            } catch(e:ItemPendingError) {
                e.addResponder(new ItemResponder(selectionPendingResultHandler, selectionPendingFailureHandler, new ListBaseSelectionPending(incr, index, stopData, transition, placeHolder, CursorBookmark.CURRENT, 0)));
                iteratorValid = false;
            };
            try {
                iterator.seek(placeHolder, 0);
                if (!iteratorValid){
                    iteratorValid = true;
                    lastSeekPending = null;
                };
            } catch(e2:ItemPendingError) {
                lastSeekPending = new ListBaseSeekPending(placeHolder, 0);
                e2.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
            };
        }
        protected function clearHighlightIndicator(_arg1:Sprite, _arg2:IListItemRenderer):void{
            if (highlightIndicator){
                Sprite(highlightIndicator).graphics.clear();
            };
        }
        protected function truncateRowArrays(_arg1:int):void{
            listItems.splice(_arg1);
            rowInfo.splice(_arg1);
        }
        public function get itemRenderer():IFactory{
            return (_itemRenderer);
        }
        protected function seekPositionSafely(_arg1:int):Boolean{
            var index:* = _arg1;
            try {
                iterator.seek(CursorBookmark.FIRST, index);
                if (!iteratorValid){
                    iteratorValid = true;
                    lastSeekPending = null;
                };
            } catch(e:ItemPendingError) {
                lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, index);
                e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                iteratorValid = false;
            };
            return (iteratorValid);
        }
        mx_internal function set $horizontalScrollPosition(_arg1:Number):void{
            var _local2:int = super.horizontalScrollPosition;
            if (_local2 != _arg1){
                super.horizontalScrollPosition = _arg1;
            };
        }
        protected function applySelectionEffect(_arg1:Sprite, _arg2:String, _arg3:IListItemRenderer):void{
            var _local5:Function;
            var _local4:Number = getStyle("selectionDuration");
            if (_local4 != 0){
                _arg1.alpha = 0;
                selectionTweens[_arg2] = new Tween(_arg1, 0, 1, _local4, 5);
                selectionTweens[_arg2].addEventListener(TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);
                selectionTweens[_arg2].addEventListener(TweenEvent.TWEEN_END, selectionTween_endHandler);
                selectionTweens[_arg2].setTweenHandlers(onSelectionTweenUpdate, onSelectionTweenUpdate);
                _local5 = (getStyle("selectionEasingFunction") as Function);
                if (_local5 != null){
                    selectionTweens[_arg2].easingFunction = _local5;
                };
            };
        }
        override public function set showInAutomationHierarchy(_arg1:Boolean):void{
        }
        protected function removeFromRowArrays(_arg1:int):void{
            listItems.splice(_arg1, 1);
            rowInfo.splice(_arg1, 1);
        }
        protected function updateList():void{
            removeClipMask();
            var _local1:CursorBookmark = ((iterator) ? iterator.bookmark : null);
            clearIndicators();
            clearVisibleData();
            if (iterator){
                if (((((offscreenExtraColumns) || (offscreenExtraColumnsLeft))) || (offscreenExtraColumnsRight))){
                    makeRowsAndColumnsWithExtraColumns(unscaledWidth, unscaledHeight);
                } else {
                    makeRowsAndColumnsWithExtraRows(unscaledWidth, unscaledHeight);
                };
                iterator.seek(_local1, 0);
            } else {
                makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
            };
            drawRowBackgrounds();
            configureScrollBars();
            addClipMask(true);
        }
        public function set variableRowHeight(_arg1:Boolean):void{
            _variableRowHeight = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("variableRowHeightChanged"));
        }
        protected function isRendererUnconstrained(_arg1:Object):Boolean{
            return (!((unconstrainedRenderers[_arg1] == null)));
        }
        public function set selectedIndices(_arg1:Array):void{
            if (((!(collection)) || ((collection.length == 0)))){
                _selectedIndices = _arg1;
                bSelectedIndicesChanged = true;
                bSelectionChanged = true;
                invalidateDisplayList();
                return;
            };
            commitSelectedIndices(_arg1);
        }
        protected function mouseUpHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Point;
            var _local4:ListEvent;
            mouseDownPoint = null;
            _local2 = mouseEventToItemRenderer(_arg1);
            _local3 = itemRendererToIndices(_local2);
            mouseIsUp();
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            if (mouseDownItem){
                _local4 = new ListEvent(ListEvent.CHANGE);
                _local4.itemRenderer = mouseDownItem;
                _local3 = itemRendererToIndices(mouseDownItem);
                if (_local3){
                    _local4.columnIndex = _local3.x;
                    _local4.rowIndex = _local3.y;
                };
                dispatchEvent(_local4);
                mouseDownItem = null;
            };
            if (((!(_local2)) || (!(hitTestPoint(_arg1.stageX, _arg1.stageY))))){
                isPressed = false;
                return;
            };
            if (bSelectOnRelease){
                bSelectOnRelease = false;
                if (selectItem(_local2, _arg1.shiftKey, _arg1.ctrlKey)){
                    _local4 = new ListEvent(ListEvent.CHANGE);
                    _local4.itemRenderer = _local2;
                    if (_local3){
                        _local4.columnIndex = _local3.x;
                        _local4.rowIndex = _local3.y;
                    };
                    dispatchEvent(_local4);
                };
            };
            isPressed = false;
        }
        public function get allowMultipleSelection():Boolean{
            return (_allowMultipleSelection);
        }
        public function itemToItemRenderer(_arg1:Object):IListItemRenderer{
            return (UIDToItemRenderer(itemToUID(_arg1)));
        }
        public function isItemSelected(_arg1:Object):Boolean{
            if (_arg1 == null){
                return (false);
            };
            if ((_arg1 is String)){
                return (!((selectedData[_arg1] == undefined)));
            };
            return (!((selectedData[itemToUID(_arg1)] == undefined)));
        }
        protected function dragScroll():void{
            var _local2:Number;
            var _local3:Number;
            var _local4:Number;
            var _local5:ScrollEvent;
            var _local1:Number = 0;
            if (dragScrollingInterval == 0){
                return;
            };
            var _local6:Number = 30;
            _local3 = verticalScrollPosition;
            if (DragManager.isDragging){
                _local1 = (viewMetrics.top + ((variableRowHeight) ? (getStyle("fontSize") / 4) : rowHeight));
            };
            clearInterval(dragScrollingInterval);
            if (mouseY < _local1){
                verticalScrollPosition = Math.max(0, (_local3 - 1));
                if (DragManager.isDragging){
                    _local2 = 100;
                } else {
                    _local4 = Math.min(((0 - mouseY) - 30), 0);
                    _local2 = ((((0.593 * _local4) * _local4) + 1) + _local6);
                };
                dragScrollingInterval = setInterval(dragScroll, _local2);
                if (_local3 != verticalScrollPosition){
                    _local5 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local5.detail = ScrollEventDetail.THUMB_POSITION;
                    _local5.direction = ScrollEventDirection.VERTICAL;
                    _local5.position = verticalScrollPosition;
                    _local5.delta = (verticalScrollPosition - _local3);
                    dispatchEvent(_local5);
                };
            } else {
                if (mouseY > (unscaledHeight - _local1)){
                    verticalScrollPosition = Math.min(maxVerticalScrollPosition, (verticalScrollPosition + 1));
                    if (DragManager.isDragging){
                        _local2 = 100;
                    } else {
                        _local4 = Math.min(((mouseY - unscaledHeight) - 30), 0);
                        _local2 = ((((0.593 * _local4) * _local4) + 1) + _local6);
                    };
                    dragScrollingInterval = setInterval(dragScroll, _local2);
                    if (_local3 != verticalScrollPosition){
                        _local5 = new ScrollEvent(ScrollEvent.SCROLL);
                        _local5.detail = ScrollEventDetail.THUMB_POSITION;
                        _local5.direction = ScrollEventDirection.VERTICAL;
                        _local5.position = verticalScrollPosition;
                        _local5.delta = (verticalScrollPosition - _local3);
                        dispatchEvent(_local5);
                    };
                } else {
                    dragScrollingInterval = setInterval(dragScroll, 15);
                };
            };
            if (((((DragManager.isDragging) && (lastDragEvent))) && (!((_local3 == verticalScrollPosition))))){
                dragOverHandler(lastDragEvent);
            };
        }
        protected function moveSelectionHorizontally(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
        }
        private function findStringLoop(_arg1:String, _arg2:CursorBookmark, _arg3:int, _arg4:int):Boolean{
            var itmStr:* = null;
            var item:* = null;
            var pt:* = null;
            var evt:* = null;
            var more:* = false;
            var str:* = _arg1;
            var cursorPos:* = _arg2;
            var i:* = _arg3;
            var stopIndex:* = _arg4;
            while (i != stopIndex) {
                itmStr = itemToLabel(iterator.current);
                itmStr = itmStr.substring(0, str.length);
                if ((((str == itmStr)) || ((str.toUpperCase() == itmStr.toUpperCase())))){
                    iterator.seek(cursorPos, 0);
                    scrollToIndex(i);
                    commitSelectedIndex(i);
                    item = indexToItemRenderer(i);
                    pt = itemRendererToIndices(item);
                    evt = new ListEvent(ListEvent.CHANGE);
                    evt.itemRenderer = item;
                    if (pt){
                        evt.columnIndex = pt.x;
                        evt.rowIndex = pt.y;
                    };
                    dispatchEvent(evt);
                    return (true);
                };
                try {
                    more = iterator.moveNext();
                } catch(e1:ItemPendingError) {
                    e1.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, CursorBookmark.CURRENT, 1, (i + 1), stopIndex)));
                    iteratorValid = false;
                    return (false);
                };
                if (((!(more)) && (!((stopIndex == collection.length))))){
                    i = -1;
                    try {
                        iterator.seek(CursorBookmark.FIRST, 0);
                    } catch(e2:ItemPendingError) {
                        e2.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, CursorBookmark.FIRST, 0, 0, stopIndex)));
                        iteratorValid = false;
                        return (false);
                    };
                };
                i = (i + 1);
            };
            iterator.seek(cursorPos, 0);
            iteratorValid = true;
            return (false);
        }
        protected function drawRowBackgrounds():void{
        }
        private function selectionIndicesPendingResultHandler(_arg1:Object, _arg2:ListBaseSelectionDataPending):void{
            if (_arg2.bookmark){
                iterator.seek(_arg2.bookmark, _arg2.offset);
            };
            setSelectionIndicesLoop(_arg2.index, _arg2.items, _arg2.useFind);
        }
        public function itemRendererContains(_arg1:IListItemRenderer, _arg2:DisplayObject):Boolean{
            if (!_arg2){
                return (false);
            };
            if (!_arg1){
                return (false);
            };
            return (_arg1.owns(_arg2));
        }
        public function removeDataEffectItem(_arg1:Object):void{
            if (modifiedCollectionView){
                modifiedCollectionView.removeItem(dataItemWrappersByRenderer[_arg1]);
                iterator.seek(CursorBookmark.CURRENT);
                if (invalidateDisplayListFlag){
                    callLater(invalidateList);
                } else {
                    invalidateList();
                };
            };
        }
        override public function set horizontalScrollPolicy(_arg1:String):void{
            super.horizontalScrollPolicy = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        public function itemRendererToIndex(_arg1:IListItemRenderer):int{
            var _local2:int;
            if ((_arg1.name in rowMap)){
                _local2 = rowMap[_arg1.name].rowIndex;
                return (((_local2 + verticalScrollPosition) - offscreenExtraRowsTop));
            };
            return (int.MIN_VALUE);
        }
        public function get dropEnabled():Boolean{
            return (_dropEnabled);
        }
        private function setSelectionIndicesLoop(_arg1:int, _arg2:Array, _arg3:Boolean=false):void{
            var data:* = null;
            var uid:* = null;
            var index:* = _arg1;
            var indices:* = _arg2;
            var firstTime:Boolean = _arg3;
            while (indices.length) {
                if (index != indices[0]){
                    try {
                        collectionIterator.seek(CursorBookmark.CURRENT, (indices[0] - index));
                    } catch(e:ItemPendingError) {
                        e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler, selectionIndicesPendingFailureHandler, new ListBaseSelectionDataPending(firstTime, index, indices, CursorBookmark.CURRENT, (indices[0] - index))));
                        return;
                    };
                };
                index = indices[0];
                indices.shift();
                data = collectionIterator.current;
                if (firstTime){
                    _selectedIndex = index;
                    _selectedItem = data;
                    caretIndex = index;
                    caretBookmark = collectionIterator.bookmark;
                    anchorIndex = index;
                    anchorBookmark = collectionIterator.bookmark;
                    firstTime = false;
                };
                uid = itemToUID(data);
                insertSelectionDataAfter(uid, new ListBaseSelectionData(data, index, false), lastSelectionData);
                if (UIDToItemRenderer(uid)){
                    drawItem(UIDToItemRenderer(uid), true, (uid == highlightUID), (caretIndex == index));
                };
            };
            if (initialized){
                updateList();
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        override protected function measure():void{
            super.measure();
            var _local1:EdgeMetrics = viewMetrics;
            var _local2:int = (((explicitColumnCount < 1)) ? defaultColumnCount : explicitColumnCount);
            var _local3:int = (((explicitRowCount < 1)) ? defaultRowCount : explicitRowCount);
            if (!isNaN(explicitRowHeight)){
                measuredHeight = (((explicitRowHeight * _local3) + _local1.top) + _local1.bottom);
                measuredMinHeight = (((explicitRowHeight * Math.min(_local3, 2)) + _local1.top) + _local1.bottom);
            } else {
                measuredHeight = (((rowHeight * _local3) + _local1.top) + _local1.bottom);
                measuredMinHeight = (((rowHeight * Math.min(_local3, 2)) + _local1.top) + _local1.bottom);
            };
            if (!isNaN(explicitColumnWidth)){
                measuredWidth = (((explicitColumnWidth * _local2) + _local1.left) + _local1.right);
                measuredMinWidth = (((explicitColumnWidth * Math.min(_local2, 1)) + _local1.left) + _local1.right);
            } else {
                measuredWidth = (((columnWidth * _local2) + _local1.left) + _local1.right);
                measuredMinWidth = (((columnWidth * Math.min(_local2, 1)) + _local1.left) + _local1.right);
            };
            if ((((((verticalScrollPolicy == ScrollPolicy.AUTO)) && (verticalScrollBar))) && (verticalScrollBar.visible))){
                measuredWidth = (measuredWidth - verticalScrollBar.minWidth);
                measuredMinWidth = (measuredMinWidth - verticalScrollBar.minWidth);
            };
            if ((((((horizontalScrollPolicy == ScrollPolicy.AUTO)) && (horizontalScrollBar))) && (horizontalScrollBar.visible))){
                measuredHeight = (measuredHeight - horizontalScrollBar.minHeight);
                measuredMinHeight = (measuredMinHeight - horizontalScrollBar.minHeight);
            };
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        private function removeSelectionData(_arg1:String):void{
            var _local2:ListBaseSelectionData = selectedData[_arg1];
            if (firstSelectionData == _local2){
                firstSelectionData = _local2.nextSelectionData;
            };
            if (lastSelectionData == _local2){
                lastSelectionData = _local2.prevSelectionData;
            };
            if (_local2.prevSelectionData != null){
                _local2.prevSelectionData.nextSelectionData = _local2.nextSelectionData;
            };
            if (_local2.nextSelectionData != null){
                _local2.nextSelectionData.prevSelectionData = _local2.prevSelectionData;
            };
            delete selectedData[_arg1];
        }
        protected function setRowHeight(_arg1:Number):void{
            _rowHeight = _arg1;
        }
        public function indicesToIndex(_arg1:int, _arg2:int):int{
            return (((_arg1 * columnCount) + _arg2));
        }
        public function get value():Object{
            var _local1:Object = selectedItem;
            if (!_local1){
                return (null);
            };
            if (typeof(_local1) != "object"){
                return (_local1);
            };
            return (((_local1.data)!=null) ? _local1.data : _local1.label);
        }
        mx_internal function getRowInfo():Array{
            return (rowInfo);
        }
        private function rendererMoveHandler(_arg1:MoveEvent):void{
            var _local2:IListItemRenderer;
            if (!rendererTrackingSuspended){
                _local2 = (_arg1.currentTarget as IListItemRenderer);
                drawItem(_local2, true);
            };
        }
        protected function calculateDropIndicatorY(_arg1:Number, _arg2:int):Number{
            var _local3:int;
            var _local4:Number = 0;
            if (((((((_arg1) && ((_arg2 < _arg1)))) && (listItems[_arg2].length))) && (listItems[_arg2][0]))){
                return ((listItems[_arg2][0].y - 1));
            };
            _local3 = 0;
            while (_local3 < _arg1) {
                if (listItems[_local3].length){
                    _local4 = (_local4 + rowInfo[_local3].height);
                } else {
                    break;
                };
                _local3++;
            };
            return (_local4);
        }
        protected function clearCaretIndicator(_arg1:Sprite, _arg2:IListItemRenderer):void{
            if (caretIndicator){
                Sprite(caretIndicator).graphics.clear();
            };
        }
        override public function validateDisplayList():void{
            var _local1:ISystemManager;
            if (invalidateDisplayListFlag){
                _local1 = (parent as ISystemManager);
                if (_local1){
                    if ((((_local1 == systemManager.topLevelSystemManager)) && (!((_local1.document == this))))){
                        setActualSize(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
                    };
                };
                if (runDataEffectNextUpdate){
                    runDataEffectNextUpdate = false;
                    runningDataEffect = true;
                    initiateDataChangeEffect((((scaleX == 0)) ? 0 : (width / scaleX)), (((scaleY == 0)) ? 0 : (height / scaleY)));
                } else {
                    updateDisplayList((((scaleX == 0)) ? 0 : (width / scaleX)), (((scaleY == 0)) ? 0 : (height / scaleY)));
                };
                invalidateDisplayListFlag = false;
            };
        }
        mx_internal function getListVisibleData():Object{
            return (visibleData);
        }
        public function getRendererSemanticValue(_arg1:Object, _arg2:String):Object{
            return ((modifiedCollectionView.getSemantics(dataItemWrappersByRenderer[_arg1]) == _arg2));
        }
        mx_internal function setColumnCount(_arg1:int):void{
            _columnCount = _arg1;
        }
        mx_internal function hasOnlyTextRenderers():Boolean{
            if (listItems.length == 0){
                return (true);
            };
            var _local1:Array = listItems[(listItems.length - 1)];
            var _local2:int = _local1.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (!(_local1[_local3] is IUITextField)){
                    return (false);
                };
                _local3++;
            };
            return (true);
        }
        protected function sumRowHeights(_arg1:int, _arg2:int):Number{
            var _local3:Number = 0;
            var _local4:int = _arg1;
            while (_local4 <= _arg2) {
                _local3 = (_local3 + rowInfo[_local4].height);
                _local4++;
            };
            return (_local3);
        }
        protected function get rowInfo():Array{
            return (listContent.rowInfo);
        }
        private function selectionPendingFailureHandler(_arg1:Object, _arg2:ListBaseSelectionPending):void{
        }
        mx_internal function convertIndexToColumn(_arg1:int):int{
            return (indexToColumn(_arg1));
        }
        mx_internal function createItemMask(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):DisplayObject{
            var _local5:Shape;
            var _local6:Graphics;
            if (!itemMaskFreeList){
                itemMaskFreeList = [];
            };
            if (itemMaskFreeList.length > 0){
                _local5 = itemMaskFreeList.pop();
                if (_local5.width != _arg3){
                    _local5.width = _arg3;
                };
                if (_local5.height != _arg4){
                    _local5.height = _arg4;
                };
            } else {
                _local5 = new FlexShape();
                _local5.name = "mask";
                _local6 = _local5.graphics;
                _local6.beginFill(0xFFFFFF);
                _local6.drawRect(0, 0, _arg3, _arg4);
                _local6.endFill();
                _local5.visible = false;
                listContent.addChild(_local5);
            };
            if (_local5.x != _arg1){
                _local5.x = _arg1;
            };
            if (_local5.y != _arg2){
                _local5.y = _arg2;
            };
            return (_local5);
        }
        mx_internal function convertIndexToRow(_arg1:int):int{
            return (indexToRow(_arg1));
        }
        protected function get listItems():Array{
            return (((listContent) ? listContent.listItems : []));
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:int;
            var _local3:int;
            super.commitProperties();
            if (((listContent) && (!((listContent.iterator == iterator))))){
                listContent.iterator = iterator;
            };
            if (cachedPaddingTopInvalid){
                cachedPaddingTopInvalid = false;
                cachedPaddingTop = getStyle("paddingTop");
                itemsSizeChanged = true;
                invalidateDisplayList();
            };
            if (cachedPaddingBottomInvalid){
                cachedPaddingBottomInvalid = false;
                cachedPaddingBottom = getStyle("paddingBottom");
                itemsSizeChanged = true;
                invalidateDisplayList();
            };
            if (cachedVerticalAlignInvalid){
                cachedVerticalAlignInvalid = false;
                cachedVerticalAlign = getStyle("verticalAlign");
                itemsSizeChanged = true;
                invalidateDisplayList();
            };
            if (columnCountChanged){
                if (_columnCount < 1){
                    _columnCount = defaultColumnCount;
                };
                if (((((!(isNaN(explicitWidth))) && (isNaN(explicitColumnWidth)))) && ((explicitColumnCount > 0)))){
                    setColumnWidth((((explicitWidth - viewMetrics.left) - viewMetrics.right) / columnCount));
                };
                columnCountChanged = false;
            };
            if (rowCountChanged){
                if (_rowCount < 1){
                    _rowCount = defaultRowCount;
                };
                if (((((!(isNaN(explicitHeight))) && (isNaN(explicitRowHeight)))) && ((explicitRowCount > 0)))){
                    setRowHeight((((explicitHeight - viewMetrics.top) - viewMetrics.bottom) / rowCount));
                };
                rowCountChanged = false;
            };
            if (offscreenExtraRowsOrColumnsChanged){
                adjustOffscreenRowsAndColumns();
                if (iterator){
                    _local1 = Math.min((offscreenExtraColumns / 2), horizontalScrollPosition);
                    _local2 = Math.min((offscreenExtraRows / 2), verticalScrollPosition);
                    _local3 = scrollPositionToIndex((horizontalScrollPosition - _local1), (verticalScrollPosition - _local2));
                    seekPositionSafely(_local3);
                    invalidateList();
                };
                offscreenExtraRowsOrColumnsChanged = false;
            };
        }
        protected function setRowCount(_arg1:int):void{
            _rowCount = _arg1;
        }
        public function set labelFunction(_arg1:Function):void{
            _labelFunction = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("labelFunctionChanged"));
        }
        protected function adjustAfterAdd(_arg1:Array, _arg2:int):Boolean{
            var length:* = 0;
            var requiresValueCommit:* = false;
            var data:* = null;
            var placeHolder:* = null;
            var p:* = null;
            var items:* = _arg1;
            var location:* = _arg2;
            length = items.length;
            requiresValueCommit = false;
            for (p in selectedData) {
                data = selectedData[p];
                if (data.index >= location){
                    data.index = (data.index + length);
                };
            };
            if (_selectedIndex >= location){
                _selectedIndex = (_selectedIndex + length);
                requiresValueCommit = true;
            };
            if (anchorIndex >= location){
                anchorIndex = (anchorIndex + length);
                placeHolder = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.FIRST, anchorIndex);
                    anchorBookmark = iterator.bookmark;
                } catch(e:ItemPendingError) {
                    e.addResponder(new ItemResponder(setBookmarkPendingResultHandler, setBookmarkPendingFailureHandler, {
                        property:"anchorBookmark",
                        value:anchorIndex
                    }));
                };
                iterator.seek(placeHolder);
            };
            if (caretIndex >= location){
                caretIndex = (caretIndex + length);
                placeHolder = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.FIRST, caretIndex);
                    caretBookmark = iterator.bookmark;
                } catch(e:ItemPendingError) {
                    e.addResponder(new ItemResponder(setBookmarkPendingResultHandler, setBookmarkPendingFailureHandler, {
                        property:"caretBookmark",
                        value:caretIndex
                    }));
                };
                iterator.seek(placeHolder);
            };
            return (requiresValueCommit);
        }
        private function mouseLeaveHandler(_arg1:Event):void{
            var _local2:ListEvent;
            var _local3:Point;
            mouseDownPoint = null;
            mouseIsUp();
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            if (mouseDownItem){
                _local2 = new ListEvent(ListEvent.CHANGE);
                _local2.itemRenderer = mouseDownItem;
                _local3 = itemRendererToIndices(mouseDownItem);
                if (_local3){
                    _local2.columnIndex = _local3.x;
                    _local2.rowIndex = _local3.y;
                };
                dispatchEvent(_local2);
                mouseDownItem = null;
            };
            isPressed = false;
        }
        public function unconstrainRenderer(_arg1:Object):void{
            unconstrainedRenderers[_arg1] = true;
        }
        mx_internal function getIterator():IViewCursor{
            return (iterator);
        }
        public function get selectedItems():Array{
            return (((bSelectedItemsChanged) ? _selectedItems : copySelectedItems()));
        }
        protected function findKey(_arg1:int):Boolean{
            var _local2:int = _arg1;
            return ((((((_local2 >= 33)) && ((_local2 <= 126)))) && (findString(String.fromCharCode(_local2)))));
        }
        override public function set verticalScrollPolicy(_arg1:String):void{
            super.verticalScrollPolicy = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        public function set selectedIndex(_arg1:int):void{
            if (((!(collection)) || ((collection.length == 0)))){
                _selectedIndex = _arg1;
                bSelectionChanged = true;
                bSelectedIndexChanged = true;
                invalidateDisplayList();
                return;
            };
            commitSelectedIndex(_arg1);
        }
        public function set itemRenderer(_arg1:IFactory):void{
            _itemRenderer = _arg1;
            invalidateSize();
            invalidateDisplayList();
            itemsSizeChanged = true;
            rendererChanged = true;
            dispatchEvent(new Event("itemRendererChanged"));
        }
        public function hideDropFeedback(_arg1:DragEvent):void{
            if (dropIndicator){
                DisplayObject(dropIndicator).parent.removeChild(DisplayObject(dropIndicator));
                dropIndicator = null;
                drawFocus(false);
            };
        }
        private function commitSelectedItems(_arg1:Array):void{
            var useFind:* = false;
            var items:* = _arg1;
            clearSelected();
            useFind = !((collection.sort == null));
            try {
                collectionIterator.seek(CursorBookmark.FIRST, 0);
            } catch(e:ItemPendingError) {
                e.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler, new ListBaseSelectionDataPending(useFind, 0, items, null, 0)));
                return;
            };
            setSelectionDataLoop(items, 0, useFind);
        }
        public function set dataTipField(_arg1:String):void{
            _dataTipField = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("dataTipFieldChanged"));
        }
        private function makeRowsAndColumnsWithExtraColumns(_arg1:Number, _arg2:Number):void{
            var _local10:int;
            var _local11:int;
            var _local12:int;
            var _local13:int;
            var _local3:int = (offscreenExtraColumns / 2);
            var _local4:int = (offscreenExtraColumns / 2);
            if (horizontalScrollPosition > (collection.length - columnCount)){
                super.horizontalScrollPosition = Math.max(0, (collection.length - columnCount));
            };
            offscreenExtraColumnsLeft = Math.min(_local3, horizontalScrollPosition);
            var _local5:int = scrollPositionToIndex((horizontalScrollPosition - offscreenExtraColumnsLeft), verticalScrollPosition);
            seekPositionSafely(_local5);
            var _local6:CursorBookmark = iterator.bookmark;
            if (offscreenExtraColumnsLeft > 0){
                makeRowsAndColumns(0, 0, 0, listContent.height, 0, 0, true, offscreenExtraColumnsLeft);
            };
            var _local7:Number = ((offscreenExtraColumnsLeft) ? (listItems[0][(offscreenExtraColumnsLeft - 1)].x + columnWidth) : 0);
            var _local8:Point = makeRowsAndColumns(_local7, 0, (_local7 + listContent.widthExcludingOffsets), listContent.height, offscreenExtraColumnsLeft, 0);
            if ((((_local4 > 0)) && (!(iterator.afterLast)))){
                if (((offscreenExtraColumnsLeft + _local8.x) - 1) < 0){
                    _local7 = 0;
                } else {
                    _local7 = (listItems[0][((offscreenExtraColumnsLeft + _local8.x) - 1)].x + columnWidth);
                };
                _local10 = listItems[0].length;
                _local8 = makeRowsAndColumns(_local7, 0, _local7, listContent.height, (offscreenExtraColumnsLeft + _local8.x), 0, true, _local4);
                if (_local8.x < _local4){
                    _local11 = (listItems[0].length - (_local10 + _local8.x));
                    if (_local11){
                        _local12 = 0;
                        while (_local12 < listItems.length) {
                            _local13 = 0;
                            while (_local13 < _local11) {
                                listItems[_local12].pop();
                                _local13++;
                            };
                            _local12++;
                        };
                    };
                };
                offscreenExtraColumnsRight = _local8.x;
            } else {
                offscreenExtraColumnsRight = 0;
            };
            var _local9:Number = listContent.widthExcludingOffsets;
            listContent.leftOffset = (-(offscreenExtraColumnsLeft) * columnWidth);
            listContent.rightOffset = ((offscreenExtraColumnsRight)>0) ? (((listItems[0][(listItems[0].length - 1)].x + columnWidth) - _local9) + listContent.leftOffset) : 0;
            iterator.seek(_local6, 0);
            adjustListContent(_arg1, _arg2);
        }
        protected function dragOverHandler(_arg1:DragEvent):void{
            if (_arg1.isDefaultPrevented()){
                return;
            };
            lastDragEvent = _arg1;
            if (((((enabled) && (iteratorValid))) && (_arg1.dragSource.hasFormat("items")))){
                DragManager.showFeedback(((_arg1.ctrlKey) ? DragManager.COPY : DragManager.MOVE));
                showDropFeedback(_arg1);
                return;
            };
            hideDropFeedback(_arg1);
            DragManager.showFeedback(DragManager.NONE);
        }
        private function adjustSelectionSettings(_arg1:Boolean):void{
            if (bSelectionChanged){
                bSelectionChanged = false;
                if (((bSelectedIndicesChanged) && (((_arg1) || ((_selectedIndices == null)))))){
                    bSelectedIndicesChanged = false;
                    bSelectedIndexChanged = false;
                    commitSelectedIndices(_selectedIndices);
                };
                if (((bSelectedItemChanged) && (((_arg1) || ((_selectedItem == null)))))){
                    bSelectedItemChanged = false;
                    bSelectedIndexChanged = false;
                    commitSelectedItem(_selectedItem);
                };
                if (((bSelectedItemsChanged) && (((_arg1) || ((_selectedItems == null)))))){
                    bSelectedItemsChanged = false;
                    bSelectedIndexChanged = false;
                    commitSelectedItems(_selectedItems);
                };
                if (((bSelectedIndexChanged) && (((_arg1) || ((_selectedIndex == -1)))))){
                    commitSelectedIndex(_selectedIndex);
                    bSelectedIndexChanged = false;
                };
            };
        }
        private function clearSelectionData():void{
            selectedData = {};
            firstSelectionData = null;
            lastSelectionData = null;
        }
        protected function shiftRow(_arg1:int, _arg2:int, _arg3:int, _arg4:Boolean):void{
            var _local5:IListItemRenderer;
            var _local6:int;
            while (_local6 < _arg3) {
                _local5 = listItems[_arg1][_local6];
                if (_arg4){
                    listItems[_arg2][_local6] = _local5;
                    rowMap[_local5.name].rowIndex = _arg2;
                } else {
                    rowMap[_local5.name].rowIndex = _arg1;
                };
                _local6++;
            };
            if (_arg4){
                rowInfo[_arg2] = rowInfo[_arg1];
            };
        }
        mx_internal function selectionTween_endHandler(_arg1:TweenEvent):void{
            selectionTween_updateHandler(_arg1);
        }
        mx_internal function resetDragScrolling():void{
            if (dragScrollingInterval != 0){
                clearInterval(dragScrollingInterval);
                dragScrollingInterval = 0;
            };
        }
        protected function mouseOverHandler(_arg1:MouseEvent):void{
            var _local2:ListEvent;
            var _local3:IListItemRenderer;
            var _local4:Point;
            var _local5:String;
            var _local6:String;
            var _local7:BaseListData;
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            if (((!((dragScrollingInterval == 0))) && (!(_arg1.buttonDown)))){
                mouseIsUp();
            };
            isPressed = _arg1.buttonDown;
            _local3 = mouseEventToItemRenderer(_arg1);
            _local4 = itemRendererToIndices(_local3);
            if (!_local3){
                return;
            };
            _local5 = itemToUID(_local3.data);
            if (((!(isPressed)) || (allowDragSelection))){
                if (_arg1.relatedObject){
                    if (((lastHighlightItemRenderer) && (highlightUID))){
                        _local7 = rowMap[_local3.name];
                        _local6 = _local7.uid;
                    };
                    if (((((itemRendererContains(_local3, _arg1.relatedObject)) || ((_local5 == _local6)))) || ((_arg1.relatedObject == highlightIndicator)))){
                        return;
                    };
                };
                if (((getStyle("useRollOver")) && (!((_local3.data == null))))){
                    if (allowDragSelection){
                        bSelectOnRelease = true;
                    };
                    drawItem(UIDToItemRenderer(_local5), isItemSelected(_local3.data), true, (_local5 == caretUID));
                    if (_local4){
                        _local2 = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                        _local2.columnIndex = _local4.x;
                        _local2.rowIndex = _local4.y;
                        _local2.itemRenderer = _local3;
                        dispatchEvent(_local2);
                        lastHighlightItemIndices = _local4;
                        lastHighlightItemRendererAtIndices = _local3;
                    };
                };
            } else {
                if (DragManager.isDragging){
                    return;
                };
                if (((((!((dragScrollingInterval == 0))) && (allowDragSelection))) || (menuSelectionMode))){
                    if (selectItem(_local3, _arg1.shiftKey, _arg1.ctrlKey)){
                        _local2 = new ListEvent(ListEvent.CHANGE);
                        _local2.itemRenderer = _local3;
                        if (_local4){
                            _local2.columnIndex = _local4.x;
                            _local2.rowIndex = _local4.y;
                        };
                        dispatchEvent(_local2);
                    };
                };
            };
        }
        protected function mouseClickHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Point;
            var _local4:ListEvent;
            _local2 = mouseEventToItemRenderer(_arg1);
            if (!_local2){
                return;
            };
            _local3 = itemRendererToIndices(_local2);
            if (_local3){
                _local4 = new ListEvent(ListEvent.ITEM_CLICK);
                _local4.columnIndex = _local3.x;
                _local4.rowIndex = _local3.y;
                _local4.itemRenderer = _local2;
                dispatchEvent(_local4);
            };
        }
        private function selectionIndicesPendingFailureHandler(_arg1:Object, _arg2:ListBaseSelectionDataPending):void{
        }
        protected function finishKeySelection():void{
            var _local1:String;
            var _local5:IListItemRenderer;
            var _local7:Point;
            var _local8:ListEvent;
            var _local2:int = listItems.length;
            var _local3:int = ((listItems.length - offscreenExtraRowsTop) - offscreenExtraRowsBottom);
            var _local4:int = (((rowInfo[((_local2 - offscreenExtraRowsBottom) - 1)].y + rowInfo[((_local2 - offscreenExtraRowsBottom) - 1)].height))>(listContent.heightExcludingOffsets - listContent.topOffset)) ? 1 : 0;
            if (lastKey == Keyboard.PAGE_DOWN){
                if ((_local3 - _local4) == 0){
                    caretIndex = Math.min(((verticalScrollPosition + _local3) - _local4), (collection.length - 1));
                } else {
                    caretIndex = Math.min((((verticalScrollPosition + _local3) - _local4) - 1), (collection.length - 1));
                };
            };
            var _local6:Boolean;
            if (((bSelectItem) && (((caretIndex - verticalScrollPosition) >= 0)))){
                if ((caretIndex - verticalScrollPosition) > Math.max(((_local3 - _local4) - 1), 0)){
                    if ((((lastKey == Keyboard.END)) && ((maxVerticalScrollPosition > verticalScrollPosition)))){
                        caretIndex = (caretIndex - 1);
                        moveSelectionVertically(lastKey, bShiftKey, bCtrlKey);
                        return;
                    };
                    caretIndex = (((_local3 - _local4) - 1) + verticalScrollPosition);
                };
                _local5 = listItems[((caretIndex - verticalScrollPosition) + offscreenExtraRowsTop)][0];
                if (_local5){
                    _local1 = itemToUID(_local5.data);
                    _local5 = UIDToItemRenderer(_local1);
                    if (((!(bCtrlKey)) || ((lastKey == Keyboard.SPACE)))){
                        selectItem(_local5, bShiftKey, bCtrlKey);
                        _local6 = true;
                    };
                    if (bCtrlKey){
                        drawItem(_local5, !((selectedData[_local1] == null)), (_local1 == highlightUID), true);
                    };
                };
            };
            if (_local6){
                _local7 = itemRendererToIndices(_local5);
                _local8 = new ListEvent(ListEvent.CHANGE);
                if (_local7){
                    _local8.columnIndex = _local7.x;
                    _local8.rowIndex = _local7.y;
                };
                _local8.itemRenderer = _local5;
                dispatchEvent(_local8);
            };
        }
        private function selectionDataPendingFailureHandler(_arg1:Object, _arg2:ListBaseSelectionDataPending):void{
        }
        mx_internal function addClipMask(_arg1:Boolean):void{
            var _local10:DisplayObject;
            var _local11:Number;
            if (_arg1){
                if (((((((((((((((horizontalScrollBar) && (horizontalScrollBar.visible))) || (hasOnlyTextRenderers()))) || (runningDataEffect))) || (!((listContent.bottomOffset == 0))))) || (!((listContent.topOffset == 0))))) || (!((listContent.leftOffset == 0))))) || (!((listContent.rightOffset == 0))))){
                    listContent.mask = maskShape;
                    selectionLayer.mask = null;
                } else {
                    listContent.mask = null;
                    selectionLayer.mask = maskShape;
                };
            };
            if (listContent.mask){
                return;
            };
            var _local2:int = (listItems.length - 1);
            var _local3:ListRowInfo = rowInfo[_local2];
            var _local4:Array = listItems[_local2];
            if ((_local3.y + _local3.height) <= listContent.height){
                return;
            };
            var _local5:int = _local4.length;
            var _local6:Number = _local3.y;
            var _local7:Number = listContent.width;
            var _local8:Number = (listContent.height - _local3.y);
            var _local9:int;
            while (_local9 < _local5) {
                _local10 = _local4[_local9];
                _local11 = (_local10.y - _local6);
                if ((_local10 is IUITextField)){
                    _local10.height = (_local8 - _local11);
                } else {
                    _local10.mask = createItemMask(0, (_local6 + _local11), _local7, (_local8 - _local11));
                };
                _local9++;
            };
        }
        public function set allowMultipleSelection(_arg1:Boolean):void{
            _allowMultipleSelection = _arg1;
        }
        protected function scrollVertically(_arg1:int, _arg2:int, _arg3:Boolean):void{
            var i:* = 0;
            var j:* = 0;
            var numRows:* = 0;
            var numCols:* = 0;
            var uid:* = null;
            var curY:* = NaN;
            var cursorPos:* = null;
            var discardRows:* = 0;
            var desiredoffscreenExtraRowsTop:* = 0;
            var newoffscreenExtraRowsTop:* = 0;
            var offscreenExtraRowsBottomToMake:* = 0;
            var newTopOffset:* = NaN;
            var fillHeight:* = NaN;
            var pt:* = null;
            var rowIdx:* = 0;
            var modDeltaPos:* = 0;
            var desiredPrefixItems:* = 0;
            var actual:* = null;
            var row:* = null;
            var rowData:* = null;
            var desiredSuffixItems:* = 0;
            var newOffscreenRows:* = 0;
            var visibleAreaBottomY:* = 0;
            var pos:* = _arg1;
            var deltaPos:* = _arg2;
            var scrollUp:* = _arg3;
            var rowCount:* = rowInfo.length;
            var columnCount:* = listItems[0].length;
            var moveBlockDistance:* = 0;
            var listContentVisibleHeight:* = listContent.heightExcludingOffsets;
            if (scrollUp){
                discardRows = deltaPos;
                desiredoffscreenExtraRowsTop = (offscreenExtraRows / 2);
                newoffscreenExtraRowsTop = Math.min(desiredoffscreenExtraRowsTop, (offscreenExtraRowsTop + deltaPos));
                if (offscreenExtraRowsTop < desiredoffscreenExtraRowsTop){
                    discardRows = Math.max(0, (deltaPos - (desiredoffscreenExtraRowsTop - offscreenExtraRowsTop)));
                };
                moveBlockDistance = sumRowHeights(0, (discardRows - 1));
                i = 0;
                while (i < discardRows) {
                    if (!seekNextSafely(iterator, pos)){
                        return;
                    };
                    i = (i + 1);
                };
                i = 0;
                while (i < rowCount) {
                    numCols = listItems[i].length;
                    if (i < discardRows){
                        destroyRow(i, numCols);
                    } else {
                        if (discardRows > 0){
                            moveRowVertically(i, numCols, -(moveBlockDistance));
                            moveIndicatorsVertically(rowInfo[i].uid, -(moveBlockDistance));
                            shiftRow(i, (i - discardRows), numCols, true);
                            if (listItems[i].length == 0){
                                listItems[(i - discardRows)].splice(0);
                            };
                        };
                    };
                    i = (i + 1);
                };
                if (discardRows){
                    truncateRowArrays((rowCount - discardRows));
                };
                curY = (rowInfo[((rowCount - discardRows) - 1)].y + rowInfo[((rowCount - discardRows) - 1)].height);
                cursorPos = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.CURRENT, (rowCount - discardRows));
                    if (!iteratorValid){
                        iteratorValid = true;
                        lastSeekPending = null;
                    };
                } catch(e1:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(cursorPos, 0);
                    e1.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                };
                offscreenExtraRowsBottomToMake = (offscreenExtraRows / 2);
                newTopOffset = 0;
                i = 0;
                while (i < newoffscreenExtraRowsTop) {
                    newTopOffset = (newTopOffset - rowInfo[i].height);
                    i = (i + 1);
                };
                fillHeight = (listContentVisibleHeight - (curY + newTopOffset));
                if (fillHeight > 0){
                    pt = makeRowsAndColumns(0, curY, listContent.width, (curY + fillHeight), 0, (rowCount - discardRows));
                    rowCount = (rowCount + pt.y);
                } else {
                    rowIdx = ((rowCount - discardRows) - 1);
                    rowIdx = (rowIdx - 1);
                    fillHeight = (fillHeight + rowInfo[rowIdx].height);
                    while (fillHeight < 0) {
                        offscreenExtraRowsBottomToMake = (offscreenExtraRowsBottomToMake - 1);
                        rowIdx = (rowIdx - 1);
                        fillHeight = (fillHeight + rowInfo[rowIdx].height);
                    };
                };
                if (offscreenExtraRowsBottomToMake > 0){
                    if (pt){
                        curY = (rowInfo[((rowCount - discardRows) - 1)].y + rowInfo[((rowCount - discardRows) - 1)].height);
                    };
                    pt = makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, (rowCount - discardRows), true, offscreenExtraRowsBottomToMake);
                } else {
                    pt = new Point(0, 0);
                };
                try {
                    iterator.seek(cursorPos, 0);
                } catch(e2:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(cursorPos, 0);
                    e2.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                };
                offscreenExtraRowsTop = newoffscreenExtraRowsTop;
                offscreenExtraRowsBottom = (((offscreenExtraRows / 2) - offscreenExtraRowsBottomToMake) + pt.y);
            } else {
                curY = 0;
                modDeltaPos = deltaPos;
                desiredPrefixItems = (offscreenExtraRows / 2);
                if (pos < desiredPrefixItems){
                    modDeltaPos = (modDeltaPos - (desiredPrefixItems - pos));
                };
                i = 0;
                while (i < modDeltaPos) {
                    addToRowArrays();
                    i = (i + 1);
                };
                actual = new Point(0, 0);
                if (modDeltaPos > 0){
                    try {
                        iterator.seek(CursorBookmark.CURRENT, -(modDeltaPos));
                        if (!iteratorValid){
                            iteratorValid = true;
                            lastSeekPending = null;
                        };
                    } catch(e3:ItemPendingError) {
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, -(modDeltaPos));
                        e3.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                        iteratorValid = false;
                    };
                    cursorPos = iterator.bookmark;
                    allowRendererStealingDuringLayout = false;
                    actual = makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, 0, true, modDeltaPos);
                    allowRendererStealingDuringLayout = true;
                    try {
                        iterator.seek(cursorPos, 0);
                    } catch(e4:ItemPendingError) {
                        lastSeekPending = new ListBaseSeekPending(cursorPos, 0);
                        e4.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                        iteratorValid = false;
                    };
                };
                if ((((actual.y == 0)) && ((modDeltaPos > 0)))){
                    verticalScrollPosition = 0;
                    restoreRowArrays(modDeltaPos);
                };
                moveBlockDistance = sumRowHeights(0, (actual.y - 1));
                desiredSuffixItems = (offscreenExtraRows / 2);
                newOffscreenRows = 0;
                visibleAreaBottomY = (listContentVisibleHeight + sumRowHeights(0, (Math.min(desiredPrefixItems, pos) - 1)));
                i = actual.y;
                while (i < listItems.length) {
                    row = listItems[i];
                    rowData = rowInfo[i];
                    moveRowVertically(i, listItems[i].length, moveBlockDistance);
                    if (rowData.y >= visibleAreaBottomY){
                        newOffscreenRows = (newOffscreenRows + 1);
                        if (newOffscreenRows > desiredSuffixItems){
                            destroyRow(i, listItems[i].length);
                            removeFromRowArrays(i);
                            i = (i - 1);
                        } else {
                            shiftRow(i, (i + deltaPos), listItems[i].length, false);
                            moveIndicatorsVertically(rowInfo[i].uid, moveBlockDistance);
                        };
                    } else {
                        shiftRow(i, (i + deltaPos), listItems[i].length, false);
                        moveIndicatorsVertically(rowInfo[i].uid, moveBlockDistance);
                    };
                    i = (i + 1);
                };
                rowCount = listItems.length;
                offscreenExtraRowsTop = Math.min(desiredPrefixItems, pos);
                offscreenExtraRowsBottom = Math.min(newOffscreenRows, desiredSuffixItems);
            };
            listContent.topOffset = -(sumRowHeights(0, (offscreenExtraRowsTop - 1)));
            listContent.bottomOffset = (((rowInfo[(rowInfo.length - 1)].y + rowInfo[(rowInfo.length - 1)].height) + listContent.topOffset) - listContentVisibleHeight);
            adjustListContent(oldUnscaledWidth, oldUnscaledHeight);
            addClipMask(true);
        }
        protected function selectItem(_arg1:IListItemRenderer, _arg2:Boolean, _arg3:Boolean, _arg4:Boolean=true):Boolean{
            var placeHolder:* = null;
            var index:* = 0;
            var numSelected:* = 0;
            var curSelectionData:* = null;
            var oldAnchorBookmark:* = null;
            var oldAnchorIndex:* = 0;
            var incr:* = false;
            var item:* = _arg1;
            var shiftKey:* = _arg2;
            var ctrlKey:* = _arg3;
            var transition:Boolean = _arg4;
            if (((!(item)) || (!(isItemSelectable(item.data))))){
                return (false);
            };
            var selectionChange:* = false;
            placeHolder = iterator.bookmark;
            index = itemRendererToIndex(item);
            var uid:* = itemToUID(item.data);
            if (((!(allowMultipleSelection)) || (((!(shiftKey)) && (!(ctrlKey)))))){
                numSelected = 0;
                if (allowMultipleSelection){
                    curSelectionData = firstSelectionData;
                    if (curSelectionData != null){
                        numSelected = (numSelected + 1);
                        if (curSelectionData.nextSelectionData){
                            numSelected = (numSelected + 1);
                        };
                    };
                };
                if (((ctrlKey) && (selectedData[uid]))){
                    selectionChange = true;
                    clearSelected(transition);
                } else {
                    if (((((!((_selectedIndex == index))) || (bSelectedIndexChanged))) || (((allowMultipleSelection) && (!((numSelected == 1))))))){
                        selectionChange = true;
                        clearSelected(transition);
                        insertSelectionDataBefore(uid, new ListBaseSelectionData(item.data, index, approximate), firstSelectionData);
                        drawItem(UIDToItemRenderer(uid), true, (uid == highlightUID), true, transition);
                        _selectedIndex = index;
                        _selectedItem = item.data;
                        iterator.seek(CursorBookmark.CURRENT, (_selectedIndex - indicesToIndex((verticalScrollPosition - offscreenExtraRowsTop), (horizontalScrollPosition - offscreenExtraColumnsLeft))));
                        caretIndex = _selectedIndex;
                        caretBookmark = iterator.bookmark;
                        anchorIndex = _selectedIndex;
                        anchorBookmark = iterator.bookmark;
                        iterator.seek(placeHolder, 0);
                    };
                };
            } else {
                if (((shiftKey) && (allowMultipleSelection))){
                    if (anchorBookmark){
                        oldAnchorBookmark = anchorBookmark;
                        oldAnchorIndex = anchorIndex;
                        incr = (anchorIndex < index);
                        clearSelected(false);
                        caretIndex = index;
                        caretBookmark = iterator.bookmark;
                        anchorIndex = oldAnchorIndex;
                        anchorBookmark = oldAnchorBookmark;
                        _selectedIndex = index;
                        _selectedItem = item.data;
                        try {
                            iterator.seek(anchorBookmark, 0);
                        } catch(e:ItemPendingError) {
                            e.addResponder(new ItemResponder(selectionPendingResultHandler, selectionPendingFailureHandler, new ListBaseSelectionPending(incr, index, item.data, transition, placeHolder, CursorBookmark.CURRENT, 0)));
                            iteratorValid = false;
                        };
                        shiftSelectionLoop(incr, anchorIndex, item.data, transition, placeHolder);
                    };
                    selectionChange = true;
                } else {
                    if (((ctrlKey) && (allowMultipleSelection))){
                        if (selectedData[uid]){
                            removeSelectionData(uid);
                            drawItem(UIDToItemRenderer(uid), false, (uid == highlightUID), true, transition);
                            if (item.data == selectedItem){
                                calculateSelectedIndexAndItem();
                            };
                        } else {
                            insertSelectionDataBefore(uid, new ListBaseSelectionData(item.data, index, approximate), firstSelectionData);
                            drawItem(UIDToItemRenderer(uid), true, (uid == highlightUID), true, transition);
                            _selectedIndex = index;
                            _selectedItem = item.data;
                        };
                        iterator.seek(CursorBookmark.CURRENT, (index - indicesToIndex(verticalScrollPosition, horizontalScrollPosition)));
                        caretIndex = index;
                        caretBookmark = iterator.bookmark;
                        anchorIndex = index;
                        anchorBookmark = iterator.bookmark;
                        iterator.seek(placeHolder, 0);
                        selectionChange = true;
                    };
                };
            };
            return (selectionChange);
        }
        mx_internal function selectionTween_updateHandler(_arg1:TweenEvent):void{
            Sprite(_arg1.target.listener).alpha = Number(_arg1.value);
        }
        protected function prepareDataEffect(_arg1:CollectionEvent):void{
            var _local2:Object;
            var _local3:Class;
            var _local4:int;
            var _local5:int;
            if (!cachedItemsChangeEffect){
                _local2 = getStyle("itemsChangeEffect");
                _local3 = (_local2 as Class);
                if (_local3){
                    _local2 = new (_local3)();
                };
                cachedItemsChangeEffect = (_local2 as IEffect);
            };
            if (runningDataEffect){
                collection = actualCollection;
                listContent.iterator = (iterator = actualIterator);
                cachedItemsChangeEffect.end();
                modifiedCollectionView = null;
            };
            if (((cachedItemsChangeEffect) && (iteratorValid))){
                _local4 = iterator.bookmark.getViewIndex();
                _local5 = ((_local4 + (rowCount * columnCount)) - 1);
                if (((!(modifiedCollectionView)) && ((collection is IList)))){
                    modifiedCollectionView = new ModifiedCollectionView(ICollectionView(collection));
                };
                if (modifiedCollectionView){
                    modifiedCollectionView.processCollectionEvent(_arg1, _local4, _local5);
                    runDataEffectNextUpdate = true;
                    if (invalidateDisplayListFlag){
                        callLater(invalidateList);
                    } else {
                        invalidateList();
                    };
                };
            };
        }
        protected function drawSelectionIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            var _local8:Graphics = Sprite(_arg1).graphics;
            _local8.clear();
            _local8.beginFill(_arg6);
            _local8.drawRect(0, 0, _arg4, _arg5);
            _local8.endFill();
            _arg1.x = _arg2;
            _arg1.y = _arg3;
        }
        mx_internal function setColumnWidth(_arg1:Number):void{
            _columnWidth = _arg1;
        }
        protected function makeRowsAndColumns(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int, _arg6:int, _arg7:Boolean=false, _arg8:uint=0):Point{
            return (new Point(0, 0));
        }
        public function isItemVisible(_arg1:Object):Boolean{
            return (!((itemToItemRenderer(_arg1) == null)));
        }
        mx_internal function commitSelectedIndices(_arg1:Array):void{
            var indices:* = _arg1;
            clearSelected();
            try {
                collectionIterator.seek(CursorBookmark.FIRST, 0);
            } catch(e:ItemPendingError) {
                e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler, selectionIndicesPendingFailureHandler, new ListBaseSelectionDataPending(true, 0, indices, CursorBookmark.FIRST, 0)));
                return;
            };
            setSelectionIndicesLoop(0, indices, true);
        }
        public function calculateDropIndex(_arg1:DragEvent=null):int{
            var _local2:IListItemRenderer;
            var _local3:IListItemRenderer;
            var _local4:Point;
            var _local5:int;
            var _local6:int;
            if (_arg1){
                _local4 = new Point(_arg1.localX, _arg1.localY);
                _local4 = DisplayObject(_arg1.target).localToGlobal(_local4);
                _local4 = listContent.globalToLocal(_local4);
                _local5 = listItems.length;
                _local6 = 0;
                while (_local6 < _local5) {
                    if (listItems[_local6][0]){
                        _local3 = listItems[_local6][0];
                    };
                    if ((((rowInfo[_local6].y <= _local4.y)) && ((_local4.y < (rowInfo[_local6].y + rowInfo[_local6].height))))){
                        _local2 = listItems[_local6][0];
                        break;
                    };
                    _local6++;
                };
                if (_local2){
                    lastDropIndex = itemRendererToIndex(_local2);
                } else {
                    if (_local3){
                        lastDropIndex = (itemRendererToIndex(_local3) + 1);
                    } else {
                        lastDropIndex = ((collection) ? collection.length : 0);
                    };
                };
            };
            return (lastDropIndex);
        }
        protected function mouseDownHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Point;
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            if (runningDataEffect){
                cachedItemsChangeEffect.end();
                dataEffectCompleted = true;
                itemsSizeChanged = true;
                invalidateList();
                dataItemWrappersByRenderer = new Dictionary();
                validateDisplayList();
            };
            isPressed = true;
            _local2 = mouseEventToItemRenderer(_arg1);
            if (!_local2){
                return;
            };
            bSelectOnRelease = false;
            _local3 = new Point(_arg1.localX, _arg1.localY);
            _local3 = DisplayObject(_arg1.target).localToGlobal(_local3);
            mouseDownPoint = globalToLocal(_local3);
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true, 0, true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler, false, 0, true);
            if (!dragEnabled){
                dragScrollingInterval = setInterval(dragScroll, 15);
            };
            if (((dragEnabled) && (selectedData[rowMap[_local2.name].uid]))){
                bSelectOnRelease = true;
            } else {
                if (selectItem(_local2, _arg1.shiftKey, _arg1.ctrlKey)){
                    mouseDownItem = _local2;
                };
            };
        }
        public function get labelField():String{
            return (_labelField);
        }
        private function onSelectionTweenUpdate(_arg1:Number):void{
        }
        protected function clearIndicators():void{
            var _local1:String;
            for (_local1 in selectionTweens) {
                removeIndicators(_local1);
            };
            while (selectionLayer.numChildren > 0) {
                selectionLayer.removeChildAt(0);
            };
            selectionTweens = {};
            selectionIndicators = {};
            highlightIndicator = null;
            highlightUID = null;
            caretIndicator = null;
            caretUID = null;
        }
        public function get offscreenExtraRowsOrColumns():int{
            return (_offscreenExtraRowsOrColumns);
        }
        public function get wordWrap():Boolean{
            return (_wordWrap);
        }
        protected function drawItem(_arg1:IListItemRenderer, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:Boolean=false, _arg5:Boolean=false):void{
            var _local6:Sprite;
            var _local7:Graphics;
            var _local12:Number;
            if (!_arg1){
                return;
            };
            var _local8:ListBaseContentHolder = (DisplayObject(_arg1).parent as ListBaseContentHolder);
            if (!_local8){
                return;
            };
            var _local9:Array = _local8.rowInfo;
            var _local10:Sprite = _local8.selectionLayer;
            var _local11:BaseListData = rowMap[_arg1.name];
            if (!_local11){
                return;
            };
            if (((_arg3) && (((!(highlightItemRenderer)) || (!((highlightUID == _local11.uid))))))){
                if (!highlightIndicator){
                    _local6 = new SpriteAsset();
                    _local10.addChild(DisplayObject(_local6));
                    highlightIndicator = _local6;
                } else {
                    if (highlightIndicator.parent != _local10){
                        _local10.addChild(highlightIndicator);
                    } else {
                        _local10.setChildIndex(DisplayObject(highlightIndicator), (_local10.numChildren - 1));
                    };
                };
                _local6 = highlightIndicator;
                drawHighlightIndicator(_local6, _arg1.x, _local9[_local11.rowIndex].y, _arg1.width, _local9[_local11.rowIndex].height, getStyle("rollOverColor"), _arg1);
                lastHighlightItemRenderer = (highlightItemRenderer = _arg1);
                highlightUID = _local11.uid;
            } else {
                if (((((!(_arg3)) && (highlightItemRenderer))) && (((_local11) && ((highlightUID == _local11.uid)))))){
                    clearHighlightIndicator(highlightIndicator, _arg1);
                    highlightItemRenderer = null;
                    highlightUID = null;
                };
            };
            if (_arg2){
                _local12 = ((runningDataEffect) ? (_arg1.y - cachedPaddingTop) : _local9[_local11.rowIndex].y);
                if (!selectionIndicators[_local11.uid]){
                    _local6 = new SpriteAsset();
                    _local6.mouseEnabled = false;
                    _local10.addChild(DisplayObject(_local6));
                    selectionIndicators[_local11.uid] = _local6;
                    drawSelectionIndicator(_local6, _arg1.x, _local12, _arg1.width, _local9[_local11.rowIndex].height, ((enabled) ? getStyle("selectionColor") : getStyle("selectionDisabledColor")), _arg1);
                    if (_arg5){
                        applySelectionEffect(_local6, _local11.uid, _arg1);
                    };
                } else {
                    _local6 = selectionIndicators[_local11.uid];
                    drawSelectionIndicator(_local6, _arg1.x, _local12, _arg1.width, _local9[_local11.rowIndex].height, ((enabled) ? getStyle("selectionColor") : getStyle("selectionDisabledColor")), _arg1);
                };
            } else {
                if (!_arg2){
                    if (((_local11) && (selectionIndicators[_local11.uid]))){
                        if (selectionTweens[_local11.uid]){
                            selectionTweens[_local11.uid].removeEventListener(TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);
                            selectionTweens[_local11.uid].removeEventListener(TweenEvent.TWEEN_END, selectionTween_endHandler);
                            if (selectionIndicators[_local11.uid].alpha < 1){
                                Tween.removeTween(selectionTweens[_local11.uid]);
                            };
                            delete selectionTweens[_local11.uid];
                        };
                        _local10.removeChild(selectionIndicators[_local11.uid]);
                        delete selectionIndicators[_local11.uid];
                    };
                };
            };
            if (_arg4){
                if (showCaret){
                    if (!caretIndicator){
                        _local6 = new SpriteAsset();
                        _local6.mouseEnabled = false;
                        _local10.addChild(DisplayObject(_local6));
                        caretIndicator = _local6;
                    } else {
                        if (caretIndicator.parent != _local10){
                            _local10.addChild(caretIndicator);
                        } else {
                            _local10.setChildIndex(DisplayObject(caretIndicator), (_local10.numChildren - 1));
                        };
                    };
                    _local6 = caretIndicator;
                    drawCaretIndicator(_local6, _arg1.x, _local9[_local11.rowIndex].y, _arg1.width, _local9[_local11.rowIndex].height, getStyle("selectionColor"), _arg1);
                    caretItemRenderer = _arg1;
                    caretUID = _local11.uid;
                };
            } else {
                if (((((!(_arg4)) && (caretItemRenderer))) && ((caretUID == _local11.uid)))){
                    clearCaretIndicator(caretIndicator, _arg1);
                    caretItemRenderer = null;
                    caretUID = "";
                };
            };
            if ((_arg1 is IFlexDisplayObject)){
                if ((_arg1 is IInvalidating)){
                    IInvalidating(_arg1).invalidateDisplayList();
                    IInvalidating(_arg1).validateNow();
                };
            } else {
                if ((_arg1 is IUITextField)){
                    IUITextField(_arg1).validateNow();
                };
            };
        }
        protected function dragExitHandler(_arg1:DragEvent):void{
            if (_arg1.isDefaultPrevented()){
                return;
            };
            lastDragEvent = null;
            hideDropFeedback(_arg1);
            resetDragScrolling();
            DragManager.showFeedback(DragManager.NONE);
        }
        protected function adjustAfterRemove(_arg1:Array, _arg2:int, _arg3:Boolean):Boolean{
            var data:* = null;
            var requiresValueCommit:* = false;
            var i:* = 0;
            var length:* = 0;
            var placeHolder:* = null;
            var s:* = null;
            var items:* = _arg1;
            var location:* = _arg2;
            var emitEvent:* = _arg3;
            requiresValueCommit = emitEvent;
            i = 0;
            length = items.length;
            for (s in selectedData) {
                i = (i + 1);
                data = selectedData[s];
                if (data.index > location){
                    data.index = (data.index - length);
                };
            };
            if (_selectedIndex > location){
                _selectedIndex = (_selectedIndex - length);
                requiresValueCommit = true;
            };
            if ((((i > 0)) && ((_selectedIndex == -1)))){
                _selectedIndex = data.index;
                _selectedItem = data.data;
                requiresValueCommit = true;
            };
            if (i == 0){
                _selectedIndex = -1;
                bSelectionChanged = true;
                bSelectedIndexChanged = true;
                invalidateDisplayList();
            };
            if (anchorIndex > location){
                anchorIndex = (anchorIndex - length);
                placeHolder = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.FIRST, anchorIndex);
                    anchorBookmark = iterator.bookmark;
                } catch(e:ItemPendingError) {
                    e.addResponder(new ItemResponder(setBookmarkPendingResultHandler, setBookmarkPendingFailureHandler, {
                        property:"anchorBookmark",
                        value:anchorIndex
                    }));
                };
                iterator.seek(placeHolder);
            };
            if (caretIndex > location){
                caretIndex = (caretIndex - length);
                placeHolder = iterator.bookmark;
                try {
                    iterator.seek(CursorBookmark.FIRST, caretIndex);
                    caretBookmark = iterator.bookmark;
                } catch(e:ItemPendingError) {
                    e.addResponder(new ItemResponder(setBookmarkPendingResultHandler, setBookmarkPendingFailureHandler, {
                        property:"caretBookmark",
                        value:caretIndex
                    }));
                };
                iterator.seek(placeHolder);
            };
            return (requiresValueCommit);
        }
        public function itemToIcon(_arg1:Object):Class{
            var iconClass:* = null;
            var icon:* = undefined;
            var data:* = _arg1;
            if (data == null){
                return (null);
            };
            if (iconFunction != null){
                return (iconFunction(data));
            };
            if ((data is XML)){
                try {
                    if (data[iconField].length() != 0){
                        icon = String(data[iconField]);
                        if (icon != null){
                            iconClass = Class(systemManager.getDefinitionByName(icon));
                            if (iconClass){
                                return (iconClass);
                            };
                            return (document[icon]);
                        };
                    };
                } catch(e:Error) {
                };
            } else {
                if ((data is Object)){
                    try {
                        if (data[iconField] != null){
                            if ((data[iconField] is Class)){
                                return (data[iconField]);
                            };
                            if ((data[iconField] is String)){
                                iconClass = Class(systemManager.getDefinitionByName(data[iconField]));
                                if (iconClass){
                                    return (iconClass);
                                };
                                return (document[data[iconField]]);
                            };
                        };
                    } catch(e:Error) {
                    };
                };
            };
            return (null);
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            var _local2:IFlexDisplayObject = (border as IFlexDisplayObject);
            if (_local2){
                if ((_local2 is IUIComponent)){
                    IUIComponent(_local2).enabled = _arg1;
                };
                if ((_local2 is IInvalidating)){
                    IInvalidating(_local2).invalidateDisplayList();
                };
            };
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        public function addDataEffectItem(_arg1:Object):void{
            if (modifiedCollectionView){
                modifiedCollectionView.addItem(dataItemWrappersByRenderer[_arg1]);
            };
            if (iterator.afterLast){
                iterator.seek(CursorBookmark.FIRST);
            } else {
                iterator.seek(CursorBookmark.CURRENT);
            };
            if (invalidateDisplayListFlag){
                callLater(invalidateList);
            } else {
                invalidateList();
            };
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                return (super.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            var _local1 = (dataProvider == null);
            var _local2:Boolean = ((!((dataProvider == null))) && ((dataProvider.length == 0)));
            if (((_local1) || (_local2))){
                dataProvider = [null];
                validateNow();
            };
            if (((!(listItems)) || ((listItems.length == 0)))){
                return (super.baselinePosition);
            };
            var _local3:IUIComponent = (listItems[0][0] as IUIComponent);
            if (!_local3){
                return (super.baselinePosition);
            };
            var _local4:ListBaseContentHolder = ListBaseContentHolder(_local3.parent);
            var _local5:Number = ((_local4.y + _local3.y) + _local3.baselinePosition);
            if (((_local1) || (_local2))){
                if (_local1){
                    dataProvider = null;
                } else {
                    if (_local2){
                        dataProvider = [];
                    };
                };
                validateNow();
            };
            return (_local5);
        }
        private function makeRowsAndColumnsWithExtraRows(_arg1:Number, _arg2:Number):void{
            var _local3:ListRowInfo;
            var _local4:ListRowInfo;
            var _local5:ListRowInfo;
            var _local6:int;
            var _local7:Point;
            var _local14:int;
            var _local15:int;
            var _local16:int;
            var _local8:int = (offscreenExtraRows / 2);
            var _local9:int = (offscreenExtraRows / 2);
            offscreenExtraRowsTop = Math.min(_local8, verticalScrollPosition);
            var _local10:int = scrollPositionToIndex(horizontalScrollPosition, (verticalScrollPosition - offscreenExtraRowsTop));
            seekPositionSafely(_local10);
            var _local11:CursorBookmark = iterator.bookmark;
            if (offscreenExtraRowsTop > 0){
                makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0, true, offscreenExtraRowsTop);
            };
            var _local12:Number = ((offscreenExtraRowsTop) ? (rowInfo[(offscreenExtraRowsTop - 1)].y + rowHeight) : 0);
            _local7 = makeRowsAndColumns(0, _local12, listContent.width, (_local12 + listContent.heightExcludingOffsets), 0, offscreenExtraRowsTop);
            if ((((_local9 > 0)) && (!(iterator.afterLast)))){
                if (((offscreenExtraRowsTop + _local7.y) - 1) < 0){
                    _local12 = 0;
                } else {
                    _local12 = (rowInfo[((offscreenExtraRowsTop + _local7.y) - 1)].y + rowInfo[((offscreenExtraRowsTop + _local7.y) - 1)].height);
                };
                _local14 = listItems.length;
                _local7 = makeRowsAndColumns(0, _local12, listContent.width, _local12, 0, (offscreenExtraRowsTop + _local7.y), true, _local9);
                if (_local7.y == _local9){
                    while ((((((_local7.y > 0)) && (listItems[(listItems.length - 1)]))) && ((listItems[(listItems.length - 1)].length == 0)))) {
                        _local7.y--;
                        listItems.pop();
                        rowInfo.pop();
                    };
                } else {
                    if (_local7.y < _local9){
                        _local15 = (listItems.length - (_local14 + _local7.y));
                        if (_local15){
                            _local16 = 0;
                            while (_local16 < _local15) {
                                listItems.pop();
                                rowInfo.pop();
                                _local16++;
                            };
                        };
                    };
                };
                offscreenExtraRowsBottom = _local7.y;
            } else {
                offscreenExtraRowsBottom = 0;
            };
            var _local13:Number = listContent.heightExcludingOffsets;
            listContent.topOffset = (-(offscreenExtraRowsTop) * rowHeight);
            listContent.bottomOffset = ((offscreenExtraRowsBottom)>0) ? (((listItems[(listItems.length - 1)][0].y + rowHeight) - _local13) + listContent.topOffset) : 0;
            if (iteratorValid){
                iterator.seek(_local11, 0);
            };
            adjustListContent(_arg1, _arg2);
        }
        mx_internal function indicesToItemRenderer(_arg1:int, _arg2:int):IListItemRenderer{
            return (listItems[_arg1][_arg2]);
        }
        mx_internal function getItemRendererForMouseEvent(_arg1:MouseEvent):IListItemRenderer{
            return (mouseEventToItemRenderer(_arg1));
        }
        mx_internal function set $verticalScrollPosition(_arg1:Number):void{
            var _local2:int = super.verticalScrollPosition;
            if (_local2 != _arg1){
                super.verticalScrollPosition = _arg1;
            };
        }
        protected function mouseOutHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            if (((!(enabled)) || (!(selectable)))){
                return;
            };
            isPressed = _arg1.buttonDown;
            _local2 = mouseEventToItemRenderer(_arg1);
            if (!_local2){
                return;
            };
            if (!isPressed){
                if (((((((itemRendererContains(_local2, _arg1.relatedObject)) || ((_arg1.relatedObject == listContent)))) || ((_arg1.relatedObject == highlightIndicator)))) || (!(highlightItemRenderer)))){
                    return;
                };
                if (((getStyle("useRollOver")) && (!((_local2.data == null))))){
                    clearHighlight(_local2);
                };
            };
        }
        public function set dropEnabled(_arg1:Boolean):void{
            if (((_dropEnabled) && (!(_arg1)))){
                removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false);
                removeEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false);
                removeEventListener(DragEvent.DRAG_OVER, dragOverHandler, false);
                removeEventListener(DragEvent.DRAG_DROP, dragDropHandler, false);
            };
            _dropEnabled = _arg1;
            if (_arg1){
                addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false, EventPriority.DEFAULT_HANDLER);
                addEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false, EventPriority.DEFAULT_HANDLER);
                addEventListener(DragEvent.DRAG_OVER, dragOverHandler, false, EventPriority.DEFAULT_HANDLER);
                addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, EventPriority.DEFAULT_HANDLER);
            };
        }
        protected function get listContentStyleFilters():Object{
            return (_listContentStyleFilters);
        }
        public function itemToLabel(_arg1:Object):String{
            var data:* = _arg1;
            if (data == null){
                return (" ");
            };
            if (labelFunction != null){
                return (labelFunction(data));
            };
            if ((data is XML)){
                try {
                    if (data[labelField].length() != 0){
                        data = data[labelField];
                    };
                } catch(e:Error) {
                };
            } else {
                if ((data is Object)){
                    try {
                        if (data[labelField] != null){
                            data = data[labelField];
                        };
                    } catch(e:Error) {
                    };
                };
            };
            if ((data is String)){
                return (String(data));
            };
            try {
                return (data.toString());
            } catch(e:Error) {
            };
            return (" ");
        }
        public function set rowCount(_arg1:int):void{
            explicitRowCount = _arg1;
            if (_rowCount != _arg1){
                setRowCount(_arg1);
                rowCountChanged = true;
                invalidateProperties();
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                dispatchEvent(new Event("rowCountChanged"));
            };
        }
        public function set columnCount(_arg1:int):void{
            explicitColumnCount = _arg1;
            if (_columnCount != _arg1){
                setColumnCount(_arg1);
                columnCountChanged = true;
                invalidateProperties();
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                dispatchEvent(new Event("columnCountChanged"));
            };
        }
        private function partialPurgeItemRenderers():void{
            var _local1:*;
            var _local2:String;
            var _local3:DisplayObject;
            var _local4:Dictionary;
            var _local5:*;
            dataEffectCompleted = false;
            while (freeItemRenderers.length) {
                _local3 = DisplayObject(freeItemRenderers.pop());
                if (_local3.parent){
                    listContent.removeChild(_local3);
                };
            };
            for (_local1 in freeItemRenderersByFactory) {
                _local4 = freeItemRenderersByFactory[_local1];
                for (_local5 in _local4) {
                    _local3 = DisplayObject(_local5);
                    delete _local4[_local5];
                    if (_local3.parent){
                        listContent.removeChild(_local3);
                    };
                };
            };
            for (_local2 in reservedItemRenderers) {
                _local3 = DisplayObject(reservedItemRenderers[_local2]);
                if (_local3.parent){
                    listContent.removeChild(_local3);
                };
            };
            reservedItemRenderers = {};
            rowMap = {};
            clearVisibleData();
        }
        protected function seekPendingResultHandler(_arg1:Object, _arg2:ListBaseSeekPending):void{
            var data:* = _arg1;
            var info:* = _arg2;
            if (info != lastSeekPending){
                return;
            };
            lastSeekPending = null;
            iteratorValid = true;
            try {
                iterator.seek(info.bookmark, info.offset);
            } catch(e:ItemPendingError) {
                lastSeekPending = new ListBaseSeekPending(info.bookmark, info.offset);
                e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                iteratorValid = false;
            };
            if (bSortItemPending){
                bSortItemPending = false;
                adjustAfterSort();
            };
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        mx_internal function mouseEventToItemRendererOrEditor(_arg1:MouseEvent):IListItemRenderer{
            var _local3:Point;
            var _local4:Number;
            var _local5:int;
            var _local6:int;
            var _local7:int;
            var _local8:int;
            var _local2:DisplayObject = DisplayObject(_arg1.target);
            if (_local2 == listContent){
                _local3 = new Point(_arg1.stageX, _arg1.stageY);
                _local3 = listContent.globalToLocal(_local3);
                _local4 = 0;
                _local5 = listItems.length;
                _local6 = 0;
                while (_local6 < _local5) {
                    if (listItems[_local6].length){
                        if (_local3.y < (_local4 + rowInfo[_local6].height)){
                            _local7 = listItems[_local6].length;
                            if (_local7 == 1){
                                return (listItems[_local6][0]);
                            };
                            _local8 = Math.floor((_local3.x / columnWidth));
                            return (listItems[_local6][_local8]);
                        };
                    };
                    _local4 = (_local4 + rowInfo[_local6].height);
                    _local6++;
                };
            } else {
                if (_local2 == highlightIndicator){
                    return (lastHighlightItemRenderer);
                };
            };
            while (((_local2) && (!((_local2 == this))))) {
                if ((((_local2 is IListItemRenderer)) && ((_local2.parent == listContent)))){
                    if (_local2.visible){
                        return (IListItemRenderer(_local2));
                    };
                    break;
                };
                if ((_local2 is IUIComponent)){
                    _local2 = IUIComponent(_local2).owner;
                } else {
                    _local2 = _local2.parent;
                };
            };
            return (null);
        }
        protected function configureScrollBars():void{
        }
        protected function clearVisibleData():void{
            listContent.visibleData = {};
        }
        private function insertSelectionDataAfter(_arg1:String, _arg2:ListBaseSelectionData, _arg3:ListBaseSelectionData):void{
            if (_arg3 == null){
                firstSelectionData = (lastSelectionData = _arg2);
            } else {
                if (_arg3 == lastSelectionData){
                    lastSelectionData = _arg2;
                };
                _arg2.prevSelectionData = _arg3;
                _arg2.nextSelectionData = _arg3.nextSelectionData;
                _arg3.nextSelectionData = _arg2;
            };
            selectedData[_arg1] = _arg2;
        }
        protected function moveSelectionVertically(_arg1:uint, _arg2:Boolean, _arg3:Boolean):void{
            var _local4:Number;
            var _local5:IListItemRenderer;
            var _local6:String;
            var _local7:int;
            var _local13:ScrollEvent;
            var _local8:Boolean;
            showCaret = true;
            var _local9:int = listItems.length;
            var _local10:int = ((listItems.length - offscreenExtraRowsTop) - offscreenExtraRowsBottom);
            var _local11:int = (((rowInfo[((_local9 - offscreenExtraRowsBottom) - 1)].y + rowInfo[((_local9 - offscreenExtraRowsBottom) - 1)].height))>(listContent.heightExcludingOffsets - listContent.topOffset)) ? 1 : 0;
            var _local12:Boolean;
            bSelectItem = false;
            switch (_arg1){
                case Keyboard.UP:
                    if (caretIndex > 0){
                        caretIndex--;
                        _local12 = true;
                        bSelectItem = true;
                    };
                    break;
                case Keyboard.DOWN:
                    if (caretIndex < (collection.length - 1)){
                        caretIndex++;
                        _local12 = true;
                        bSelectItem = true;
                    } else {
                        if ((((caretIndex == (collection.length - 1))) && (_local11))){
                            if (verticalScrollPosition < maxVerticalScrollPosition){
                                _local4 = (verticalScrollPosition + 1);
                            };
                        };
                    };
                    break;
                case Keyboard.PAGE_UP:
                    if ((((caretIndex > verticalScrollPosition)) && ((caretIndex < (verticalScrollPosition + _local10))))){
                        caretIndex = verticalScrollPosition;
                    } else {
                        caretIndex = Math.max((caretIndex - Math.max((_local10 - _local11), 1)), 0);
                        _local4 = Math.max(caretIndex, 0);
                    };
                    bSelectItem = true;
                    break;
                case Keyboard.PAGE_DOWN:
                    if ((((caretIndex >= verticalScrollPosition)) && ((caretIndex < (((verticalScrollPosition + _local10) - _local11) - 1))))){
                    } else {
                        if ((((caretIndex == verticalScrollPosition)) && (((_local10 - _local11) <= 1)))){
                            caretIndex++;
                        };
                        _local4 = Math.max(Math.min(caretIndex, maxVerticalScrollPosition), 0);
                    };
                    bSelectItem = true;
                    break;
                case Keyboard.HOME:
                    if (caretIndex > 0){
                        caretIndex = 0;
                        bSelectItem = true;
                        _local4 = 0;
                    };
                    break;
                case Keyboard.END:
                    if (caretIndex < (collection.length - 1)){
                        caretIndex = (collection.length - 1);
                        bSelectItem = true;
                        _local4 = maxVerticalScrollPosition;
                    };
                    break;
            };
            if (_local12){
                if (caretIndex >= ((verticalScrollPosition + _local10) - _local11)){
                    if ((_local10 - _local11) == 0){
                        _local4 = Math.min(maxVerticalScrollPosition, caretIndex);
                    } else {
                        _local4 = Math.min(maxVerticalScrollPosition, (((caretIndex - _local10) + _local11) + 1));
                    };
                } else {
                    if (caretIndex < verticalScrollPosition){
                        _local4 = Math.max(caretIndex, 0);
                    };
                };
            };
            if (!isNaN(_local4)){
                if (verticalScrollPosition != _local4){
                    _local13 = new ScrollEvent(ScrollEvent.SCROLL);
                    _local13.detail = ScrollEventDetail.THUMB_POSITION;
                    _local13.direction = ScrollEventDirection.VERTICAL;
                    _local13.delta = (_local4 - verticalScrollPosition);
                    _local13.position = _local4;
                    verticalScrollPosition = _local4;
                    dispatchEvent(_local13);
                };
                if (!iteratorValid){
                    keySelectionPending = true;
                    return;
                };
            };
            bShiftKey = _arg2;
            bCtrlKey = _arg3;
            lastKey = _arg1;
            finishKeySelection();
        }
        protected function getReservedOrFreeItemRenderer(_arg1:Object):IListItemRenderer{
            var _local2:IListItemRenderer;
            var _local3:String;
            var _local4:IFactory;
            var _local5:Dictionary;
            var _local6:*;
            if (runningDataEffect){
                _local3 = itemToUID(_arg1);
                _local2 = IListItemRenderer(reservedItemRenderers[_local3]);
            };
            if (_local2){
                delete reservedItemRenderers[_local3];
            } else {
                _local4 = getItemRendererFactory(_arg1);
                if (freeItemRenderersByFactory){
                    if (_local4 == itemRenderer){
                        if (freeItemRenderers.length){
                            _local2 = freeItemRenderers.pop();
                            delete freeItemRenderersByFactory[_local4][_local2];
                        };
                    } else {
                        _local5 = freeItemRenderersByFactory[_local4];
                        if (_local5){
                            for (_local6 in _local5) {
                                _local2 = _local6;
                                delete freeItemRenderersByFactory[_local4][_local2];
                                break;
                            };
                        };
                    };
                };
            };
            return (_local2);
        }
        protected function addDragData(_arg1:Object):void{
            _arg1.addHandler(copySelectedItems, "items");
        }
        private function adjustAfterSort():void{
            var p:* = null;
            var index:* = 0;
            var newVerticalScrollPosition:* = 0;
            var newHorizontalScrollPosition:* = 0;
            var pos:* = 0;
            var data:* = null;
            var i:* = 0;
            for (p in selectedData) {
                i = (i + 1);
            };
            index = ((anchorBookmark) ? anchorBookmark.getViewIndex() : -1);
            if (index >= 0){
                if (i == 1){
                    _selectedIndex = (anchorIndex = (caretIndex = index));
                    data = selectedData[p];
                    data.index = index;
                };
                newVerticalScrollPosition = indexToRow(index);
                if (newVerticalScrollPosition == -1){
                    return;
                };
                newVerticalScrollPosition = Math.min(maxVerticalScrollPosition, newVerticalScrollPosition);
                newHorizontalScrollPosition = indexToColumn(index);
                if (newHorizontalScrollPosition == -1){
                    return;
                };
                newHorizontalScrollPosition = Math.min(maxHorizontalScrollPosition, newHorizontalScrollPosition);
                pos = scrollPositionToIndex(newHorizontalScrollPosition, newVerticalScrollPosition);
                try {
                    iterator.seek(CursorBookmark.CURRENT, (pos - index));
                    if (!iteratorValid){
                        iteratorValid = true;
                        lastSeekPending = null;
                    };
                } catch(e:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, (pos - index));
                    e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                    return;
                };
                super.verticalScrollPosition = newVerticalScrollPosition;
                if (listType != "vertical"){
                    super.horizontalScrollPosition = newHorizontalScrollPosition;
                };
            } else {
                try {
                    index = scrollPositionToIndex(horizontalScrollPosition, (verticalScrollPosition - offscreenExtraRowsTop));
                    iterator.seek(CursorBookmark.FIRST, index);
                    if (!iteratorValid){
                        iteratorValid = true;
                        lastSeekPending = null;
                    };
                } catch(e:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, index);
                    e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                    return;
                };
            };
            if (i > 1){
                commitSelectedItems(selectedItems);
            };
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        private function initiateSelectionTracking(_arg1:Array):void{
            var _local3:IListItemRenderer;
            var _local2:int;
            while (_local2 < _arg1.length) {
                _local3 = (_arg1[_local2] as IListItemRenderer);
                if (selectedData[itemToUID(_local3.data)]){
                    _local3.addEventListener(MoveEvent.MOVE, rendererMoveHandler);
                    trackedRenderers.push(_local3);
                };
                _local2++;
            };
        }
        private function setSelectionDataLoop(_arg1:Array, _arg2:int, _arg3:Boolean=true):void{
            var uid:* = null;
            var item:* = null;
            var bookmark:* = null;
            var len:* = 0;
            var data:* = null;
            var prevSelectionData:* = null;
            var i:* = 0;
            var items:* = _arg1;
            var index:* = _arg2;
            var useFind:Boolean = _arg3;
            if (useFind){
                while (items.length) {
                    item = items.pop();
                    uid = itemToUID(item);
                    try {
                        collectionIterator.findAny(item);
                    } catch(e1:ItemPendingError) {
                        items.push(item);
                        e1.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler, new ListBaseSelectionDataPending(useFind, 0, items, null, 0)));
                        return;
                    };
                    bookmark = collectionIterator.bookmark;
                    index = bookmark.getViewIndex();
                    if (index >= 0){
                        insertSelectionDataBefore(uid, new ListBaseSelectionData(item, index, true), firstSelectionData);
                    } else {
                        try {
                            collectionIterator.seek(CursorBookmark.FIRST, 0);
                        } catch(e2:ItemPendingError) {
                            e2.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler, new ListBaseSelectionDataPending(false, 0, items, CursorBookmark.FIRST, 0)));
                            return;
                        };
                        setSelectionDataLoop(items, 0, false);
                        return;
                    };
                    if (items.length == 0){
                        _selectedIndex = index;
                        _selectedItem = item;
                        caretIndex = index;
                        caretBookmark = collectionIterator.bookmark;
                        anchorIndex = index;
                        anchorBookmark = collectionIterator.bookmark;
                    };
                };
            } else {
                while (((items.length) && (!(collectionIterator.afterLast)))) {
                    len = items.length;
                    data = collectionIterator.current;
                    prevSelectionData = null;
                    i = 0;
                    while (i < len) {
                        if (data == items[i]){
                            uid = itemToUID(data);
                            if (prevSelectionData == null){
                                insertSelectionDataBefore(uid, new ListBaseSelectionData(data, index, false), firstSelectionData);
                            } else {
                                insertSelectionDataAfter(uid, new ListBaseSelectionData(data, index, false), prevSelectionData);
                            };
                            if (i == 0){
                                _selectedIndex = index;
                                _selectedItem = data;
                                caretIndex = index;
                                caretBookmark = collectionIterator.bookmark;
                                anchorIndex = index;
                                anchorBookmark = collectionIterator.bookmark;
                            };
                            break;
                        };
                        uid = itemToUID(items[i]);
                        if (selectedData[uid] != null){
                            prevSelectionData = selectedData[uid];
                        };
                        i = (i + 1);
                    };
                    try {
                        collectionIterator.moveNext();
                        index = (index + 1);
                    } catch(e2:ItemPendingError) {
                        e2.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler, new ListBaseSelectionDataPending(false, index, items.slice((i + 1)), CursorBookmark.FIRST, index)));
                        return;
                    };
                };
            };
            if (initialized){
                updateList();
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        public function set dragEnabled(_arg1:Boolean):void{
            if (((_dragEnabled) && (!(_arg1)))){
                removeEventListener(DragEvent.DRAG_START, dragStartHandler, false);
                removeEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false);
            };
            _dragEnabled = _arg1;
            if (_arg1){
                addEventListener(DragEvent.DRAG_START, dragStartHandler, false, EventPriority.DEFAULT_HANDLER);
                addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false, EventPriority.DEFAULT_HANDLER);
            };
        }
        mx_internal function getListContentHolder():ListBaseContentHolder{
            return (listContent);
        }
        public function set iconFunction(_arg1:Function):void{
            _iconFunction = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("iconFunctionChanged"));
        }
        protected function initiateDataChangeEffect(_arg1:Number, _arg2:Number):void{
            var _local9:Array;
            var _local10:int;
            var _local11:Object;
            actualCollection = collection;
            actualIterator = iterator;
            collection = modifiedCollectionView;
            modifiedCollectionView.showPreservedState = true;
            listContent.iterator = (iterator = collection.createCursor());
            var _local3:int = scrollPositionToIndex((horizontalScrollPosition - offscreenExtraColumnsLeft), (verticalScrollPosition - offscreenExtraRowsTop));
            iterator.seek(CursorBookmark.FIRST, _local3);
            updateDisplayList(_arg1, _arg2);
            var _local4:Array = [];
            var _local5:Dictionary = new Dictionary(true);
            var _local6:int;
            while (_local6 < listItems.length) {
                _local9 = listItems[_local6];
                if (((_local9) && ((_local9.length > 0)))){
                    _local10 = 0;
                    while (_local10 < _local9.length) {
                        _local11 = _local9[_local10];
                        if (_local11){
                            _local4.push(_local11);
                            _local5[_local11] = true;
                        };
                        _local10++;
                    };
                };
                _local6++;
            };
            cachedItemsChangeEffect.targets = _local4;
            if (cachedItemsChangeEffect.effectTargetHost != this){
                cachedItemsChangeEffect.effectTargetHost = this;
            };
            cachedItemsChangeEffect.captureStartValues();
            modifiedCollectionView.showPreservedState = false;
            iterator.seek(CursorBookmark.FIRST, _local3);
            itemsSizeChanged = true;
            updateDisplayList(_arg1, _arg2);
            var _local7:Array = [];
            var _local8:Array = cachedItemsChangeEffect.targets;
            _local6 = 0;
            while (_local6 < listItems.length) {
                _local9 = listItems[_local6];
                if (((_local9) && ((_local9.length > 0)))){
                    _local10 = 0;
                    while (_local10 < _local9.length) {
                        _local11 = _local9[_local10];
                        if (((_local11) && (!(_local5[_local11])))){
                            _local8.push(_local11);
                            _local7.push(_local11);
                        };
                        _local10++;
                    };
                };
                _local6++;
            };
            if (_local7.length > 0){
                cachedItemsChangeEffect.targets = _local8;
                cachedItemsChangeEffect.captureMoreStartValues(_local7);
            };
            cachedItemsChangeEffect.captureEndValues();
            modifiedCollectionView.showPreservedState = true;
            iterator.seek(CursorBookmark.FIRST, _local3);
            itemsSizeChanged = true;
            updateDisplayList(_arg1, _arg2);
            initiateSelectionTracking(_local8);
            cachedItemsChangeEffect.addEventListener(EffectEvent.EFFECT_END, finishDataChangeEffect);
            cachedItemsChangeEffect.play();
        }
        public function get labelFunction():Function{
            return (_labelFunction);
        }
        public function get dataTipField():String{
            return (_dataTipField);
        }
        protected function adjustListContent(_arg1:Number=-1, _arg2:Number=-1):void{
            if (_arg2 < 0){
                _arg2 = oldUnscaledHeight;
                _arg1 = oldUnscaledWidth;
            };
            var _local3:Number = (viewMetrics.left + listContent.leftOffset);
            var _local4:Number = (viewMetrics.top + listContent.topOffset);
            listContent.move(_local3, _local4);
            var _local5:Number = ((Math.max(0, listContent.rightOffset) - _local3) - viewMetrics.right);
            var _local6:Number = ((Math.max(0, listContent.bottomOffset) - _local4) - viewMetrics.bottom);
            listContent.setActualSize((_arg1 + _local5), (_arg2 + _local6));
        }
        public function get selectedIndex():int{
            return (_selectedIndex);
        }
        mx_internal function setBookmarkPendingFailureHandler(_arg1:Object, _arg2:Object):void{
        }
        private function insertSelectionDataBefore(_arg1:String, _arg2:ListBaseSelectionData, _arg3:ListBaseSelectionData):void{
            if (_arg3 == null){
                firstSelectionData = (lastSelectionData = _arg2);
            } else {
                if (_arg3 == firstSelectionData){
                    firstSelectionData = _arg2;
                };
                _arg2.nextSelectionData = _arg3;
                _arg2.prevSelectionData = _arg3.prevSelectionData;
                _arg3.prevSelectionData = _arg2;
            };
            selectedData[_arg1] = _arg2;
        }
        mx_internal function getCaretIndex():int{
            return (caretIndex);
        }
        mx_internal function removeClipMask():void{
            var _local7:DisplayObject;
            if (((listContent) && (listContent.mask))){
                return;
            };
            var _local1:int = (listItems.length - 1);
            if (_local1 < 0){
                return;
            };
            var _local2:Number = rowInfo[_local1].height;
            var _local3:ListRowInfo = rowInfo[_local1];
            var _local4:Array = listItems[_local1];
            var _local5:int = _local4.length;
            var _local6:int;
            while (_local6 < _local5) {
                _local7 = _local4[_local6];
                if ((_local7 is IUITextField)){
                    if (_local7.height != (_local2 - (_local7.y - _local3.y))){
                        _local7.height = (_local2 - (_local7.y - _local3.y));
                    };
                } else {
                    if (((_local7) && (_local7.mask))){
                        itemMaskFreeList.push(_local7.mask);
                        _local7.mask = null;
                    };
                };
                _local6++;
            };
        }
        mx_internal function reconstructDataFromListItems():Array{
            var _local1:Array;
            var _local2:int;
            var _local3:IListItemRenderer;
            var _local4:Object;
            var _local5:Object;
            var _local6:int;
            if (!listItems){
                return ([]);
            };
            _local1 = [];
            _local2 = 0;
            while (_local2 < listItems.length) {
                if (listItems[_local2]){
                    _local3 = (listItems[_local2][0] as IListItemRenderer);
                    if (_local3){
                        _local4 = _local3.data;
                        _local1.push(_local4);
                        _local6 = 0;
                        while (_local6 < listItems[_local2].length) {
                            _local3 = (listItems[_local2][_local6] as IListItemRenderer);
                            if (_local3){
                                _local5 = _local3.data;
                                if (_local5 != _local4){
                                    _local1.push(_local5);
                                };
                            };
                            _local6++;
                        };
                    };
                };
                _local2++;
            };
            return (_local1);
        }
        public function set dataTipFunction(_arg1:Function):void{
            _dataTipFunction = _arg1;
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("dataTipFunctionChanged"));
        }
        private function calculateSelectedIndexAndItem():void{
            var _local2:String;
            var _local1:int;
            for (_local2 in selectedData) {
                _local1 = 1;
                break;
            };
            if (!_local1){
                _selectedIndex = -1;
                _selectedItem = null;
                return;
            };
            _selectedIndex = selectedData[_local2].index;
            _selectedItem = selectedData[_local2].data;
        }
        protected function scrollPositionToIndex(_arg1:int, _arg2:int):int{
            return (((iterator) ? _arg2 : -1));
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!listContent){
                listContent = new ListBaseContentHolder(this);
                listContent.styleName = new StyleProxy(this, listContentStyleFilters);
                addChild(listContent);
            };
            if (!selectionLayer){
                selectionLayer = listContent.selectionLayer;
            };
        }
        public function findString(_arg1:String):Boolean{
            var cursorPos:* = null;
            var bMovedNext:* = false;
            var str:* = _arg1;
            if (((!(collection)) || ((collection.length == 0)))){
                return (false);
            };
            cursorPos = iterator.bookmark;
            var stopIndex:* = selectedIndex;
            var i:* = (stopIndex + 1);
            if (selectedIndex == -1){
                try {
                    iterator.seek(CursorBookmark.FIRST, 0);
                } catch(e1:ItemPendingError) {
                    e1.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, CursorBookmark.FIRST, 0, 0, collection.length)));
                    iteratorValid = false;
                    return (false);
                };
                stopIndex = collection.length;
                i = 0;
            } else {
                try {
                    iterator.seek(CursorBookmark.FIRST, stopIndex);
                } catch(e2:ItemPendingError) {
                    if (anchorIndex == (collection.length - 1)){
                        e2.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, CursorBookmark.FIRST, 0, 0, collection.length)));
                    } else {
                        e2.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, anchorBookmark, 1, (anchorIndex + 1), anchorIndex)));
                    };
                    iteratorValid = false;
                    return (false);
                };
                bMovedNext = false;
                try {
                    bMovedNext = iterator.moveNext();
                } catch(e3:ItemPendingError) {
                    e3.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, anchorBookmark, 1, (anchorIndex + 1), anchorIndex)));
                    iteratorValid = false;
                    return (false);
                };
                if (!bMovedNext){
                    try {
                        iterator.seek(CursorBookmark.FIRST, 0);
                    } catch(e4:ItemPendingError) {
                        e4.addResponder(new ItemResponder(findPendingResultHandler, findPendingFailureHandler, new ListBaseFindPending(str, cursorPos, CursorBookmark.FIRST, 0, 0, collection.length)));
                        iteratorValid = false;
                        return (false);
                    };
                    stopIndex = collection.length;
                    i = 0;
                };
            };
            return (findStringLoop(str, cursorPos, i, stopIndex));
        }
        private function commitSelectedItem(_arg1:Object, _arg2:Boolean=true):void{
            if (_arg2){
                clearSelected();
            };
            if (_arg1 != null){
                commitSelectedItems([_arg1]);
            };
        }
        public function showDropFeedback(_arg1:DragEvent):void{
            var _local6:Class;
            var _local7:EdgeMetrics;
            if (!dropIndicator){
                _local6 = getStyle("dropIndicatorSkin");
                if (!_local6){
                    _local6 = ListDropIndicator;
                };
                dropIndicator = IFlexDisplayObject(new (_local6)());
                _local7 = viewMetrics;
                drawFocus(true);
                dropIndicator.x = 2;
                dropIndicator.setActualSize((listContent.width - 4), 4);
                dropIndicator.visible = true;
                listContent.addChild(DisplayObject(dropIndicator));
                if (collection){
                    if (dragScrollingInterval == 0){
                        dragScrollingInterval = setInterval(dragScroll, 15);
                    };
                };
            };
            var _local2:int = listItems.length;
            var _local3:int = (((rowInfo[((_local2 - offscreenExtraRowsBottom) - 1)].y + rowInfo[((_local2 - offscreenExtraRowsBottom) - 1)].height))>(listContent.heightExcludingOffsets - listContent.topOffset)) ? 1 : 0;
            var _local4:Number = calculateDropIndex(_arg1);
            _local4 = (_local4 - verticalScrollPosition);
            var _local5:Number = listItems.length;
            if (_local4 >= _local5){
                if (_local3){
                    _local4 = (_local5 - 1);
                } else {
                    _local4 = _local5;
                };
            };
            if (_local4 < 0){
                _local4 = 0;
            };
            dropIndicator.y = calculateDropIndicatorY(_local5, (_local4 + offscreenExtraRowsTop));
        }
        mx_internal function commitSelectedIndex(_arg1:int):void{
            var bookmark:* = null;
            var len:* = 0;
            var data:* = null;
            var selectedBookmark:* = null;
            var uid:* = null;
            var value:* = _arg1;
            if (value != -1){
                value = Math.min(value, (collection.length - 1));
                bookmark = iterator.bookmark;
                len = (value - scrollPositionToIndex((horizontalScrollPosition - offscreenExtraColumnsLeft), (verticalScrollPosition - offscreenExtraRowsTop)));
                try {
                    iterator.seek(CursorBookmark.CURRENT, len);
                } catch(e:ItemPendingError) {
                    iterator.seek(bookmark, 0);
                    bSelectedIndexChanged = true;
                    _selectedIndex = value;
                    return;
                };
                data = iterator.current;
                selectedBookmark = iterator.bookmark;
                uid = itemToUID(data);
                iterator.seek(bookmark, 0);
                if (!selectedData[uid]){
                    if (((listContent) && (UIDToItemRenderer(uid)))){
                        selectItem(UIDToItemRenderer(uid), false, false);
                    } else {
                        clearSelected();
                        insertSelectionDataBefore(uid, new ListBaseSelectionData(data, value, approximate), firstSelectionData);
                        _selectedIndex = value;
                        caretIndex = value;
                        caretBookmark = selectedBookmark;
                        anchorIndex = value;
                        anchorBookmark = selectedBookmark;
                        _selectedItem = data;
                    };
                };
            } else {
                clearSelected();
            };
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }
        protected function get visibleData():Object{
            return (listContent.visibleData);
        }
        public function set rowHeight(_arg1:Number):void{
            explicitRowHeight = _arg1;
            if (_rowHeight != _arg1){
                setRowHeight(_arg1);
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                dispatchEvent(new Event("rowHeightChanged"));
            };
        }
        private function seekNextSafely(_arg1:IViewCursor, _arg2:int):Boolean{
            var iterator:* = _arg1;
            var pos:* = _arg2;
            try {
                iterator.moveNext();
            } catch(e:ItemPendingError) {
                lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos);
                e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                iteratorValid = false;
            };
            return (iteratorValid);
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            if (((_listData) && ((_listData is DataGridListData)))){
                selectedItem = _data[DataGridListData(_listData).dataField];
            } else {
                if ((((_listData is ListData)) && ((ListData(_listData).labelField in _data)))){
                    selectedItem = _data[ListData(_listData).labelField];
                } else {
                    selectedItem = _data;
                };
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        public function get rowCount():int{
            return (_rowCount);
        }
        mx_internal function get rendererArray():Array{
            return (listItems);
        }
        public function get columnCount():int{
            return (_columnCount);
        }
        protected function purgeItemRenderers():void{
            var _local1:*;
            var _local2:Array;
            var _local3:IListItemRenderer;
            var _local4:DisplayObject;
            var _local5:Dictionary;
            var _local6:*;
            rendererChanged = false;
            while (listItems.length) {
                _local2 = listItems.pop();
                while (_local2.length) {
                    _local3 = IListItemRenderer(_local2.pop());
                    if (_local3){
                        listContent.removeChild(DisplayObject(_local3));
                        if (dataItemWrappersByRenderer[_local3]){
                            delete visibleData[itemToUID(dataItemWrappersByRenderer[_local3])];
                        } else {
                            delete visibleData[itemToUID(_local3.data)];
                        };
                    };
                };
            };
            while (freeItemRenderers.length) {
                _local4 = DisplayObject(freeItemRenderers.pop());
                if (_local4.parent){
                    listContent.removeChild(_local4);
                };
            };
            for (_local1 in freeItemRenderersByFactory) {
                _local5 = freeItemRenderersByFactory[_local1];
                for (_local6 in _local5) {
                    _local4 = DisplayObject(_local6);
                    delete _local5[_local6];
                    if (_local4.parent){
                        listContent.removeChild(_local4);
                    };
                };
            };
            rowMap = {};
            listContent.rowInfo = [];
        }
        protected function mouseEventToItemRenderer(_arg1:MouseEvent):IListItemRenderer{
            return (mouseEventToItemRendererOrEditor(_arg1));
        }
        protected function UIDToItemRenderer(_arg1:String):IListItemRenderer{
            if (!listContent){
                return (null);
            };
            return (visibleData[_arg1]);
        }
        public function get dragEnabled():Boolean{
            return (_dragEnabled);
        }
        private function findPendingResultHandler(_arg1:Object, _arg2:ListBaseFindPending):void{
            iterator.seek(_arg2.bookmark, _arg2.offset);
            findStringLoop(_arg2.searchString, _arg2.startingBookmark, _arg2.currentIndex, _arg2.stopIndex);
        }
        protected function set allowItemSizeChangeNotification(_arg1:Boolean):void{
            listContent.allowItemSizeChangeNotification = _arg1;
        }
        public function get iconFunction():Function{
            return (_iconFunction);
        }
        protected function collectionChangeHandler(_arg1:Event):void{
            var len:* = 0;
            var index:* = 0;
            var i:* = 0;
            var data:* = null;
            var p:* = null;
            var selectedUID:* = null;
            var ce:* = null;
            var emitEvent:* = false;
            var oldUID:* = null;
            var sd:* = null;
            var requiresValueCommit:* = false;
            var firstUID:* = null;
            var uid:* = null;
            var deletedItems:* = null;
            var fakeRemove:* = null;
            var event:* = _arg1;
            if ((event is CollectionEvent)){
                ce = CollectionEvent(event);
                if (ce.kind == CollectionEventKind.ADD){
                    prepareDataEffect(ce);
                    if ((((ce.location == 0)) && ((verticalScrollPosition == 0)))){
                        try {
                            iterator.seek(CursorBookmark.FIRST);
                            if (!iteratorValid){
                                iteratorValid = true;
                                lastSeekPending = null;
                            };
                        } catch(e:ItemPendingError) {
                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                            iteratorValid = false;
                        };
                    } else {
                        if ((((listType == "vertical")) && ((verticalScrollPosition >= ce.location)))){
                            super.verticalScrollPosition = (super.verticalScrollPosition + ce.items.length);
                        };
                    };
                    emitEvent = adjustAfterAdd(ce.items, ce.location);
                    if (emitEvent){
                        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                    };
                } else {
                    if (ce.kind == CollectionEventKind.REPLACE){
                        selectedUID = ((selectedItem) ? itemToUID(selectedItem) : null);
                        len = ce.items.length;
                        i = 0;
                        while (i < len) {
                            oldUID = itemToUID(ce.items[i].oldValue);
                            sd = selectedData[oldUID];
                            if (sd){
                                sd.data = ce.items[i].newValue;
                                delete selectedData[oldUID];
                                selectedData[itemToUID(sd.data)] = sd;
                                if (selectedUID == oldUID){
                                    _selectedItem = sd.data;
                                    dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                                };
                            };
                            i = (i + 1);
                        };
                        prepareDataEffect(ce);
                    } else {
                        if (ce.kind == CollectionEventKind.REMOVE){
                            prepareDataEffect(ce);
                            requiresValueCommit = false;
                            if (((listItems.length) && (listItems[0].length))){
                                firstUID = rowMap[listItems[0][0].name].uid;
                                selectedUID = ((selectedItem) ? itemToUID(selectedItem) : null);
                                i = 0;
                                while (i < ce.items.length) {
                                    uid = itemToUID(ce.items[i]);
                                    if ((((uid == firstUID)) && ((verticalScrollPosition == 0)))){
                                        try {
                                            iterator.seek(CursorBookmark.FIRST);
                                            if (!iteratorValid){
                                                iteratorValid = true;
                                                lastSeekPending = null;
                                            };
                                        } catch(e1:ItemPendingError) {
                                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                                            e1.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                                            iteratorValid = false;
                                        };
                                    };
                                    if (selectedData[uid]){
                                        removeSelectionData(uid);
                                    };
                                    if (selectedUID == uid){
                                        _selectedItem = null;
                                        _selectedIndex = -1;
                                        requiresValueCommit = true;
                                    };
                                    removeIndicators(uid);
                                    i = (i + 1);
                                };
                                if ((((listType == "vertical")) && ((verticalScrollPosition >= ce.location)))){
                                    if (verticalScrollPosition > ce.location){
                                        super.verticalScrollPosition = (verticalScrollPosition - Math.min(ce.items.length, (verticalScrollPosition - ce.location)));
                                    } else {
                                        if (verticalScrollPosition >= collection.length){
                                            super.verticalScrollPosition = Math.max((collection.length - 1), 0);
                                        };
                                    };
                                    try {
                                        offscreenExtraRowsTop = Math.min(offscreenExtraRowsTop, verticalScrollPosition);
                                        index = scrollPositionToIndex(horizontalScrollPosition, (verticalScrollPosition - offscreenExtraRowsTop));
                                        iterator.seek(CursorBookmark.FIRST, index);
                                        if (!iteratorValid){
                                            iteratorValid = true;
                                            lastSeekPending = null;
                                        };
                                    } catch(e2:ItemPendingError) {
                                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, index);
                                        e2.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                                        iteratorValid = false;
                                    };
                                };
                                emitEvent = adjustAfterRemove(ce.items, ce.location, requiresValueCommit);
                                if (emitEvent){
                                    dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                                };
                            };
                        } else {
                            if (ce.kind == CollectionEventKind.MOVE){
                                if (ce.oldLocation < ce.location){
                                    for (p in selectedData) {
                                        data = selectedData[p];
                                        if ((((data.index > ce.oldLocation)) && ((data.index < ce.location)))){
                                            data.index--;
                                        } else {
                                            if (data.index == ce.oldLocation){
                                                data.index = ce.location;
                                            };
                                        };
                                    };
                                    if ((((_selectedIndex > ce.oldLocation)) && ((_selectedIndex < ce.location)))){
                                        _selectedIndex--;
                                    } else {
                                        if (_selectedIndex == ce.oldLocation){
                                            _selectedIndex = ce.location;
                                        };
                                    };
                                } else {
                                    if (ce.location < ce.oldLocation){
                                        for (p in selectedData) {
                                            data = selectedData[p];
                                            if ((((data.index > ce.location)) && ((data.index < ce.oldLocation)))){
                                                data.index++;
                                            } else {
                                                if (data.index == ce.oldLocation){
                                                    data.index = ce.location;
                                                };
                                            };
                                        };
                                        if ((((_selectedIndex > ce.location)) && ((_selectedIndex < ce.oldLocation)))){
                                            _selectedIndex++;
                                        } else {
                                            if (_selectedIndex == ce.oldLocation){
                                                _selectedIndex = ce.location;
                                            };
                                        };
                                    };
                                };
                                if (ce.oldLocation == verticalScrollPosition){
                                    if (ce.location > maxVerticalScrollPosition){
                                        iterator.seek(CursorBookmark.CURRENT, (maxVerticalScrollPosition - ce.location));
                                    };
                                    super.verticalScrollPosition = Math.min(ce.location, maxVerticalScrollPosition);
                                } else {
                                    if ((((ce.location >= verticalScrollPosition)) && ((ce.oldLocation < verticalScrollPosition)))){
                                        seekNextSafely(iterator, verticalScrollPosition);
                                    } else {
                                        if ((((ce.location <= verticalScrollPosition)) && ((ce.oldLocation > verticalScrollPosition)))){
                                            seekPreviousSafely(iterator, verticalScrollPosition);
                                        };
                                    };
                                };
                            } else {
                                if (ce.kind == CollectionEventKind.REFRESH){
                                    if (anchorBookmark){
                                        try {
                                            iterator.seek(anchorBookmark, 0);
                                            if (!iteratorValid){
                                                iteratorValid = true;
                                                lastSeekPending = null;
                                            };
                                        } catch(e:ItemPendingError) {
                                            bSortItemPending = true;
                                            lastSeekPending = new ListBaseSeekPending(anchorBookmark, 0);
                                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                                            iteratorValid = false;
                                        } catch(cursorError:CursorError) {
                                            clearSelected();
                                        };
                                        adjustAfterSort();
                                    } else {
                                        try {
                                            index = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
                                            iterator.seek(CursorBookmark.FIRST, index);
                                            if (!iteratorValid){
                                                iteratorValid = true;
                                                lastSeekPending = null;
                                            };
                                        } catch(e:ItemPendingError) {
                                            bSortItemPending = true;
                                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, index);
                                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                                            iteratorValid = false;
                                        };
                                    };
                                } else {
                                    if (ce.kind == CollectionEventKind.RESET){
                                        if ((((collection.length == 0)) || (((runningDataEffect) && ((actualCollection.length == 0)))))){
                                            deletedItems = reconstructDataFromListItems();
                                            if (deletedItems.length){
                                                fakeRemove = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                                                fakeRemove.kind = CollectionEventKind.REMOVE;
                                                fakeRemove.items = deletedItems;
                                                fakeRemove.location = 0;
                                                prepareDataEffect(fakeRemove);
                                            };
                                        };
                                        try {
                                            iterator.seek(CursorBookmark.FIRST);
                                            if (!iteratorValid){
                                                iteratorValid = true;
                                                lastSeekPending = null;
                                            };
                                            collectionIterator.seek(CursorBookmark.FIRST);
                                        } catch(e:ItemPendingError) {
                                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                                            iteratorValid = false;
                                        };
                                        if (((((((bSelectedIndexChanged) || (bSelectedItemChanged))) || (bSelectedIndicesChanged))) || (bSelectedItemsChanged))){
                                            bSelectionChanged = true;
                                        } else {
                                            commitSelectedIndex(-1);
                                        };
                                        if (isNaN(verticalScrollPositionPending)){
                                            verticalScrollPositionPending = 0;
                                            super.verticalScrollPosition = 0;
                                        };
                                        if (isNaN(horizontalScrollPositionPending)){
                                            horizontalScrollPositionPending = 0;
                                            super.horizontalScrollPosition = 0;
                                        };
                                        invalidateSize();
                                    } else {
                                        if (ce.kind == CollectionEventKind.UPDATE){
                                            selectedUID = ((selectedItem) ? itemToUID(selectedItem) : null);
                                            len = ce.items.length;
                                            i = 0;
                                            while (i < len) {
                                                if (ce.items[i].property == "uid"){
                                                    oldUID = ce.items[i].oldValue;
                                                    sd = selectedData[oldUID];
                                                    if (sd){
                                                        sd.data = ce.items[i].target;
                                                        delete selectedData[oldUID];
                                                        selectedData[ce.items[i].newValue] = sd;
                                                        if (selectedUID == oldUID){
                                                            _selectedItem = sd.data;
                                                            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                                                        };
                                                    };
                                                };
                                                i = (i + 1);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        public function set dataProvider(_arg1:Object):void{
            var _local3:XMLList;
            var _local4:Array;
            if (collection){
                collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
            };
            if ((_arg1 is Array)){
                collection = new ArrayCollection((_arg1 as Array));
            } else {
                if ((_arg1 is ICollectionView)){
                    collection = ICollectionView(_arg1);
                } else {
                    if ((_arg1 is IList)){
                        collection = new ListCollectionView(IList(_arg1));
                    } else {
                        if ((_arg1 is XMLList)){
                            collection = new XMLListCollection((_arg1 as XMLList));
                        } else {
                            if ((_arg1 is XML)){
                                _local3 = new XMLList();
                                _local3 = (_local3 + _arg1);
                                collection = new XMLListCollection(_local3);
                            } else {
                                _local4 = [];
                                if (_arg1 != null){
                                    _local4.push(_arg1);
                                };
                                collection = new ArrayCollection(_local4);
                            };
                        };
                    };
                };
            };
            iterator = collection.createCursor();
            collectionIterator = collection.createCursor();
            collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
            clearSelectionData();
            var _local2:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _local2.kind = CollectionEventKind.RESET;
            collectionChangeHandler(_local2);
            dispatchEvent(_local2);
            itemsNeedMeasurement = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        protected function destroyRow(_arg1:int, _arg2:int):void{
            var _local3:IListItemRenderer;
            var _local4:String = rowInfo[_arg1].uid;
            removeIndicators(_local4);
            var _local5:int;
            while (_local5 < _arg2) {
                _local3 = listItems[_arg1][_local5];
                if (_local3.data){
                    delete visibleData[_local4];
                };
                addToFreeItemRenderers(_local3);
                _local5++;
            };
        }
        protected function dragDropHandler(_arg1:DragEvent):void{
            var _local2:Array;
            var _local3:int;
            var _local4:Array;
            var _local5:int;
            if (_arg1.isDefaultPrevented()){
                return;
            };
            hideDropFeedback(_arg1);
            lastDragEvent = null;
            resetDragScrolling();
            if (((enabled) && (_arg1.dragSource.hasFormat("items")))){
                if (!dataProvider){
                    dataProvider = [];
                };
                _local2 = (_arg1.dragSource.dataForFormat("items") as Array);
                _local3 = calculateDropIndex(_arg1);
                if ((((_arg1.action == DragManager.MOVE)) && (dragMoveEnabled))){
                    if (_arg1.dragInitiator == this){
                        _local4 = selectedIndices;
                        _local4.sort(Array.NUMERIC);
                        _local5 = (_local4.length - 1);
                        while (_local5 >= 0) {
                            collectionIterator.seek(CursorBookmark.FIRST, _local4[_local5]);
                            if (_local4[_local5] < _local3){
                                _local3--;
                            };
                            collectionIterator.remove();
                            _local5--;
                        };
                        clearSelected(false);
                    };
                };
                collectionIterator.seek(CursorBookmark.FIRST, _local3);
                _local5 = (_local2.length - 1);
                while (_local5 >= 0) {
                    if (_arg1.action == DragManager.COPY){
                        collectionIterator.insert(copyItemWithUID(_local2[_local5]));
                    } else {
                        if (_arg1.action == DragManager.MOVE){
                            collectionIterator.insert(_local2[_local5]);
                        };
                    };
                    _local5--;
                };
            };
            lastDragEvent = null;
        }
        public function get dataTipFunction():Function{
            return (_dataTipFunction);
        }
        public function scrollToIndex(_arg1:int):Boolean{
            var _local2:int;
            if ((((_arg1 >= ((verticalScrollPosition + listItems.length) - offscreenExtraRowsBottom))) || ((_arg1 < verticalScrollPosition)))){
                _local2 = Math.min(_arg1, maxVerticalScrollPosition);
                verticalScrollPosition = _local2;
                return (true);
            };
            return (false);
        }
        protected function addToFreeItemRenderers(_arg1:IListItemRenderer):void{
            DisplayObject(_arg1).visible = false;
            var _local2:IFactory = factoryMap[_arg1];
            var _local3:ItemWrapper = dataItemWrappersByRenderer[_arg1];
            var _local4:String = ((_local3) ? itemToUID(_local3) : itemToUID(_arg1.data));
            if (visibleData[_local4] == _arg1){
                delete visibleData[_local4];
            };
            if (_local3){
                reservedItemRenderers[itemToUID(_local3)] = _arg1;
            } else {
                if (!freeItemRenderersByFactory){
                    freeItemRenderersByFactory = new Dictionary(true);
                };
                if (freeItemRenderersByFactory[_local2] == undefined){
                    freeItemRenderersByFactory[_local2] = new Dictionary(true);
                };
                freeItemRenderersByFactory[_local2][_arg1] = 1;
                if (_local2 == itemRenderer){
                    freeItemRenderers.push(_arg1);
                };
            };
            delete rowMap[_arg1.name];
        }
        override protected function initializeAccessibility():void{
            if (ListBase.createAccessibilityImplementation != null){
                ListBase.createAccessibilityImplementation(this);
            };
        }
        public function isItemSelectable(_arg1:Object):Boolean{
            if (!selectable){
                return (false);
            };
            if (_arg1 == null){
                return (false);
            };
            return (true);
        }
        private function findPendingFailureHandler(_arg1:Object, _arg2:ListBaseFindPending):void{
        }
        public function get rowHeight():Number{
            return (_rowHeight);
        }
        public function get data():Object{
            return (_data);
        }
        mx_internal function adjustOffscreenRowsAndColumns():void{
            offscreenExtraColumns = 0;
            offscreenExtraRows = offscreenExtraRowsOrColumns;
        }
        protected function indexToRow(_arg1:int):int{
            return (_arg1);
        }
        protected function get dragImageOffsets():Point{
            var _local1:Point = new Point();
            var _local2:int = listItems.length;
            var _local3:int;
            while (_local3 < _local2) {
                if (selectedData[rowInfo[_local3].uid]){
                    _local1.x = listItems[_local3][0].x;
                    _local1.y = listItems[_local3][0].y;
                };
                _local3++;
            };
            return (_local1);
        }
        public function get dataProvider():Object{
            if (actualCollection){
                return (actualCollection);
            };
            return (collection);
        }
        override public function styleChanged(_arg1:String):void{
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            if (IS_ITEM_STYLE[_arg1]){
                itemsSizeChanged = true;
                invalidateDisplayList();
            } else {
                if (_arg1 == "paddingTop"){
                    cachedPaddingTopInvalid = true;
                    invalidateProperties();
                } else {
                    if (_arg1 == "paddingBottom"){
                        cachedPaddingBottomInvalid = true;
                        invalidateProperties();
                    } else {
                        if (_arg1 == "verticalAlign"){
                            cachedVerticalAlignInvalid = true;
                            invalidateProperties();
                        } else {
                            if (_arg1 == "itemsChangeEffect"){
                                cachedItemsChangeEffect = null;
                            } else {
                                if (((listContent) && (listItems))){
                                    _local2 = listItems.length;
                                    _local3 = 0;
                                    while (_local3 < _local2) {
                                        _local4 = listItems[_local3].length;
                                        _local5 = 0;
                                        while (_local5 < _local4) {
                                            if (listItems[_local3][_local5]){
                                                listItems[_local3][_local5].styleChanged(_arg1);
                                            };
                                            _local5++;
                                        };
                                        _local3++;
                                    };
                                };
                            };
                        };
                    };
                };
            };
            super.styleChanged(_arg1);
            if (invalidateSizeFlag){
                itemsNeedMeasurement = true;
                invalidateProperties();
            };
            if (StyleManager.isSizeInvalidatingStyle(_arg1)){
                scrollAreaChanged = true;
            };
        }
        private function selectionPendingResultHandler(_arg1:Object, _arg2:ListBaseSelectionPending):void{
            iterator.seek(_arg2.bookmark, _arg2.offset);
            shiftSelectionLoop(_arg2.incrementing, _arg2.index, _arg2.stopData, _arg2.transition, _arg2.placeHolder);
        }
        public function set selectedItems(_arg1:Array):void{
            if (((!(collection)) || ((collection.length == 0)))){
                _selectedItems = _arg1;
                bSelectedItemsChanged = true;
                bSelectionChanged = true;
                invalidateDisplayList();
                return;
            };
            commitSelectedItems(_arg1);
        }
        public function itemToDataTip(_arg1:Object):String{
            var data:* = _arg1;
            if (data == null){
                return (" ");
            };
            if (dataTipFunction != null){
                return (dataTipFunction(data));
            };
            if ((data is XML)){
                try {
                    if (data[dataTipField].length() != 0){
                        data = data[dataTipField];
                    };
                } catch(e:Error) {
                };
            } else {
                if ((data is Object)){
                    try {
                        if (data[dataTipField] != null){
                            data = data[dataTipField];
                        } else {
                            if (data.label != null){
                                data = data.label;
                            };
                        };
                    } catch(e:Error) {
                    };
                };
            };
            if ((data is String)){
                return (String(data));
            };
            try {
                return (data.toString());
            } catch(e:Error) {
            };
            return (" ");
        }
        protected function dragStartHandler(_arg1:DragEvent):void{
            var _local2:DragSource;
            if (_arg1.isDefaultPrevented()){
                return;
            };
            _local2 = new DragSource();
            addDragData(_local2);
            DragManager.doDrag(this, _local2, _arg1, dragImage, 0, 0, 0.5, dragMoveEnabled);
        }
        private function cleanupAfterDataChangeEffect():void{
            if (((runningDataEffect) || (runDataEffectNextUpdate))){
                return;
            };
            var _local1:int = scrollPositionToIndex((horizontalScrollPosition - offscreenExtraColumnsLeft), (verticalScrollPosition - offscreenExtraRowsTop));
            iterator.seek(CursorBookmark.FIRST, _local1);
            dataEffectCompleted = true;
            itemsSizeChanged = true;
            invalidateList();
            dataItemWrappersByRenderer = new Dictionary();
        }
        mx_internal function setBookmarkPendingResultHandler(_arg1:Object, _arg2:Object):void{
            var placeHolder:* = null;
            var data:* = _arg1;
            var info:* = _arg2;
            placeHolder = iterator.bookmark;
            try {
                iterator.seek(CursorBookmark.FIRST, info.value);
                this[info.property] = iterator.bookmark;
            } catch(e:ItemPendingError) {
                e.addResponder(new ItemResponder(setBookmarkPendingResultHandler, setBookmarkPendingFailureHandler, info));
            };
            iterator.seek(placeHolder);
        }
        protected function removeIndicators(_arg1:String):void{
            if (selectionTweens[_arg1]){
                selectionTweens[_arg1].removeEventListener(TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);
                selectionTweens[_arg1].removeEventListener(TweenEvent.TWEEN_END, selectionTween_endHandler);
                if (selectionIndicators[_arg1].alpha < 1){
                    Tween.removeTween(selectionTweens[_arg1]);
                };
                delete selectionTweens[_arg1];
            };
            if (selectionIndicators[_arg1]){
                selectionIndicators[_arg1].parent.removeChild(selectionIndicators[_arg1]);
                selectionIndicators[_arg1] = null;
            };
            if (_arg1 == highlightUID){
                highlightItemRenderer = null;
                highlightUID = null;
                clearHighlightIndicator(highlightIndicator, UIDToItemRenderer(_arg1));
            };
            if (_arg1 == caretUID){
                caretItemRenderer = null;
                caretUID = null;
                clearCaretIndicator(caretIndicator, UIDToItemRenderer(_arg1));
            };
        }
        private function mouseIsUp():void{
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);
            if (((!(dragEnabled)) && (!((dragScrollingInterval == 0))))){
                clearInterval(dragScrollingInterval);
                dragScrollingInterval = 0;
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:CursorBookmark;
            var _local6:int;
            super.updateDisplayList(_arg1, _arg2);
            if ((((((((((oldUnscaledWidth == _arg1)) && ((oldUnscaledHeight == _arg2)))) && (!(itemsSizeChanged)))) && (!(bSelectionChanged)))) && (!(scrollAreaChanged)))){
                return;
            };
            if (oldUnscaledWidth != _arg1){
                itemsSizeChanged = true;
            };
            removeClipMask();
            var _local4:Graphics = selectionLayer.graphics;
            _local4.clear();
            if ((((listContent.width > 0)) && ((listContent.height > 0)))){
                _local4.beginFill(0x808080, 0);
                _local4.drawRect(0, 0, listContent.width, listContent.height);
                _local4.endFill();
            };
            if (rendererChanged){
                purgeItemRenderers();
            } else {
                if (dataEffectCompleted){
                    partialPurgeItemRenderers();
                };
            };
            adjustListContent(_arg1, _arg2);
            var _local5:Boolean = ((collection) && ((collection.length > 0)));
            if (_local5){
                adjustScrollPosition();
            };
            if ((((((((((((oldUnscaledWidth == _arg1)) && (!(scrollAreaChanged)))) && (!(itemsSizeChanged)))) && ((listItems.length > 0)))) && (iterator))) && ((columnCount == 1)))){
                _local6 = (listItems.length - 1);
                if (oldUnscaledHeight > _arg2){
                    reduceRows(_local6);
                } else {
                    makeAdditionalRows(_local6);
                };
            } else {
                if (iterator){
                    _local3 = iterator.bookmark;
                };
                clearIndicators();
                rendererTrackingSuspended = true;
                if (iterator){
                    if (((((offscreenExtraColumns) || (offscreenExtraColumnsLeft))) || (offscreenExtraColumnsRight))){
                        makeRowsAndColumnsWithExtraColumns(_arg1, _arg2);
                    } else {
                        makeRowsAndColumnsWithExtraRows(_arg1, _arg2);
                    };
                } else {
                    makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
                };
                rendererTrackingSuspended = false;
                seekPositionIgnoreError(iterator, _local3);
            };
            oldUnscaledWidth = _arg1;
            oldUnscaledHeight = _arg2;
            configureScrollBars();
            addClipMask(true);
            itemsSizeChanged = false;
            wordWrapChanged = false;
            adjustSelectionSettings(_local5);
            if (((keySelectionPending) && (iteratorValid))){
                keySelectionPending = false;
                finishKeySelection();
            };
        }
        protected function dragCompleteHandler(_arg1:DragEvent):void{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            isPressed = false;
            if (_arg1.isDefaultPrevented()){
                return;
            };
            if ((((_arg1.action == DragManager.MOVE)) && (dragMoveEnabled))){
                if (_arg1.relatedObject != this){
                    _local2 = selectedIndices;
                    _local2.sort(Array.NUMERIC);
                    _local3 = _local2.length;
                    _local4 = (_local3 - 1);
                    while (_local4 >= 0) {
                        collectionIterator.seek(CursorBookmark.FIRST, _local2[_local4]);
                        collectionIterator.remove();
                        _local4--;
                    };
                    clearSelected(false);
                };
            };
            lastDragEvent = null;
            resetDragScrolling();
        }
        public function getItemRendererFactory(_arg1:Object):IFactory{
            if (_arg1 == null){
                return (nullItemRenderer);
            };
            return (itemRenderer);
        }

    }
}//package mx.controls.listClasses 
