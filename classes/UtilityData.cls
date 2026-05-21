public with sharing class UtilityData {
    
    //we can use this method to refer
    //How to get the metadata and use it in apex
    public static void storeCustomMetaDataInMapViaSOQL(){
        //create a map to store the data
        Map<String,Decimal> discountConfigMap = new Map<String,Decimal>();
        
        //loop over the metadata records and store it in a map
        for(Discount_Config__mdt c :[Select DiscountPercentage__c,ProductCategory__c,Region__c from Discount_Config__mdt]){
            discountConfigMap.put(c.Region__c+'-'+c.ProductCategory__c,c.DiscountPercentage__c);
        }
        //Fetch the discount details
        Decimal Discount = discountConfigMap.get('APAC-Premium');
        //Decimal Discount = discountConfigMap.get(we can get this data from method parameters);
        system.debug('Discount'+Discount);
    }
    public static void storeCustomMetaDataInMapViagetAll(){
        //we can get all the data using getAll
        //key will have- Record Name and Value in map will have-Record data
        Map<String,Discount_Config__mdt> discountConfigMap = Discount_Config__mdt.getAll();
        Decimal discount;
        for(Discount_Config__mdt r : discountConfigMap.values()){
            if(r.Region__c =='APAC' && r.ProductCategory__c =='Standard'){
                discount = r.DiscountPercentage__c;
                break;
            }
        }
        System.debug('APAC-Standard Discount is: -'+discount);
        
        
    }
}