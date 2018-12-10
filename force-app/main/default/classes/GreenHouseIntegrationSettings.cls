/****************************************************************
* This class is used in GreenhouseConfiguration lightning component .
* Code Written by: Ajay Kumar
* on Date : 10/10/2018 11:00 AM
* Last Modified By Ajay Kumar ,  11/12/2018 
*****************************************************************/
public class GreenHouseIntegrationSettings {
    
    @AuraEnabled
    /*****This method is used to fetch fields from sobjects******/
    public static Map<String,String> getFieldName(String objName,String searchString,Boolean refer) {  
        Map<String,String> Fieldmap = new Map<String,String>();
        Map<String,String> fldmap = new Map<String,String>();
        System.debug('objName'+objName);
        if(objName<>null && objName<>''){      
            String sobjectName = objName;
            
            Schema.SObjectType gd = Schema.getGlobalDescribe().get(sobjectName);  
            DescribeSObjectResult objDef = gd.getDescribe();
            
            Map<String, SObjectField> fields = objDef.fields.getMap();        
            Set<String> fieldSet = fields.keySet();
            List<String> fldName = new List<String>();
            
            for(String s:fieldSet) {
                SObjectField fieldToken = fields.get(s);
                DescribeFieldResult selectedField = fieldToken.getDescribe();
                
                String fieldName = selectedField.getName(); //for API of fields
                String fieldLabel = selectedField.getLabel(); //for label of fields
                Schema.DisplayType fielddataType = selectedField.getType(); //for datatype of fields                
                
                if(refer != true){
                    if(selectedField.isUpdateable() || objName == 'Greenhouse__Candidate_Education__c'){
                        Fieldmap.put(fieldName,fieldLabel);
                        fldName.add(fieldName);
                    }

                }else  {
                   if(String.valueOf(fielddataType) == 'REFERENCE'){
                       if(selectedField.isUpdateable() && selectedField.isAccessible() && selectedField.isCreateable()){
                           Fieldmap.put(fieldName,fieldLabel);
                           fldName.add(fieldName);
                       }
                   }
                }
               
                /* if(selectedField.isUpdateable()){
                    Fieldmap.put(fieldName,fieldLabel);
                    fldName.add(fieldName); 
                }   */
                
            }    
            fldName.Sort();
            
            for(String keySet : fldName){   
                if(keySet.tolowercase().contains(searchString.toLowerCase())){
                    String srtField=Fieldmap.get(keySet);
                    fldmap.put(keySet,srtField); 
                }          
            }
            if (fldmap.isEmpty()){       
                fldmap.put('No Results found','No Results found');
            }
        }
        return fldmap;
    }
    @AuraEnabled
    /*****This method is used to fetch Objects ******/
    public static List<String> getObjectName(String searchString) {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<string> objectName = new List<string>();
        if(searchString<>null)
        for(Schema.SObjectType thisObj : gd.values()) {
            String name = thisObj.getDescribe().getName();
            if(!thisObj.getDescribe().isCustomSetting() && thisObj.getDescribe().getRecordTypeInfos().size() > 0 && thisObj.getDescribe().isCreateable() &&
               !name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed')){      
                   if(name.toLowerCase().contains(searchString.toLowerCase())){
                       objectName.add(name);
                   }
                   //objectName.add(name);
               }
        }
        objectName.sort();
        if (objectName.isEmpty()){       
            objectName.add('No Results found');
        }
        return objectName;
    }
    
    
    @AuraEnabled
    /********Method to save all Greenhouse Integration Setting custom setting**************/
    public static Greenhouse__Greenhouse_Integration_Settings__c saveValueNew(Greenhouse__Greenhouse_Integration_Settings__c GreenhouseIntegration){ 
        UPSERT GreenhouseIntegration;
        return GreenhouseIntegration;
    }
    
    @AuraEnabled
    /********Method to get Data from batch**************/
    public static void syncGreenhouseCandidate(){ 
        //database.executebatch(new batch_SyncGreenhouseCandidate(1));
    }
    
