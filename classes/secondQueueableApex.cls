public class secondQueueableApex implements queueable {
    public static void execute(queueableContext qc){
        system.debug('second queueable class triggered');
    }
}