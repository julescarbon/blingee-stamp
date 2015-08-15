package mx.controls {
    import flash.display.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.controls.listClasses.*;

    public class Image extends SWFLoader implements IDataRenderer, IDropInListItemRenderer, IListItemRenderer {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _listData:BaseListData;
        private var sourceSet:Boolean;
        private var _data:Object;
        private var settingBrokenImage:Boolean;
        private var makeContentVisible:Boolean = false;

        public function Image(){
            tabChildren = false;
            tabEnabled = true;
            showInAutomationHierarchy = true;
        }
        override mx_internal function contentLoaderInfo_completeEventHandler(_arg1:Event):void{
            var _local2:DisplayObject = DisplayObject(_arg1.target.loader);
            super.contentLoaderInfo_completeEventHandler(_arg1);
            _local2.visible = false;
            makeContentVisible = true;
            invalidateDisplayList();
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        public function set listData(_arg1:BaseListData):void{
            _listData = _arg1;
        }
        public function get data():Object{
            return (_data);
        }
        public function set data(_arg1:Object):void{
            _data = _arg1;
            if (!sourceSet){
                source = ((listData) ? listData.label : data);
                sourceSet = false;
            };
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
        }
        override public function invalidateSize():void{
            if (((data) && (settingBrokenImage))){
                return;
            };
            super.invalidateSize();
        }
        override public function set source(_arg1:Object):void{
            settingBrokenImage = (_arg1 == getStyle("brokenImageSkin"));
            sourceSet = !(settingBrokenImage);
            super.source = _arg1;
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            if (((makeContentVisible) && (contentHolder))){
                contentHolder.visible = true;
                makeContentVisible = false;
            };
        }

    }
}//package mx.controls 
