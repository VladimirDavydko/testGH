global class schduleBatch_SyncGreenhouseCandidate implements Schedulable{
    global void execute(SchedulableContext batchSync) {
       batch_SyncGreenhouseCandidate batchCan = new batch_SyncGreenhouseCandidate(1);  
       Database.executeBatch(batchCan);    
    } 
}