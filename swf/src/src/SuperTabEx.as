package src {
    import flexlib.controls.tabBarClasses.*;

    public class SuperTabEx extends SuperTab {

        var m_explicitPercentWidth:int = -1;

        public function set explicitPercentWidth(_arg1:int):void{
            m_explicitPercentWidth = _arg1;
        }
        public function get explicitPercentWidth():int{
            return (m_explicitPercentWidth);
        }

    }
}//package src 
