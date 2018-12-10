global class schduleBatch_SyncGreenhouseJob implements Schedulable{

    global void execute(SchedulableContext batchSync) {
       batch_SyncGreenhouseJob batchJob = new batch_SyncGreenhouseJob(1);  
       Database.executeBatch(batchJob);    
    }
}