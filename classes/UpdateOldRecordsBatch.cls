public class UpdateOldRecordsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> accountIds = new Set<Id>();
        system.debug('Scope :-'+scope);
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        system.debug(accountIds);
        OpportunityProductHandler.updateAccountFields(accountIds);
    }
    
    public void finish(Database.BatchableContext bc) {
        // Optional: Add any post-batch processing here
    }
}