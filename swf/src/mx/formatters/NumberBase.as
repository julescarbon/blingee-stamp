package mx.formatters {

    public class NumberBase {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var thousandsSeparatorTo:String;
        public var decimalSeparatorTo:String;
        public var isValid:Boolean = false;
        public var thousandsSeparatorFrom:String;
        public var decimalSeparatorFrom:String;

        public function NumberBase(_arg1:String=".", _arg2:String=",", _arg3:String=".", _arg4:String=","){
            this.decimalSeparatorFrom = _arg1;
            this.thousandsSeparatorFrom = _arg2;
            this.decimalSeparatorTo = _arg3;
            this.thousandsSeparatorTo = _arg4;
            isValid = true;
        }
        public function formatThousands(_arg1:String):String{
            var _local7:int;
            var _local8:int;
            var _local9:int;
            var _local10:Array;
            var _local11:int;
            var _local2:Number = Number(_arg1);
            var _local3 = (_local2 < 0);
            var _local4:String = Math.abs(_local2).toString();
            var _local5:Array = Math.abs(_local2).toString().split(((_local4.indexOf(decimalSeparatorTo))!=-1) ? decimalSeparatorTo : ".");
            var _local6:int = String(_local5[0]).length;
            if (_local6 > 3){
                _local7 = int(Math.floor((_local6 / 3)));
                if ((_local6 % 3) == 0){
                    _local7--;
                };
                _local8 = _local6;
                _local9 = (_local8 - 3);
                _local10 = [];
                _local11 = 0;
                while (_local11 <= _local7) {
                    _local10[_local11] = _local5[0].slice(_local9, _local8);
                    _local9 = int(Math.max((_local9 - 3), 0));
                    _local8 = int(Math.max((_local8 - 3), 1));
                    _local11++;
                };
                _local10.reverse();
                _local5[0] = _local10.join(thousandsSeparatorTo);
            };
            _local4 = _local5.join(decimalSeparatorTo);
            if (_local3){
                _local4 = ("-" + _local4);
            };
            return (_local4.toString());
        }
        public function formatDecimal(_arg1:String):String{
            var _local2:Array = _arg1.split(".");
            return (_local2.join(decimalSeparatorTo));
        }
        public function parseNumberString(_arg1:String):String{
            var _local5:String;
            var _local6:String;
            var _local8:String;
            var _local9:int;
            var _local2:Array = _arg1.split(decimalSeparatorFrom);
            if (_local2.length > 2){
                return (null);
            };
            var _local3:int = _arg1.length;
            var _local4:int;
            var _local7:Boolean;
            while (_local4 < _local3) {
                _local5 = _arg1.charAt(_local4);
                _local4++;
                if (((((("0" <= _local5)) && ((_local5 <= "9")))) || ((_local5 == decimalSeparatorFrom)))){
                    _local8 = _arg1.charAt((_local4 - 2));
                    if (_local8 == "-"){
                        _local7 = true;
                    };
                    _local6 = "";
                    --_local4;
                    _local9 = _local4;
                    while (_local9 < _local3) {
                        _local5 = _arg1.charAt(_local4);
                        _local4++;
                        if (((("0" <= _local5)) && ((_local5 <= "9")))){
                            _local6 = (_local6 + _local5);
                        } else {
                            if (_local5 == decimalSeparatorFrom){
                                _local6 = (_local6 + ".");
                            } else {
                                if (((!((_local5 == thousandsSeparatorFrom))) || ((_local4 >= _local3)))){
                                    break;
                                };
                            };
                        };
                        _local9++;
                    };
                };
            };
            return (((_local7) ? ("-" + _local6) : _local6));
        }
        public function formatPrecision(_arg1:String, _arg2:int):String{
            var _local4:String;
            var _local5:String;
            if (_arg2 == -1){
                return (_arg1);
            };
            var _local3:Array = _arg1.split(decimalSeparatorTo);
            _local3[0] = (((_local3[0].length == 0)) ? "0" : _local3[0]);
            if (_arg2 > 0){
                _local4 = ((_local3[1]) ? String(_local3[1]) : "");
                _local5 = (_local4 + "000000000000000000000000000000000");
                _arg1 = ((_local3[0] + decimalSeparatorTo) + _local5.substr(0, _arg2));
            } else {
                _arg1 = String(_local3[0]);
            };
            return (_arg1.toString());
        }
        public function formatRounding(_arg1:String, _arg2:String):String{
            var _local3:Number = Number(_arg1);
            if (_arg2 != NumberBaseRoundType.NONE){
                if (_arg2 == NumberBaseRoundType.UP){
                    _local3 = Math.ceil(_local3);
                } else {
                    if (_arg2 == NumberBaseRoundType.DOWN){
                        _local3 = Math.floor(_local3);
                    } else {
                        if (_arg2 == NumberBaseRoundType.NEAREST){
                            _local3 = Math.round(_local3);
                        } else {
                            isValid = false;
                            return ("");
                        };
                    };
                };
            };
            return (_local3.toString());
        }
        public function formatNegative(_arg1:String, _arg2:Boolean):String{
            if (_arg2){
                if (_arg1.charAt(0) != "-"){
                    _arg1 = ("-" + _arg1);
                };
            } else {
                if (!_arg2){
                    if (_arg1.charAt(0) == "-"){
                        _arg1 = _arg1.substr(1, (_arg1.length - 1));
                    };
                    _arg1 = (("(" + _arg1) + ")");
                } else {
                    isValid = false;
                    return ("");
                };
            };
            return (_arg1);
        }
        public function formatRoundingWithPrecision(_arg1:String, _arg2:String, _arg3:int):String{
            var _local4:Number = Number(_arg1);
            if (_arg2 == NumberBaseRoundType.NONE){
                if (_arg3 == -1){
                    return (_local4.toString());
                };
            } else {
                if (_arg3 < 0){
                    _arg3 = 0;
                };
                _local4 = (_local4 * Math.pow(10, _arg3));
                _local4 = Number(_local4.toString());
                if (_arg2 == NumberBaseRoundType.UP){
                    _local4 = Math.ceil(_local4);
                } else {
                    if (_arg2 == NumberBaseRoundType.DOWN){
                        _local4 = Math.floor(_local4);
                    } else {
                        if (_arg2 == NumberBaseRoundType.NEAREST){
                            _local4 = Math.round(_local4);
                        } else {
                            isValid = false;
                            return ("");
                        };
                    };
                };
                _local4 = (_local4 / Math.pow(10, _arg3));
            };
            return (_local4.toString());
        }

    }
}//package mx.formatters 