    @AuraEnabled
    public static String getSelectedObjName(String objName){
        List<Greenhouse__Greenhouse_Mappings__c> greenMappingList = [SELECT Id,Name, Greenhouse__Greenhouse_Property__c, Greenhouse__Salesforce_Object__c,
                                                         Greenhouse__Greenhouse_Object__c, Greenhouse__Salesforce_Field__c, Greenhouse__Update_Rule__c FROM Greenhouse__Greenhouse_Mappings__c
                                                         WHERE Greenhouse__Greenhouse_Object__c =: objName AND Greenhouse__Salesforce_Object__c<>null limit 1];
        if(greenMappingList.isEmpty() == false){
            return greenMappingList[0].Greenhouse__Salesforce_Object__c;
        }else{
            String sfoBj;
            list<DefaultGreenhouseMapping__mdt> listMetaData=[SELECT Greenhouse__Required__c,id,Greenhouse_Parent_Table__c,Greenhouse_Property__c,Greenhouse_Table__c,Greenhouse__Salesforce_Field__c,Greenhouse__Salesforce_Object__c from Greenhouse__DefaultGreenhouseMapping__mdt where Greenhouse__Greenhouse_Table__c=:objName];
        
            for(Greenhouse__DefaultGreenhouseMapping__mdt defu: listMetaData){
                sfoBj=defu.Greenhouse__Salesforce_Object__c;
                if(sfoBj<>null){
                    break;
                }
            }
            return sfoBj;
        }
    }
    @AuraEnabled
    public static String getSelectedReferenceField(String objName){
        List<Greenhouse__Greenhouse_Mappings__c> greenMappingList = [SELECT Id,Name, Greenhouse__Greenhouse_Property__c, Greenhouse__Salesforce_Object__c, Greenhouse__Salesforce_Reference_Field__c,
                                                         Greenhouse__Greenhouse_Object__c, Greenhouse__Salesforce_Field__c, Greenhouse__Update_Rule__c FROM Greenhouse__Greenhouse_Mappings__c
                                                         WHERE Greenhouse__Greenhouse_Object__c =: objName AND Greenhouse__Salesforce_Object__c<>null limit 1];
        if(greenMappingList.isEmpty() == false){
            return greenMappingList[0].Greenhouse__Salesforce_Reference_Field__c;
        }else{
            String sfoBj;
            //Need to check this query
            list<DefaultGreenhouseMapping__mdt> listMetaData=[SELECT Greenhouse__Required__c,id,Greenhouse_Parent_Table__c,Greenhouse_Property__c,Greenhouse_Table__c,Greenhouse__Salesforce_Field__c,Greenhouse__Salesforce_Object__c from Greenhouse__DefaultGreenhouseMapping__mdt where Greenhouse__Greenhouse_Table__c=:objName];
        
            for(Greenhouse__DefaultGreenhouseMapping__mdt defu: listMetaData){
                sfoBj=defu.Greenhouse__Salesforce_Object__c;
                if(sfoBj<>null){
                    break;
                }
            }
            return sfoBj;
        }
    }
    @AuraEnabled
    public static List<greenhouseMappingWrapper> clearMappingList(String SubobjName,String greenhouseStr,String salesforceObj){
        List<greenhouseMappingWrapper> greenhouseMapList = (List<greenhouseMappingWrapper>)System.JSON.deserialize(greenhouseStr, List<greenhouseMappingWrapper>.class);
        
        for(greenhouseMappingWrapper gren : greenhouseMapList ){
            if(SubobjName==gren.greenhouseObject){
                gren.salesforceField = '';
                gren.synField= false;
                gren.salesforceObjName=salesforceObj;
            }
        }
        return greenhouseMapList;
    }
    @AuraEnabled
    public static List<greenhouseMappingWrapper> clearMappingListReference(String SubobjName,String greenhouseStr,String salesforceObj){
        List<greenhouseMappingWrapper> greenhouseMapList = (List<greenhouseMappingWrapper>)System.JSON.deserialize(greenhouseStr, List<greenhouseMappingWrapper>.class);
        
        for(greenhouseMappingWrapper gren : greenhouseMapList ){
            if(SubobjName==gren.greenhouseObject){
               // gren.salesforceField = '';
                //gren.synField= false;
                gren.salesforceReferenceField=salesforceObj;
            }
        }
        return greenhouseMapList;
    }
    public static list<DefaultGreenhouseMapping__mdt> getDefaultMapping(String objName){
        list<Greenhouse__DefaultGreenhouseMapping__mdt> listMetaData=[SELECT id,Greenhouse__Required__c,Greenhouse__Greenhouse_Parent_Table__c,Greenhouse__Greenhouse_Property__c,Greenhouse__Greenhouse_Table__c,Greenhouse__Salesforce_Field__c,Greenhouse__Salesforce_Object__c from Greenhouse__DefaultGreenhouseMapping__mdt where Greenhouse__Greenhouse_Parent_Table__c=:objName];
        
        for(Greenhouse__DefaultGreenhouseMapping__mdt dft: [SELECT id,Greenhouse__Required__c,Greenhouse__Greenhouse_Parent_Table__c,Greenhouse__Greenhouse_Property__c,Greenhouse__Greenhouse_Table__c,Greenhouse__Salesforce_Field__c,Greenhouse__Salesforce_Object__c from Greenhouse__DefaultGreenhouseMapping__mdt where Greenhouse_Table__c=:objName]){
            listMetaData.add(dft);
        }
        return listMetaData;
    }
    
