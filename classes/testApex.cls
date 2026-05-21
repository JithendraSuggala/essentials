public class testApex {
    
    public static void testmeth(){
        List<Id> caseList = new List<Id>();
    caseList.add('5002w000006zGB4AAM');
    caseList.add('5002w000006zGBLAA2');
    caseList.add('5002w000006zGBMAA2');
    caseList.add('5002w000006zGBNAA2');
    caseList.add('5002w000006zGBOAA2');
        
        List<Case> accList =[select id,AccountId from case where id in: caseList];
    }
    public static void getUserDetails(){
        Id userId= userInfo.getUserId();
        String userEmail = userinfo.getUserEmail();
        String userName = userinfo.getUserName();
        
        system.debug('User Email ID is :'+userEmail);
        system.debug('User Name is :'+userName);
        User userRec = [SELECT id,profile.Name from User where id = :userId];
        //system.debug('User details -> '+userRec);
    }
    
        }