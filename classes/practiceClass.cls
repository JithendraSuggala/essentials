public class practiceClass {
    
    public static String aOrAn(String word) {
        if(word == null || string.isEmpty(word)){
            return word;
        }
        
        if(word.startsWith('a') || word.startsWith('e') || word.startsWith('i') || word.startsWith('o') || word.startsWith('u')){
            word='an ' + word;
            System.debug('Final word is '+ word);
            return word;
        }
        else{
            word= 'a ' + word;
            System.debug('Final word is '+ word);
            return word;
        }
    }
    public static void test(){
        String blank = '';
        String nullString = null;
        String whitespace = '  ';
        System.assert(String.isBlank(blank));
        System.assert(String.isBlank(nullString));
        System.assert(String.isBlank(whitespace));
        String alpha = 'Hello';
        System.assert(!String.isBlank(alpha));
    }
    public static String convert15to18DigitId(String fifteenDigit)
    {
        id i;
        if(String.isBlank(fifteenDigit)){
            return 'null';
        }
        else If(fifteenDigit.length()==15){
            //i = Id.valueOf(fifteenDigit);
            system.debug('Output string is '+ (id)fifteenDigit);
            return (id)fifteenDigit;
        }
        else{
            return '-1';
        }
    }
}