    public static list<Greenhouse__Greenhouse_Mappings__c> getCustomMapping(String objName){
        List<Greenhouse__Greenhouse_Mappings__c> greenMappingList = [SELECT Id,Greenhouse__Greenhouse_Parent_Table__c,Greenhouse__Salesforce_Reference_Field__c,Name,Greenhouse__Sync_Field__c, Greenhouse__Greenhouse_Property__c, Greenhouse__Salesforce_Object__c,
                                                         Greenhouse__Greenhouse_Object__c, Greenhouse__Salesforce_Field__c FROM Greenhouse__Greenhouse_Mappings__c
                                                         WHERE Greenhouse__Greenhouse_Parent_Table__c =: objName OR Greenhouse__Greenhouse_Object__c=: objName];
        return greenMappingList;
    }
    
    @AuraEnabled
    public static List<greenhouseMappingWrapper> getRecords(String objName,String salesforceobj){
        List<greenhouseMappingWrapper> greenhouseMapList = new List<greenhouseMappingWrapper>();
        
        
        list<Greenhouse__DefaultGreenhouseMapping__mdt> listDefaultMapping =getDefaultMapping(objName);
        List<Greenhouse__Greenhouse_Mappings__c> listCustomMapping = getCustomMapping(objName);
        
        map<String,Greenhouse__Greenhouse_Mappings__c> mapCustomMapping=new map<String,Greenhouse__Greenhouse_Mappings__c>();
        for(Greenhouse__Greenhouse_Mappings__c gren: listCustomMapping){
            if(gren.Greenhouse__Greenhouse_Parent_Table__c<>null){
                mapCustomMapping.put(gren.Greenhouse__Greenhouse_Parent_Table__c+gren.Greenhouse__Greenhouse_Object__c+gren.Greenhouse__Greenhouse_Property__c,gren);
            }else{
                mapCustomMapping.put(gren.Greenhouse__Greenhouse_Object__c+gren.Greenhouse__Greenhouse_Property__c,gren);
            }
        }
        for(DefaultGreenhouseMapping__mdt custMap: listDefaultMapping ){
            greenhouseMappingWrapper greenWrap = new greenhouseMappingWrapper();
            
            if(custMap.Greenhouse__Greenhouse_Parent_Table__c<>null){
                if(mapCustomMapping.containskey(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c)){
                    greenWrap.salesforceField = mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Field__c;
                    greenWrap.synField= mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Sync_Field__c;
                    greenWrap.salesforceObjName=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Object__c;
                    greenWrap.salesforceId=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).id;
                    greenWrap.salesforceReferenceField=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Reference_Field__c;
                }else{
                    greenWrap.salesforceField = custMap.Greenhouse__Salesforce_Field__c;
                    if(custMap.Greenhouse__Salesforce_Field__c<>null){
                        greenWrap.synField= true;
                    }else{
                        greenWrap.synField= false;
                    }
                    greenWrap.salesforceObjName=custMap.Greenhouse__Salesforce_Object__c;
                                        
                    if(custMap.Greenhouse__Salesforce_Object__c== null && objName==custMap.Greenhouse__Greenhouse_Table__c){
                        greenWrap.salesforceObjName=salesforceobj;
                    }
                   
                    
                }
            }else if(mapCustomMapping.containskey(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c)){
                    greenWrap.salesforceField = mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Field__c;
                    greenWrap.synField= mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Sync_Field__c;
                    greenWrap.salesforceObjName=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Object__c;
                    greenWrap.salesforceId=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).id;
                    greenWrap.salesforceReferenceField=mapCustomMapping.get(custMap.Greenhouse__Greenhouse_Table__c+custMap.Greenhouse__Greenhouse_Property__c).Greenhouse__Salesforce_Reference_Field__c;
            }else{
                greenWrap.salesforceField = custMap.Greenhouse__Salesforce_Field__c;
                if(custMap.Greenhouse__Salesforce_Field__c<>null){
                    greenWrap.synField= true;
                }else{
                    greenWrap.synField= false;
                }
                greenWrap.salesforceObjName=custMap.Greenhouse__Salesforce_Object__c;
                if(custMap.Greenhouse__Salesforce_Object__c== null && objName==custMap.Greenhouse__Greenhouse_Table__c){
                    greenWrap.salesforceObjName=salesforceobj;
                }
            }
            
