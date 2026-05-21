public with sharing class callAnimalServer {
    public static HttpResponse getAnimalDetails(){
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        req.setMethod('GET');
        HTTPResponse response = http.send(req);
        if(response.getStatusCode() == 200){
            Map<String,Object> result = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            //system.debug('result: --->'+result);
            List<Object> animalsList =  (List<Object>) result.get('animals');
            system.debug('Animals List contains: --->');
            for(Object o:animalsList){
                system.debug(o);
            }
                
        }
        return response;
    }
    public static HttpResponse postAnimalDetails(){
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setBody('{"name":"Muddy"}');
        
        HttpResponse response = http.send(req);
        
        if(response.getStatusCode() == 201){
            system.debug(response.getBody());
        }
        else{
            system.debug('Error code--->'+response.getStatusCode()+' -> '+response);
        }
        return response;
    }
}