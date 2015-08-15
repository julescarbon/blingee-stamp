package mx.messaging {
    import mx.events.*;
    import mx.messaging.messages.*;
    import mx.logging.*;

    public class Producer extends AbstractProducer {

        private var _subtopic:String = "";

        public function Producer(){
            _log = Log.getLogger("mx.messaging.Producer");
            _agentType = "producer";
        }
        override protected function internalSend(_arg1:IMessage, _arg2:Boolean=true):void{
            if (subtopic.length > 0){
                _arg1.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopic;
            };
            super.internalSend(_arg1, _arg2);
        }
        public function set subtopic(_arg1:String):void{
            var _local2:PropertyChangeEvent;
            if (_subtopic != _arg1){
                if (_arg1 == null){
                    _arg1 = "";
                };
                _local2 = PropertyChangeEvent.createUpdateEvent(this, "subtopic", _subtopic, _arg1);
                _subtopic = _arg1;
                dispatchEvent(_local2);
            };
        }
        public function get subtopic():String{
            return (_subtopic);
        }

    }
}//package mx.messaging 
