public class demoApex {
    public static void nameCheck(String firstname,String lastname){
        if(String.isEmpty(firstname)&& String.isEmpty(lastname)){
            System.debug('Blank');
        }
        else{
            System.debug('Name is :- '+firstname+' '+lastname);
        }
    }
    public static void test(){
        Account Acc = new Account();
        Acc.Name='test Acc2';
    }
}