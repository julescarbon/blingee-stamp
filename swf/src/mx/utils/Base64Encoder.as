package mx.utils {
    import flash.utils.*;

    public class Base64Encoder {

        public static const MAX_BUFFER_SIZE:uint = 32767;
        private static const ALPHABET_CHAR_CODES:Array = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47];
        public static const CHARSET_UTF_8:String = "UTF-8";
        private static const ESCAPE_CHAR_CODE:Number = 61;

        public static var newLine:int = 10;

        private var _line:uint;
        private var _count:uint;
        private var _buffers:Array;
        public var insertNewLines:Boolean = true;
        private var _work:Array;

        public function Base64Encoder(){
            _work = [0, 0, 0];
            super();
            reset();
        }
        public function flush():String{
            if (_count > 0){
                encodeBlock();
            };
            var _local1:String = drain();
            reset();
            return (_local1);
        }
        public function toString():String{
            return (flush());
        }
        public function reset():void{
            _buffers = [];
            _buffers.push([]);
            _count = 0;
            _line = 0;
            _work[0] = 0;
            _work[1] = 0;
            _work[2] = 0;
        }
        public function encodeBytes(_arg1:ByteArray, _arg2:uint=0, _arg3:uint=0):void{
            if (_arg3 == 0){
                _arg3 = _arg1.length;
            };
            var _local4:uint = _arg1.position;
            _arg1.position = _arg2;
            var _local5:uint = _arg2;
            while (_local5 < _arg3) {
                _work[_count] = _arg1[_local5];
                _count++;
                if ((((_count == _work.length)) || ((((_arg2 + _arg3) - _local5) == 1)))){
                    encodeBlock();
                    _count = 0;
                    _work[0] = 0;
                    _work[1] = 0;
                    _work[2] = 0;
                };
                _local5++;
            };
            _arg1.position = _local4;
        }
        public function encode(_arg1:String, _arg2:uint=0, _arg3:uint=0):void{
            if (_arg3 == 0){
                _arg3 = _arg1.length;
            };
            var _local4:uint = _arg2;
            while (_local4 < (_arg2 + _arg3)) {
                _work[_count] = _arg1.charCodeAt(_local4);
                _count++;
                if ((((_count == _work.length)) || ((((_arg2 + _arg3) - _local4) == 1)))){
                    encodeBlock();
                    _count = 0;
                    _work[0] = 0;
                    _work[1] = 0;
                    _work[2] = 0;
                };
                _local4++;
            };
        }
        private function encodeBlock():void{
            var _local1:Array = (_buffers[(_buffers.length - 1)] as Array);
            if (_local1.length >= MAX_BUFFER_SIZE){
                _local1 = [];
                _buffers.push(_local1);
            };
            _local1.push(ALPHABET_CHAR_CODES[((_work[0] & 0xFF) >> 2)]);
            _local1.push(ALPHABET_CHAR_CODES[(((_work[0] & 3) << 4) | ((_work[1] & 240) >> 4))]);
            if (_count > 1){
                _local1.push(ALPHABET_CHAR_CODES[(((_work[1] & 15) << 2) | ((_work[2] & 192) >> 6))]);
            } else {
                _local1.push(ESCAPE_CHAR_CODE);
            };
            if (_count > 2){
                _local1.push(ALPHABET_CHAR_CODES[(_work[2] & 63)]);
            } else {
                _local1.push(ESCAPE_CHAR_CODE);
            };
            if (insertNewLines){
                if ((_line = (_line + 4)) == 76){
                    _local1.push(newLine);
                    _line = 0;
                };
            };
        }
        public function encodeUTFBytes(_arg1:String):void{
            var _local2:ByteArray = new ByteArray();
            _local2.writeUTFBytes(_arg1);
            _local2.position = 0;
            encodeBytes(_local2);
        }
        public function drain():String{
            var _local3:Array;
            var _local1 = "";
            var _local2:uint;
            while (_local2 < _buffers.length) {
                _local3 = (_buffers[_local2] as Array);
                _local1 = (_local1 + String.fromCharCode.apply(null, _local3));
                _local2++;
            };
            _buffers = [];
            _buffers.push([]);
            return (_local1);
        }

    }
}//package mx.utils 