            greenWrap.required=custMap.Greenhouse__Required__c;
            greenWrap.greenhouseProperty = custMap.Greenhouse__Greenhouse_Property__c;
            greenWrap.greenhouseObject=custMap.Greenhouse__Greenhouse_Table__c;
            greenWrap.greenhouseParentObject=custMap.Greenhouse__Greenhouse_Parent_Table__c;
            
            greenhouseMapList.add(greenWrap);
        }              
        
       if(objName<>null){
            for(String st: getGreenHouseProperty(objName)){
                greenhouseMappingWrapper greenWrap = new greenhouseMappingWrapper();
                
                if(mapCustomMapping.containskey(objName+st)){
                    greenWrap.salesforceField =mapCustomMapping.get(objName+st).Salesforce_Field__c;
                    greenWrap.synField= mapCustomMapping.get(objName+st).Sync_Field__c;
                    greenWrap.salesforceId =mapCustomMapping.get(objName+st).id;
                    greenWrap.salesforceObjName=mapCustomMapping.get(objName+st).Salesforce_Object__c;
                    greenWrap.salesforceReferenceField=mapCustomMapping.get(objName+st).Greenhouse__Salesforce_Reference_Field__c;
                }else{
                    greenWrap.salesforceField = '';
                    greenWrap.synField= false;
                    greenWrap.salesforceId ='';
                    greenWrap.salesforceObjName=salesforceobj;
                    greenWrap.salesforceReferenceField='';
                }
                greenWrap.greenhouseProperty = st;
                greenWrap.greenhouseObject=objName;
                greenWrap.required=false;
                greenWrap.greenhouseParentObject=objName;
                greenhouseMapList.add(greenWrap);
            }
        }
        
        
        return greenhouseMapList;
    }
    
   
    @AuraEnabled
    /********Method to save all Greenhouse Mapping custom setting**************/
    public static void saveMapValues(String greenhouseMappingList){ 
        
        List<greenhouseMappingWrapper> greenhouseMapList = (List<greenhouseMappingWrapper>)System.JSON.deserialize(greenhouseMappingList, List<greenhouseMappingWrapper>.class);
        List<Greenhouse__Greenhouse_Mappings__c> greenMappingList = new List<Greenhouse__Greenhouse_Mappings__c>();
        List<Greenhouse__Greenhouse_Mappings__c> greenDelMappingList= new list<Greenhouse__Greenhouse_Mappings__c>();
        
        
        Set<String> setFieldName=new set<String>();
        for(greenhouseMappingWrapper greenWrap : greenhouseMapList){
            if(greenWrap.salesforceField!='' && greenWrap.salesforceField!=null && greenWrap.greenhouseProperty!=null){
                Greenhouse__Greenhouse_Mappings__c greenMap = new Greenhouse__Greenhouse_Mappings__c();
                
                String recordName = greenWrap.greenhouseProperty +' '+ greenWrap.greenhouseObject; 

                if(recordName.length() > 30){
                    greenMap.Name = recordName.subString(0,30);
                }else{
                    greenMap.Name = recordName;
                }
                
                greenMap.Greenhouse__Salesforce_Field__c = greenWrap.salesforceField;
                greenMap.Greenhouse__Greenhouse_Property__c = greenWrap.greenhouseProperty;
                greenMap.Greenhouse__Salesforce_Object__c = greenWrap.salesforceObjName;
                
                if(greenWrap.greenhouseParentObject!=greenWrap.greenhouseObject){
                    greenMap.Greenhouse__Greenhouse_Parent_Table__c=greenWrap.greenhouseParentObject;
                }
                greenMap.Greenhouse__Sync_field__c=greenWrap.synField;
                if(greenWrap.salesforceId <> ''){
                    greenMap.Id = greenWrap.salesforceId;
                }
                greenMap.Greenhouse__Salesforce_Reference_Field__c=greenWrap.salesforceReferenceField;
                
                greenMap.Greenhouse__Greenhouse_Object__c=greenWrap.greenhouseObject;
                if(!setFieldName.contains(greenMap.Name)){
                    greenMappingList.add(greenMap);
                    setFieldName.add(greenMap.Name);
                }
            }else if(greenWrap.salesforceId !='' && greenWrap.salesforceId!= null){
                greenDelMappingList.add(new Greenhouse__Greenhouse_Mappings__c(id=greenWrap.salesforceId));
            }
        }
        
        if(greenDelMappingList.isEmpty()==false){
            DELETE greenDelMappingList;
        }
        System.debug('greenMappingList'+greenMappingList);
        if(greenMappingList.isEmpty() == false){
            upsert greenMappingList;
        }
    }
    
    @AuraEnabled
    /***Method to get all fields from the Greenhouse Integration Settings custom setting***/
    public static Greenhouse__Greenhouse_Integration_Settings__c getHiearchySettings(){
        return Greenhouse__Greenhouse_Integration_Settings__c.getorgdefaults();
    }
    
    @AuraEnabled
    /********Method to get OrganizationId**************/
    public static string getOrgId(){
        return UserInfo.getOrganizationId();
    }
    
    @AuraEnabled
    /********Method to get OrganizationId**************/
    public static List<string> getGreenHouseProperty(String objName){
        
        Greenhouse__Greenhouse_Integration_Settings__c orgDefaultSetting = Greenhouse__Greenhouse_Integration_Settings__c.getInstance();
        map<String,String> mapHeaders =new map<String,String>();
        Blob headerValue = Blob.valueOf(orgDefaultSetting.Greenhouse__Harvest_API_Key__c+':');
        mapHeaders.put('Authorization','Basic '+EncodingUtil.base64Encode(headerValue));
        List<String> options = new List<String>();
        list<Greenhouse_Integration_Setup__mdt> listGreenhouseSetup=[SELECT id,Greenhouse__Greenhouse_Endpoint__c from Greenhouse_Integration_Setup__mdt];
        if(objName<>null)
        if(objName.tolowercase()=='jobs'){
            httpResponse jobResponse= greenhouseApiHelper.callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/jobs?per_page=1&page=1','GET',mapHeaders,null);
            
            if(jobResponse.getstatuscode()==200){
                List<greenhouseJob> listgreenhouseJob= greenhouseJob.parse(jobResponse.getbody());
                if(listgreenhouseJob.isempty()==false){
                    
                    for(greenhouseJob gstCan: listgreenhouseJob){
                    
                            if(gstCan.custom_fields<>null){
                                
                                if(gstCan.custom_fields.name<>null){
                                    for(String st: gstCan.custom_fields.name){
                                        options.add(st);
                                    }
                                }
                            }
                       
                    }    
                }
            }            
            
        }else if(objName.tolowercase()=='applications'){
            httpResponse applicationResponse= greenhouseApiHelper.callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/applications?per_page=1&page=1','GET',mapHeaders,null);
            if(applicationResponse.getstatuscode()==200){
                List<greenhouseapplication> listgreenhouseapplication=greenhouseapplication.parse(applicationResponse.getbody());
                
                if(listgreenhouseapplication.isempty()==false){
                    for(greenhouseapplication gstCan: listgreenhouseapplication){
                        
                            if(gstCan.custom_fields<>null){
                                
                                if(gstCan.custom_fields.name<>null){
                                    for(String st: gstCan.custom_fields.name){
                                        options.add(st);
                                        
                                    }
                                    
                                }
                            }
                       
                    }    
                }
            }
        }else if(objName.tolowercase()=='candidates'){
            httpResponse candidateResponse = greenhouseApiHelper.callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/candidates/?per_page=1&page=1','GET',mapHeaders,null);
            
            if(candidateResponse.getstatuscode()==200){
               List<GreenhouseCandidate> listGeenhouseCandidate=GreenhouseCandidate.parse(candidateResponse.getbody());
                
                if(listGeenhouseCandidate.isempty()==false){
                   for(GreenhouseCandidate gstCan: listGeenhouseCandidate){
                            if(gstCan.custom_fields<>null){
                                if(gstCan.custom_fields.fieldValmap<>null){
                                    for(String st: gstCan.custom_fields.fieldValmap.keyset()){
                                        options.add(st);
                                    }
                               }
                            }
                       
                        
                    }
                }
                
            }
            
        }else{
            
        }
        options.Sort();
        
        return options;
    }
     
    @AuraEnabled
    /********Method to get Sub Object Name**************/
    public static List<String> getChildObjects(String greenhouseObj) { 
        List<String> subObjList=new list<String>();
        list<Greenhouse__DefaultGreenhouseMapping__mdt> listDefaultMapping =getDefaultMapping(greenhouseObj);
        if(greenhouseObj<>null){
            for(Greenhouse__DefaultGreenhouseMapping__mdt defMap: listDefaultMapping){
                if(defMap.Greenhouse__Greenhouse_Parent_Table__c<>null){
                    if(defMap.Greenhouse__Greenhouse_Parent_Table__c.tolowercase()==greenhouseObj.tolowercase() && !subObjList.contains(defMap.Greenhouse_Table__c)){
                        subObjList.add(defMap.Greenhouse__Greenhouse_Table__c);
                    }
                }
            }
        }
        return subObjList;
    }    
   
}