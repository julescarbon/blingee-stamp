package mx.controls {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.controls.scrollClasses.*;
    import mx.controls.listClasses.*;
    import mx.collections.*;
    import flash.utils.*;
    import flash.ui.*;
    import mx.collections.errors.*;

    public class List extends ListBase implements IIMESupport {

        mx_internal static const VERSION:String = "3.2.0.3958";

        mx_internal static var createAccessibilityImplementation:Function;

        public var editorXOffset:Number = 0;
        public var itemEditorInstance:IListItemRenderer;
        public var rendererIsEditor:Boolean = false;
        private var dontEdit:Boolean = false;
        public var editorYOffset:Number = 0;
        public var editorWidthOffset:Number = 0;
        private var lastEditedItemPosition;
        public var itemEditor:IFactory;
        public var editable:Boolean = false;
        private var losingFocus:Boolean = false;
        public var editorUsesEnterKey:Boolean = false;
        public var editorDataField:String = "text";
        private var bEditedItemPositionChanged:Boolean = false;
        mx_internal var _lockedRowCount:int = 0;
        private var inEndEdit:Boolean = false;
        public var editorHeightOffset:Number = 0;
        private var _editedItemPosition:Object;
        private var _imeMode:String;
        private var actualRowIndex:int;
        private var _proposedEditedItemPosition;
        private var actualColIndex:int = 0;
        protected var measuringObjects:Dictionary;

        public function List(){
            itemEditor = new ClassFactory(TextInput);
            super();
            listType = "vertical";
            bColumnScrolling = false;
            itemRenderer = new ClassFactory(ListItemRenderer);
            _horizontalScrollPolicy = ScrollPolicy.OFF;
            _verticalScrollPolicy = ScrollPolicy.AUTO;
            defaultColumnCount = 1;
            defaultRowCount = 7;
            addEventListener(ListEvent.ITEM_EDIT_BEGINNING, itemEditorItemEditBeginningHandler, false, EventPriority.DEFAULT_HANDLER);
            addEventListener(ListEvent.ITEM_EDIT_BEGIN, itemEditorItemEditBeginHandler, false, EventPriority.DEFAULT_HANDLER);
            addEventListener(ListEvent.ITEM_EDIT_END, itemEditorItemEditEndHandler, false, EventPriority.DEFAULT_HANDLER);
        }
        override public function measureWidthOfItems(_arg1:int=-1, _arg2:int=0):Number{
            var item:* = null;
            var rw:* = NaN;
            var data:* = null;
            var factory:* = null;
            var index:int = _arg1;
            var count:int = _arg2;
            if (count == 0){
                count = ((collection) ? collection.length : 0);
            };
            if (((collection) && ((collection.length == 0)))){
                count = 0;
            };
            var w:* = 0;
            var bookmark:* = ((iterator) ? iterator.bookmark : null);
            if (((!((index == -1))) && (iterator))){
                try {
                    iterator.seek(CursorBookmark.FIRST, index);
                } catch(e:ItemPendingError) {
                    return (0);
                };
            };
            var more:* = !((iterator == null));
            var i:* = 0;
            while (i < count) {
                if (more){
                    data = iterator.current;
                    factory = getItemRendererFactory(data);
                    item = measuringObjects[factory];
                    if (!item){
                        item = getMeasuringRenderer(data);
                    };
                    item.explicitWidth = NaN;
                    setupRendererFromData(item, data);
                    rw = item.measuredWidth;
                    w = Math.max(w, rw);
                };
                if (more){
                    try {
                        more = iterator.moveNext();
                    } catch(e:ItemPendingError) {
                        more = false;
                    };
                };
                i = (i + 1);
            };
            if (iterator){
                iterator.seek(bookmark, 0);
            };
            if (w == 0){
                if (explicitWidth){
                    return (explicitWidth);
                };
                return (DEFAULT_MEASURED_WIDTH);
            };
            var paddingLeft:* = getStyle("paddingLeft");
            var paddingRight:* = getStyle("paddingRight");
            w = (w + (paddingLeft + paddingRight));
            return (w);
        }
        private function findNextEnterItemRenderer(_arg1:KeyboardEvent):void{
            if (_proposedEditedItemPosition !== undefined){
                return;
            };
            _editedItemPosition = lastEditedItemPosition;
            var _local2:int = _editedItemPosition.rowIndex;
            var _local3:int = _editedItemPosition.columnIndex;
            var _local4:int = (_editedItemPosition.rowIndex + ((_arg1.shiftKey) ? -1 : 1));
            if ((((_local4 < collection.length)) && ((_local4 >= 0)))){
                _local2 = _local4;
            };
            var _local5:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING, false, true);
            _local5.rowIndex = _local2;
            _local5.columnIndex = 0;
            dispatchEvent(_local5);
        }
        public function get imeMode():String{
            return (_imeMode);
        }
        private function mouseFocusChangeHandler(_arg1:MouseEvent):void{
            if (((((itemEditorInstance) && (!(_arg1.isDefaultPrevented())))) && (itemRendererContains(itemEditorInstance, DisplayObject(_arg1.target))))){
                _arg1.preventDefault();
            };
        }
        public function set imeMode(_arg1:String):void{
            _imeMode = _arg1;
        }
        override protected function mouseUpHandler(_arg1:MouseEvent):void{
            var _local2:ListEvent;
            var _local3:IListItemRenderer;
            var _local4:Sprite;
            var _local5:int;
            var _local6:int;
            var _local7:Point;
            _local3 = mouseEventToItemRenderer(_arg1);
            super.mouseUpHandler(_arg1);
            if (((((_local3) && (_local3.data))) && (!((_local3 == itemEditorInstance))))){
                _local7 = itemRendererToIndices(_local3);
                if (((editable) && (!(dontEdit)))){
                    _local2 = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING, false, true);
                    _local2.rowIndex = _local7.y;
                    _local2.columnIndex = 0;
                    _local2.itemRenderer = _local3;
                    dispatchEvent(_local2);
                };
            };
        }
        private function itemEditorItemEditEndHandler(_arg1:ListEvent):void{
            var bChanged:* = false;
            var bFieldChanged:* = false;
            var newData:* = null;
            var data:* = null;
            var editCollection:* = null;
            var listData:* = null;
            var fm:* = null;
            var event:* = _arg1;
            if (!event.isDefaultPrevented()){
                bChanged = false;
                bFieldChanged = false;
                newData = itemEditorInstance[editorDataField];
                data = event.itemRenderer.data;
                if ((data is String)){
                    if (!(newData is String)){
                        newData = newData.toString();
                    };
                } else {
                    if ((data is uint)){
                        if (!(newData is uint)){
                            newData = uint(newData);
                        };
                    } else {
                        if ((data is int)){
                            if (!(newData is int)){
                                newData = int(newData);
                            };
                        } else {
                            if ((data is Number)){
                                if (!(newData is int)){
                                    newData = Number(newData);
                                };
                            } else {
                                bFieldChanged = true;
                                try {
                                    data[labelField] = newData;
                                    if (!(data is IPropertyChangeNotifier)){
                                        if (actualCollection){
                                            actualCollection.itemUpdated(data, labelField);
                                        } else {
                                            collection.itemUpdated(data, labelField);
                                        };
                                    };
                                } catch(e:Error) {
                                    trace("attempt to write to", labelField, "failed.  You may need a custom ITEM_EDIT_END handler");
                                };
                            };
                        };
                    };
                };
                if (!bFieldChanged){
                    if (data !== newData){
                        bChanged = true;
                        data = newData;
                    };
                    if (bChanged){
                        editCollection = ((actualCollection) ? (actualCollection as IList) : (collection as IList));
                        if (editCollection){
                            IList(editCollection).setItemAt(data, event.rowIndex);
                        } else {
                            trace("attempt to update collection failed.  You may need a custom ITEM_EDIT_END handler");
                        };
                    };
                };
                if ((event.itemRenderer is IDropInListItemRenderer)){
                    listData = BaseListData(IDropInListItemRenderer(event.itemRenderer).listData);
                    listData.label = itemToLabel(data);
                    IDropInListItemRenderer(event.itemRenderer).listData = listData;
                };
                delete visibleData[itemToUID(event.itemRenderer.data)];
                event.itemRenderer.data = data;
                visibleData[itemToUID(data)] = event.itemRenderer;
            } else {
                if (event.reason != ListEventReason.OTHER){
                    if (((itemEditorInstance) && (_editedItemPosition))){
                        if (selectedIndex != _editedItemPosition.rowIndex){
                            selectedIndex = _editedItemPosition.rowIndex;
                        };
                        fm = focusManager;
                        if ((itemEditorInstance is IFocusManagerComponent)){
                            fm.setFocus(IFocusManagerComponent(itemEditorInstance));
                        };
                    };
                };
            };
            if ((((event.reason == ListEventReason.OTHER)) || (!(event.isDefaultPrevented())))){
                destroyItemEditor();
            };
        }
        private function itemEditorItemEditBeginningHandler(_arg1:ListEvent):void{
            if (!_arg1.isDefaultPrevented()){
                setEditedItemPosition({
                    columnIndex:_arg1.columnIndex,
                    rowIndex:_arg1.rowIndex
                });
            } else {
                if (!itemEditorInstance){
                    _editedItemPosition = null;
                    editable = false;
                    setFocus();
                    editable = true;
                };
            };
        }
        override public function createItemRenderer(_arg1:Object):IListItemRenderer{
            var _local2:IFactory;
            var _local3:IListItemRenderer;
            var _local4:Dictionary;
            var _local5:*;
            _local2 = getItemRendererFactory(_arg1);
            if (!_local2){
                if (_arg1 == null){
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
        override protected function focusOutHandler(_arg1:FocusEvent):void{
            if (_arg1.target == this){
                super.focusOutHandler(_arg1);
            };
            if ((((_arg1.relatedObject == this)) && (itemRendererContains(itemEditorInstance, DisplayObject(_arg1.target))))){
                return;
            };
            if ((((_arg1.relatedObject == null)) && (itemRendererContains(editedItemRenderer, DisplayObject(_arg1.target))))){
                return;
            };
            if ((((_arg1.relatedObject == null)) && (itemRendererContains(itemEditorInstance, DisplayObject(_arg1.target))))){
                return;
            };
            if (((itemEditorInstance) && (((!(_arg1.relatedObject)) || (!(itemRendererContains(itemEditorInstance, _arg1.relatedObject))))))){
                endEdit(ListEventReason.OTHER);
                removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
                removeEventListener(MouseEvent.MOUSE_DOWN, mouseFocusChangeHandler);
            };
        }
        override protected function scrollHorizontally(_arg1:int, _arg2:int, _arg3:Boolean):void{
            var _local4:int = listItems.length;
            var _local5:Number = getStyle("paddingLeft");
            var _local6:int;
            while (_local6 < _local4) {
                if (listItems[_local6].length){
                    listItems[_local6][0].x = (-(_arg1) + _local5);
                };
                _local6++;
            };
        }
        override protected function drawHighlightIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            super.drawHighlightIndicator(_arg1, 0, _arg3, ((unscaledWidth - viewMetrics.left) - viewMetrics.right), _arg5, _arg6, _arg7);
        }
        public function get editedItemPosition():Object{
            if (_editedItemPosition){
                return ({
                    rowIndex:_editedItemPosition.rowIndex,
                    columnIndex:0
                });
            };
            return (_editedItemPosition);
        }
        private function setEditedItemPosition(_arg1:Object):void{
            bEditedItemPositionChanged = true;
            _proposedEditedItemPosition = _arg1;
            invalidateDisplayList();
        }
        override protected function drawRowBackgrounds():void{
            var _local2:Array;
            var _local6:int;
            var _local1:Sprite = Sprite(listContent.getChildByName("rowBGs"));
            if (!_local1){
                _local1 = new FlexSprite();
                _local1.mouseEnabled = false;
                _local1.name = "rowBGs";
                listContent.addChildAt(_local1, 0);
            };
            _local2 = getStyle("alternatingItemColors");
            if (((!(_local2)) || ((_local2.length == 0)))){
                while (_local1.numChildren > _local6) {
                    _local1.removeChildAt((_local1.numChildren - 1));
                };
                return;
            };
            StyleManager.getColorNames(_local2);
            var _local3:int;
            var _local4:int = verticalScrollPosition;
            var _local5:int;
            _local6 = listItems.length;
            while (_local3 < _local6) {
                var _temp1 = _local5;
                _local5 = (_local5 + 1);
                drawRowBackground(_local1, _temp1, rowInfo[_local3].y, rowInfo[_local3].height, _local2[(_local4 % _local2.length)], _local4);
                _local3++;
                _local4++;
            };
            while (_local1.numChildren > _local6) {
                _local1.removeChildAt((_local1.numChildren - 1));
            };
        }
        override protected function drawCaretIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            super.drawCaretIndicator(_arg1, 0, _arg3, ((unscaledWidth - viewMetrics.left) - viewMetrics.right), _arg5, _arg6, _arg7);
        }
        private function deactivateHandler(_arg1:Event):void{
            if (itemEditorInstance){
                endEdit(ListEventReason.OTHER);
                losingFocus = true;
                setFocus();
            };
        }
        protected function layoutEditor(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void{
            itemEditorInstance.move(_arg1, _arg2);
            itemEditorInstance.setActualSize(_arg3, _arg4);
        }
        private function editorKeyDownHandler(_arg1:KeyboardEvent):void{
            if (_arg1.keyCode == Keyboard.ESCAPE){
                endEdit(ListEventReason.CANCELLED);
            } else {
                if (((_arg1.ctrlKey) && ((_arg1.charCode == 46)))){
                    endEdit(ListEventReason.CANCELLED);
                } else {
                    if ((((_arg1.charCode == Keyboard.ENTER)) && (!((_arg1.keyCode == 229))))){
                        if (editorUsesEnterKey){
                            return;
                        };
                        if (endEdit(ListEventReason.NEW_ROW)){
                            if (!dontEdit){
                                findNextEnterItemRenderer(_arg1);
                            };
                        };
                    };
                };
            };
        }
        private function itemEditorItemEditBeginHandler(_arg1:ListEvent):void{
            var _local2:IFocusManager;
            if (root){
                systemManager.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
            };
            if (((!(_arg1.isDefaultPrevented())) && (!((listItems[actualRowIndex][actualColIndex].data == null))))){
                createItemEditor(_arg1.columnIndex, _arg1.rowIndex);
                if ((((editedItemRenderer is IDropInListItemRenderer)) && ((itemEditorInstance is IDropInListItemRenderer)))){
                    IDropInListItemRenderer(itemEditorInstance).listData = IDropInListItemRenderer(editedItemRenderer).listData;
                };
                if (!rendererIsEditor){
                    itemEditorInstance.data = editedItemRenderer.data;
                };
                if ((itemEditorInstance is IInvalidating)){
                    IInvalidating(itemEditorInstance).validateNow();
                };
                if ((itemEditorInstance is IIMESupport)){
                    IIMESupport(itemEditorInstance).imeMode = imeMode;
                };
                _local2 = focusManager;
                if ((itemEditorInstance is IFocusManagerComponent)){
                    _local2.setFocus(IFocusManagerComponent(itemEditorInstance));
                };
                _local2.defaultButtonEnabled = false;
                _arg1 = new ListEvent(ListEvent.ITEM_FOCUS_IN);
                _arg1.rowIndex = _editedItemPosition.rowIndex;
                _arg1.itemRenderer = itemEditorInstance;
                dispatchEvent(_arg1);
            };
        }
        private function editingTemporarilyPrevented(_arg1:Object):Boolean{
            var _local2:int;
            var _local3:IListItemRenderer;
            if (((runningDataEffect) && (_arg1))){
                _local2 = ((_arg1.rowIndex - verticalScrollPosition) + offscreenExtraRowsTop);
                if ((((_local2 < 0)) || ((_local2 >= listItems.length)))){
                    return (false);
                };
                _local3 = listItems[_local2][0];
                if (((_local3) && (((getRendererSemanticValue(_local3, "replaced")) || (getRendererSemanticValue(_local3, "removed")))))){
                    return (true);
                };
            };
            return (false);
        }
        override public function measureHeightOfItems(_arg1:int=-1, _arg2:int=0):Number{
            var data:* = null;
            var item:* = null;
            var index:int = _arg1;
            var count:int = _arg2;
            if (count == 0){
                count = ((collection) ? collection.length : 0);
            };
            var paddingTop:* = getStyle("paddingTop");
            var paddingBottom:* = getStyle("paddingBottom");
            var ww:* = 200;
            if (listContent.width){
                ww = listContent.width;
            };
            var h:* = 0;
            var bookmark:* = ((iterator) ? iterator.bookmark : null);
            if (((!((index == -1))) && (iterator))){
                iterator.seek(CursorBookmark.FIRST, index);
            };
            var rh:* = rowHeight;
            var more:* = !((iterator == null));
            var i:* = 0;
            while (i < count) {
                if (more){
                    rh = rowHeight;
                    data = iterator.current;
                    item = getMeasuringRenderer(data);
                    item.explicitWidth = ww;
                    setupRendererFromData(item, data);
                    if (variableRowHeight){
                        rh = ((item.getExplicitOrMeasuredHeight() + paddingTop) + paddingBottom);
                    };
                };
                h = (h + rh);
                if (more){
                    try {
                        more = iterator.moveNext();
                    } catch(e:ItemPendingError) {
                        more = false;
                    };
                };
                i = (i + 1);
            };
            if (iterator){
                iterator.seek(bookmark, 0);
            };
            return (h);
        }
        mx_internal function callSetupRendererFromData(_arg1:IListItemRenderer, _arg2:Object):void{
            setupRendererFromData(_arg1, _arg2);
        }
        override protected function drawSelectionIndicator(_arg1:Sprite, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:uint, _arg7:IListItemRenderer):void{
            super.drawSelectionIndicator(_arg1, 0, _arg3, ((unscaledWidth - viewMetrics.left) - viewMetrics.right), _arg5, _arg6, _arg7);
        }
        private function keyFocusChangeHandler(_arg1:FocusEvent):void{
            if ((((((_arg1.keyCode == Keyboard.TAB)) && (!(_arg1.isDefaultPrevented())))) && (findNextItemRenderer(_arg1.shiftKey)))){
                _arg1.preventDefault();
            };
        }
        public function set editedItemPosition(_arg1:Object):void{
            var _local2:Object = {
                rowIndex:_arg1.rowIndex,
                columnIndex:0
            };
            setEditedItemPosition(_local2);
        }
        override protected function makeRowsAndColumns(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:int, _arg6:int, _arg7:Boolean=false, _arg8:uint=0):Point{
            var yy:* = NaN;
            var hh:* = NaN;
            var i:* = 0;
            var j:* = 0;
            var item:* = null;
            var oldItem:* = null;
            var rowData:* = null;
            var data:* = null;
            var wrappedData:* = null;
            var uid:* = null;
            var rh:* = NaN;
            var ld:* = null;
            var rr:* = null;
            var rowInfo:* = null;
            var dx:* = NaN;
            var dy:* = NaN;
            var dw:* = NaN;
            var dh:* = NaN;
            var left:* = _arg1;
            var top:* = _arg2;
            var right:* = _arg3;
            var bottom:* = _arg4;
            var firstCol:* = _arg5;
            var firstRow:* = _arg6;
            var byCount:Boolean = _arg7;
            var rowsNeeded:int = _arg8;
            listContent.allowItemSizeChangeNotification = false;
            var paddingLeft:* = getStyle("paddingLeft");
            var paddingRight:* = getStyle("paddingRight");
            var xx:* = ((left + paddingLeft) - horizontalScrollPosition);
            var ww:* = ((right - paddingLeft) - paddingRight);
            var bSelected:* = false;
            var bHighlight:* = false;
            var bCaret:* = false;
            var colNum:* = 0;
            var rowNum:* = lockedRowCount;
            var rowsMade:* = 0;
            var more:* = true;
            var valid:* = true;
            yy = top;
            rowNum = firstRow;
            more = ((((!((iterator == null))) && (!(iterator.afterLast)))) && (iteratorValid));
            while (((((!(byCount)) && ((yy < bottom)))) || (((byCount) && ((rowsNeeded > 0)))))) {
                if (byCount){
                    rowsNeeded = (rowsNeeded - 1);
                };
                valid = more;
                wrappedData = ((more) ? iterator.current : null);
                data = (((wrappedData is ItemWrapper)) ? wrappedData.data : wrappedData);
                uid = null;
                if (!listItems[rowNum]){
                    listItems[rowNum] = [];
                };
                if (valid){
                    item = listItems[rowNum][colNum];
                    uid = itemToUID(wrappedData);
                    if (((!(item)) || (((((runningDataEffect) && (dataItemWrappersByRenderer[item]))) ? !((dataItemWrappersByRenderer[item] == wrappedData)) : !((item.data == data)))))){
                        if (allowRendererStealingDuringLayout){
                            item = visibleData[uid];
                            if (((!(item)) && (!((wrappedData == data))))){
                                item = visibleData[itemToUID(data)];
                            };
                        };
                        if (item){
                            ld = BaseListData(rowMap[item.name]);
                            if (((ld) && ((ld.rowIndex > rowNum)))){
                                listItems[ld.rowIndex] = [];
                            } else {
                                item = null;
                            };
                        };
                        if (!item){
                            item = getReservedOrFreeItemRenderer(wrappedData);
                        };
                        if (!item){
                            item = createItemRenderer(data);
                            item.owner = this;
                            item.styleName = listContent;
                            listContent.addChild(DisplayObject(item));
                        };
                        oldItem = listItems[rowNum][colNum];
                        if (oldItem){
                            addToFreeItemRenderers(oldItem);
                        };
                        listItems[rowNum][colNum] = item;
                    };
                    rowData = makeListData(data, uid, rowNum);
                    rowMap[item.name] = rowData;
                    if ((item is IDropInListItemRenderer)){
                        if (data != null){
                            IDropInListItemRenderer(item).listData = rowData;
                        } else {
                            IDropInListItemRenderer(item).listData = null;
                        };
                    };
                    item.data = data;
                    item.enabled = enabled;
                    item.visible = true;
                    if (uid != null){
                        visibleData[uid] = item;
                    };
                    if (wrappedData != data){
                        dataItemWrappersByRenderer[item] = wrappedData;
                    };
                    item.explicitWidth = ww;
                    if ((((item is IInvalidating)) && (((wordWrapChanged) || (variableRowHeight))))){
                        IInvalidating(item).invalidateSize();
                    };
                    UIComponentGlobals.layoutManager.validateClient(item, true);
                    hh = Math.ceil(((variableRowHeight) ? ((item.getExplicitOrMeasuredHeight() + cachedPaddingTop) + cachedPaddingBottom) : rowHeight));
                    rh = item.getExplicitOrMeasuredHeight();
                    item.setActualSize(ww, ((variableRowHeight) ? rh : ((rowHeight - cachedPaddingTop) - cachedPaddingBottom)));
                    item.move(xx, (yy + cachedPaddingTop));
                } else {
                    hh = (((rowNum > 0)) ? rowInfo[(rowNum - 1)].height : rowHeight);
                    if (hh == 0){
                        hh = rowHeight;
                    };
                    oldItem = listItems[rowNum][colNum];
                    if (oldItem){
                        addToFreeItemRenderers(oldItem);
                        listItems[rowNum].splice(colNum, 1);
                    };
                };
                bSelected = !((selectedData[uid] == null));
                if (wrappedData != data){
                    bSelected = ((bSelected) || (selectedData[itemToUID(data)]));
                    bSelected = ((((bSelected) && (!(getRendererSemanticValue(item, ModifiedCollectionView.REPLACEMENT))))) && (!(getRendererSemanticValue(item, ModifiedCollectionView.ADDED))));
                };
                bHighlight = (highlightUID == uid);
                bCaret = (caretUID == uid);
                rowInfo[rowNum] = new ListRowInfo(yy, hh, uid, data);
                if (valid){
                    drawItem(item, bSelected, bHighlight, bCaret);
                };
                yy = (yy + hh);
                rowNum = (rowNum + 1);
                rowsMade = (rowsMade + 1);
                if (((iterator) && (more))){
                    try {
                        more = iterator.moveNext();
                    } catch(e:ItemPendingError) {
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, 0);
                        e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                        more = false;
                        iteratorValid = false;
                    };
                };
            };
            if (!byCount){
                while (rowNum < listItems.length) {
                    rr = listItems.pop();
                    rowInfo.pop();
                    while (rr.length) {
                        item = rr.pop();
                        addToFreeItemRenderers(item);
                    };
                };
            };
            if (itemEditorInstance){
                listContent.setChildIndex(DisplayObject(itemEditorInstance), (listContent.numChildren - 1));
                item = listItems[actualRowIndex][actualColIndex];
                rowInfo = rowInfo[actualRowIndex];
                if (((item) && (!(rendererIsEditor)))){
                    dx = editorXOffset;
                    dy = editorYOffset;
                    dw = editorWidthOffset;
                    dh = editorHeightOffset;
                    layoutEditor((item.x + dx), (rowInfo.y + dy), Math.min((item.width + dw), ((listContent.width - listContent.x) - itemEditorInstance.x)), Math.min((rowInfo.height + dh), ((listContent.height - listContent.y) - itemEditorInstance.y)));
                };
            };
            listContent.allowItemSizeChangeNotification = variableRowHeight;
            return (new Point(colNum, rowsMade));
        }
        override protected function measure():void{
            super.measure();
            var _local1:EdgeMetrics = viewMetrics;
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            if (((((((initialized) && (variableRowHeight))) && ((explicitRowCount < 1)))) && (isNaN(explicitRowHeight)))){
                measuredHeight = height;
            };
        }
        private function findNextItemRenderer(_arg1:Boolean):Boolean{
            if (!lastEditedItemPosition){
                return (false);
            };
            if (_proposedEditedItemPosition !== undefined){
                return (true);
            };
            _editedItemPosition = lastEditedItemPosition;
            var _local2:int = _editedItemPosition.rowIndex;
            var _local3:int = _editedItemPosition.columnIndex;
            var _local4:int = (_editedItemPosition.rowIndex + ((_arg1) ? -1 : 1));
            if ((((_local4 < collection.length)) && ((_local4 >= 0)))){
                _local2 = _local4;
            } else {
                setEditedItemPosition(null);
                losingFocus = true;
                setFocus();
                return (false);
            };
            var _local5:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING, false, true);
            _local5.rowIndex = _local2;
            _local5.columnIndex = _local3;
            dispatchEvent(_local5);
            return (true);
        }
        override protected function mouseDownHandler(_arg1:MouseEvent):void{
            var _local2:IListItemRenderer;
            var _local3:Sprite;
            var _local5:Point;
            var _local6:Boolean;
            _local2 = mouseEventToItemRenderer(_arg1);
            var _local4:Boolean = itemRendererContains(itemEditorInstance, DisplayObject(_arg1.target));
            if (!_local4){
                if (((_local2) && (_local2.data))){
                    _local5 = itemRendererToIndices(_local2);
                    _local6 = true;
                    if (itemEditorInstance){
                        _local6 = endEdit(ListEventReason.NEW_ROW);
                    };
                    if (!_local6){
                        return;
                    };
                } else {
                    if (itemEditorInstance){
                        endEdit(ListEventReason.OTHER);
                    };
                };
                super.mouseDownHandler(_arg1);
            };
        }
        override protected function keyDownHandler(_arg1:KeyboardEvent):void{
            if (itemEditorInstance){
                return;
            };
            super.keyDownHandler(_arg1);
        }
        override protected function focusInHandler(_arg1:FocusEvent):void{
            var _local2:Boolean;
            if (_arg1.target != this){
                return;
            };
            if (losingFocus){
                losingFocus = false;
                return;
            };
            super.focusInHandler(_arg1);
            if (((editable) && (!(isPressed)))){
                _editedItemPosition = lastEditedItemPosition;
                _local2 = !((editedItemPosition == null));
                if (!_editedItemPosition){
                    _editedItemPosition = {
                        rowIndex:0,
                        columnIndex:0
                    };
                    _local2 = ((listItems.length) && ((listItems[0].length > 0)));
                };
                if (_local2){
                    setEditedItemPosition(_editedItemPosition);
                };
            };
            if (editable){
                addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
                addEventListener(MouseEvent.MOUSE_DOWN, mouseFocusChangeHandler);
            };
        }
        override protected function mouseEventToItemRenderer(_arg1:MouseEvent):IListItemRenderer{
            var _local2:IListItemRenderer = super.mouseEventToItemRenderer(_arg1);
            return ((((_local2 == itemEditorInstance)) ? null : _local2));
        }
        protected function makeListData(_arg1:Object, _arg2:String, _arg3:int):BaseListData{
            return (new ListData(itemToLabel(_arg1), itemToIcon(_arg1), labelField, _arg2, this, _arg3));
        }
        public function createItemEditor(_arg1:int, _arg2:int):void{
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            _arg1 = 0;
            if (_arg2 > lockedRowCount){
                _arg2 = (_arg2 - verticalScrollPosition);
            };
            var _local3:IListItemRenderer = listItems[_arg2][_arg1];
            var _local4:ListRowInfo = rowInfo[_arg2];
            if (!rendererIsEditor){
                _local5 = 0;
                _local6 = -2;
                _local7 = 0;
                _local8 = 4;
                if (!itemEditorInstance){
                    _local5 = editorXOffset;
                    _local6 = editorYOffset;
                    _local7 = editorWidthOffset;
                    _local8 = editorHeightOffset;
                    itemEditorInstance = itemEditor.newInstance();
                    itemEditorInstance.owner = this;
                    itemEditorInstance.styleName = this;
                    listContent.addChild(DisplayObject(itemEditorInstance));
                };
                listContent.setChildIndex(DisplayObject(itemEditorInstance), (listContent.numChildren - 1));
                itemEditorInstance.visible = true;
                layoutEditor((_local3.x + _local5), (_local4.y + _local6), Math.min((_local3.width + _local7), ((listContent.width - listContent.x) - itemEditorInstance.x)), Math.min((_local4.height + _local8), ((listContent.height - listContent.y) - itemEditorInstance.y)));
                DisplayObject(itemEditorInstance).addEventListener("focusOut", itemEditorFocusOutHandler);
            } else {
                itemEditorInstance = _local3;
            };
            DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
            systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN, editorMouseDownHandler, true, 0, true);
            systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, editorMouseDownHandler, false, 0, true);
        }
        public function get lockedRowCount():int{
            return (_lockedRowCount);
        }
        override public function set enabled(_arg1:Boolean):void{
            super.enabled = _arg1;
            if (itemEditorInstance){
                endEdit(ListEventReason.OTHER);
            };
            invalidateDisplayList();
        }
        protected function endEdit(_arg1:String):Boolean{
            if (!editedItemRenderer){
                return (true);
            };
            inEndEdit = true;
            var _local2:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_END, false, true);
            _local2.rowIndex = editedItemPosition.rowIndex;
            _local2.itemRenderer = editedItemRenderer;
            _local2.reason = _arg1;
            dispatchEvent(_local2);
            dontEdit = !((itemEditorInstance == null));
            if (((!(dontEdit)) && ((_arg1 == ListEventReason.CANCELLED)))){
                losingFocus = true;
                setFocus();
            };
            inEndEdit = false;
            return (!(_local2.isDefaultPrevented()));
        }
        override protected function collectionChangeHandler(_arg1:Event):void{
            var _local2:CollectionEvent;
            if ((_arg1 is CollectionEvent)){
                _local2 = CollectionEvent(_arg1);
                if (_local2.kind == CollectionEventKind.REMOVE){
                    if (editedItemPosition){
                        if (collection.length == 0){
                            if (itemEditorInstance){
                                endEdit(ListEventReason.CANCELLED);
                            };
                            setEditedItemPosition(null);
                        } else {
                            if (_local2.location <= editedItemPosition.rowIndex){
                                if (inEndEdit){
                                    _editedItemPosition = {
                                        columnIndex:editedItemPosition.columnIndex,
                                        rowIndex:Math.max(0, (editedItemPosition.rowIndex - _local2.items.length))
                                    };
                                } else {
                                    setEditedItemPosition({
                                        columnIndex:editedItemPosition.columnIndex,
                                        rowIndex:Math.max(0, (editedItemPosition.rowIndex - _local2.items.length))
                                    });
                                };
                            };
                        };
                    };
                };
            };
            super.collectionChangeHandler(_arg1);
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                if (((listItems.length) && (listItems[0].length))){
                    return (((borderMetrics.top + cachedPaddingTop) + listItems[0][0].baselinePosition));
                };
                return (NaN);
            };
            return (super.baselinePosition);
        }
        private function itemEditorFocusOutHandler(_arg1:FocusEvent):void{
            if (((_arg1.relatedObject) && (contains(_arg1.relatedObject)))){
                return;
            };
            if (!_arg1.relatedObject){
                return;
            };
            if (itemEditorInstance){
                endEdit(ListEventReason.OTHER);
            };
        }
        override public function set dataProvider(_arg1:Object):void{
            if (itemEditorInstance){
                endEdit(ListEventReason.OTHER);
            };
            super.dataProvider = _arg1;
        }
        override protected function initializeAccessibility():void{
            if (createAccessibilityImplementation != null){
                createAccessibilityImplementation(this);
            };
        }
        override protected function configureScrollBars():void{
            var _local2:Number;
            var _local3:int;
            var _local1:int = listItems.length;
            if (_local1 == 0){
                return;
            };
            var _local4:int = listItems.length;
            while ((((_local1 > 1)) && (((rowInfo[(_local4 - 1)].y + rowInfo[(_local4 - 1)].height) > (listContent.height - listContent.bottomOffset))))) {
                _local1--;
                _local4--;
            };
            var _local5:int = ((verticalScrollPosition - lockedRowCount) - 1);
            var _local6:int;
            while (((_local1) && ((listItems[(_local1 - 1)].length == 0)))) {
                if (((collection) && (((_local1 + _local5) >= collection.length)))){
                    _local1--;
                    _local6++;
                } else {
                    break;
                };
            };
            if ((((((verticalScrollPosition > 0)) && ((_local6 > 0)))) && (!(runningDataEffect)))){
                if (adjustVerticalScrollPositionDownward(Math.max(_local1, 1))){
                    return;
                };
            };
            if (listContent.topOffset){
                _local2 = Math.abs(listContent.topOffset);
                _local3 = 0;
                while ((rowInfo[_local3].y + rowInfo[_local3].height) <= _local2) {
                    _local1--;
                    _local3++;
                    if (_local3 == _local1){
                        break;
                    };
                };
            };
            var _local7:int = listItems[0].length;
            var _local8:Object = horizontalScrollBar;
            var _local9:Object = verticalScrollBar;
            var _local10:int = Math.round(unscaledWidth);
            var _local11:int = ((collection) ? (collection.length - lockedRowCount) : 0);
            var _local12:int = (_local1 - lockedRowCount);
            setScrollBarProperties(((isNaN(_maxHorizontalScrollPosition)) ? Math.round(listContent.width) : Math.round((_maxHorizontalScrollPosition + _local10))), _local10, _local11, _local12);
            maxVerticalScrollPosition = Math.max((_local11 - _local12), 0);
        }
        override protected function mouseWheelHandler(_arg1:MouseEvent):void{
            if (itemEditorInstance){
                endEdit(ListEventReason.OTHER);
            };
            super.mouseWheelHandler(_arg1);
        }
        override public function set maxHorizontalScrollPosition(_arg1:Number):void{
            super.maxHorizontalScrollPosition = _arg1;
            scrollAreaChanged = true;
            invalidateDisplayList();
        }
        override protected function scrollHandler(_arg1:Event):void{
            var scrollBar:* = null;
            var pos:* = NaN;
            var delta:* = 0;
            var o:* = null;
            var bookmark:* = null;
            var event:* = _arg1;
            if ((event is ScrollEvent)){
                if (itemEditorInstance){
                    endEdit(ListEventReason.OTHER);
                };
                if (((!(liveScrolling)) && ((ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)))){
                    return;
                };
                scrollBar = ScrollBar(event.target);
                pos = scrollBar.scrollPosition;
                removeClipMask();
                if (scrollBar == verticalScrollBar){
                    delta = (pos - verticalScrollPosition);
                    super.scrollHandler(event);
                    if ((((Math.abs(delta) >= (listItems.length - lockedRowCount))) || (!(iteratorValid)))){
                        try {
                            if (!iteratorValid){
                                iterator.seek(CursorBookmark.FIRST, pos);
                            } else {
                                iterator.seek(CursorBookmark.CURRENT, delta);
                            };
                            if (!iteratorValid){
                                iteratorValid = true;
                                lastSeekPending = null;
                            };
                        } catch(e:ItemPendingError) {
                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos);
                            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                            iteratorValid = false;
                        };
                        bookmark = iterator.bookmark;
                        clearIndicators();
                        clearVisibleData();
                        makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
                        iterator.seek(bookmark, 0);
                    } else {
                        if (delta != 0){
                            scrollVertically(pos, Math.abs(delta), Boolean((delta > 0)));
                        };
                    };
                    if (variableRowHeight){
                        configureScrollBars();
                    };
                    drawRowBackgrounds();
                } else {
                    delta = (pos - _horizontalScrollPosition);
                    super.scrollHandler(event);
                    scrollHorizontally(pos, Math.abs(delta), Boolean((delta > 0)));
                };
                addClipMask(false);
            };
        }
        public function get editedItemRenderer():IListItemRenderer{
            if (!itemEditorInstance){
                return (null);
            };
            return (listItems[actualRowIndex][actualColIndex]);
        }
        private function commitEditedItemPosition(_arg1:Object):void{
            var _local10:String;
            if (((!(enabled)) || (!(editable)))){
                return;
            };
            if (((((((itemEditorInstance) && (_arg1))) && ((itemEditorInstance is IFocusManagerComponent)))) && ((_editedItemPosition.rowIndex == _arg1.rowIndex)))){
                IFocusManagerComponent(itemEditorInstance).setFocus();
                return;
            };
            if (itemEditorInstance){
                if (!_arg1){
                    _local10 = ListEventReason.OTHER;
                } else {
                    _local10 = ListEventReason.NEW_ROW;
                };
                if (((!(endEdit(_local10))) && (!((_local10 == ListEventReason.OTHER))))){
                    return;
                };
            };
            _editedItemPosition = _arg1;
            if (((!(_arg1)) || (dontEdit))){
                return;
            };
            var _local2:int = _arg1.rowIndex;
            var _local3:int = _arg1.columnIndex;
            if (selectedIndex != _arg1.rowIndex){
                commitSelectedIndex(_arg1.rowIndex);
            };
            var _local4:int = lockedRowCount;
            var _local5:int = ((((verticalScrollPosition + listItems.length) - offscreenExtraRowsTop) - offscreenExtraRowsBottom) - 1);
            var _local6:int = (((rowInfo[((listItems.length - offscreenExtraRowsBottom) - 1)].y + rowInfo[((listItems.length - offscreenExtraRowsBottom) - 1)].height))>listContent.height) ? 1 : 0;
            if (_local2 > _local4){
                if (_local2 < (verticalScrollPosition + _local4)){
                    verticalScrollPosition = (_local2 - _local4);
                } else {
                    while ((((_local2 > _local5)) || ((((((_local2 == _local5)) && ((_local2 > (verticalScrollPosition + _local4))))) && (_local6))))) {
                        if (verticalScrollPosition == maxVerticalScrollPosition){
                            break;
                        };
                        verticalScrollPosition = Math.min((verticalScrollPosition + (((_local2 > _local5)) ? (_local2 - _local5) : _local6)), maxVerticalScrollPosition);
                        _local5 = ((((verticalScrollPosition + listItems.length) - offscreenExtraRowsTop) - offscreenExtraRowsBottom) - 1);
                        _local6 = (((rowInfo[((listItems.length - offscreenExtraRowsBottom) - 1)].y + rowInfo[((listItems.length - offscreenExtraRowsBottom) - 1)].height))>listContent.height) ? 1 : 0;
                    };
                };
                actualRowIndex = (_local2 - verticalScrollPosition);
            } else {
                if (_local2 == _local4){
                    verticalScrollPosition = 0;
                };
                actualRowIndex = _local2;
            };
            var _local7:EdgeMetrics = borderMetrics;
            actualColIndex = _local3;
            var _local8:IListItemRenderer = listItems[actualRowIndex][actualColIndex];
            if (!_local8){
                commitEditedItemPosition(null);
                return;
            };
            if (!isItemEditable(_local8.data)){
                commitEditedItemPosition(null);
                return;
            };
            var _local9:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGIN, false, true);
            _local9.rowIndex = _editedItemPosition.rowIndex;
            _local9.itemRenderer = _local8;
            dispatchEvent(_local9);
            lastEditedItemPosition = _editedItemPosition;
            if (bEditedItemPositionChanged){
                bEditedItemPositionChanged = false;
                commitEditedItemPosition(_proposedEditedItemPosition);
                _proposedEditedItemPosition = undefined;
            };
            if (!itemEditorInstance){
                commitEditedItemPosition(null);
            };
        }
        protected function drawRowBackground(_arg1:Sprite, _arg2:int, _arg3:Number, _arg4:Number, _arg5:uint, _arg6:int):void{
            var _local7:Shape;
            if (_arg2 < _arg1.numChildren){
                _local7 = Shape(_arg1.getChildAt(_arg2));
            } else {
                _local7 = new FlexShape();
                _local7.name = "rowBackground";
                _arg1.addChild(_local7);
            };
            _arg4 = Math.min(rowInfo[_arg2].height, (listContent.height - rowInfo[_arg2].y));
            _local7.y = rowInfo[_arg2].y;
            var _local8:Graphics = _local7.graphics;
            _local8.clear();
            _local8.beginFill(_arg5, getStyle("backgroundAlpha"));
            _local8.drawRect(0, 0, listContent.width, _arg4);
            _local8.endFill();
        }
        override protected function commitProperties():void{
            var _local1:Number;
            var _local2:Number;
            var _local3:IListItemRenderer;
            var _local4:Number;
            var _local5:int;
            super.commitProperties();
            if (itemsNeedMeasurement){
                itemsNeedMeasurement = false;
                if (isNaN(explicitRowHeight)){
                    if (iterator){
                        _local1 = getStyle("paddingTop");
                        _local2 = getStyle("paddingBottom");
                        _local3 = getMeasuringRenderer(iterator.current);
                        _local4 = 200;
                        if (listContent.width){
                            _local4 = listContent.width;
                        };
                        _local3.explicitWidth = _local4;
                        setupRendererFromData(_local3, iterator.current);
                        _local5 = ((_local3.getExplicitOrMeasuredHeight() + _local1) + _local2);
                        setRowHeight(Math.max(_local5, 20));
                    } else {
                        setRowHeight(20);
                    };
                };
                if (isNaN(explicitColumnWidth)){
                    setColumnWidth(measureWidthOfItems(0, ((explicitRowCount)<1) ? defaultRowCount : explicitRowCount));
                };
            };
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
        private function adjustVerticalScrollPositionDownward(_arg1:int):Boolean{
            var n:* = 0;
            var j:* = 0;
            var more:* = false;
            var data:* = null;
            var rowCount:* = _arg1;
            var bookmark:* = iterator.bookmark;
            var h:* = 0;
            var ch:* = 0;
            var paddingTop:* = getStyle("paddingTop");
            var paddingBottom:* = getStyle("paddingBottom");
            var paddingLeft:* = getStyle("paddingLeft");
            var paddingRight:* = getStyle("paddingRight");
            h = (rowInfo[(rowCount - 1)].y + rowInfo[(rowCount - 1)].height);
            h = ((listContent.heightExcludingOffsets - listContent.topOffset) - h);
            var numRows:* = 0;
            try {
                if (iterator.afterLast){
                    iterator.seek(CursorBookmark.LAST, 0);
                } else {
                    more = iterator.movePrevious();
                };
            } catch(e:ItemPendingError) {
                more = false;
            };
            if (!more){
                super.verticalScrollPosition = 0;
                try {
                    iterator.seek(CursorBookmark.FIRST, 0);
                    if (!iteratorValid){
                        iteratorValid = true;
                        lastSeekPending = null;
                    };
                } catch(e:ItemPendingError) {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                    e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, lastSeekPending));
                    iteratorValid = false;
                    invalidateList();
                    return (true);
                };
                updateList();
                return (true);
            };
            var item:* = getMeasuringRenderer(iterator.current);
            item.explicitWidth = ((listContent.width - paddingLeft) - paddingRight);
            while ((((h > 0)) && (more))) {
                if (more){
                    data = iterator.current;
                    setupRendererFromData(item, data);
                    ch = ((variableRowHeight) ? ((item.getExplicitOrMeasuredHeight() + paddingBottom) + paddingTop) : rowHeight);
                };
                h = (h - ch);
                try {
                    more = iterator.movePrevious();
                    numRows = (numRows + 1);
                } catch(e:ItemPendingError) {
                    more = false;
                };
            };
            if (h < 0){
                numRows = (numRows - 1);
            };
            iterator.seek(bookmark, 0);
            verticalScrollPosition = Math.max(0, (verticalScrollPosition - numRows));
            if ((((numRows > 0)) && (!(variableRowHeight)))){
                configureScrollBars();
            };
            return ((numRows > 0));
        }
        public function isItemEditable(_arg1:Object):Boolean{
            if (!editable){
                return (false);
            };
            if (_arg1 == null){
                return (false);
            };
            return (true);
        }
        override protected function adjustListContent(_arg1:Number=-1, _arg2:Number=-1):void{
            var _local3:Number = (viewMetrics.left + Math.max(listContent.leftOffset, 0));
            var _local4:Number = (viewMetrics.top + listContent.topOffset);
            listContent.move(_local3, _local4);
            var _local5:Number = ((Math.max(0, listContent.rightOffset) - _local3) - viewMetrics.right);
            var _local6:Number = ((Math.max(0, listContent.bottomOffset) - _local4) - viewMetrics.bottom);
            var _local7:Number = (_arg1 + _local5);
            if ((((horizontalScrollPolicy == ScrollPolicy.ON)) || ((((horizontalScrollPolicy == ScrollPolicy.AUTO)) && (!(isNaN(_maxHorizontalScrollPosition))))))){
                if (isNaN(_maxHorizontalScrollPosition)){
                    _local7 = (_local7 * 2);
                } else {
                    _local7 = (_local7 + _maxHorizontalScrollPosition);
                };
            };
            listContent.setActualSize(_local7, (_arg2 + _local6));
        }
        private function editorMouseDownHandler(_arg1:Event):void{
            if ((((_arg1 is MouseEvent)) && (itemRendererContains(itemEditorInstance, DisplayObject(_arg1.target))))){
                return;
            };
            endEdit(ListEventReason.OTHER);
        }
        override public function set itemRenderer(_arg1:IFactory):void{
            super.itemRenderer = _arg1;
            purgeMeasuringRenderers();
        }
        mx_internal function setupRendererFromData(_arg1:IListItemRenderer, _arg2:Object):void{
            var _local3:Object = (((_arg2 is ItemWrapper)) ? _arg2.data : _arg2);
            if ((_arg1 is IDropInListItemRenderer)){
                if (_local3 != null){
                    IDropInListItemRenderer(_arg1).listData = makeListData(_local3, itemToUID(_arg2), 0);
                } else {
                    IDropInListItemRenderer(_arg1).listData = null;
                };
            };
            _arg1.data = _local3;
            if ((_arg1 is IInvalidating)){
                IInvalidating(_arg1).invalidateSize();
            };
            UIComponentGlobals.layoutManager.validateClient(_arg1, true);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            setRowCount(listItems.length);
            if (((bEditedItemPositionChanged) && (!(editingTemporarilyPrevented(_proposedEditedItemPosition))))){
                bEditedItemPositionChanged = false;
                commitEditedItemPosition(_proposedEditedItemPosition);
                _proposedEditedItemPosition = undefined;
            };
            drawRowBackgrounds();
        }
        public function destroyItemEditor():void{
            var _local1:ListEvent;
            if (itemEditorInstance){
                DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
                systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN, editorMouseDownHandler, true);
                systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, editorMouseDownHandler);
                _local1 = new ListEvent(ListEvent.ITEM_FOCUS_OUT);
                _local1.rowIndex = _editedItemPosition.rowIndex;
                _local1.itemRenderer = editedItemRenderer;
                dispatchEvent(_local1);
                if (!rendererIsEditor){
                    if (((itemEditorInstance) && ((itemEditorInstance is UIComponent)))){
                        UIComponent(itemEditorInstance).drawFocus(false);
                    };
                    listContent.removeChild(DisplayObject(itemEditorInstance));
                };
                itemEditorInstance = null;
                _editedItemPosition = null;
            };
        }
        mx_internal function callMakeListData(_arg1:Object, _arg2:String, _arg3:int):BaseListData{
            return (makeListData(_arg1, _arg2, _arg3));
        }
        public function set lockedRowCount(_arg1:int):void{
            _lockedRowCount = _arg1;
            invalidateDisplayList();
        }

    }
}//package mx.controls 
