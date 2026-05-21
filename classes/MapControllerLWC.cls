public class MapControllerLWC {
	
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [Select id,Name,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account ORDER BY Name LIMIT 20 ];
    }
}