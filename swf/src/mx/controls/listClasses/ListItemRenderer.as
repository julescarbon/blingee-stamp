package mx.controls.listClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import mx.events.*;

    public class ListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _listData:ListData;
        private var _data:Object;
        protected var label:IUITextField;
        private var listOwner:ListBase;
        protected var icon:IFlexDisplayObject;

        public function ListItemRenderer(){
            addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        mx_internal function getLabel():IUITextField{
            return (label);
        }
        override protected function commitProperties():void{
            var _local2:Class;
            super.commitProperties();
            var _local1 = -1;
            if (((hasFontContextChanged()) && (!((label == null))))){
                _local1 = getChildIndex(DisplayObject(label));
                removeChild(DisplayObject(label));
                label = null;
            };
            if (!label){
                label = IUITextField(createInFontContext(UITextField));
                label.styleName = this;
                if (_local1 == -1){
                    addChild(DisplayObject(label));
                } else {
                    addChildAt(DisplayObject(label), _local1);
                };
            };
            if (icon){
                removeChild(DisplayObject(icon));
                icon = null;
            };
            if (_data != null){
                listOwner = ListBase(_listData.owner);
                if (_listData.icon){
                    _local2 = _listData.icon;
                    icon = new (_local2)();
                    addChild(DisplayObject(icon));
                };
                label.text = ((_listData.label) ? _listData.label : " ");
                label.multiline = listOwner.variableRowHeight;
                label.wordWrap = listOwner.wordWrap;
                if (listOwner.showDataTips){
                    if ((((label.textWidth > label.width)) || (!((listOwner.dataTipFunction == null))))){
                        toolTip = listOwner.itemToDataTip(_data);
                    } else {
                        toolTip = null;
                    };
                } else {
                    toolTip = null;
                };
            } else {
                label.text = " ";
                toolTip = null;
            };
        }
        protected function toolTipShowHandler(_arg1:ToolTipEvent):void{
            var _local5:Rectangle;
            var _local8:InterManagerRequest;
            var _local2:IToolTip = _arg1.toolTip;
            var _local3:ISystemManager = systemManager.topLevelSystemManager;
            var _local4:DisplayObject = _local3.getSandboxRoot();
            var _local6:Point = new Point(0, 0);
            _local6 = label.localToGlobal(_local6);
            _local6 = _local4.globalToLocal(_local6);
            _local2.move(_local6.x, (_local6.y + ((height - _local2.height) / 2)));
            if (_local3 != _local4){
                _local8 = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, false, false, "getVisibleApplicationRect");
                _local4.dispatchEvent(_local8);
                _local5 = Rectangle(_local8.value);
            } else {
                _local5 = _local3.getVisibleApplicationRect();
            };
            var _local7:Number = (_local5.x + _local5.width);
            _local6.x = _local2.x;
            _local6.y = _local2.y;
            _local6 = _local4.localToGlobal(_local6);
            if ((_local6.x + _local2.width) > _local7){
                _local2.move((_local2.x - ((_local6.x + _local2.width) - _local7)), _local2.y);
            };
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = ListData(_arg1);
            invalidateProperties();
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            invalidateProperties();
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                if (!label){
                    return (0);
                };
                return (label.baselinePosition);
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((label.y + label.baselinePosition));
        }
        override protected function measure():void{
            super.measure();
            var _local1:Number = 0;
            if (icon){
                _local1 = icon.measuredWidth;
            };
            if ((((label.width < 4)) || ((label.height < 4)))){
                label.width = 4;
                label.height = 16;
            };
            if (isNaN(explicitWidth)){
                _local1 = (_local1 + label.getExplicitOrMeasuredWidth());
                measuredWidth = _local1;
                measuredHeight = label.getExplicitOrMeasuredHeight();
            } else {
                measuredWidth = explicitWidth;
                label.setActualSize(Math.max((explicitWidth - _local1), 4), label.height);
                measuredHeight = label.getExplicitOrMeasuredHeight();
                if (((icon) && ((icon.measuredHeight > measuredHeight)))){
                    measuredHeight = icon.measuredHeight;
                };
            };
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        override protected function createChildren():void{
            super.createChildren();
            if (!label){
                label = IUITextField(createInFontContext(UITextField));
                label.styleName = this;
                addChild(DisplayObject(label));
            };
        }
        public function get data():Object{
            return (_data);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local5:Number;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = 0;
            if (icon){
                icon.x = _local3;
                _local3 = (icon.x + icon.measuredWidth);
                icon.setActualSize(icon.measuredWidth, icon.measuredHeight);
            };
            label.x = _local3;
            label.setActualSize((_arg1 - _local3), measuredHeight);
            var _local4:String = getStyle("verticalAlign");
            if (_local4 == "top"){
                label.y = 0;
                if (icon){
                    icon.y = 0;
                };
            } else {
                if (_local4 == "bottom"){
                    label.y = ((_arg2 - label.height) + 2);
                    if (icon){
                        icon.y = (_arg2 - icon.height);
                    };
                } else {
                    label.y = ((_arg2 - label.height) / 2);
                    if (icon){
                        icon.y = ((_arg2 - icon.height) / 2);
                    };
                };
            };
            if (((data) && (parent))){
                if (!enabled){
                    _local5 = getStyle("disabledColor");
                } else {
                    if (listOwner.isItemHighlighted(listData.uid)){
                        _local5 = getStyle("textRollOverColor");
                    } else {
                        if (listOwner.isItemSelected(listData.uid)){
                            _local5 = getStyle("textSelectedColor");
                        } else {
                            _local5 = getStyle("color");
                        };
                    };
                };
                label.setColor(_local5);
            };
        }

    }
}//package mx.controls.listClasses 
