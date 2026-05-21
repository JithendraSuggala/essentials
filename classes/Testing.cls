public class Testing {
    public static Set<Integer> setUnion(Set<Integer> set1, Set<Integer> set2) {
    //code here
    set<Integer> fin = new set<Integer>();
    set1.addAll(set2);
   	system.debug('Final set values :'+set1);
    return set1;
}
    public static List<String> fullNames(List<String> firstNames, List<String> lastNames) {
    //code here
    List<String> FullName =new List<String>();
    String var;
    for(Integer i=0;i<firstNames.size();i++){
        var = firstNames[i]+' '+lastNames[i];
        fullName.add(var);
    }
        System.debug('Fullnames :'+fullName);
    return fullName;
}
    public static Integer arraySum(List<Integer> numbers) {
        integer sum=0;
        for(Integer i=0;i<numbers.size();i++){
            sum+=numbers.get(i);
        }
        system.debug('Sum of Integers :'+sum);
        return sum;
        
    }   
    public List<Integer> evenNumbers(Integer n) {
        //code here
        List<Integer> evenList = new List<Integer>();
        for(Integer i=1;i<=n;i++){
            integer num=0;
            num=i*2;
            evenList.add(num);
        }
        return evenList;
    }
    public static void insertAtStart(String cityName, List<String> cities) {
        //code here
        cities.add(0,cityName);
        system.debug('citiesList :'+cities);
        
    }
    
}