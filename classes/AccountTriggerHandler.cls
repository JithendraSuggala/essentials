public with sharing class AccountTriggerHandler {
    
    public static void afterUpdate(List<Account> accList, Map<Id,Account> oldMap){
        //AccountTriggerHandler.updateName(accList, oldMap);)
        //AccountTriggerHandler.updatestatus(accList, oldMap);

    }
//update contact status if account status is inactive
    /*public static void updatestatus(List<Account> accList, Map<Id,Account> oldMap){
        List<Account> accToUpdate = new List<Account>();
        for(Account acc : accList){
            if(acc.status != oldMap.get(acc.Id).status && acc.status == 'Inactive'){
                accToUpdate.add(acc.Id);
            }
        }
        if(accToUpdate.size()>0){
            List<Contact> conList = [SELECT Id,Status FROM Contact WHERE AccountId IN :accToUpdate AND Status = 'Active'];
            for(Contact con : conList){
                con.Status = 'Inactive';
            }
            update conList;
        }
    }*/
}