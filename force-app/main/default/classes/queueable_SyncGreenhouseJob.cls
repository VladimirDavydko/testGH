public class queueable_SyncGreenhouseJob implements Queueable { 
    
    private Integer pageCount;
    private Sync_Log__c syncLog;
    
    public queueable_SyncGreenhouseJob(Integer pageCount, Sync_Log__c syncLog){
        this.pageCount = pageCount;
        this.syncLog = syncLog;
    }
    
    public void execute(QueueableContext context) {
        
        Integer noOfJobsProcessed = greenhouseApiHelper.greenhouseJobs(null,pageCount);
        syncLog.Jobs_Synced__c += noOfJobsProcessed;
        
        if(noOfJobsProcessed == 50 && pageCount < 4){
            System.enqueueJob(new queueable_SyncGreenhouseJob(pageCount++, syncLog));
        }
        else{
            System.enqueueJob(new queueable_SyncGreenhouseApplication(1, syncLog));
        }
        
    }
}