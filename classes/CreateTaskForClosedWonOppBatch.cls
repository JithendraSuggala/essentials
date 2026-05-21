public class CreateTaskForClosedWonOppBatch implements Database.Batchable<Sobject>{
    
    private string query;
    
    public CreateTaskForClosedWonOppBatch(String query){
        this.query = query;
    }
    public database.queryLocator start(Database.BatchableContext bc){
        return database.getQueryLocator(query);
    }
    
    public void execute(Database.batchableContext bc, list<Opportunity> OppList){
        
        
        set<Id> accountIds = new set<Id>();
        List<Task> tasksToBeInserted = new List<Task>();
        for(Opportunity newOpp: oppList){
            accountIds.add(newOpp.AccountId);
        }

        Map<Id,Account> AccountMap = new Map<Id,Account>([select Id,OwnerId from Account where Id in :accountIds]);
               
        
        for(Opportunity Opp:OppList){
                Task newTask = new Task();
                newTask.WhatId = Opp.Id;
                newTask.Subject='Follow up with new customer';
                newTask.Status='Not Started';
                newTask.Priority='High';
                newTask.ActivityDate=System.today()+3;
                newTask.OwnerId = AccountMap.get(Opp.AccountId).OwnerId;
                tasksToBeInserted.add(newTask);
                }
            if(tasksToBeInserted.size()>0){
                insert tasksToBeInserted;
            }
    }
    public void finish(Database.batchableContext bc){
        system.debug('Batch Job -> CreateTaskForClosedWonOppBatch Executed Successfully');
    }

}