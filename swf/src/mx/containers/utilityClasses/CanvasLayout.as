package mx.containers.utilityClasses {
    import flash.display.*;
    import flash.geom.*;
    import mx.core.*;
    import mx.events.*;
    import flash.utils.*;
    import mx.containers.errors.*;

    public class CanvasLayout extends Layout {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static var r:Rectangle = new Rectangle();

        private var colSpanChildren:Array;
        private var constraintRegionsInUse:Boolean = false;
        private var rowSpanChildren:Array;
        private var constraintCache:Dictionary;
        private var _contentArea:Rectangle;

        public function CanvasLayout(){
            colSpanChildren = [];
            rowSpanChildren = [];
            constraintCache = new Dictionary(true);
            super();
        }
        private function parseConstraints(_arg1:IUIComponent=null):ChildConstraintInfo{
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:String;
            var _local11:String;
            var _local12:String;
            var _local13:String;
            var _local14:String;
            var _local15:String;
            var _local16:String;
            var _local17:Array;
            var _local18:int;
            var _local30:ConstraintColumn;
            var _local31:Boolean;
            var _local32:ConstraintRow;
            var _local2:LayoutConstraints = getLayoutConstraints(_arg1);
            if (!_local2){
                return (null);
            };
            while (true) {
                _local17 = parseConstraintExp(_local2.left);
                if (!_local17){
                    _local3 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local3 = Number(_local17[0]);
                    } else {
                        _local10 = _local17[0];
                        _local3 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.right);
                if (!_local17){
                    _local4 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local4 = Number(_local17[0]);
                    } else {
                        _local11 = _local17[0];
                        _local4 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.horizontalCenter);
                if (!_local17){
                    _local5 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local5 = Number(_local17[0]);
                    } else {
                        _local12 = _local17[0];
                        _local5 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.top);
                if (!_local17){
                    _local6 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local6 = Number(_local17[0]);
                    } else {
                        _local13 = _local17[0];
                        _local6 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.bottom);
                if (!_local17){
                    _local7 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local7 = Number(_local17[0]);
                    } else {
                        _local14 = _local17[0];
                        _local7 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.verticalCenter);
                if (!_local17){
                    _local8 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local8 = Number(_local17[0]);
                    } else {
                        _local15 = _local17[0];
                        _local8 = _local17[1];
                    };
                };
                _local17 = parseConstraintExp(_local2.baseline);
                if (!_local17){
                    _local9 = NaN;
                } else {
                    if (_local17.length == 1){
                        _local9 = Number(_local17[0]);
                    } else {
                        _local16 = _local17[0];
                        _local9 = _local17[1];
                    };
                };
                break;
            };
            var _local19:ContentColumnChild = new ContentColumnChild();
            var _local20:Boolean;
            var _local21:Number = 0;
            var _local22:Number = 0;
            var _local23:Number = 0;
            _local18 = 0;
            while (_local18 < IConstraintLayout(target).constraintColumns.length) {
                _local30 = IConstraintLayout(target).constraintColumns[_local18];
                if (_local30.mx_internal::contentSize){
                    if (_local30.id == _local10){
                        _local19.leftCol = _local30;
                        _local19.leftOffset = _local3;
                        _local21 = _local18;
                        _local19.left = _local21;
                        _local20 = true;
                    };
                    if (_local30.id == _local11){
                        _local19.rightCol = _local30;
                        _local19.rightOffset = _local4;
                        _local22 = (_local18 + 1);
                        _local19.right = _local22;
                        _local20 = true;
                    };
                    if (_local30.id == _local12){
                        _local19.hcCol = _local30;
                        _local19.hcOffset = _local5;
                        _local23 = (_local18 + 1);
                        _local19.hc = _local23;
                        _local20 = true;
                    };
                };
                _local18++;
            };
            if (_local20){
                _local19.child = _arg1;
                if (((((((_local19.leftCol) && (!(_local19.rightCol)))) || (((_local19.rightCol) && (!(_local19.leftCol)))))) || (_local19.hcCol))){
                    _local19.span = 1;
                } else {
                    _local19.span = (_local22 - _local21);
                };
                _local31 = false;
                _local18 = 0;
                while (_local18 < colSpanChildren.length) {
                    if (_local19.child == colSpanChildren[_local18].child){
                        _local31 = true;
                        break;
                    };
                    _local18++;
                };
                if (!_local31){
                    colSpanChildren.push(_local19);
                };
            };
            _local20 = false;
            var _local24:ContentRowChild = new ContentRowChild();
            var _local25:Number = 0;
            var _local26:Number = 0;
            var _local27:Number = 0;
            var _local28:Number = 0;
            _local18 = 0;
            while (_local18 < IConstraintLayout(target).constraintRows.length) {
                _local32 = IConstraintLayout(target).constraintRows[_local18];
                if (_local32.mx_internal::contentSize){
                    if (_local32.id == _local13){
                        _local24.topRow = _local32;
                        _local24.topOffset = _local6;
                        _local25 = _local18;
                        _local24.top = _local25;
                        _local20 = true;
                    };
                    if (_local32.id == _local14){
                        _local24.bottomRow = _local32;
                        _local24.bottomOffset = _local7;
                        _local26 = (_local18 + 1);
                        _local24.bottom = _local26;
                        _local20 = true;
                    };
                    if (_local32.id == _local15){
                        _local24.vcRow = _local32;
                        _local24.vcOffset = _local8;
                        _local27 = (_local18 + 1);
                        _local24.vc = _local27;
                        _local20 = true;
                    };
                    if (_local32.id == _local16){
                        _local24.baselineRow = _local32;
                        _local24.baselineOffset = _local9;
                        _local28 = (_local18 + 1);
                        _local24.baseline = _local28;
                        _local20 = true;
                    };
                };
                _local18++;
            };
            if (_local20){
                _local24.child = _arg1;
                if (((((((((_local24.topRow) && (!(_local24.bottomRow)))) || (((_local24.bottomRow) && (!(_local24.topRow)))))) || (_local24.vcRow))) || (_local24.baselineRow))){
                    _local24.span = 1;
                } else {
                    _local24.span = (_local26 - _local25);
                };
                _local31 = false;
                _local18 = 0;
                while (_local18 < rowSpanChildren.length) {
                    if (_local24.child == rowSpanChildren[_local18].child){
                        _local31 = true;
                        break;
                    };
                    _local18++;
                };
                if (!_local31){
                    rowSpanChildren.push(_local24);
                };
            };
            var _local29:ChildConstraintInfo = new ChildConstraintInfo(_local3, _local4, _local5, _local6, _local7, _local8, _local9, _local10, _local11, _local12, _local13, _local14, _local15, _local16);
            constraintCache[_arg1] = _local29;
            return (_local29);
        }
        private function bound(_arg1:Number, _arg2:Number, _arg3:Number):Number{
            if (_arg1 < _arg2){
                _arg1 = _arg2;
            } else {
                if (_arg1 > _arg3){
                    _arg1 = _arg3;
                } else {
                    _arg1 = Math.floor(_arg1);
                };
            };
            return (_arg1);
        }
        private function shareRowSpace(_arg1:ContentRowChild, _arg2:Number):Number{
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local3:ConstraintRow = _arg1.topRow;
            var _local4:ConstraintRow = _arg1.bottomRow;
            var _local5:IUIComponent = _arg1.child;
            var _local6:Number = 0;
            var _local7:Number = 0;
            var _local8:Number = ((_arg1.topOffset) ? _arg1.topOffset : 0);
            var _local9:Number = ((_arg1.bottomOffset) ? _arg1.bottomOffset : 0);
            if (((_local3) && (_local3.height))){
                _local6 = (_local6 + _local3.height);
            } else {
                if (((_local4) && (!(_local3)))){
                    _local3 = IConstraintLayout(target).constraintRows[(_arg1.bottom - 2)];
                    if (((_local3) && (_local3.height))){
                        _local6 = (_local6 + _local3.height);
                    };
                };
            };
            if (((_local4) && (_local4.height))){
                _local7 = (_local7 + _local4.height);
            } else {
                if (((_local3) && (!(_local4)))){
                    _local4 = IConstraintLayout(target).constraintRows[(_arg1.top + 1)];
                    if (((_local4) && (_local4.height))){
                        _local7 = (_local7 + _local4.height);
                    };
                };
            };
            if (((_local3) && (isNaN(_local3.height)))){
                _local3.setActualHeight(Math.max(0, _local3.maxHeight));
            };
            if (((_local4) && (isNaN(_local4.height)))){
                _local4.setActualHeight(Math.max(0, _local4.height));
            };
            var _local10:Number = _local5.getExplicitOrMeasuredHeight();
            if (_local10){
                if (!_arg1.topRow){
                    if (_local10 > _local6){
                        _local12 = ((_local10 - _local6) + _local9);
                    } else {
                        _local12 = (_local10 + _local9);
                    };
                };
                if (!_arg1.bottomRow){
                    if (_local10 > _local7){
                        _local11 = ((_local10 - _local7) + _local8);
                    } else {
                        _local11 = (_local10 + _local8);
                    };
                };
                if (((_arg1.topRow) && (_arg1.bottomRow))){
                    _local13 = (_local10 / Number(_arg1.span));
                    if ((_local13 + _local8) < _local6){
                        _local11 = _local6;
                        _local12 = ((_local10 - (_local6 - _local8)) + _local9);
                    } else {
                        _local11 = (_local13 + _local8);
                    };
                    if ((_local13 + _local9) < _local7){
                        _local12 = _local7;
                        _local11 = ((_local10 - (_local7 - _local9)) + _local8);
                    } else {
                        _local12 = (_local13 + _local9);
                    };
                };
                _local12 = bound(_local12, _local4.minHeight, _local4.maxHeight);
                _local4.setActualHeight(_local12);
                _arg2 = (_arg2 - _local12);
                _local11 = bound(_local11, _local3.minHeight, _local3.maxHeight);
                _local3.setActualHeight(_local11);
                _arg2 = (_arg2 - _local11);
            };
            return (_arg2);
        }
        private function parseConstraintExp(_arg1:String):Array{
            if (!_arg1){
                return (null);
            };
            var _local2:String = _arg1.replace(/:/g, " ");
            var _local3:Array = _local2.split(/\s+/);
            return (_local3);
        }
        private function measureColumnsAndRows():void{
            var _local3:int;
            var _local4:int;
            var _local13:ConstraintColumn;
            var _local14:ConstraintRow;
            var _local15:Number;
            var _local16:Number;
            var _local17:Number;
            var _local18:Number;
            var _local19:ContentColumnChild;
            var _local20:ContentRowChild;
            var _local1:Array = IConstraintLayout(target).constraintColumns;
            var _local2:Array = IConstraintLayout(target).constraintRows;
            if ((((!(_local2.length) > 0)) && ((!(_local1.length) > 0)))){
                constraintRegionsInUse = false;
                return;
            };
            constraintRegionsInUse = true;
            var _local5:Number = 0;
            var _local6:Number = 0;
            var _local7:EdgeMetrics = Container(target).viewMetrics;
            var _local8:Number = ((Container(target).width - _local7.left) - _local7.right);
            var _local9:Number = ((Container(target).height - _local7.top) - _local7.bottom);
            var _local10:Array = [];
            var _local11:Array = [];
            var _local12:Array = [];
            if (_local1.length > 0){
                _local3 = 0;
                while (_local3 < _local1.length) {
                    _local13 = _local1[_local3];
                    if (!isNaN(_local13.percentWidth)){
                        _local11.push(_local13);
                    } else {
                        if (((!(isNaN(_local13.width))) && (!(_local13.mx_internal::contentSize)))){
                            _local10.push(_local13);
                        } else {
                            _local12.push(_local13);
                            _local13.mx_internal::contentSize = true;
                        };
                    };
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < _local10.length) {
                    _local13 = ConstraintColumn(_local10[_local3]);
                    _local8 = (_local8 - _local13.width);
                    _local3++;
                };
                if (_local12.length > 0){
                    if (colSpanChildren.length > 0){
                        colSpanChildren.sortOn("span");
                        _local4 = 0;
                        while (_local4 < colSpanChildren.length) {
                            _local19 = colSpanChildren[_local4];
                            if (_local19.span == 1){
                                if (_local19.hcCol){
                                    _local13 = ConstraintColumn(_local1[_local1.indexOf(_local19.hcCol)]);
                                } else {
                                    if (_local19.leftCol){
                                        _local13 = ConstraintColumn(_local1[_local1.indexOf(_local19.leftCol)]);
                                    } else {
                                        if (_local19.rightCol){
                                            _local13 = ConstraintColumn(_local1[_local1.indexOf(_local19.rightCol)]);
                                        };
                                    };
                                };
                                _local16 = _local19.child.getExplicitOrMeasuredWidth();
                                if (_local19.hcOffset){
                                    _local16 = (_local16 + _local19.hcOffset);
                                } else {
                                    if (_local19.leftOffset){
                                        _local16 = (_local16 + _local19.leftOffset);
                                    };
                                    if (_local19.rightOffset){
                                        _local16 = (_local16 + _local19.rightOffset);
                                    };
                                };
                                if (!isNaN(_local13.width)){
                                    _local16 = Math.max(_local13.width, _local16);
                                };
                                _local16 = bound(_local16, _local13.minWidth, _local13.maxWidth);
                                _local13.setActualWidth(_local16);
                                _local8 = (_local8 - _local13.width);
                            } else {
                                _local8 = shareColumnSpace(_local19, _local8);
                            };
                            _local4++;
                        };
                        colSpanChildren = [];
                    };
                    _local3 = 0;
                    while (_local3 < _local12.length) {
                        _local13 = _local12[_local3];
                        if (!_local13.width){
                            _local16 = bound(0, _local13.minWidth, 0);
                            _local13.setActualWidth(_local16);
                        };
                        _local3++;
                    };
                };
                _local18 = _local8;
                _local3 = 0;
                while (_local3 < _local11.length) {
                    _local13 = ConstraintColumn(_local11[_local3]);
                    if (_local18 <= 0){
                        _local16 = 0;
                    } else {
                        _local16 = Math.round(((_local18 * _local13.percentWidth) / 100));
                    };
                    _local16 = bound(_local16, _local13.minWidth, _local13.maxWidth);
                    _local13.setActualWidth(_local16);
                    _local8 = (_local8 - _local16);
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < _local1.length) {
                    _local13 = ConstraintColumn(_local1[_local3]);
                    _local13.x = _local5;
                    _local5 = (_local5 + _local13.width);
                    _local3++;
                };
            };
            _local10 = [];
            _local11 = [];
            _local12 = [];
            if (_local2.length > 0){
                _local3 = 0;
                while (_local3 < _local2.length) {
                    _local14 = _local2[_local3];
                    if (!isNaN(_local14.percentHeight)){
                        _local11.push(_local14);
                    } else {
                        if (((!(isNaN(_local14.height))) && (!(_local14.mx_internal::contentSize)))){
                            _local10.push(_local14);
                        } else {
                            _local12.push(_local14);
                            _local14.mx_internal::contentSize = true;
                        };
                    };
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < _local10.length) {
                    _local14 = ConstraintRow(_local10[_local3]);
                    _local9 = (_local9 - _local14.height);
                    _local3++;
                };
                if (_local12.length > 0){
                    if (rowSpanChildren.length > 0){
                        rowSpanChildren.sortOn("span");
                        _local4 = 0;
                        while (_local4 < rowSpanChildren.length) {
                            _local20 = rowSpanChildren[_local4];
                            if (_local20.span == 1){
                                if (_local20.vcRow){
                                    _local14 = ConstraintRow(_local2[_local2.indexOf(_local20.vcRow)]);
                                } else {
                                    if (_local20.baselineRow){
                                        _local14 = ConstraintRow(_local2[_local2.indexOf(_local20.baselineRow)]);
                                    } else {
                                        if (_local20.topRow){
                                            _local14 = ConstraintRow(_local2[_local2.indexOf(_local20.topRow)]);
                                        } else {
                                            if (_local20.bottomRow){
                                                _local14 = ConstraintRow(_local2[_local2.indexOf(_local20.bottomRow)]);
                                            };
                                        };
                                    };
                                };
                                _local17 = _local20.child.getExplicitOrMeasuredHeight();
                                if (_local20.baselineOffset){
                                    _local17 = (_local17 + _local20.baselineOffset);
                                } else {
                                    if (_local20.vcOffset){
                                        _local17 = (_local17 + _local20.vcOffset);
                                    } else {
                                        if (_local20.topOffset){
                                            _local17 = (_local17 + _local20.topOffset);
                                        };
                                        if (_local20.bottomOffset){
                                            _local17 = (_local17 + _local20.bottomOffset);
                                        };
                                    };
                                };
                                if (!isNaN(_local14.height)){
                                    _local17 = Math.max(_local14.height, _local17);
                                };
                                _local17 = bound(_local17, _local14.minHeight, _local14.maxHeight);
                                _local14.setActualHeight(_local17);
                                _local9 = (_local9 - _local14.height);
                            } else {
                                _local9 = shareRowSpace(_local20, _local9);
                            };
                            _local4++;
                        };
                        rowSpanChildren = [];
                    };
                    _local3 = 0;
                    while (_local3 < _local12.length) {
                        _local14 = ConstraintRow(_local12[_local3]);
                        if (!_local14.height){
                            _local17 = bound(0, _local14.minHeight, 0);
                            _local14.setActualHeight(_local17);
                        };
                        _local3++;
                    };
                };
                _local18 = _local9;
                _local3 = 0;
                while (_local3 < _local11.length) {
                    _local14 = ConstraintRow(_local11[_local3]);
                    if (_local18 <= 0){
                        _local17 = 0;
                    } else {
                        _local17 = Math.round(((_local18 * _local14.percentHeight) / 100));
                    };
                    _local17 = bound(_local17, _local14.minHeight, _local14.maxHeight);
                    _local14.setActualHeight(_local17);
                    _local9 = (_local9 - _local17);
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < _local2.length) {
                    _local14 = _local2[_local3];
                    _local14.y = _local6;
                    _local6 = (_local6 + _local14.height);
                    _local3++;
                };
            };
        }
        private function child_moveHandler(_arg1:MoveEvent):void{
            if ((_arg1.target is IUIComponent)){
                if (!IUIComponent(_arg1.target).includeInLayout){
                    return;
                };
            };
            var _local2:Container = super.target;
            if (_local2){
                _local2.invalidateSize();
                _local2.invalidateDisplayList();
                _contentArea = null;
            };
        }
        private function applyAnchorStylesDuringMeasure(_arg1:IUIComponent, _arg2:Rectangle):void{
            var _local13:int;
            var _local3:IConstraintClient = (_arg1 as IConstraintClient);
            if (!_local3){
                return;
            };
            var _local4:ChildConstraintInfo = constraintCache[_local3];
            if (!_local4){
                _local4 = parseConstraints(_arg1);
            };
            var _local5:Number = _local4.left;
            var _local6:Number = _local4.right;
            var _local7:Number = _local4.hc;
            var _local8:Number = _local4.top;
            var _local9:Number = _local4.bottom;
            var _local10:Number = _local4.vc;
            var _local11:Array = IConstraintLayout(target).constraintColumns;
            var _local12:Array = IConstraintLayout(target).constraintRows;
            var _local14:Number = 0;
            if (!(_local11.length) > 0){
                if (!isNaN(_local7)){
                    _arg2.x = Math.round((((target.width - _arg1.width) / 2) + _local7));
                } else {
                    if (((!(isNaN(_local5))) && (!(isNaN(_local6))))){
                        _arg2.x = _local5;
                        _arg2.width = (_arg2.width + _local6);
                    } else {
                        if (!isNaN(_local5)){
                            _arg2.x = _local5;
                        } else {
                            if (!isNaN(_local6)){
                                _arg2.x = 0;
                                _arg2.width = (_arg2.width + _local6);
                            };
                        };
                    };
                };
            } else {
                _arg2.x = 0;
                _local13 = 0;
                while (_local13 < _local11.length) {
                    _local14 = (_local14 + ConstraintColumn(_local11[_local13]).width);
                    _local13++;
                };
                _arg2.width = _local14;
            };
            if (!(_local12.length) > 0){
                if (!isNaN(_local10)){
                    _arg2.y = Math.round((((target.height - _arg1.height) / 2) + _local10));
                } else {
                    if (((!(isNaN(_local8))) && (!(isNaN(_local9))))){
                        _arg2.y = _local8;
                        _arg2.height = (_arg2.height + _local9);
                    } else {
                        if (!isNaN(_local8)){
                            _arg2.y = _local8;
                        } else {
                            if (!isNaN(_local9)){
                                _arg2.y = 0;
                                _arg2.height = (_arg2.height + _local9);
                            };
                        };
                    };
                };
            } else {
                _local14 = 0;
                _arg2.y = 0;
                _local13 = 0;
                while (_local13 < _local12.length) {
                    _local14 = (_local14 + ConstraintRow(_local12[_local13]).height);
                    _local13++;
                };
                _arg2.height = _local14;
            };
        }
        override public function measure():void{
            var _local1:Container;
            var _local5:EdgeMetrics;
            var _local6:Rectangle;
            var _local7:IUIComponent;
            var _local8:ConstraintColumn;
            var _local9:ConstraintRow;
            _local1 = super.target;
            var _local2:Number = 0;
            var _local3:Number = 0;
            var _local4:Number = 0;
            _local5 = _local1.viewMetrics;
            _local4 = 0;
            while (_local4 < _local1.numChildren) {
                _local7 = (_local1.getChildAt(_local4) as IUIComponent);
                parseConstraints(_local7);
                _local4++;
            };
            _local4 = 0;
            while (_local4 < IConstraintLayout(_local1).constraintColumns.length) {
                _local8 = IConstraintLayout(_local1).constraintColumns[_local4];
                if (_local8.mx_internal::contentSize){
                    _local8.mx_internal::_width = NaN;
                };
                _local4++;
            };
            _local4 = 0;
            while (_local4 < IConstraintLayout(_local1).constraintRows.length) {
                _local9 = IConstraintLayout(_local1).constraintRows[_local4];
                if (_local9.mx_internal::contentSize){
                    _local9.mx_internal::_height = NaN;
                };
                _local4++;
            };
            measureColumnsAndRows();
            _contentArea = null;
            _local6 = measureContentArea();
            _local1.measuredWidth = ((_local6.width + _local5.left) + _local5.right);
            _local1.measuredHeight = ((_local6.height + _local5.top) + _local5.bottom);
        }
        private function target_childRemoveHandler(_arg1:ChildExistenceChangedEvent):void{
            DisplayObject(_arg1.relatedObject).removeEventListener(MoveEvent.MOVE, child_moveHandler);
            delete constraintCache[_arg1.relatedObject];
        }
        override public function set target(_arg1:Container):void{
            var _local3:int;
            var _local4:int;
            var _local2:Container = super.target;
            if (_arg1 != _local2){
                if (_local2){
                    _local2.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, target_childAddHandler);
                    _local2.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, target_childRemoveHandler);
                    _local4 = _local2.numChildren;
                    _local3 = 0;
                    while (_local3 < _local4) {
                        DisplayObject(_local2.getChildAt(_local3)).removeEventListener(MoveEvent.MOVE, child_moveHandler);
                        _local3++;
                    };
                };
                if (_arg1){
                    _arg1.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, target_childAddHandler);
                    _arg1.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, target_childRemoveHandler);
                    _local4 = _arg1.numChildren;
                    _local3 = 0;
                    while (_local3 < _local4) {
                        DisplayObject(_arg1.getChildAt(_local3)).addEventListener(MoveEvent.MOVE, child_moveHandler);
                        _local3++;
                    };
                };
                super.target = _arg1;
            };
        }
        private function measureContentArea():Rectangle{
            var _local1:int;
            var _local3:Array;
            var _local4:Array;
            var _local5:IUIComponent;
            var _local6:LayoutConstraints;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            if (_contentArea){
                return (_contentArea);
            };
            _contentArea = new Rectangle();
            var _local2:int = target.numChildren;
            if ((((_local2 == 0)) && (constraintRegionsInUse))){
                _local3 = IConstraintLayout(target).constraintColumns;
                _local4 = IConstraintLayout(target).constraintRows;
                if (_local3.length > 0){
                    _contentArea.right = (_local3[(_local3.length - 1)].x + _local3[(_local3.length - 1)].width);
                } else {
                    _contentArea.right = 0;
                };
                if (_local4.length > 0){
                    _contentArea.bottom = (_local4[(_local4.length - 1)].y + _local4[(_local4.length - 1)].height);
                } else {
                    _contentArea.bottom = 0;
                };
            };
            _local1 = 0;
            while (_local1 < _local2) {
                _local5 = (target.getChildAt(_local1) as IUIComponent);
                _local6 = getLayoutConstraints(_local5);
                if (!_local5.includeInLayout){
                } else {
                    _local7 = _local5.x;
                    _local8 = _local5.y;
                    _local9 = _local5.getExplicitOrMeasuredWidth();
                    _local10 = _local5.getExplicitOrMeasuredHeight();
                    if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                        if (((!(isNaN(_local5.percentWidth))) || (((((_local6) && (!(isNaN(_local6.left))))) && (!(isNaN(_local6.right))))))){
                            _local9 = _local5.minWidth;
                        };
                    } else {
                        if (((!(isNaN(_local5.percentWidth))) || (((((((_local6) && (!(isNaN(_local6.left))))) && (!(isNaN(_local6.right))))) && (isNaN(_local5.explicitWidth)))))){
                            _local9 = _local5.minWidth;
                        };
                    };
                    if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0){
                        if (((!(isNaN(_local5.percentHeight))) || (((((_local6) && (!(isNaN(_local6.top))))) && (!(isNaN(_local6.bottom))))))){
                            _local10 = _local5.minHeight;
                        };
                    } else {
                        if (((!(isNaN(_local5.percentHeight))) || (((((((_local6) && (!(isNaN(_local6.top))))) && (!(isNaN(_local6.bottom))))) && (isNaN(_local5.explicitHeight)))))){
                            _local10 = _local5.minHeight;
                        };
                    };
                    r.x = _local7;
                    r.y = _local8;
                    r.width = _local9;
                    r.height = _local10;
                    applyAnchorStylesDuringMeasure(_local5, r);
                    _local7 = r.x;
                    _local8 = r.y;
                    _local9 = r.width;
                    _local10 = r.height;
                    if (isNaN(_local7)){
                        _local7 = _local5.x;
                    };
                    if (isNaN(_local8)){
                        _local8 = _local5.y;
                    };
                    _local11 = _local7;
                    _local12 = _local8;
                    if (isNaN(_local9)){
                        _local9 = _local5.width;
                    };
                    if (isNaN(_local10)){
                        _local10 = _local5.height;
                    };
                    _local11 = (_local11 + _local9);
                    _local12 = (_local12 + _local10);
                    _contentArea.right = Math.max(_contentArea.right, _local11);
                    _contentArea.bottom = Math.max(_contentArea.bottom, _local12);
                };
                _local1++;
            };
            return (_contentArea);
        }
        private function shareColumnSpace(_arg1:ContentColumnChild, _arg2:Number):Number{
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local3:ConstraintColumn = _arg1.leftCol;
            var _local4:ConstraintColumn = _arg1.rightCol;
            var _local5:IUIComponent = _arg1.child;
            var _local6:Number = 0;
            var _local7:Number = 0;
            var _local8:Number = ((_arg1.rightOffset) ? _arg1.rightOffset : 0);
            var _local9:Number = ((_arg1.leftOffset) ? _arg1.leftOffset : 0);
            if (((_local3) && (_local3.width))){
                _local6 = (_local6 + _local3.width);
            } else {
                if (((_local4) && (!(_local3)))){
                    _local3 = IConstraintLayout(target).constraintColumns[(_arg1.right - 2)];
                    if (((_local3) && (_local3.width))){
                        _local6 = (_local6 + _local3.width);
                    };
                };
            };
            if (((_local4) && (_local4.width))){
                _local7 = (_local7 + _local4.width);
            } else {
                if (((_local3) && (!(_local4)))){
                    _local4 = IConstraintLayout(target).constraintColumns[(_arg1.left + 1)];
                    if (((_local4) && (_local4.width))){
                        _local7 = (_local7 + _local4.width);
                    };
                };
            };
            if (((_local3) && (isNaN(_local3.width)))){
                _local3.setActualWidth(Math.max(0, _local3.maxWidth));
            };
            if (((_local4) && (isNaN(_local4.width)))){
                _local4.setActualWidth(Math.max(0, _local4.maxWidth));
            };
            var _local10:Number = _local5.getExplicitOrMeasuredWidth();
            if (_local10){
                if (!_arg1.leftCol){
                    if (_local10 > _local6){
                        _local12 = ((_local10 - _local6) + _local8);
                    } else {
                        _local12 = (_local10 + _local8);
                    };
                };
                if (!_arg1.rightCol){
                    if (_local10 > _local7){
                        _local11 = ((_local10 - _local7) + _local9);
                    } else {
                        _local11 = (_local10 + _local9);
                    };
                };
                if (((_arg1.leftCol) && (_arg1.rightCol))){
                    _local13 = (_local10 / Number(_arg1.span));
                    if ((_local13 + _local9) < _local6){
                        _local11 = _local6;
                        _local12 = ((_local10 - (_local6 - _local9)) + _local8);
                    } else {
                        _local11 = (_local13 + _local9);
                    };
                    if ((_local13 + _local8) < _local7){
                        _local12 = _local7;
                        _local11 = ((_local10 - (_local7 - _local8)) + _local9);
                    } else {
                        _local12 = (_local13 + _local8);
                    };
                };
                _local11 = bound(_local11, _local3.minWidth, _local3.maxWidth);
                _local3.setActualWidth(_local11);
                _arg2 = (_arg2 - _local11);
                _local12 = bound(_local12, _local4.minWidth, _local4.maxWidth);
                _local4.setActualWidth(_local12);
                _arg2 = (_arg2 - _local12);
            };
            return (_arg2);
        }
        private function getLayoutConstraints(_arg1:IUIComponent):LayoutConstraints{
            var _local2:IConstraintClient = (_arg1 as IConstraintClient);
            if (!_local2){
                return (null);
            };
            var _local3:LayoutConstraints = new LayoutConstraints();
            _local3.baseline = _local2.getConstraintValue("baseline");
            _local3.bottom = _local2.getConstraintValue("bottom");
            _local3.horizontalCenter = _local2.getConstraintValue("horizontalCenter");
            _local3.left = _local2.getConstraintValue("left");
            _local3.right = _local2.getConstraintValue("right");
            _local3.top = _local2.getConstraintValue("top");
            _local3.verticalCenter = _local2.getConstraintValue("verticalCenter");
            return (_local3);
        }
        override public function updateDisplayList(_arg1:Number, _arg2:Number):void{
            var _local3:int;
            var _local4:IUIComponent;
            var _local10:ConstraintColumn;
            var _local11:ConstraintRow;
            var _local5:Container = super.target;
            var _local6:int = _local5.numChildren;
            _local5.mx_internal::doingLayout = false;
            var _local7:EdgeMetrics = _local5.viewMetrics;
            _local5.mx_internal::doingLayout = true;
            var _local8:Number = ((_arg1 - _local7.left) - _local7.right);
            var _local9:Number = ((_arg2 - _local7.top) - _local7.bottom);
            if ((((IConstraintLayout(_local5).constraintColumns.length > 0)) || ((IConstraintLayout(_local5).constraintRows.length > 0)))){
                constraintRegionsInUse = true;
            };
            if (constraintRegionsInUse){
                _local3 = 0;
                while (_local3 < _local6) {
                    _local4 = (_local5.getChildAt(_local3) as IUIComponent);
                    parseConstraints(_local4);
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < IConstraintLayout(_local5).constraintColumns.length) {
                    _local10 = IConstraintLayout(_local5).constraintColumns[_local3];
                    if (_local10.mx_internal::contentSize){
                        _local10.mx_internal::_width = NaN;
                    };
                    _local3++;
                };
                _local3 = 0;
                while (_local3 < IConstraintLayout(_local5).constraintRows.length) {
                    _local11 = IConstraintLayout(_local5).constraintRows[_local3];
                    if (_local11.mx_internal::contentSize){
                        _local11.mx_internal::_height = NaN;
                    };
                    _local3++;
                };
                measureColumnsAndRows();
            };
            _local3 = 0;
            while (_local3 < _local6) {
                _local4 = (_local5.getChildAt(_local3) as IUIComponent);
                applyAnchorStylesDuringUpdateDisplayList(_local8, _local9, _local4);
                _local3++;
            };
        }
        private function applyAnchorStylesDuringUpdateDisplayList(_arg1:Number, _arg2:Number, _arg3:IUIComponent=null):void{
            var _local20:int;
            var _local21:Number;
            var _local22:Number;
            var _local23:Number;
            var _local24:Number;
            var _local25:String;
            var _local34:Number;
            var _local35:Number;
            var _local36:Number;
            var _local37:Number;
            var _local38:Number;
            var _local39:Boolean;
            var _local40:Boolean;
            var _local41:Boolean;
            var _local42:ConstraintColumn;
            var _local43:Boolean;
            var _local44:Boolean;
            var _local45:Boolean;
            var _local46:Boolean;
            var _local47:ConstraintRow;
            var _local4:IConstraintClient = (_arg3 as IConstraintClient);
            if (!_local4){
                return;
            };
            var _local5:ChildConstraintInfo = parseConstraints(_arg3);
            var _local6:Number = _local5.left;
            var _local7:Number = _local5.right;
            var _local8:Number = _local5.hc;
            var _local9:Number = _local5.top;
            var _local10:Number = _local5.bottom;
            var _local11:Number = _local5.vc;
            var _local12:Number = _local5.baseline;
            var _local13:String = _local5.leftBoundary;
            var _local14:String = _local5.rightBoundary;
            var _local15:String = _local5.hcBoundary;
            var _local16:String = _local5.topBoundary;
            var _local17:String = _local5.bottomBoundary;
            var _local18:String = _local5.vcBoundary;
            var _local19:String = _local5.baselineBoundary;
            var _local26:Boolean;
            var _local27:Boolean;
            var _local28:Boolean = ((((!(_local15)) && (!(_local13)))) && (!(_local14)));
            var _local29:Boolean = ((((((!(_local18)) && (!(_local16)))) && (!(_local17)))) && (!(_local19)));
            var _local30:Number = 0;
            var _local31:Number = _arg1;
            var _local32:Number = 0;
            var _local33:Number = _arg2;
            if (!_local28){
                _local39 = ((_local13) ? true : false);
                _local40 = ((_local14) ? true : false);
                _local41 = ((_local15) ? true : false);
                _local20 = 0;
                while (_local20 < IConstraintLayout(target).constraintColumns.length) {
                    _local42 = ConstraintColumn(IConstraintLayout(target).constraintColumns[_local20]);
                    if (_local39){
                        if (_local13 == _local42.id){
                            _local30 = _local42.x;
                            _local39 = false;
                        };
                    };
                    if (_local40){
                        if (_local14 == _local42.id){
                            _local31 = (_local42.x + _local42.width);
                            _local40 = false;
                        };
                    };
                    if (_local41){
                        if (_local15 == _local42.id){
                            _local35 = _local42.width;
                            _local37 = _local42.x;
                            _local41 = false;
                        };
                    };
                    _local20++;
                };
                if (_local39){
                    _local25 = resourceManager.getString("containers", "columnNotFound", [_local13]);
                    throw (new ConstraintError(_local25));
                };
                if (_local40){
                    _local25 = resourceManager.getString("containers", "columnNotFound", [_local14]);
                    throw (new ConstraintError(_local25));
                };
                if (_local41){
                    _local25 = resourceManager.getString("containers", "columnNotFound", [_local15]);
                    throw (new ConstraintError(_local25));
                };
            } else {
                if (!_local28){
                    _local25 = resourceManager.getString("containers", "noColumnsFound");
                    throw (new ConstraintError(_local25));
                };
            };
            _arg1 = Math.round((_local31 - _local30));
            if (((!(isNaN(_local6))) && (!(isNaN(_local7))))){
                _local21 = ((_arg1 - _local6) - _local7);
                if (_local21 < _arg3.minWidth){
                    _local21 = _arg3.minWidth;
                };
            } else {
                if (!isNaN(_arg3.percentWidth)){
                    _local21 = ((_arg3.percentWidth / 100) * _arg1);
                    _local21 = bound(_local21, _arg3.minWidth, _arg3.maxWidth);
                    _local26 = true;
                } else {
                    _local21 = _arg3.getExplicitOrMeasuredWidth();
                };
            };
            if (((!(_local29)) && ((IConstraintLayout(target).constraintRows.length > 0)))){
                _local43 = ((_local16) ? true : false);
                _local44 = ((_local17) ? true : false);
                _local45 = ((_local18) ? true : false);
                _local46 = ((_local19) ? true : false);
                _local20 = 0;
                while (_local20 < IConstraintLayout(target).constraintRows.length) {
                    _local47 = ConstraintRow(IConstraintLayout(target).constraintRows[_local20]);
                    if (_local43){
                        if (_local16 == _local47.id){
                            _local32 = _local47.y;
                            _local43 = false;
                        };
                    };
                    if (_local44){
                        if (_local17 == _local47.id){
                            _local33 = (_local47.y + _local47.height);
                            _local44 = false;
                        };
                    };
                    if (_local45){
                        if (_local18 == _local47.id){
                            _local34 = _local47.height;
                            _local36 = _local47.y;
                            _local45 = false;
                        };
                    };
                    if (_local46){
                        if (_local19 == _local47.id){
                            _local38 = _local47.y;
                            _local46 = false;
                        };
                    };
                    _local20++;
                };
                if (_local43){
                    _local25 = resourceManager.getString("containers", "rowNotFound", [_local16]);
                    throw (new ConstraintError(_local25));
                };
                if (_local44){
                    _local25 = resourceManager.getString("containers", "rowNotFound", [_local17]);
                    throw (new ConstraintError(_local25));
                };
                if (_local45){
                    _local25 = resourceManager.getString("containers", "rowNotFound", [_local18]);
                    throw (new ConstraintError(_local25));
                };
                if (_local46){
                    _local25 = resourceManager.getString("containers", "rowNotFound", [_local19]);
                    throw (new ConstraintError(_local25));
                };
            } else {
                if (((!(_local29)) && (!((IConstraintLayout(target).constraintRows.length > 0))))){
                    _local25 = resourceManager.getString("containers", "noRowsFound");
                    throw (new ConstraintError(_local25));
                };
            };
            _arg2 = Math.round((_local33 - _local32));
            if (((!(isNaN(_local9))) && (!(isNaN(_local10))))){
                _local22 = ((_arg2 - _local9) - _local10);
                if (_local22 < _arg3.minHeight){
                    _local22 = _arg3.minHeight;
                };
            } else {
                if (!isNaN(_arg3.percentHeight)){
                    _local22 = ((_arg3.percentHeight / 100) * _arg2);
                    _local22 = bound(_local22, _arg3.minHeight, _arg3.maxHeight);
                    _local27 = true;
                } else {
                    _local22 = _arg3.getExplicitOrMeasuredHeight();
                };
            };
            if (!isNaN(_local8)){
                if (_local15){
                    _local23 = Math.round(((((_local35 - _local21) / 2) + _local8) + _local37));
                } else {
                    _local23 = Math.round((((_arg1 - _local21) / 2) + _local8));
                };
            } else {
                if (!isNaN(_local6)){
                    if (_local13){
                        _local23 = (_local30 + _local6);
                    } else {
                        _local23 = _local6;
                    };
                } else {
                    if (!isNaN(_local7)){
                        if (_local14){
                            _local23 = ((_local31 - _local7) - _local21);
                        } else {
                            _local23 = ((_arg1 - _local7) - _local21);
                        };
                    };
                };
            };
            if (!isNaN(_local12)){
                if (_local19){
                    _local24 = ((_local38 - _arg3.baselinePosition) + _local12);
                } else {
                    _local24 = _local12;
                };
            };
            if (!isNaN(_local11)){
                if (_local18){
                    _local24 = Math.round(((((_local34 - _local22) / 2) + _local11) + _local36));
                } else {
                    _local24 = Math.round((((_arg2 - _local22) / 2) + _local11));
                };
            } else {
                if (!isNaN(_local9)){
                    if (_local16){
                        _local24 = (_local32 + _local9);
                    } else {
                        _local24 = _local9;
                    };
                } else {
                    if (!isNaN(_local10)){
                        if (_local17){
                            _local24 = ((_local33 - _local10) - _local22);
                        } else {
                            _local24 = ((_arg2 - _local10) - _local22);
                        };
                    };
                };
            };
            _local23 = ((isNaN(_local23)) ? _arg3.x : _local23);
            _local24 = ((isNaN(_local24)) ? _arg3.y : _local24);
            _arg3.move(_local23, _local24);
            if (_local26){
                if ((_local23 + _local21) > _arg1){
                    _local21 = Math.max((_arg1 - _local23), _arg3.minWidth);
                };
            };
            if (_local27){
                if ((_local24 + _local22) > _arg2){
                    _local22 = Math.max((_arg2 - _local24), _arg3.minHeight);
                };
            };
            if (((!(isNaN(_local21))) && (!(isNaN(_local22))))){
                _arg3.setActualSize(_local21, _local22);
            };
        }
        private function target_childAddHandler(_arg1:ChildExistenceChangedEvent):void{
            DisplayObject(_arg1.relatedObject).addEventListener(MoveEvent.MOVE, child_moveHandler);
        }

    }
}//package mx.containers.utilityClasses 

