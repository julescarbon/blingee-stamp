package {
    import mx.core.*;
    import mx.styles.*;
    import mx.effects.*;
    import mx.collections.*;
    import mx.messaging.messages.*;
    import flash.utils.*;
    import flash.system.*;
    import flash.net.*;
    import mx.utils.*;
    import mx.messaging.config.*;

    public class _BlingeeMaker_FlexInit {

        public static function init(_arg1:IFlexModuleFactory):void{
            var fbs:* = _arg1;
            var _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("addedEffect", "added");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("completeEffect", "complete");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("creationCompleteEffect", "creationComplete");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("focusInEffect", "focusIn");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("focusOutEffect", "focusOut");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("hideEffect", "hide");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("itemsChangeEffect", "itemsChange");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("mouseDownEffect", "mouseDown");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("mouseUpEffect", "mouseUp");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("moveEffect", "move");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("removedEffect", "removed");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("resizeEffect", "resize");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("resizeEndEffect", "resizeEnd");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("resizeStartEffect", "resizeStart");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("rollOutEffect", "rollOut");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("rollOverEffect", "rollOver");
            _local3 = EffectManager;
            _local3.mx_internal::registerEffectTrigger("showEffect", "show");
            try {
                if (getClassByAlias("flex.messaging.io.ArrayCollection") == null){
                    registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
            };
            try {
                if (getClassByAlias("flex.messaging.io.ArrayList") == null){
                    registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
            };
            try {
                if (getClassByAlias("flex.messaging.config.ConfigMap") == null){
                    registerClassAlias("flex.messaging.config.ConfigMap", ConfigMap);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.config.ConfigMap", ConfigMap);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.AcknowledgeMessage") == null){
                    registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
            };
            try {
                if (getClassByAlias("DSK") == null){
                    registerClassAlias("DSK", AcknowledgeMessageExt);
                };
            } catch(e:Error) {
                registerClassAlias("DSK", AcknowledgeMessageExt);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.AsyncMessage") == null){
                    registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
            };
            try {
                if (getClassByAlias("DSA") == null){
                    registerClassAlias("DSA", AsyncMessageExt);
                };
            } catch(e:Error) {
                registerClassAlias("DSA", AsyncMessageExt);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.CommandMessage") == null){
                    registerClassAlias("flex.messaging.messages.CommandMessage", CommandMessage);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.CommandMessage", CommandMessage);
            };
            try {
                if (getClassByAlias("DSC") == null){
                    registerClassAlias("DSC", CommandMessageExt);
                };
            } catch(e:Error) {
                registerClassAlias("DSC", CommandMessageExt);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.ErrorMessage") == null){
                    registerClassAlias("flex.messaging.messages.ErrorMessage", ErrorMessage);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.ErrorMessage", ErrorMessage);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.HTTPMessage") == null){
                    registerClassAlias("flex.messaging.messages.HTTPMessage", HTTPRequestMessage);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.HTTPMessage", HTTPRequestMessage);
            };
            try {
                if (getClassByAlias("flex.messaging.messages.MessagePerformanceInfo") == null){
                    registerClassAlias("flex.messaging.messages.MessagePerformanceInfo", MessagePerformanceInfo);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.messages.MessagePerformanceInfo", MessagePerformanceInfo);
            };
            try {
                if (getClassByAlias("flex.messaging.io.ObjectProxy") == null){
                    registerClassAlias("flex.messaging.io.ObjectProxy", ObjectProxy);
                };
            } catch(e:Error) {
                registerClassAlias("flex.messaging.io.ObjectProxy", ObjectProxy);
            };
            var styleNames:* = ["strokeColor", "fontWeight", "modalTransparencyBlur", "rollOverColor", "textRollOverColor", "backgroundDisabledColor", "textIndent", "barColor", "fontSize", "kerning", "footerColors", "textAlign", "separatorWidth", "disabledIconColor", "fontStyle", "dropdownBorderColor", "modalTransparencyDuration", "textSelectedColor", "strokeWidth", "selectionColor", "modalTransparency", "fontGridFitType", "selectionDisabledColor", "disabledColor", "fontAntiAliasType", "modalTransparencyColor", "alternatingItemColors", "leading", "shadowColor", "iconColor", "dropShadowColor", "separatorColor", "themeColor", "letterSpacing", "fontFamily", "color", "fontThickness", "errorColor", "headerColors", "fontSharpness", "textDecoration"];
            var i:* = 0;
            while (i < styleNames.length) {
                StyleManager.registerInheritingStyle(styleNames[i]);
                i = (i + 1);
            };
        }

    }
}//package 
