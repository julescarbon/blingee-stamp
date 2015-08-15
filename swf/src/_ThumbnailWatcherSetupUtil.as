package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _ThumbnailWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            Thumbnail.watcherSetupUtil = new (_ThumbnailWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[7] = new PropertyWatcher("imageBox", {propertyChange:true}, [_arg3[6], _arg3[7], _arg3[5]], _arg2);
            _arg4[2] = new PropertyWatcher("data", {dataChange:true}, [_arg3[2], _arg3[4], _arg3[3]], _arg2);
            _arg4[3] = new PropertyWatcher("thumbnail", null, [_arg3[2]], null);
            _arg4[4] = new PropertyWatcher("source", null, [_arg3[2]], null);
            _arg4[6] = new PropertyWatcher("isLocked", null, [_arg3[4]], null);
            _arg4[5] = new PropertyWatcher("name", null, [_arg3[3]], null);
            _arg4[1] = new PropertyWatcher("showThumnail", {propertyChange:true}, [_arg3[2]], _arg2);
            _arg4[7].updateParent(_arg1);
            _arg4[2].updateParent(_arg1);
            _arg4[2].addChild(_arg4[3]);
            _arg4[2].addChild(_arg4[4]);
            _arg4[2].addChild(_arg4[6]);
            _arg4[2].addChild(_arg4[5]);
            _arg4[1].updateParent(_arg1);
        }

    }
}//package 
