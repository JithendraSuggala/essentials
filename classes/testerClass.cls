public class testerClass {
    public static Boolean isFirsttime = true;
    public static void updateAccountDesc(List<Account> newAccList){
        List<Account> updatedAccList = new List<Account>();
        for(Account a: newAccList){
            a.Description='I got updated Via Code';
            updatedAccList.add(a);
            system.debug('Description --------->'+a.Description);
        }
        
    }
    public static void updateAccountWebsite(List<Account> newAccList){
        List<Account> updatedAccList = new List<Account>();
        for(Account a: newAccList){
             Account updatedAcc = new Account(Id = a.Id); 
            updatedAcc.Website='roblox.com';
            updatedAccList.add(updatedAcc);
            system.debug('Website --------->'+updatedAcc.Website);
        }
        if(updatedAccList.size()>0){
           update updatedAccList;
        }
            
    }
    public static void updateContactDetails(List<Account> newAccList,Map<Id,Account> accOldMap){
        //check if the mobile number is changed or not
        Map<Id,String> AccountsWithPhoneMap = new Map<Id,String>();
        for(Account a: newAccList){
            if(a.Phone != accOldMap.get(a.Id).Phone){
		//If yes, then add the account and it's mobile number in a map
                AccountsWithPhoneMap.put(a.Id,a.Phone);
            }
        }
        // If there are no updations of mobile number in account, then return
        if(AccountsWithPhoneMap.isEmpty()) return;
        // query all the contacts associated with modified accounts
        List<Contact> contactsToBeUpdated =[Select id,AccountId from Contact where AccountId in :AccountsWithPhoneMap.keyset()];
        List<Contact> updatedContacts = new List<Contact>();
       
        //Loop through all the contacts and update the mobile number in the contact record
        for(Contact c: contactsToBeUpdated){
            c.Phone=AccountsWithPhoneMap.get(c.AccountId);
            updatedContacts.add(c);
	        }
        if(updatedContacts.size()>0){
            update updatedContacts;
        }
    }
    public static void testEnum(){
        
    }
    public enum Seasons{Winter,Summer,Rainy,News}
    }