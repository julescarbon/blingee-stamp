package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _LayerRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            LayerRenderer.watcherSetupUtil = new (_LayerRendererWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[4] = new PropertyWatcher("imageBox", {propertyChange:true}, [_arg3[2], _arg3[4], _arg3[3]], _arg2);
            _arg4[0] = new PropertyWatcher("data", {dataChange:true}, [_arg3[1], _arg3[0]], _arg2);
            _arg4[1] = new PropertyWatcher("photo", null, [_arg3[1], _arg3[0]], null);
            _arg4[2] = new PropertyWatcher("thumbnail", null, [_arg3[0]], null);
            _arg4[3] = new PropertyWatcher("name", null, [_arg3[1]], null);
            _arg4[4].updateParent(_arg1);
            _arg4[0].updateParent(_arg1);
            _arg4[0].addChild(_arg4[1]);
            _arg4[1].addChild(_arg4[2]);
            _arg4[1].addChild(_arg4[3]);
        }

    }
}//package 
