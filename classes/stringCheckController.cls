//Generated for Decodeforce programming test
public class stringCheckController{

	public static boolean keywordExist(String input){

		Boolean result=false;

		/* Write your logic below */

    if(input.contains('salesforce')){
        result = true;
    }
    if(input.contains('Salesforce')){
        result = false;
    }
		return result;
	
	}
}