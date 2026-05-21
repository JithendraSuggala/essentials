public class PracticeApex {
    
    public static void databaseDemo(){
        List<Account> accList = new List<Account>{
            new Account(Name='Test DML 1',Phone='9123443251'),
            new Account(Name='Test DML 2'),
            new Account()
        };
        /*accList =[select id,Name,Rating,Industry from Account where Rating='Hot'];
        
        for(Account acc : accList){
            acc.Industry ='Energy';
        }*/
        
        Database.SaveResult[] results =Database.insert(accList,false);
        //Database.upsertResult[] res =Database.upsert(AccList,false);
        //Database.deleteResult[] res=Database.delete(accList,false);
        
        for(Database.SaveResult sr : results){
            if(sr.isSuccess()){
                system.debug('Inserted Account'+sr.getId());
            }
            else{
                for(Database.Error err : sr.getErrors()){
                    system.debug('following error has occured');
                    system.debug(err.getStatusCode()+' : '+err.getMessage());
                }
            }
        }
       
    }

    public static void CompareNumbers(Integer a, Integer b){
        if(a>b){
            System.debug(a+' is Greater than '+b);
        }
        else if(a==b){
            System.debug(a+' and '+b+'are equal');
        }
        else{
            System.debug(b+' is Greater than '+a);
        }
    }
    public static void foreachloop(){
        list<Account> accList =[SELECT Id,Name from Account Limit 5];
        set<Id> accIds = new set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        if(accList.size()>0){
            for(Account acc: accList){
            system.debug(acc.id +' - '+acc);
            accIds.add(acc.Id);
            accMap.put(acc.Id,acc);
        }
        }
        
        system.debug('Account Set Contains '+accIds);
        system.debug('Map Contains '+accMap);
        //Iterate on Set of Account Ids and show 
        for(Id accid : accIds){
            system.debug(accid);
        }
        
    }
}