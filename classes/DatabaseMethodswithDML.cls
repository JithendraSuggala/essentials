public class DatabaseMethodswithDML {

    public static void insertOperation(){
        Account a = new Account();
        a.Name='Nuthan Logistics';
        insert a;
    }
    public static void BulkInsertOperation(){
        List<Account> accList = new List<Account>();
        
            for(Integer i = 0;i<=25;i++){
               Account a= new Account(Name ='Acc b'+i);
                accList.add(a);
            }
        Insert accList;
    }
    public static void updateOperation(){
        
        Account A = new Account(Id='001Ig00000JWXY5IAP');
        A.Rating='Hot';
        update A;
        
    }
    public static void BulkUpdateOperation(){
        List<Account> accsToUpdate = [select id from Account where name like 'Acc b0%' ];
        for(Account a: accsToUpdate){
            a.Industry='Media';
        }
        update accsToUpdate;
    }
    public Static void deleteOperation(){
        Account a =[select id from Account where Id ='001Ig00000JWXY5IAP'];
        delete a;
    }
    public static void BulkDeleteOperation(){
        List<Account> accList = [select id from Account where name like 'Acc b%'];
        delete accList;
    }
    public static void undeleteOperation(){
        Account a = [Select id from Account where id ='001Ig00000JWXY5IAP' AND isDeleted= true ALL ROWS];
        undelete a;
    }
    public static void BulkUndeleteOperation(){
        List<Account> accList = [select id from Account where name like 'Acc b%'  and isDeleted= true ALL ROWS];
        undelete accList;
    }
    public static void mergeRecords(){
        //we can merge duplicates for Case,Account,Contact,Lead records only
        Account mainAccount =[select id from Account where Id ='001Ig00000JWXY5IAP'];
        Account duplicateAccount =[select id from Account where Id ='001Ig00000FkvJyIAJ'];
        merge mainAccount duplicateAccount;
    }
    //Database Methods
    public static void DatabaseInsertOperation(List<account> accList){
        List<Database.SaveResult> results = Database.Insert(accList,false);
        
        for(Database.SaveResult sr : results)
        if(sr.isSuccess()){
            system.debug('Record Inserted Successfully ->'+ sr.getId());
        }
        else{
            for(Database.error err: sr.getErrors()){
                system.debug('Error Occured while Inserting records');
                system.debug('Fields -> '+err.getFields()+' Error -> '+err.getMessage()+'Error Code -> '+ err.getStatusCode());
                //fields
                //Message
                //statusCode
            }
        }   
    }
    public static void DatabaseUpdateOperation(List<Account> accList){
	        List<Database.SaveResult> results = Database.update(accList,false);
        for(Database.SaveResult sr: results){
            if(sr.isSuccess()){
                System.debug('This record is updated Successfully'+sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('Fields-> '+err.getFields()+ ' Error ->'+ err.getStatusCode()+ err.getMessage());
                }
            }
                
        }
        }
    public static void DatabaseDeleteOperation(List<Account> accList){
	        List<Database.DeleteResult> results = Database.delete(accList,false);
        for(Database.DeleteResult sr: results){
            if(sr.isSuccess()){
                System.debug('This record is Deleted Successfully'+sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('Fields-> '+err.getFields()+ ' Error ->'+ err.getStatusCode()+ err.getMessage());
                }
            }
                
        }
        }
    public static void DatabaseunDeleteOperation(List<Account> accList){
	        List<Database.unDeleteResult> results = Database.undelete(accList,false);
        for(Database.unDeleteResult sr: results){
            if(sr.isSuccess()){
                System.debug('This record is unddeleted Successfully'+sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    System.debug('Fields-> '+err.getFields()+ ' Error ->'+ err.getStatusCode()+ err.getMessage());
                }
            }
                
        }
        }
    public static void dynamicSOQLquery(String fields, String sObject_Name, String filters){
        String accName='%'+filters+'%';
        String query ='SELECT '+fields+ ' FROM '+sObject_Name;
        if(String.isNotblank(Filters)){
            query+=' WHERE Name like :accName';
        }
        system.debug('Final query is -> '+query);
        List<sObject> records = Database.query(query);
        system.debug('Output is -> '+records);
    }
}