public class testAsync {
    public testAsync(){
        eat();
        wash();
        work();
    }
    public static void eat(){
        system.debug('Eating method triggered');
    }
    @future
    public static void wash(){
        system.debug('washing method triggered');
    }
    public static void work(){
        system.debug('Work method triggered');
    } 
}