/* couldn't get the crypto library to work, haha,
   so this is ported directly from the actionscript library
   */

/*private_static*/ var base64chars/*String*/ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

var keySize/*Number*/ = 128;
/*private*/ var Nb/*Number*/;
/*private*/ var SBoxInverse/*Array*/;
/*private*/ var Nk/*Number*/;
/*private*/ var shiftOffsets/*Array*/;
/*private*/ var Nr/*Number*/;
var blockSize/*Number*/ = 128;
/*private*/ var roundsArray/*Array*/;
/*private*/ var Rcon/*Array*/;
/*private*/ var SBox/*Array*/;

var AESBase64 = module.exports = function (_arg1/*Number*/, _arg2/*Number*/){
    Rcon = [1, 2, 4, 8, 16, 32, 64, 128, 27, 54, 108, 216, 171, 77, 154, 47, 94, 188, 99, 198, 151, 53, 106, 212, 179, 125, 250, 239, 197, 145];
    SBox = [99, 124, 119, 123, 242, 107, 111, 197, 48, 1, 103, 43, 254, 215, 171, 118, 202, 130, 201, 125, 250, 89, 71, 240, 173, 212, 162, 175, 156, 164, 114, 192, 183, 253, 147, 38, 54, 63, 247, 204, 52, 165, 229, 241, 113, 216, 49, 21, 4, 199, 35, 195, 24, 150, 5, 154, 7, 18, 128, 226, 235, 39, 178, 117, 9, 131, 44, 26, 27, 110, 90, 160, 82, 59, 214, 179, 41, 227, 47, 132, 83, 209, 0, 237, 32, 252, 177, 91, 106, 203, 190, 57, 74, 76, 88, 207, 208, 239, 170, 251, 67, 77, 51, 133, 69, 249, 2, 127, 80, 60, 159, 168, 81, 163, 64, 143, 146, 157, 56, 245, 188, 182, 218, 33, 16, 0xFF, 243, 210, 205, 12, 19, 236, 95, 151, 68, 23, 196, 167, 126, 61, 100, 93, 25, 115, 96, 129, 79, 220, 34, 42, 144, 136, 70, 238, 184, 20, 222, 94, 11, 219, 224, 50, 58, 10, 73, 6, 36, 92, 194, 211, 172, 98, 145, 149, 228, 121, 231, 200, 55, 109, 141, 213, 78, 169, 108, 86, 244, 234, 101, 122, 174, 8, 186, 120, 37, 46, 28, 166, 180, 198, 232, 221, 116, 31, 75, 189, 139, 138, 112, 62, 181, 102, 72, 3, 246, 14, 97, 53, 87, 185, 134, 193, 29, 158, 225, 248, 152, 17, 105, 217, 142, 148, 155, 30, 135, 233, 206, 85, 40, 223, 140, 161, 137, 13, 191, 230, 66, 104, 65, 153, 45, 15, 176, 84, 187, 22];
    SBoxInverse = [82, 9, 106, 213, 48, 54, 165, 56, 191, 64, 163, 158, 129, 243, 215, 251, 124, 227, 57, 130, 155, 47, 0xFF, 135, 52, 142, 67, 68, 196, 222, 233, 203, 84, 123, 148, 50, 166, 194, 35, 61, 238, 76, 149, 11, 66, 250, 195, 78, 8, 46, 161, 102, 40, 217, 36, 178, 118, 91, 162, 73, 109, 139, 209, 37, 114, 248, 246, 100, 134, 104, 152, 22, 212, 164, 92, 204, 93, 101, 182, 146, 108, 112, 72, 80, 253, 237, 185, 218, 94, 21, 70, 87, 167, 141, 157, 132, 144, 216, 171, 0, 140, 188, 211, 10, 247, 228, 88, 5, 184, 179, 69, 6, 208, 44, 30, 143, 202, 63, 15, 2, 193, 175, 189, 3, 1, 19, 138, 107, 58, 145, 17, 65, 79, 103, 220, 234, 151, 242, 207, 206, 240, 180, 230, 115, 150, 172, 116, 34, 231, 173, 53, 133, 226, 249, 55, 232, 28, 117, 223, 110, 71, 241, 26, 113, 29, 41, 197, 137, 111, 183, 98, 14, 170, 24, 190, 27, 252, 86, 62, 75, 198, 210, 121, 32, 154, 219, 192, 254, 120, 205, 90, 244, 31, 221, 168, 51, 136, 7, 199, 49, 177, 18, 16, 89, 39, 128, 236, 95, 96, 81, 127, 169, 25, 181, 74, 13, 45, 229, 122, 159, 147, 201, 156, 239, 160, 224, 59, 77, 174, 42, 245, 176, 200, 235, 187, 60, 131, 83, 153, 97, 23, 43, 4, 126, 186, 119, 214, 38, 225, 105, 20, 99, 85, 33, 12, 125];
    keySize = _arg1;
    blockSize = _arg2;
    roundsArray = [0, 0, 0, 0, [0, 0, 0, 0, 10, 0, 12, 0, 14], 0, [0, 0, 0, 0, 12, 0, 12, 0, 14], 0, [0, 0, 0, 0, 14, 0, 14, 0, 14]];
    shiftOffsets = [0, 0, 0, 0, [0, 1, 2, 3], 0, [0, 1, 2, 3], 0, [0, 1, 3, 4]];
    Nb = (_arg2 / 32);
    Nk = (_arg1 / 32);
    Nr = roundsArray[Nk][Nb];
}
function strToChars(_arg1/*String*/)/*Array*/{
    var _local2/*Array*/ = new Array();
    var _local3/*Number*/ = 0;
    while (_local3 < _arg1.length) {
        _local2.push(_arg1.charCodeAt(_local3));
        _local3++;
    };
    return (_local2);
}
function encodeBase64(_arg1/*Array*/)/*String*/{
    var _local4/*Number*/;
    var _local5/*Number*/;
    var _local6/*Number*/;
    var _local7/*Number*/;
    var _local8/*Number*/;
    var _local9/*Number*/;
    var _local10/*Number*/;
    var _local2/*Number*/ = 0;
    var _local3/*String*/ = new String("");
    while (_local2 < _arg1.length) {
        var _temp1 = _local2;
        _local2 = (_local2 + 1);
        _local4 = _arg1[_temp1];
        var _temp2 = _local2;
        _local2 = (_local2 + 1);
        _local5 = _arg1[_temp2];
        var _temp3 = _local2;
        _local2 = (_local2 + 1);
        _local6 = _arg1[_temp3];
        _local7 = (_local4 >> 2);
        _local8 = (((_local4 & 3) << 4) | (_local5 >> 4));
        _local9 = (((_local5 & 15) << 2) | (_local6 >> 6));
        _local10 = (_local6 & 63);
        if (isNaN(_local5)){
            _local10 = 64;
            _local9 = _local10;
        } else {
            if (isNaN(_local6)){
                _local10 = 64;
            };
        };
        _local3 = (_local3 + (base64chars.charAt(_local7) + base64chars.charAt(_local8)));
        _local3 = (_local3 + (base64chars.charAt(_local9) + base64chars.charAt(_local10)));
    };
    return (_local3);
}
function utf8Encode(_arg1/*String*/)/*Array*/{
    var _local6/*Number*/;
    var _local2 = "";
    var _local3/*Number*/ = 0;
    while (_local3 < _arg1.length) {
        _local6 = _arg1.charCodeAt(_local3);
        if (_local6 < 128){
            _local2 = (_local2 + String.fromCharCode(_local6));
        } else {
            if ((((_local6 > 127)) && ((_local6 < 0x0800)))){
                _local2 = (_local2 + String.fromCharCode(((_local6 >> 6) | 192)));
                _local2 = (_local2 + String.fromCharCode(((_local6 & 63) | 128)));
            } else {
                _local2 = (_local2 + String.fromCharCode(((_local6 >> 12) | 224)));
                _local2 = (_local2 + String.fromCharCode((((_local6 >> 6) & 63) | 128)));
                _local2 = (_local2 + String.fromCharCode(((_local6 & 63) | 128)));
            };
        };
        _local3++;
    };
    var _local4/*Array*/ = new Array();
    var _local5/*Number*/ = 0;
    while (_local5 < _local2.length) {
        _local4.push(_local2.charCodeAt(_local5));
        _local5++;
    };
    return (_local4);
}
function charsToStr(_arg1/*Array*/)/*String*/{
    return (utf8Decode(_arg1));
}
function decodeBase64(_arg1/*String*/)/*Array*/{
    var _local4/*Number*/;
    var _local5/*Number*/;
    var _local6/*Number*/;
    var _local7/*Number*/;
    var _local8/*Number*/;
    var _local9/*Number*/;
    var _local10/*Number*/;
    var _local2/*Number*/ = 0;
    var _local3/*Array*/ = new Array();
    while (_local2 < _arg1.length) {
        var _temp1 = _local2;
        _local2 = (_local2 + 1);
        _local7 = base64chars.indexOf(_arg1.charAt(_temp1));
        var _temp2 = _local2;
        _local2 = (_local2 + 1);
        _local8 = base64chars.indexOf(_arg1.charAt(_temp2));
        var _temp3 = _local2;
        _local2 = (_local2 + 1);
        _local9 = base64chars.indexOf(_arg1.charAt(_temp3));
        var _temp4 = _local2;
        _local2 = (_local2 + 1);
        _local10 = base64chars.indexOf(_arg1.charAt(_temp4));
        _local4 = ((_local7 << 2) | (_local8 >> 4));
        _local5 = (((_local8 & 15) << 4) | (_local9 >> 2));
        _local6 = (((_local9 & 3) << 6) | _local10);
        _local3.push(_local4);
        if (_local9 != 64){
            _local3.push(_local5);
        };
        if (_local10 != 64){
            _local3.push(_local6);
        };
    };
    return (_local3);
}
function utf8Decode(_arg1/*Array*/)/*String*/{
    var _local2 = "";
    var _local3/*Number*/ = 0;
    var _local4/*Number*/ = 0;
    var _local5/*Number*/ = 0;
    var _local6/*Number*/ = 0;
    while (_local3 < _arg1.length) {
        _local4 = _arg1[_local3];
        if (_local4 < 128){
            _local2 = (_local2 + String.fromCharCode(_local4));
            _local3++;
        } else {
            if ((((_local4 > 191)) && ((_local4 < 224)))){
                _local5 = _arg1[(_local3 + 1)];
                _local2 = (_local2 + String.fromCharCode((((_local4 & 31) << 6) | (_local5 & 63))));
                _local3 = (_local3 + 2);
            } else {
                _local5 = _arg1[(_local3 + 1)];
                _local6 = _arg1[(_local3 + 2)];
                _local2 = (_local2 + String.fromCharCode(((((_local4 & 15) << 12) | ((_local5 & 63) << 6)) | (_local6 & 63))));
                _local3 = (_local3 + 3);
            };
        };
    };
    return (_local2);
}

