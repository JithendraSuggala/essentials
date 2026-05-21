public class AccountChangeTriggerHandler {
    public static void captureChange(List<AccountChangeEvent> newlist){
        for(AccountChangeEvent ac: newlist){
            
            EventBus.ChangeEventHeader header = ac.ChangeEventHeader;
            
            System.debug('Change Type: ' + header.changeType);
            System.debug('Record IDs: ' + header.recordIds);
            System.debug('Changed Fields: ' + header.changedFields);
            System.debug('Commit Timestamp: ' + header.commitTimestamp);
            System.debug('Commit User: ' + header.commitUser);
            
        }
    }
}