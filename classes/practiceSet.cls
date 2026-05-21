public class practiceSet {
    public static void practiceSetMethod(){
        Set<Integer> intset = new Set<Integer>();
        List<Integer> intlist = new List<Integer>{17,18};
        intset.add(10);
        intset.add(15);
        intset.add(20);
        intset.addAll(intlist);
        system.debug('IntSet contains :'+intset);
    }
    public static void demo(){
        //syntax to create set
        set<Integer> intSet = new Set<Integer>();
        set<Integer> clonedSet = new Set<Integer>();
        //adding elements into set
        //Set only contains unique values
        intSet.add(10);
        intSet.add(20);
        intSet.add(30);
        intSet.add(40);
        System.debug('Set Contains :'+intSet);
        //adding list into set
        List<Integer> intList = new List<Integer>();
        intList.add(45);
        intList.add(50);
        intSet.addAll(intList);
        System.debug('Set Contains :'+intSet);
        clonedset =intSet.clone();
        System.debug('clonedSet Contains :'+clonedSet);
        System.debug('intSet equals clonedSet :'+clonedSet.equals(intSet));
        clonedSet.clear();
        System.debug('clonedSet Contains :'+clonedSet);
        System.debug('intSet Contains :'+intSet);
        System.debug('is clonedSet Empty? :'+clonedSet.isEmpty());
        
        intSet.removeAll(intList);
        System.debug('intSet Contains :'+intSet);
       	
    }
    public static void sobjectdemo(){
        set<Id> accountIds = new set<Id>();
        List<Account> accList =[select Id from Account limit 5];
        
        for(Account acc : accList){
            accountIds.add(acc.Id);
        }
        system.debug('account set contains'+ accountIds);
    }
}