package mx.effects.effectClasses {
    import mx.core.*;
    import flash.events.*;
    import mx.events.*;
    import mx.styles.*;
    import mx.effects.*;

    public class MoveInstance extends TweenEffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var xFrom:Number;
        public var yFrom:Number;
        private var left;
        private var forceClipping:Boolean = false;
        public var xTo:Number;
        private var top;
        private var horizontalCenter;
        public var yTo:Number;
        private var oldWidth:Number;
        private var right;
        private var bottom;
        private var oldHeight:Number;
        public var xBy:Number;
        public var yBy:Number;
        private var checkClipping:Boolean = true;
        private var verticalCenter;

        public function MoveInstance(_arg1:Object){
            super(_arg1);
        }
        override public function initEffect(_arg1:Event):void{
            super.initEffect(_arg1);
            if ((((_arg1 is MoveEvent)) && ((_arg1.type == MoveEvent.MOVE)))){
                if (((((((((((isNaN(xFrom)) && (isNaN(xTo)))) && (isNaN(xBy)))) && (isNaN(yFrom)))) && (isNaN(yTo)))) && (isNaN(yBy)))){
                    xFrom = MoveEvent(_arg1).oldX;
                    xTo = target.x;
                    yFrom = MoveEvent(_arg1).oldY;
                    yTo = target.y;
                };
            };
        }
        override public function play():void{
            var _local2:EdgeMetrics;
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            super.play();
            var _local9 = EffectManager;
            _local9.mx_internal::startBitmapEffect(IUIComponent(target));
            if (isNaN(xFrom)){
                xFrom = ((((!(isNaN(xTo))) && (!(isNaN(xBy))))) ? (xTo - xBy) : target.x);
            };
            if (isNaN(xTo)){
                if (((((isNaN(xBy)) && (propertyChanges))) && (!((propertyChanges.end["x"] === undefined))))){
                    xTo = propertyChanges.end["x"];
                } else {
                    xTo = ((isNaN(xBy)) ? target.x : (xFrom + xBy));
                };
            };
            if (isNaN(yFrom)){
                yFrom = ((((!(isNaN(yTo))) && (!(isNaN(yBy))))) ? (yTo - yBy) : target.y);
            };
            if (isNaN(yTo)){
                if (((((isNaN(yBy)) && (propertyChanges))) && (!((propertyChanges.end["y"] === undefined))))){
                    yTo = propertyChanges.end["y"];
                } else {
                    yTo = ((isNaN(yBy)) ? target.y : (yFrom + yBy));
                };
            };
            tween = createTween(this, [xFrom, yFrom], [xTo, yTo], duration);
            var _local1:Container = (target.parent as Container);
            if (_local1){
                _local2 = _local1.viewMetrics;
                _local3 = _local2.left;
                _local4 = (_local1.width - _local2.right);
                _local5 = _local2.top;
                _local6 = (_local1.height - _local2.bottom);
                if ((((((((((((((((xFrom < _local3)) || ((xTo < _local3)))) || (((xFrom + target.width) > _local4)))) || (((xTo + target.width) > _local4)))) || ((yFrom < _local5)))) || ((yTo < _local5)))) || (((yFrom + target.height) > _local6)))) || (((yTo + target.height) > _local6)))){
                    forceClipping = true;
                    _local1.mx_internal::forceClipping = true;
                };
            };
            mx_internal::applyTweenStartValues();
            if ((target is IStyleClient)){
                left = target.getStyle("left");
                if (left != undefined){
                    target.setStyle("left", undefined);
                };
                right = target.getStyle("right");
                if (right != undefined){
                    target.setStyle("right", undefined);
                };
                top = target.getStyle("top");
                if (top != undefined){
                    target.setStyle("top", undefined);
                };
                bottom = target.getStyle("bottom");
                if (bottom != undefined){
                    target.setStyle("bottom", undefined);
                };
                horizontalCenter = target.getStyle("horizontalCenter");
                if (horizontalCenter != undefined){
                    target.setStyle("horizontalCenter", undefined);
                };
                verticalCenter = target.getStyle("verticalCenter");
                if (verticalCenter != undefined){
                    target.setStyle("verticalCenter", undefined);
                };
                if (((!((left == undefined))) && (!((right == undefined))))){
                    _local7 = target.width;
                    oldWidth = target.explicitWidth;
                    target.width = _local7;
                };
                if (((!((top == undefined))) && (!((bottom == undefined))))){
                    _local8 = target.height;
                    oldHeight = target.explicitHeight;
                    target.height = _local8;
                };
            };
        }
        override public function onTweenUpdate(_arg1:Object):void{
            var _local2:Container;
            var _local3:EdgeMetrics;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            EffectManager.suspendEventHandling();
            if (((!(forceClipping)) && (checkClipping))){
                _local2 = (target.parent as Container);
                if (_local2){
                    _local3 = _local2.viewMetrics;
                    _local4 = _local3.left;
                    _local5 = (_local2.width - _local3.right);
                    _local6 = _local3.top;
                    _local7 = (_local2.height - _local3.bottom);
                    if ((((((((_arg1[0] < _local4)) || (((_arg1[0] + target.width) > _local5)))) || ((_arg1[1] < _local6)))) || (((_arg1[1] + target.height) > _local7)))){
                        forceClipping = true;
                        _local2.mx_internal::forceClipping = true;
                    };
                };
            };
            target.move(_arg1[0], _arg1[1]);
            EffectManager.resumeEventHandling();
        }
        override public function onTweenEnd(_arg1:Object):void{
            var _local2:Container;
            var _local3 = EffectManager;
            _local3.mx_internal::endBitmapEffect(IUIComponent(target));
            if (left != undefined){
                target.setStyle("left", left);
            };
            if (right != undefined){
                target.setStyle("right", right);
            };
            if (top != undefined){
                target.setStyle("top", top);
            };
            if (bottom != undefined){
                target.setStyle("bottom", bottom);
            };
            if (horizontalCenter != undefined){
                target.setStyle("horizontalCenter", horizontalCenter);
            };
            if (verticalCenter != undefined){
                target.setStyle("verticalCenter", verticalCenter);
            };
            if (((!((left == undefined))) && (!((right == undefined))))){
                target.explicitWidth = oldWidth;
            };
            if (((!((top == undefined))) && (!((bottom == undefined))))){
                target.explicitHeight = oldHeight;
            };
            if (forceClipping){
                _local2 = (target.parent as Container);
                if (_local2){
                    forceClipping = false;
                    _local2.mx_internal::forceClipping = false;
                };
            };
            checkClipping = false;
            super.onTweenEnd(_arg1);
        }

    }
}//package mx.effects.effectClasses 
