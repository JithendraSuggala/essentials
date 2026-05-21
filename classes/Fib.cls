public class Fib {
public static Integer fibonacci(Integer n) {
  
    List<Integer> FibList = new List<Integer>();
    FibList.add(1);
    FibList.add(1);
    for(Integer var=2;var<=10;var++){
        Integer m= FibList[var-1]+FibList[var-2];
        FibList.add(m);
    }
        system.debug('Fib List'+FibList);
        system.debug('Value is'+FibList[n-1]);
    return FibList[n-1];
}
}