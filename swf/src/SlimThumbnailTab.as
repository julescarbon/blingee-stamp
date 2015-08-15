package {
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.text.*;
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.binding.*;
    import mx.containers.*;
    import src.*;
    import mx.collections.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.net.*;
    import flash.ui.*;
    import flexlib.containers.*;
    import flash.external.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.filters.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class SlimThumbnailTab extends VBox implements IBindingClient {

        private static var _watcherSetupUtil:IWatcherSetupUtil;

        protected var _19515670m_ThumnailItemRenderer:IFactory;
        protected var _258902851m_rgPages:ArrayCollection;
        protected var m_fNotifyOnLastPage:Boolean = false;
        mx_internal var _watchers:Array;
        private var _1626832020txtDescription:Text;
        protected var _570663592m_rgPhotos:ArrayCollection;
        mx_internal var _bindingsBeginWithWord:Object;
        protected var m_iTabPageSize:int;
        mx_internal var _bindingsByDestination:Object;
        private var _593797233photoListContainer:VBox;
        protected var m_Gallery:Gallery;
        mx_internal var _bindings:Array;
        protected var photoList:TileList = null;
        private var _1693868351lkbPages:LinkBar;
        private var _documentDescriptor_:UIComponentDescriptor;

        public function SlimThumbnailTab(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({childDescriptors:[new UIComponentDescriptor({
                            type:VBox,
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:ButtonScrollingCanvas,
                                        propertiesFactory:function ():Object{
                                            return ({
                                                verticalScrollPolicy:"off",
                                                horizontalScrollPolicy:"auto",
                                                percentWidth:100,
                                                height:25,
                                                buttonWidth:15,
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:LinkBar,
                                                    id:"lkbPages"
                                                })]
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:Text,
                                        id:"txtDescription",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                visible:false,
                                                includeInLayout:false,
                                                percentWidth:100
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:VBox,
                                        id:"photoListContainer",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                percentWidth:100,
                                                percentHeight:100
                                            });
                                        }
                                    })]
                                });
                            }
                        })]});
                }
            });
            _258902851m_rgPages = new ArrayCollection();
            _570663592m_rgPhotos = new ArrayCollection();
            _19515670m_ThumnailItemRenderer = new ClassFactory(Thumbnail);
            _bindings = [];
            _watchers = [];
            _bindingsByDestination = {};
            _bindingsBeginWithWord = {};
            super();
            mx_internal::_document = this;
            this.percentWidth = 100;
            this.percentHeight = 100;
            this.verticalScrollPolicy = "off";
            this.horizontalScrollPolicy = "off";
            this.addEventListener("creationComplete", ___SlimThumbnailTab_VBox1_creationComplete);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            SlimThumbnailTab._watcherSetupUtil = _arg1;
        }

        protected function set m_rgPages(_arg1:ArrayCollection):void{
            var _local2:Object = this._258902851m_rgPages;
            if (_local2 !== _arg1){
                this._258902851m_rgPages = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_rgPages", _local2, _arg1));
            };
        }
        public function set lkbPages(_arg1:LinkBar):void{
            var _local2:Object = this._1693868351lkbPages;
            if (_local2 !== _arg1){
                this._1693868351lkbPages = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lkbPages", _local2, _arg1));
            };
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _SlimThumbnailTab_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_SlimThumbnailTabWatcherSetupUtil");
                var _local2 = watcherSetupUtilClass;
                _local2["init"](null);
            };
            _watcherSetupUtil.setup(this, function (_arg1:String){
                return (target[_arg1]);
            }, bindings, watchers);
            var i:* = 0;
            while (i < bindings.length) {
                Binding(bindings[i]).execute();
                i = (i + 1);
            };
            mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
            mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
            super.initialize();
        }
        protected function UpdatePhotoList():void{
            if (null != photoList){
                photoListContainer.removeChild(photoList);
            };
            photoList = new TileList();
            photoList.dataProvider = m_rgPhotos;
            photoList.percentWidth = 100;
            photoList.percentHeight = 100;
            photoList.itemRenderer = m_ThumnailItemRenderer;
            photoList.verticalScrollPolicy = ScrollPolicy.OFF;
            photoList.horizontalScrollPolicy = ScrollPolicy.OFF;
            photoList.styleName = "thumbnailList";
            photoListContainer.addChild(photoList);
        }
        protected function UpdatePaginationLinks():void{
            m_rgPages = new ArrayCollection();
            var _local1:int = Math.ceil((m_rgPhotos.length / m_iTabPageSize));
            var _local2:int;
            while (_local2 < _local1) {
                m_rgPages.addItem((_local2 + 1));
                _local2++;
            };
            if (_local1 > 0){
                lkbPages.selectedIndex = 0;
            };
        }
        public function ScrollToPageNumber(_arg1:int):Boolean{
            if (null == photoList){
                return (false);
            };
            var _local2:int = ((_arg1 - 1) * m_iTabPageSize);
            return (photoList.scrollToIndex(_local2));
        }
        protected function get m_rgPhotos():ArrayCollection{
            return (this._570663592m_rgPhotos);
        }
        public function set ThumnailItemRenderer(_arg1:IFactory):void{
            var _local2:IFactory = this.m_ThumnailItemRenderer;
            this.m_ThumnailItemRenderer = _arg1;
            if (_local2 != _arg1){
                UpdatePhotoList();
            };
        }
        public function AddPhoto(_arg1:Photo):void{
            if (null == _arg1){
                return;
            };
            if (((txtDescription.visible) || (txtDescription.includeInLayout))){
                txtDescription.visible = false;
                txtDescription.includeInLayout = false;
            };
            m_rgPhotos.addItem(_arg1);
            var _local2:int = Math.ceil((m_rgPhotos.length / m_iTabPageSize));
            if (m_rgPages.length < _local2){
                m_rgPages.addItem(_local2);
            };
            var _local3:int = _local2;
            lkbPages.selectedIndex = (_local3 - 1);
            ScrollToPageNumber(1);
            ScrollToPageNumber(_local3);
        }
        private function _SlimThumbnailTab_bindingExprs():void{
            var _local1:*;
            _local1 = m_rgPages;
        }
        private function _SlimThumbnailTab_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():Object{
                return (m_rgPages);
            }, function (_arg1:Object):void{
                lkbPages.dataProvider = _arg1;
            }, "lkbPages.dataProvider");
            result[0] = binding;
            return (result);
        }
        public function Initialize(_arg1:String, _arg2:Gallery, _arg3:int, _arg4:Boolean=false, _arg5:IFactory=null):void{
            label = _arg1;
            m_Gallery = _arg2;
            m_iTabPageSize = _arg3;
            m_fNotifyOnLastPage = _arg4;
            m_ThumnailItemRenderer = ((_arg5) ? _arg5 : new ClassFactory(Thumbnail));
        }
        protected function get m_rgPages():ArrayCollection{
            return (this._258902851m_rgPages);
        }
        public function get lkbPages():LinkBar{
            return (this._1693868351lkbPages);
        }
        public function set tabPageSize(_arg1:int):void{
            var _local2:int = this.m_iTabPageSize;
            this.m_iTabPageSize = _arg1;
            if (_local2 != _arg1){
                UpdatePaginationLinks();
            };
        }
        protected function set m_rgPhotos(_arg1:ArrayCollection):void{
            var _local2:Object = this._570663592m_rgPhotos;
            if (_local2 !== _arg1){
                this._570663592m_rgPhotos = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_rgPhotos", _local2, _arg1));
            };
        }
        protected function set m_ThumnailItemRenderer(_arg1:IFactory):void{
            var _local2:Object = this._19515670m_ThumnailItemRenderer;
            if (_local2 !== _arg1){
                this._19515670m_ThumnailItemRenderer = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_ThumnailItemRenderer", _local2, _arg1));
            };
        }
        public function ___SlimThumbnailTab_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        protected function OnCreationComplete():void{
            lkbPages.addEventListener(ItemClickEvent.ITEM_CLICK, OnLinkBarItemClicked);
            m_rgPhotos = new ArrayCollection(m_Gallery.photos.toArray());
            UpdatePaginationLinks();
            if (((!((m_Gallery.description == null))) && ((m_Gallery.description.length > 0)))){
                txtDescription.visible = true;
                txtDescription.includeInLayout = true;
                txtDescription.text = m_Gallery.description;
            };
            UpdatePhotoList();
        }
        public function get ThumnailItemRenderer():IFactory{
            return (this.m_ThumnailItemRenderer);
        }
        public function set txtDescription(_arg1:Text):void{
            var _local2:Object = this._1626832020txtDescription;
            if (_local2 !== _arg1){
                this._1626832020txtDescription = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "txtDescription", _local2, _arg1));
            };
        }
        public function set photoListContainer(_arg1:VBox):void{
            var _local2:Object = this._593797233photoListContainer;
            if (_local2 !== _arg1){
                this._593797233photoListContainer = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "photoListContainer", _local2, _arg1));
            };
        }
        public function get tabPageSize():int{
            return (this.m_iTabPageSize);
        }
        protected function get m_ThumnailItemRenderer():IFactory{
            return (this._19515670m_ThumnailItemRenderer);
        }
        public function get photoListContainer():VBox{
            return (this._593797233photoListContainer);
        }
        public function get txtDescription():Text{
            return (this._1626832020txtDescription);
        }
        public function OnLinkBarItemClicked(_arg1:ItemClickEvent):void{
            var _local4:Button;
            lkbPages.selectedIndex = _arg1.index;
            var _local2:Array = lkbPages.getChildren();
            var _local3:int;
            while (_local3 < _local2.length) {
                _local4 = (_local2[_local3] as Button);
                _local4.enabled = !((_arg1.index == _local3));
                _local3++;
            };
            ScrollToPageNumber((_arg1.item as int));
            if (((((((m_fNotifyOnLastPage) && ((_local2.length > 0)))) && (((_local2.length - 1) == _arg1.index)))) && (!((null == this.parent))))){
                this.parent.dispatchEvent(new Event(BlingeeMaker.TAB_LAST_PAGE_CLICKED, true));
            };
        }

    }
}//package 
