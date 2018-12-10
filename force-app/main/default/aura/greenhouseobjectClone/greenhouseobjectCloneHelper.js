({
    /*** Function for update record according to object selected ****/
    getRecords : function(component, event, helper) {
        var actionRecords = component.get("c.getRecords");
        actionRecords.setParams({
            objName : component.get("v.objNameShow"),
            salesforceobj: component.get("v.MainObjectName")
        })
        
        actionRecords.setCallback(this, function(resp){          
            if(resp.getState() == 'SUCCESS'){
                if(resp.getReturnValue() != null){
                    
                    component.set("v.greenhouseMappingWrapperList", resp.getReturnValue());
                    console.log('Last Wrapper'+JSON.stringify(resp.getReturnValue()));
                    //console.log('dsfds'+component.get("v.activeSection"));
                    /*for(var i = 0; i < resp.getReturnValue().length; i++){
                        if(resp.getReturnValue()[i].greenhouseObject == component.get("v.activeSection")){
                        	component.set("v.lookupFields",resp.getReturnValue()[i].salesforceReferenceField);
                        }
                                                                
                    }*/
                    component.set("v.Spinner",false);
                    var actionGetSubObj = component.get("c.getChildObjects");
                    
                    actionGetSubObj.setParams({
                        greenhouseObj : component.get("v.objNameShow")
                    })
                    
                    actionGetSubObj.setCallback(this, function(res){          
                        if(res.getState() == 'SUCCESS'){
                            if(res.getReturnValue() != null){
                                component.set("v.subjectObjectNameList",res.getReturnValue());             
                            }
                        }
                    });
                    $A.enqueueAction(actionGetSubObj);
                }
            }
        });
        $A.enqueueAction(actionRecords);
    },
    clearMappingHelper : function(component, event, helper,salesforceObj) {
        //component.set("v.lookupFields",'');
        var greenHouseTable;
        var selectedObject = component.get("c.clearMappingList");
        if(component.find("accordion").get('v.activeSectionName') != undefined){
            greenHouseTable =component.find("accordion").get('v.activeSectionName');
        }else{
            greenHouseTable =component.get("v.objNameShow");
        }
        selectedObject.setParams({
            SubobjName : greenHouseTable,
            greenhouseStr : JSON.stringify(component.get("v.greenhouseMappingWrapperList")),
            salesforceObj: salesforceObj
        })
        
        selectedObject.setCallback(this, function(response){          
            if(response.getState() == 'SUCCESS'){
                component.set("v.greenhouseMappingWrapperList",response.getReturnValue());
            }
        });
        $A.enqueueAction(selectedObject);    
    },
    /*** Helper to get object name of searched ****/ 
    getSearchStringObjectName : function(component, event, helper,objName,listName) {
        var getObject = component.get('c.getObjectName');
        getObject.setParams({ 
            "searchString" : objName
        });
        
        var fieldOption=[];
        
        getObject.setCallback(this, function(a) {
            var state = a.getState();
            if(state === 'SUCCESS'){
                component.set(listName,a.getReturnValue());          
            }
        });
        $A.enqueueAction(getObject);
    },
    getobjectHelper: function(component, event, helper,objNameVar,listName) {
        component.set("v.Spinner", false);
        if(component.get(objNameVar) == '' || component.get(objNameVar) == undefined){
            helper.getSearchStringObjectName(component, event, helper,'',listName);
        }else{
            helper.getSearchStringObjectName(component, event, helper,component.get(objNameVar),listName);
        }
    },
    toggleToastHelper : function(component, event, helper,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type : type
        });
        toastEvent.fire();
    },
    
    getSelectedSearchFields : function(component, event, helper) { 
        
        var getField = component.get('c.getFieldName');
        getField.setParams({ 
            "objName" : component.get("v.MainObjectName"),
            "searchString" : component.get("v.lookupFields"),
            "refer" : true
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
    getAllReferenceFields : function(component, event, helper) {
        component.set("v.Spinner", false);
        if(component.get("v.lookupFields") == '' || component.get("v.lookupFields") == undefined){            
            var getField = component.get('c.getFieldName');
            
            getField.setParams({ 
                "objName" : component.get("v.MainObjectName"),
                "searchString" :'',
                "refer" : true
            });
            var fieldOption=[];
            getField.setCallback(this, function(a) {
                var state = a.getState();
                console.log('state '+state);
                if(state === 'SUCCESS'){
                    for (var key in a.getReturnValue()){                    
                        fieldOption.push({"class": "optionClass", label: a.getReturnValue()[key], value: key});
                    }
                    component.set("v.objectFieldList",fieldOption); 
                }
            });
            $A.enqueueAction(getField);
        }else{
            helper.getSelectedSearchFields(component, event, helper);
        }
    },
    
    getAllReferenceFieldsKeyUp : function(component, event, helper,searchText) {
        component.set("v.Spinner", false);
        if(searchText == '' || searchText == undefined){            
            var getField = component.get('c.getFieldName');
            
            getField.setParams({ 
                "objName" : component.get("v.MainObjectName"),
                "searchString" :'',
                "refer" : true
            });
            var fieldOption=[];
            getField.setCallback(this, function(a) {
                var state = a.getState();
                console.log('state '+state);
                if(state === 'SUCCESS'){
                    for (var key in a.getReturnValue()){                    
                        fieldOption.push({"class": "optionClass", label: a.getReturnValue()[key], value: key});
                    }
                    component.set("v.objectFieldList",fieldOption); 
                }
            });
            $A.enqueueAction(getField);
        }else{
            var getField = component.get('c.getFieldName');
            getField.setParams({ 
                "objName" : component.get("v.MainObjectName"),
                "searchString" : searchText,
                "refer" : true
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
        }
    } 
    
})