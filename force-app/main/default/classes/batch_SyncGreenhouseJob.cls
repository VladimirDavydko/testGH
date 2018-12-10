global class batch_SyncGreenhouseJob implements Database.Batchable<integer>, Database.AllowsCallouts, Database.Stateful{
    global integer countVar=0;
    global String successResult;
    
    global batch_SyncGreenhouseJob(integer count){
        countVar=count;
    }
    
    global Iterable<integer> start(Database.BatchableContext BC){
        list<integer> intList=new list<integer>();
        intList.add(countVar);
        return intList;
    }

    global void execute(Database.BatchableContext bc, list<integer> scope){
        successResult=greenhouseApiHelper.greenhouseJobs(null,countVar);
    }

    global void finish(Database.BatchableContext BC){
        countVar=countVar+1;
        if(countVar<=4){
            if(successResult!='complete'){
                database.executebatch(new batch_SyncGreenhouseJob(countVar));
            }else{
                Greenhouse_Integration_Settings__c greenhouseSetting = Greenhouse_Integration_Settings__c.getOrgDefaults();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {greenhouseSetting.Error_Email_Notifications__c};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Job Batch Status');
                mail.setHtmlBody('Hi,<br/><br/> Your Job sync batch is processed Successfully');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }else{
                Greenhouse_Integration_Settings__c greenhouseSetting = Greenhouse_Integration_Settings__c.getOrgDefaults();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {greenhouseSetting.Error_Email_Notifications__c};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Job Batch Status');
                mail.setHtmlBody('Hi,<br/><br/> Your Job sync batch is processed Successfully');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
    }
    
    

}