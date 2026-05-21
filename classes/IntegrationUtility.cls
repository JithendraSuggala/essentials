public with sharing class IntegrationUtility {
    public static Map<String,String> returnWebsiteDetails(string websiteName) {
        Map<String,String> websitedetails = new Map<String,String>();
        WebsiteInformation__mdt website = 
        [SELECT Id,DeveloperName,secretKey__c,EndPointURL__c,serviceMethod__c,serviceType__c 
        FROM WebsiteInformation__mdt
        WHERE DeveloperName =: websiteName limit 1];

        websitedetails.put('WebsiteName', website.DeveloperName);
        websitedetails.put('SecretKey', website.secretKey__c);
        websitedetails.put('EndPointURL', website.EndPointURL__c);
        websitedetails.put('ServiceMethod', website.serviceMethod__c);
        websitedetails.put('ServiceType', website.serviceType__c);
        String Key = websitedetails.get('SecretKey');
        return websitedetails;
    }
}