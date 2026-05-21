public with sharing class AccountListController {
    public class AccountsResult {
        @AuraEnabled public List<Account> records;
        @AuraEnabled public Integer totalCount;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getBillingCountries() {
        List<String> countries = new List<String>();
        for (AggregateResult ar : [
            SELECT BillingCountry
            FROM Account
            WHERE BillingCountry != null
            GROUP BY BillingCountry
            ORDER BY BillingCountry
        ]) {
            countries.add((String) ar.get('BillingCountry'));
        }
        system.debug('Billing Countries: ' + countries);
        return countries;
    }

    @AuraEnabled(cacheable=true)
    public static AccountsResult getAccounts(String billingCountry, Integer pageSize, Integer pageNumber) {
        Integer size = (pageSize == null || pageSize <= 0) ? 200 : pageSize;
        Integer page = (pageNumber == null || pageNumber < 1) ? 1 : pageNumber;
        Integer offsetRows = (page - 1) * size;

        Boolean allCountries = String.isBlank(billingCountry) || billingCountry == 'All';
        String soql = 'SELECT Id, Name, BillingCountry, ShippingCountry, Phone, Industry, Type, Owner.Name FROM Account'
            + (allCountries ? '' : ' WHERE BillingCountry = :billingCountry')
            + ' ORDER BY Name LIMIT :size OFFSET :offsetRows';
        String countSoql = 'SELECT COUNT() FROM Account'
            + (allCountries ? '' : ' WHERE BillingCountry = :billingCountry');

        AccountsResult result = new AccountsResult();
        result.records = Database.query(soql);
        result.totalCount = (Integer)Database.countQuery(countSoql);
        return result;
    }
}