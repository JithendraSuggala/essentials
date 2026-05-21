public class TaskTriggerHandler {
    public static void checkTaskStatus(List<Task> tasksList, Map<Id,Task> oldTaskMap){
        Set<Id> OppIds = new Set<Id>();
        for(Task newTask :tasksList){
            Boolean isRelevant = false;
            if(newTask.WhatId != null && String.valueOf(newTask.WhatId).startsWith('006')){
                if(oldTaskMap == null){
                    isRelevant = true;
                    //System.debug('Inside After Insert Scenario');
                }
                else{
                    Task oldTask = oldTaskMap.get(newTask.Id);
                    If(newTask.Status != oldTask.Status && (newTask.Status =='Completed' || oldTask.Status =='Completed')){
                        //System.debug('Inside After update Scenario');
                        isRelevant=true;}
                }}
            if(isRelevant){
                OppIds.add(newTask.WhatId);
               // System.debug('Opportunities added'+OppIds);
            }
        }
        
        if(OppIds.isEmpty()) return;
        //mapping Opportunities and tasks
        Map<Id,List<Task>> TasksWithOppMap = new Map<Id,List<Task>>();
        for(Task t: [select Id,WhatId,Status from Task where WhatId in:OppIds]){
            if(!TasksWithOppMap.containsKey(t.WhatId)){
                TasksWithOppMap.put(t.WhatId,new List<Task>());
                
            }
            TasksWithOppMap.get(t.WhatId).add(t);
            
        }
        //get the opportunities where all tasks are closed
        List<Opportunity> oppsToBeUpdated = new List<Opportunity>();
        For(Id OppId: TasksWithOppMap.keyset()){
            Boolean allTasksAreCompleted = true;
            for(Task t: TasksWithOppMap.get(OppId)){
                
                if(t.Status !='Completed'){
                    allTasksAreCompleted = false;
                    break;
                }
                
            }
            if(allTasksAreCompleted){
                //System.debug('ALl tasks are completed');
                oppsToBeUpdated.add(new Opportunity(Id = OppId,Description='All tasks are completed'));
            }
            else{
                oppsToBeUpdated.add(new Opportunity(Id = OppId,Description=null));
            }
        }
        if(!oppsToBeUpdated.isEmpty()){
            update oppsToBeUpdated;
        }  
    }
    
}