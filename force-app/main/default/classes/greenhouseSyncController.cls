/****************************************************************
* This class is used in greenhouseSync lightning component .
* Code Written by: Ajay Kumar
* on Date : 10/23/2018 12:00 AM
* Last Modified By Ajay Kumar ,  10/23/2018 
*****************************************************************/
public class greenhouseSyncController {
    @AuraEnabled
    public static string syncGreenhouse(Id recordId){
        String message;
        if(recordId<>null){
            Greenhouse__Greenhouse_Integration_Settings__c greenhouse = Greenhouse__Greenhouse_Integration_Settings__c.getorgdefaults();
            if(greenhouse.Greenhouse__ON__c==false){
                message='Error: Greenhouse Integration is disabled';
                return message;
            }else{
                String sObjName = recordId.getSObjectType().getDescribe().getName();
                if(sObjName =='Contact'){
                    if(greenhouse.Greenhouse__Sync_Candidates__c==false){
                        message='Error: Currently Candidates Syncing is OFF.Contact your System Administrator.';
                        return message;
                    }
                    
                    list<Contact> listContact=[Select id,Greenhouse__Greenhouse_io_ID__c from contact where id =:recordId];
                    
                    if(listContact.isempty()==false){
                        greenhouseApiHelper.greenhouseCandidates(listContact[0].Greenhouse__Greenhouse_io_ID__c,1);
                        message='Candidate record has been synced from Greenhouse.io';
                    }
                   
                }else if(sObjName =='Greenhouse__Application__c'){
                    if(greenhouse.Greenhouse__Sync_Applications__c==false){
                        message='Error: Greenhouse Application is disabled';
                        return message;
                    }
                    
                    list<Greenhouse__Application__c> listApplication=[Select id,Greenhouse__Greenhouse_io_ID__c from Greenhouse__Application__c where id =:recordId];
                    
                    if(listApplication.isempty()==false){
                        greenhouseApiHelper.greenhouseApplications(listApplication[0].Greenhouse__Greenhouse_io_ID__c,1);
                        message='Application record has been synced from Greenhouse.io';
                    }
                    
                }else if(sObjName =='Greenhouse__Job__c'){
                    if(greenhouse.Greenhouse__Sync_Jobs__c==false){
                        message='Error: Greenhouse Jobs is disabled';
                        return message;
                    }
                    list<Greenhouse__Job__c> listJobs=[Select id,Greenhouse__Greenhouse_io_ID__c from Greenhouse__Job__c where id =:recordId];
                    
                    if(listJobs.isempty()==false){
                        greenhouseApiHelper.greenhouseJobs(listJobs[0].Greenhouse__Greenhouse_io_ID__c,1);
                        
                        message='Job record has been synced from Greenhouse.io';
                    }
                   
                    
                }
        }
        }else{
            message='Record id doesn\'t exist.';
        }
        
        if(message ==null){
            message='Error: There is some issue.';
        }
        return message;
    }
    
     
}