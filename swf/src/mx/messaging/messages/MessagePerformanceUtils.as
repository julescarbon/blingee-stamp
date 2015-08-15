package mx.messaging.messages {

    public class MessagePerformanceUtils {

        public static const MPI_HEADER_PUSH:String = "DSMPIP";
        public static const MPI_HEADER_OUT:String = "DSMPIO";
        public static const MPI_HEADER_IN:String = "DSMPII";

        public var mpii:MessagePerformanceInfo;
        public var mpio:MessagePerformanceInfo;
        public var mpip:MessagePerformanceInfo;

        public function MessagePerformanceUtils(_arg1:Object):void{
            this.mpii = (_arg1.headers[MPI_HEADER_IN] as MessagePerformanceInfo);
            this.mpio = (_arg1.headers[MPI_HEADER_OUT] as MessagePerformanceInfo);
            if ((((mpio == null)) || ((((mpii == null)) && ((_arg1.headers[MPI_HEADER_PUSH] == null)))))){
                throw (new Error("Message is missing MPI headers.  Verify that all participants have it enabled."));
            };
            if (pushedMessageFlag){
                this.mpip = (_arg1.headers[MPI_HEADER_PUSH] as MessagePerformanceInfo);
            };
        }
        public function get serverPollDelay():Number{
            if (mpip == null){
                return (0);
            };
            if ((((mpip.serverPrePushTime == 0)) || ((mpio.sendTime == 0)))){
                return (0);
            };
            return ((mpio.sendTime - mpip.serverPrePushTime));
        }
        public function get clientReceiveTime():Number{
            return (mpio.receiveTime);
        }
        public function get serverPrePushTime():Number{
            if (mpii == null){
                return (0);
            };
            if (mpii.serverPrePushTime == 0){
                return (serverProcessingTime);
            };
            return ((mpii.serverPrePushTime - mpii.receiveTime));
        }
        public function get pushOneWayTime():Number{
            return ((clientReceiveTime - serverSendTime));
        }
        public function prettyPrint():String{
            var _local1:String = new String("");
            if (messageSize != 0){
                _local1 = (_local1 + (("Original message size(B): " + messageSize) + "\n"));
            };
            if (responseMessageSize != 0){
                _local1 = (_local1 + (("Response message size(B): " + responseMessageSize) + "\n"));
            };
            if (totalTime != 0){
                _local1 = (_local1 + (("Total time (s): " + (totalTime / 1000)) + "\n"));
            };
            if (networkRTT != 0){
                _local1 = (_local1 + (("Network Roundtrip time (s): " + (networkRTT / 1000)) + "\n"));
            };
            if (serverProcessingTime != 0){
                _local1 = (_local1 + (("Server processing time (s): " + (serverProcessingTime / 1000)) + "\n"));
            };
            if (serverAdapterTime != 0){
                _local1 = (_local1 + (("Server adapter time (s): " + (serverAdapterTime / 1000)) + "\n"));
            };
            if (serverNonAdapterTime != 0){
                _local1 = (_local1 + (("Server non-adapter time (s): " + (serverNonAdapterTime / 1000)) + "\n"));
            };
            if (serverAdapterExternalTime != 0){
                _local1 = (_local1 + (("Server adapter external time (s): " + (serverAdapterExternalTime / 1000)) + "\n"));
            };
            if (pushedMessageFlag){
                _local1 = (_local1 + "PUSHED MESSAGE INFORMATION:\n");
                if (totalPushTime != 0){
                    _local1 = (_local1 + (("Total push time (s): " + (totalPushTime / 1000)) + "\n"));
                };
                if (pushOneWayTime != 0){
                    _local1 = (_local1 + (("Push one way time (s): " + (pushOneWayTime / 1000)) + "\n"));
                };
                if (originatingMessageSize != 0){
                    _local1 = (_local1 + (("Originating Message size (B): " + originatingMessageSize) + "\n"));
                };
                if (serverPollDelay != 0){
                    _local1 = (_local1 + (("Server poll delay (s): " + (serverPollDelay / 1000)) + "\n"));
                };
            };
            return (_local1);
        }
        public function get serverSendTime():Number{
            return (mpio.sendTime);
        }
        public function get serverNonAdapterTime():Number{
            return ((serverProcessingTime - serverAdapterTime));
        }
        public function get pushedMessageFlag():Boolean{
            return (mpio.pushedFlag);
        }
        public function get originatingMessageSentTime():Number{
            return (mpip.sendTime);
        }
        public function get serverProcessingTime():Number{
            if (pushedMessageFlag){
                return ((mpip.serverPrePushTime - mpip.receiveTime));
            };
            return ((mpio.sendTime - mpii.receiveTime));
        }
        public function get serverAdapterExternalTime():Number{
            if (pushedMessageFlag){
                if (mpip == null){
                    return (0);
                };
                if ((((mpip.serverPreAdapterExternalTime == 0)) || ((mpip.serverPostAdapterExternalTime == 0)))){
                    return (0);
                };
                return ((mpip.serverPostAdapterExternalTime - mpip.serverPreAdapterExternalTime));
            };
            if (mpii == null){
                return (0);
            };
            if ((((mpii.serverPreAdapterExternalTime == 0)) || ((mpii.serverPostAdapterExternalTime == 0)))){
                return (0);
            };
            return ((mpii.serverPostAdapterExternalTime - mpii.serverPreAdapterExternalTime));
        }
        public function get responseMessageSize():int{
            return (mpio.messageSize);
        }
        public function get messageSize():int{
            if (mpii == null){
                return (0);
            };
            return (mpii.messageSize);
        }
        public function get networkRTT():Number{
            if (!pushedMessageFlag){
                return ((totalTime - serverProcessingTime));
            };
            return (0);
        }
        public function get totalTime():Number{
            if (mpii == null){
                return (0);
            };
            return ((mpio.receiveTime - mpii.sendTime));
        }
        public function get totalPushTime():Number{
            return (((clientReceiveTime - originatingMessageSentTime) - pushedOverheadTime));
        }
        public function get serverAdapterTime():Number{
            if (pushedMessageFlag){
                if (mpip == null){
                    return (0);
                };
                if ((((mpip.serverPreAdapterTime == 0)) || ((mpip.serverPostAdapterTime == 0)))){
                    return (0);
                };
                return ((mpip.serverPostAdapterTime - mpip.serverPreAdapterTime));
            };
            if (mpii == null){
                return (0);
            };
            if ((((mpii.serverPreAdapterTime == 0)) || ((mpii.serverPostAdapterTime == 0)))){
                return (0);
            };
            return ((mpii.serverPostAdapterTime - mpii.serverPreAdapterTime));
        }
        private function get pushedOverheadTime():Number{
            return (mpip.overheadTime);
        }
        public function get originatingMessageSize():Number{
            return (mpip.messageSize);
        }

    }
}//package mx.messaging.messages 
