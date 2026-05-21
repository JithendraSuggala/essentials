public class PracticeMap {
    
    public static void practicemethod(){
        Map<Integer,String> colors = new Map<Integer,String>();
        colors.put(1,'Red');
        colors.put(2,'Blue');
        colors.put(3,'Green');
        System.debug('Colors in the map are...'+colors);
        Map<Integer,String> moreColors = new Map<Integer,String>();
        moreColors.put(4,'Yellow');
        moreColors.put(5,'Maroon');
        moreColors.put(1,'Pink');
        System.debug('MoreColors Map Contains...'+moreColors);
        // adding morecolors to colors map
        colors.putAll(morecolors);
        System.debug('Updated  Colors map Contains...'+colors);
        colors.remove(1);
        System.debug('Updated  Colors map Contains...'+colors);
        System.debug('Size of Colors map Contains...'+colors.size());
        System.debug('Values in Colors map...'+colors.values());
        //removing data in moreColors
        moreColors.clear();
        System.debug('More Colors map Contains...'+moreColors);
        moreColors = colors.clone();
        System.debug('Cloned MoreColors map Contains...'+moreColors);
        System.debug('Does More Colors map Contains 2...'+moreColors.containsKey(2));
        
    }
    public static void sObjectInMapwithoutLoop(){
        List<Account> accList = [Select Id,Name,Phone FROM Account LIMIT 5];
        Map<Id,Account> accMap = new Map<Id,Account>(accList);
        //accMap.putAll(accList);
        system.debug('Account Map Contains :-'+accMap);
    }
    public static void sOjectInMapWithLoop(){
        List<Account> accList = [Select Id,Name,Phone FROM Account LIMIT 5];
        Map<Id,Account> accMap = new Map<Id,Account>();
        
        for(Account a:accList){
            accMap.put(a.Id,a);
        }
        system.debug('Account Map Contains :-'+accMap);
        system.debug('Account Map Keys :-'+accMap.keyset());
        system.debug('Account Map Values :-'+accMap.values());
            
        
    }
}