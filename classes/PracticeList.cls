public class PracticeList {
    public static void ListDemo(){
        List<integer> IntList = new list<integer>();
        IntList.add(0);
        IntList.add(2);
        system.debug('Method 1:- adding values to list using list.add');
        system.debug('IntList Contains Values: '+IntList);
        List<integer> IntListCopied = new list<integer>();
        IntListCopied.add(3);
        IntListCopied.add(5);
        IntListCopied.addAll(IntList);
        IntListCopied.add(0,1);
        system.debug('Method 2:- adding values to list using list.addAll');
        system.debug('IntListCopied Contains Values: '+IntListCopied);
    }
    public static void listmethod(){
        List<String> colors = new List<String>();
        colors.add('Violet');
        colors.add('Indigo');
        colors.add('Blue');
        system.debug('Colors List Contains :'+colors);
        List<string> basecolors = new List<string>{'Red','Green','Blue'};
        colors.addAll(basecolors);
        system.debug('Colors List Contains :'+colors);
        colors.remove(4);
        system.debug('Colors List Contains :'+colors);
        system.debug('Size of Colors is :-'+colors.size());
        system.debug('Colors is empty :-'+colors.isEmpty());
        system.debug('Index of Red is '+colors.indexOf('Red'));
        system.debug('Color in Index 3 of Colors is '+colors.get(3));
        system.debug('Colors List contains Blue '+colors.contains('Blue'));
    }
}