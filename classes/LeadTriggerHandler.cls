public class LeadTriggerHandler {
    
    public static void addTask(List<Lead> LeadsList){
        List<Task> tasksToCreate = new List<Task>();
        System.debug('Task Method created');
        for(Lead l: LeadsList){
            if(l.isConverted){
                Task newTask = new Task();
                newTask.WhoId =l.ConvertedContactId;
                newTask.OwnerId=l.OwnerId;
              	newTask.Status='Not Started';
                newTask.Subject = 'Follow-up with new Contact';
                newTask.WhatId=l.ConvertedAccountId;
                newTask.ActivityDate=System.Today().addDays(7);
                tasksToCreate.add(newTask);
            }
        }
        if(tasksToCreate.size()>0){
        insert tasksToCreate;
        }        
    }
}