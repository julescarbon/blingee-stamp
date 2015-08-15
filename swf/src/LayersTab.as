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
    import mx.rpc.events.*;
    import mx.containers.*;
    import src.*;
    import mx.collections.*;
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

    public class LayersTab extends VBox implements IBindingClient {

        public static const MOTION_TYPE_FLOP:int = 10;
        public static const MOTION_TYPE_SPIN_LEFT:int = 6;
        public static const MOTION_TYPE_FLIP:int = 9;
        public static const MOTION_TYPE_SHAKE:int = 4;
        public static const MOTION_TYPE_FLY_LEFT:int = 14;
        public static const MOTION_TYPE_FLY_INTO:int = 15;
        public static const MOTION_TYPE_ROTATE_RIGHT:int = 21;
        public static const MOTION_TYPE_FLOAT_UP:int = 17;
        public static const MOTION_TYPE_NONE:int = 0;
        public static const MOTION_TYPE_FLOAT_RIGHT:int = 19;
        public static const MOTION_TYPE_BLINK:int = 3;
        public static const MOTION_TYPE_FLOAT_DOWN:int = 18;
        public static const MOTION_TYPE_FLY_UP:int = 11;
        public static const MOTION_TYPE_RISE:int = 7;
        public static const MOTION_TYPE_FLY_OUT:int = 16;
        public static const MOTION_TYPE_DISAPPEAR:int = 2;
        public static const MOTION_TYPE_SPIN_RIGHT:int = 5;
        public static const MOTION_TYPE_SINK:int = 8;
        public static const MOTION_TYPE_APPEAR:int = 1;
        public static const MOTION_TYPE_FLOAT_LEFT:int = 20;
        public static const MOTION_TYPE_FLY_RIGHT:int = 13;
        public static const MOTION_TYPE_FLY_DOWN:int = 12;
        public static const MOTION_TYPE_ROTATE_LEFT:int = 22;

        private static var _watcherSetupUtil:IWatcherSetupUtil;

        private var _539977690btnLayerFlipHorizontal:Button;
        private var _1231513745lstLayers:List;
        private var _1144385720lblEmtpyMessage:TextArea;
        mx_internal var _bindingsByDestination:Object;
        private var actionFlipVerticalSymbol:Class;
        private var actionMoveUpSymbol:Class;
        private var _994692081cmbLayerMotion:ComboBoxExt;
        private var _730301491lblLayerTransparency:Label;
        private var actionMoveDownSymbol:Class;
        private var _1212911352sdrLayerTransparency:HSlider;
        private var _1026459439lblLayerMotion:Label;
        mx_internal var _watchers:Array;
        private var _1662336120btnLayerMoveDown:Button;
        private var _993906943btnLayerMoveUp:Button;
        protected var m_rbLanguage:ResourceBundle;
        private var _1638941768lblLayerFlip:Label;
        private var actionFlipHorizontalSymbol:Class;
        private var _315526136btnLayerFlipVertical:Button;
        mx_internal var _bindingsBeginWithWord:Object;
        protected var m_mapLayerMotionToIndex:Dictionary;
        protected var _449965929m_rgLayers:ArrayCollection;
        mx_internal var _bindings:Array;
        protected var _2019414573m_rgLayerMotions:ArrayCollection;
        private var _documentDescriptor_:UIComponentDescriptor;

        public function LayersTab(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({childDescriptors:[new UIComponentDescriptor({
                            type:TextArea,
                            id:"lblEmtpyMessage",
                            stylesFactory:function ():void{
                                this.paddingLeft = 5;
                                this.paddingTop = 5;
                                this.paddingRight = 5;
                                this.paddingBottom = 5;
                                this.borderStyle = "none";
                            },
                            propertiesFactory:function ():Object{
                                return ({
                                    editable:false,
                                    wordWrap:true,
                                    percentWidth:100,
                                    visible:true
                                });
                            }
                        }), new UIComponentDescriptor({
                            type:HBox,
                            stylesFactory:function ():void{
                                this.paddingLeft = 5;
                                this.paddingTop = 5;
                                this.paddingRight = 5;
                                this.paddingBottom = 5;
                            },
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:VBox,
                                        stylesFactory:function ():void{
                                            this.horizontalAlign = "center";
                                            this.paddingTop = 5;
                                            this.paddingBottom = 10;
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                width:200,
                                                percentHeight:100,
                                                horizontalScrollPolicy:"off",
                                                verticalScrollPolicy:"off",
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:HBox,
                                                    propertiesFactory:function ():Object{
                                                        return ({childDescriptors:[new UIComponentDescriptor({
                                                                type:Button,
                                                                id:"btnLayerMoveUp",
                                                                events:{click:"__btnLayerMoveUp_click"},
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:90,
                                                                        enabled:false
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Button,
                                                                id:"btnLayerMoveDown",
                                                                events:{click:"__btnLayerMoveDown_click"},
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:90,
                                                                        enabled:false
                                                                    });
                                                                }
                                                            })]});
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:List,
                                                    id:"lstLayers",
                                                    stylesFactory:function ():void{
                                                        this.paddingLeft = 0;
                                                        this.paddingTop = 0;
                                                        this.paddingRight = 0;
                                                        this.paddingBottom = 0;
                                                    },
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            x:0,
                                                            y:0,
                                                            percentWidth:100,
                                                            percentHeight:100,
                                                            horizontalScrollPolicy:"off",
                                                            verticalScrollPolicy:"on",
                                                            itemRenderer:_LayersTab_ClassFactory1_c()
                                                        });
                                                    }
                                                })]
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:VBox,
                                        stylesFactory:function ():void{
                                            this.paddingLeft = 10;
                                            this.paddingTop = 30;
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                percentWidth:100,
                                                percentHeight:100,
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:Label,
                                                    id:"lblLayerFlip"
                                                }), new UIComponentDescriptor({
                                                    type:HBox,
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            percentWidth:100,
                                                            childDescriptors:[new UIComponentDescriptor({
                                                                type:Button,
                                                                id:"btnLayerFlipHorizontal",
                                                                events:{click:"__btnLayerFlipHorizontal_click"},
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:60,
                                                                        enabled:false
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Button,
                                                                id:"btnLayerFlipVertical",
                                                                events:{click:"__btnLayerFlipVertical_click"},
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:60,
                                                                        enabled:false
                                                                    });
                                                                }
                                                            })]
                                                        });
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:Label,
                                                    id:"lblLayerTransparency"
                                                }), new UIComponentDescriptor({
                                                    type:HSlider,
                                                    id:"sdrLayerTransparency",
                                                    events:{change:"__sdrLayerTransparency_change"},
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            labels:[0, "100%"],
                                                            width:160,
                                                            minimum:0,
                                                            maximum:100,
                                                            value:0,
                                                            snapInterval:5,
                                                            enabled:false
                                                        });
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:Label,
                                                    id:"lblLayerMotion",
                                                    stylesFactory:function ():void{
                                                        this.paddingTop = 10;
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:ComboBoxExt,
                                                    id:"cmbLayerMotion",
                                                    events:{change:"__cmbLayerMotion_change"},
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            editable:false,
                                                            width:160,
                                                            height:50,
                                                            rowCount:4,
                                                            itemRenderer:_LayersTab_ClassFactory2_c(),
                                                            enabled:false
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
            actionMoveUpSymbol = LayersTab_actionMoveUpSymbol;
            actionMoveDownSymbol = LayersTab_actionMoveDownSymbol;
            actionFlipVerticalSymbol = LayersTab_actionFlipVerticalSymbol;
            actionFlipHorizontalSymbol = LayersTab_actionFlipHorizontalSymbol;
            _449965929m_rgLayers = new ArrayCollection();
            _2019414573m_rgLayerMotions = new ArrayCollection();
            m_mapLayerMotionToIndex = new Dictionary();
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
            this.addEventListener("creationComplete", ___LayersTab_VBox1_creationComplete);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            LayersTab._watcherSetupUtil = _arg1;
        }

        public function get btnLayerMoveUp():Button{
            return (this._993906943btnLayerMoveUp);
        }
        public function set btnLayerMoveUp(_arg1:Button):void{
            var _local2:Object = this._993906943btnLayerMoveUp;
            if (_local2 !== _arg1){
                this._993906943btnLayerMoveUp = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnLayerMoveUp", _local2, _arg1));
            };
        }
        public function OnBtnLayerFlipHorizontal():void{
            if (lstLayers.selectedIndex < 0){
                return;
            };
            this.dispatchEvent(new ResultEvent(BlingeeMaker.LAYER_FLIPED_HORIZONTAL, true, true, (m_rgLayers[lstLayers.selectedIndex] as Layer)));
        }
        public function __cmbLayerMotion_change(_arg1:ListEvent):void{
            OnCmbLayerMotionChange();
        }
        public function get sdrLayerTransparency():HSlider{
            return (this._1212911352sdrLayerTransparency);
        }
        public function set languageResource(_arg1:ResourceBundle):void{
            var _local2:Object = this.languageResource;
            if (_local2 !== _arg1){
                this._526654586languageResource = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "languageResource", _local2, _arg1));
            };
        }
        public function RemoveLayer(_arg1:int):void{
            var _local2:int = FindLayerIndexById(_arg1);
            if (_local2 < 0){
                return;
            };
            m_rgLayers.removeItemAt(_local2);
            m_rgLayers.refresh();
            if (m_rgLayers.length < 1){
                lblEmtpyMessage.visible = true;
                lblEmtpyMessage.includeInLayout = true;
            };
        }
        public function __btnLayerFlipHorizontal_click(_arg1:MouseEvent):void{
            OnBtnLayerFlipHorizontal();
        }
        public function set btnLayerMoveDown(_arg1:Button):void{
            var _local2:Object = this._1662336120btnLayerMoveDown;
            if (_local2 !== _arg1){
                this._1662336120btnLayerMoveDown = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnLayerMoveDown", _local2, _arg1));
            };
        }
        public function set sdrLayerTransparency(_arg1:HSlider):void{
            var _local2:Object = this._1212911352sdrLayerTransparency;
            if (_local2 !== _arg1){
                this._1212911352sdrLayerTransparency = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "sdrLayerTransparency", _local2, _arg1));
            };
        }
        private function _LayersTab_ClassFactory1_c():ClassFactory{
            var _local1:ClassFactory = new ClassFactory();
            _local1.generator = LayerRenderer;
            return (_local1);
        }
        public function set cmbLayerMotion(_arg1:ComboBoxExt):void{
            var _local2:Object = this._994692081cmbLayerMotion;
            if (_local2 !== _arg1){
                this._994692081cmbLayerMotion = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cmbLayerMotion", _local2, _arg1));
            };
        }
        public function get btnLayerFlipHorizontal():Button{
            return (this._539977690btnLayerFlipHorizontal);
        }
        public function get cmbLayerMotion():ComboBoxExt{
            return (this._994692081cmbLayerMotion);
        }
        public function OnLayersChange(_arg1:Event):void{
            var _local2:Layer;
            if ((((-1 == lstLayers.selectedIndex)) || ((m_rgLayers.length <= 1)))){
                btnLayerMoveUp.enabled = false;
                btnLayerMoveDown.enabled = false;
            } else {
                if (0 == lstLayers.selectedIndex){
                    btnLayerMoveUp.enabled = false;
                    btnLayerMoveDown.enabled = true;
                } else {
                    if ((m_rgLayers.length - 1) == lstLayers.selectedIndex){
                        btnLayerMoveUp.enabled = true;
                        btnLayerMoveDown.enabled = false;
                    } else {
                        btnLayerMoveUp.enabled = true;
                        btnLayerMoveDown.enabled = true;
                    };
                };
            };
            if (lstLayers.selectedIndex < 0){
                btnLayerFlipHorizontal.enabled = false;
                btnLayerFlipVertical.enabled = false;
                sdrLayerTransparency.enabled = false;
                sdrLayerTransparency.value = 0;
                cmbLayerMotion.enabled = false;
            } else {
                _local2 = m_rgLayers[lstLayers.selectedIndex];
                if ((((BlingeeMaker.TOOLTYPE_ADD == _local2.toolType)) || ((BlingeeMaker.TOOLTYPE_TEXT == _local2.toolType)))){
                    btnLayerFlipHorizontal.enabled = true;
                    btnLayerFlipVertical.enabled = true;
                    cmbLayerMotion.enabled = true;
                } else {
                    btnLayerFlipHorizontal.enabled = false;
                    btnLayerFlipVertical.enabled = false;
                    cmbLayerMotion.enabled = false;
                };
                sdrLayerTransparency.enabled = true;
                sdrLayerTransparency.value = (100 - _local2.opacity);
                cmbLayerMotion.selectedIndex = ((m_mapLayerMotionToIndex[_local2.motionType])!=null) ? (m_mapLayerMotionToIndex[_local2.motionType] as int) : 0;
            };
        }
        public function get lblLayerTransparency():Label{
            return (this._730301491lblLayerTransparency);
        }
        public function OnCmbLayerMotionChange():void{
            if (lstLayers.selectedIndex < 0){
                return;
            };
            if (cmbLayerMotion.selectedIndex < 0){
                return;
            };
            var _local1:Layer = (m_rgLayers[lstLayers.selectedIndex] as Layer);
            _local1.motionType = (cmbLayerMotion.selectedItem.value as int);
            this.dispatchEvent(new ResultEvent(BlingeeMaker.LAYER_SET_MOTION, true, true, _local1));
        }
        public function ___LayersTab_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        public function get lblEmtpyMessage():TextArea{
            return (this._1144385720lblEmtpyMessage);
        }
        protected function InitializeMotionList():void{
            m_rgLayerMotions = new ArrayCollection([{
                label:languageResource.getString("motion_NoMotion"),
                value:MOTION_TYPE_NONE
            }, {
                label:languageResource.getString("motion_Appear"),
                value:MOTION_TYPE_APPEAR
            }, {
                label:languageResource.getString("motion_Disapper"),
                value:MOTION_TYPE_DISAPPEAR
            }, {
                label:languageResource.getString("motion_Blink"),
                value:MOTION_TYPE_BLINK
            }, {
                label:languageResource.getString("motion_Shake"),
                value:MOTION_TYPE_SHAKE
            }, {
                label:languageResource.getString("motion_SpinRight"),
                value:MOTION_TYPE_SPIN_RIGHT
            }, {
                label:languageResource.getString("motion_SpinLeft"),
                value:MOTION_TYPE_SPIN_LEFT
            }, {
                label:languageResource.getString("motion_Rise"),
                value:MOTION_TYPE_RISE
            }, {
                label:languageResource.getString("motion_Sink"),
                value:MOTION_TYPE_SINK
            }, {
                label:languageResource.getString("motion_Flip"),
                value:MOTION_TYPE_FLIP
            }, {
                label:languageResource.getString("motion_Flop"),
                value:MOTION_TYPE_FLOP
            }, {
                label:languageResource.getString("motion_FlyUp"),
                value:MOTION_TYPE_FLY_UP
            }, {
                label:languageResource.getString("motion_FlyDown"),
                value:MOTION_TYPE_FLY_DOWN
            }, {
                label:languageResource.getString("motion_FlyRight"),
                value:MOTION_TYPE_FLY_RIGHT
            }, {
                label:languageResource.getString("motion_FlyLeft"),
                value:MOTION_TYPE_FLY_LEFT
            }, {
                label:languageResource.getString("motion_FlyInto"),
                value:MOTION_TYPE_FLY_INTO
            }, {
                label:languageResource.getString("motion_FlyOut"),
                value:MOTION_TYPE_FLY_OUT
            }, {
                label:languageResource.getString("motion_FloatUp"),
                value:MOTION_TYPE_FLOAT_UP
            }, {
                label:languageResource.getString("motion_FloatDown"),
                value:MOTION_TYPE_FLOAT_DOWN
            }, {
                label:languageResource.getString("motion_FloatRight"),
                value:MOTION_TYPE_FLOAT_RIGHT
            }, {
                label:languageResource.getString("motion_FloatLeft"),
                value:MOTION_TYPE_FLOAT_LEFT
            }, {
                label:languageResource.getString("motion_RotateRight"),
                value:MOTION_TYPE_ROTATE_RIGHT
            }, {
                label:languageResource.getString("motion_RotateLeft"),
                value:MOTION_TYPE_ROTATE_LEFT
            }]);
            var _local1:* = 0;
            while (_local1 < m_rgLayerMotions.length) {
                m_mapLayerMotionToIndex[(m_rgLayerMotions[_local1].value as int)] = _local1;
                _local1++;
            };
        }
        public function set btnLayerFlipHorizontal(_arg1:Button):void{
            var _local2:Object = this._539977690btnLayerFlipHorizontal;
            if (_local2 !== _arg1){
                this._539977690btnLayerFlipHorizontal = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnLayerFlipHorizontal", _local2, _arg1));
            };
        }
        public function get lblLayerFlip():Label{
            return (this._1638941768lblLayerFlip);
        }
        protected function OnCreationComplete():void{
            var _local1:Sort = new Sort();
            _local1.fields = [new SortField("depth", false, true, true)];
            m_rgLayers.sort = _local1;
            lstLayers.addEventListener(ListEvent.CHANGE, OnLayersChange);
            lstLayers.addEventListener(FlexEvent.VALUE_COMMIT, OnLayersChange);
            this.addEventListener(FlexEvent.DATA_CHANGE, OnLayersChange);
        }
        public function ResetLayers():void{
            m_rgLayers.removeAll();
        }
        public function OnLayerTransparencyChange():void{
            if (lstLayers.selectedIndex < 0){
                return;
            };
            var _local1:Layer = (m_rgLayers[lstLayers.selectedIndex] as Layer);
            _local1.opacity = (100 - sdrLayerTransparency.value);
            this.dispatchEvent(new ResultEvent(BlingeeMaker.LAYER_CHANGED_OPACITY, true, true, _local1));
        }
        public function set lblLayerTransparency(_arg1:Label):void{
            var _local2:Object = this._730301491lblLayerTransparency;
            if (_local2 !== _arg1){
                this._730301491lblLayerTransparency = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblLayerTransparency", _local2, _arg1));
            };
        }
        protected function get m_rgLayers():ArrayCollection{
            return (this._449965929m_rgLayers);
        }
        public function get lstLayers():List{
            return (this._1231513745lstLayers);
        }
        public function __btnLayerFlipVertical_click(_arg1:MouseEvent):void{
            OnBtnLayerFlipVertical();
        }
        public function get languageResource():ResourceBundle{
            return (m_rbLanguage);
        }
        public function get btnLayerMoveDown():Button{
            return (this._1662336120btnLayerMoveDown);
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _LayersTab_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_LayersTabWatcherSetupUtil");
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
        protected function FindLayerIndexByDepth(_arg1:int):int{
            var _local2 = -1;
            var _local3:int;
            while (_local3 < m_rgLayers.length) {
                if (_arg1 == Layer(m_rgLayers[_local3]).depth){
                    _local2 = _local3;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        public function SelectLayer(_arg1:int):void{
            var _local2:int = FindLayerIndexById(_arg1);
            if (_local2 < 0){
                return;
            };
            lstLayers.selectedIndex = _local2;
            lstLayers.scrollToIndex(_local2);
        }
        public function OnBtnLayerFlipVertical():void{
            if (lstLayers.selectedIndex < 0){
                return;
            };
            this.dispatchEvent(new ResultEvent(BlingeeMaker.LAYER_FLIPED_VERTICAL, true, true, (m_rgLayers[lstLayers.selectedIndex] as Layer)));
        }
        public function set lblEmtpyMessage(_arg1:TextArea):void{
            var _local2:Object = this._1144385720lblEmtpyMessage;
            if (_local2 !== _arg1){
                this._1144385720lblEmtpyMessage = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblEmtpyMessage", _local2, _arg1));
            };
        }
        private function _LayersTab_bindingExprs():void{
            var _local1:*;
            _local1 = languageResource.getString("lblEmtpyMessage_text");
            _local1 = languageResource.getString("btnLayerMoveUp_toolTip");
            _local1 = actionMoveUpSymbol;
            _local1 = languageResource.getString("btnLayerMoveDown_toolTip");
            _local1 = actionMoveDownSymbol;
            _local1 = m_rgLayers;
            _local1 = languageResource.getString("lblLayerFlip_label");
            _local1 = languageResource.getString("btnLayerFlipHorizontal_toolTip");
            _local1 = actionFlipHorizontalSymbol;
            _local1 = languageResource.getString("btnLayerFlipVertical_toolTip");
            _local1 = actionFlipVerticalSymbol;
            _local1 = languageResource.getString("lblLayerTransparency_label");
            _local1 = languageResource.getString("lblLayerMotion_label");
            _local1 = m_rgLayerMotions;
        }
        protected function set m_rgLayerMotions(_arg1:ArrayCollection):void{
            var _local2:Object = this._2019414573m_rgLayerMotions;
            if (_local2 !== _arg1){
                this._2019414573m_rgLayerMotions = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_rgLayerMotions", _local2, _arg1));
            };
        }
        public function OnBtnLayerMoveDown():void{
            if (lstLayers.selectedIndex < 0){
                return;
            };
            if (lstLayers.selectedIndex >= (m_rgLayers.length - 1)){
                return;
            };
            this.SwapLayers(lstLayers.selectedIndex, (lstLayers.selectedIndex + 1));
        }
        public function set lblLayerFlip(_arg1:Label):void{
            var _local2:Object = this._1638941768lblLayerFlip;
            if (_local2 !== _arg1){
                this._1638941768lblLayerFlip = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblLayerFlip", _local2, _arg1));
            };
        }
        public function set lblLayerMotion(_arg1:Label):void{
            var _local2:Object = this._1026459439lblLayerMotion;
            if (_local2 !== _arg1){
                this._1026459439lblLayerMotion = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblLayerMotion", _local2, _arg1));
            };
        }
        public function __btnLayerMoveUp_click(_arg1:MouseEvent):void{
            OnBtnLayerMoveUp();
        }
        protected function FindLayerIndexById(_arg1:int):int{
            var _local2 = -1;
            var _local3:int;
            while (_local3 < m_rgLayers.length) {
                if (_arg1 == Layer(m_rgLayers[_local3]).id){
                    _local2 = _local3;
                    break;
                };
                _local3++;
            };
            return (_local2);
        }
        public function Initialize():void{
        }
        public function get lblLayerMotion():Label{
            return (this._1026459439lblLayerMotion);
        }
        protected function set m_rgLayers(_arg1:ArrayCollection):void{
            var _local2:Object = this._449965929m_rgLayers;
            if (_local2 !== _arg1){
                this._449965929m_rgLayers = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_rgLayers", _local2, _arg1));
            };
        }
        protected function get m_rgLayerMotions():ArrayCollection{
            return (this._2019414573m_rgLayerMotions);
        }
        protected function SwapLayers(_arg1:int, _arg2:int, _arg3:Boolean=true):void{
            var _local4:Layer = (m_rgLayers.getItemAt(_arg1) as Layer);
            var _local5:Layer = (m_rgLayers.getItemAt(_arg2) as Layer);
            var _local6:int = _local4.depth;
            _local4.depth = _local5.depth;
            _local5.depth = _local6;
            m_rgLayers.refresh();
            lstLayers.selectedIndex = _arg2;
            if (_arg3){
                this.dispatchEvent(new ResultEvent(BlingeeMaker.LAYER_SWAPED_DEPTH, true, true, _local4));
            };
        }
        private function _LayersTab_ClassFactory2_c():ClassFactory{
            var _local1:ClassFactory = new ClassFactory();
            _local1.generator = LayerMotionLineRenderer;
            return (_local1);
        }
        public function set lstLayers(_arg1:List):void{
            var _local2:Object = this._1231513745lstLayers;
            if (_local2 !== _arg1){
                this._1231513745lstLayers = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lstLayers", _local2, _arg1));
            };
        }
        public function OnBtnLayerMoveUp():void{
            if (lstLayers.selectedIndex < 1){
                return;
            };
            this.SwapLayers(lstLayers.selectedIndex, (lstLayers.selectedIndex - 1));
        }
        public function __sdrLayerTransparency_change(_arg1:SliderEvent):void{
            OnLayerTransparencyChange();
        }
        public function UpdateLayer(_arg1:int, _arg2:Photo, _arg3:int, _arg4:int, _arg5:int, _arg6:int):void{
            var _local8:Layer;
            var _local9:int;
            var _local7:int = FindLayerIndexById(_arg1);
            if (_local7 < 0){
                m_rgLayers.addItem(new Layer(_arg1, _arg2, _arg3, _arg4, _arg5));
                if (1 == m_rgLayers.length){
                    lstLayers.selectedIndex = (m_rgLayers.length - 1);
                };
            } else {
                _local8 = (m_rgLayers[_local7] as Layer);
                _local8.opacity = _arg5;
                _local8.motionType = _arg6;
                _local9 = this.FindLayerIndexByDepth(_arg4);
                if ((((_local9 < 0)) || ((_local7 == _local9)))){
                    _local8.depth = _arg4;
                    if (lstLayers.selectedIndex != _local9){
                        lstLayers.selectedIndex = _local9;
                    } else {
                        this.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
                    };
                } else {
                    this.SwapLayers(_local7, _local9, false);
                };
            };
            m_rgLayers.refresh();
            if (m_rgLayers.length > 0){
                lblEmtpyMessage.visible = false;
                lblEmtpyMessage.includeInLayout = false;
            };
        }
        protected function FindLayerById(_arg1:int):Layer{
            var _local2:Layer;
            var _local3:int = FindLayerIndexById(_arg1);
            if (_local3 >= 0){
                _local2 = (m_rgLayers[_local3] as Layer);
            };
            return (_local2);
        }
        public function set btnLayerFlipVertical(_arg1:Button):void{
            var _local2:Object = this._315526136btnLayerFlipVertical;
            if (_local2 !== _arg1){
                this._315526136btnLayerFlipVertical = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnLayerFlipVertical", _local2, _arg1));
            };
        }
        public function __btnLayerMoveDown_click(_arg1:MouseEvent):void{
            OnBtnLayerMoveDown();
        }
        private function _LayersTab_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("lblEmtpyMessage_text");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblEmtpyMessage.text = _arg1;
            }, "lblEmtpyMessage.text");
            result[0] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("btnLayerMoveUp_toolTip");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnLayerMoveUp.toolTip = _arg1;
            }, "btnLayerMoveUp.toolTip");
            result[1] = binding;
            binding = new Binding(this, function ():Class{
                return (actionMoveUpSymbol);
            }, function (_arg1:Class):void{
                btnLayerMoveUp.setStyle("icon", _arg1);
            }, "btnLayerMoveUp.icon");
            result[2] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("btnLayerMoveDown_toolTip");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnLayerMoveDown.toolTip = _arg1;
            }, "btnLayerMoveDown.toolTip");
            result[3] = binding;
            binding = new Binding(this, function ():Class{
                return (actionMoveDownSymbol);
            }, function (_arg1:Class):void{
                btnLayerMoveDown.setStyle("icon", _arg1);
            }, "btnLayerMoveDown.icon");
            result[4] = binding;
            binding = new Binding(this, function ():Object{
                return (m_rgLayers);
            }, function (_arg1:Object):void{
                lstLayers.dataProvider = _arg1;
            }, "lstLayers.dataProvider");
            result[5] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("lblLayerFlip_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblLayerFlip.text = _arg1;
            }, "lblLayerFlip.text");
            result[6] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("btnLayerFlipHorizontal_toolTip");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnLayerFlipHorizontal.toolTip = _arg1;
            }, "btnLayerFlipHorizontal.toolTip");
            result[7] = binding;
            binding = new Binding(this, function ():Class{
                return (actionFlipHorizontalSymbol);
            }, function (_arg1:Class):void{
                btnLayerFlipHorizontal.setStyle("icon", _arg1);
            }, "btnLayerFlipHorizontal.icon");
            result[8] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("btnLayerFlipVertical_toolTip");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnLayerFlipVertical.toolTip = _arg1;
            }, "btnLayerFlipVertical.toolTip");
            result[9] = binding;
            binding = new Binding(this, function ():Class{
                return (actionFlipVerticalSymbol);
            }, function (_arg1:Class):void{
                btnLayerFlipVertical.setStyle("icon", _arg1);
            }, "btnLayerFlipVertical.icon");
            result[10] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("lblLayerTransparency_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblLayerTransparency.text = _arg1;
            }, "lblLayerTransparency.text");
            result[11] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = languageResource.getString("lblLayerMotion_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblLayerMotion.text = _arg1;
            }, "lblLayerMotion.text");
            result[12] = binding;
            binding = new Binding(this, function ():Object{
                return (m_rgLayerMotions);
            }, function (_arg1:Object):void{
                cmbLayerMotion.dataProvider = _arg1;
            }, "cmbLayerMotion.dataProvider");
            result[13] = binding;
            return (result);
        }
        public function get btnLayerFlipVertical():Button{
            return (this._315526136btnLayerFlipVertical);
        }
        private function set _526654586languageResource(_arg1:ResourceBundle):void{
            m_rbLanguage = _arg1;
            InitializeMotionList();
        }

    }
}//package 
