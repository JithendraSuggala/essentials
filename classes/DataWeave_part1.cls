public class DataWeave_part1 {
    public static void getData(){
        HttpRequest req = new HttpRequest();
        req.setEndPoint('https://feeds.bbci.co.uk/news/world/rss.xml');
        req.setMethod('GET');
        req.setHeader('Accept','application/xml');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() != 200){
            System.debug('== Error while fetching data'+res.getStatusCode());
        }
        String resBody = res.getBody();
        System.debug('Response from External System'+res.getBody());
        
        Map<String,object> params = new Map<string,object>();
        params.put('records', resbody);
        
        DataWeave.Script script = DataWeave.Script.createScript('xmlToJsonPart2');
    	DataWeave.Result result = Script.execute(params);
        
        List<Object> objs = (List<Object>) result.getValue();
        List<Account> accounts = new List<Account>();
        for(Object obj : objs){
            Accounts.add((Account) obj);
        }
        insert Accounts;
        System.debug(Accounts);
    }
}