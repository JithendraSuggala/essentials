public class FormController {
    
    @AuraEnabled(cacheable = true)
    public static List<QuestionWrapper> getQuestions(){
        List<QuestionWrapper> wrapperList = new List<QuestionWrapper>();
        List<formData__mdt> questions = [select QuestionLabel__c,Picklist_Values__c,Data_Type__c from formData__mdt];
        for(formData__mdt question: questions){
            QuestionWrapper wrap = new QuestionWrapper();
            wrap.label= question.QuestionLabel__c;
            wrap.type = question.Data_Type__c;
            
            if(String.isNotBlank(question.Picklist_Values__c)){
                wrap.options = new List<String>(question.Picklist_Values__c.split(';'));
            }
            wrapperList.add(wrap);
        }
        return wrapperList;
    }
    
    public class QuestionWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public List<String> options;
        
    }
}