public class queueable_SyncGreenhouseCandidate implements Queueable { 
    
    private Integer pageCount;
    private Sync_Log__c syncLog;
    
    public queueable_SyncGreenhouseCandidate(Integer pageCount){
        this.pageCount = pageCount;
        this.syncLog = new Sync_Log__c(Candidates_Synced__c = 0, Jobs_Synced__c = 0, Applications_Synced__c = 0, Last_Sync_Date_Time__c = Datetime.Now());
    }
    
    public queueable_SyncGreenhouseCandidate(Integer pageCount, Sync_Log__c syncLog){
        this.pageCount = pageCount;
        this.syncLog = syncLog;
    }
    
    public void execute(QueueableContext context) {
        
        Integer noOfCandidatesProcessed = greenhouseApiHelper.greenhouseCandidates(null,pageCount);
        syncLog.Candidates_Synced__c += noOfCandidatesProcessed;
        
        if(noOfCandidatesProcessed == 50 && pageCount < 4){
             
            System.enqueueJob(new queueable_SyncGreenhouseCandidate(pageCount++, syncLog));
        }
        else{
            System.enqueueJob(new queueable_SyncGreenhouseJob(1, syncLog));
        }
        
    }
}