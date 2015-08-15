package {
    import mx.core.*;
    import mx.events.*;
    import mx.controls.*;
    import mx.containers.*;
    import flash.system.*;

    public class DebugTab extends VBox {

        private var _documentDescriptor_:UIComponentDescriptor;
        private var _2139592032txtSystemMemory:Text;

        public function DebugTab(){
            _documentDescriptor_ = new UIComponentDescriptor({
                type:VBox,
                propertiesFactory:function ():Object{
                    return ({childDescriptors:[new UIComponentDescriptor({
                            type:VBox,
                            propertiesFactory:function ():Object{
                                return ({
                                    percentWidth:100,
                                    percentHeight:100,
                                    childDescriptors:[new UIComponentDescriptor({
                                        type:Text,
                                        id:"txtSystemMemory",
                                        propertiesFactory:function ():Object{
                                            return ({
                                                visible:true,
                                                includeInLayout:true
                                            });
                                        }
                                    })]
                                });
                            }
                        })]});
                }
            });
            super();
            mx_internal::_document = this;
            this.percentWidth = 100;
            this.percentHeight = 100;
            this.verticalScrollPolicy = "off";
            this.horizontalScrollPolicy = "off";
            this.addEventListener("creationComplete", ___DebugTab_VBox1_creationComplete);
            this.addEventListener("show", ___DebugTab_VBox1_show);
        }
        public function get txtSystemMemory():Text{
            return (this._2139592032txtSystemMemory);
        }
        protected function OnCreationComplete():void{
        }
        public function set txtSystemMemory(_arg1:Text):void{
            var _local2:Object = this._2139592032txtSystemMemory;
            if (_local2 !== _arg1){
                this._2139592032txtSystemMemory = _arg1;
                this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "txtSystemMemory", _local2, _arg1));
            };
        }
        override public function initialize():void{
            mx_internal::setDocumentDescriptor(_documentDescriptor_);
            super.initialize();
        }
        public function ___DebugTab_VBox1_creationComplete(_arg1:FlexEvent):void{
            OnCreationComplete();
        }
        protected function OnShow():void{
            txtSystemMemory.text = (("System memory: " + Number((System.totalMemory / (0x0400 * 0x0400))).toFixed(2)) + "MB");
        }
        public function ___DebugTab_VBox1_show(_arg1:FlexEvent):void{
            OnShow();
        }
        public function Initialize():void{
        }

    }
}//package 
