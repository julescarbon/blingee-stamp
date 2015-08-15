package mx.events {
    import flash.events.*;

    public class BrowserChangeEvent extends Event {

        public static const BROWSER_URL_CHANGE:String = "browserURLChange";
        mx_internal static const VERSION:String = "3.2.0.3958";
        public static const URL_CHANGE:String = "urlChange";
        public static const APPLICATION_URL_CHANGE:String = "applicationURLChange";

        public var lastURL:String;
        public var url:String;

        public function BrowserChangeEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false, _arg4:String=null, _arg5:String=null){
            super(_arg1, _arg2, _arg3);
            this.url = _arg4;
            this.lastURL = _arg5;
        }
        override public function clone():Event{
            return (new BrowserChangeEvent(type, bubbles, cancelable, url, lastURL));
        }

    }
}//package mx.events 