var padBuffer = function padBuffer(_arg1/*Array*/)/*void*/{
    var _local2/*Number*/ = (blockSize / 8);
    var _local3/*Number*/ = (_local2 - (_arg1.length % _local2));
    var _local4/*Number*/ = 0;
    while (_local4 < _local3) {
        _arg1[_arg1.length] = _local3;
        _local4++;
    };
}
var encryption = function encryption(_arg1/*Array*/, _arg2/*Array*/)/*Array*/{
    _arg1 = packBytes(_arg1);
    addRoundKey(_arg1, _arg2);
    var _local3/*Number*/ = 1;
    while (_local3 < Nr) {
        Round(_arg1, _arg2.slice((Nb * _local3), (Nb * (_local3 + 1))));
        _local3++;
    };
    FinalRound(_arg1, _arg2.slice((Nb * Nr)));
    return (unpackBytes(_arg1));
}
var xtime = function xtime(_arg1/*Number*/)/*Number*/{
    _arg1 = (_arg1 << 1);
    return ((((_arg1 & 0x0100)) ? (_arg1 ^ 283) : _arg1));
}
var charsToHex = function charsToHex(_arg1/*Array*/)/*String*/{
    var _local2/*String*/ = new String("");
    var _local3/*Array*/ = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f");
    var _local4/*Number*/ = 0;
    while (_local4 < _arg1.length) {
        _local2 = (_local2 + (_local3[(_arg1[_local4] >> 4)] + _local3[(_arg1[_local4] & 15)]));
        _local4++;
    };
    return (_local2);
}
var InverseFinalRound = function InverseFinalRound(_arg1/*Array*/, _arg2/*Array*/)/*void*/{
    addRoundKey(_arg1, _arg2);
    shiftRow(_arg1, "decrypt");
    byteSub(_arg1, "decrypt");
}
var mult_GF256 = function mult_GF256(_arg1/*Number*/, _arg2/*Number*/)/*Number*/{
    var _local3/*Number*/ = 0;
    var _local4/*Number*/ = 1;
    while (_local4 < 0x0100) {
        if ((_arg1 & _local4)){
            _local3 = (_local3 ^ _arg2);
        };
        _local4 = (_local4 * 2);
        _arg2 = xtime(_arg2);
    };
    return (_local3);
}
var decrypt = module.exports.prototype.decrypt = function decrypt(_arg1/*String*/, _arg2/*String*/, _arg3/*String*/)/*String*/{
    var _local10/*Number*/;
    var _local4/*Array*/ = new Array();
    var _local5/*Array*/ = new Array();
    var _local6/*Array*/ = decodeBase64(_arg1);
    var _local7/*Number*/ = (blockSize / 8);
    var _local8/*Array*/ = keyExpansion(strToChars(_arg2));
    var _local9/*Number*/ = 0;
    while (_local9 < _local6.length) {
        if ((((_local9 == 0)) && ((_arg3 == "CBC")))){
            break;
        };
        _local5 = _local6.slice(_local9, Math.min((_local9 + _local7), _local6.length));
        if (_local5.length < _local7){
            break;
        };
        _local5 = decryption(_local5, _local8);
        if (_arg3 == "CBC"){
            _local10 = 0;
            while (_local10 < _local7) {
                _local5[_local10] = (_local5[_local10] ^ _local6[((_local9 - _local7) + _local10)]);
                _local10++;
            };
        } else {
            _local4 = _local4.concat(_local5);
        };
        _local9 = (_local9 + _local7);
    };
    if ((_local6.length % _local7) == 0){
        removePad(_local4);
    };
    return (charsToStr(_local4));
}
var hexToChars = function hexToChars(_arg1/*String*/)/*Array*/{
    var _local2/*Array*/ = new Array();
    var _local3/*Number*/ = ((_arg1.substr(0, 2))=="0x") ? 2 : 0;
    while (_local3 < _arg1.length) {
        _local2.push(parseInt(_arg1.substr(_local3, 2), 16));
        _local3 = (_local3 + 2);
    };
    return (_local2);
}
var shiftRow = function shiftRow(_arg1/*Array*/, _arg2/*String*/)/*void*/{
    var _local3/*Number*/ = 1;
    while (_local3 < 4) {
        if (_arg2 == "encrypt"){
            _arg1[_local3] = cyclicShiftLeft(_arg1[_local3], shiftOffsets[Nb][_local3]);
        } else {
            _arg1[_local3] = cyclicShiftLeft(_arg1[_local3], (Nb - shiftOffsets[Nb][_local3]));
        };
        _local3++;
    };
}
var FinalRound = function FinalRound(_arg1/*Array*/, _arg2/*Array*/)/*void*/{
    byteSub(_arg1, "encrypt");
    shiftRow(_arg1, "encrypt");
    addRoundKey(_arg1, _arg2);
}
var mixColumn = function mixColumn(_arg1/*Array*/, _arg2/*String*/)/*void*/{
    var _local5/*Number*/;
    var _local3/*Array*/ = new Array();
    var _local4/*Number*/ = 0;
    while (_local4 < Nb) {
        _local5 = 0;
        while (_local5 < 4) {
            if (_arg2 == "encrypt"){
                _local3[_local5] = (((mult_GF256(_arg1[_local5][_local4], 2) ^ mult_GF256(_arg1[((_local5 + 1) % 4)][_local4], 3)) ^ _arg1[((_local5 + 2) % 4)][_local4]) ^ _arg1[((_local5 + 3) % 4)][_local4]);
            } else {
                _local3[_local5] = (((mult_GF256(_arg1[_local5][_local4], 14) ^ mult_GF256(_arg1[((_local5 + 1) % 4)][_local4], 11)) ^ mult_GF256(_arg1[((_local5 + 2) % 4)][_local4], 13)) ^ mult_GF256(_arg1[((_local5 + 3) % 4)][_local4], 9));
            };
            _local5++;
        };
        _local5 = 0;
        while (_local5 < 4) {
            _arg1[_local5][_local4] = _local3[_local5];
            _local5++;
        };
        _local4++;
    };
}
var decryption = function decryption(_arg1/*Array*/, _arg2/*Array*/)/*Array*/{
    _arg1 = packBytes(_arg1);
    InverseFinalRound(_arg1, _arg2.slice((Nb * Nr)));
    var _local3/*Number*/ = (Nr - 1);
    while (_local3 > 0) {
        InverseRound(_arg1, _arg2.slice((Nb * _local3), (Nb * (_local3 + 1))));
        _local3--;
    };
    addRoundKey(_arg1, _arg2);
    return (unpackBytes(_arg1));
}
var byteSub = function byteSub(_arg1/*Array*/, _arg2/*String*/)/*void*/{
    var _local4/*Array*/;
    var _local5/*Number*/;
    if (_arg2 == "encrypt"){
        _local4 = SBox;
    } else {
        _local4 = SBoxInverse;
    };
    var _local3/*Number*/ = 0;
    while (_local3 < 4) {
        _local5 = 0;
        while (_local5 < Nb) {
            _arg1[_local3][_local5] = _local4[_arg1[_local3][_local5]];
            _local5++;
        };
        _local3++;
    };
}
var packBytes = function packBytes(_arg1/*Array*/)/*Array*/{
    var _local2/*Array*/ = new Array();
    _local2[0] = new Array();
    _local2[1] = new Array();
    _local2[2] = new Array();
    _local2[3] = new Array();
    var _local3/*Number*/ = 0;
    while (_local3 < _arg1.length) {
        _local2[0][(_local3 / 4)] = _arg1[_local3];
        _local2[1][(_local3 / 4)] = _arg1[(_local3 + 1)];
        _local2[2][(_local3 / 4)] = _arg1[(_local3 + 2)];
        _local2[3][(_local3 / 4)] = _arg1[(_local3 + 3)];
        _local3 = (_local3 + 4);
    };
    return (_local2);
}
var encrypt = module.exports.prototype.encrypt = function encrypt(_arg1/*String*/, _arg2/*String*/, _arg3/*String*/)/*String*/{
    var _local10/*Number*/;
    var _local4/*Array*/ = new Array();
    var _local5/*Array*/ = new Array();
    var _local6/*Number*/ = (blockSize / 8);
    if (_arg3 == "CBC"){
        _local4 = getRandomBytes(_local6);
    };
    var _local7/*Array*/ = strToChars(_arg1);
    var _local8/*Array*/ = keyExpansion(strToChars(_arg2));
    var _local9/*Number*/ = 0;
    while (_local9 < _local7.length) {
        _local5 = _local7.slice(_local9, Math.min((_local9 + _local6), _local7.length));
        if (_local5.length < _local6){
            padBuffer(_local5);
        };
        if (_arg3 == "CBC"){
            _local10 = 0;
            while (_local10 < _local6) {
                _local5[_local10] = (_local5[_local10] ^ _local4[(_local9 + _local10)]);
                _local10++;
            };
        };
        _local4 = _local4.concat(encryption(_local5, _local8));
        _local9 = (_local9 + _local6);
    };
    if ((_local7.length % _local6) == 0){
        _local4.push(0);
    };
    return (encodeBase64(_local4));
}
keyExpansion = function keyExpansion(_arg1/*Array*/)/*Array*/{
    var _local4/*Number*/;
    var _local2/*Number*/ = 0;
    Nk = (keySize / 32);
    Nb = (blockSize / 32);
    var _local3/*Array*/ = new Array();
    Nr = roundsArray[Nk][Nb];
    _local4 = 0;
    while (_local4 < Nk) {
        _local3[_local4] = (((_arg1[(4 * _local4)] | (_arg1[((4 * _local4) + 1)] << 8)) | (_arg1[((4 * _local4) + 2)] << 16)) | (_arg1[((4 * _local4) + 3)] << 24));
        _local4++;
    };
    _local4 = Nk;
    while (_local4 < (Nb * (Nr + 1))) {
        _local2 = _local3[(_local4 - 1)];
        if ((_local4 % Nk) == 0){
            _local2 = ((((SBox[((_local2 >> 8) & 0xFF)] | (SBox[((_local2 >> 16) & 0xFF)] << 8)) | (SBox[((_local2 >> 24) & 0xFF)] << 16)) | (SBox[(_local2 & 0xFF)] << 24)) ^ Rcon[(Math.floor((_local4 / Nk)) - 1)]);
        } else {
            if ((((Nk > 6)) && (((_local4 % Nk) == 4)))){
                _local2 = ((((SBox[((_local2 >> 24) & 0xFF)] << 24) | (SBox[((_local2 >> 16) & 0xFF)] << 16)) | (SBox[((_local2 >> 8) & 0xFF)] << 8)) | SBox[(_local2 & 0xFF)]);
            };
        };
        _local3[_local4] = (_local3[(_local4 - Nk)] ^ _local2);
        _local4++;
    };
    return (_local3);
}
var InverseRound = function InverseRound(_arg1/*Array*/, _arg2/*Array*/)/*void*/{
    addRoundKey(_arg1, _arg2);
    mixColumn(_arg1, "decrypt");
    shiftRow(_arg1, "decrypt");
    byteSub(_arg1, "decrypt");
}
var cyclicShiftLeft = function cyclicShiftLeft(_arg1/*Array*/, _arg2/*Number*/)/*Array*/{
    var _local3/*Array*/ = _arg1.slice(0, _arg2);
    _arg1 = _arg1.slice(_arg2).concat(_local3);
    return (_arg1);
}
var unpackBytes = function unpackBytes(_arg1/*Array*/)/*Array*/{
    var _local2/*Array*/ = new Array();
    var _local3/*Number*/ = 0;
    while (_local3 < _arg1[0].length) {
        _local2[_local2.length] = _arg1[0][_local3];
        _local2[_local2.length] = _arg1[1][_local3];
        _local2[_local2.length] = _arg1[2][_local3];
        _local2[_local2.length] = _arg1[3][_local3];
        _local3++;
    };
    return (_local2);
}
var addRoundKey = function addRoundKey(_arg1/*Array*/, _arg2/*Array*/)/*void*/{
    var _local3/*Number*/ = 0;
    while (_local3 < Nb) {
        _arg1[0][_local3] = (_arg1[0][_local3] ^ (_arg2[_local3] & 0xFF));
        _arg1[1][_local3] = (_arg1[1][_local3] ^ ((_arg2[_local3] >> 8) & 0xFF));
        _arg1[2][_local3] = (_arg1[2][_local3] ^ ((_arg2[_local3] >> 16) & 0xFF));
        _arg1[3][_local3] = (_arg1[3][_local3] ^ ((_arg2[_local3] >> 24) & 0xFF));
        _local3++;
    };
}
var Round = function Round(_arg1/*Array*/, _arg2/*Array*/)/*void*/{
    byteSub(_arg1, "encrypt");
    shiftRow(_arg1, "encrypt");
    mixColumn(_arg1, "encrypt");
    addRoundKey(_arg1, _arg2);
}
var removePad = function removePad(_arg1/*Array*/)/*void*/{
    var _local2/*Number*/ = (blockSize / 8);
    var _local3/*Number*/ = _arg1[(_arg1.length - 1)];
    var _local4/*Number*/ = 0;
    while (_local4 < _local3) {
        _arg1.pop();
        _local4++;
    };
}
var getRandomBytes = function getRandomBytes(_arg1/*Number*/)/*Array*/{
    var _local2/*Array*/ = new Array();
    var _local3/*Number*/ = 0;
    while (_local3 < _arg1) {
        _local2[_local3] = Math.round((Math.random() * 0xFF));
        _local3++;
    };
    return (_local2);
}
