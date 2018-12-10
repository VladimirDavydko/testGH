/****************************************************************
* This class is used to parse the Greenhouse Candidates.
* Code Written by: Ajay Kumar
* on Date : 10/13/2018 4:10 AM
* Last Modified By Ajay Kumar ,  10/17/2018
*****************************************************************/

public class greenhouseApiHelper{
    
    //Method to get Greenhouse Candidates List
    public static Integer greenhouseCandidates(String candidateId,integer pageCount){
        Greenhouse__Greenhouse_Integration_Settings__c orgDefaultSetting = Greenhouse__Greenhouse_Integration_Settings__c.getInstance();
        list<Greenhouse_Integration_Setup__mdt> listGreenhouseSetup=[SELECT id,Greenhouse__Greenhouse_Endpoint__c from Greenhouse__Greenhouse_Integration_Setup__mdt];
        Integer response;
        
        if(listGreenhouseSetup.isempty()==false){
            map<String,String> mapHeaders =new map<String,String>();
            
            Blob headerValue = Blob.valueOf(orgDefaultSetting.Greenhouse__Harvest_API_Key__c+':');
            mapHeaders.put('Authorization','Basic '+EncodingUtil.base64Encode(headerValue));
            
            httpResponse candidateResponse;
            
            if(candidateId<>null){
                candidateResponse = callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/candidates?candidate_ids='+candidateId+'&per_page=1&page='+pageCount,'GET',mapHeaders,null);
                if(candidateResponse.getstatuscode()==200){
                    if(candidateResponse.getbody()!=null){
                        response=parseSobj(candidateResponse.getbody(),'Candidates',1);    
                    }
                }
            }else{
                Datetime lastSyncTime = [SELECT Id, Last_Sync_Date_Time__c FROM Sync_Log__c ORDER BY CreatedDate DESC LIMIT 1].Last_Sync_Date_Time__c;
                
                candidateResponse = callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/candidates/?per_page=50&page='+pageCount+'&updated_after='+ lastSyncTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''),'GET',mapHeaders,null);
                if(candidateResponse.getstatuscode()==200){
                    if(candidateResponse.getbody()!=null){
                        response=parseSobj(candidateResponse.getbody(),'Candidates',50);    
                    }
                }
            }
            
            
        }
        
        
        return response;
        
    }
    //Method to parse Greenhouse Candidate list in to contact list
    public static Integer parseSobj(String JSONString ,String greenHouseTable,integer count){
        list<GreenhouseCandidate> listGeenhouseCandidate= new list<GreenhouseCandidate>();
        list<greenhouseJob> listgreenhouseJob= new list<greenhouseJob>();
        
        list<greenhouseApplication> listgreenhouseApplication= new list<greenhouseApplication>();
        if(greenHouseTable=='Candidates'){
            listGeenhouseCandidate=GreenhouseCandidate.parse(JSONString);  
        }else if(greenHouseTable=='Jobs'){
            if(count==1){
                greenhouseJob gh;
                gh= greenhouseJob.parseSingle(JSONString);
                listgreenhouseJob.add(gh);
            }else{
                listgreenhouseJob=greenhouseJob.parse(JSONString);
            
            }
        }else if(greenHouseTable == 'Applications'){
            listgreenhouseApplication=greenhouseApplication.parse(JSONString);
        }
        
        
        list<sObject> sobjectListInsert=new list<sObject>();
        list<sObject> sobjectListUpdate=new list<sObject>();
        
        map<String,string> mapFielMap=new map<String,String>();
        map<String,String> mapObjectName=new map<String,String>();
        String parentObj;
        for(Greenhouse__DefaultGreenhouseMapping__mdt dfMap: getDefaultMapping(greenHouseTable)){
            if(dfMap.Greenhouse__Greenhouse_Parent_Table__c==null && dfMap.Greenhouse__Salesforce_Field__c<>null){
                mapFielMap.put(dfMap.Greenhouse__Greenhouse_Table__c+dfMap.Greenhouse__Greenhouse_Property__c,dfMap.Greenhouse__Salesforce_Field__c);
                mapObjectName.put(dfMap.Greenhouse__Greenhouse_Table__c+dfMap.Greenhouse__Greenhouse_Property__c,dfMap.Greenhouse__Salesforce_Object__c);
                parentObj=dfMap.Greenhouse__Salesforce_Object__c;
            }else if(dfMap.Greenhouse__Salesforce_Field__c<>null){
                mapFielMap.put(dfMap.Greenhouse__Greenhouse_Parent_Table__c+dfMap.Greenhouse__Greenhouse_Table__c+dfMap.Greenhouse__Greenhouse_Property__c,dfMap.Greenhouse__Salesforce_Field__c);
                mapObjectName.put(dfMap.Greenhouse__Greenhouse_Parent_Table__c+dfMap.Greenhouse__Greenhouse_Table__c+dfMap.Greenhouse__Greenhouse_Property__c,dfMap.Greenhouse__Salesforce_Object__c);
            }
        }
       
        for(Greenhouse__Greenhouse_Mappings__c custMap: getCustomMapping(greenHouseTable)){
            if(custMap.Greenhouse__Greenhouse_Parent_Table__c==null && custMap.Greenhouse__Salesforce_Field__c<>null){
                mapFielMap.put(custMap.Greenhouse_Object__c+custMap.Greenhouse__Greenhouse_Property__c,custMap.Greenhouse__Salesforce_Field__c);
                mapObjectName.put(custMap.Greenhouse__Greenhouse_Object__c+custMap.Greenhouse__Greenhouse_Property__c,custMap.Greenhouse__Salesforce_Object__c);
                parentObj=custMap.Greenhouse__Salesforce_Object__c;
            }else if(custMap.Greenhouse__Salesforce_Field__c<>null){
                mapFielMap.put(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse_Object__c+custMap.Greenhouse__Greenhouse_Property__c,custMap.Greenhouse__Salesforce_Field__c);
                mapObjectName.put(custMap.Greenhouse__Greenhouse_Parent_Table__c+custMap.Greenhouse_Object__c+custMap.Greenhouse__Greenhouse_Property__c,custMap.Greenhouse__Salesforce_Object__c);
            }
        }
        
        
        
        if(greenHouseTable=='Candidates'){
            String mainSoql='SELECT id,'+mapFielMap.get(greenHouseTable+'id')+' From '+parentObj+' WHERE '+ mapFielMap.get(greenHouseTable+'id')+' in: ';
            set<String> setCandidateId=new set<String>();
            for(greenhouseCandidate gHCandidate: listGeenhouseCandidate){
                if(mapFielMap.containskey(greenHouseTable+'id')){
                    if(gHCandidate.fieldName.get('id')<>null){
                        setCandidateId.add(gHCandidate.fieldName.get('id'));
                    }
                }
            }
            
            mainSoql=mainSoql+'setCandidateId';
            map<String,id> mapSobj=new map<String,id>();
            
            for(sobject sObj: database.query(mainSoql)){
                mapSobj.put(String.valueof(sObj.get(mapFielMap.get(greenHouseTable+'id'))),sObj.id);
            }
           
            for(greenhouseCandidate gHCandidate: listGeenhouseCandidate){
                sObject sobj=Schema.getGlobalDescribe().get(parentObj).newSObject() ;
                if(gHCandidate.fieldName<>null){
                    for(String st: gHCandidate.fieldName.keyset()){
                        if(mapFielMap.containskey(greenHouseTable+st)){
                            if(gHCandidate.fieldName.get(st)<>null){
                                if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                    sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                }else{
                                   sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                }
                            }
                        }
                    }
                    //System.debug('========gHCandidate.custom_fields.fieldValmap.'+gHCandidate.custom_fields.fieldValmap);
                    if(gHCandidate.custom_fields<>null){
                        if(gHCandidate.custom_fields.fieldValmap<>null){
                            for(String st: gHCandidate.custom_fields.fieldValmap.keyset()){
                                if(mapFielMap.containskey(greenHouseTable+st)){
                                    if(gHCandidate.fieldName.get(st)<>null){
                                        if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                            sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                        }else{
                                           sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(sobj.get('id')<>null){
                        sobjectListUpdate.add(sobj);
                    }else{
                        sobjectListInsert.add(sobj);
                    }
                }
            }
        }else if(greenHouseTable=='Jobs'){
            String mainSoql='SELECT id,'+mapFielMap.get(greenHouseTable+'id')+' From '+parentObj+' WHERE '+ mapFielMap.get(greenHouseTable+'id')+' in: ';
            set<String> setCandidateId=new set<String>();
            System.debug('===========listgreenhouseJob'+listgreenhouseJob);
            for(greenhouseJob gHCandidate: listgreenhouseJob){
                if(mapFielMap.containskey(greenHouseTable+'id')){
                    if(gHCandidate.fieldName.get('id')<>null){
                        setCandidateId.add(gHCandidate.fieldName.get('id'));
                    }
                }
            }
            System.debug('======setCandidateId====='+setCandidateId);
            mainSoql=mainSoql+'setCandidateId';
            map<String,id> mapSobj=new map<String,id>();
            
            for(sobject sObj: database.query(mainSoql)){
                mapSobj.put(String.valueof(sObj.get(mapFielMap.get(greenHouseTable+'id'))),sObj.id);
            }
            System.debug('======mapSobj====='+mapSobj);
            for(greenhouseJob gHCandidate: listgreenhouseJob){
                System.debug('===========gHCandidate'+gHCandidate.fieldName);
                sObject sobj=Schema.getGlobalDescribe().get(parentObj).newSObject() ;
                if(gHCandidate.fieldName<>null){
                    for(String st: gHCandidate.fieldName.keyset()){
                        if(mapFielMap.containskey(greenHouseTable+st)){
                            if(gHCandidate.fieldName.get(st)<>null){
                                if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                    sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                }else{
                                   sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                }
                            }
                        }
                    }
                    //System.debug('========gHCandidate.custom_fields.fieldValmap.'+gHCandidate.custom_fields.fieldValmap);
                    if(gHCandidate.custom_fields<>null){
                        if(gHCandidate.custom_fields.fieldValmap<>null){
                            for(String st: gHCandidate.custom_fields.fieldValmap.keyset()){
                                if(mapFielMap.containskey(greenHouseTable+st)){
                                    if(gHCandidate.fieldName.get(st)<>null){
                                        if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                            sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                        }else{
                                           sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(sobj.get('id')<>null){
                        sobjectListUpdate.add(sobj);
                    }else{
                        sobjectListInsert.add(sobj);
                    }
                }
            }
        }else if(greenHouseTable == 'Applications'){
            String mainSoql='SELECT id,'+mapFielMap.get(greenHouseTable+'id')+' From '+parentObj+' WHERE '+ mapFielMap.get(greenHouseTable+'id')+' in: ';
            set<String> setCandidateId=new set<String>();
            for(greenhouseApplication gHCandidate: listgreenhouseApplication){
                if(mapFielMap.containskey(greenHouseTable+'id')){
                    if(gHCandidate.fieldName.get('id')<>null){
                        setCandidateId.add(gHCandidate.fieldName.get('id'));
                    }
                }
            }
            
            mainSoql=mainSoql+'setCandidateId';
            map<String,id> mapSobj=new map<String,id>();
            
            for(sobject sObj: database.query(mainSoql)){
                mapSobj.put(String.valueof(sObj.get(mapFielMap.get(greenHouseTable+'id'))),sObj.id);
            }
           
            for(greenhouseApplication gHCandidate: listgreenhouseApplication){
                sObject sobj=Schema.getGlobalDescribe().get(parentObj).newSObject() ;
                if(gHCandidate.fieldName<>null){
                    for(String st: gHCandidate.fieldName.keyset()){
                        if(mapFielMap.containskey(greenHouseTable+st)){
                            if(gHCandidate.fieldName.get(st)<>null){
                                if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                    sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                }else{
                                   sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                }
                            }
                        }
                    }
                    //System.debug('========gHCandidate.custom_fields.fieldValmap.'+gHCandidate.custom_fields.fieldValmap);
                    if(gHCandidate.custom_fields<>null){
                        if(gHCandidate.custom_fields.fieldValmap<>null){
                            for(String st: gHCandidate.custom_fields.fieldValmap.keyset()){
                                if(mapFielMap.containskey(greenHouseTable+st)){
                                    if(gHCandidate.fieldName.get(st)<>null){
                                        if(mapSobj.containskey(gHCandidate.fieldName.get(st))){
                                            sobj.put('id',mapSobj.get(gHCandidate.fieldName.get(st)));
                                        }else{
                                           sobj.put(mapFielMap.get(greenHouseTable+st),covertFieldValue(parentObj,mapFielMap.get(greenHouseTable+st),gHCandidate.fieldName.get(st)));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(sobj.get('id')<>null){
                        sobjectListUpdate.add(sobj);
                    }else{
                        sobjectListInsert.add(sobj);
                    }
                }
            }
        }
        
        System.debug('======sobjectListInsert'+sobjectListInsert);
         System.debug('======sobjectListInsert'+sobjectListInsert.size());
        if(sobjectListInsert.isempty()==false){
            DATABASE.INSERT(sobjectListInsert,false);
        }
        System.debug('======sobjectListUpdate'+sobjectListUpdate);
        System.debug('======sobjectListUpdate'+sobjectListUpdate.size());
        if(sobjectListUpdate.isempty()==false){
            DATABASE.UPDATE(sobjectListUpdate,false);
        }
        
        return (sobjectListInsert.size() + sobjectListUpdate.size());
    }
    
   
    public static object covertFieldValue(String sObjectName, String field,String value){
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult r = t.getDescribe();
        
        Schema.DescribeFieldResult f;
        if(r.fields.getMap().containskey(field)){
            f = r.fields.getMap().get(field).getDescribe();
        }else{
            System.debug('===='+field+'not contains');
        }
        
        
        if(field <> null && f <>null){
            if(f.getType()== Schema.DisplayType.Date){
                return date.valueOf(value);
            }
            
            if(f.getType() == Schema.DisplayType.String || f.getType()== Schema.DisplayType.URL || f.getType()== Schema.DisplayType.TextArea){
                return String.valueOf(value);
            }
            
            if(f.getType() == Schema.DisplayType.Double){
                return Decimal.valueOf(value);
            }
            
            if(f.getType()== Schema.DisplayType.Integer){
                return Integer.valueOf(value);
            }
            
            if(f.getType()== Schema.DisplayType.Boolean){
                return boolean.valueOf(value);
            }
            
            if(f.getType() == Schema.DisplayType.datetime){
                return convertDatetime(value);
            }
        }
        
        return null;
    }
    
    //Method to get Greenhouse Jobs
    public static Integer greenhouseJobs(String jobid,integer pageCount){
        Greenhouse__Greenhouse_Integration_Settings__c orgDefaultSetting = Greenhouse__Greenhouse_Integration_Settings__c.getInstance();
        list<Greenhouse_Integration_Setup__mdt> listGreenhouseSetup=[SELECT id,Greenhouse_Endpoint__c from Greenhouse_Integration_Setup__mdt];
        Integer response;
                        
        if(listGreenhouseSetup.isempty()==false){
            map<String,String> mapHeaders =new map<String,String>();
           
            Blob headerValue = Blob.valueOf(orgDefaultSetting.Greenhouse__Harvest_API_Key__c+':');
            mapHeaders.put('Authorization','Basic '+EncodingUtil.base64Encode(headerValue));
            integer count;
            
            
            List<greenhouseJob> listgreenhouseJob =new list<greenhousejob>();
            httpResponse jobResponse;
            if(jobid <> null){
                jobResponse= callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/jobs/'+jobid+'?per_page=2&page='+pageCount ,'GET',mapHeaders,null);
                if(jobResponse.getstatuscode()==200){
                    
                    response=parseSobj(jobResponse.getbody(),'Jobs',1);
                }
            }else{
                Datetime lastSyncTime = [SELECT Id, Last_Sync_Date_Time__c FROM Sync_Log__c ORDER BY CreatedDate DESC LIMIT 1].Last_Sync_Date_Time__c;
                
                jobResponse= callApi(listGreenhouseSetup[0].Greenhouse__Greenhouse_Endpoint__c+'/jobs?per_page=50&page='+pageCount+'&updated_after='+ lastSyncTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''),'GET',mapHeaders,null);
                if(jobResponse.getstatuscode()==200){
                    response=parseSobj(jobResponse.getbody(),'Jobs',50);
                   
                }
            }
                
        }
        
        return response;
        
    }
    //Method to get Greeenhouse Applications
    public static Integer greenhouseApplications(String applicationid,integer pageCount){
        Greenhouse__Greenhouse_Integration_Settings__c orgDefaultSetting = Greenhouse__Greenhouse_Integration_Settings__c.getInstance();
        list<Greenhouse__Greenhouse_Integration_Setup__mdt> listGreenhouseSetup=[SELECT id,Greenhouse__Greenhouse_Endpoint__c from Greenhouse__Greenhouse_Integration_Setup__mdt];
        Integer response;
        List<greenhouseapplication> listgreenhouseapplication=new list<greenhouseapplication>();
        if(listGreenhouseSetup.isempty()==false){
            map<String,String> mapHeaders =new map<String,String>();
           
            Blob headerValue = Blob.valueOf(orgDefaultSetting.Greenhouse__Harvest_API_Key__c+':');
            mapHeaders.put('Authorization','Basic '+EncodingUtil.base64Encode(headerValue));
            
            httpResponse applicationResponse;
            
            if(applicationid<>null){
                applicationResponse= callApi(listGreenhouseSetup[0].Greenhouse_Endpoint__c+'/applications/'+applicationid+'?per_page=1&page='+pageCount,'GET',mapHeaders,null);
                if(applicationResponse.getstatuscode()==200){
                    response=parseSobj(applicationResponse.getbody(),'Applications',1);
                }
            
            }else{
                Datetime lastSyncTime = [SELECT Id, Last_Sync_Date_Time__c FROM Sync_Log__c ORDER BY CreatedDate DESC LIMIT 1].Last_Sync_Date_Time__c;
                
                applicationResponse= callApi(listGreenhouseSetup[0].Greenhouse_Endpoint__c+'/applications?per_page=1&page='+pageCount+'&updated_after='+ lastSyncTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''),'GET',mapHeaders,null);
                if(applicationResponse.getstatuscode()==200){
                    response=parseSobj(applicationResponse.getbody(),'Applications',1);
                }
            }
        }

        
        return response;
    }
    //Helper method to call the HTTP 
    public static httpResponse callApi(String endPoint, String method, map<String,String> mapHeaders,String body){
        HttpRequest greenhouseRequest = new HttpRequest();
        greenhouseRequest.setEndpoint(endpoint);
        greenhouseRequest.setMethod(method);
        greenhouseRequest.settimeout(120000);
       
        for(String st: mapHeaders.keyset()){
            greenhouseRequest.setHeader(st, mapHeaders.get(st));
        }
        
        if(body<>null){
            greenhouseRequest.SetBody(Body); 
        }
        
        Http http = new Http();
        HTTPResponse greenhouseResponse = http.send(greenhouseRequest);
  
        return greenhouseResponse;        
    }
    
    public static datetime convertDatetime(String dateTValue){
        List<String> DateAndTimeList = dateTValue.split('T');
        List<String> dayList = DateAndTimeList[0].split('-'); 
        List<string> timeList = DateAndTimeList[1].split(':');
        return DateTime.newInstance(Integer.valueOf(dayList[0]), Integer.valueOf(dayList[1]), Integer.valueOf(dayList[2]), Integer.valueOf(timeList[0]), Integer.valueOf(timeList[1]), Integer.valueOf(timeList[2].split('\\.')[0]));
    }
    public static list<DefaultGreenhouseMapping__mdt> getDefaultMapping(String objName){
        list<DefaultGreenhouseMapping__mdt> listMetaData=[SELECT id,Greenhouse_Parent_Table__c,Greenhouse_Property__c,Greenhouse_Table__c,Salesforce_Field__c,Salesforce_Object__c from DefaultGreenhouseMapping__mdt where Greenhouse_Parent_Table__c=:objName];
        
        for(DefaultGreenhouseMapping__mdt dft: [SELECT id,Greenhouse_Parent_Table__c,Greenhouse_Property__c,Greenhouse_Table__c,Salesforce_Field__c,Salesforce_Object__c from DefaultGreenhouseMapping__mdt where Greenhouse_Table__c=:objName]){
            listMetaData.add(dft);
        }
        return listMetaData;
    }
    
    public static list<Greenhouse_Mappings__c> getCustomMapping(String objName){
        List<Greenhouse_Mappings__c> greenMappingList = [SELECT Id,Greenhouse_Parent_Table__c,Name,Sync_Field__c, Greenhouse_Property__c, Salesforce_Object__c,
                                                         Greenhouse_Object__c, Salesforce_Field__c FROM Greenhouse_Mappings__c
                                                         WHERE (Greenhouse_Parent_Table__c =: objName OR Greenhouse_Object__c=: objName) AND Sync_Field__c=true];
        return greenMappingList;
    }
    
    public static List<Greenhouse_Mappings__c> getMapping(String objName){
        return [SELECT id,name,Greenhouse_Object__c,Greenhouse_Property__c,Salesforce_Field__c,Salesforce_Object__c,Update_Rule__c from Greenhouse_Mappings__c where Greenhouse_Object__c=:objName AND Salesforce_Field__c != null];
    }
}