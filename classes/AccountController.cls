public with sharing class AccountController {
   
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Id accId) {
        return [SELECT Id, Name,Phone,Active__c FROM Account where Id = :accId with SECURITY_ENFORCED];
    }
}