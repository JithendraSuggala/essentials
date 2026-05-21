public class SimpleInterest {
    public static void calc(){
        decimal principle=2000,rate=10,t=10;
        decimal SI=(principle*rate*t)/100;
        System.debug('Simple Interest is '+SI);
    }
}