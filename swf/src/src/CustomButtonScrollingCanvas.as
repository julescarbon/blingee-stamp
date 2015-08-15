package src {
    import flexlib.containers.*;

    public class CustomButtonScrollingCanvas extends ButtonScrollingCanvas {

        override protected function positionButtons(_arg1:Number, _arg2:Number):void{
            var _local3:Number = this.buttonWidth;
            var _local4:Number = ((this._explicitButtonHeight) ? this._explicitButtonHeight : _arg2);
            leftButton.move(0, 0);
            leftButton.setActualSize(_local3, _local4);
            rightButton.move((_arg1 - _local3), 0);
            rightButton.setActualSize(_local3, _local4);
            if (leftButton.visible){
                upButton.move(_local3, 0);
                downButton.move(_local3, (_arg2 - _local3));
                if (rightButton.visible){
                    upButton.setActualSize((_arg1 - (_local3 * 2)), _local3);
                    downButton.setActualSize((_arg1 - (_local3 * 2)), _local3);
                } else {
                    upButton.setActualSize((_arg1 - _local3), _local3);
                    downButton.setActualSize((_arg1 - _local3), _local3);
                };
            } else {
                upButton.move(0, 0);
                downButton.move(0, (_arg2 - _local3));
                if (rightButton.visible){
                    upButton.setActualSize((_arg1 - _local3), _local3);
                    downButton.setActualSize((_arg1 - _local3), _local3);
                } else {
                    upButton.setActualSize(_arg1, _local3);
                    downButton.setActualSize(_arg1, _local3);
                };
            };
        }

    }
}//package src 
