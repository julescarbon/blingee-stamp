package mx.resources {
    import mx.core.*;

    public class LocaleSorter {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private static function normalizeLocale(_arg1:String):String{
            return (_arg1.toLowerCase().replace(/-/g, "_"));
        }
        public static function sortLocalesByPreference(_arg1:Array, _arg2:Array, _arg3:String=null, _arg4:Boolean=false):Array{
            var result:* = null;
            var hasLocale:* = null;
            var i:* = 0;
            var j:* = 0;
            var k:* = 0;
            var l:* = 0;
            var locale:* = null;
            var plocale:* = null;
            var appLocales:* = _arg1;
            var systemPreferences:* = _arg2;
            var ultimateFallbackLocale = _arg3;
            var addAll:Boolean = _arg4;
            var promote:* = function (_arg1:String):void{
                if (typeof(hasLocale[_arg1]) != "undefined"){
                    result.push(appLocales[hasLocale[_arg1]]);
                    delete hasLocale[_arg1];
                };
            };
            result = [];
            hasLocale = {};
            var locales:* = trimAndNormalize(appLocales);
            var preferenceLocales:* = trimAndNormalize(systemPreferences);
            addUltimateFallbackLocale(preferenceLocales, ultimateFallbackLocale);
            j = 0;
            while (j < locales.length) {
                hasLocale[locales[j]] = j;
                j = (j + 1);
            };
            i = 0;
            l = preferenceLocales.length;
            while (i < l) {
                plocale = LocaleID.fromString(preferenceLocales[i]);
                promote(preferenceLocales[i]);
                promote(plocale.toString());
                while (plocale.transformToParent()) {
                    promote(plocale.toString());
                };
                plocale = LocaleID.fromString(preferenceLocales[i]);
                j = 0;
                while (j < l) {
                    locale = preferenceLocales[j];
                    if (plocale.isSiblingOf(LocaleID.fromString(locale))){
                        promote(locale);
                    };
                    j = (j + 1);
                };
                j = 0;
                k = locales.length;
                while (j < k) {
                    locale = locales[j];
                    if (plocale.isSiblingOf(LocaleID.fromString(locale))){
                        promote(locale);
                    };
                    j = (j + 1);
                };
                i = (i + 1);
            };
            if (addAll){
                j = 0;
                k = locales.length;
                while (j < k) {
                    promote(locales[j]);
                    j = (j + 1);
                };
            };
            return (result);
        }
        private static function addUltimateFallbackLocale(_arg1:Array, _arg2:String):void{
            var _local3:String;
            if (((!((_arg2 == null))) && (!((_arg2 == ""))))){
                _local3 = normalizeLocale(_arg2);
                if (_arg1.indexOf(_local3) == -1){
                    _arg1.push(_local3);
                };
            };
        }
        private static function trimAndNormalize(_arg1:Array):Array{
            var _local2:Array = [];
            var _local3:int;
            while (_local3 < _arg1.length) {
                _local2.push(normalizeLocale(_arg1[_local3]));
                _local3++;
            };
            return (_local2);
        }

    }
}//package mx.resources 

class LocaleID {

    public static const STATE_PRIMARY_LANGUAGE:int = 0;
    public static const STATE_REGION:int = 3;
    public static const STATE_EXTENDED_LANGUAGES:int = 1;
    public static const STATE_EXTENSIONS:int = 5;
    public static const STATE_SCRIPT:int = 2;
    public static const STATE_VARIANTS:int = 4;
    public static const STATE_PRIVATES:int = 6;

    private var privateLangs:Boolean = false;
    private var script:String = "";
    private var variants:Array;
    private var privates:Array;
    private var extensions:Object;
    private var lang:String = "";
    private var region:String = "";
    private var extended_langs:Array;

