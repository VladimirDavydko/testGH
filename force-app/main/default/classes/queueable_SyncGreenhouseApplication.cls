public class queueable_SyncGreenhouseApplication implements Queueable { 
    
    private Integer pageCount;
    private Sync_Log__c syncLog;
    
    public queueable_SyncGreenhouseApplication(Integer pageCount, Sync_Log__c syncLog){
        this.pageCount = pageCount;
        this.syncLog = syncLog;
    }
    
    public void execute(QueueableContext context) {
        
        Integer noOfApplicationsProcessed = greenhouseApiHelper.greenhouseJobs(null,pageCount);
        syncLog.Applications_Synced__c += noOfApplicationsProcessed;
        
        if(noOfApplicationsProcessed == 50 && pageCount < 4){
            System.enqueueJob(new queueable_SyncGreenhouseApplication(pageCount++, syncLog));
        }
        else{
            insert syncLog;
            
            Greenhouse_Integration_Settings__c greenhouseSetting = Greenhouse_Integration_Settings__c.getOrgDefaults();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {greenhouseSetting.Error_Email_Notifications__c};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Status');
            mail.setHtmlBody('Hi,<br/><br/> Your Sync batch is processed Successfully <br/><br/> Candidates Processed: ' + syncLog.Candidates_Synced__c + ' <br/><br/> Jobs Processed: ' + syncLog.Jobs_Synced__c + ' <br/><br/> Applications Processed: ' + syncLog.Applications_Synced__c);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
    }
}