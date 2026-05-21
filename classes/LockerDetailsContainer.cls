public with sharing class LockerDetailsContainer {
    @AuraEnabled(cacheable=true)
    public static List<Locker_Details__c> getLockerDetails() {
        return [SELECT Id, Name, Available__c FROM Locker_Details__c with USER_MODE order by Name ASC];
    }
}