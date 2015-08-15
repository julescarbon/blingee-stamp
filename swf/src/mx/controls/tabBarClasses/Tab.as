package mx.controls.tabBarClasses {
    import flash.display.*;
    import flash.text.*;
    import mx.core.*;
    import mx.styles.*;
    import mx.controls.*;

    public class Tab extends Button {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var focusSkin:IFlexDisplayObject;

        public function Tab(){
            focusEnabled = false;
        }
        override public function drawFocus(_arg1:Boolean):void{
            var _local2:Boolean;
            var _local3:Class;
            if (((((_arg1) && (!(selected)))) && (!(isEffectStarted)))){
                if (!focusSkin){
                    _local2 = false;
                    _local3 = getStyle(overSkinName);
                    if (!_local3){
                        _local3 = getStyle(skinName);
                        _local2 = true;
                    };
                    if (_local3){
                        focusSkin = new (_local3)();
                        DisplayObject(focusSkin).name = overSkinName;
                        if ((focusSkin is ISimpleStyleClient)){
                            ISimpleStyleClient(focusSkin).styleName = this;
                        };
                        addChild(DisplayObject(focusSkin));
                        if (((((_local2) && (!((focusSkin is IProgrammaticSkin))))) && ((focusSkin is IStateClient)))){
                            IStateClient(focusSkin).currentState = "over";
                        };
                    };
                };
                invalidateDisplayList();
                validateNow();
            } else {
                if (focusSkin){
                    removeChild(DisplayObject(focusSkin));
                    focusSkin = null;
                };
            };
        }
        override mx_internal function layoutContents(_arg1:Number, _arg2:Number, _arg3:Boolean):void{
            super.layoutContents(_arg1, _arg2, _arg3);
            if (selected){
                textField.y++;
                if (currentIcon){
                    currentIcon.y++;
                };
            };
            if (currentSkin){
                setChildIndex(DisplayObject(currentSkin), (numChildren - 1));
            };
            if (((focusSkin) && (!(selected)))){
                focusSkin.setActualSize(_arg1, _arg2);
                setChildIndex(DisplayObject(focusSkin), (numChildren - 1));
            };
            if (currentIcon){
                setChildIndex(DisplayObject(currentIcon), (numChildren - 1));
            };
            if (textField){
                setChildIndex(DisplayObject(textField), (numChildren - 1));
            };
        }
        override protected function updateDisplayList(_arg1:Number, _arg2:Number):void{
            super.updateDisplayList(_arg1, _arg2);
            if (currentIcon){
                currentIcon.scaleX = 1;
                currentIcon.scaleY = 1;
            };
            viewIcon();
        }
        override public function measureText(_arg1:String):TextLineMetrics{
            return (((textField.styleName)==this) ? super.measureText(_arg1) : textField.getUITextFormat().measureText(_arg1));
        }
        override mx_internal function viewIcon():void{
            var _local1:Number;
            super.viewIcon();
            if (currentIcon){
                if (((!((height == 0))) && ((currentIcon.height > (height - 4))))){
                    _local1 = ((height - 4) / currentIcon.height);
                    currentIcon.scaleX = _local1;
                    currentIcon.scaleY = _local1;
                    invalidateSize();
                    if (height > 0){
                        layoutContents(width, height, false);
                    };
                };
            };
        }

    }
}//package mx.controls.tabBarClasses 
