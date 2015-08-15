package mx.states {
    import mx.effects.*;

    public class Transition {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public var effect:IEffect;
        public var toState:String = "*";
        public var fromState:String = "*";

    }
}//package mx.states 
