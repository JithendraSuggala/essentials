public class testclassBatchApex implements Database.batchable<sObject>{
    public database.QueryLocator start(Database.batchableContext bc){
        return database.getQueryLocator('select Id from Account');
    }
    public void execute(database.BatchableContext bc, List<Account> scope){
        for(Account a:scope){
            
        }
    }
    public void finish(database.BatchableContext bc){
        
    }
}