    public function LocaleID(){
        extended_langs = [];
        variants = [];
        extensions = {};
        privates = [];
        super();
    }
    public static function fromString(_arg1:String):LocaleID{
        var _local5:Array;
        var _local8:String;
        var _local9:int;
        var _local10:String;
        var _local2:LocaleID = new (LocaleID)();
        var _local3:int = STATE_PRIMARY_LANGUAGE;
        var _local4:Array = _arg1.replace(/-/g, "_").split("_");
        var _local6:int;
        var _local7:int = _local4.length;
        while (_local6 < _local7) {
            _local8 = _local4[_local6].toLowerCase();
            if (_local3 == STATE_PRIMARY_LANGUAGE){
                if (_local8 == "x"){
                    _local2.privateLangs = true;
                } else {
                    if (_local8 == "i"){
                        _local2.lang = (_local2.lang + "i-");
                    } else {
                        _local2.lang = (_local2.lang + _local8);
                        _local3 = STATE_EXTENDED_LANGUAGES;
                    };
                };
            } else {
                _local9 = _local8.length;
                if (_local9 == 0){
                } else {
                    _local10 = _local8.charAt(0).toLowerCase();
                    if ((((_local3 <= STATE_EXTENDED_LANGUAGES)) && ((_local9 == 3)))){
                        _local2.extended_langs.push(_local8);
                        if (_local2.extended_langs.length == 3){
                            _local3 = STATE_SCRIPT;
                        };
                    } else {
                        if ((((_local3 <= STATE_SCRIPT)) && ((_local9 == 4)))){
                            _local2.script = _local8;
                            _local3 = STATE_REGION;
                        } else {
                            if ((((_local3 <= STATE_REGION)) && ((((_local9 == 2)) || ((_local9 == 3)))))){
                                _local2.region = _local8;
                                _local3 = STATE_VARIANTS;
                            } else {
                                if ((((_local3 <= STATE_VARIANTS)) && ((((((((_local10 >= "a")) && ((_local10 <= "z")))) && ((_local9 >= 5)))) || ((((((_local10 >= "0")) && ((_local10 <= "9")))) && ((_local9 >= 4)))))))){
                                    _local2.variants.push(_local8);
                                    _local3 = STATE_VARIANTS;
                                } else {
                                    if ((((_local3 < STATE_PRIVATES)) && ((_local9 == 1)))){
                                        if (_local8 == "x"){
                                            _local3 = STATE_PRIVATES;
                                            _local5 = _local2.privates;
                                        } else {
                                            _local3 = STATE_EXTENSIONS;
                                            _local5 = ((_local2.extensions[_local8]) || ([]));
                                            _local2.extensions[_local8] = _local5;
                                        };
                                    } else {
                                        if (_local3 >= STATE_EXTENSIONS){
                                            _local5.push(_local8);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _local6++;
        };
        _local2.canonicalize();
        return (_local2);
    }

    public function equals(_arg1:LocaleID):Boolean{
        return ((toString() == _arg1.toString()));
    }
    public function canonicalize():void{
        var _local1:String;
        for (_local1 in extensions) {
            if (extensions.hasOwnProperty(_local1)){
                if (extensions[_local1].length == 0){
                    delete extensions[_local1];
                } else {
                    extensions[_local1] = extensions[_local1].sort();
                };
            };
        };
        extended_langs = extended_langs.sort();
        variants = variants.sort();
        privates = privates.sort();
        if (script == ""){
            script = LocaleRegistry.getScriptByLang(lang);
        };
        if ((((script == "")) && (!((region == ""))))){
            script = LocaleRegistry.getScriptByLangAndRegion(lang, region);
        };
        if ((((region == "")) && (!((script == ""))))){
            region = LocaleRegistry.getDefaultRegionForLangAndScript(lang, script);
        };
    }
    public function toString():String{
        var _local2:String;
        var _local1:Array = [lang];
        Array.prototype.push.apply(_local1, extended_langs);
        if (script != ""){
            _local1.push(script);
        };
        if (region != ""){
            _local1.push(region);
        };
        Array.prototype.push.apply(_local1, variants);
        for (_local2 in extensions) {
            if (extensions.hasOwnProperty(_local2)){
                _local1.push(_local2);
                Array.prototype.push.apply(_local1, extensions[_local2]);
            };
        };
        if (privates.length > 0){
            _local1.push("x");
            Array.prototype.push.apply(_local1, privates);
        };
        return (_local1.join("_"));
    }
    public function isSiblingOf(_arg1:LocaleID):Boolean{
        return ((((lang == _arg1.lang)) && ((script == _arg1.script))));
    }
    public function transformToParent():Boolean{
        var _local2:String;
        var _local3:Array;
        var _local4:String;
        if (privates.length > 0){
            privates.splice((privates.length - 1), 1);
            return (true);
        };
        var _local1:String;
        for (_local2 in extensions) {
            if (extensions.hasOwnProperty(_local2)){
                _local1 = _local2;
            };
        };
        if (_local1){
            _local3 = extensions[_local1];
            if (_local3.length == 1){
                delete extensions[_local1];
                return (true);
            };
            _local3.splice((_local3.length - 1), 1);
            return (true);
        };
        if (variants.length > 0){
            variants.splice((variants.length - 1), 1);
            return (true);
        };
        if (script != ""){
            if (LocaleRegistry.getScriptByLang(lang) != ""){
                script = "";
                return (true);
            };
            if (region == ""){
                _local4 = LocaleRegistry.getDefaultRegionForLangAndScript(lang, script);
                if (_local4 != ""){
                    region = _local4;
                    script = "";
                    return (true);
                };
            };
        };
        if (region != ""){
            if (!(((script == "")) && ((LocaleRegistry.getScriptByLang(lang) == "")))){
                region = "";
                return (true);
            };
        };
        if (extended_langs.length > 0){
            extended_langs.splice((extended_langs.length - 1), 1);
            return (true);
        };
        return (false);
    }

}
class LocaleRegistry {

    private static const SCRIPT_ID_BY_LANG:Object = {
        ab:5,
        af:1,
        am:2,
        ar:3,
        as:4,
        ay:1,
        be:5,
        bg:5,
        bn:4,
        bs:1,
        ca:1,
        ch:1,
        cs:1,
        cy:1,
        da:1,
        de:1,
        dv:6,
        dz:7,
        el:8,
        en:1,
        eo:1,
        es:1,
        et:1,
        eu:1,
        fa:3,
        fi:1,
        fj:1,
        fo:1,
        fr:1,
        frr:1,
        fy:1,
        ga:1,
        gl:1,
        gn:1,
        gu:9,
        gv:1,
        he:10,
        hi:11,
        hr:1,
        ht:1,
        hu:1,
        hy:12,
        id:1,
        in:1,
        is:1,
        it:1,
        iw:10,
        ja:13,
        ka:14,
        kk:5,
        kl:1,
        km:15,
        kn:16,
        ko:17,
        la:1,
        lb:1,
        ln:1,
        lo:18,
        lt:1,
        lv:1,
        mg:1,
        mh:1,
        mk:5,
        ml:19,
        mo:1,
        mr:11,
        ms:1,
        mt:1,
        my:20,
        na:1,
        nb:1,
        nd:1,
        ne:11,
        nl:1,
        nn:1,
        no:1,
        nr:1,
        ny:1,
        om:1,
        or:21,
        pa:22,
        pl:1,
        ps:3,
        pt:1,
        qu:1,
        rn:1,
        ro:1,
        ru:5,
        rw:1,
        sg:1,
        si:23,
        sk:1,
        sl:1,
        sm:1,
        so:1,
        sq:1,
        ss:1,
        st:1,
        sv:1,
        sw:1,
        ta:24,
        te:25,
        th:26,
        ti:2,
        tl:1,
        tn:1,
        to:1,
        tr:1,
        ts:1,
        uk:5,
        ur:3,
        ve:1,
        vi:1,
        wo:1,
        xh:1,
        yi:10,
        zu:1,
        cpe:1,
        dsb:1,
        frs:1,
        gsw:1,
        hsb:1,
        kok:11,
        mai:11,
        men:1,
        nds:1,
        niu:1,
        nqo:27,
        nso:1,
        son:1,
        tem:1,
        tkl:1,
        tmh:1,
        tpi:1,
        tvl:1,
        zbl:28
    };
    private static const SCRIPTS:Array = ["", "latn", "ethi", "arab", "beng", "cyrl", "thaa", "tibt", "grek", "gujr", "hebr", "deva", "armn", "jpan", "geor", "khmr", "knda", "kore", "laoo", "mlym", "mymr", "orya", "guru", "sinh", "taml", "telu", "thai", "nkoo", "blis", "hans", "hant", "mong", "syrc"];
    private static const DEFAULT_REGION_BY_LANG_AND_SCRIPT:Object = {
        bg:{5:"bg"},
        ca:{1:"es"},
        zh:{
            30:"tw",
            29:"cn"
        },
        cs:{1:"cz"},
        da:{1:"dk"},
        de:{1:"de"},
        el:{8:"gr"},
        en:{1:"us"},
        es:{1:"es"},
        fi:{1:"fi"},
        fr:{1:"fr"},
        he:{10:"il"},
        hu:{1:"hu"},
        is:{1:"is"},
        it:{1:"it"},
        ja:{13:"jp"},
        ko:{17:"kr"},
        nl:{1:"nl"},
        nb:{1:"no"},
        pl:{1:"pl"},
        pt:{1:"br"},
        ro:{1:"ro"},
        ru:{5:"ru"},
        hr:{1:"hr"},
        sk:{1:"sk"},
        sq:{1:"al"},
        sv:{1:"se"},
        th:{26:"th"},
        tr:{1:"tr"},
        ur:{3:"pk"},
        id:{1:"id"},
        uk:{5:"ua"},
        be:{5:"by"},
        sl:{1:"si"},
        et:{1:"ee"},
        lv:{1:"lv"},
        lt:{1:"lt"},
        fa:{3:"ir"},
        vi:{1:"vn"},
        hy:{12:"am"},
        az:{
            1:"az",
            5:"az"
        },
        eu:{1:"es"},
        mk:{5:"mk"},
        af:{1:"za"},
        ka:{14:"ge"},
        fo:{1:"fo"},
        hi:{11:"in"},
        ms:{1:"my"},
        kk:{5:"kz"},
        ky:{5:"kg"},
        sw:{1:"ke"},
        uz:{
            1:"uz",
            5:"uz"
        },
        tt:{5:"ru"},
        pa:{22:"in"},
        gu:{9:"in"},
        ta:{24:"in"},
        te:{25:"in"},
        kn:{16:"in"},
        mr:{11:"in"},
        sa:{11:"in"},
        mn:{5:"mn"},
        gl:{1:"es"},
        kok:{11:"in"},
        syr:{32:"sy"},
        dv:{6:"mv"},
        nn:{1:"no"},
        sr:{
            1:"cs",
            5:"cs"
        },
        cy:{1:"gb"},
        mi:{1:"nz"},
        mt:{1:"mt"},
        quz:{1:"bo"},
        tn:{1:"za"},
        xh:{1:"za"},
        zu:{1:"za"},
        nso:{1:"za"},
        se:{1:"no"},
        smj:{1:"no"},
        sma:{1:"no"},
        sms:{1:"fi"},
        smn:{1:"fi"},
        bs:{1:"ba"}
    };
    private static const SCRIPT_BY_ID:Object = {
        latn:1,
        ethi:2,
        arab:3,
        beng:4,
        cyrl:5,
        thaa:6,
        tibt:7,
        grek:8,
        gujr:9,
        hebr:10,
        deva:11,
        armn:12,
        jpan:13,
        geor:14,
        khmr:15,
        knda:16,
        kore:17,
        laoo:18,
        mlym:19,
        mymr:20,
        orya:21,
        guru:22,
        sinh:23,
        taml:24,
        telu:25,
        thai:26,
        nkoo:27,
        blis:28,
        hans:29,
        hant:30,
        mong:31,
        syrc:32
    };
    private static const SCRIPT_ID_BY_LANG_AND_REGION:Object = {
        zh:{
            cn:29,
            sg:29,
            tw:30,
            hk:30,
            mo:30
        },
        mn:{
            cn:31,
            sg:5
        },
        pa:{
            pk:3,
            in:22
        },
        ha:{
            gh:1,
            ne:1
        }
    };

    public function LocaleRegistry(){
    }
    public static function getScriptByLangAndRegion(_arg1:String, _arg2:String):String{
        var _local3:Object = SCRIPT_ID_BY_LANG_AND_REGION[_arg1];
        if (_local3 == null){
            return ("");
        };
        var _local4:Object = _local3[_arg2];
        if (_local4 == null){
            return ("");
        };
        return (SCRIPTS[int(_local4)].toLowerCase());
    }
    public static function getScriptByLang(_arg1:String):String{
        var _local2:Object = SCRIPT_ID_BY_LANG[_arg1];
        if (_local2 == null){
            return ("");
        };
        return (SCRIPTS[int(_local2)].toLowerCase());
    }
    public static function getDefaultRegionForLangAndScript(_arg1:String, _arg2:String):String{
        var _local3:Object = DEFAULT_REGION_BY_LANG_AND_SCRIPT[_arg1];
        var _local4:Object = SCRIPT_BY_ID[_arg2];
        if ((((_local3 == null)) || ((_local4 == null)))){
            return ("");
        };
        return (((_local3[int(_local4)]) || ("")));
    }

}
