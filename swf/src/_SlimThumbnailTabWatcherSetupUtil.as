package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _SlimThumbnailTabWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            SlimThumbnailTab.watcherSetupUtil = new (_SlimThumbnailTabWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[0] = new PropertyWatcher("m_rgPages", {propertyChange:true}, [_arg3[0]], _arg2);
            _arg4[0].updateParent(_arg1);
        }

    }
}//package 
