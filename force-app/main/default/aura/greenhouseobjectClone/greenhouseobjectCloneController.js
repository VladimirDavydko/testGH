({
    /*********function for component load************/
    init: function (component,event, helper) {
        component.set("v.Spinner", true);
        
        var actionGetHarvestKey = component.get("c.getHiearchySettings");
        actionGetHarvestKey.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                //saving custom setting to attribute
                component.set("v.greenhouseSetting", response.getReturnValue());
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(actionGetHarvestKey);
        
        var actionGetOrgId = component.get("c.getOrgId");
        actionGetOrgId.setCallback(this, function(response){
            if(response !== null && response.getState() == 'SUCCESS'){
                component.set("v.orgId", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionGetOrgId);               
        
        var jobs = [{
            "label": "Jobs",
            "name": "2",
            "expanded": false,
            "items" :[{
                "label": "Job 1",
                "name": "3",
                "expanded": false,
                "items" :[]
            },{
                "label": "Job 2",
                "name": "4",
                "expanded": false,
                "items" :[]
            }]
        }]
        component.set('v.items', jobs);
        
        var candidates = [{
            "label": "Candidates",
            "name": "2",
            "expanded": false,
            
            "items" :[{
                "label": "Candidates 1",
                "name": "3",
                "expanded": false,
                "items" :[]
            },{
                "label": "Candidates 2",
                "name": "4",
                "expanded": false,
                "items" :[]
            }]
        }]
        component.set('v.candidates', candidates);
        
        var application = [{
            "label": "Application",
            "name": "2",
            "expanded": false,           
            "items" :[{
                "label": "Application 1",
                "name": "3",
                "expanded": false,
                "items" :[]
            },{
                "label": "Application 2",
                "name": "4",
                "expanded": false,
                "items" :[]
            }]
        }]
        component.set('v.application', application);
        //console.log("Tree Initiated");
    },
    
    /*********function for get all Objects************/
    getAllMainObjects : function(component, event, helper) {
        console.log('getAllMainObjects');
        helper.getobjectHelper(component, event, helper,'v.MainObjectName','v.MainobjectList');
    },
    onclickOutside : function(component, event, helper) {
        console.log('i am in main blur');
        window.setTimeout(
            $A.getCallback(function() {
                var target = event.target;
                console.log('main blur'+target.value);
                if(target.value == undefined){
                    component.set("v.MainobjectList",[]);
                }
                
            }), 1500
        );
        
    },
    /*********function for get all Objects************/
    getAllObjects : function(component, event, helper) {
        helper.getobjectHelper(component, event, helper,'v.ObjectName','v.objectList');
    },
    /*********function for Search functionality************/
    getSelectedMainObjects : function(component, event, helper) {        
        
        helper.getSearchStringObjectName(component, event, helper,component.get("v.MainObjectName"),'v.MainobjectList');
    },
    keyCheck : function(component, event, helper) {
        if(event.which == 8){
            component.set("v.confirmPopup",true);
        }
    },
    /*********function for Search functionality************/
    getSelectedObjects : function(component, event, helper) { 	
        helper.getSearchStringObjectName(component, event, helper,component.get("v.ObjectName"),'v.objectList');
    },
    /*********function for Set Selected Field************/
    clearObject: function(component, event, helper) {
        var searchString = component.get("v.MainObjectName");
        if(!searchString.trim()){
            component.set("v.confirmPopup",true);                                        
        }
    },
    /*********function for Set Selected Field************/
    getSelectedMainObjectName: function(component, event, helper) {
        
        var selectedItem = event.currentTarget;
        var fieldItem = selectedItem.dataset.label;
        helper.clearMappingHelper(component, event, helper,fieldItem);
        
        if(fieldItem != 'No Results found'){
            component.set("v.MainObjectName",fieldItem);            
            component.set("v.MainobjectList",[]);
        }               
    },
    /*********function for Set Selected Field************/
    getSelectedObjectName: function(component, event, helper) {
        console.log('getSelectedObjectName');
        var selectedItem = event.currentTarget;
        var fieldItem = selectedItem.dataset.label;
        helper.clearMappingHelper(component, event, helper,fieldItem);
        
        if(fieldItem != 'No Results found'){
            component.set("v.ObjectName",fieldItem);            
            component.set("v.objectList",[]);
        }               
    },
    
    handleKeyUp: function (cmp, evt) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var queryTerm = cmp.find('enter-search').get('v.value');
            alert('Searched for "' + queryTerm + '"!');
        }
    },
    
    /*********function for Sync Object************/
    syncNow: function(component,event,helper){
        console.log('i am in syncNow');
        var syncObj = component.get("c.syncGreenhouseCandidate");
        syncObj.setCallback(this, function(response){   
            if(response.getState() == 'SUCCESS'){
                helper.toggleToastHelper(component, event, helper,'success',' Batch is processed, we will inform you once its done.');
            }
        });
        $A.enqueueAction(syncObj);
    },
    
    /*********function for Open Modal Popup************/
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        
        component.set("v.Spinner", true);
        component.set("v.subjectObjectNameList",[]);
        component.set("v.isOpen", true);
        component.set("v.MainobjectList",[]);
        component.set("v.greenhouseMappingWrapperList",[]);
        
        var greenHouseTable;
        if(component.find("accordion").get('v.activeSectionName') != undefined){
            greenHouseTable =component.find("accordion").get('v.activeSectionName');
        }else{
            greenHouseTable =event.getSource().get("v.value");
        }
        
        var actionSalesforceObj = component.get("c.getSelectedObjName");
        console.log('actionSalesforceObj '+actionSalesforceObj);
        actionSalesforceObj.setParams({
            objName : greenHouseTable
        })
        
        actionSalesforceObj.setCallback(this, function(response){   
            if(response.getState() == 'SUCCESS'){
                console.log('i am in success');
                if(response.getReturnValue() != null){
                    console.log('i am under get returnvalue');
                    component.set("v.MainObjectName",response.getReturnValue());
                    component.set("v.MainObjectClone",response.getReturnValue());
                    helper.getRecords(component, event, helper);
                    
                }else{
                    console.log('i am out get returnvalue');
                    component.set("v.MainObjectName",'');
                    helper.getRecords(component, event, helper);
                    
                }
            }else if(response.getState() == 'ERROR'){
                var errorMsg = action.getError()[0].message;
                helper.toggleToastHelper(component, event, helper,'success',+errorMsg);
            }
        });
        $A.enqueueAction(actionSalesforceObj);
        
        component.set("v.objNameShow",event.getSource().get("v.value"));
    },
    Yes: function(component, event, helper) {
        console.log('i am in yes');
        component.set("v.confirmPopup",false);
        helper.clearMappingHelper(component, event, helper,'');
        component.set("v.MainobjectList",[]);
        component.set("v.objectList",[]);
        component.set("v.ObjectName",'');
        component.set("v.MainObjectName",'');
    },
    
    No: function(component, event, helper) {
        console.log('i am in no');
        component.set("v.confirmPopup",false);
        component.set("v.MainObjectName",component.get("v.MainObjectClone"));
        component.set("v.ObjectName",component.get("v.ObjectNameClone"));
        component.set("v.MainobjectList",[]);
        component.set("v.objectList",[]);
        
    },
    closeDropdown: function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var target = event.target;
                if(target.value == undefined){
                    component.set("v.objectList",[]);
                }
                
            }), 1500
        );
        
    },   
    
    /*********function for Save Mapping Records************/
    saveRecords: function(component, event, helper) {
        component.set("v.Spinner", true);
        component.set("v.showError",false);
        component.set("v.showErrorRequired",false);
        
        var lookup = component.get("v.lookupFields");
        console.log('lookup '+component.get("v.lookupFields"));
        //if(lookup != ''){
        
        var greenWrapList = component.get("v.greenhouseMappingWrapperList");
        for(var i =0; i < greenWrapList.length; i++){
            if(greenWrapList[i].required == true){
                if(greenWrapList[i].salesforceField != '' && greenWrapList[i].salesforceField != null){
                }else{
                    component.set("v.showErrorRequired",true);
                    component.set("v.Spinner", false);
                    helper.toggleToastHelper(component, event, helper,'error',' Required fields are blank');
                    return null;
                }
            }
        }
        
        if(component.get("v.showErrorRequired") == false){
            console.log('Last Wrapper'+JSON.stringify(component.get("v.greenhouseMappingWrapperList")));
            var action = component.get("c.saveMapValues");
                        action.setParams({
                            "greenhouseMappingList" : JSON.stringify(component.get("v.greenhouseMappingWrapperList")),
                        })
                        action.setCallback(this, function(response){
                            if(response.getState() == 'SUCCESS'){
                                component.set("v.isOpen", false);
                                component.set("v.Spinner", false);
                            }
                        });
                        $A.enqueueAction(action);
        }
        
        /*}else{
            component.set("v.Spinner", false);
            var items = component.get("v.subjectObjectNameList[0]");
            console.log('items = === '+items)
            helper.toggleToastHelper(component, event, helper,'error',items+' Lookup field is blank');
        }*/
    },
    
    /*********function for Close Modal Popup************/
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        component.set("v.confirmPopup",false);  
        component.set("v.isOpen", false);
        component.set("v.openNewRow", false);
    },
    
    handleSelect: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected
        var selectedMenuItemValue = event.getParam("value");        
    },
    
    /*** Function for save value of HarvestApi Key ***/
    Submit : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                component.set("v.Spinner", false);
                component.set("v.greenhouseSetting",res.getReturnValue());
                helper.toggleToastHelper(component, event, helper,'success',' API key successfully updated');               
            }
        });
        $A.enqueueAction(action);
    },
    
    /*** Function for save value of Error Notification ***/
    SubmitErrorNotification : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                component.set("v.Spinner", false);
                component.set("v.greenhouseSetting",res.getReturnValue());
                helper.toggleToastHelper(component, event, helper,'success', ' Notification Email Successfully Updated');
            }
        });
        $A.enqueueAction(action);
    },
    
    /*** Function for save value of Toggle Change ***/
    ToggleChange : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue().ON__c==true){                    
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Greenhouse integration enabled');
                }else{
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Greenhouse integration disabled');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*** Function for save value of Jobs Toggle Change ***/
    JobsToggleChange : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue().Sync_Jobs__c==true){                    
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Jobs Setting enabled');
                }else{
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Jobs Setting disabled');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*** Function for save value of Candidates Toggle Change ***/
    CandidatesToggleChange : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue().Greenhouse__Sync_Candidates__c==true){                   
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Candidates Setting enabled');
                }else{
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Candidates Setting disabled');
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    /*** Function for save value of Applications Toggle Change ***/
    ApplicationsToggleChange : function(component, event, helper) {
        component.set("v.Spinner", true);
        var action = component.get("c.saveValueNew");	
        action.setParams({  
            "GreenhouseIntegration": component.get("v.greenhouseSetting")
        });
        action.setCallback(this,function(res){
            if(res.getState()==="SUCCESS"){
                if(res.getReturnValue().Greenhouse__Sync_Applications__c==true){                    
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Applications Setting enabled');
                    
                }else{
                    component.set("v.Spinner", false);
                    component.set("v.greenhouseSetting",res.getReturnValue());
                    helper.toggleToastHelper(component, event, helper,'success',' Applications Setting disabled');
                    
                }
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
    
    getActiveSection : function(component,event,helper){
        component.set("v.activeSection",component.find("accordion").get('v.activeSectionName'));
        
        if(component.find("accordion").get('v.activeSectionName') != undefined){
            var action = component.get("c.getSelectedObjName");
            action.setParams({
                objName : component.find("accordion").get('v.activeSectionName')
            })
            
            action.setCallback(this, function(response){          
                if(response.getState() == 'SUCCESS'){
                    if(response.getReturnValue() != null){
                        component.set("v.ObjectName",response.getReturnValue());
                        component.set("v.ObjectNameClone",response.getReturnValue());
                    }else{
                        component.set("v.ObjectName",'');
                    }
                }
            });
            $A.enqueueAction(action);
            component.set("v.Spinner",false);
        }
    },
    showHidePanel : function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var fieldId = selectedItem.dataset.id;
        var tmpExp = component.get("v."+fieldId);
        
        if(tmpExp)
            component.set("v."+fieldId,false);
        else
            component.set("v."+fieldId,true);     
        
        var fieldItem = selectedItem.dataset.label;
        
    },
    
    //accordian initialization
    handleShowActiveSectionName: function (cmp, event, helper) {
        alert(cmp.find("accordion").get('v.activeSectionName'));
        
        
    },
    handleSetActiveSectionC: function (cmp) {
        cmp.find("accordion").set('v.activeSectionName', 'C');
    },
    
    /*********function for get all fields************/
    getAllFields : function(component, event, helper) {
        helper.getAllReferenceFields(component, event, helper);        
    },
    test: function(component, event, helper) {
        
        var target = event.target;  
        var searchText = target.value;
        console.log('searchText'+searchText);
        
        helper.getAllReferenceFieldsKeyUp(component, event, helper,searchText);         
    },
    
    /*********function for Set Selected Field************/
    getSelectedFieldName: function(component, event, helper) {
        
        var selectedItem = event.currentTarget;
        var fieldItem = selectedItem.dataset.label;
        
        if(fieldItem != 'No Results found'){
            component.set("v.lookupFields",fieldItem);
            component.set("v.objectFieldList",[]);
        }
    },
    
    lookupFieldClosed: function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var target = event.target;
                if(target.value == undefined){
                    component.set("v.objectFieldList",[]);
                }
                
            }), 1500
        );
        
    },
    
    setScriptLoaded : function(component, event, helper){
        
        $(document).ready(function(e){
            console.log("Document Ready State"); 
            var item =  $('.slds-tree__item').find('button').attr('title');
            var btn = $('.sync-accordian button');
            console.log(btn);
            console.log($('button.slds-button_icon').title);
            
        });
        
        
        //console.log($(this).removeAttr('title'));
        
        /*$(".slds-button").hover(function(){

        // Get the current title
        var title = $(this).attr("title");

        // Store it in a temporary attribute
        $(this).attr("tmp_title", title);

        // Set the title to nothing so we don't see the tooltips
        $(this).attr("title","");
        
        });*/
        
        $('.popup-table').click(function(e){
            console.log("Clicked");
            $('.city_predictions').remove();  
        });     
        $('.split-left').height($('.split-right').height()+"px");
        $('.split-right').click(function(e){
            $('.split-left').height($('.split-right').height()+"px");
        });
        
        
        
        console.log($('.slds-tree__item button').attr('title'));
        setTimeout(function() {
            $('button.slds-button_icon').each(function(){
                console.log($(this)); 
            });
        }, 10000);
        
        console.log($('button.slds-button_icon').attr('title'));
        
        $('.slds-tree__item').find("button.slds-button_icon").each(function(e){
            console.log("Each Running");
            $(this).attr('title');
            console.log($('.slds-tree__item').find("button.slds-button_icon").attr('title'));
            $('.slds-tree__item').find("button.slds-button_icon").attr('title','');          
        });        
        
    }
})