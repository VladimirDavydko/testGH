({  
    /*********function for component load************/
    doInit : function(component, event, helper) {
        var getField = component.get('c.getFieldName');
        getField.setParams({ 
            "objName" : component.get("v.objName"),
            "searchString" :'',
            "refer" : false            
        });
        var currentValue = component.get('v.greenhouseMapping').salesforceField;
        var fieldOption=[];
        getField.setCallback(this, function(a) {
            var state = a.getState();
            if(state === 'SUCCESS'){
                for (var key in a.getReturnValue()){                    
                    fieldOption.push({"class": "optionClass", label: a.getReturnValue()[key], value: key});
                }
                
                if(component.find('jobFieldSelected') != 'undefined'){
                }               
            }
        });
        $A.enqueueAction(getField);
        
        var requiredfield = component.find(requiredField).get(v.greenhouseMapping.salesforceField);
        
        if(requiredfield == '' || requiredfield == undefined){
            component.set("v.required",true);
        }
        
    },
    
    /*********function for get all fields************/
    getAllFields : function(component, event, helper) {
        console.log('getAllFields'+component.get("v.greenhouseMapping.salesforceField"));
        component.set("v.greenhouseMapping.synField",false);
        if(component.get("v.greenhouseMapping.salesforceField") == '' || component.get("v.greenhouseMapping.salesforceField") == undefined){            
            var getField = component.get('c.getFieldName');
            
            getField.setParams({ 
                "objName" : component.get("v.objName"),
                "searchString" :'',
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
                }else if(state === 'ERROR'){
                    var errorMsg = a.getError();
                    console.log('errorMsg '+errorMsg[0].message);
                    helper.toggleToastHelper(component, event, helper,'error',errorMsg[0].message);
                }
            });
            $A.enqueueAction(getField);
        }else{
            console.log('else');
            helper.getSelectedSearchFields(component, event, helper);
        }
    },
    
    /*********function for Search functionality************/
    getSelectedFields : function(component, event, helper) {
        var target = event.target;  
        var searchText = target.value;
        
        component.set("v.greenhouseMapping.salesforceField",searchText);
        helper.getSelectedSearchFields(component, event, helper);
    },
    
    requiredFieldCheck : function(component, event, helper) {
        var requiredfield = component.find('requiredField').get('v.value');
        console.log('requiredfield'+requiredfield);
        if(requiredfield == '' || requiredfield == undefined){
            component.set("v.required",true);
        }
    },
    
    onclickOutside: function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var target = event.target;
                if(target.value == ''){
                    component.set("v.objectFieldList",[]);
                }
                             
            }), 1200
        );
     },
    
    /*********function for Set Selected Field************/
    getSelectedFieldName: function(component, event, helper) {

        var selectedItem = event.currentTarget;
        var fieldItem = selectedItem.dataset.label;

        if(fieldItem != 'No Results found'){
            component.set("v.greenhouseMapping.salesforceField",fieldItem);
            component.set("v.objectFieldList",[]);
        }
        if(fieldItem != ''){
           component.set("v.greenhouseMapping.synField",true); 
        }else{
           component.set("v.greenhouseMapping.synField",false);
        }
    },
    
})