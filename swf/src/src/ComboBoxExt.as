package src {
    import flash.display.*;
    import mx.core.*;
    import mx.events.*;
    import mx.controls.*;
    import mx.controls.listClasses.*;

    public class ComboBoxExt extends ComboBox {

        protected var m_selectedItemDisplay:IDataRenderer;

        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local7:UIComponent;
            var _local8:DisplayObject;
            super.updateDisplayList(_arg1, _arg2);
            var _local3:Number = _arg1;
            var _local4:Number = _arg2;
            var _local5:Number = 0;
            var _local6:Number = getStyle("arrowButtonWidth");
            if (isNaN(_local6)){
                _local6 = 0;
            };
            if (null != this.m_selectedItemDisplay){
                this.textInput.setActualSize(0, 0);
                this.textInput.visible = false;
                this.textInput.includeInLayout = false;
                if ((this.m_selectedItemDisplay is UIComponent)){
                    _local7 = (this.m_selectedItemDisplay as UIComponent);
                    _local7.move(_local5, _local5);
                    _local7.setActualSize(((_local3 - _local6) - (2 * _local5)), (_local4 - (2 * _local5)));
                    _local7.mouseEnabled = false;
                    _local7.mouseChildren = false;
                } else {
                    _local8 = (this.m_selectedItemDisplay as DisplayObject);
                    _local8.x = _local5;
                    _local8.y = _local5;
                    _local8.width = ((_local3 - _local6) - (2 * _local5));
                    _local8.height = (_local4 - (2 * _local5));
                };
            };
        }
        override protected function commitProperties():void{
            super.commitProperties();
        }
        override protected function createChildren():void{
            var _local1:Object;
            var _local2:DisplayObject;
            super.createChildren();
            if (!this.editable){
                if (null != this.textInput){
                    this.textInput.visible = false;
                    this.includeInLayout = false;
                };
                if (null != this.itemRenderer){
                    _local1 = this.itemRenderer.newInstance();
                    if ((((_local1 is IDropInListItemRenderer)) && ((_local1 is DisplayObject)))){
                        this.m_selectedItemDisplay = (_local1 as IDataRenderer);
                        _local2 = (m_selectedItemDisplay as DisplayObject);
                        this.addChild(_local2);
                        this.addEventListener(FlexEvent.VALUE_COMMIT, OnUpdateSelectedItemDisplay);
                        this.addEventListener(FlexEvent.DATA_CHANGE, OnUpdateSelectedItemDisplay);
                    };
                };
            };
        }
        protected function OnUpdateSelectedItemDisplay(_arg1:FlexEvent):void{
            if (((!((null == this.m_selectedItemDisplay))) && (!((null == this.selectedItem))))){
                this.m_selectedItemDisplay.data = this.selectedItem;
            };
        }

    }
}//package src 
