package {
    import flash.display.*;
    import mx.core.*;
    import mx.binding.*;

    public class _LayerMotionLineRendererWatcherSetupUtil extends Sprite implements IWatcherSetupUtil {

        public static function init(_arg1:IFlexModuleFactory):void{
            LayerMotionLineRenderer.watcherSetupUtil = new (_LayerMotionLineRendererWatcherSetupUtil)();
        }

        public function setup(_arg1:Object, _arg2:Function, _arg3:Array, _arg4:Array):void{
            _arg4[0] = new PropertyWatcher("imageBox", {propertyChange:true}, [_arg3[2], _arg3[1], _arg3[0]], _arg2);
            _arg4[0].updateParent(_arg1);
        }

    }
}//package 
