/*
    Name  : receiveSMS
    Developer Name : Parantap Srivastav
    Description : This is a POC class to receive reponses from the text messages vio Twilio using the @HttpGet.There are also methods to get responses from the email. and a create event emthod to create an event if the response corresponds to yes. The user in this case has been hardcoded to Parantap Srivastav's id and the date of the event is also hardcoded.  These can be made dynamic in the further iterartions.
*/

@RestResource(urlMapping='/receiveSMS/*')
global class receiveSMS {
    
    public string response{get;set;}
    public string InterviewerName{get;set;}
    public string selectedResponse{get;set;}
    public string responseOptions{get;set;}    

    @HttpGet
    global static void getSMS() {
		
       // Store the request received
       RestRequest req = RestContext.request;
       
       // Store the HTTP parameters received in a Map
       Map<String, String> smsParams = req.params ;

       System.Debug(RestContext.request); 
       System.debug(req.requestbody.tostring());
 		
       String fromMobile ;
       String msgBody ;
       
       // Extract SMS Sender's phone number and store it in a variable
       if (smsParams.containsKey('From')){
           fromMobile = smsParams.get('From') ;
       }

       // Extract the body of SMS and store it in a variable
       if (smsParams.containsKey('Body')){
          msgBody = smsParams.get('Body') ;
       }
        
       //if the reposne from the interviwer is 'Yes', create an event. Need to convert the reposne to lower case to be matched irrespective of the input. 
       if(msgBody == 'Yes') {
            createEvent();
        }
        
       //Set the response values for Web Service
       RestContext.response.statusCode = 200;
       RestContext.response.addHeader('Content-Type', 'text/plain');
       RestContext.response.responseBody = Blob.valueOf('Thanks, We have received your response and will get back to you soon') ;
		
    }
    
    //Used to get the response from the email response page and create an event
    public void emailResponse(){
        System.Debug('This is the Name of the interviewer ' + InterviewerName);
        System.Debug('This is the email picklist resposne ' + selectedResponse);
        System.Debug('This is the email text resposne ' + response);
        if(selectedResponse == 'Yes') {
            createEvent();
        }
    }
    
    //get the picklist value in the email response page to be dynamic. Currently it is static in the vf page.
    Public List<Selectoption> getresponseOptions(){
        List<Selectoption> listOfResponse = new List<selectoption>();
        listOfResponse.add(new selectOption('', '- None -'));
        listOfResponse.add(new selectOption('', 'YES'));
        listOfResponse.add(new selectOption('', 'NO'));
        return listOfResponse;
    }
    
    //used to create the event for the user(interviewer) 
    public static void createEvent() {
        DateTime dt = DateTime.newInstance(2020, 4, 10, 2, 00,00);
        Event eve = new Event(Subject='Meeting',Type='Meeting', Description='Interview Scheduling', OwnerId='0053h000001dTtBAAU', StartDateTime=dt, IsAllDayEvent=true);
        insert eve;

    }
         

}