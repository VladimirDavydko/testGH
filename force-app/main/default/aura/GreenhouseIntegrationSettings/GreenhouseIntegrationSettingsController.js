({
    /*********function for component load************/
    doInit : function(component, event, helper) {
        var action = component.get("c.getHiearchySettings");
        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                //saving custom setting to attribute
                component.set("v.harvestApiKeyValue", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        var actionGetOrgId = component.get("c.getorgid");
        actionGetOrgId.setCallback(this, function(response){
            if(response !== null && response.getState() == 'SUCCESS'){
                component.set("v.orgId", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionGetOrgId);
    },
    
    /*** Function for save value of HarvestApi Key ***/
    Submit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValue");	
        action.setParams({  
            "harvestApiKey": component.find("harvestApiKey").get("v.value")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
})