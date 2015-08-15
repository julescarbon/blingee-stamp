package flexlib.controls {
    import flash.display.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.*;
    import mx.containers.*;
    import mx.collections.*;
    import flexlib.controls.tabBarClasses.*;
    import flexlib.events.*;

    public class SuperTabBar extends TabBar {

        public static const TABS_REORDERED:String = "tabsReordered";

        private var _closePolicy:String = "close_rollover";
        private var _dropEnabled:Boolean = true;
        private var _dragEnabled:Boolean = true;

        public function SuperTabBar(){
            navItemFactory = new ClassFactory(SuperTab);
        }
        public function getClosePolicyForTab(_arg1:int):String{
            return ((getChildAt(_arg1) as SuperTab).closePolicy);
        }
        private function removeDragListeners(_arg1:SuperTab):void{
            _arg1.removeEventListener(MouseEvent.MOUSE_DOWN, tryDrag);
            _arg1.removeEventListener(MouseEvent.MOUSE_UP, removeDrag);
        }
        public function get closePolicy():String{
            return (_closePolicy);
        }
        public function onCloseTabClicked(_arg1:Event):void{
            var _local2:int = getChildIndex(DisplayObject(_arg1.currentTarget));
            if ((dataProvider is IList)){
                dataProvider.removeItemAt(_local2);
            } else {
                if ((dataProvider is ViewStack)){
                    dataProvider.removeChildAt(_local2);
                };
            };
        }
        private function tryDrag(_arg1:MouseEvent):void{
            _arg1.target.addEventListener(MouseEvent.MOUSE_MOVE, doDrag);
        }
        private function addDragListeners(_arg1:SuperTab):void{
            _arg1.addEventListener(MouseEvent.MOUSE_DOWN, tryDrag, false, 0, true);
            _arg1.addEventListener(MouseEvent.MOUSE_UP, removeDrag, false, 0, true);
        }
        public function set closePolicy(_arg1:String):void{
            var _local4:SuperTab;
            this._closePolicy = _arg1;
            this.invalidateDisplayList();
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = SuperTab(getChildAt(_local3));
                _local4.closePolicy = _arg1;
                _local3++;
            };
        }
        private function removeDrag(_arg1:MouseEvent):void{
            _arg1.target.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
        }
        public function get dropEnabled():Boolean{
            return (_dropEnabled);
        }
        public function set dragEnabled(_arg1:Boolean):void{
            var _local4:SuperTab;
            this._dragEnabled = _arg1;
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = SuperTab(getChildAt(_local3));
                if (_arg1){
                    addDragListeners(_local4);
                } else {
                    removeDragListeners(_local4);
                };
                _local3++;
            };
        }
        private function tabDragOver(_arg1:DragEvent):void{
            var _local2:SuperTab;
            var _local3:Number;
            var _local4:Number;
            var _local5:Boolean;
            if (((_arg1.dragSource.hasFormat("tabDrag")) && (!((_arg1.dragInitiator == _arg1.currentTarget))))){
                _local2 = (_arg1.currentTarget as SuperTab);
                _local3 = this.getChildIndex(_local2);
                _local4 = 0;
                _local5 = (_arg1.localX < (_local2.width / 2));
                if (((((_local5) && ((_local3 > 0)))) || ((_local3 < (this.numChildren - 1))))){
                    _local4 = (this.getStyle("horizontalGap") / 2);
                };
                _local4 = ((_local5) ? -(_local4) : (_local2.width + _local4));
                _local2.showIndicatorAt(_local4);
                DragManager.showFeedback(DragManager.LINK);
            };
        }
        private function doDrag(_arg1:MouseEvent):void{
            var _local2:SuperTab;
            var _local3:DragSource;
            var _local4:BitmapData;
            var _local5:Bitmap;
            var _local6:UIComponent;
            if ((((_arg1.target is IUIComponent)) && ((((IUIComponent(_arg1.target) is SuperTab)) || ((((IUIComponent(_arg1.target).parent is SuperTab)) && (!((IUIComponent(_arg1.target) is Button))))))))){
                if ((IUIComponent(_arg1.target) is SuperTab)){
                    _local2 = (IUIComponent(_arg1.target) as SuperTab);
                };
                if ((IUIComponent(_arg1.target).parent is SuperTab)){
                    _local2 = (IUIComponent(_arg1.target).parent as SuperTab);
                };
                _local3 = new DragSource();
                _local3.addData(_arg1.currentTarget, "tabDrag");
                if ((dataProvider is IList)){
                    _local3.addData(_arg1.currentTarget, "listDP");
                };
                if ((dataProvider is ViewStack)){
                    _local3.addData(_arg1.currentTarget, "stackDP");
                };
                _local4 = new BitmapData(_local2.width, _local2.height, true, 0);
                _local4.draw(_local2);
                _local5 = new Bitmap(_local4);
                _local6 = new UIComponent();
                _local6.addChild(_local5);
                _arg1.target.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
                DragManager.doDrag(IUIComponent(_arg1.target), _local3, _arg1, _local6);
            };
        }
        public function set dropEnabled(_arg1:Boolean):void{
            var _local4:SuperTab;
            this._dropEnabled = _arg1;
            var _local2:int = numChildren;
            var _local3:int;
            while (_local3 < _local2) {
                _local4 = SuperTab(getChildAt(_local3));
                if (_arg1){
                    addDropListeners(_local4);
                } else {
                    removeDropListeners(_local4);
                };
                _local3++;
            };
        }
        private function tabDragExit(_arg1:DragEvent):void{
            var _local2:SuperTab = (_arg1.currentTarget as SuperTab);
            _local2.showIndicator = false;
        }
        private function removeDropListeners(_arg1:SuperTab):void{
            _arg1.removeEventListener(DragEvent.DRAG_ENTER, tabDragEnter);
            _arg1.removeEventListener(DragEvent.DRAG_OVER, tabDragOver);
            _arg1.removeEventListener(DragEvent.DRAG_DROP, tabDragDrop);
            _arg1.removeEventListener(DragEvent.DRAG_EXIT, tabDragExit);
        }
        public function get dragEnabled():Boolean{
            return (_dragEnabled);
        }
        private function tabDragEnter(_arg1:DragEvent):void{
            if (((_arg1.dragSource.hasFormat("tabDrag")) && (!((_arg1.draggedItem == _arg1.dragInitiator))))){
                if ((this.dataProvider is ViewStack)){
                    if (_arg1.dragSource.hasFormat("stackDP")){
                        DragManager.acceptDragDrop(IUIComponent(_arg1.target));
                    };
                } else {
                    if ((this.dataProvider is IList)){
                        if (_arg1.dragSource.hasFormat("listDP")){
                            DragManager.acceptDragDrop(IUIComponent(_arg1.target));
                        };
                    };
                };
            };
        }
        public function setClosePolicyForTab(_arg1:int, _arg2:String):void{
            if (this.numChildren >= (_arg1 + 1)){
                (getChildAt(_arg1) as SuperTab).closePolicy = _arg2;
            };
        }
        private function addDropListeners(_arg1:SuperTab):void{
            _arg1.addEventListener(DragEvent.DRAG_ENTER, tabDragEnter, false, 0, true);
            _arg1.addEventListener(DragEvent.DRAG_OVER, tabDragOver, false, 0, true);
            _arg1.addEventListener(DragEvent.DRAG_DROP, tabDragDrop, false, 0, true);
            _arg1.addEventListener(DragEvent.DRAG_EXIT, tabDragExit, false, 0, true);
        }
        private function tabDragDrop(_arg1:DragEvent):void{
            var _local2:SuperTab;
            var _local3:SuperTab;
            var _local4:Boolean;
            var _local5:SuperTabBar;
            var _local6:*;
            var _local7:Number;
            var _local8:Number;
            if (((_arg1.dragSource.hasFormat("tabDrag")) && (!((_arg1.draggedItem == _arg1.dragInitiator))))){
                _local2 = (_arg1.currentTarget as SuperTab);
                _local3 = (_arg1.dragInitiator as SuperTab);
                _local4 = (_arg1.localX < (_local2.width / 2));
                _local6 = _arg1.dragInitiator;
                while (((_local6) && (_local6.parent))) {
                    _local6 = _local6.parent;
                    if ((_local6 is SuperTab)){
                        _local3 = _local6;
                    } else {
                        if ((_local6 is SuperTabBar)){
                            _local5 = _local6;
                            break;
                        };
                    };
                };
                _local2.showIndicator = false;
                _local7 = _local5.getChildIndex(_local3);
                _local8 = this.getChildIndex(_local2);
                if (!_local4){
                    _local8 = (_local8 + 1);
                };
                this.dispatchEvent(new TabReorderEvent(SuperTabBar.TABS_REORDERED, false, false, _local5, _local7, _local8));
            };
        }
        override protected function createNavItem(_arg1:String, _arg2:Class=null):IFlexDisplayObject{
            var _local3:SuperTab = (super.createNavItem(_arg1, _arg2) as SuperTab);
            _local3.closePolicy = this.closePolicy;
            if (dragEnabled){
                addDragListeners(_local3);
            };
            if (dropEnabled){
                addDropListeners(_local3);
            };
            _local3.addEventListener(SuperTab.CLOSE_TAB_EVENT, onCloseTabClicked, false, 0, true);
            return (_local3);
        }
        public function resetTabs():void{
            this.resetNavItems();
        }

    }
}//package flexlib.controls 
