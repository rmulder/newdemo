public with sharing class ResumeServiceController {

	public Service__c service{get; set;}
	public String serviceId{get; set;}
	public User loggedInUser{get;set;}
	public String usr{get;set;}
	public String id{get; set;}
	public String ut{get; set;}
    public String spa{get; set;}

    public ResumeServiceController(ApexPages.StandardController controller) {

    	this.service = (Service__c)controller.getrecord();	
    	serviceId=ApexPages.currentPage().getParameters().get('id'); 
    	usr = ApexPages.currentPage().getParameters().get('usr');
        spa = ApexPages.currentPage().getParameters().get('spa');
    	system.debug('The user is' + usr);
    	if(serviceId != null){
    		service = [SELECT Id,User_Token__c,Current_Person__c,One_N_Done__c,Current_Branch_Name__c,Current_User_Email_Address__c,Current_Channel__c,Current_timestamp__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :serviceId];
    	}
    	if(usr!=null){
    	    loggedInUser=[select id,Email,Channel__c,Location__c,Name from User where Id=:usr];
    	}
    	if(usr!=null){
    	    if (loggedInUser.Channel__c == 'Branch') {
    	        service.Current_Channel__c = 'Branch';
    	    }else if(loggedInUser.Channel__c == 'Call Center'){
    	        service.Current_Channel__c = 'Call Center';
    	    }else{
    	        service.Current_Channel__c = loggedInUser.Channel__c;
    	    }
    	    service.Current_timestamp__c = system.now();
    	    service.Current_Person__c = loggedInUser.Id;
    	    service.Current_Branch_Name__c = loggedInUser.Location__c;
    	    service.Current_User_Email_Address__c=loggedInUser.Email;
    	    service.Ownerid = loggedInUser.Id;
    	}
    	else{
    	    service.Current_Channel__c='Online'; 
    	    service.Current_timestamp__c =system.now();
    	    service.Current_Person__c = loggedInUser.Id;
    	    service.Current_Branch_Name__c = loggedInUser.Location__c;
    	    service.Current_User_Email_Address__c=loggedInUser.Email;
    	}
    }

    public PageReference resumeServiceApplication(){

    	PageReference p = null;

    	if(service.Status__c != 'Closed'){
    		service.Status__c = 'Open';
    	}

    	update service;
        ServiceCryptoHelper.refreshToken(service);
        String userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);

        Cookie sid = ApexPages.currentPage().getCookies().get('svcId');
        Cookie sut = ApexPages.currentPage().getCookies().get('sut');
        sid = new Cookie('svcId',serviceId,null,-1,true);
        sut = new Cookie('sut',userToken,null,-1,true);
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{sid,sut});
        if (spa != null && spa == '1') {
            p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'forms');
            p.setRedirect(true);
        } else {
            p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'serviceApp?id='+serviceId);
            p.setRedirect(true);
        }
    	return p;


    }

}