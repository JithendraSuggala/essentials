public class ContactTriggerHandler {
    
    public static void updateContactCount(set<Id> accountIds){
        map<Id,Integer> accountContactMap = new Map<Id,Integer>();
        for(AggregateResult ar:[select AccountId,count(Id) contactCount from contact where AccountId in :accountIds
                                GROUP BY AccountId])
        {
            accountContactMap.put((Id)ar.get('AccountId'),(Integer)ar.get('contactCount'));
        }
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accId:accountIds){
            Integer contactCount = accountContactMap.get(accId);
            accountsToUpdate.add(new account(id = accId, NumberofLocations__c =contactCount!= null? contactCount:0 ));
        }
        update accountsToUpdate;
    }
    public static void createFollowupTaskOnInsert(List<Contact> contactsList){
        List<Task> tasksToInsert = new List<Task>();
        for(Contact c : contactsList){
            Task t = new Task();
            t.OwnerId = c.OwnerId;
            t.Subject = 'Verify Contact Details';
            t.WhoId =c.Id;
            t.ActivityDate= System.today().addDays(7);
            
            tasksToInsert.add(t);
        }
        if(tasksToInsert.size()>0){
            insert tasksToInsert;
        }
    }
    public static void createFollowupTaskOnUpdate(Map<Id,Contact> oldMap,List<Contact> conList){
        List<Task> tasksToInsert = new List<Task>();
        for(contact c:conList){
            contact oldContact = oldMap.get(c.Id);
            if(oldContact.Email != c.Email){
                Task t = new Task();
                t.OwnerId = c.OwnerId;
                t.Subject = 'Verify Contact Email';
                t.WhoId =c.Id;
                t.ActivityDate= System.today().addDays(7);
                tasksToInsert.add(t);
            }
        }
        if(tasksToInsert.size()>0){
            insert tasksToInsert;
        }
    }
    public static void preventContactUpdate(List<Contact> newContacts,Map<Id,Contact> oldContactsMap){
        //System.debug('entered  ContactTriggerHandler.preventContactUpdate');
        for(Contact c: newContacts){
            if(oldContactsMap!= null && oldContactsMap.get(c.Id).LastModifiedById == userInfo.getUserId()){
                DateTime lastModified = oldContactsMap.get(c.Id).LastModifiedDate;
                //system.debug('lastModified '+lastModified);
                DateTime now = system.now();
                //system.debug('now '+now);
                
                Long timeDifferenceinMinutes = (now.getTime()-lastModified.getTime())/(1000*60);
                //system.debug('now.getTime() '+now.getTime()+' lastModified.getTime() '+ lastModified.getTime()+' timeDifferenceinMinutes: '+timeDifferenceinMinutes);
                if(timeDifferenceinMinutes < 120){
                    c.addError('You cannot update this Contact again within 2 hours of your last update.' );
                }
            }
        }
        
    }
    //This method checks if this contact is the one and only primary contact for contact's Account. 
    public static void isContactPrimary(List<Contact>newContactList,Map<Id,Contact> oldContactMap){
        Set<Id> accountIdSet = new Set<Id>();
        //Add all the Account Ids of Primary Accounts to a set
        for(Contact c: newContactList){
            if(c.AccountId!= null && c.Is_Primary_Contact__c){
                Boolean isBecomingPrimary = oldContactMap==Null || !oldContactMap.containsKey(c.Id)
                    || !oldContactMap.get(c.Id).Is_Primary_Contact__c ;
                if(isBecomingPrimary){
                    accountIdSet.add(c.AccountId);
                }
            }
        }
        //Query Existing Primary Contacts for Accounts
        Map<Id,set<Id>> accountHasPrimary = new Map<Id,set<Id>>();
        for(Contact c: [Select Id,AccountId,Is_Primary_Contact__c from Contact where AccountId in:accountIdSet and Is_Primary_Contact__c = true]){
            if(!accountHasPrimary.containsKey(c.AccountId)){
               accountHasPrimary.put(c.AccountId,new Set<Id>()); 
            }
            accountHasPrimary.get(c.AccountId).add(c.Id);
        }
        //Validate new Contacts
        for(Contact c: newContactList){
            if(c.AccountId != null && c.Is_Primary_Contact__c){
            if(accountHasPrimary.containsKey(c.AccountId)){
                c.addError('Only one Primary Contact is allowed per Account.');
            }else{
                accountHasPrimary.put(c.AccountId, new set<Id>());
            }
                accountHasPrimary.get(c.AccountId).add(c.Id);}
        }
    }
    public static void updateContactCountOnAccount(List<contact>ContactList){
        Set<Id>AccountIdSet = new Set<Id>();
        for(Contact c: ContactList){
            if(c.AccountId != Null){
            AccountIdSet.add(c.AccountId);
            }
        }
        
        Map<Id,Integer> accountsWithContactsMap = new map<Id,Integer>();
        
        for(aggregateResult ar : [select AccountId,COUNT(Id) contactCount from Contact where AccountId in:AccountIdSet GROUP BY AccountId]){
            
            accountsWithContactsMap.put((Id)ar.get('AccountId'),(Integer) ar.get('contactCount'));
        }
        
        List<Account> accountsToBeUpdated = new List<Account>();
        for(Id accId : AccountIdSet){
            Account acc = new Account(Id=accId,contactCount__c = accountsWithContactsMap.containsKey(accId) ? accountsWithContactsMap.get(accId) : 0) ;
            accountsToBeUpdated.add(acc);
        }
        if(!accountsToBeUpdated.isEmpty()){
            update accountsToBeUpdated;
        }
    }
    /*
    
    public static void handleAfterInsert(List<Contact> newContacts) {
        updateContactCount(newContacts, 1);
    }

    public static void handleAfterUndelete(List<Contact> undeletedContacts) {
        updateContactCount(undeletedContacts, 1);
    }

    public static void handleBeforeDelete(List<Contact> oldContacts) {
        updateContactCount(oldContacts, -1);
    }

    private static void updateContactCount(List<Contact> contacts, Integer delta) {
        Map<Id, Integer> accountContactDeltaMap = new Map<Id, Integer>();

        for (Contact con : contacts) {
            if (con.AccountId != null) {
                accountContactDeltaMap.put(con.AccountId,
                    accountContactDeltaMap.getOrDefault(con.AccountId, 0) + delta);
            }
        }

        if (accountContactDeltaMap.isEmpty()) return;

        List<Account> accountsToUpdate = [
            SELECT Id, ContactCount__c
            FROM Account
            WHERE Id IN :accountContactDeltaMap.keySet()
        ];

        for (Account acc : accountsToUpdate) {
            Integer change = accountContactDeltaMap.get(acc.Id);
            if (acc.ContactCount__c == null) {
                acc.ContactCount__c = 0;
            }
            acc.ContactCount__c = Math.max(0, acc.ContactCount__c + change);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    
}*/

    public static void updateAccountDesc(List<Contact> newContactsList){
        //Set<Id> AccIdSet = new set<Id>();
    Map<Id,String> ContactswithFirstName = new Map<Id,String>();
    for(Contact c: newContactsList){
        if(c.AccountId != null){
        ContactswithFirstName.put(c.AccountId,c.LastName);
        }
    }
    List<Account> accData =[Select id,Description from Account where id in:ContactswithFirstName.keySet()];
    List<Account> accToBeUpdated = new List<Account>();
    for(Account Acc: accData){  
        Acc.Description = ContactswithFirstName.get(Acc.Id);
        accToBeUpdated.add(acc);
    }
    if(!accToBeUpdated.isEmpty()){
        update accToBeUpdated;
    }
    }
    public static void handleOrphanContacts(List<Contact> newContactList){
        DefaultAccountConfig__mdt AcctId = DefaultAccountConfig__mdt.getInstance('Default_Account');
        for(Contact c: newContactList){
            if(String.isNotBlank(c.AccountId) && String.isNotBlank(AcctId.Default_Account_Id__c)){
                c.AccountId=AcctId.Default_Account_Id__c;
            }
            
        }
    }
    
}