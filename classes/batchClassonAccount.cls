public class batchClassonAccount implements database.Batchable<sObject>{
        public database.QueryLocator start(database.BatchableContext bc){
        return database.getQueryLocator('select id,LastActivityDate__c from Account');
    }
    public void execute(database.batchableContext bc, List<Account> scope){
        set<Id> accIds= new set<Id>();
        for(Account a: scope){
            accIds.add(a.Id);
        }
        List<Task> tasks =[select id,AccountId,ActivityDate 
                           from Task 
                           where AccountId IN :accIds 
                           ORDER BY AccountId,ActivityDate DESC];
        Map<Id, Date> accountToLastActivityDate = new Map<Id, Date>();
        for(Task t :tasks){
            if(!accountToLastActivityDate.containsKey(t.AccountId)){
                accountToLastActivityDate.put(t.AccountId,t.ActivityDate);
            }
        }
        List<Account> acctoUpdate = new List<Account>();
        for(Account a : scope){
            if(accountToLastActivityDate.containskey(a.Id)){
                a.LastActivityDate__c=accountToLastActivityDate.get(a.Id);
                acctoUpdate.add(a);
            }
            
        }
        if(acctoUpdate.size()>0){
            update acctoUpdate;
        }
    }
    public void finish(database.batchableContext bc){
        
    }
}