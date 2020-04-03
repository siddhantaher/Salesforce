public with sharing class TestPOC {

    public static void matchCandidatesWithInterviers(List<Candidate__c> newInsertedCandidateList) {
        Candidate__c candy = newInsertedCandidateList[0];
        //Candidate__c candy = [SELECT Name, Interview_Time__c, Applied_Position__c, Practice__c FROM Candidate__c WHERE Name = 'GoGo' LIMIT 1];
        List<Event> userEvents = [Select Description, StartDateTime, EndDateTime, ActivityDateTime, Location, IsAllDayEvent, OwnerId FROM Event WHERE OwnerId ='0053h000001dTtBAAU' ];

        For(Event eve : userEvents){
            if(eve.StartDateTime == candy.Interview_Time__c){
                System.debug('XXXXXCandidate interview time' + candy.Interview_Time__c);
                System.debug('XXXXXevent time' + eve.StartDateTime);
                System.debug('There is a match with the interviewer');
                sendEmail(eve);
                
            }
            else{
                System.debug('YYYYYevent time' + eve.StartDateTime);
                System.debug('YYYYYCandidate interview time' + candy.Interview_Time__c);
                System.debug('No match');
            }
        }
        
    }

    public static void sendEmail(Event eve) {

        //Creating an email for the lead 
        Messaging.SingleEmailMessage[] mails = new Messaging.SingleEmailMessage[0];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSenderDisplayName('Slalom Recruiting');
        mail.setTargetObjectId(eve.OwnerId);            
        mail.setSubject('This is the subject');
        mail.setSaveAsActivity(false);
        // mail.setPlainTextBody(ld.Owner.Name + ',' + '\n' + 'Please be advised that the ' + ld.Name + ' was created on ' + 
        //                      ld.CreatedDate + ' and has not been converted.' + '\n' + 'Feel free to access this record from the link below and update it accordingly:' + 
        //                      '\n' + 'Link: '+ URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ld.Id + '\n' + 'Best Regards,'
        //                      + '\n' + 'Salesforce Automation');
        mail.setPlainTextBody('This is the email of the text');
        mails.add(mail);
        Messaging.sendEmail(mails);
        
    }
    
}