public class TestBatchApex implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('select id,Description from Case');
    }
    public void execute(Database.BatchableContext bc, list<Case> smallList){
        for(Case c:smallList){
            c.Description='Description Updated from Batch Apex';
        }
        update smallList;
    }
    public void finish(Database.BatchableContext bc){
        system.debug('@@ TestBatchApex executed');
        Database.executeBatch(new chainBatchApex());
    }
}