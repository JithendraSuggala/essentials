public class OpportunityHandler {
    public static void isOppClosedWon(List<Opportunity> newOppList, Map<Id,Opportunity>oldOppMap){
        List<Task> tasksTobeInserted = new List<Task>(); 
        for(Opportunity Opp: newOppList){  
            Opportunity oldOpp = oldOppMap.get(Opp.id);
            if(oldOpp.StageName != Opp.StageName && Opp.StageName == 'Closed Won' && Opp.Amount >100000){
                Task t = new Task();
                t.Subject ='Followup on '+ Opp.Name + ' Opportunity';
                t.WhatId = Opp.Id;
                t.OwnerId = Opp.OwnerId;
                t.ActivityDate = system.today()+2;
                tasksTobeInserted.add(t);
            }
        }      
        if(tasksTobeInserted.size()>0){
            insert tasksTobeInserted;
        }
        
    }
    public static void checkOpportunityStatus(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap ){
        //System.debug('In checkOpportunityStatus Method');
        set<Id> AccountIds = new Set<Id>();
        for(Opportunity Opp : newOppList){
            Boolean isRelevant = false;
            if(Opp.AccountId != Null){
                if(oldOppMap == null){
                    isRelevant = true;
                }
                else{
                    if(Opp.StageName!= oldOppMap.get(Opp.Id).StageName){
                        isRelevant = true;
                    }
                }
            }
            if(isRelevant){
                AccountIds.add(Opp.AccountId);
                system.debug('Accounts Added --> '+AccountIds);
            }
        }
        Map<Id,List<Opportunity>> AccountswithOpportunities = new Map<Id,List<Opportunity>>();
        for(Opportunity O :[Select Id,StageName,AccountId from Opportunity where AccountId in :AccountIds]){
            if(!AccountswithOpportunities.containsKey(O.AccountId)){
                AccountswithOpportunities.put(O.AccountId,new List<Opportunity>());
            }
            AccountswithOpportunities.get(O.AccountId).add(O);
        }
        List<Account> accountsToBeUpdated = new List<Account>();
        for(Id AccId : AccountswithOpportunities.keySet()){
            Integer openOpps =0;
            Integer closedOpps =0;
            for(Opportunity O : AccountswithOpportunities.get(AccId)){
                if(O.StageName == 'Closed Won'){
                    ++closedOpps;
                }
                else{
                    ++openOpps;
                }
            }
            system.debug('Open Opportunities: '+openOpps+' Closed Opportunities: '+closedOpps);
            accountsToBeUpdated.add(new Account(Id =AccId, OpenOpportunities__c= openOpps, ClosedOpportunities__c= closedOpps));
        }
        if(!accountsToBeUpdated.isEmpty()){
            update accountsToBeUpdated;
        }
    }
    public static void OppStageBlockHandler(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> OppIdset = new Set<Id>();
        for(Opportunity o: newOppList){
            if(o.StageName != oldOppMap.get(o.Id).StageName){
                OppIdset.add(o.Id);
            }
        }
        if(!OppIdset.isEmpty()){return;}
        //List<Opportunity> allOpportunities =[select Id,StageName from Opportunity where Id in:OppList];
        Map<Id,ProcessInstance> approvalMap = new Map<Id,ProcessInstance>();
        for(ProcessInstance pi : [Select Id,TargetObjectId,Status from ProcessInstance 
                                  where TargetObjectId in:OppIdset
                                  AND Status ='Pending']){
                                      approvalMap.put(pi.TargetObjectId,pi);
                                  }
        for(Opportunity o :newOppList){
            if(approvalMap.ContainsKey(o.Id)){
                o.StageName = oldOppMap.get(o.Id).StageName;
                o.addError('You can\'t update the Stage Name when Approval is pending');
            }
            
        }
    }
    public static void updateAverageDealSize(List<Opportunity> newOppList){
        Set<Id> accIdSet = new Set<Id>();
        for(Opportunity o: newOppList){
            if(o.AccountId != null){
                accIdset.add(o.AccountId);
            }
        }
        Map<Id,Decimal> accountAvg= new Map<Id,Decimal>();
        for(aggregateResult ar: [Select AccountId,Avg(Amount) avgAmount from Opportunity GROUP BY AccountId ]){
            accountAvg.put((Id)ar.get('AccountId'),(Decimal)ar.get('avgAmount'));
        }
        List<Account> updatedAccounts = new List<Account>();
        for(Id accId : accIdSet){
            Decimal averageAmount = accountAvg.get(accId);
            Account a = new Account(Id = accId,Description ='Average Opp Amount is '+averageAmount );
            updatedAccounts.add(a);
        }
        if(!updatedAccounts.isEmpty()){
            update updatedAccounts;
        }
    }
    public static void updateAmountonAccount(List<Opportunity> newOppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdset = new Set<Id>();
        for(Opportunity o: newOppList){
            if(o.Amount!=null && o.Amount!= oldOppMap.get(o.Id).Amount && o.AccountId != null){
                accIdSet.add(o.AccountId);
            }
        }
        List<Opportunity> allOppList =[select id from Opportunity where AccountId in:accIdset];
        List<AggregateResult> ar =[select AccountId,SUM(Amount) total from Opportunity where AccountId in:accIdset GROUP BY AccountId];
        
        List<Account> accountsToUpdate = new List<Account>();
        for(AggregateResult a : ar){
            Id accId = (Id)a.get('AccountId');
            Decimal sum= (Decimal)a.get('total');
            
            Account acc = new Account();
            acc.Id = accId;
            acc.Description='Total Sum is:- '+sum;
            accountsToUpdate.add(acc);
        }
        if(accountsToUpdate.size()>0){
            update accountsToUpdate;
        }
    }
    public static void updateApplicableDiscount(List<Opportunity> newOppList,Map<Id,Opportunity>oldOppMap,Boolean isUpdateOperation){
        //get all the metadata which will be helpful in assigning discount
        Map<String,	Discount_Config__mdt> DiscountMap =	Discount_Config__mdt.getAll();
        
        //Loop through all the opportunities
        for(Opportunity o : newOppList){
            //check if update operation is performed
            if(isUpdateOperation && oldOppMap != null){
                if(o.Region__c == oldOppMap.get(o.Id).Region__c && o.ProductCategory__c == oldOppMap.get(o.Id).ProductCategory__c){
                    continue;
                }}
            //check if insert is being performed
            else if(isUpdateOperation == false && oldOppMap == null){
                if(String.isEmpty(o.Region__c) || String.isEmpty(o.ProductCategory__c)){
                    continue;
                }
            }
            //build a string which can be used to identify custom metadata record
            String key =o.ProductCategory__c+o.Region__c;
            
            //updating ApplicableDiscount__c value
            if(DiscountMap.containsKey(key)){
                o.ApplicableDiscount__c=DiscountMap.get(key).DiscountPercentage__c;
            }
            else{
                o.ApplicableDiscount__c=0;
            }
        }
    }
}