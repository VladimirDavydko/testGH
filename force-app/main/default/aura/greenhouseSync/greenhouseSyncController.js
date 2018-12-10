({
	/*********function for component load************/
    doInit : function(component, event, helper) {
        var action = component.get("c.syncGreenhouse");
        // set param to method  
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.Spinner", true);
                var str = response.getReturnValue();
                if(str.includes('Error:')){
                    component.set("v.Spinner", false);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire();
                    // Call helper function on error
                    helper.showToast('error', response.getReturnValue() );
                }else{
                    component.set("v.Spinner", false);
                    // Close the action panel on success
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire();
                    // Call helper function on success
                    helper.showToast('success', response.getReturnValue());
                    $A.get('e.force:refreshView').fire();
                    //window.location.reload();
                }
            }else{
                component.set("v.Spinner", false);
                // Call helper function on error
                helper.showToast('error', response.getReturnValue() );
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
    },
    
})