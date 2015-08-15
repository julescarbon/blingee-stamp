package mx.managers {
    import mx.core.*;
    import flash.events.*;
    import mx.managers.dragClasses.*;

    public class DragManager {

        public static const MOVE:String = "move";
        public static const COPY:String = "copy";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const LINK:String = "link";
        public static const NONE:String = "none";

        private static var implClassDependency:DragManagerImpl;
        private static var _impl:IDragManager;

        private static function get impl():IDragManager{
            if (!_impl){
                _impl = IDragManager(Singleton.getInstance("mx.managers::IDragManager"));
            };
            return (_impl);
        }
        mx_internal static function get dragProxy():DragProxy{
            return (Object(impl).dragProxy);
        }
        public static function showFeedback(_arg1:String):void{
            impl.showFeedback(_arg1);
        }
        public static function acceptDragDrop(_arg1:IUIComponent):void{
            impl.acceptDragDrop(_arg1);
        }
        public static function doDrag(_arg1:IUIComponent, _arg2:DragSource, _arg3:MouseEvent, _arg4:IFlexDisplayObject=null, _arg5:Number=0, _arg6:Number=0, _arg7:Number=0.5, _arg8:Boolean=true):void{
            impl.doDrag(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8);
        }
        mx_internal static function endDrag():void{
            impl.endDrag();
        }
        public static function get isDragging():Boolean{
            return (impl.isDragging);
        }
        public static function getFeedback():String{
            return (impl.getFeedback());
        }

    }
}//package mx.managers 
