package {
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.text.*;
    import mx.core.*;
    import mx.managers.*;
    import flash.events.*;
    import mx.events.*;
    import mx.resources.*;
    import mx.styles.*;
    import mx.controls.*;
    import mx.states.*;
    import mx.binding.*;
    import mx.rpc.events.*;
    import mx.containers.*;
    import mx.rpc.http.mxml.*;
    import src.*;
    import flexlib.controls.*;
    import mx.controls.listClasses.*;
    import mx.collections.*;
    import flexlib.controls.tabBarClasses.*;
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

    public class BlingeeMaker extends Application implements IBindingClient {

        protected static const c_iConnectionChunkSize:int = 0x7000;
        public static const TOOLSUBTYPE_ROTATERIGHT:int = 4;
        public static const c_iTabPageSizeDefault:int = 16;
        protected static const c_strLoadTimeoutDialogTitle:String = "Loading Error";
        public static const TOOLTYPE_PEN:int = 3;
        protected static const c_strConnectionReceiving:String = "BlingeeToolToWrapper";
        public static const TOOLSUBTYPE_SCALEDOWN:int = 2;
        public static const TOOLTYPE_ADD:int = 1;
        protected static const c_strResetAlertDialogTitle:String = "Reset Confirmation";
        public static const TAB_LAST_PAGE_CLICKED:String = "TAB_LAST_PAGE_CLICKED_EVENT";
        public static const c_iUpgradeOnTabLastPageMinTabSizeFactor:int = 5;
        public static const LAYER_SET_MOTION:String = "LAYER_SET_MOTION_EVENT";
        public static const TOOLTYPE_MOVE:int = 2;
        public static const TOOLSUBTYPE_MOVE:int = 0;
        public static const c_strBlingeeTooPath:String = "/swfs/blingee_tool";
        public static const CONFIG_LOAD_EMBEDDED_BLINGEETOOL:Boolean = true;
        public static const LAYER_CHANGED_OPACITY:String = "LAYER_CHANGED_OPACITY_EVENT";
        public static const DEFAULT_PEN_WIDTH:int = 5;
        public static const DEFAULT_FONTS:Array = [{
            data:0,
            label:"Normal"
        }, {
            data:4,
            label:"Girly"
        }, {
            data:5,
            label:"Gothic"
        }, {
            data:2,
            label:"Graffiti"
        }, {
            data:1,
            label:"Hippie"
        }, {
            data:3,
            label:"Script"
        }];
        protected static const c_strConnectionSending:String = "WrapperToBlingeeTool";
        public static const TOOLSUBTYPE_SCALEUP:int = 1;
        public static const TOOLTYPE_FILL:int = 0;
        public static const c_iLoadTimeoutSeconds:int = 60;
        public static const DEFAULT_FONT_SIZE:int = 36;
        public static const TOOLTYPE_ERASE:int = 5;
        public static const CREATED_PHOTO:String = "CREATED_PHOTO_EVENT";
        public static const LAYER_SWAPED_DEPTH:String = "LAYER_SWAPED_DEPTH_EVENT";
        public static const LAYER_FLIPED_HORIZONTAL:String = "LAYER_FLIPED_HORIZONTAL_EVENT";
        public static const c_iTabPageSizeAlt:int = 15;
        public static const c_iConcurentImageLoads:int = 10;
        public static const LOCKED_CONTENT_CLICKED:String = "LOCKED_CONTENT_CLICKED_EVENT";
        public static const SELECTED_PHOTO:String = "SELECTED_PHOTO_EVENT";
        public static const c_iLockedContentThresholdDefault:int = 160;
        public static const TOOLTYPE_TEXT:int = 4;
        public static const LAYER_FLIPED_VERTICAL:String = "LAYER_FLIPED_VERTICAL_EVENT";
        public static const TOOLSUBTYPE_ROTATELEFT:int = 3;

        private static var _watcherSetupUtil:IWatcherSetupUtil;
        mx_internal static var _BlingeeMaker_StylesInit_done:Boolean = false;

        private var _1727029869gridPenWidth:Grid;
        private var contentLayerSymbol:Class;
        private var _206185977btnSave:Button;
        protected var m_mapSelectedPhotos:Dictionary;
        private var _458075144gridTextTools:Grid;
        private var _2095990867btnReset:Button;
        private var _252027thumbnailTabPanel:Canvas;
        private var cursorZoomOutSymbol:Class;
        private var _895705168lblSaving:Label;
        mx_internal var _bindingsByDestination:Object;
        protected var m_iTabPageSize:int = 16;
        private var _embed_mxml_graphics_ZOOMOUTbutton_png_182742576:Class;
        private var _881829287cmbFont:ComboBox;
        private var _143482968blingeeToolClass:Class;
        protected var _255537731m_strLoadTimeoutDialogMessage:String;
        protected var m_mainToolbarSelectedButton:Button;
        private var rbPortuguese:ResourceBundle;
        private var _721380233btnScaleUp:Button;
        protected var m_fRequireToolbar:Boolean = true;
        protected var m_lcSending:LocalConnection;
        protected var m_FirstPhoto:Photo;
        private var rbSpanish:ResourceBundle;
        private var _315768297contentTabBar:SuperTabBarEx;
        protected var m_loadTimer:Timer;
        private var _embed_mxml_graphics_RESETbutton_png_464360864:Class;
        private var cursorMoveSymbol:Class;
        private var _embed_mxml_graphics_SAVEbutton_png_1471188342:Class;
        protected var m_fSuggestUpgradeOnTabLastPage:Boolean = false;
        protected var m_SelectedThumbnailOwner:ListBase;
        protected var m_strBlingeeData:String = "";
        protected var m_GoodieBagThumbnailTab:SlimThumbnailTab;
        private var _embed_mxml_graphics_PENbutton_png_971043756:Class;
        private var cursorFillSymbol:Class;
        protected var m_strConnectionSending:String;
        private var _1435898491btnRotateRight:Button;
        private var contentStampSymbol:Class;
        private var _206219689btnText:Button;
        private var _1076106611workPanel:Canvas;
        private var _1378839387btnAdd:Button;
        protected var m_SelectedThumbnail:Thumbnail;
        protected var m_strXmlImageConfig:String = "";
        private var cursorTextSymbol:Class;
        protected var m_iLockedContentThreshold:Number = 160;
        protected var m_photoLoadingQueue:ArrayCollection;
        protected var m_rgMainToolbarButtons:ArrayCollection;
        protected var m_strConnectionSuffix:String = "nosfx";
        private var rbDutch:ResourceBundle;
        private var cursorPenSymbol:Class;
        private var _579312420btnSearch:Button;
        private var _1808376718sdrPenWidth:HSlider;
        private var _986293969layersTabPanel:VBox;
        private var _embed_mxml_graphics_TEXTbutton_png_1504955702:Class;
        protected var m_layersTab:LayersTab;
        protected var m_fStampSearchEnabled:Boolean = false;
        private var cursorRotateRightSymbol:Class;
        mx_internal var _bindingsBeginWithWord:Object;
        private var _embed_mxml_graphics_find_png_1842950354:Class;
        private var rbJapanese:ResourceBundle;
        private var _77115900previewThumbnail:Thumbnail;
        private var iconFindSymbol:Class;
        protected var m_InkThumbnailTab:SlimThumbnailTab;
        private var _2145423051swfLoader:Image;
        private var rbEnglish:ResourceBundle;
        private var _1309877340nmsFontSize:NumericStepper;
        protected var m_fDisableUpgradeTab:Boolean = false;
        protected var m_fDisableUpgradeOnTabLastPage = false;
        private var _1198576870contentTabList:ViewStack;
        private var _812125315boxPreview:Panel;
        private var _1502273288contentTabPanel:Canvas;
        private var _1756165648btnScaleDown:Button;
        protected var _2026944317m_Service:PhotoService;
        private var _embed_mxml_graphics_ZOOMINbutton_png_55551180:Class;
        private var _1679445173httpServiceLoadConfig:HTTPService;
        protected var m_lcReceiving:LocalConnection;
        protected var _461153877m_strDefaultLoadingString:String;
        protected var m_strXmlInput:String = "";
        private var _embed_mxml_graphics_FILLbutton_png_1505219430:Class;
        public var _BlingeeMaker_SetProperty10:SetProperty;
        protected var m_rgThumbnailTabs:ArrayCollection;
        private var cursorZoomInSymbol:Class;
        protected var m_strServerUrl:String = "";
        private var cursorEraseSymbol:Class;
        private var _1825284746thumbnailTabs:CustomButtonScrollingCanvas;
        private var _embed_mxml_graphics_ADDbutton_png_955052988:Class;
        protected var m_strEncryptionKey:String;
        private var _3632rb:ResourceBundle;
        private var _embed_mxml_graphics_RRRRbutton_png_1739642604:Class;
        private var contentUpgradeSymbol:Class;
        private var cursorAddSymbol:Class;
        private var _1524123833thumbnailTabList:ViewStack;
        private var _923329406btnRotateLeft:Button;
        private var _embed_mxml_graphics_ERASEbutton_png_1514180978:Class;
        protected var m_fLockContentAboveThreshold:Boolean = false;
        private var _embed_mxml_graphics_UNDObutton_png_1701844772:Class;
        protected var m_fInkWasSelected:Boolean = false;
        private var _1694553506gridPreview:Grid;
        private var _206257504btnUndo:Button;
        private var _embed_mxml_graphics_RRRLbutton_png_1718663152:Class;
        private var _1378824931btnPen:Button;
        protected var m_ContentThumnailItemRenderer:ClassFactory = null;
        private var _1634065648boxToolBar:VBox;
        private var _1736356154gridTransform:Grid;
        public var _BlingeeMaker_SetProperty1:SetProperty;
        public var _BlingeeMaker_SetProperty2:SetProperty;
        public var _BlingeeMaker_SetProperty3:SetProperty;
        public var _BlingeeMaker_SetProperty4:SetProperty;
        public var _BlingeeMaker_SetProperty5:SetProperty;
        private var _205806079btnFill:Button;
        public var _BlingeeMaker_SetProperty7:SetProperty;
        public var _BlingeeMaker_SetProperty8:SetProperty;
        public var _BlingeeMaker_SetProperty9:SetProperty;
        protected var m_fCreationCompleted:Boolean = false;
        public var _BlingeeMaker_SetProperty6:SetProperty;
        public var _BlingeeMaker_Label4:Label;
        public var _BlingeeMaker_Label5:Label;
        private var _53916763cvsPenWidthPreview:Canvas;
        private var _embed_mxml_graphics_MOVEbutton_png_1471403278:Class;
        protected var m_strUpgradeMessage = "";
        private var _460758694lblLoading:Label;
        protected var m_renameLocalConnectionTimer:Timer;
        mx_internal var _watchers:Array;
        public var m_strBufferC:String = "XOTT0lh26MWhWz87IH";
        public var m_strBufferD:String = "DFqe25c";
        public var m_strBufferE:String = "EHDKE2Er";
        public var m_strBufferH:String = "4t39LjJp3wxLk";
        protected var _840947981m_strResetAlertDialogMessage:String;
        private var cursorRotateLeftSymbol:Class;
        public var m_strBufferT:String = "rAI1P8bpXoReutED8";
        private var rbItalian:ResourceBundle;
        protected var m_fHasToolbar:Boolean = false;
        protected var m_strConnectionReceiving:String;
        protected var m_loadBlingeeTypesTimer:Timer;
        private var _206020685btnMove:Button;
        private var rbGerman:ResourceBundle;
        private var _2084355498btnErase:Button;
        private var rbFrench:ResourceBundle;
        mx_internal var _bindings:Array;
        private var _1751940170thumbnailTabBar:SuperTabBar;
        private var _documentDescriptor_:UIComponentDescriptor;
        protected var m_idCursor:Number = 0;

        public function BlingeeMaker(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:Application,
                propertiesFactory:function ():Object{
                    return ({childDescriptors:[new UIComponentDescriptor({
                            type:Canvas,
                            id:"workPanel",
                            propertiesFactory:function ():Object{
                                return ({
                                    height:474,
                                    visible:false,
                                    includeInLayout:false,
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:Panel,
                                        id:"boxPreview",
                                        stylesFactory:function ():void{
                                            this.borderStyle = "solid";
                                            this.borderThickness = 1;
                                            this.cornerRadius = 0;
                                            this.dropShadowEnabled = false;
                                            this.horizontalAlign = "center";
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                x:140,
                                                y:0,
                                                width:432,
                                                percentHeight:100,
                                                verticalScrollPolicy:"off",
                                                horizontalScrollPolicy:"off",
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:Label,
                                                    id:"lblLoading"
                                                }), new UIComponentDescriptor({
                                                    type:Label,
                                                    id:"lblSaving",
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            visible:false,
                                                            includeInLayout:false
                                                        });
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:Image,
                                                    id:"swfLoader",
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            width:406,
                                                            height:406,
                                                            maintainAspectRatio:true,
                                                            scaleContent:false,
                                                            visible:false,
                                                            includeInLayout:false,
                                                            styleName:"thumbnailDefault"
                                                        });
                                                    }
                                                })]
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:VBox,
                                        id:"boxToolBar",
                                        stylesFactory:function ():void{
                                            this.cornerRadius = 0;
                                            this.backgroundColor = 0xFFFFFF;
                                            this.borderStyle = "solid";
                                            this.borderThickness = 1;
                                            this.dropShadowEnabled = false;
                                            this.paddingLeft = 0;
                                            this.paddingRight = 0;
                                            this.paddingTop = 8;
                                            this.paddingBottom = 8;
                                            this.horizontalAlign = "center";
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                x:0,
                                                y:0,
                                                width:130,
                                                percentHeight:100,
                                                verticalScrollPolicy:"off",
                                                horizontalScrollPolicy:"off",
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:VBox,
                                                    stylesFactory:function ():void{
                                                        this.borderThickness = 0;
                                                        this.horizontalAlign = "center";
                                                    },
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            width:110,
                                                            percentHeight:100,
                                                            horizontalScrollPolicy:"off",
                                                            childDescriptors:[new UIComponentDescriptor({
                                                                type:Grid,
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnAdd",
                                                                                                    events:{
                                                                                                        change:"__btnAdd_change",
                                                                                                        valueCommit:"__btnAdd_valueCommit"
                                                                                                    },
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_ADDbutton_png_955052988;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    }), new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnMove",
                                                                                                    events:{change:"__btnMove_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_MOVEbutton_png_1471403278;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        }), new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnPen",
                                                                                                    events:{change:"__btnPen_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_PENbutton_png_971043756;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    }), new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnFill",
                                                                                                    events:{change:"__btnFill_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_FILLbutton_png_1505219430;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        }), new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnText",
                                                                                                    events:{change:"__btnText_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_TEXTbutton_png_1504955702;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    }), new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnErase",
                                                                                                    events:{change:"__btnErase_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_ERASEbutton_png_1514180978;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Spacer,
                                                                propertiesFactory:function ():Object{
                                                                    return ({height:0});
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                id:"gridTransform",
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnScaleUp",
                                                                                                    events:{change:"__btnScaleUp_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_ZOOMINbutton_png_55551180;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    }), new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnScaleDown",
                                                                                                    events:{change:"__btnScaleDown_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_ZOOMOUTbutton_png_182742576;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        }), new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnRotateLeft",
                                                                                                    events:{change:"__btnRotateLeft_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_RRRLbutton_png_1718663152;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    }), new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnRotateRight",
                                                                                                    events:{change:"__btnRotateRight_change"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_RRRRbutton_png_1739642604;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:50,
                                                                                                            toggle:true
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                id:"gridPenWidth",
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        visible:false,
                                                                        includeInLayout:false,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                colSpan:2,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:VBox,
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.horizontalAlign = "center";
                                                                                                        this.borderStyle = "solid";
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:100,
                                                                                                            childDescriptors:[new UIComponentDescriptor({
                                                                                                                type:HBox,
                                                                                                                stylesFactory:function ():void{
                                                                                                                    this.horizontalAlign = "left";
                                                                                                                },
                                                                                                                propertiesFactory:function ():Object{
                                                                                                                    return ({
                                                                                                                        percentWidth:100,
                                                                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                                                                            type:Label,
                                                                                                                            propertiesFactory:function ():Object{
                                                                                                                                return ({text:"Pen width:"});
                                                                                                                            }
                                                                                                                        })]
                                                                                                                    });
                                                                                                                }
                                                                                                            }), new UIComponentDescriptor({
                                                                                                                type:Canvas,
                                                                                                                id:"cvsPenWidthPreview",
                                                                                                                propertiesFactory:function ():Object{
                                                                                                                    return ({
                                                                                                                        width:50,
                                                                                                                        height:50
                                                                                                                    });
                                                                                                                }
                                                                                                            }), new UIComponentDescriptor({
                                                                                                                type:HSlider,
                                                                                                                id:"sdrPenWidth",
                                                                                                                events:{change:"__sdrPenWidth_change"},
                                                                                                                propertiesFactory:function ():Object{
                                                                                                                    return ({
                                                                                                                        width:90,
                                                                                                                        minimum:2,
                                                                                                                        maximum:50,
                                                                                                                        snapInterval:1,
                                                                                                                        liveDragging:true
                                                                                                                    });
                                                                                                                }
                                                                                                            })]
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                id:"gridTextTools",
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        visible:false,
                                                                        includeInLayout:false,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                colSpan:2,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:VBox,
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.horizontalAlign = "left";
                                                                                                        this.borderStyle = "solid";
                                                                                                        this.paddingLeft = 5;
                                                                                                        this.paddingBottom = 5;
                                                                                                        this.verticalGap = 0;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:100,
                                                                                                            verticalScrollPolicy:"off",
                                                                                                            horizontalScrollPolicy:"off",
                                                                                                            childDescriptors:[new UIComponentDescriptor({
                                                                                                                type:Label,
                                                                                                                id:"_BlingeeMaker_Label4"
                                                                                                            }), new UIComponentDescriptor({
                                                                                                                type:ComboBox,
                                                                                                                id:"cmbFont",
                                                                                                                events:{change:"__cmbFont_change"},
                                                                                                                propertiesFactory:function ():Object{
                                                                                                                    return ({
                                                                                                                        editable:false,
                                                                                                                        width:85
                                                                                                                    });
                                                                                                                }
                                                                                                            }), new UIComponentDescriptor({
                                                                                                                type:Label,
                                                                                                                id:"_BlingeeMaker_Label5"
                                                                                                            }), new UIComponentDescriptor({
                                                                                                                type:NumericStepper,
                                                                                                                id:"nmsFontSize",
                                                                                                                events:{change:"__nmsFontSize_change"},
                                                                                                                propertiesFactory:function ():Object{
                                                                                                                    return ({
                                                                                                                        width:85,
                                                                                                                        minimum:1,
                                                                                                                        maximum:100,
                                                                                                                        stepSize:1
                                                                                                                    });
                                                                                                                }
                                                                                                            })]
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Spacer,
                                                                propertiesFactory:function ():Object{
                                                                    return ({height:0});
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                id:"gridPreview",
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                colSpan:2,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Thumbnail,
                                                                                                    id:"previewThumbnail",
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            showThumnail:false,
                                                                                                            showLoading:true,
                                                                                                            width:100,
                                                                                                            height:100
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Spacer,
                                                                propertiesFactory:function ():Object{
                                                                    return ({percentHeight:100});
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnUndo",
                                                                                                    events:{buttonDown:"__btnUndo_buttonDown"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_UNDObutton_png_1701844772;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({width:100});
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        }), new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnReset",
                                                                                                    events:{buttonDown:"__btnReset_buttonDown"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_RESETbutton_png_464360864;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({width:100});
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:HRule,
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        percentWidth:100,
                                                                        height:1
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:Grid,
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        width:110,
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:GridRow,
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    percentWidth:100,
                                                                                    childDescriptors:[new UIComponentDescriptor({
                                                                                        type:GridItem,
                                                                                        stylesFactory:function ():void{
                                                                                            this.horizontalAlign = "center";
                                                                                        },
                                                                                        propertiesFactory:function ():Object{
                                                                                            return ({
                                                                                                percentWidth:100,
                                                                                                childDescriptors:[new UIComponentDescriptor({
                                                                                                    type:Button,
                                                                                                    id:"btnSave",
                                                                                                    events:{click:"__btnSave_click"},
                                                                                                    stylesFactory:function ():void{
                                                                                                        this.icon = _embed_mxml_graphics_SAVEbutton_png_1471188342;
                                                                                                    },
                                                                                                    propertiesFactory:function ():Object{
                                                                                                        return ({
                                                                                                            width:100,
                                                                                                            enabled:false
                                                                                                        });
                                                                                                    }
                                                                                                })]
                                                                                            });
                                                                                        }
                                                                                    })]
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            })]
                                                        });
                                                    }
                                                })]
                                            });
                                        }
                                    })]
                                });
                            }
                        }), new UIComponentDescriptor({
                            type:Canvas,
                            id:"contentTabPanel",
                            propertiesFactory:function ():Object{
                                return ({
                                    width:572,
                                    height:486,
                                    visible:false,
                                    includeInLayout:false,
                                    verticalScrollPolicy:"off",
                                    horizontalScrollPolicy:"off",
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:SuperTabBarEx,
                                        id:"contentTabBar",
                                        stylesFactory:function ():void{
                                            this.tabWidth = 120;
                                            this.tabHeight = 31;
                                            this.tabStyleName = "contentTabBarTab";
                                            this.selectedTabTextStyleName = "contentTabBarSelectedTabText";
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                x:0,
                                                y:0,
                                                percentWidth:100,
                                                dragEnabled:false,
                                                dropEnabled:false,
                                                toggleOnClick:true,
                                                styleName:"contentTabBar"
                                            });
                                        }
                                    }), new UIComponentDescriptor({
                                        type:ViewStack,
                                        id:"contentTabList",
                                        stylesFactory:function ():void{
                                            this.paddingLeft = 0;
                                            this.paddingTop = 0;
                                            this.paddingRight = 0;
                                            this.paddingBottom = 0;
                                        },
                                        propertiesFactory:function ():Object{
                                            return ({
                                                x:0,
                                                y:30,
                                                percentWidth:100,
                                                percentHeight:100,
                                                styleName:"contentTabList",
                                                childDescriptors:[new UIComponentDescriptor({
                                                    type:Canvas,
                                                    id:"thumbnailTabPanel",
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            x:0,
                                                            y:0,
                                                            percentWidth:100,
                                                            percentHeight:100,
                                                            verticalScrollPolicy:"off",
                                                            horizontalScrollPolicy:"off",
                                                            childDescriptors:[new UIComponentDescriptor({
                                                                type:ViewStack,
                                                                id:"thumbnailTabList",
                                                                stylesFactory:function ():void{
                                                                    this.cornerRadius = 0;
                                                                    this.borderStyle = "solid";
                                                                    this.borderThickness = 1;
                                                                    this.paddingTop = 5;
                                                                    this.paddingRight = 5;
                                                                    this.paddingBottom = 5;
                                                                    this.paddingLeft = 5;
                                                                },
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        x:129,
                                                                        y:0,
                                                                        percentWidth:100,
                                                                        percentHeight:100,
                                                                        styleName:"thumbnailTabList"
                                                                    });
                                                                }
                                                            }), new UIComponentDescriptor({
                                                                type:CustomButtonScrollingCanvas,
                                                                id:"thumbnailTabs",
                                                                propertiesFactory:function ():Object{
                                                                    return ({
                                                                        x:0,
                                                                        y:0,
                                                                        width:130,
                                                                        percentHeight:100,
                                                                        buttonWidth:20,
                                                                        horizontalScrollPolicy:"off",
                                                                        verticalScrollPolicy:"auto",
                                                                        childDescriptors:[new UIComponentDescriptor({
                                                                            type:SuperTabBar,
                                                                            id:"thumbnailTabBar",
                                                                            stylesFactory:function ():void{
                                                                                this.tabWidth = 130;
                                                                                this.tabHeight = 30;
                                                                                this.tabStyleName = "thumbnailTabBarButton";
                                                                            },
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    direction:"vertical",
                                                                                    dragEnabled:false,
                                                                                    dropEnabled:false,
                                                                                    toggleOnClick:true
                                                                                });
                                                                            }
                                                                        }), new UIComponentDescriptor({
                                                                            type:Button,
                                                                            id:"btnSearch",
                                                                            events:{click:"__btnSearch_click"},
                                                                            stylesFactory:function ():void{
                                                                                this.icon = _embed_mxml_graphics_find_png_1842950354;
                                                                            },
                                                                            propertiesFactory:function ():Object{
                                                                                return ({
                                                                                    styleName:"thumbnailTabBarSearchButton",
                                                                                    width:130,
                                                                                    height:30,
                                                                                    visible:false
                                                                                });
                                                                            }
                                                                        })]
                                                                    });
                                                                }
                                                            })]
                                                        });
                                                    }
                                                }), new UIComponentDescriptor({
                                                    type:VBox,
                                                    id:"layersTabPanel",
                                                    propertiesFactory:function ():Object{
                                                        return ({
                                                            percentWidth:100,
                                                            percentHeight:100,
                                                            styleName:"contentTab"
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
            _143482968blingeeToolClass = BlingeeMaker_blingeeToolClass;
            cursorAddSymbol = BlingeeMaker_cursorAddSymbol;
            cursorFillSymbol = BlingeeMaker_cursorFillSymbol;
            cursorMoveSymbol = BlingeeMaker_cursorMoveSymbol;
            cursorPenSymbol = BlingeeMaker_cursorPenSymbol;
            cursorTextSymbol = BlingeeMaker_cursorTextSymbol;
            cursorEraseSymbol = BlingeeMaker_cursorEraseSymbol;
            cursorRotateLeftSymbol = BlingeeMaker_cursorRotateLeftSymbol;
            cursorRotateRightSymbol = BlingeeMaker_cursorRotateRightSymbol;
            cursorZoomInSymbol = BlingeeMaker_cursorZoomInSymbol;
            cursorZoomOutSymbol = BlingeeMaker_cursorZoomOutSymbol;
            contentStampSymbol = BlingeeMaker_contentStampSymbol;
            contentLayerSymbol = BlingeeMaker_contentLayerSymbol;
            contentUpgradeSymbol = BlingeeMaker_contentUpgradeSymbol;
            iconFindSymbol = BlingeeMaker_iconFindSymbol;
            rbEnglish = ResourceBundle.getResourceBundle("LocaleEnglish", ApplicationDomain.currentDomain);
            rbFrench = ResourceBundle.getResourceBundle("LocaleFrench", ApplicationDomain.currentDomain);
            rbGerman = ResourceBundle.getResourceBundle("LocaleGerman", ApplicationDomain.currentDomain);
            rbJapanese = ResourceBundle.getResourceBundle("LocaleJapanese", ApplicationDomain.currentDomain);
            rbDutch = ResourceBundle.getResourceBundle("LocaleDutch", ApplicationDomain.currentDomain);
            rbItalian = ResourceBundle.getResourceBundle("LocaleItalian", ApplicationDomain.currentDomain);
            rbPortuguese = ResourceBundle.getResourceBundle("LocalePortuguese", ApplicationDomain.currentDomain);
            rbSpanish = ResourceBundle.getResourceBundle("LocaleSpanish", ApplicationDomain.currentDomain);
            m_rgThumbnailTabs = new ArrayCollection();
            m_mapSelectedPhotos = new Dictionary();
            _embed_mxml_graphics_ADDbutton_png_955052988 = BlingeeMaker__embed_mxml_graphics_ADDbutton_png_955052988;
            _embed_mxml_graphics_ERASEbutton_png_1514180978 = BlingeeMaker__embed_mxml_graphics_ERASEbutton_png_1514180978;
            _embed_mxml_graphics_FILLbutton_png_1505219430 = BlingeeMaker__embed_mxml_graphics_FILLbutton_png_1505219430;
            _embed_mxml_graphics_MOVEbutton_png_1471403278 = BlingeeMaker__embed_mxml_graphics_MOVEbutton_png_1471403278;
            _embed_mxml_graphics_PENbutton_png_971043756 = BlingeeMaker__embed_mxml_graphics_PENbutton_png_971043756;
            _embed_mxml_graphics_RESETbutton_png_464360864 = BlingeeMaker__embed_mxml_graphics_RESETbutton_png_464360864;
            _embed_mxml_graphics_RRRLbutton_png_1718663152 = BlingeeMaker__embed_mxml_graphics_RRRLbutton_png_1718663152;
            _embed_mxml_graphics_RRRRbutton_png_1739642604 = BlingeeMaker__embed_mxml_graphics_RRRRbutton_png_1739642604;
            _embed_mxml_graphics_SAVEbutton_png_1471188342 = BlingeeMaker__embed_mxml_graphics_SAVEbutton_png_1471188342;
            _embed_mxml_graphics_TEXTbutton_png_1504955702 = BlingeeMaker__embed_mxml_graphics_TEXTbutton_png_1504955702;
            _embed_mxml_graphics_UNDObutton_png_1701844772 = BlingeeMaker__embed_mxml_graphics_UNDObutton_png_1701844772;
            _embed_mxml_graphics_ZOOMINbutton_png_55551180 = BlingeeMaker__embed_mxml_graphics_ZOOMINbutton_png_55551180;
            _embed_mxml_graphics_ZOOMOUTbutton_png_182742576 = BlingeeMaker__embed_mxml_graphics_ZOOMOUTbutton_png_182742576;
            _embed_mxml_graphics_find_png_1842950354 = BlingeeMaker__embed_mxml_graphics_find_png_1842950354;
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
                this.horizontalAlign = "left";
                this.verticalAlign = "top";
                this.paddingLeft = 0;
                this.paddingTop = 0;
                this.paddingRight = 0;
                this.paddingBottom = 0;
                this.backgroundAlpha = 0;
            };
            mx_internal::_BlingeeMaker_StylesInit();
            this.layout = "vertical";
            this.states = [_BlingeeMaker_State1_c(), _BlingeeMaker_State2_c()];
            _BlingeeMaker_HTTPService1_i();
            this.addEventListener("initialize", ___BlingeeMaker_Application1_initialize);
            this.addEventListener("creationComplete", ___BlingeeMaker_Application1_creationComplete);
            this.addEventListener("resize", ___BlingeeMaker_Application1_resize);
        }
        public static function set watcherSetupUtil(_arg1:IWatcherSetupUtil):void{
            BlingeeMaker._watcherSetupUtil = _arg1;
        }

        public function __btnErase_change(_arg1:Event):void{
            if (!btnErase.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_ERASE);
            SetCursor(cursorEraseSymbol);
        }
        public function get gridTextTools():Grid{
            return (this._458075144gridTextTools);
        }
        protected function OnBtnResetConfirmed(_arg1:CloseEvent):void{
            if (Alert.YES != _arg1.detail){
                return;
            };
            m_mainToolbarSelectedButton = null;
            btnAdd.selected = true;
            m_lcSending.send(m_strConnectionSending, "OnBtnResetPressed");
            m_layersTab.ResetLayers();
        }
        public function set previewThumbnail(_arg1:Thumbnail):void{
            var _local2:Object = this._77115900previewThumbnail;
            if (_local2 !== _arg1){
                this._77115900previewThumbnail = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "previewThumbnail", _local2, _arg1));
            };
        }
        public function set gridTextTools(_arg1:Grid):void{
            var _local2:Object = this._458075144gridTextTools;
            if (_local2 !== _arg1){
                this._458075144gridTextTools = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridTextTools", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_State2_c():State{
            var _local1:State = new State();
            _local1.name = "saving";
            _local1.basedOn = "loaded";
            _local1.overrides = [_BlingeeMaker_SetProperty6_i(), _BlingeeMaker_SetProperty7_i(), _BlingeeMaker_SetProperty8_i(), _BlingeeMaker_SetProperty9_i(), _BlingeeMaker_SetProperty10_i()];
            return (_local1);
        }
        public function OnToolLayerSelected(_arg1:int):void{
            trace(("OnToolLayerSelected: " + _arg1));
            m_layersTab.SelectLayer(_arg1);
        }
        public function set btnScaleDown(_arg1:Button):void{
            var _local2:Object = this._1756165648btnScaleDown;
            if (_local2 !== _arg1){
                this._1756165648btnScaleDown = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnScaleDown", _local2, _arg1));
            };
        }
        public function set contentTabBar(_arg1:SuperTabBarEx):void{
            var _local2:Object = this._315768297contentTabBar;
            if (_local2 !== _arg1){
                this._315768297contentTabBar = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentTabBar", _local2, _arg1));
            };
        }
        public function get btnMove():Button{
            return (this._206020685btnMove);
        }
        public function get lblSaving():Label{
            return (this._895705168lblSaving);
        }
        public function get thumbnailTabBar():SuperTabBar{
            return (this._1751940170thumbnailTabBar);
        }
        public function get btnReset():Button{
            return (this._2095990867btnReset);
        }
        private function OnLayerSetMotion(_arg1:ResultEvent):void{
            trace("OnLayerSetMotion");
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Layer)){
                return;
            };
            var _local2:Layer = (_arg1.result as Layer);
            m_lcSending.send(m_strConnectionSending, "OnLayerSetMotion", _local2.id, _local2.motionType);
        }
        private function _BlingeeMaker_State1_c():State{
            var _local1:State = new State();
            _local1.name = "loaded";
            _local1.overrides = [_BlingeeMaker_SetProperty1_i(), _BlingeeMaker_SetProperty2_i(), _BlingeeMaker_SetProperty3_i(), _BlingeeMaker_SetProperty4_i(), _BlingeeMaker_SetProperty5_i()];
            return (_local1);
        }
        public function get cvsPenWidthPreview():Canvas{
            return (this._53916763cvsPenWidthPreview);
        }
        private function set rb(_arg1:ResourceBundle):void{
            var _local2:Object = this._3632rb;
            if (_local2 !== _arg1){
                this._3632rb = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rb", _local2, _arg1));
            };
        }
        public function LoadConfigUrl(_arg1:String):void{
            lblLoading.text = rb.getString("lblLoadingPicture_label");
            var _local2:Object = new Object();
            _local2.tmp = Math.random().toString();
            httpServiceLoadConfig.url = _arg1;
            httpServiceLoadConfig.method = "POST";
            httpServiceLoadConfig.send(_local2);
        }
        public function get thumbnailTabPanel():Canvas{
            return (this._252027thumbnailTabPanel);
        }
        protected function set m_strLoadTimeoutDialogMessage(_arg1:String):void{
            var _local2:Object = this._255537731m_strLoadTimeoutDialogMessage;
            if (_local2 !== _arg1){
                this._255537731m_strLoadTimeoutDialogMessage = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_strLoadTimeoutDialogMessage", _local2, _arg1));
            };
        }
        public function __nmsFontSize_change(_arg1:NumericStepperEvent):void{
            OnFontSizeChanged();
        }
        protected function OnBtnSearchPressed():void{
            ExternalInterface.call("searchStamps", "");
        }
        private function OnSelectedPhoto(_arg1:ResultEvent):void{
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Thumbnail)){
                return;
            };
            SelectThumbnail((_arg1.result as Thumbnail));
        }
        public function ___BlingeeMaker_Application1_initialize(_arg1:FlexEvent):void{
            Initialize();
        }
        private function OnLayerFlipedVertical(_arg1:ResultEvent):void{
            trace("OnLayerFlipedVertical");
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Layer)){
                return;
            };
            var _local2:Layer = (_arg1.result as Layer);
            m_lcSending.send(m_strConnectionSending, "OnLayerFlipedVertical", _local2.id);
        }
        public function set lblSaving(_arg1:Label):void{
            var _local2:Object = this._895705168lblSaving;
            if (_local2 !== _arg1){
                this._895705168lblSaving = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblSaving", _local2, _arg1));
            };
        }
        public function set btnMove(_arg1:Button):void{
            var _local2:Object = this._206020685btnMove;
            if (_local2 !== _arg1){
                this._206020685btnMove = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnMove", _local2, _arg1));
            };
        }
        public function get btnAdd():Button{
            return (this._1378839387btnAdd);
        }
        public function set btnReset(_arg1:Button):void{
            var _local2:Object = this._2095990867btnReset;
            if (_local2 !== _arg1){
                this._2095990867btnReset = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnReset", _local2, _arg1));
            };
        }
        public function __btnAdd_change(_arg1:Event):void{
            if (!btnAdd.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_ADD);
            SetCursor(cursorAddSymbol);
        }
        public function set thumbnailTabBar(_arg1:SuperTabBar):void{
            var _local2:Object = this._1751940170thumbnailTabBar;
            if (_local2 !== _arg1){
                this._1751940170thumbnailTabBar = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumbnailTabBar", _local2, _arg1));
            };
        }
        protected function RemoveCurrentCusor():void{
            if (0 == m_idCursor){
                return;
            };
            CursorManager.removeCursor(m_idCursor);
        }
        public function set cvsPenWidthPreview(_arg1:Canvas):void{
            var _local2:Object = this._53916763cvsPenWidthPreview;
            if (_local2 !== _arg1){
                this._53916763cvsPenWidthPreview = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cvsPenWidthPreview", _local2, _arg1));
            };
        }
        public function get httpServiceLoadConfig():HTTPService{
            return (this._1679445173httpServiceLoadConfig);
        }
        protected function get m_Service():PhotoService{
            return (this._2026944317m_Service);
        }
        public function __btnSearch_click(_arg1:MouseEvent):void{
            OnBtnSearchPressed();
        }
        public function OnRenameLocalConnection(_arg1:Event):void{
            m_lcSending.send(m_strConnectionSending, "LoadConfig", Application.application.parameters.id, Application.application.parameters.bmu, Application.application.parameters.btp, "1", Application.application.parameters.upm);
        }
        public function __btnScaleDown_change(_arg1:Event):void{
            if (!btnScaleDown.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_MOVE, TOOLSUBTYPE_SCALEDOWN);
            SetCursor(cursorZoomOutSymbol);
        }
        public function PostBlingeeData(_arg1:String):void{
            currentState = "saving";
            var _local2:AESBase64 = new AESBase64(128, 128);
            m_strBlingeeData = _local2.encrypt(m_strBlingeeData, m_strEncryptionKey, "ECB");
            var _local3:URLRequest = new URLRequest(_arg1);
            _local3.data = (("<?xml version=\"1.0\"?>\n<blingee>" + m_strBlingeeData) + "</blingee>");
            _local3.method = URLRequestMethod.POST;
            navigateToURL(_local3, "_self");
            m_strBlingeeData = "";
        }
        public function get UpgradeOnTabLastPageMinTabSize():int{
            return ((c_iUpgradeOnTabLastPageMinTabSizeFactor * TabPageSize));
        }
        public function set thumbnailTabPanel(_arg1:Canvas):void{
            var _local2:Object = this._252027thumbnailTabPanel;
            if (_local2 !== _arg1){
                this._252027thumbnailTabPanel = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumbnailTabPanel", _local2, _arg1));
            };
        }
        public function OnToolBlingeeTransformAdded(_arg1:int, _arg2:String, _arg3:int, _arg4:int, _arg5:int, _arg6:int):void{
            trace(((((((((((("OnToolBlingeeTransformAdded: " + _arg1) + ", ") + _arg2) + ", ") + _arg3) + ", ") + _arg4) + ", ") + _arg5) + ", ") + _arg6));
            m_layersTab.UpdateLayer(_arg1, (m_mapSelectedPhotos[_arg2] as Photo), _arg3, _arg4, _arg5, _arg6);
        }
        public function get btnPen():Button{
            return (this._1378824931btnPen);
        }
        public function set thumbnailTabs(_arg1:CustomButtonScrollingCanvas):void{
            var _local2:Object = this._1825284746thumbnailTabs;
            if (_local2 !== _arg1){
                this._1825284746thumbnailTabs = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumbnailTabs", _local2, _arg1));
            };
        }
        public function __cmbFont_change(_arg1:ListEvent):void{
            OnFontChanged();
        }
        public function __btnPen_change(_arg1:Event):void{
            if (!btnPen.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_PEN);
            SetCursor(cursorPenSymbol);
        }
        private function OnLocalConnectionStatus(_arg1:StatusEvent):void{
            trace(_arg1.toString());
        }
        public function get swfLoader():Image{
            return (this._2145423051swfLoader);
        }
        public function set btnAdd(_arg1:Button):void{
            var _local2:Object = this._1378839387btnAdd;
            if (_local2 !== _arg1){
                this._1378839387btnAdd = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnAdd", _local2, _arg1));
            };
        }
        public function set lblLoading(_arg1:Label):void{
            var _local2:Object = this._460758694lblLoading;
            if (_local2 !== _arg1){
                this._460758694lblLoading = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lblLoading", _local2, _arg1));
            };
        }
        public function __btnScaleUp_change(_arg1:Event):void{
            if (!btnScaleUp.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_MOVE, TOOLSUBTYPE_SCALEUP);
            SetCursor(cursorZoomInSymbol);
        }
        private function OnSwfLoaderComplete(_arg1:Event):void{
            if (!CONFIG_LOAD_EMBEDDED_BLINGEETOOL){
                return;
            };
        }
        protected function AddStampToGoodieBag(_arg1:String):void{
            var pattern:* = null;
            var aesBase64:* = null;
            var strXmlInput:* = null;
            var xmlPhoto:* = null;
            var oPhoto:* = null;
            var strRawData:* = _arg1;
            try {
                if (!m_fStampSearchEnabled){
                    return;
                };
                if (null == m_GoodieBagThumbnailTab){
                    return;
                };
                pattern = /[\r\n]/g;
                aesBase64 = new AESBase64(128, 128);
                strXmlInput = aesBase64.decrypt(strRawData.replace(pattern, ""), m_strEncryptionKey, "ECB");
                xmlPhoto = new XML(strXmlInput);
                oPhoto = new Photo(xmlPhoto);
                m_GoodieBagThumbnailTab.AddPhoto(oPhoto);
                thumbnailTabList.selectedChild = m_GoodieBagThumbnailTab;
            } catch(error:Error) {
            };
        }
        public function __btnAdd_valueCommit(_arg1:FlexEvent):void{
            if (!btnAdd.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_ADD);
            SetCursor(cursorAddSymbol);
        }
        private function OnCreationComplete():void{
            var button:* = null;
            var tabLayers:* = null;
            var tabReference:* = null;
            var tabUpgrade:* = null;
            m_fCreationCompleted = true;
            if (this.m_fHasToolbar){
                boxPreview.title = "BlingeeMaker 2.0";
            } else {
                boxPreview.title = "BlingeeMaker 1.0";
            };
            UpdateApplicationLayout();
            m_rgMainToolbarButtons = new ArrayCollection();
            m_rgMainToolbarButtons.addItem(btnAdd);
            m_rgMainToolbarButtons.addItem(btnMove);
            m_rgMainToolbarButtons.addItem(btnPen);
            m_rgMainToolbarButtons.addItem(btnFill);
            m_rgMainToolbarButtons.addItem(btnText);
            m_rgMainToolbarButtons.addItem(btnErase);
            m_rgMainToolbarButtons.addItem(btnScaleUp);
            m_rgMainToolbarButtons.addItem(btnScaleDown);
            m_rgMainToolbarButtons.addItem(btnRotateLeft);
            m_rgMainToolbarButtons.addItem(btnRotateRight);
            var i:* = 0;
            while (i < m_rgMainToolbarButtons.length) {
                button = Button(m_rgMainToolbarButtons[i]);
                button.addEventListener(FlexEvent.VALUE_COMMIT, OnToolbarMainButtonSelected);
                i = (i + 1);
            };
            m_layersTab = new LayersTab();
            m_layersTab.languageResource = rb;
            if (((this.m_fRequireToolbar) && (!(this.m_fHasToolbar)))){
                tabLayers = (contentTabBar.getChildAt(1) as SuperTab);
                if (((!((null == tabLayers))) && ((layersTabPanel.label == tabLayers.label)))){
                    contentTabBar.removeChild(tabLayers);
                };
                if (!this.m_fDisableUpgradeTab){
                    tabReference = (contentTabBar.getChildAt(0) as SuperTab);
                    tabUpgrade = new SuperTabEx();
                    tabUpgrade.styleName = tabReference.styleName;
                    tabUpgrade.height = tabReference.height;
                    tabUpgrade.closePolicy = SuperTab.CLOSE_NEVER;
                    tabUpgrade.label = m_strUpgradeMessage;
                    tabUpgrade.setStyle("icon", contentUpgradeSymbol);
                    tabUpgrade.explicitPercentWidth = 100;
                    tabUpgrade.addEventListener(MouseEvent.MOUSE_UP, OnToolbarFeatureRequested);
                    contentTabBar.addChild(tabUpgrade);
                };
                if (!this.m_fDisableUpgradeOnTabLastPage){
                    this.addEventListener(BlingeeMaker.TAB_LAST_PAGE_CLICKED, OnToolbarFeatureRequested);
                    this.m_fSuggestUpgradeOnTabLastPage = true;
                };
                if ("1" == Application.application.parameters.lcat){
                    this.m_fLockContentAboveThreshold = true;
                    this.m_iLockedContentThreshold = c_iLockedContentThresholdDefault;
                    if (null != Application.application.parameters.lctv){
                        try {
                            this.m_iLockedContentThreshold = Number(Application.application.parameters.lctv);
                        } catch(error:Error) {
                        };
                    };
                    this.addEventListener(BlingeeMaker.LOCKED_CONTENT_CLICKED, OnToolbarFeatureRequested);
                };
            };
            lblLoading.text = m_strDefaultLoadingString;
            InitializeLocalConnection();
            LoadBlingeeTool();
            m_loadTimer = new Timer((c_iLoadTimeoutSeconds * 1000), 1);
            m_loadTimer.addEventListener(TimerEvent.TIMER, OnLoadTimeout);
            m_loadTimer.start();
        }
        public function get btnUndo():Button{
            return (this._206257504btnUndo);
        }
        public function __sdrPenWidth_change(_arg1:SliderEvent):void{
            OnPenWidthChange(true);
        }
        private function LoadConfigResultHandler(_arg1:ResultEvent):void{
            var _local7:AESBase64;
            var _local2:XML = (_arg1.result as XML);
            var _local3:String = _local2.attribute("value").toString();
            var _local4:RegExp = /[\r\n]/g;
            if (((!((_local2.attribute("type") == null))) && ((_local2.attribute("type").toString() == "1")))){
                _local7 = new AESBase64(128, 128);
                m_strXmlInput = _local7.decrypt(_local3.replace(_local4, ""), m_strEncryptionKey, "ECB");
            } else {
                m_strXmlInput = AESBase64.charsToStr(AESBase64.decodeBase64(_local3.replace(_local4, "")));
            };
            _local2 = <Config/>
            ;
            _local2.appendChild(new XML(m_strXmlInput)..Image);
            m_strXmlImageConfig = _local2.toXMLString();
            var _local5:Number = Math.ceil((m_strXmlImageConfig.length / c_iConnectionChunkSize));
            var _local6:int;
            while (_local6 < _local5) {
                m_lcSending.send(m_strConnectionSending, "AppendLoadConfig", m_strXmlImageConfig.substr((_local6 * c_iConnectionChunkSize), c_iConnectionChunkSize));
                _local6++;
            };
            m_lcSending.send(m_strConnectionSending, "ProcessLoadConfig");
            if (((true) && (("3" == Application.application.parameters.bmu)))){
                LoadBlingeeTypes();
            };
        }
        public function set httpServiceLoadConfig(_arg1:HTTPService):void{
            var _local2:Object = this._1679445173httpServiceLoadConfig;
            if (_local2 !== _arg1){
                this._1679445173httpServiceLoadConfig = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "httpServiceLoadConfig", _local2, _arg1));
            };
        }
        public function RenameLocalConnection():void{
            m_renameLocalConnectionTimer = new Timer(0, 1);
            m_renameLocalConnectionTimer.addEventListener(TimerEvent.TIMER, OnRenameLocalConnection);
            m_renameLocalConnectionTimer.start();
        }
        public function get workPanel():Canvas{
            return (this._1076106611workPanel);
        }
        protected function SendFontInfo():void{
            m_lcSending.send(m_strConnectionSending, "SetFontInfo", cmbFont.selectedItem.data, nmsFontSize.value);
        }
        protected function OnLoadBlingeeTypes(_arg1:Event):void{
            OnPenWidthChange(false);
            m_Service = new PhotoService();
            m_Service.Initialize(m_strXmlInput, OnGalleriesLoaded, PhotoService.MODE_PARSE_INPUT);
            currentState = "loaded";
        }
        public function LoadBlingeeTypes():void{
            lblLoading.text = rb.getString("lblLoadingStamps_label");
            m_loadBlingeeTypesTimer = new Timer(0, 1);
            m_loadBlingeeTypesTimer.addEventListener(TimerEvent.TIMER, OnLoadBlingeeTypes);
            m_loadBlingeeTypesTimer.start();
        }
        public function get btnRotateRight():Button{
            return (this._1435898491btnRotateRight);
        }
        public function get gridPenWidth():Grid{
            return (this._1727029869gridPenWidth);
        }
        protected function set m_Service(_arg1:PhotoService):void{
            var _local2:Object = this._2026944317m_Service;
            if (_local2 !== _arg1){
                this._2026944317m_Service = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_Service", _local2, _arg1));
            };
        }
        public function set gridTransform(_arg1:Grid):void{
            var _local2:Object = this._1736356154gridTransform;
            if (_local2 !== _arg1){
                this._1736356154gridTransform = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridTransform", _local2, _arg1));
            };
        }
        private function OnIOError(_arg1:IOErrorEvent):void{
            trace(_arg1.toString());
        }
        public function get cmbFont():ComboBox{
            return (this._881829287cmbFont);
        }
        protected function get m_strDefaultLoadingString():String{
            return (this._461153877m_strDefaultLoadingString);
        }
        public function get btnText():Button{
            return (this._206219689btnText);
        }
        public function get btnErase():Button{
            return (this._2084355498btnErase);
        }
        protected function OnToolbarFeatureRequested(_arg1:Event):void{
            if (((this.m_fHasToolbar) || (!(this.m_fRequireToolbar)))){
                return;
            };
            ExternalInterface.call("onToolbarRequested", "");
        }
        public function get gridPreview():Grid{
            return (this._1694553506gridPreview);
        }
        public function AppendBlingeeTypes(_arg1:String):void{
            m_strXmlInput = (m_strXmlInput + _arg1);
        }
        private function OnLayerFlipedHorizontal(_arg1:ResultEvent):void{
            trace("OnLayerFlipedHorizontal");
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Layer)){
                return;
            };
            var _local2:Layer = (_arg1.result as Layer);
            m_lcSending.send(m_strConnectionSending, "OnLayerFlipedHorizontal", _local2.id);
        }
        public function set layersTabPanel(_arg1:VBox):void{
            var _local2:Object = this._986293969layersTabPanel;
            if (_local2 !== _arg1){
                this._986293969layersTabPanel = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "layersTabPanel", _local2, _arg1));
            };
        }
        public function get TabPageSize():int{
            return (this.m_iTabPageSize);
        }
        public function __btnFill_change(_arg1:Event):void{
            if (!btnFill.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_FILL);
            SetCursor(cursorFillSymbol);
        }
        private function _BlingeeMaker_SetProperty9_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty9 = _local1;
            _local1.name = "visible";
            _local1.value = true;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty9", _BlingeeMaker_SetProperty9);
            return (_local1);
        }
        protected function set m_strResetAlertDialogMessage(_arg1:String):void{
            var _local2:Object = this._840947981m_strResetAlertDialogMessage;
            if (_local2 !== _arg1){
                this._840947981m_strResetAlertDialogMessage = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_strResetAlertDialogMessage", _local2, _arg1));
            };
        }
        private function OnLayerChangedOpacity(_arg1:ResultEvent):void{
            trace("OnLayerChangedOpacity");
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Layer)){
                return;
            };
            var _local2:Layer = (_arg1.result as Layer);
            m_lcSending.send(m_strConnectionSending, "OnLayerChangedOpacity", _local2.id, _local2.opacity);
        }
        private function _BlingeeMaker_SetProperty10_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty10 = _local1;
            _local1.name = "includeInLayout";
            _local1.value = true;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty10", _BlingeeMaker_SetProperty10);
            return (_local1);
        }
        public function get btnSave():Button{
            return (this._206185977btnSave);
        }
        public function get btnFill():Button{
            return (this._205806079btnFill);
        }
        public function get previewThumbnail():Thumbnail{
            return (this._77115900previewThumbnail);
        }
        public function get contentTabBar():SuperTabBarEx{
            return (this._315768297contentTabBar);
        }
        private function OnLoadTimeout(_arg1:TimerEvent):void{
            if (lblLoading.text != m_strDefaultLoadingString){
                return;
            };
            Alert.show(m_strLoadTimeoutDialogMessage, c_strLoadTimeoutDialogTitle);
        }
        public function set boxToolBar(_arg1:VBox):void{
            var _local2:Object = this._1634065648boxToolBar;
            if (_local2 !== _arg1){
                this._1634065648boxToolBar = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "boxToolBar", _local2, _arg1));
            };
        }
        public function AppendBlingeeData(_arg1:String):void{
            m_strBlingeeData = (m_strBlingeeData + _arg1);
        }
        protected function OnPenWidthChange(_arg1:Boolean):void{
            var _local2:Number = Number(sdrPenWidth.value);
            cvsPenWidthPreview.graphics.clear();
            cvsPenWidthPreview.graphics.beginFill(0);
            cvsPenWidthPreview.graphics.drawCircle(25, 25, (_local2 / 2));
            if (_arg1){
                m_lcSending.send(m_strConnectionSending, "SetPenWidth", _local2);
            };
        }
        private function get rb():ResourceBundle{
            return (this._3632rb);
        }
        public function get btnScaleDown():Button{
            return (this._1756165648btnScaleDown);
        }
        public function set contentTabList(_arg1:ViewStack):void{
            var _local2:Object = this._1198576870contentTabList;
            if (_local2 !== _arg1){
                this._1198576870contentTabList = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentTabList", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty8_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty8 = _local1;
            _local1.name = "includeInLayout";
            _local1.value = false;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty8", _BlingeeMaker_SetProperty8);
            return (_local1);
        }
        protected function SetCursor(_arg1:Class=null):void{
            RemoveCurrentCusor();
            m_idCursor = CursorManager.setCursor(_arg1);
        }
        private function _BlingeeMaker_bindingExprs():void{
            var _local1:*;
            _local1 = btnSave;
            _local1 = swfLoader;
            _local1 = swfLoader;
            _local1 = lblLoading;
            _local1 = lblLoading;
            _local1 = btnSave;
            _local1 = swfLoader;
            _local1 = swfLoader;
            _local1 = lblSaving;
            _local1 = lblSaving;
            _local1 = m_strDefaultLoadingString;
            _local1 = rb.getString("lblSaving_label");
            _local1 = rb.getString("btnAdd_label");
            _local1 = rb.getString("btnMove_label");
            _local1 = rb.getString("btnPen_label");
            _local1 = rb.getString("btnFill_label");
            _local1 = rb.getString("btnText_label");
            _local1 = rb.getString("btnErase_label");
            _local1 = rb.getString("btnScaleUp_label");
            _local1 = rb.getString("btnScaleDown_label");
            _local1 = rb.getString("btnRotateLeft_label");
            _local1 = rb.getString("btnRotateRight_label");
            _local1 = DEFAULT_PEN_WIDTH;
            _local1 = (rb.getString("lblFont_label") + ":");
            _local1 = DEFAULT_FONTS;
            _local1 = (rb.getString("lblFontSize_label") + ":");
            _local1 = DEFAULT_FONT_SIZE;
            _local1 = rb.getString("btnUndo_label");
            _local1 = rb.getString("btnReset_label");
            _local1 = rb.getString("btnSave_label");
            _local1 = SuperTab.CLOSE_NEVER;
            _local1 = contentTabList;
            _local1 = rb.getString("thumbnailTabPanel_label");
            _local1 = contentStampSymbol;
            _local1 = thumbnailTabList;
            _local1 = rb.getString("btnSearch_label");
            _local1 = (thumbnailTabBar.y + ((thumbnailTabBar.height)>0) ? (thumbnailTabBar.height - 1) : 0);
            _local1 = rb.getString("layersTabPanel_label");
            _local1 = contentLayerSymbol;
        }
        public function set btnPen(_arg1:Button):void{
            var _local2:Object = this._1378824931btnPen;
            if (_local2 !== _arg1){
                this._1378824931btnPen = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnPen", _local2, _arg1));
            };
        }
        protected function get m_strLoadTimeoutDialogMessage():String{
            return (this._255537731m_strLoadTimeoutDialogMessage);
        }
        public function __httpServiceLoadConfig_fault(_arg1:FaultEvent):void{
            LoadConfigFaultHandler(_arg1);
        }
        public function set contentTabPanel(_arg1:Canvas):void{
            var _local2:Object = this._1502273288contentTabPanel;
            if (_local2 !== _arg1){
                this._1502273288contentTabPanel = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "contentTabPanel", _local2, _arg1));
            };
        }
        public function set btnSearch(_arg1:Button):void{
            var _local2:Object = this._579312420btnSearch;
            if (_local2 !== _arg1){
                this._579312420btnSearch = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnSearch", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty7_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty7 = _local1;
            _local1.name = "visible";
            _local1.value = false;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty7", _BlingeeMaker_SetProperty7);
            return (_local1);
        }
        public function set swfLoader(_arg1:Image):void{
            var _local2:Object = this._2145423051swfLoader;
            if (_local2 !== _arg1){
                this._2145423051swfLoader = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "swfLoader", _local2, _arg1));
            };
        }
        private function InitializeResourceBundles():void{
            rb = rbEnglish;
            if ("fr" == Application.application.parameters.lang){
                rb = rbFrench;
            };
            if ("de" == Application.application.parameters.lang){
                rb = rbGerman;
            };
            if ("ja" == Application.application.parameters.lang){
                rb = rbJapanese;
            };
            if ("nl" == Application.application.parameters.lang){
                rb = rbDutch;
            };
            if ("it" == Application.application.parameters.lang){
                rb = rbItalian;
            };
            if ("pt" == Application.application.parameters.lang){
                rb = rbPortuguese;
            };
            if ("es" == Application.application.parameters.lang){
                rb = rbSpanish;
            };
            m_strDefaultLoadingString = rb.getString("strDefaultLoading_string");
            m_strResetAlertDialogMessage = rb.getString("strResetAlertDialogMessage_string");
            m_strLoadTimeoutDialogMessage = rb.getString("strLoadTimeoutDialogMessage_string");
        }
        private function _BlingeeMaker_bindingsSetup():Array{
            var binding:* = null;
            var result:* = [];
            binding = new Binding(this, function ():Object{
                return (btnSave);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty1.target = _arg1;
            }, "_BlingeeMaker_SetProperty1.target");
            result[0] = binding;
            binding = new Binding(this, function ():Object{
                return (swfLoader);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty2.target = _arg1;
            }, "_BlingeeMaker_SetProperty2.target");
            result[1] = binding;
            binding = new Binding(this, function ():Object{
                return (swfLoader);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty3.target = _arg1;
            }, "_BlingeeMaker_SetProperty3.target");
            result[2] = binding;
            binding = new Binding(this, function ():Object{
                return (lblLoading);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty4.target = _arg1;
            }, "_BlingeeMaker_SetProperty4.target");
            result[3] = binding;
            binding = new Binding(this, function ():Object{
                return (lblLoading);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty5.target = _arg1;
            }, "_BlingeeMaker_SetProperty5.target");
            result[4] = binding;
            binding = new Binding(this, function ():Object{
                return (btnSave);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty6.target = _arg1;
            }, "_BlingeeMaker_SetProperty6.target");
            result[5] = binding;
            binding = new Binding(this, function ():Object{
                return (swfLoader);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty7.target = _arg1;
            }, "_BlingeeMaker_SetProperty7.target");
            result[6] = binding;
            binding = new Binding(this, function ():Object{
                return (swfLoader);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty8.target = _arg1;
            }, "_BlingeeMaker_SetProperty8.target");
            result[7] = binding;
            binding = new Binding(this, function ():Object{
                return (lblSaving);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty9.target = _arg1;
            }, "_BlingeeMaker_SetProperty9.target");
            result[8] = binding;
            binding = new Binding(this, function ():Object{
                return (lblSaving);
            }, function (_arg1:Object):void{
                _BlingeeMaker_SetProperty10.target = _arg1;
            }, "_BlingeeMaker_SetProperty10.target");
            result[9] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = m_strDefaultLoadingString;
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblLoading.text = _arg1;
            }, "lblLoading.text");
            result[10] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("lblSaving_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                lblSaving.text = _arg1;
            }, "lblSaving.text");
            result[11] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnAdd_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnAdd.label = _arg1;
            }, "btnAdd.label");
            result[12] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnMove_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnMove.label = _arg1;
            }, "btnMove.label");
            result[13] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnPen_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnPen.label = _arg1;
            }, "btnPen.label");
            result[14] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnFill_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnFill.label = _arg1;
            }, "btnFill.label");
            result[15] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnText_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnText.label = _arg1;
            }, "btnText.label");
            result[16] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnErase_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnErase.label = _arg1;
            }, "btnErase.label");
            result[17] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnScaleUp_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnScaleUp.label = _arg1;
            }, "btnScaleUp.label");
            result[18] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnScaleDown_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnScaleDown.label = _arg1;
            }, "btnScaleDown.label");
            result[19] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnRotateLeft_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnRotateLeft.label = _arg1;
            }, "btnRotateLeft.label");
            result[20] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnRotateRight_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnRotateRight.label = _arg1;
            }, "btnRotateRight.label");
            result[21] = binding;
            binding = new Binding(this, function ():Number{
                return (DEFAULT_PEN_WIDTH);
            }, function (_arg1:Number):void{
                sdrPenWidth.value = _arg1;
            }, "sdrPenWidth.value");
            result[22] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = (rb.getString("lblFont_label") + ":");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                _BlingeeMaker_Label4.text = _arg1;
            }, "_BlingeeMaker_Label4.text");
            result[23] = binding;
            binding = new Binding(this, function ():Object{
                return (DEFAULT_FONTS);
            }, function (_arg1:Object):void{
                cmbFont.dataProvider = _arg1;
            }, "cmbFont.dataProvider");
            result[24] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = (rb.getString("lblFontSize_label") + ":");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                _BlingeeMaker_Label5.text = _arg1;
            }, "_BlingeeMaker_Label5.text");
            result[25] = binding;
            binding = new Binding(this, function ():Number{
                return (DEFAULT_FONT_SIZE);
            }, function (_arg1:Number):void{
                nmsFontSize.value = _arg1;
            }, "nmsFontSize.value");
            result[26] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnUndo_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnUndo.label = _arg1;
            }, "btnUndo.label");
            result[27] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnReset_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnReset.label = _arg1;
            }, "btnReset.label");
            result[28] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnSave_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnSave.label = _arg1;
            }, "btnSave.label");
            result[29] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = SuperTab.CLOSE_NEVER;
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                contentTabBar.closePolicy = _arg1;
            }, "contentTabBar.closePolicy");
            result[30] = binding;
            binding = new Binding(this, function ():Object{
                return (contentTabList);
            }, function (_arg1:Object):void{
                contentTabBar.dataProvider = _arg1;
            }, "contentTabBar.dataProvider");
            result[31] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("thumbnailTabPanel_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                thumbnailTabPanel.label = _arg1;
            }, "thumbnailTabPanel.label");
            result[32] = binding;
            binding = new Binding(this, function ():Class{
                return (contentStampSymbol);
            }, function (_arg1:Class):void{
                thumbnailTabPanel.icon = _arg1;
            }, "thumbnailTabPanel.icon");
            result[33] = binding;
            binding = new Binding(this, function ():Object{
                return (thumbnailTabList);
            }, function (_arg1:Object):void{
                thumbnailTabBar.dataProvider = _arg1;
            }, "thumbnailTabBar.dataProvider");
            result[34] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("btnSearch_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnSearch.label = _arg1;
            }, "btnSearch.label");
            result[35] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = (thumbnailTabBar.y + ((thumbnailTabBar.height)>0) ? (thumbnailTabBar.height - 1) : 0);
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                btnSearch.setStyle("top", _arg1);
            }, "btnSearch.top");
            result[36] = binding;
            binding = new Binding(this, function ():String{
                var _local1:* = rb.getString("layersTabPanel_label");
                var _local2:* = (((_local1 == undefined)) ? null : String(_local1));
                return (_local2);
            }, function (_arg1:String):void{
                layersTabPanel.label = _arg1;
            }, "layersTabPanel.label");
            result[37] = binding;
            binding = new Binding(this, function ():Class{
                return (contentLayerSymbol);
            }, function (_arg1:Class):void{
                layersTabPanel.icon = _arg1;
            }, "layersTabPanel.icon");
            result[38] = binding;
            return (result);
        }
        private function OnLayerSwapedDepth(_arg1:ResultEvent):void{
            trace("OnLayerSwapedDepth");
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Layer)){
                return;
            };
            var _local2:Layer = (_arg1.result as Layer);
            m_lcSending.send(m_strConnectionSending, "OnLayerSwapedDepth", _local2.id, _local2.depth);
        }
        public function __btnReset_buttonDown(_arg1:FlexEvent):void{
            Alert.show(m_strResetAlertDialogMessage, c_strResetAlertDialogTitle, (Alert.YES | Alert.NO), null, OnBtnResetConfirmed, null);
        }
        public function get thumbnailTabs():CustomButtonScrollingCanvas{
            return (this._1825284746thumbnailTabs);
        }
        public function set thumbnailTabList(_arg1:ViewStack):void{
            var _local2:Object = this._1524123833thumbnailTabList;
            if (_local2 !== _arg1){
                this._1524123833thumbnailTabList = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "thumbnailTabList", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty6_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty6 = _local1;
            _local1.name = "enabled";
            _local1.value = false;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty6", _BlingeeMaker_SetProperty6);
            return (_local1);
        }
        public function get lblLoading():Label{
            return (this._460758694lblLoading);
        }
        protected function UpdateApplicationLayout():void{
            var _local3:SlimThumbnailTab;
            if (!m_fCreationCompleted){
                return;
            };
            contentTabPanel.visible = false;
            contentTabPanel.includeInLayout = false;
            var _local1 = -1;
            if (this.height > this.width){
                this.layout = "vertical";
                this.setStyle("paddingLeft", 0);
                this.m_iTabPageSize = c_iTabPageSizeDefault;
                workPanel.height = 468;
                workPanel.setStyle("paddingBottom", 10);
                boxPreview.width = 432;
                contentTabPanel.width = 572;
                contentTabPanel.height = 486;
                _local1 = 130;
                this.m_ContentThumnailItemRenderer = new ClassFactory(Thumbnail);
                this.m_ContentThumnailItemRenderer.properties = {thumbnailWidth:100};
            } else {
                this.layout = "horizontal";
                this.setStyle("paddingLeft", 0);
                this.m_iTabPageSize = c_iTabPageSizeAlt;
                workPanel.height = 536;
                workPanel.setStyle("paddingBottom", 0);
                boxPreview.width = 432;
                contentTabPanel.width = 394;
                contentTabPanel.height = 536;
                _local1 = 110;
                this.m_ContentThumnailItemRenderer = new ClassFactory(SmallThumbnail);
                this.m_ContentThumnailItemRenderer.properties = {thumbnailWidth:90};
            };
            thumbnailTabList.x = (_local1 - 1);
            thumbnailTabs.width = _local1;
            thumbnailTabBar.setStyle("tabWidth", _local1);
            btnSearch.width = _local1;
            workPanel.visible = true;
            workPanel.includeInLayout = true;
            var _local2:int;
            while (_local2 < m_rgThumbnailTabs.length) {
                _local3 = (m_rgThumbnailTabs[_local2] as SlimThumbnailTab);
                _local3.ThumnailItemRenderer = this.m_ContentThumnailItemRenderer;
                _local3.tabPageSize = this.m_iTabPageSize;
                _local2++;
            };
            contentTabPanel.visible = true;
            contentTabPanel.includeInLayout = true;
        }
        public function ___BlingeeMaker_Application1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        public function ___BlingeeMaker_Application1_resize(_arg1:ResizeEvent):void{
            OnResize();
        }
        mx_internal function _BlingeeMaker_StylesInit():void{
            var style:* = null;
            var effects:* = null;
            if (mx_internal::_BlingeeMaker_StylesInit_done){
                return;
            };
            mx_internal::_BlingeeMaker_StylesInit_done = true;
            style = StyleManager.getStyleDeclaration(".lockedThumbnailOverlay");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".lockedThumbnailOverlay", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundAlpha = 0.65;
                    this.backgroundColor = 0xCCCCCC;
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailList");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailList", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.selectionColor = 0xFFFFFF;
                    this.rollOverColor = 0xFFFFFF;
                    this.borderStyle = "none";
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration(".contentTab");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".contentTab", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration("ToolTip");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("ToolTip", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.color = 0xFFFFFF;
                    this.backgroundColor = 4737090;
                };
            };
            style = StyleManager.getStyleDeclaration(".contentTabList");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".contentTabList", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.borderColor = 15219792;
                    this.borderThickness = 1;
                    this.borderStyle = "solid";
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailTabList");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailTabList", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration("Preloader");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Preloader", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.borderColor = 0xFFFFFF;
                    this.color = 15219792;
                    this.themeColor = 15219792;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration(".contentTabBarTab");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".contentTabBarTab", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.borderColor = 15219792;
                    this.width = 100;
                    this.textRollOverColor = 15219792;
                    this.fontSize = 12;
                    this.backgroundColor = 15219792;
                };
            };
            style = StyleManager.getStyleDeclaration(".contentTabBarSelectedTabText");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".contentTabBarSelectedTabText", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.color = 0xFFFFFF;
                    this.textRollOverColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration("Alert");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Alert", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.borderColor = 0xFFFFFF;
                    this.color = 15219792;
                    this.buttonStyleName = "alertButton";
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailTabBarButton");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailTabBarButton", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.textAlign = "left";
                    this.fillAlphas = [0.6, 0.4, 0.75, 0.65];
                    this.selectedDownSkin = VerticalTabSkin;
                    this.cornerRadius = 0;
                    this.selectedUpSkin = VerticalTabSkin;
                    this.selectedOverSkin = VerticalTabSkin;
                    this.fontSize = 10;
                    this.downSkin = VerticalTabSkin;
                    this.selectedDisabledSkin = VerticalTabSkin;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration("Application");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Application", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.color = 1579026;
                    this.backgroundGradientAlphas = [1, 1];
                    this.backgroundGradientColors = [0xFFFFFF, 0xFFFFFF];
                    this.borderStyle = "none";
                    this.themeColor = 15219792;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailSelected");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailSelected", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundColor = 3684402;
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailTabBarSearchButton");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailTabBarSearchButton", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.textAlign = "left";
                    this.fillAlphas = [0.8, 0.6, 0.95, 0.85];
                    this.color = 0;
                    this.selectedDownSkin = VerticalTabSkin;
                    this.cornerRadius = 0;
                    this.fillColors = [16768373, 16768373, 16768373, 16768373];
                    this.selectedUpSkin = VerticalTabSkin;
                    this.selectedOverSkin = VerticalTabSkin;
                    this.fontSize = 10;
                    this.downSkin = VerticalTabSkin;
                    this.selectedDisabledSkin = VerticalTabSkin;
                    this.backgroundColor = 0xFFFFFF;
                };
            };
            style = StyleManager.getStyleDeclaration(".thumbnailRolledOver");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailRolledOver", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundColor = 7895154;
                };
            };
            style = StyleManager.getStyleDeclaration(".contentTabBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".contentTabBar", style, false);
            };
            style = StyleManager.getStyleDeclaration(".thumbnailDefault");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".thumbnailDefault", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.backgroundColor = 0xCCCCCC;
                };
            };
            style = StyleManager.getStyleDeclaration("Panel");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("Panel", style, false);
            };
            style = StyleManager.getStyleDeclaration(".alertButton");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration(".alertButton", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.color = 1579026;
                    this.themeColor = 15219792;
                };
            };
            style = StyleManager.getStyleDeclaration("LinkBar");
            if (!style){
                style = new CSSStyleDeclaration();
                StyleManager.setStyleDeclaration("LinkBar", style, false);
            };
            if (style.factory == null){
                style.factory = function ():void{
                    this.selectionColor = 15219792;
                    this.disabledColor = 15219792;
                    this.textRollOverColor = 0xFFFFFF;
                    this.rollOverColor = 15219792;
                };
            };
            var _local2 = StyleManager;
            _local2.mx_internal::initProtoChainRoots();
        }
        public function __httpServiceLoadConfig_result(_arg1:ResultEvent):void{
            LoadConfigResultHandler(_arg1);
        }
        public function ShowAlertMessage(_arg1:String, _arg2:String):void{
            Alert.show(_arg2, _arg1, Alert.OK);
            if (currentState == "saving"){
                currentState = "loaded";
            };
        }
        private function LoadBlingeeTool():void{
            var _local1:Loader;
            if (!CONFIG_LOAD_EMBEDDED_BLINGEETOOL){
                swfLoader.source = (((((((((((((((m_strServerUrl + c_strBlingeeTooPath) + "/BlingeeTool") + Application.application.parameters.v) + ".swf?id=") + Application.application.parameters.id) + "&btu=") + Application.application.parameters.bmu) + "&btp=") + Application.application.parameters.btp) + "&lcm=") + "1") + "&upm=") + escape(Application.application.parameters.upm)) + "&sfx=") + m_strConnectionSuffix);
            } else {
                _local1 = new Loader();
                _local1.contentLoaderInfo.addEventListener(Event.COMPLETE, OnSwfLoaderComplete);
                _local1.loadBytes(new blingeeToolClass());
                swfLoader.source = _local1;
            };
            if ("3" == Application.application.parameters.bmu){
                LoadConfigUrl("http://blingee.com/blingee/create_config/148087364");
            };
        }
        public function get gridTransform():Grid{
            return (this._1736356154gridTransform);
        }
        public function set btnUndo(_arg1:Button):void{
            var _local2:Object = this._206257504btnUndo;
            if (_local2 !== _arg1){
                this._206257504btnUndo = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnUndo", _local2, _arg1));
            };
        }
        private function LoadConfigFaultHandler(_arg1:FaultEvent):void{
            if (null == Application.application.parameters.bmdbg){
                Alert.show(rb.getString("strErrorLoadingPictureMessage_string"), "Could not load Picture");
            } else {
                Alert.show(_arg1.fault.message, "Could not load Picture");
            };
        }
        private function InitializeLocalConnection():void{
            if (null != Application.application.parameters.sfx){
                m_strConnectionSuffix = Application.application.parameters.sfx;
            } else {
                if (!CONFIG_LOAD_EMBEDDED_BLINGEETOOL){
                    m_strConnectionSuffix = ((("" + ((Math.random() * 1000) * 1000)) + "-") + new Date().getMilliseconds());
                };
            };
            m_strConnectionSending = (c_strConnectionSending + m_strConnectionSuffix);
            m_strConnectionReceiving = (c_strConnectionReceiving + m_strConnectionSuffix);
            m_lcSending = new LocalConnection();
            m_lcReceiving = new LocalConnection();
            m_lcSending.addEventListener(StatusEvent.STATUS, OnLocalConnectionStatus);
            m_lcReceiving.addEventListener(StatusEvent.STATUS, OnLocalConnectionStatus);
            m_lcReceiving.client = this;
            m_lcReceiving.connect(m_strConnectionReceiving);
        }
        public function get layersTabPanel():VBox{
            return (this._986293969layersTabPanel);
        }
        protected function get m_strResetAlertDialogMessage():String{
            return (this._840947981m_strResetAlertDialogMessage);
        }
        public function __btnText_change(_arg1:Event):void{
            if (!btnText.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_TEXT);
            SetCursor(cursorTextSymbol);
        }
        public function set boxPreview(_arg1:Panel):void{
            var _local2:Object = this._812125315boxPreview;
            if (_local2 !== _arg1){
                this._812125315boxPreview = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "boxPreview", _local2, _arg1));
            };
        }
        public function set btnRotateLeft(_arg1:Button):void{
            var _local2:Object = this._923329406btnRotateLeft;
            if (_local2 !== _arg1){
                this._923329406btnRotateLeft = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnRotateLeft", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty5_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty5 = _local1;
            _local1.name = "includeInLayout";
            _local1.value = false;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty5", _BlingeeMaker_SetProperty5);
            return (_local1);
        }
        public function set btnRotateRight(_arg1:Button):void{
            var _local2:Object = this._1435898491btnRotateRight;
            if (_local2 !== _arg1){
                this._1435898491btnRotateRight = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnRotateRight", _local2, _arg1));
            };
        }
        public function get contentTabPanel():Canvas{
            return (this._1502273288contentTabPanel);
        }
        public function get boxToolBar():VBox{
            return (this._1634065648boxToolBar);
        }
        public function __btnUndo_buttonDown(_arg1:FlexEvent):void{
            m_lcSending.send(m_strConnectionSending, "OnBtnUndoPressed");
        }
        public function set btnScaleUp(_arg1:Button):void{
            var _local2:Object = this._721380233btnScaleUp;
            if (_local2 !== _arg1){
                this._721380233btnScaleUp = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnScaleUp", _local2, _arg1));
            };
        }
        public function get contentTabList():ViewStack{
            return (this._1198576870contentTabList);
        }
        public function set sdrPenWidth(_arg1:HSlider):void{
            var _local2:Object = this._1808376718sdrPenWidth;
            if (_local2 !== _arg1){
                this._1808376718sdrPenWidth = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "sdrPenWidth", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty4_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty4 = _local1;
            _local1.name = "visible";
            _local1.value = false;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty4", _BlingeeMaker_SetProperty4);
            return (_local1);
        }
        public function get btnSearch():Button{
            return (this._579312420btnSearch);
        }
        public function set gridPenWidth(_arg1:Grid):void{
            var _local2:Object = this._1727029869gridPenWidth;
            if (_local2 !== _arg1){
                this._1727029869gridPenWidth = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridPenWidth", _local2, _arg1));
            };
        }
        protected function SelectThumbnail(_arg1:Thumbnail):void{
            trace("SelectThumbnail");
            if (null == _arg1){
                return;
            };
            if (((!((null == previewThumbnail))) && ((previewThumbnail.data == _arg1.data)))){
                return;
            };
            if (((!((null == m_SelectedThumbnailOwner))) && (!((_arg1.owner == m_SelectedThumbnailOwner))))){
                m_SelectedThumbnailOwner.selectedIndex = -1;
            };
            var _local2:Photo = (_arg1.data as Photo);
            m_SelectedThumbnail = _arg1;
            m_SelectedThumbnailOwner = (m_SelectedThumbnail.owner as ListBase);
            previewThumbnail.data = _local2;
            m_mapSelectedPhotos[_local2.id] = _local2;
            m_lcSending.send(m_strConnectionSending, "SetSelectedBlingeeAlt", _local2.source, _local2.id);
            if (btnMove.selected){
                btnAdd.selected = true;
            };
        }
        public function OnToolBlingeeTransformRemoved(_arg1:int):void{
            trace(("OnToolBlingeeTransformRemoved: " + _arg1));
            m_layersTab.RemoveLayer(_arg1);
        }
        public function set workPanel(_arg1:Canvas):void{
            var _local2:Object = this._1076106611workPanel;
            if (_local2 !== _arg1){
                this._1076106611workPanel = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "workPanel", _local2, _arg1));
            };
        }
        public function set gridPreview(_arg1:Grid):void{
            var _local2:Object = this._1694553506gridPreview;
            if (_local2 !== _arg1){
                this._1694553506gridPreview = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gridPreview", _local2, _arg1));
            };
        }
        public function get thumbnailTabList():ViewStack{
            return (this._1524123833thumbnailTabList);
        }
        public function set cmbFont(_arg1:ComboBox):void{
            var _local2:Object = this._881829287cmbFont;
            if (_local2 !== _arg1){
                this._881829287cmbFont = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "cmbFont", _local2, _arg1));
            };
        }
        public function set nmsFontSize(_arg1:NumericStepper):void{
            var _local2:Object = this._1309877340nmsFontSize;
            if (_local2 !== _arg1){
                this._1309877340nmsFontSize = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "nmsFontSize", _local2, _arg1));
            };
        }
        private function set blingeeToolClass(_arg1:Class):void{
            var _local2:Object = this._143482968blingeeToolClass;
            if (_local2 !== _arg1){
                this._143482968blingeeToolClass = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "blingeeToolClass", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_HTTPService1_i():HTTPService{
            var _local1:HTTPService = new HTTPService();
            httpServiceLoadConfig = _local1;
            _local1.url = "";
            _local1.resultFormat = "e4x";
            _local1.addEventListener("result", __httpServiceLoadConfig_result);
            _local1.addEventListener("fault", __httpServiceLoadConfig_fault);
            _local1.initialized(this, "httpServiceLoadConfig");
            return (_local1);
        }
        protected function set m_strDefaultLoadingString(_arg1:String):void{
            var _local2:Object = this._461153877m_strDefaultLoadingString;
            if (_local2 !== _arg1){
                this._461153877m_strDefaultLoadingString = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "m_strDefaultLoadingString", _local2, _arg1));
            };
        }
        public function set btnText(_arg1:Button):void{
            var _local2:Object = this._206219689btnText;
            if (_local2 !== _arg1){
                this._206219689btnText = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnText", _local2, _arg1));
            };
        }
        private function _BlingeeMaker_SetProperty3_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty3 = _local1;
            _local1.name = "includeInLayout";
            _local1.value = true;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty3", _BlingeeMaker_SetProperty3);
            return (_local1);
        }
        public function set btnErase(_arg1:Button):void{
            var _local2:Object = this._2084355498btnErase;
            if (_local2 !== _arg1){
                this._2084355498btnErase = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnErase", _local2, _arg1));
            };
        }
        public function get boxPreview():Panel{
            return (this._812125315boxPreview);
        }
        public function get btnRotateLeft():Button{
            return (this._923329406btnRotateLeft);
        }
        public function __btnRotateLeft_change(_arg1:Event):void{
            if (!btnRotateLeft.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_MOVE, TOOLSUBTYPE_ROTATELEFT);
            SetCursor(cursorRotateLeftSymbol);
        }
        public function get btnScaleUp():Button{
            return (this._721380233btnScaleUp);
        }
        public function get sdrPenWidth():HSlider{
            return (this._1808376718sdrPenWidth);
        }
        override public function initialize():void{
            var target:* = null;
            var watcherSetupUtilClass:* = null;
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            var bindings:* = _BlingeeMaker_bindingsSetup();
            var watchers:* = [];
            target = this;
            if (_watcherSetupUtil == null){
                watcherSetupUtilClass = getDefinitionByName("_BlingeeMakerWatcherSetupUtil");
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
        private function OnGalleriesLoaded(_arg1:ResultEvent):void{
            var _local2:int;
            var _local3:Gallery;
            var _local4:String;
            var _local5:int;
            var _local6:SlimThumbnailTab;
            var _local7:Photo;
            var _local8:DebugTab;
            addEventListener(BlingeeMaker.CREATED_PHOTO, OnCreatedPhoto);
            addEventListener(BlingeeMaker.SELECTED_PHOTO, OnSelectedPhoto);
            addEventListener(BlingeeMaker.LAYER_SWAPED_DEPTH, OnLayerSwapedDepth);
            addEventListener(BlingeeMaker.LAYER_FLIPED_HORIZONTAL, OnLayerFlipedHorizontal);
            addEventListener(BlingeeMaker.LAYER_FLIPED_VERTICAL, OnLayerFlipedVertical);
            addEventListener(BlingeeMaker.LAYER_CHANGED_OPACITY, OnLayerChangedOpacity);
            addEventListener(BlingeeMaker.LAYER_SET_MOTION, OnLayerSetMotion);
            _local2 = 0;
            while (_local2 < m_Service.galleries.length) {
                _local3 = Gallery(m_Service.galleries[_local2]);
                if ((((null == m_FirstPhoto)) && ((_local3.photos.length > 0)))){
                    m_FirstPhoto = _local3.photos[0];
                };
                _local4 = ((_local3.name)!=null) ? _local3.name : rb.getString("strGoodieBag_string");
                _local5 = 0;
                while (_local5 < _local3.photos.length) {
                    _local7 = Photo(_local3.photos[_local5]);
                    m_photoLoadingQueue.addItem(_local7);
                    if (((!(_local3.isGoodieBag)) && (this.m_fLockContentAboveThreshold))){
                        if (_local5 >= this.m_iLockedContentThreshold){
                            _local7.isLocked = true;
                        };
                    };
                    _local5++;
                };
                _local6 = new SlimThumbnailTab();
                _local6.Initialize(_local4, _local3, TabPageSize, ((this.m_fSuggestUpgradeOnTabLastPage) && ((_local3.photos.length >= UpgradeOnTabLastPageMinTabSize))), this.m_ContentThumnailItemRenderer);
                thumbnailTabList.addChild(_local6);
                m_rgThumbnailTabs.addItem(_local6);
                if ((((null == m_GoodieBagThumbnailTab)) || (_local3.isGoodieBag))){
                    m_GoodieBagThumbnailTab = _local6;
                };
                if ((((null == m_InkThumbnailTab)) || (_local3.isInkSet))){
                    m_InkThumbnailTab = _local6;
                };
                _local2++;
            };
            if ("1" == Application.application.parameters.sdbg){
                _local8 = new DebugTab();
                _local8.Initialize();
                _local8.label = "Debug";
                thumbnailTabList.addChild(_local8);
            };
            _local2 = 0;
            while (_local2 < thumbnailTabList.getChildren().length) {
                thumbnailTabBar.setClosePolicyForTab(_local2, SuperTab.CLOSE_NEVER);
                _local2++;
            };
            if (thumbnailTabBar.getChildren().length > 0){
                thumbnailTabBar.selectedIndex = 0;
            };
            if (m_fStampSearchEnabled){
                this.btnSearch.visible = true;
                ExternalInterface.call("foo");
            };
            layersTabPanel.addChild(m_layersTab);
            btnAdd.selected = true;
        }
        private function _BlingeeMaker_SetProperty2_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty2 = _local1;
            _local1.name = "visible";
            _local1.value = true;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty2", _BlingeeMaker_SetProperty2);
            return (_local1);
        }
        protected function OnResize():void{
            UpdateApplicationLayout();
        }
        private function OnToolbarMainButtonSelected(_arg1:Event):void{
            var _local3:Button;
            if (m_mainToolbarSelectedButton == _arg1.target){
                if (btnPen == _arg1.target){
                    m_mainToolbarSelectedButton = null;
                    btnAdd.selected = true;
                } else {
                    m_mainToolbarSelectedButton.selected = true;
                };
                return;
            };
            if (!Button(_arg1.target).selected){
                return;
            };
            m_mainToolbarSelectedButton = Button(_arg1.target);
            var _local2:int;
            while (_local2 < m_rgMainToolbarButtons.length) {
                _local3 = Button(m_rgMainToolbarButtons[_local2]);
                if (_local3 == _arg1.target){
                } else {
                    _local3.selected = false;
                };
                _local2++;
            };
            if (btnPen == _arg1.target){
                SetGridVisibility(gridTransform, false);
                SetGridVisibility(gridPreview, true);
                SetGridVisibility(gridPenWidth, true);
                SetGridVisibility(gridTextTools, false);
            } else {
                if (btnText == _arg1.target){
                    SetGridVisibility(gridTransform, false);
                    SetGridVisibility(gridPreview, true);
                    SetGridVisibility(gridPenWidth, false);
                    SetGridVisibility(gridTextTools, true);
                    if (((!((null == m_InkThumbnailTab))) && (!(m_fInkWasSelected)))){
                        thumbnailTabList.selectedChild = m_InkThumbnailTab;
                        m_fInkWasSelected = true;
                    };
                } else {
                    SetGridVisibility(gridTransform, true);
                    SetGridVisibility(gridPreview, true);
                    SetGridVisibility(gridPenWidth, false);
                    SetGridVisibility(gridTextTools, false);
                };
            };
        }
        private function get blingeeToolClass():Class{
            return (this._143482968blingeeToolClass);
        }
        public function get nmsFontSize():NumericStepper{
            return (this._1309877340nmsFontSize);
        }
        protected function OnFontSizeChanged():void{
            SendFontInfo();
        }
        private function Initialize():void{
            InitializeResourceBundles();
            if (null == Application.application.parameters.bmu){
                Application.application.parameters.bmu = "0";
            };
            if (null == Application.application.parameters.btp){
                Application.application.parameters.btp = "0";
            };
            if (null == Application.application.parameters.upm){
                Application.application.parameters.upm = "";
            };
            m_strServerUrl = "";
            if ("1" == Application.application.parameters.bmu){
                m_strServerUrl = "http://image.blingee.com";
            } else {
                if ("2" == Application.application.parameters.bmu){
                    m_strServerUrl = "http://image.blingeebeta.com";
                };
            };
            m_photoLoadingQueue = new ArrayCollection();
            m_strEncryptionKey = (((m_strBufferT + m_strBufferC) + m_strBufferH) + m_strBufferE);
            if ("3" == Application.application.parameters.bmu){
                m_strServerUrl = "http://cooldell:3000";
            };
            if ("1" == Application.application.parameters.sps){
                m_fStampSearchEnabled = true;
            };
            if (m_fStampSearchEnabled){
                ExternalInterface.addCallback("addStampToGoodieBag", AddStampToGoodieBag);
                Security.allowDomain("*");
            };
            if ("0" == Application.application.parameters.rtb){
                this.m_fRequireToolbar = false;
            };
            if ("1" == Application.application.parameters.htb){
                this.m_fHasToolbar = true;
            };
            if ("1" == Application.application.parameters.dut){
                this.m_fDisableUpgradeTab = true;
            };
            if ("1" == Application.application.parameters.duotlp){
                this.m_fDisableUpgradeOnTabLastPage = true;
            };
            if (null != Application.application.parameters.upmsg){
                m_strUpgradeMessage = Application.application.parameters.upmsg;
            } else {
                m_strUpgradeMessage = rb.getString("contentTabUpgrade_label");
            };
        }
        public function __btnMove_change(_arg1:Event):void{
            if (!btnMove.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_MOVE);
            SetCursor(cursorMoveSymbol);
        }
        protected function OnBtnSavePressed():void{
            m_lcSending.send(m_strConnectionSending, "OnBtnSavePressed");
        }
        private function OnCreatedPhoto(_arg1:ResultEvent):void{
            if (null != m_SelectedThumbnail){
                return;
            };
            if (null == _arg1.result){
                return;
            };
            if (!(_arg1.result is Thumbnail)){
                return;
            };
            var _local2:Thumbnail = (_arg1.result as Thumbnail);
            if (m_FirstPhoto != _local2.data){
                return;
            };
            SelectThumbnail(_local2);
            _local2.Select();
        }
        public function __btnRotateRight_change(_arg1:Event):void{
            if (!btnRotateRight.selected){
                return;
            };
            m_lcSending.send(m_strConnectionSending, "SetCurrentToolType", TOOLTYPE_MOVE, TOOLSUBTYPE_ROTATERIGHT);
            SetCursor(cursorRotateRightSymbol);
        }
        private function _BlingeeMaker_SetProperty1_i():SetProperty{
            var _local1:SetProperty = new SetProperty();
            _BlingeeMaker_SetProperty1 = _local1;
            _local1.name = "enabled";
            _local1.value = true;
            BindingManager.executeBindings(this, "_BlingeeMaker_SetProperty1", _BlingeeMaker_SetProperty1);
            return (_local1);
        }
        protected function SetGridVisibility(_arg1:Grid, _arg2:Boolean):void{
            _arg1.visible = _arg2;
            _arg1.includeInLayout = _arg2;
        }
        public function __btnSave_click(_arg1:MouseEvent):void{
            OnBtnSavePressed();
        }
        protected function OnFontChanged():void{
            SendFontInfo();
        }
        public function set btnSave(_arg1:Button):void{
            var _local2:Object = this._206185977btnSave;
            if (_local2 !== _arg1){
                this._206185977btnSave = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnSave", _local2, _arg1));
            };
        }
        public function set btnFill(_arg1:Button):void{
            var _local2:Object = this._205806079btnFill;
            if (_local2 !== _arg1){
                this._205806079btnFill = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "btnFill", _local2, _arg1));
            };
        }

    }
}//package 
