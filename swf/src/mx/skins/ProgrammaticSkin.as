package mx.skins {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.managers.*;
    import mx.styles.*;
    import mx.utils.*;

    public class ProgrammaticSkin extends FlexShape implements IFlexDisplayObject, IInvalidating, ILayoutManagerClient, ISimpleStyleClient, IProgrammaticSkin {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var tempMatrix:Matrix = new Matrix();

        private var _initialized:Boolean = false;
        private var _height:Number;
        private var invalidateDisplayListFlag:Boolean = false;
        private var _styleName:IStyleClient;
        private var _nestLevel:int = 0;
        private var _processedDescriptors:Boolean = false;
        private var _updateCompletePendingFlag:Boolean = true;
        private var _width:Number;

        public function ProgrammaticSkin(){
            _width = measuredWidth;
            _height = measuredHeight;
        }
        public function getStyle(_arg1:String){
            return (((_styleName) ? _styleName.getStyle(_arg1) : null));
        }
        protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
        }
        public function get nestLevel():int{
            return (_nestLevel);
        }
        public function set nestLevel(_arg1:int):void{
            _nestLevel = _arg1;
            invalidateDisplayList();
        }
        override public function get height():Number{
            return (_height);
        }
        public function get updateCompletePendingFlag():Boolean{
            return (_updateCompletePendingFlag);
        }
        protected function verticalGradientMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Matrix{
            return (rotatedGradientMatrix(_arg1, _arg2, _arg3, _arg4, 90));
        }
        public function validateSize(_arg1:Boolean=false):void{
        }
        public function invalidateDisplayList():void{
            if (((!(invalidateDisplayListFlag)) && ((nestLevel > 0)))){
                invalidateDisplayListFlag = true;
                UIComponentGlobals.layoutManager.invalidateDisplayList(this);
            };
        }
        public function set updateCompletePendingFlag(_arg1:Boolean):void{
            _updateCompletePendingFlag = _arg1;
        }
        protected function horizontalGradientMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Matrix{
            return (rotatedGradientMatrix(_arg1, _arg2, _arg3, _arg4, 0));
        }
        override public function set height(_arg1:Number):void{
            _height = _arg1;
            invalidateDisplayList();
        }
        public function set processedDescriptors(_arg1:Boolean):void{
            _processedDescriptors = _arg1;
        }
        public function validateDisplayList():void{
            invalidateDisplayListFlag = false;
            updateDisplayList(width, height);
        }
        public function get measuredWidth():Number{
            return (0);
        }
        override public function set width(_arg1:Number):void{
            _width = _arg1;
            invalidateDisplayList();
        }
        public function get measuredHeight():Number{
            return (0);
        }
        public function set initialized(_arg1:Boolean):void{
            _initialized = _arg1;
        }
        protected function drawRoundRect(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Object=null, _arg6:Object=null, _arg7:Object=null, _arg8:Matrix=null, _arg9:String="linear", _arg10:Array=null, _arg11:Object=null):void{
            var _local13:Number;
            var _local14:Array;
            var _local15:Object;
            var _local12:Graphics = graphics;
            if ((((_arg3 == 0)) || ((_arg4 == 0)))){
                return;
            };
            if (_arg6 !== null){
                if ((_arg6 is uint)){
                    _local12.beginFill(uint(_arg6), Number(_arg7));
                } else {
                    if ((_arg6 is Array)){
                        _local14 = (((_arg7 is Array)) ? (_arg7 as Array) : [_arg7, _arg7]);
                        if (!_arg10){
                            _arg10 = [0, 0xFF];
                        };
                        _local12.beginGradientFill(_arg9, (_arg6 as Array), _local14, _arg10, _arg8);
                    };
                };
            };
            if (!_arg5){
                _local12.drawRect(_arg1, _arg2, _arg3, _arg4);
            } else {
                if ((_arg5 is Number)){
                    _local13 = (Number(_arg5) * 2);
                    _local12.drawRoundRect(_arg1, _arg2, _arg3, _arg4, _local13, _local13);
                } else {
                    GraphicsUtil.drawRoundRectComplex(_local12, _arg1, _arg2, _arg3, _arg4, _arg5.tl, _arg5.tr, _arg5.bl, _arg5.br);
                };
            };
            if (_arg11){
                _local15 = _arg11.r;
                if ((_local15 is Number)){
                    _local13 = (Number(_local15) * 2);
                    _local12.drawRoundRect(_arg11.x, _arg11.y, _arg11.w, _arg11.h, _local13, _local13);
                } else {
                    GraphicsUtil.drawRoundRectComplex(_local12, _arg11.x, _arg11.y, _arg11.w, _arg11.h, _local15.tl, _local15.tr, _local15.bl, _local15.br);
                };
            };
            if (_arg6 !== null){
                _local12.endFill();
            };
        }
        public function get processedDescriptors():Boolean{
            return (_processedDescriptors);
        }
        public function set styleName(_arg1:Object):void{
            if (_styleName != _arg1){
                _styleName = (_arg1 as IStyleClient);
                invalidateDisplayList();
            };
        }
        public function setActualSize(_arg1:Number, _arg2:Number):void{
            var _local3:Boolean;
            if (_width != _arg1){
                _width = _arg1;
                _local3 = true;
            };
            if (_height != _arg2){
                _height = _arg2;
                _local3 = true;
            };
            if (_local3){
                invalidateDisplayList();
            };
        }
        public function styleChanged(_arg1:String):void{
            invalidateDisplayList();
        }
        override public function get width():Number{
            return (_width);
        }
        public function invalidateProperties():void{
        }
        public function get initialized():Boolean{
            return (_initialized);
        }
        protected function rotatedGradientMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number):Matrix{
            tempMatrix.createGradientBox(_arg3, _arg4, ((_arg5 * Math.PI) / 180), _arg1, _arg2);
            return (tempMatrix);
        }
        public function move(_arg1:Number, _arg2:Number):void{
            this.x = _arg1;
            this.y = _arg2;
        }
        public function get styleName():Object{
            return (_styleName);
        }
        public function validateNow():void{
            if (invalidateDisplayListFlag){
                validateDisplayList();
            };
        }
        public function invalidateSize():void{
        }
        public function validateProperties():void{
        }

    }
}//package mx.skins 
