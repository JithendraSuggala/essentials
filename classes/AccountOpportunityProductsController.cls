public with sharing class AccountOpportunityProductsController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id accountId) {
        return [SELECT Id, Opportunity.Name, Product2.Name, Quantity, TotalPrice, Description 
                FROM OpportunityLineItem 
                WHERE Opportunity.AccountId = :accountId AND Description LIKE '%CAP%' WITH SECURITY_ENFORCED];
    }
}