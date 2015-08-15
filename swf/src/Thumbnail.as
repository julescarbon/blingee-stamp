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
    import mx.states.*;
    import mx.binding.*;
    import mx.rpc.events.*;
    import mx.containers.*;
    import mx.controls.listClasses.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.accessibility.*;
    import flash.xml.*;
    import flash.net.*;
    import flash.ui.*;
    import flash.external.*;
    import flash.debugger.*;
    import flash.errors.*;
    import flash.filters.*;
    import flash.printing.*;
    import flash.profiler.*;

    public class Thumbnail extends VBox implements IBindingClient, IDropInListItemRenderer {

        public static const DEFFAULT_WIDTH:int = 100;

        private static var _watcherSetupUtil:IWatcherSetupUtil;

        private var _embed_mxml_graphics_icons_lock_png_799625381:Class;
        public var _Thumbnail_SetStyle2:SetStyle;
        public var _Thumbnail_SetStyle3:SetStyle;
        private var _1238760267listOwner:ListBase;
        private var _1773929635imgLockBox:Canvas;
        private var _724809599showLoading:Boolean = true;
        public var _Thumbnail_SetStyle1:SetStyle;
        mx_internal var _watchers:Array;
        private var _100313435image:Image;
        public var loadingAnimation:Class;
        protected var m_iThumbnailWidth:int = 100;
        private var _1131547285progressing:Boolean = false;
        private var _listData:BaseListData;
        private var _859628944imageBox:Canvas;
        mx_internal var _bindingsBeginWithWord:Object;
        private var _715314751showThumnail:Boolean = true;
        private var _1916680078imgLock:Image;
        private var _100346066index:int = -1;
        mx_internal var _bindings:Array;
        mx_internal var _bindingsByDestination:Object;
        private var _documentDescriptor_:UIComponentDescriptor;

        public function Thumbnail(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({childDescriptors:[new UIComponentDescriptor({
                            type:Canvas,
                            id:"imageBox",
                            stylesFactory:function ():void{
                                this.borderStyle = "solid";
                            },
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    styleName:"thumbnailDefault",
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:Image,
                                        id:"image",
                                        events:{
                                            progress:"__image_progress",
                                            complete:"__image_complete"
                                        },
                                        stylesFactory:function ():void{
                                            this.horizontalAlign = "center";
                                            this.verticalAlign = "middle";
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                autoLoad:true,
                                                percentWidth:100,
                                                percentHeight:100
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:Canvas,
                                        id:"imgLockBox",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                percentWidth:100,
                                                percentHeight:100,
                                                styleName:"lockedThumbnailOverlay",
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:Image,
                                                    id:"imgLock",
                                                    stylesFactory:function ():void{
                                                        this.horizontalAlign = "right";
                                                        this.verticalAlign = "bottom";
                                                    },
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            source:_embed_mxml_graphics_icons_lock_png_799625381,
                                                            percentWidth:100,
                                                            percentHeight:100,
                                                            scaleContent:false
                                                        });
                                                    }
                                                })]
                                            });
                                        }
                                    })]
                                });
                            }
                        })]});
                }
            });
            loadingAnimation = Thumbnail_loadingAnimation;
            _embed_mxml_graphics_icons_lock_png_799625381 = Thumbnail__embed_mxml_graphics_icons_lock_png_799625381;
            _bindings = [];
            _watchers = [];
            _bindingsByDestination = {};
            _bindingsBeginWithWord = {};
            super();
            mx_internal::_document = this;
            if (!this.styleDeclaration){
                this.styleDeclaration = new CSSStyleDeclaration();
            };
            this.styleDeclaration.defaultFactory = function ():void{
                this.horizontalAlign = "center";
                this.verticalAlign = "middle";
            };
            this.verticalScrollPolicy = "off";
            this.horizontalScrollPolicy = "off";
            this.states = [_Thumbnail_State1_c(), _Thumbnail_State2_c(), _Thumbnail_State3_c()];
            this.addEventListener("initialize", ___Thumbnail_VBox1_initialize);
            this.addEventListener("creationComplete", ___Thumbnail_VBox1_creationComplete);
            this.addEventListener("rollOver", ___Thumbnail_VBox1_rollOver);
            this.addEventListener("rollOut", ___Thumbnail_VBox1_rollOut);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            Thumbnail._watcherSetupUtil = _arg1;
        }

        public function ___Thumbnail_VBox1_rollOut(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
        }
        public function __image_complete(_arg1:Event):void{
            OnComplete();
        }
        public function set showLoading(_arg1:Boolean):void{
            var _local2:Object = this._724809599showLoading;
            if (_local2 !== _arg1){
                this._724809599showLoading = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showLoading", _local2, _arg1));
            };
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _Thumbnail_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_ThumbnailWatcherSetupUtil");
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
        private function _Thumbnail_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():Number{
                return (m_iThumbnailWidth);
            }, function (_arg1:Number):void{
                this.width = _arg1;
            }, "this.width");
            result[0] = binding;
            binding = new Binding(this, function ():Number{
                return (m_iThumbnailWidth);
            }, function (_arg1:Number):void{
                this.height = _arg1;
            }, "this.height");
            result[1] = binding;
            binding = new Binding(this, function ():Object{
                return (((showThumnail) ? data.thumbnail : data.source));
            }, function (_arg1:Object):void{
                image.source = _arg1;
            }, "image.source");
            result[2] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = data.name;
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                image.toolTip = _arg1;
            }, "image.toolTip");
            result[3] = binding;
            binding = new Binding(this, function ():Boolean{
                return (((data) ? data.isLocked : false));
            }, function (_arg1:Boolean):void{
                imgLockBox.visible = _arg1;
            }, "imgLockBox.visible");
            result[4] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _Thumbnail_SetStyle1.target = _arg1;
            }, "_Thumbnail_SetStyle1.target");
            result[5] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _Thumbnail_SetStyle2.target = _arg1;
            }, "_Thumbnail_SetStyle2.target");
            result[6] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _Thumbnail_SetStyle3.target = _arg1;
            }, "_Thumbnail_SetStyle3.target");
            result[7] = binding;
            return (result);
        }
        public function Select():void{
            index = listOwner.itemRendererToIndex(this);
            if (index < 0){
                return;
            };
            if (listOwner.selectedIndex != index){
                listOwner.selectedIndex = index;
            };
        }
        public function get imgLock():Image{
            return (this._1916680078imgLock);
        }
        private function set _1345164648listData(_arg1:BaseListData):void{
            _listData = _arg1;
            if (_listData.owner != listOwner){
                if (listOwner != null){
                    listOwner.removeEventListener(FlexEvent.VALUE_COMMIT, OnDataChange);
                    listOwner.removeEventListener(Event.CHANGE, OnDataChange);
                };
                listOwner = (_listData.owner as ListBase);
                listOwner.addEventListener(FlexEvent.VALUE_COMMIT, OnDataChange);
                listOwner.addEventListener(Event.CHANGE, OnDataChange);
            };
        }
        public function set imgLock(_arg1:Image):void{
            var _local2:Object = this._1916680078imgLock;
            if (_local2 !== _arg1){
                this._1916680078imgLock = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imgLock", _local2, _arg1));
            };
        }
        public function ___Thumbnail_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        private function get listOwner():ListBase{
            return (this._1238760267listOwner);
        }
        public function set image(_arg1:Image):void{
            var _local2:Object = this._100313435image;
            if (_local2 !== _arg1){
                this._100313435image = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "image", _local2, _arg1));
            };
        }
        private function _Thumbnail_State2_c():State{
            var _local1:State = new State();
            _local1.name = "rollover";
            _local1.overrides = [_Thumbnail_SetStyle2_i()];
            return (_local1);
        }
        private function set progressing(_arg1:Boolean):void{
            var _local2:Object = this._1131547285progressing;
            if (_local2 !== _arg1){
                this._1131547285progressing = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "progressing", _local2, _arg1));
            };
        }
        public function get thumbnailWidth():int{
            return (m_iThumbnailWidth);
        }
        private function _Thumbnail_SetStyle2_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _Thumbnail_SetStyle2 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailRolledOver";
            BindingManager.executeBindings(this, "_Thumbnail_SetStyle2", _Thumbnail_SetStyle2);
            return (_local1);
        }
        private function set index(_arg1:int):void{
            var _local2:Object = this._100346066index;
            if (_local2 !== _arg1){
                this._100346066index = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "index", _local2, _arg1));
            };
        }
        protected function Initialize():void{
        }
        private function get progressing():Boolean{
            return (this._1131547285progressing);
        }
        public function set listData(_arg1:BaseListData):void{
            var _local2:Object = this.listData;
            if (_local2 !== _arg1){
                this._1345164648listData = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listData", _local2, _arg1));
            };
        }
        public function ___Thumbnail_VBox1_initialize(_arg1:FlexEvent):void{
            Initialize();
        }
        public function get showThumnail():Boolean{
            return (this._715314751showThumnail);
        }
        public function set imgLockBox(_arg1:Canvas):void{
            var _local2:Object = this._1773929635imgLockBox;
            if (_local2 !== _arg1){
                this._1773929635imgLockBox = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imgLockBox", _local2, _arg1));
            };
        }
        private function _Thumbnail_bindingExprs():void{
            var _local1:*;
            _local1 = m_iThumbnailWidth;
            _local1 = m_iThumbnailWidth;
            _local1 = ((showThumnail) ? data.thumbnail : data.source);
            _local1 = data.name;
            _local1 = ((data) ? data.isLocked : false);
            _local1 = imageBox;
            _local1 = imageBox;
            _local1 = imageBox;
        }
        protected function OnProgress():void{
            if (progressing){
                return;
            };
            progressing = true;
            if (this.showLoading){
                this.imageBox.setStyle("backgroundImage", loadingAnimation);
            };
        }
        private function get index():int{
            return (this._100346066index);
        }
        protected function OnCreationComplete():void{
            this.addEventListener(FlexEvent.DATA_CHANGE, OnDataChange);
            this.addEventListener(MouseEvent.CLICK, OnDataChange);
        }
        protected function OnDataChange(_arg1:Event):void{
            if (null == listOwner){
                return;
            };
            index = listOwner.itemRendererToIndex(this);
            if (index < 0){
                return;
            };
            if (index == listOwner.selectedIndex){
                if (((data) && (data.isLocked))){
                    if (((_arg1) && ((_arg1 is MouseEvent)))){
                        listOwner.dispatchEvent(new Event(BlingeeMaker.LOCKED_CONTENT_CLICKED, true));
                    };
                } else {
                    listOwner.dispatchEvent(new ResultEvent(BlingeeMaker.SELECTED_PHOTO, true, true, this));
                    currentState = "selected";
                };
            } else {
                currentState = "default";
            };
        }
        public function get image():Image{
            return (this._100313435image);
        }
        public function Deselect():void{
            if ("selected" == currentState){
                currentState = "default";
            };
            index = listOwner.itemRendererToIndex(this);
            if (index == listOwner.selectedIndex){
                listOwner.selectedIndex = -1;
            };
        }
        protected function OnMouseMove(_arg1:Event):void{
            if (null == listOwner){
                return;
            };
            if (_arg1.type == MouseEvent.ROLL_OVER){
                currentState = "rollover";
            } else {
                if ((((index >= 0)) && ((index == listOwner.selectedIndex)))){
                    currentState = "selected";
                } else {
                    currentState = "default";
                };
            };
        }
        public function set imageBox(_arg1:Canvas):void{
            var _local2:Object = this._859628944imageBox;
            if (_local2 !== _arg1){
                this._859628944imageBox = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageBox", _local2, _arg1));
            };
        }
        public function get imgLockBox():Canvas{
            return (this._1773929635imgLockBox);
        }
        public function ___Thumbnail_VBox1_rollOver(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
        }
        protected function OnComplete():void{
            progressing = false;
            if (this.showLoading){
                this.imageBox.setStyle("backgroundImage", null);
            };
            if (null == listOwner){
                return;
            };
            listOwner.dispatchEvent(new ResultEvent(BlingeeMaker.CREATED_PHOTO, true, true, this));
        }
        private function set listOwner(_arg1:ListBase):void{
            var _local2:Object = this._1238760267listOwner;
            if (_local2 !== _arg1){
                this._1238760267listOwner = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listOwner", _local2, _arg1));
            };
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        public function get imageBox():Canvas{
            return (this._859628944imageBox);
        }
        public function __image_progress(_arg1:ProgressEvent):void{
            OnProgress();
        }
        public function set thumbnailWidth(_arg1:int):void{
            m_iThumbnailWidth = _arg1;
        }
        private function _Thumbnail_State1_c():State{
            var _local1:State = new State();
            _local1.name = "default";
            _local1.overrides = [_Thumbnail_SetStyle1_i()];
            return (_local1);
        }
        private function _Thumbnail_State3_c():State{
            var _local1:State = new State();
            _local1.name = "selected";
            _local1.overrides = [_Thumbnail_SetStyle3_i()];
            return (_local1);
        }
        private function _Thumbnail_SetStyle1_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _Thumbnail_SetStyle1 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailDefault";
            BindingManager.executeBindings(this, "_Thumbnail_SetStyle1", _Thumbnail_SetStyle1);
            return (_local1);
        }
        private function _Thumbnail_SetStyle3_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _Thumbnail_SetStyle3 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailSelected";
            BindingManager.executeBindings(this, "_Thumbnail_SetStyle3", _Thumbnail_SetStyle3);
            return (_local1);
        }
        public function set showThumnail(_arg1:Boolean):void{
            var _local2:Object = this._715314751showThumnail;
            if (_local2 !== _arg1){
                this._715314751showThumnail = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showThumnail", _local2, _arg1));
            };
        }
        public function get showLoading():Boolean{
            return (this._724809599showLoading);
        }

    }
}//package 
