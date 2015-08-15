package mx.controls.listClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import mx.events.*;

    public class TileListItemRenderer extends UIComponent implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer, IFontContextComponent {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var iconOnly:Boolean = false;
        private var _listData:ListData;
        private var _data:Object;
        protected var label:IUITextField;
        private var listOwner:TileBase;
        protected var icon:IFlexDisplayObject;
        private var iconClass:Class;

        public function TileListItemRenderer(){
            addEventListener(ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler);
        }
        public function set fontContext(_arg1:IFlexModuleFactory):void{
            this.moduleFactory = _arg1;
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local6:Number;
            var _local9:Number;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = ((iconOnly) ? 0 : getStyle("verticalGap"));
            var _local4:Number = getStyle("paddingLeft");
            var _local5:Number = getStyle("paddingRight");
            if (icon){
                icon.width = Math.min((_arg1 - (_local4 + _local5)), icon.measuredWidth);
                icon.height = Math.min(Math.max(((_arg2 - _local3) - label.getExplicitOrMeasuredHeight()), 0), icon.measuredHeight);
                icon.x = (_local4 + ((((_arg1 - _local4) - _local5) - icon.width) / 2));
            };
            label.width = (_arg1 - (_local4 + _local5));
            label.height = Math.min(label.getExplicitOrMeasuredHeight(), ((icon) ? Math.max(((_arg2 - _local3) - icon.height), 0) : _arg2));
            label.x = _local4;
            if (((listOwner) && (listOwner.showDataTips))){
                if ((((((label.textWidth > label.width)) || (((listOwner.dataTipField) && (!((listOwner.dataTipField == "label"))))))) || (!((listOwner.dataTipFunction == null))))){
                    toolTip = listOwner.itemToDataTip(_data);
                } else {
                    toolTip = null;
                };
            } else {
                toolTip = null;
            };
            var _local7:Number = label.height;
            if (icon){
                _local7 = (_local7 + (icon.height + _local3));
            };
            var _local8:String = getStyle("verticalAlign");
            if (_local8 == "top"){
                _local6 = 0;
                if (icon){
                    icon.y = _local6;
                    _local6 = (_local6 + (_local3 + icon.height));
                };
                label.y = _local6;
            } else {
                if (_local8 == "bottom"){
                    _local6 = (_arg2 - label.height);
                    label.y = _local6;
                    if (icon){
                        _local6 = (_local6 - (_local3 + icon.height));
                        icon.y = _local6;
                    };
                } else {
                    _local6 = ((_arg2 - _local7) / 2);
                    if (icon){
                        icon.y = _local6;
                        _local6 = (_local6 + (_local3 + icon.height));
                    };
                    label.y = _local6;
                };
            };
            if (((data) && (parent))){
                if (!enabled){
                    _local9 = getStyle("disabledColor");
                } else {
                    if (listOwner.isItemSelected(listData.uid)){
                        _local9 = getStyle("textSelectedColor");
                    } else {
                        if (listOwner.isItemHighlighted(listData.uid)){
                            _local9 = getStyle("textRollOverColor");
                        } else {
                            _local9 = getStyle("color");
                        };
                    };
                };
                label.setColor(_local9);
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
        mx_internal function getLabel():IUITextField{
            return (label);
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = ListData(_arg1);
            invalidateProperties();
        }
        override protected function commitProperties():void{
            var _local1:int;
            var _local2:Class;
            super.commitProperties();
            if (((hasFontContextChanged()) && (!((label == null))))){
                _local1 = getChildIndex(DisplayObject(label));
                removeLabel();
                createLabel(_local1);
            };
            if (((icon) && (!(_data)))){
                removeChild(DisplayObject(icon));
                icon = null;
                iconClass = null;
            };
            if (_data){
                listOwner = TileBase(_listData.owner);
                if (_listData.icon){
                    _local2 = _listData.icon;
                    if (iconClass != _local2){
                        iconClass = _local2;
                        if (icon){
                            removeChild(DisplayObject(icon));
                        };
                        icon = new iconClass();
                        addChild(DisplayObject(icon));
                    };
                };
                label.text = _listData.label;
                label.multiline = listOwner.variableRowHeight;
                label.wordWrap = listOwner.wordWrap;
            } else {
                label.text = " ";
                toolTip = null;
            };
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            invalidateProperties();
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        mx_internal function createLabel(_arg1:int):void{
            if (!label){
                label = IUITextField(createInFontContext(UITextField));
                label.styleName = this;
                if (_arg1 == -1){
                    addChild(DisplayObject(label));
                } else {
                    addChildAt(DisplayObject(label), _arg1);
                };
            };
        }
        override public function get baselinePosition():Number{
            if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                super.baselinePosition;
            };
            if (!validateBaselinePosition()){
                return (NaN);
            };
            return ((label.y + label.baselinePosition));
        }
        override protected function measure():void{
            var _local2:Number;
            var _local3:Number;
            super.measure();
            var _local1:Number = 0;
            if (icon){
                _local1 = (_local1 + icon.measuredHeight);
            };
            if ((((((label.text == "")) || ((label.text == " ")))) || ((label.text == null)))){
                label.explicitHeight = 0;
                iconOnly = true;
            } else {
                label.explicitHeight = NaN;
                _local1 = (_local1 + getStyle("verticalGap"));
                iconOnly = false;
            };
            measuredHeight = (label.getExplicitOrMeasuredHeight() + _local1);
            _local2 = getStyle("paddingLeft");
            _local3 = getStyle("paddingRight");
            measuredWidth = ((label.getExplicitOrMeasuredWidth() + _local2) + _local3);
            if (((icon) && ((((icon.measuredWidth + _local2) + _local3) > measuredWidth)))){
                measuredWidth = ((icon.measuredWidth + _local2) + _local3);
            };
        }
        mx_internal function removeLabel():void{
            if (label){
                removeChild(DisplayObject(label));
                label = null;
            };
        }
        public function get fontContext():IFlexModuleFactory{
            return (moduleFactory);
        }
        override protected function createChildren():void{
            super.createChildren();
            createLabel(-1);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        public function get data():Object{
            return (_data);
        }

    }
}//package mx.controls.listClasses 
