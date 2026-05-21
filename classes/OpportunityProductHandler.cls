public class OpportunityProductHandler {
    public static void updateAccountFields(Set<Id> accountIds) {
        
        // Step 1: Fetch Opportunities related to Accounts
        List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds];
        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>(opportunities);
        Set<Id> opportunityIds = opportunitiesMap.keySet();
        System.debug('Opportunity IDs: ' + opportunityIds);
        
        // Step 2: Fetch Opportunity Line Items related to Opportunities
        List<OpportunityLineItem> opportunityLineItems = [SELECT Id, OpportunityId, Description, Quantity, Name FROM OpportunityLineItem WHERE Description like '%cap%' and OpportunityId IN :opportunityIds];
        
        System.debug('Opportunity Line Items: ' + opportunityLineItems);
        // Step 3: Process and aggregate data
        Map<Id, List<OpportunityLineItem>> accountToOpportunityLineItems = new Map<Id, List<OpportunityLineItem>>();
        
        for (OpportunityLineItem oli : opportunityLineItems) {
            Id accountId = opportunitiesMap.get(oli.OpportunityId).AccountId;
            if (!accountToOpportunityLineItems.containsKey(accountId)) {
                accountToOpportunityLineItems.put(accountId, new List<OpportunityLineItem>());
            }
            accountToOpportunityLineItems.get(accountId).add(oli);
        }
        
        // Update Account fields
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountToOpportunityLineItems.keySet()) {
            Account acc = new Account(Id = accountId);
            List<OpportunityLineItem> olis = accountToOpportunityLineItems.get(accountId);
            acc.ProductCount__c = olis.size();
            // Create a list of descriptions
            List<String> names = new List<String>();
            for (OpportunityLineItem oli : olis) {
                names.add(oli.Name);
            }
            // Join Product Names into a single string
            acc.ListOfProducts__c = String.join(names, '\n');
            accountsToUpdate.add(acc);
            System.debug('Account to update: ' + acc);
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}