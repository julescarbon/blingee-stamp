package {
    import mx.core.*;
    import mx.managers.*;
    import flash.system.*;

    public class _BlingeeMaker_mx_managers_SystemManager extends SystemManager implements IFlexModuleFactory {

        override public function create(... _args):Object{
            if ((((_args.length > 0)) && (!((_args[0] is String))))){
                return (super.create.apply(this, _args));
            };
            var _local2:String = (((_args.length == 0)) ? "BlingeeMaker" : String(_args[0]));
            var _local3:Class = Class(getDefinitionByName(_local2));
            if (!_local3){
                return (null);
            };
            var _local4:Object = new (_local3)();
            if ((_local4 is IFlexModule)){
                IFlexModule(_local4).moduleFactory = this;
            };
            return (_local4);
        }
        override public function info():Object{
            return ({
                backgroundAlpha:"0",
                compiledLocales:["en_US"],
                compiledResourceBundleNames:["LocaleDutch", "LocaleEnglish", "LocaleFrench", "LocaleGerman", "LocaleItalian", "LocaleJapanese", "LocalePortuguese", "LocaleSpanish", "SharedResources", "collections", "containers", "controls", "core", "effects", "formatters", "logging", "messaging", "rpc", "skins", "styles"],
                creationComplete:"OnCreationComplete()",
                currentDomain:ApplicationDomain.currentDomain,
                frameRate:"12",
                horizontalAlign:"left",
                initialize:"Initialize()",
                layout:"vertical",
                mainClassName:"BlingeeMaker",
                mixins:["_BlingeeMaker_FlexInit", "_alertButtonStyleStyle", "_ControlBarStyle", "_ScrollBarStyle", "_TabBarStyle", "_activeTabStyleStyle", "_TabStyle", "_textAreaHScrollBarStyleStyle", "_ToolTipStyle", "_ComboBoxStyle", "_DragManagerStyle", "_TextAreaStyle", "_advancedDataGridStylesStyle", "_comboDropdownStyle", "_ListBaseStyle", "_textAreaVScrollBarStyleStyle", "_ContainerStyle", "_linkButtonStyleStyle", "_globalStyle", "_windowStatusStyle", "_PanelStyle", "_windowStylesStyle", "_activeButtonStyleStyle", "_HSliderStyle", "_LinkBarStyle", "_NumericStepperStyle", "_errorTipStyle", "_richTextEditorTextAreaStyleStyle", "_CursorManagerStyle", "_todayStyleStyle", "_dateFieldPopupStyle", "_ButtonBarStyle", "_TextInputStyle", "_ButtonBarButtonStyle", "_HRuleStyle", "_plainStyle", "_dataGridStylesStyle", "_LinkButtonStyle", "_ApplicationStyle", "_SWFLoaderStyle", "_headerDateTextStyle", "_ButtonStyle", "_popUpMenuStyle", "_AlertStyle", "_swatchPanelTextFieldStyle", "_opaquePanelStyle", "_weekDayStyleStyle", "_headerDragProxyStyleStyle", "_TileListStyle", "_SlimThumbnailTabWatcherSetupUtil", "_BlingeeMakerWatcherSetupUtil", "_LayersTabWatcherSetupUtil", "_ThumbnailWatcherSetupUtil", "_LayerMotionLineRendererWatcherSetupUtil", "_LayerRendererWatcherSetupUtil"],
                paddingBottom:"0",
                paddingLeft:"0",
                paddingRight:"0",
                paddingTop:"0",
                resize:"OnResize()",
                verticalAlign:"top"
            });
        }

    }
}//package 
