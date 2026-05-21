public class scheduleAccounts implements schedulable{
    public void execute(SchedulableContext sc){
        database.executebatch(new testScheduleBatch());
    }
}