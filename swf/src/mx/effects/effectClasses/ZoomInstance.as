package mx.effects.effectClasses {
    import flash.events.*;
    import mx.events.*;
    import mx.effects.*;

    public class ZoomInstance extends TweenEffectInstance {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var newY:Number;
        public var originY:Number;
        private var origX:Number;
        private var origY:Number;
        public var originX:Number;
        private var origPercentHeight:Number;
        public var zoomWidthFrom:Number;
        public var zoomWidthTo:Number;
        private var newX:Number;
        public var captureRollEvents:Boolean;
        private var origPercentWidth:Number;
        public var zoomHeightFrom:Number;
        private var origScaleX:Number;
        public var zoomHeightTo:Number;
        private var origScaleY:Number;
        private var scaledOriginX:Number;
        private var scaledOriginY:Number;
        private var show:Boolean = true;
        private var _mouseHasMoved:Boolean = false;

        public function ZoomInstance(_arg1:Object){
            super(_arg1);
        }
        override public function finishEffect():void{
            if (captureRollEvents){
                target.removeEventListener(MouseEvent.ROLL_OVER, mouseEventHandler, false);
                target.removeEventListener(MouseEvent.ROLL_OUT, mouseEventHandler, false);
                target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler, false);
            };
            super.finishEffect();
        }
        private function getScaleFromWidth(_arg1:Number):Number{
            return ((_arg1 / (target.width / Math.abs(target.scaleX))));
        }
        override public function initEffect(_arg1:Event):void{
            super.initEffect(_arg1);
            if ((((_arg1.type == FlexEvent.HIDE)) || ((_arg1.type == Event.REMOVED)))){
                show = false;
            };
        }
        private function getScaleFromHeight(_arg1:Number):Number{
            return ((_arg1 / (target.height / Math.abs(target.scaleY))));
        }
        private function applyPropertyChanges():void{
            var _local2:Boolean;
            var _local3:Boolean;
            var _local1:PropertyChanges = propertyChanges;
            if (_local1){
                _local2 = false;
                _local3 = false;
                if (_local1.end["scaleX"] !== undefined){
                    zoomWidthFrom = ((isNaN(zoomWidthFrom)) ? target.scaleX : zoomWidthFrom);
                    zoomWidthTo = ((isNaN(zoomWidthTo)) ? _local1.end["scaleX"] : zoomWidthTo);
                    _local3 = true;
                };
                if (_local1.end["scaleY"] !== undefined){
                    zoomHeightFrom = ((isNaN(zoomHeightFrom)) ? target.scaleY : zoomHeightFrom);
                    zoomHeightTo = ((isNaN(zoomHeightTo)) ? _local1.end["scaleY"] : zoomHeightTo);
                    _local3 = true;
                };
                if (_local3){
                    return;
                };
                if (_local1.end["width"] !== undefined){
                    zoomWidthFrom = ((isNaN(zoomWidthFrom)) ? getScaleFromWidth(target.width) : zoomWidthFrom);
                    zoomWidthTo = ((isNaN(zoomWidthTo)) ? getScaleFromWidth(_local1.end["width"]) : zoomWidthTo);
                    _local2 = true;
                };
                if (_local1.end["height"] !== undefined){
                    zoomHeightFrom = ((isNaN(zoomHeightFrom)) ? getScaleFromHeight(target.height) : zoomHeightFrom);
                    zoomHeightTo = ((isNaN(zoomHeightTo)) ? getScaleFromHeight(_local1.end["height"]) : zoomHeightTo);
                    _local2 = true;
                };
                if (_local2){
                    return;
                };
                if (_local1.end["visible"] !== undefined){
                    show = _local1.end["visible"];
                };
            };
        }
        private function mouseEventHandler(_arg1:MouseEvent):void{
            if (_arg1.type == MouseEvent.MOUSE_MOVE){
                _mouseHasMoved = true;
            } else {
                if ((((_arg1.type == MouseEvent.ROLL_OUT)) || ((_arg1.type == MouseEvent.ROLL_OVER)))){
                    if (!_mouseHasMoved){
                        _arg1.stopImmediatePropagation();
                    };
                    _mouseHasMoved = false;
                };
            };
        }
        override public function play():void{
            super.play();
            applyPropertyChanges();
            if (((((((isNaN(zoomWidthFrom)) && (isNaN(zoomWidthTo)))) && (isNaN(zoomHeightFrom)))) && (isNaN(zoomHeightTo)))){
                if (show){
                    zoomWidthFrom = (zoomHeightFrom = 0);
                    zoomWidthTo = target.scaleX;
                    zoomHeightTo = target.scaleY;
                } else {
                    zoomWidthFrom = target.scaleX;
                    zoomHeightFrom = target.scaleY;
                    zoomWidthTo = (zoomHeightTo = 0);
                };
            } else {
                if (((isNaN(zoomWidthFrom)) && (isNaN(zoomWidthTo)))){
                    zoomWidthFrom = (zoomWidthTo = target.scaleX);
                } else {
                    if (((isNaN(zoomHeightFrom)) && (isNaN(zoomHeightTo)))){
                        zoomHeightFrom = (zoomHeightTo = target.scaleY);
                    };
                };
                if (isNaN(zoomWidthFrom)){
                    zoomWidthFrom = target.scaleX;
                } else {
                    if (isNaN(zoomWidthTo)){
                        zoomWidthTo = ((zoomWidthFrom)==1) ? 0 : 1;
                    };
                };
                if (isNaN(zoomHeightFrom)){
                    zoomHeightFrom = target.scaleY;
                } else {
                    if (isNaN(zoomHeightTo)){
                        zoomHeightTo = ((zoomHeightFrom)==1) ? 0 : 1;
                    };
                };
            };
            if (zoomWidthFrom < 0.01){
                zoomWidthFrom = 0.01;
            };
            if (zoomWidthTo < 0.01){
                zoomWidthTo = 0.01;
            };
            if (zoomHeightFrom < 0.01){
                zoomHeightFrom = 0.01;
            };
            if (zoomHeightTo < 0.01){
                zoomHeightTo = 0.01;
            };
            origScaleX = target.scaleX;
            origScaleY = target.scaleY;
            newX = (origX = target.x);
            newY = (origY = target.y);
            if (isNaN(originX)){
                scaledOriginX = (target.width / 2);
            } else {
                scaledOriginX = (originX * origScaleX);
            };
            if (isNaN(originY)){
                scaledOriginY = (target.height / 2);
            } else {
                scaledOriginY = (originY * origScaleY);
            };
            scaledOriginX = Number(scaledOriginX.toFixed(1));
            scaledOriginY = Number(scaledOriginY.toFixed(1));
            origPercentWidth = target.percentWidth;
            if (!isNaN(origPercentWidth)){
                target.width = target.width;
            };
            origPercentHeight = target.percentHeight;
            if (!isNaN(origPercentHeight)){
                target.height = target.height;
            };
            tween = createTween(this, [zoomWidthFrom, zoomHeightFrom], [zoomWidthTo, zoomHeightTo], duration);
            if (captureRollEvents){
                target.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler, false);
                target.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler, false);
                target.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler, false);
            };
        }
        override public function onTweenEnd(_arg1:Object):void{
            var _local2:Number;
            var _local3:Number;
            if (!isNaN(origPercentWidth)){
                _local2 = target.width;
                target.percentWidth = origPercentWidth;
                if (((target.parent) && ((target.parent.autoLayout == false)))){
                    target._width = _local2;
                };
            };
            if (!isNaN(origPercentHeight)){
                _local3 = target.height;
                target.percentHeight = origPercentHeight;
                if (((target.parent) && ((target.parent.autoLayout == false)))){
                    target._height = _local3;
                };
            };
            super.onTweenEnd(_arg1);
            if (hideOnEffectEnd){
                EffectManager.suspendEventHandling();
                target.scaleX = origScaleX;
                target.scaleY = origScaleY;
                target.move(origX, origY);
                EffectManager.resumeEventHandling();
            };
        }
        override public function onTweenUpdate(_arg1:Object):void{
            EffectManager.suspendEventHandling();
            if (Math.abs((newX - target.x)) > 0.1){
                origX = (origX + (Number(target.x.toFixed(1)) - newX));
            };
            if (Math.abs((newY - target.y)) > 0.1){
                origY = (origY + (Number(target.y.toFixed(1)) - newY));
            };
            target.scaleX = _arg1[0];
            target.scaleY = _arg1[1];
            var _local2:Number = (_arg1[0] / origScaleX);
            var _local3:Number = (_arg1[1] / origScaleY);
            var _local4:Number = (scaledOriginX * _local2);
            var _local5:Number = (scaledOriginY * _local3);
            newX = ((scaledOriginX - _local4) + origX);
            newY = ((scaledOriginY - _local5) + origY);
            newX = Number(newX.toFixed(1));
            newY = Number(newY.toFixed(1));
            target.move(newX, newY);
            if (tween){
                tween.needToLayout = true;
            } else {
                needToLayout = true;
            };
            EffectManager.resumeEventHandling();
        }

    }
}//package mx.effects.effectClasses 
