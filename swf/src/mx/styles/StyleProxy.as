package mx.styles {
    import mx.core.*;

    public class StyleProxy implements IStyleClient {

        mx_internal static const VERSION:String = "3.2.0.3958";

        private var _source:IStyleClient;
        private var _filterMap:Object;

        public function StyleProxy(_arg1:IStyleClient, _arg2:Object){
            this.filterMap = _arg2;
            this.source = _arg1;
        }
        public function styleChanged(_arg1:String):void{
            return (_source.styleChanged(_arg1));
        }
        public function get filterMap():Object{
            return ((((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) ? null : _filterMap));
        }
        public function set filterMap(_arg1:Object):void{
            _filterMap = _arg1;
        }
        public function get styleDeclaration():CSSStyleDeclaration{
            return (_source.styleDeclaration);
        }
        public function notifyStyleChangeInChildren(_arg1:String, _arg2:Boolean):void{
            return (_source.notifyStyleChangeInChildren(_arg1, _arg2));
        }
        public function set inheritingStyles(_arg1:Object):void{
        }
        public function get source():IStyleClient{
            return (_source);
        }
        public function get styleName():Object{
            if ((_source.styleName is IStyleClient)){
                return (new StyleProxy(IStyleClient(_source.styleName), filterMap));
            };
            return (_source.styleName);
        }
        public function registerEffects(_arg1:Array):void{
            return (_source.registerEffects(_arg1));
        }
        public function regenerateStyleCache(_arg1:Boolean):void{
            _source.regenerateStyleCache(_arg1);
        }
        public function get inheritingStyles():Object{
            return (_source.inheritingStyles);
        }
        public function get className():String{
            return (_source.className);
        }
        public function clearStyle(_arg1:String):void{
            _source.clearStyle(_arg1);
        }
        public function getClassStyleDeclarations():Array{
            return (_source.getClassStyleDeclarations());
        }
        public function set nonInheritingStyles(_arg1:Object):void{
        }
        public function setStyle(_arg1:String, _arg2):void{
            _source.setStyle(_arg1, _arg2);
        }
        public function get nonInheritingStyles():Object{
            return ((((FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)) ? _source.nonInheritingStyles : null));
        }
        public function set styleName(_arg1:Object):void{
            _source.styleName = _arg1;
        }
        public function getStyle(_arg1:String){
            return (_source.getStyle(_arg1));
        }
        public function set source(_arg1:IStyleClient):void{
            _source = _arg1;
        }
        public function set styleDeclaration(_arg1:CSSStyleDeclaration):void{
            _source.styleDeclaration = styleDeclaration;
        }

    }
}//package mx.styles 
