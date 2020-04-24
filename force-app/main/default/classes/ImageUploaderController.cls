public with sharing class ImageUploaderController {
    @AuraEnabled
    public static String uploadPicture(String recId){
        
        System.Debug('This is the rec ID from the LWC component :  ' + recId);
        Id sId = Id.valueOf(recId);
        String objectName = sId.getSObjectType().getDescribe().getName();
        System.debug(objectName);

        //in lightning, docs are stored in content documents
        ContentDocumentLink docLink= [SELECT ContentDocumentId
                               FROM ContentDocumentLink
                               WHERE LinkedEntityId =:recId
                               ORDER BY Id
                               DESC
                               LIMIT 1];

        //content version Id Uniquely identifies the attachment
        ContentVersion version = [SELECT Id 
                                  FROM ContentVersion
                                  WHERE ContentDocumentId =:docLink.ContentDocumentId];
        
        //Update the picture_path field with the url of the image
        if(String.isNotEmpty(objectName)) {
            String query = 'SELECT Id ' + 
                            'FROM ' + objectName + 
                            ' WHERE Id =: recId';
            system.debug('This is the query' + query);
            List<sObject> so = Database.query(query);
            sObject sobj = so[0];
            system.debug('This is the so' + so[0].getSObjectType());
			sobj.put('Picture_Path__c', '/sfc/servlet.shepherd/version/download/' + version.Id);             

            upsert sobj;
        }

        return 'success';

    }

    
}
        //To create custom field from the code itself

        // HttpRequest request = new HttpRequest();
        // request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        // request.setHeader('Content-Type', 'application/json');
        // request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v41.0/tooling/sobjects/CustomField/');
        // request.setMethod('POST');

        // //request.setBody('{"Metadata" : {"type" : "Text","description" : "'+'This is a test field'+'", "inlineHelpText" : "","precision" : null,"label" : "'+'Test2'+'","length" : 255,"required" : false}, "FullName" : "'+'Contact'+'.'+'test2__c'+'"}');
        // request.setBody('{"Metadata" : {"type" : "Formula","description" : "'+'This is a test formula field'+'", "Formula" : "IMAGE(test2__c, "Image", 100, 100)","precision" : null,"label" : "'+'Test Formula'+'","Formula Return Type" : "Text","required" : false}, "FullName" : "'+'Contact'+'.'+'testFormula__c'+'"}');
        

        // Http http = new Http();
        // HTTPResponse res = http.send(request);
        // system.debug('THIS IS THE RESPONSE' + res.getBody());