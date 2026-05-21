public class testScheduleBatch implements database.batchable<sobject>{
    public Database.querylocator start(Database.batchableContext bc){
        return Database.getquerylocator('Select id,Description from Account');
    }
    public void execute(Database.batchableContext bc, List<Account> accBatch){
        for(Account acc: accBatch){
            DateTime now= DateTime.now();
            acc.description = 'Updated the Description at'+now;
        }
        update accBatch;
    }
    public void finish(Database.batchableContext bc){
        
    }
}