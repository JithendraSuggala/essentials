public class queueApex implements Queueable {
    public static void execute(queueableContext qc){
        system.debug('Queueable method triggered');
        
        system.enqueuejob(new secondQueueableApex());
    }
}