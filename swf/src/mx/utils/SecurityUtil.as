package mx.utils {
    import mx.core.*;

    public class SecurityUtil {

        mx_internal static const VERSION:String = "3.2.0.3958";

        public static function hasMutualTrustBetweenParentAndChild(_arg1:ISWFBridgeProvider):Boolean{
            if (((((_arg1) && (_arg1.childAllowsParent))) && (_arg1.parentAllowsChild))){
                return (true);
            };
            return (false);
        }

    }
}//package mx.utils 
