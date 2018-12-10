global class schduleBatch_SyncGreenhouseApplication implements Schedulable{
    global void execute(SchedulableContext batchSync) {
       batch_SyncGreenhouseApplication batchApp = new batch_SyncGreenhouseApplication(1);  
       Database.executeBatch(batchApp);    
    }

}