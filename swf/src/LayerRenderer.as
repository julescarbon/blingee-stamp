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

    public class LayerRenderer extends VBox implements IBindingClient, IDropInListItemRenderer {

        private static var _watcherSetupUtil:IWatcherSetupUtil;

        private var _1238760267listOwner:ListBase;
        private var _724809599showLoading:Boolean = true;
        mx_internal var _watchers:Array;
        public var loadingAnimation:Class;
        private var _1916428813imgData:Image;
        private var _listData:BaseListData;
        private var _1131547285progressing:Boolean = false;
        private var _859628944imageBox:HBox;
        mx_internal var _bindingsBeginWithWord:Object;
        public var _LayerRenderer_SetStyle1:SetStyle;
        public var _LayerRenderer_SetStyle2:SetStyle;
        public var _LayerRenderer_SetStyle3:SetStyle;
        private var toolTextSymbol:Class;
        private var toolPenSymbol:Class;
        private var toolAddSymbol:Class;
        mx_internal var _bindingsByDestination:Object;
        private var _100346066index:int = -1;
        mx_internal var _bindings:Array;
        private var _1916918779imgTool:Image;
        private var _811255620lblIndex:Text;
        private var _documentDescriptor_:UIComponentDescriptor;

        public function LayerRenderer(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({
                        height:100,
                        childDescriptors:[new UIComponentDescriptor({
                            type:HBox,
                            id:"imageBox",
                            stylesFactory:function ():void{
                                this.borderStyle = "solid";
                                this.verticalAlign = "middle";
                                this.horizontalGap = 2;
                            },
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    styleName:"thumbnailDefault",
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:Text,
                                        id:"lblIndex",
                                        propertiesFactory:function ():Object{
                                            return ({width:25});
                                        }
                                    }), new UIComponentDescriptor({
                                        type:Image,
                                        id:"imgTool",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                autoLoad:true,
                                                width:25
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:Image,
                                        id:"imgData",
                                        events:{
                                            progress:"__imgData_progress",
                                            complete:"__imgData_complete"
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
                                    })]
                                });
                            }
                        })]
                    });
                }
            });
            loadingAnimation = LayerRenderer_loadingAnimation;
            toolAddSymbol = LayerRenderer_toolAddSymbol;
            toolPenSymbol = LayerRenderer_toolPenSymbol;
            toolTextSymbol = LayerRenderer_toolTextSymbol;
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
            this.percentWidth = 100;
            this.height = 100;
            this.verticalScrollPolicy = "off";
            this.horizontalScrollPolicy = "off";
            this.states = [_LayerRenderer_State1_c(), _LayerRenderer_State2_c(), _LayerRenderer_State3_c()];
            this.addEventListener("initialize", ___LayerRenderer_VBox1_initialize);
            this.addEventListener("creationComplete", ___LayerRenderer_VBox1_creationComplete);
            this.addEventListener("rollOver", ___LayerRenderer_VBox1_rollOver);
            this.addEventListener("rollOut", ___LayerRenderer_VBox1_rollOut);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            LayerRenderer._watcherSetupUtil = _arg1;
        }

        private function _LayerRenderer_SetStyle2_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerRenderer_SetStyle2 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailRolledOver";
            BindingManager.executeBindings(this, "_LayerRenderer_SetStyle2", _LayerRenderer_SetStyle2);
            return (_local1);
        }
        public function ___LayerRenderer_VBox1_initialize(_arg1:FlexEvent):void{
            Initialize();
        }
        public function set imgTool(_arg1:Image):void{
            var _local2:Object = this._1916918779imgTool;
            if (_local2 !== _arg1){
                this._1916918779imgTool = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imgTool", _local2, _arg1));
            };
        }
        public function get showLoading():Boolean{
            return (this._724809599showLoading);
        }
        private function _LayerRenderer_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():Object{
                return (data.photo.thumbnail);
            }, function (_arg1:Object):void{
                imgData.source = _arg1;
            }, "imgData.source");
            result[0] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = data.photo.name;
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                imgData.toolTip = _arg1;
            }, "imgData.toolTip");
            result[1] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerRenderer_SetStyle1.target = _arg1;
            }, "_LayerRenderer_SetStyle1.target");
            result[2] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerRenderer_SetStyle2.target = _arg1;
            }, "_LayerRenderer_SetStyle2.target");
            result[3] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerRenderer_SetStyle3.target = _arg1;
            }, "_LayerRenderer_SetStyle3.target");
            result[4] = binding;
            return (result);
        }
        private function _LayerRenderer_bindingExprs():void{
            var _local1:*;
            _local1 = data.photo.thumbnail;
            _local1 = data.photo.name;
            _local1 = imageBox;
            _local1 = imageBox;
            _local1 = imageBox;
        }
        public function __imgData_complete(_arg1:Event):void{
            OnComplete();
        }
        public function get imgData():Image{
            return (this._1916428813imgData);
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _LayerRenderer_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_LayerRendererWatcherSetupUtil");
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
        protected function UpdateDisplay(_arg1:int=-1):void{
            if (_arg1 < 0){
                if (null == listOwner){
                    return;
                };
                _arg1 = listOwner.itemRendererToIndex(this);
                if (_arg1 < 0){
                    return;
                };
            };
            this.lblIndex.text = ((_arg1 + 1).toString() + ".");
            switch (this.data.toolType){
                case BlingeeMaker.TOOLTYPE_ADD:
                    this.imgTool.source = toolAddSymbol;
                    break;
                case BlingeeMaker.TOOLTYPE_PEN:
                    this.imgTool.source = toolPenSymbol;
                    break;
                case BlingeeMaker.TOOLTYPE_TEXT:
                    this.imgTool.source = toolTextSymbol;
                    break;
                default:
                    this.imgTool.source = null;
            };
        }
        public function set imgData(_arg1:Image):void{
            var _local2:Object = this._1916428813imgData;
            if (_local2 !== _arg1){
                this._1916428813imgData = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imgData", _local2, _arg1));
            };
        }
        public function ___LayerRenderer_VBox1_rollOver(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
        }
        public function set showLoading(_arg1:Boolean):void{
            var _local2:Object = this._724809599showLoading;
            if (_local2 !== _arg1){
                this._724809599showLoading = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "showLoading", _local2, _arg1));
            };
        }
        private function set index(_arg1:int):void{
            var _local2:Object = this._100346066index;
            if (_local2 !== _arg1){
                this._100346066index = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "index", _local2, _arg1));
            };
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
        private function get progressing():Boolean{
            return (this._1131547285progressing);
        }
        private function _LayerRenderer_State1_c():State{
            var _local1:State = new State();
            _local1.name = "default";
            _local1.overrides = [_LayerRenderer_SetStyle1_i()];
            return (_local1);
        }
        private function set progressing(_arg1:Boolean):void{
            var _local2:Object = this._1131547285progressing;
            if (_local2 !== _arg1){
                this._1131547285progressing = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "progressing", _local2, _arg1));
            };
        }
        private function get listOwner():ListBase{
            return (this._1238760267listOwner);
        }
        protected function Initialize():void{
        }
        public function get lblIndex():Text{
            return (this._811255620lblIndex);
        }
        private function _LayerRenderer_State3_c():State{
            var _local1:State = new State();
            _local1.name = "selected";
            _local1.overrides = [_LayerRenderer_SetStyle3_i()];
            return (_local1);
        }
        private function _LayerRenderer_SetStyle1_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerRenderer_SetStyle1 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailDefault";
            BindingManager.executeBindings(this, "_LayerRenderer_SetStyle1", _LayerRenderer_SetStyle1);
            return (_local1);
        }
        private function _LayerRenderer_SetStyle3_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerRenderer_SetStyle3 = _local1;
            _local1.name = "styleName";
            _local1.value = "thumbnailSelected";
            BindingManager.executeBindings(this, "_LayerRenderer_SetStyle3", _LayerRenderer_SetStyle3);
            return (_local1);
        }
        public function ___LayerRenderer_VBox1_rollOut(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
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
        protected function OnComplete():void{
            progressing = false;
            if (this.showLoading){
                this.imageBox.setStyle("backgroundImage", null);
            };
            if (null == listOwner){
                return;
            };
            this.UpdateDisplay();
        }
        public function set imageBox(_arg1:HBox):void{
            var _local2:Object = this._859628944imageBox;
            if (_local2 !== _arg1){
                this._859628944imageBox = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageBox", _local2, _arg1));
            };
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
        public function get imageBox():HBox{
            return (this._859628944imageBox);
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
                currentState = "selected";
            } else {
                currentState = "default";
            };
            UpdateDisplay(index);
        }
        public function set listData(_arg1:BaseListData):void{
            var _local2:Object = this.listData;
            if (_local2 !== _arg1){
                this._1345164648listData = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listData", _local2, _arg1));
            };
        }
        public function ___LayerRenderer_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        public function set lblIndex(_arg1:Text):void{
            var _local2:Object = this._811255620lblIndex;
            if (_local2 !== _arg1){
                this._811255620lblIndex = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblIndex", _local2, _arg1));
            };
        }
        public function get imgTool():Image{
            return (this._1916918779imgTool);
        }
        private function _LayerRenderer_State2_c():State{
            var _local1:State = new State();
            _local1.name = "rollover";
            _local1.overrides = [_LayerRenderer_SetStyle2_i()];
            return (_local1);
        }
        public function __imgData_progress(_arg1:ProgressEvent):void{
            OnProgress();
        }

    }
}//package 
