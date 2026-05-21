public with sharing class fetchCustomMetadataController {
    
    @AuraEnabled
    public static string searchButton(){
       map<String,String> websitedetails;
       string API_Key;
        websitedetails = IntegrationUtility.returnWebsiteDetails('WeatherCheck');
        API_Key=websitedetails.get('SecretKey');
        return API_Key;
    }
}