import mx.core.*;

class LayoutConstraints {

    public var baseline;
    public var left;
    public var bottom;
    public var top;
    public var horizontalCenter;
    public var verticalCenter;
    public var right;

    public function LayoutConstraints():void{
    }
}
class ChildConstraintInfo {

    public var baseline:Number;
    public var left:Number;
    public var baselineBoundary:String;
    public var leftBoundary:String;
    public var hcBoundary:String;
    public var top:Number;
    public var right:Number;
    public var topBoundary:String;
    public var rightBoundary:String;
    public var bottom:Number;
    public var vc:Number;
    public var bottomBoundary:String;
    public var vcBoundary:String;
    public var hc:Number;

    public function ChildConstraintInfo(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number, _arg7:Number, _arg8:String=null, _arg9:String=null, _arg10:String=null, _arg11:String=null, _arg12:String=null, _arg13:String=null, _arg14:String=null):void{
        this.left = _arg1;
        this.right = _arg2;
        this.hc = _arg3;
        this.top = _arg4;
        this.bottom = _arg5;
        this.vc = _arg6;
        this.baseline = _arg7;
        this.leftBoundary = _arg8;
        this.rightBoundary = _arg9;
        this.hcBoundary = _arg10;
        this.topBoundary = _arg11;
        this.bottomBoundary = _arg12;
        this.vcBoundary = _arg13;
        this.baselineBoundary = _arg14;
    }
}
class ContentColumnChild {

    public var rightCol:ConstraintColumn;
    public var hcCol:ConstraintColumn;
    public var left:Number;
    public var child:IUIComponent;
    public var rightOffset:Number;
    public var span:Number;
    public var hcOffset:Number;
    public var leftCol:ConstraintColumn;
    public var leftOffset:Number;
    public var hc:Number;
    public var right:Number;

    public function ContentColumnChild():void{
    }
}
class ContentRowChild {

    public var topRow:ConstraintRow;
    public var topOffset:Number;
    public var baseline:Number;
    public var baselineRow:ConstraintRow;
    public var span:Number;
    public var top:Number;
    public var vcOffset:Number;
    public var child:IUIComponent;
    public var bottomOffset:Number;
    public var bottom:Number;
    public var vc:Number;
    public var bottomRow:ConstraintRow;
    public var vcRow:ConstraintRow;
    public var baselineOffset:Number;

    public function ContentRowChild():void{
    }
}
