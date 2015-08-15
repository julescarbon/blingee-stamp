package mx.formatters {

    public class NumberFormatter extends Formatter {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var roundingOverride:String;
        private var thousandsSeparatorFromOverride:String;
        private var _useNegativeSign:Object;
        private var decimalSeparatorFromOverride:String;
        private var _decimalSeparatorTo:String;
        private var useThousandsSeparatorOverride:Object;
        private var _thousandsSeparatorTo:String;
        private var useNegativeSignOverride:Object;
        private var thousandsSeparatorToOverride:String;
        private var decimalSeparatorToOverride:String;
        private var precisionOverride:Object;
        private var _rounding:String;
        private var _useThousandsSeparator:Object;
        private var _thousandsSeparatorFrom:String;
        private var _decimalSeparatorFrom:String;
        private var _precision:Object;

        public function set precision(_arg1:Object):void{
            precisionOverride = _arg1;
            _precision = ((_arg1)!=null) ? int(_arg1) : resourceManager.getInt("formatters", "numberFormatterPrecision");
        }
        public function get useNegativeSign():Object{
            return (_useNegativeSign);
        }
        override protected function resourcesChanged():void{
            super.resourcesChanged();
            decimalSeparatorFrom = decimalSeparatorFromOverride;
            decimalSeparatorTo = decimalSeparatorToOverride;
            precision = precisionOverride;
            rounding = roundingOverride;
            thousandsSeparatorFrom = thousandsSeparatorFromOverride;
            thousandsSeparatorTo = thousandsSeparatorToOverride;
            useNegativeSign = useNegativeSignOverride;
            useThousandsSeparator = useThousandsSeparatorOverride;
        }
        public function get rounding():String{
            return (_rounding);
        }
        public function set thousandsSeparatorTo(_arg1:String):void{
            thousandsSeparatorToOverride = _arg1;
            _thousandsSeparatorTo = ((_arg1)!=null) ? _arg1 : resourceManager.getString("SharedResources", "thousandsSeparatorTo");
        }
        public function get thousandsSeparatorFrom():String{
            return (_thousandsSeparatorFrom);
        }
        public function set decimalSeparatorTo(_arg1:String):void{
            decimalSeparatorToOverride = _arg1;
            _decimalSeparatorTo = ((_arg1)!=null) ? _arg1 : resourceManager.getString("SharedResources", "decimalSeparatorTo");
        }
        public function set useNegativeSign(_arg1:Object):void{
            useNegativeSignOverride = _arg1;
            _useNegativeSign = ((_arg1)!=null) ? Boolean(_arg1) : resourceManager.getBoolean("formatters", "useNegativeSign");
        }
        override public function format(_arg1:Object):String{
            var _local8:String;
            var _local9:Number;
            if (error){
                error = null;
            };
            if (((useThousandsSeparator) && ((((decimalSeparatorFrom == thousandsSeparatorFrom)) || ((decimalSeparatorTo == thousandsSeparatorTo)))))){
                error = defaultInvalidFormatError;
                return ("");
            };
            if ((((decimalSeparatorTo == "")) || (!(isNaN(Number(decimalSeparatorTo)))))){
                error = defaultInvalidFormatError;
                return ("");
            };
            var _local2:NumberBase = new NumberBase(decimalSeparatorFrom, thousandsSeparatorFrom, decimalSeparatorTo, thousandsSeparatorTo);
            if ((_arg1 is String)){
                _arg1 = _local2.parseNumberString(String(_arg1));
            };
            if ((((_arg1 === null)) || (isNaN(Number(_arg1))))){
                error = defaultInvalidValueError;
                return ("");
            };
            var _local3 = (Number(_arg1) < 0);
            var _local4:String = _arg1.toString();
            var _local5:Array = _local4.split(".");
            var _local6:int = ((_local5[1]) ? String(_local5[1]).length : 0);
            if (precision <= _local6){
                if (rounding != NumberBaseRoundType.NONE){
                    _local4 = _local2.formatRoundingWithPrecision(_local4, rounding, int(precision));
                };
            };
            var _local7:Number = Number(_local4);
            if (Math.abs(_local7) >= 1){
                _local5 = _local4.split(".");
                _local8 = ((useThousandsSeparator) ? _local2.formatThousands(String(_local5[0])) : String(_local5[0]));
                if (((!((_local5[1] == null))) && (!((_local5[1] == ""))))){
                    _local4 = ((_local8 + decimalSeparatorTo) + _local5[1]);
                } else {
                    _local4 = _local8;
                };
            } else {
                if (Math.abs(_local7) > 0){
                    if (_local4.indexOf("e") != -1){
                        _local9 = (Math.abs(_local7) + 1);
                        _local4 = _local9.toString();
                    };
                    _local4 = (decimalSeparatorTo + _local4.substring((_local4.indexOf(".") + 1)));
                };
            };
            _local4 = _local2.formatPrecision(_local4, int(precision));
            if (Number(_local4) == 0){
                _local3 = false;
            };
            if (_local3){
                _local4 = _local2.formatNegative(_local4, useNegativeSign);
            };
            if (!_local2.isValid){
                error = defaultInvalidFormatError;
                return ("");
            };
            return (_local4);
        }
        public function get decimalSeparatorFrom():String{
            return (_decimalSeparatorFrom);
        }
        public function set rounding(_arg1:String):void{
            roundingOverride = _arg1;
            _rounding = ((_arg1)!=null) ? _arg1 : resourceManager.getString("formatters", "rounding");
        }
        public function get thousandsSeparatorTo():String{
            return (_thousandsSeparatorTo);
        }
        public function get decimalSeparatorTo():String{
            return (_decimalSeparatorTo);
        }
        public function set thousandsSeparatorFrom(_arg1:String):void{
            thousandsSeparatorFromOverride = _arg1;
            _thousandsSeparatorFrom = ((_arg1)!=null) ? _arg1 : resourceManager.getString("SharedResources", "thousandsSeparatorFrom");
        }
        public function set useThousandsSeparator(_arg1:Object):void{
            useThousandsSeparatorOverride = _arg1;
            _useThousandsSeparator = ((_arg1)!=null) ? Boolean(_arg1) : resourceManager.getBoolean("formatters", "useThousandsSeparator");
        }
        public function get useThousandsSeparator():Object{
            return (_useThousandsSeparator);
        }
        public function set decimalSeparatorFrom(_arg1:String):void{
            decimalSeparatorFromOverride = _arg1;
            _decimalSeparatorFrom = ((_arg1)!=null) ? _arg1 : resourceManager.getString("SharedResources", "decimalSeparatorFrom");
        }
        public function get precision():Object{
            return (_precision);
        }

    }
}//package mx.formatters 
