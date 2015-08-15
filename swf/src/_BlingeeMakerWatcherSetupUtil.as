package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _BlingeeMakerWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            BlingeeMaker.watcherSetupUtil = new (_BlingeeMakerWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[26] = new PropertyWatcher("contentTabList", {propertyChange:true}, [_arg3[31]], _arg2);
            _arg4[29] = new PropertyWatcher("thumbnailTabList", {propertyChange:true}, [_arg3[34]], _arg2);
            _arg4[4] = new PropertyWatcher("m_strDefaultLoadingString", {propertyChange:true}, [_arg3[10]], _arg2);
            _arg4[1] = new PropertyWatcher("swfLoader", {propertyChange:true}, [_arg3[2], _arg3[6], _arg3[1], _arg3[7]], _arg2);
            _arg4[31] = new PropertyWatcher("thumbnailTabBar", {propertyChange:true}, [_arg3[36]], _arg2);
            _arg4[33] = new PropertyWatcher("height", {heightChanged:true}, [_arg3[36]], null);
            _arg4[32] = new PropertyWatcher("y", {yChanged:true}, [_arg3[36]], null);
            _arg4[3] = new PropertyWatcher("lblSaving", {propertyChange:true}, [_arg3[9], _arg3[8]], _arg2);
            _arg4[0] = new PropertyWatcher("btnSave", {propertyChange:true}, [_arg3[5], _arg3[0]], _arg2);
            _arg4[5] = new PropertyWatcher("rb", {propertyChange:true}, [_arg3[15], _arg3[19], _arg3[23], _arg3[11], _arg3[16], _arg3[18], _arg3[35], _arg3[12], _arg3[27], _arg3[32], _arg3[17], _arg3[13], _arg3[28], _arg3[21], _arg3[29], _arg3[20], _arg3[14], _arg3[37], _arg3[25]], _arg2);
            _arg4[2] = new PropertyWatcher("lblLoading", {propertyChange:true}, [_arg3[4], _arg3[3]], _arg2);
            _arg4[26].updateParent(_arg1);
            _arg4[29].updateParent(_arg1);
            _arg4[4].updateParent(_arg1);
            _arg4[1].updateParent(_arg1);
            _arg4[31].updateParent(_arg1);
            _arg4[31].addChild(_arg4[33]);
            _arg4[31].addChild(_arg4[32]);
            _arg4[3].updateParent(_arg1);
            _arg4[0].updateParent(_arg1);
            _arg4[5].updateParent(_arg1);
            _arg4[2].updateParent(_arg1);
        }

    }
}//package 
