public class CaseTriggerHandler {
    public static void checkCaseOrigin(List<Case> caseList,Map<Id,Case> caseoldMap){
        //get all the accountIds which needs to be updated
        set<Id> accountIdsToUpdate = new set<Id>();
        for(Case newCaseRec: caseList){
            Case oldCaseRec = caseoldMap.get(newCaseRec.id);
            if(newCaseRec.Origin != oldCaseRec.Origin && newCaseRec.Origin =='Email' && newcaseRec.AccountId != null){
              
                    accountIdsToUpdate.add(newcaseRec.AccountId);
                
            }
        }
        system.debug('accountIdsToUpdate -> '+accountIdsToUpdate);
        if(accountIdsToUpdate.size()>0){
            List<Account> accountsToUpdate = [Select id,Active__c from Account where id IN :accountIdsToUpdate];
            for(Account acc: accountsToUpdate){
                acc.Active__c = 'Yes';
            }
            update accountsToUpdate;
            //system.debug('All the accounts were updated.');
        }
        List<Contact> contactsToUpdate= new List<Contact>();
        List<Contact> contactsRelatedToAccount = [select id,Is_Active__c,Is_Primary_Contact__c,AccountId from contact where AccountId IN :accountIdsToUpdate];
            for(Contact c: contactsRelatedToAccount){
                if(c.Is_Primary_Contact__c){
                    c.Is_Active__c=true;
                }
                else{
                    c.Is_Active__c=false;
                }
                contactsToUpdate.add(c);
            }
            if(contactsToUpdate.size()>0){
                update contactsToUpdate;
            }
        
    }
    
}