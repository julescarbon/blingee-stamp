package mx.messaging.config {
    import mx.resources.*;
    import mx.collections.*;
    import flash.utils.*;
    import mx.messaging.*;
    import mx.utils.*;
    import mx.messaging.errors.*;

    public class ServerConfig {

        public static const URI_ATTR:String = "uri";
        public static const CLASS_ATTR:String = "type";

        private static var _resourceManager:IResourceManager;
        private static var _clusteredChannels:Object = {};
        private static var _unclusteredChannels:Object = {};
        private static var _configFetchedChannels:Object;
        public static var serverConfigData:XML;
        private static var _channelSets:Object = {};

        private static function convertToXML(_arg1:ConfigMap, _arg2:XML):void{
            var _local3:Object;
            var _local4:Object;
            var _local5:Object;
            var _local6:XML;
            var _local7:Array;
            var _local8:int;
            var _local9:XML;
            var _local10:XML;
            for (_local3 in _arg1) {
                _local4 = _arg1[_local3];
                if ((_local4 is String)){
                    if (_local3 == ""){
                        _local5 = _arg2.localName();
                        _local6 = _arg2.parent();
                        _local6[_local5] = _local4;
                    } else {
                        _arg2.@[_local3] = _local4;
                    };
                } else {
                    if ((((_local4 is ArrayCollection)) || ((_local4 is Array)))){
                        if ((_local4 is ArrayCollection)){
                            _local7 = ArrayCollection(_local4).toArray();
                        } else {
                            _local7 = (_local4 as Array);
                        };
                        _local8 = 0;
                        while (_local8 < _local7.length) {
                            _local9 = new XML((((("<" + _local3) + "></") + _local3) + ">"));
                            _arg2.appendChild(_local9);
                            convertToXML((_local7[_local8] as ConfigMap), _local9);
                            _local8++;
                        };
                    } else {
                        _local10 = new XML((((("<" + _local3) + "></") + _local3) + ">"));
                        _arg2.appendChild(_local10);
                        convertToXML((_local4 as ConfigMap), _local10);
                    };
                };
            };
        }
        mx_internal static function getChannelIdList(_arg1:String):Array{
            var _local2:XML = getDestinationConfig(_arg1);
            return (((_local2) ? getChannelIds(_local2) : getDefaultChannelIds()));
        }
        public static function getChannel(_arg1:String, _arg2:Boolean=false):Channel{
            var _local3:Channel;
            if (!_arg2){
                if ((_arg1 in _unclusteredChannels)){
                    return (_unclusteredChannels[_arg1]);
                };
                _local3 = createChannel(_arg1);
                _unclusteredChannels[_arg1] = _local3;
                return (_local3);
            };
            if ((_arg1 in _clusteredChannels)){
                return (_clusteredChannels[_arg1]);
            };
            _local3 = createChannel(_arg1);
            _clusteredChannels[_arg1] = _local3;
            return (_local3);
        }
        mx_internal static function needsConfig(_arg1:Channel):Boolean{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:Array;
            var _local6:int;
            var _local7:int;
            if ((((_configFetchedChannels == null)) || ((_configFetchedChannels[_arg1.endpoint] == null)))){
                _local2 = _arg1.channelSets;
                _local3 = _local2.length;
                _local4 = 0;
                while (_local4 < _local3) {
                    _local5 = ChannelSet(_local2[_local4]).messageAgents;
                    _local6 = _local5.length;
                    _local7 = 0;
                    while (_local7 < _local6) {
                        if (MessageAgent(_local5[_local7]).needsConfig){
                            return (true);
                        };
                        _local7++;
                    };
                    _local4++;
                };
            };
            return (false);
        }
        public static function getChannelSet(_arg1:String):ChannelSet{
            var _local2:XML = getDestinationConfig(_arg1);
            return (internalGetChannelSet(_local2, _arg1));
        }
        public static function get xml():XML{
            if (serverConfigData == null){
                serverConfigData = <services/>
                ;
            };
            return (serverConfigData);
        }
        mx_internal static function updateServerConfigData(_arg1:ConfigMap, _arg2:String=null):void{
            var newServices:* = null;
            var newService:* = null;
            var newChannels:* = null;
            var oldServices:* = null;
            var oldService:* = null;
            var newDestination:* = null;
            var oldDestinations:* = null;
            var oldChannels:* = null;
            var serverConfig:* = _arg1;
            var endpoint = _arg2;
            if (serverConfig != null){
                if (endpoint != null){
                    if (_configFetchedChannels == null){
                        _configFetchedChannels = {};
                    };
                    _configFetchedChannels[endpoint] = true;
                };
                newServices = <services></services>
                ;
                convertToXML(serverConfig, newServices);
                xml["default-channels"] = newServices["default-channels"];
                for each (newService in newServices..service) {
                    oldServices = xml.service.(@id == newService.@id);
                    if (oldServices.length() != 0){
                        oldService = oldServices[0];
                        for each (newDestination in newService..destination) {
                            oldDestinations = oldService.destination.(@id == newDestination.@id);
                            if (oldDestinations.length() != 0){
                                delete oldDestinations[0];
                            };
                            oldService.appendChild(newDestination);
                        };
                    } else {
                        xml.appendChild(newService);
                    };
                };
                newChannels = newServices.channels;
                if (newChannels.length() > 0){
                    oldChannels = xml.channels[0];
                    if ((((oldChannels == null)) || ((oldChannels.length() == 0)))){
                        xml.appendChild(newChannels);
                    };
                };
            };
        }
        private static function internalGetChannelSet(_arg1:XML, _arg2:String):ChannelSet{
            var _local3:Array;
            var _local4:Boolean;
            var _local6:String;
            var _local7:ChannelSet;
            if (_arg1 == null){
                _local3 = getDefaultChannelIds();
                if (_local3.length == 0){
                    _local6 = resourceManager.getString("messaging", "noChannelForDestination", [_arg2]);
                    throw (new InvalidDestinationError(_local6));
                };
                _local4 = false;
            } else {
                _local3 = getChannelIds(_arg1);
                _local4 = ((_arg1.properties.network.cluster.length())>0) ? true : false;
            };
            var _local5:String = ((_local3.join(",") + ":") + _local4);
            if ((_local5 in _channelSets)){
                return (_channelSets[_local5]);
            };
            _local7 = new ChannelSet(_local3, _local4);
            if (_local4){
                _local7.initialDestinationId = _arg2;
            };
            _channelSets[_local5] = _local7;
            return (_local7);
        }
        private static function getDefaultChannelIds():Array{
            var _local1:Array = [];
            var _local2:XMLList = xml["default-channels"].channel;
            var _local3:int = _local2.length();
            var _local4:int;
            while (_local4 < _local3) {
                _local1.push(_local2[_local4].@ref.toString());
                _local4++;
            };
            return (_local1);
        }
        private static function createChannel(_arg1:String):Channel{
            var message:* = null;
            var channels:* = null;
            var channelConfig:* = null;
            var className:* = null;
            var uri:* = null;
            var channel:* = null;
            var channelClass:* = null;
            var channelId:* = _arg1;
            channels = xml.channels.channel.(@id == channelId);
            if (channels.length() == 0){
                message = resourceManager.getString("messaging", "unknownChannelWithId", [channelId]);
                throw (new InvalidChannelError(message));
            };
            channelConfig = channels[0];
            className = channelConfig.attribute(CLASS_ATTR).toString();
            uri = channelConfig.endpoint[0].attribute(URI_ATTR).toString();
            channel = null;
            try {
                channelClass = (getDefinitionByName(className) as Class);
                channel = new channelClass(channelId, uri);
                channel.applySettings(channelConfig);
                if (LoaderConfig.parameters.WSRP_ENCODED_CHANNEL != null){
                    channel.url = LoaderConfig.parameters.WSRP_ENCODED_CHANNEL;
                };
            } catch(e:ReferenceError) {
                message = resourceManager.getString("messaging", "unknownChannelClass", [className]);
                throw (new InvalidChannelError(message));
            };
            return (channel);
        }
        public static function getProperties(_arg1:String):XMLList{
            var destination:* = null;
            var message:* = null;
            var destinationId:* = _arg1;
            destination = xml..destination.(@id == destinationId);
            if (destination.length() > 0){
                return (destination.properties);
            };
            message = resourceManager.getString("messaging", "unknownDestination", [destinationId]);
            throw (new InvalidDestinationError(message));
        }
        private static function getChannelIds(_arg1:XML):Array{
            var _local2:Array = [];
            var _local3:XMLList = _arg1.channels.channel;
            var _local4:int = _local3.length();
            var _local5:int;
            while (_local5 < _local4) {
                _local2.push(_local3[_local5].@ref.toString());
                _local5++;
            };
            return (_local2);
        }
        public static function set xml(_arg1:XML):void{
            serverConfigData = _arg1;
            _channelSets = {};
            _clusteredChannels = {};
            _unclusteredChannels = {};
        }
        private static function getDestinationConfig(_arg1:String):XML{
            var destinations:* = null;
            var destinationCount:* = 0;
            var destinationId:* = _arg1;
            destinations = xml..destination.(@id == destinationId);
            destinationCount = destinations.length();
            if (destinationCount == 0){
                return (null);
            };
            return (destinations[0]);
        }
        mx_internal static function fetchedConfig(_arg1:String):Boolean{
            return (((!((_configFetchedChannels == null))) && (!((_configFetchedChannels[_arg1] == null)))));
        }
        mx_internal static function channelSetMatchesDestinationConfig(_arg1:ChannelSet, _arg2:String):Boolean{
            var csUris:* = null;
            var csChannels:* = null;
            var i:* = 0;
            var ids:* = null;
            var dsUris:* = null;
            var dsChannels:* = null;
            var channelConfig:* = null;
            var j:* = 0;
            var channelSet:* = _arg1;
            var destination:* = _arg2;
            if (channelSet != null){
                if (ObjectUtil.compare(channelSet.channelIds, getChannelIdList(destination)) == 0){
                    return (true);
                };
                csUris = [];
                csChannels = channelSet.channels;
                i = 0;
                while (i < csChannels.length) {
                    csUris.push(csChannels[i].uri);
                    i = (i + 1);
                };
                ids = getChannelIdList(destination);
                dsUris = [];
                j = 0;
                while (j < ids.length) {
                    dsChannels = xml.channels.channel.(@id == ids[j]);
                    channelConfig = dsChannels[0];
                    dsUris.push(channelConfig.endpoint[0].attribute(URI_ATTR).toString());
                    j = (j + 1);
                };
                return ((ObjectUtil.compare(csUris, dsUris) == 0));
            };
            return (false);
        }
        public static function checkChannelConsistency(_arg1:String, _arg2:String):void{
            var _local3:Array = getChannelIdList(_arg1);
            var _local4:Array = getChannelIdList(_arg2);
            if (ObjectUtil.compare(_local3, _local4) != 0){
                throw (new ArgumentError("Specified destinations are not channel consistent"));
            };
        }
        private static function get resourceManager():IResourceManager{
            if (!_resourceManager){
                _resourceManager = ResourceManager.getInstance();
            };
            return (_resourceManager);
        }

    }
}//package mx.messaging.config 
