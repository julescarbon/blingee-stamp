package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _LayersTabWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            LayersTab.watcherSetupUtil = new (_LayersTabWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[6] = new PropertyWatcher("m_rgLayers", {propertyChange:true}, [_arg3[5]], _arg2);
            _arg4[0] = new PropertyWatcher("languageResource", {propertyChange:true}, [_arg3[9], _arg3[11], _arg3[6], _arg3[1], _arg3[3], _arg3[7], _arg3[12], _arg3[0]], _arg2);
            _arg4[14] = new PropertyWatcher("m_rgLayerMotions", {propertyChange:true}, [_arg3[13]], _arg2);
            _arg4[6].updateParent(_arg1);
            _arg4[0].updateParent(_arg1);
            _arg4[14].updateParent(_arg1);
        }

    }
}//package 
