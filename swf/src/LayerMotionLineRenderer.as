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

    public class LayerMotionLineRenderer extends VBox implements IBindingClient, IDropInListItemRenderer {

        private static var _watcherSetupUtil:IWatcherSetupUtil;

        private var _1864184453imgPreview:Image;
        mx_internal var _bindingsByDestination:Object;
        private var _100346066index:int = -1;
        private var _1238760267listOwner:ListBase;
        mx_internal var _watchers:Array;
        private var _736800012lblMotion:Text;
        private var motionPreview00:Class;
        private var motionPreview01:Class;
        private var motionPreview02:Class;
        private var motionPreview03:Class;
        private var motionPreview04:Class;
        private var motionPreview05:Class;
        private var motionPreview06:Class;
        private var motionPreview07:Class;
        private var motionPreview08:Class;
        private var motionPreview09:Class;
        public var _LayerMotionLineRenderer_SetStyle1:SetStyle;
        public var _LayerMotionLineRenderer_SetStyle2:SetStyle;
        public var _LayerMotionLineRenderer_SetStyle3:SetStyle;
        private var _listData:BaseListData;
        private var _859628944imageBox:HBox;
        private var motionPreview11:Class;
        private var motionPreview12:Class;
        private var motionPreview13:Class;
        private var motionPreview14:Class;
        private var motionPreview15:Class;
        private var motionPreview10:Class;
        private var motionPreview18:Class;
        private var motionPreview19:Class;
        mx_internal var _bindingsBeginWithWord:Object;
        private var motionPreview16:Class;
        private var motionPreview17:Class;
        private var motionPreview20:Class;
        private var motionPreview21:Class;
        private var motionPreview22:Class;
        mx_internal var _bindings:Array;
        private var _documentDescriptor_:UIComponentDescriptor;

        public function LayerMotionLineRenderer(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({
                        height:50,
                        childDescriptors:[new UIComponentDescriptor({
                            type:HBox,
                            id:"imageBox",
                            stylesFactory:function ():void{
                                this.verticalAlign = "middle";
                                this.horizontalGap = 2;
                            },
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    styleName:"",
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:Image,
                                        id:"imgPreview",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                autoLoad:true,
                                                width:50,
                                                height:50
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:Text,
                                        id:"lblMotion",
                                        propertiesFactory:function ():Object{
                                            return ({percentWidth:100});
                                        }
                                    })]
                                });
                            }
                        })]
                    });
                }
            });
            motionPreview00 = LayerMotionLineRenderer_motionPreview00;
            motionPreview01 = LayerMotionLineRenderer_motionPreview01;
            motionPreview02 = LayerMotionLineRenderer_motionPreview02;
            motionPreview03 = LayerMotionLineRenderer_motionPreview03;
            motionPreview04 = LayerMotionLineRenderer_motionPreview04;
            motionPreview05 = LayerMotionLineRenderer_motionPreview05;
            motionPreview06 = LayerMotionLineRenderer_motionPreview06;
            motionPreview07 = LayerMotionLineRenderer_motionPreview07;
            motionPreview08 = LayerMotionLineRenderer_motionPreview08;
            motionPreview09 = LayerMotionLineRenderer_motionPreview09;
            motionPreview10 = LayerMotionLineRenderer_motionPreview10;
            motionPreview11 = LayerMotionLineRenderer_motionPreview11;
            motionPreview12 = LayerMotionLineRenderer_motionPreview12;
            motionPreview13 = LayerMotionLineRenderer_motionPreview13;
            motionPreview14 = LayerMotionLineRenderer_motionPreview14;
            motionPreview15 = LayerMotionLineRenderer_motionPreview15;
            motionPreview16 = LayerMotionLineRenderer_motionPreview16;
            motionPreview17 = LayerMotionLineRenderer_motionPreview17;
            motionPreview18 = LayerMotionLineRenderer_motionPreview18;
            motionPreview19 = LayerMotionLineRenderer_motionPreview19;
            motionPreview20 = LayerMotionLineRenderer_motionPreview20;
            motionPreview21 = LayerMotionLineRenderer_motionPreview21;
            motionPreview22 = LayerMotionLineRenderer_motionPreview22;
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
            this.height = 50;
            this.verticalScrollPolicy = "off";
            this.horizontalScrollPolicy = "off";
            this.states = [_LayerMotionLineRenderer_State1_c(), _LayerMotionLineRenderer_State2_c(), _LayerMotionLineRenderer_State3_c()];
            this.addEventListener("initialize", ___LayerMotionLineRenderer_VBox1_initialize);
            this.addEventListener("creationComplete", ___LayerMotionLineRenderer_VBox1_creationComplete);
            this.addEventListener("rollOver", ___LayerMotionLineRenderer_VBox1_rollOver);
            this.addEventListener("rollOut", ___LayerMotionLineRenderer_VBox1_rollOut);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            LayerMotionLineRenderer._watcherSetupUtil = _arg1;
        }

        private function _LayerMotionLineRenderer_State3_c():State{
            var _local1:State = new State();
            _local1.name = "selected";
            _local1.overrides = [_LayerMotionLineRenderer_SetStyle3_i()];
            return (_local1);
        }
        public function set imgPreview(_arg1:Image):void{
            var _local2:Object = this._1864184453imgPreview;
            if (_local2 !== _arg1){
                this._1864184453imgPreview = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imgPreview", _local2, _arg1));
            };
        }
        public function get lblMotion():Text{
            return (this._736800012lblMotion);
        }
        public function set lblMotion(_arg1:Text):void{
            var _local2:Object = this._736800012lblMotion;
            if (_local2 !== _arg1){
                this._736800012lblMotion = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblMotion", _local2, _arg1));
            };
        }
        private function set _1345164648listData(_arg1:BaseListData):void{
            _listData = _arg1;
            if (null == _listData){
                if (listOwner != null){
                    listOwner.removeEventListener(FlexEvent.VALUE_COMMIT, OnDataChange);
                    listOwner.removeEventListener(Event.CHANGE, OnDataChange);
                };
            } else {
                if (_listData.owner != listOwner){
                    if (listOwner != null){
                        listOwner.removeEventListener(FlexEvent.VALUE_COMMIT, OnDataChange);
                        listOwner.removeEventListener(Event.CHANGE, OnDataChange);
                    };
                    listOwner = (_listData.owner as ListBase);
                    listOwner.addEventListener(FlexEvent.VALUE_COMMIT, OnDataChange);
                    listOwner.addEventListener(Event.CHANGE, OnDataChange);
                };
            };
        }
        private function _LayerMotionLineRenderer_SetStyle1_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerMotionLineRenderer_SetStyle1 = _local1;
            _local1.name = "styleName";
            _local1.value = "";
            BindingManager.executeBindings(this, "_LayerMotionLineRenderer_SetStyle1", _LayerMotionLineRenderer_SetStyle1);
            return (_local1);
        }
        private function _LayerMotionLineRenderer_State2_c():State{
            var _local1:State = new State();
            _local1.name = "rollover";
            _local1.overrides = [_LayerMotionLineRenderer_SetStyle2_i()];
            return (_local1);
        }
        public function ___LayerMotionLineRenderer_VBox1_initialize(_arg1:FlexEvent):void{
            Initialize();
        }
        protected function OnCreationComplete():void{
            this.addEventListener(Event.ADDED, OnDataChange);
            this.addEventListener(FlexEvent.DATA_CHANGE, OnDataChange);
        }
        private function _LayerMotionLineRenderer_bindingExprs():void{
            var _local1:*;
            _local1 = imageBox;
            _local1 = imageBox;
            _local1 = imageBox;
        }
        protected function OnDataChange(_arg1:Event):void{
            if (null != listOwner){
                index = listOwner.itemRendererToIndex(this);
                if (index < 0){
                    return;
                };
            };
            if (((!((null == listOwner))) && ((index == listOwner.selectedIndex)))){
                currentState = "selected";
            } else {
                currentState = "default";
            };
            UpdateDisplay(index);
        }
        private function set listOwner(_arg1:ListBase):void{
            var _local2:Object = this._1238760267listOwner;
            if (_local2 !== _arg1){
                this._1238760267listOwner = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listOwner", _local2, _arg1));
            };
        }
        public function ___LayerMotionLineRenderer_VBox1_rollOver(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
        }
        public function get listData():BaseListData{
            return (_listData);
        }
        public function get imageBox():HBox{
            return (this._859628944imageBox);
        }
        public function get imgPreview():Image{
            return (this._1864184453imgPreview);
        }
        private function _LayerMotionLineRenderer_State1_c():State{
            var _local1:State = new State();
            _local1.name = "default";
            _local1.overrides = [_LayerMotionLineRenderer_SetStyle1_i()];
            return (_local1);
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _LayerMotionLineRenderer_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_LayerMotionLineRendererWatcherSetupUtil");
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
            if (((!((null == listOwner))) && ((_arg1 < 0)))){
                _arg1 = listOwner.itemRendererToIndex(this);
                if (_arg1 < 0){
                    return;
                };
            };
            if (null == this.data){
                lblMotion.text = "";
                imgPreview.source = null;
            } else {
                lblMotion.text = this.data.label;
                switch (this.data.value){
                    case LayersTab.MOTION_TYPE_APPEAR:
                        imgPreview.source = motionPreview01;
                        break;
                    case LayersTab.MOTION_TYPE_DISAPPEAR:
                        imgPreview.source = motionPreview02;
                        break;
                    case LayersTab.MOTION_TYPE_BLINK:
                        imgPreview.source = motionPreview03;
                        break;
                    case LayersTab.MOTION_TYPE_SHAKE:
                        imgPreview.source = motionPreview04;
                        break;
                    case LayersTab.MOTION_TYPE_SPIN_RIGHT:
                        imgPreview.source = motionPreview05;
                        break;
                    case LayersTab.MOTION_TYPE_SPIN_LEFT:
                        imgPreview.source = motionPreview06;
                        break;
                    case LayersTab.MOTION_TYPE_RISE:
                        imgPreview.source = motionPreview07;
                        break;
                    case LayersTab.MOTION_TYPE_SINK:
                        imgPreview.source = motionPreview08;
                        break;
                    case LayersTab.MOTION_TYPE_FLIP:
                        imgPreview.source = motionPreview09;
                        break;
                    case LayersTab.MOTION_TYPE_FLOP:
                        imgPreview.source = motionPreview10;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_UP:
                        imgPreview.source = motionPreview11;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_DOWN:
                        imgPreview.source = motionPreview12;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_RIGHT:
                        imgPreview.source = motionPreview13;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_LEFT:
                        imgPreview.source = motionPreview14;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_INTO:
                        imgPreview.source = motionPreview15;
                        break;
                    case LayersTab.MOTION_TYPE_FLY_OUT:
                        imgPreview.source = motionPreview16;
                        break;
                    case LayersTab.MOTION_TYPE_FLOAT_UP:
                        imgPreview.source = motionPreview17;
                        break;
                    case LayersTab.MOTION_TYPE_FLOAT_DOWN:
                        imgPreview.source = motionPreview18;
                        break;
                    case LayersTab.MOTION_TYPE_FLOAT_RIGHT:
                        imgPreview.source = motionPreview19;
                        break;
                    case LayersTab.MOTION_TYPE_FLOAT_LEFT:
                        imgPreview.source = motionPreview20;
                        break;
                    case LayersTab.MOTION_TYPE_ROTATE_RIGHT:
                        imgPreview.source = motionPreview21;
                        break;
                    case LayersTab.MOTION_TYPE_ROTATE_LEFT:
                        imgPreview.source = motionPreview22;
                        break;
                    default:
                        imgPreview.source = motionPreview00;
                };
            };
        }
        private function set index(_arg1:int):void{
            var _local2:Object = this._100346066index;
            if (_local2 !== _arg1){
                this._100346066index = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "index", _local2, _arg1));
            };
        }
        private function get listOwner():ListBase{
            return (this._1238760267listOwner);
        }
        private function _LayerMotionLineRenderer_SetStyle3_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerMotionLineRenderer_SetStyle3 = _local1;
            _local1.name = "styleName";
            _local1.value = "";
            BindingManager.executeBindings(this, "_LayerMotionLineRenderer_SetStyle3", _LayerMotionLineRenderer_SetStyle3);
            return (_local1);
        }
        protected function Initialize():void{
        }
        public function ___LayerMotionLineRenderer_VBox1_rollOut(_arg1:MouseEvent):void{
            OnMouseMove(_arg1);
        }
        private function _LayerMotionLineRenderer_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerMotionLineRenderer_SetStyle1.target = _arg1;
            }, "_LayerMotionLineRenderer_SetStyle1.target");
            result[0] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerMotionLineRenderer_SetStyle2.target = _arg1;
            }, "_LayerMotionLineRenderer_SetStyle2.target");
            result[1] = binding;
            binding = new Binding(this, function ():IStyleClient{
                return (imageBox);
            }, function (_arg1:IStyleClient):void{
                _LayerMotionLineRenderer_SetStyle3.target = _arg1;
            }, "_LayerMotionLineRenderer_SetStyle3.target");
            result[2] = binding;
            return (result);
        }
        public function set listData(_arg1:BaseListData):void{
            var _local2:Object = this.listData;
            if (_local2 !== _arg1){
                this._1345164648listData = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "listData", _local2, _arg1));
            };
        }
        protected function OnMouseMove(_arg1:Event):void{
            if (_arg1.type == MouseEvent.ROLL_OVER){
                currentState = "rollover";
            } else {
                if (null != listOwner){
                };
                if (((((!((null == listOwner))) && ((index >= 0)))) && ((index == listOwner.selectedIndex)))){
                    currentState = "selected";
                } else {
                    currentState = "default";
                };
            };
        }
        public function ___LayerMotionLineRenderer_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        public function set imageBox(_arg1:HBox):void{
            var _local2:Object = this._859628944imageBox;
            if (_local2 !== _arg1){
                this._859628944imageBox = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "imageBox", _local2, _arg1));
            };
        }
        private function get index():int{
            return (this._100346066index);
        }
        private function _LayerMotionLineRenderer_SetStyle2_i():SetStyle{
            var _local1:SetStyle = new SetStyle();
            _LayerMotionLineRenderer_SetStyle2 = _local1;
            _local1.name = "styleName";
            _local1.value = "";
            BindingManager.executeBindings(this, "_LayerMotionLineRenderer_SetStyle2", _LayerMotionLineRenderer_SetStyle2);
            return (_local1);
        }

    }
}//package 
