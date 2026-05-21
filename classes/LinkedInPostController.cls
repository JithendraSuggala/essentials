public with sharing class LinkedInPostController {

    @AuraEnabled
    public static String postJob(Id recordId) {

        // Fetch Job Record
        Job__c job = [
            SELECT Name, Description__c, Location__c 
            FROM Job__c 
            WHERE Id = :recordId
            LIMIT 1
        ];

        // Build post text safely
        String postText = '🚀 Hiring Now!\n\n';
        postText += 'Role: ' + job.Name + '\n';
        postText += 'Location: ' + job.Location__c + '\n';
        postText += 'Details: ' + job.Description__c + '\n\n';
        postText += '👉 Apply now!';

        // ⚠️ Replace this with actual value from /v2/me API
        String authorUrn = 'urn:li:person:RcDvhL-d3V';

        // Prepare HTTP Request
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Linkedin_Integration/v2/ugcPosts');
        req.setMethod('POST');

        // ✅ REQUIRED HEADERS
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-Restli-Protocol-Version', '2.0.0');

        // Request Body
        Map<String, Object> body = new Map<String, Object>{
            'author' => authorUrn,
            'lifecycleState' => 'PUBLISHED',
            'specificContent' => new Map<String, Object>{
                'com.linkedin.ugc.ShareContent' => new Map<String, Object>{
                    'shareCommentary' => new Map<String, Object>{
                        'text' => postText
                    },
                    'shareMediaCategory' => 'NONE'
                }
            },
            'visibility' => new Map<String, Object>{
                'com.linkedin.ugc.MemberNetworkVisibility' => 'PUBLIC'
            }
        };

        req.setBody(JSON.serialize(body));

        // Send Request
        Http http = new Http();
        HttpResponse res = http.send(req);

        // ✅ Correct debugging (Apex uses System.debug, not console.log)
        System.debug('LinkedIn Status Code: ' + res.getStatusCode());
        System.debug('LinkedIn Response Body: ' + res.getBody());

        // Handle response
        if (res.getStatusCode() == 201) {
            return 'SUCCESS';
        } else {
            throw new AuraHandledException('LinkedIn Error: ' + res.getBody());
        }
    }
}