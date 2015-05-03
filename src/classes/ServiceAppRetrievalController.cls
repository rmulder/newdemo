public with sharing class ServiceAppRetrievalController {

public String sID{get; set;}
public Service__c service{get; set;}

public String lastName{get; set;}
public String dob{get; set;}
public String email{get; set;}
public String ssn{get; set;}
public String ssnLastFour{get; set;}

    public ServiceAppRetrievalController(ApexPages.StandardController controller) {

    	sID = ApexPages.currentPage().getParameters().get('id');
        if(sID != null){
	       service = [SELECT Id,Name,Status__c,Current_Person__c,Current_Branch_Name__c,Current_Channel__c,Current_User_Email_Address__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
        }
    }

    public PageReference retrieveService(){

    	PageReference p = null;

    	System.debug('The value of entered Last Name is '+ lastName);
    	System.debug('The value of entered Dob is '+ dob);
    	System.debug('The value of entered Emaill Address is '+ email);
    	System.debug('The value of entered SSn is '+ ssn);
    	
    	if(service.Social_Security_Number__c != null){
    		ssnLastFour = service.Social_Security_Number__c.subString(service.Social_Security_Number__c.length()-4,service.Social_Security_Number__c.length());
    		system.debug('The Value of the Last 4 digits of the SSN is ##### '+ssnLastFour);
    	}

    	if(service.Field2__c == lastName && service.Date_Of_Birth__c == dob && service.Field3__c.toLowerCase() == email.toLowerCase() && ssnLastFour == ssn){
            if(service.Status__c == 'Open' || service.Status__c == 'Save For Later'){
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Sorry!! The Service you trying to retrieve is aleady closed. Please contact the call center with the following Service ID '+service.Name+' @ 844-837-2347 to get more information'));
                service.Status__c = 'Open';
                service.Current_Channel__c = 'Online';
                service.Current_Timestamp__c = System.now();
                service.Current_Person__c = system.userInfo.getUserId();
                service.Current_Branch_Name__c = '';
                service.Current_User_Email_Address__c = '';

                update service;
                
                p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'ServiceApp?id='+sID);
            } else {
                p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'ServiceApp?id='+sID);
            }
    	} else if(service.Field2__c != lastName || service.Date_Of_Birth__c != dob || service.Field3__c.toLowerCase() != email.toLowerCase() || ssnLastFour == ssn){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Cannot find the record. Please re-check the information you entered'));
    	}

    	return p;
    }

}