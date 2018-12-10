({
    getSelectedSearchFields : function(component, event, helper) { 	
        
        var getField = component.get('c.getFieldName');
        getField.setParams({ 
            "objName" : component.get("v.objName"),
            "searchString" : component.get("v.greenhouseMapping.salesforceField"),
            "refer" : false
        });
        
        var fieldOption=[];
        getField.setCallback(this, function(a) {
            var state = a.getState();
            if(state === 'SUCCESS'){
                
                for (var key in a.getReturnValue()){                    
                    fieldOption.push({"class": "optionClass", label: a.getReturnValue()[key], value: key});
                }
                component.set("v.objectFieldList",fieldOption);          
            }
        });
        $A.enqueueAction(getField);
    },
    toggleToastHelper : function(component, event, helper,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    }
})