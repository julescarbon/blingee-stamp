package mx.events {
    import mx.core.*;
    import flash.events.*;

    public class SWFBridgeRequest extends Event {

        public static const SHOW_MOUSE_CURSOR_REQUEST:String = "showMouseCursorRequest";
        public static const DEACTIVATE_POP_UP_REQUEST:String = "deactivatePopUpRequest";
        public static const SET_ACTUAL_SIZE_REQUEST:String = "setActualSizeRequest";
        public static const MOVE_FOCUS_REQUEST:String = "moveFocusRequest";
        public static const GET_VISIBLE_RECT_REQUEST:String = "getVisibleRectRequest";
        public static const ADD_POP_UP_PLACE_HOLDER_REQUEST:String = "addPopUpPlaceHolderRequest";
        public static const REMOVE_POP_UP_PLACE_HOLDER_REQUEST:String = "removePopUpPlaceHolderRequest";
        public static const RESET_MOUSE_CURSOR_REQUEST:String = "resetMouseCursorRequest";
        public static const ADD_POP_UP_REQUEST:String = "addPopUpRequest";
        public static const GET_SIZE_REQUEST:String = "getSizeRequest";
        public static const SHOW_MODAL_WINDOW_REQUEST:String = "showModalWindowRequest";
        public static const ACTIVATE_FOCUS_REQUEST:String = "activateFocusRequest";
        public static const DEACTIVATE_FOCUS_REQUEST:String = "deactivateFocusRequest";
        public static const HIDE_MOUSE_CURSOR_REQUEST:String = "hideMouseCursorRequest";
        public static const ACTIVATE_POP_UP_REQUEST:String = "activatePopUpRequest";
        public static const IS_BRIDGE_CHILD_REQUEST:String = "isBridgeChildRequest";
        public static const CAN_ACTIVATE_POP_UP_REQUEST:String = "canActivateRequestPopUpRequest";
        public static const HIDE_MODAL_WINDOW_REQUEST:String = "hideModalWindowRequest";
        public static const INVALIDATE_REQUEST:String = "invalidateRequest";
        public static const SET_SHOW_FOCUS_INDICATOR_REQUEST:String = "setShowFocusIndicatorRequest";
        public static const CREATE_MODAL_WINDOW_REQUEST:String = "createModalWindowRequest";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const REMOVE_POP_UP_REQUEST:String = "removePopUpRequest";

        public var requestor:IEventDispatcher;
        public var data:Object;

        public function SWFBridgeRequest(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:IEventDispatcher=null, _arg5:Object=null){
            super(_arg1, _arg2, _arg3);
            this.requestor = _arg4;
            this.data = _arg5;
        }
        public static function marshal(_arg1:Event):SWFBridgeRequest{
            var _local2:Object = _arg1;
            return (new SWFBridgeRequest(_local2.type, _local2.bubbles, _local2.cancelable, _local2.requestor, _local2.data));
        }

        override public function clone():Event{
            return (new SWFBridgeRequest(type, bubbles, cancelable, requestor, data));
        }

    }
}//package mx.events 
