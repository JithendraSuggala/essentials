public class ChainBatchApex implements Database.Batchable<sObject>{
    public Database.queryLocator start(Database.BatchableContext bc){
        return Database.getqueryLocator('select id,Description from Account');
    }
    public void execute(Database.BatchableContext bc,List<Account> accSubList){
        for(Account acc: accSubList){
            acc.Description='Update from Batch Apex';
        }
        update accSubList;
    }
    public void finish(Database.BatchableContext bc){
        system.debug('@@ chainBatchApex executed');
    }
}