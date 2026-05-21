public class AccountRecord {
    
    public static Id insertAccount(String name,String rating){
        
        Account a = new Account();
        a.Name=name;
        a.Rating=rating;
        insert a;
        
        return a.Id;
        
    }
    public static void insertContact(){
        Id accId;
        accId = insertAccount('t2','Hot');
        Contact c= new Contact();
        c.AccountId =accId;
        c.LastName='T2';
        insert c;
    }
    public static void insertAccountContactOpp(String name,String rating){
        
        Account a = new Account();
        a.Name=name;
        a.Rating=rating;
        insert a;
        
        Contact c= new Contact();
        c.AccountId =a.Id;
        c.LastName='Test';
        insert c;
        
        Opportunity o =new Opportunity();
        o.Name='Opp1';
        o.CloseDate=System.today();
        o.StageName='prospecting';
        o.AccountId=a.Id;
        insert o;
    }
    public static void insertAccountContactOppCase(String name, String rating){
        Account acc = new Account();
        acc.Name = name;
        acc.Rating = rating;
        
        insert acc;
        
        Contact con = new Contact();
        con.LastName='Test contact01';
        con.AccountId = acc.Id;
        
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name ='Opp 01';
        o.AccountId=acc.Id;
        o.CloseDate= system.Today();
        o.StageName='New';
        insert o;
        
        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Phone';
        c.AccountId=acc.Id;
        
        insert c;
    }
}