public with sharing class Convertleadcon {
	public String leadId;
    public Lead leadRecord;

    Opportunity newOpportunity=new Opportunity(); 

    public Convertleadcon(ApexPages.StandardController controller) {
           leadid=ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference convertLeadToOpp(){                
        //RecordType rt = [SELECT id,Name, SobjectType,IsPersonType FROM RecordType WHERE SobjectType='Account' AND IsPersonType=True LIMIT 1];
        //system.debug('RT Id is '+ rt.Id);                

        leadRecord=[select id,FirstName,Lastname,Name, Customer__c,Product__c,Sub_Product__c, SSN__c, State, City, Country, PostalCode, CreatedDate,Street, LeadSource, Status, Phone, MobilePhone, Email from Lead where Id=:leadId];
        //Group myConvertedQ = [SELECT Id, Name,developerName FROM Group WHERE DeveloperName= 'Converted_leads' and type='queue' limit 1];
        system.debug('Member name is '+leadRecord.Customer__c);
                           
        if(leadRecord.Customer__c==null ){
            //Account newAccount=new Account();
            system.debug('Came to create account');
            //newAccount.RecordTypeId=rt.id;
            //newAccount.Name=leadRecord.FirstName + '' + leadRecord.LastName;
           // newAccount.Phone=leadrecord.Phone;
            //newAccount.PersonMobilePhone=leadrecord.MobilePhone;
           	//newAccount.BillingAddress = leadRecord.BillingAddress;       
            //insert newAccount;
            //newOpportunity.AccountId= newAccount.Id;

            Customer__c newCustomer= new Customer__c();
            newCustomer.First_Name__c=leadRecord.FirstName;
            newCustomer.Last_Name__c=leadRecord.LastName;
            newCustomer.SSN__c = leadRecord.SSN__c;
            newCustomer.Phone_Number__c=leadrecord.Phone;
            newCustomer.Cell_Phone_Number__c=leadrecord.MobilePhone;
            newCustomer.Street_Address_1__c=leadrecord.Street;
            newCustomer.City__c=leadrecord.City;
            newCustomer.Country__c=leadrecord.Country;
            newCustomer.Zip_Code__c=leadrecord.PostalCode;
            newCustomer.State__c=leadrecord.State;                
            insert newCustomer;
            newOpportunity.Customer__c= newCustomer.Id;

        }
                   
        else{
            newOpportunity.Customer__c=  leadrecord.Customer__c;
        }
      
        newOpportunity.CloseDate=leadRecord.CreatedDate.Date()+30;
        newOpportunity.Name=leadRecord.Name;
        newOpportunity.StageName = 'Prospecting';
        newOpportunity.Product__c = leadrecord.Product__c;
        newOpportunity.Sub_Product__c = leadrecord.Sub_Product__c;
        //newOpportunity.SSN__c=leadrecord.SSN__c;
        /*newOpportunity.Product__c=leadRecord.Product__c;
        newOpportunity.Sub_Product__c=leadRecord.Sub_Product_type__c;        
        newOpportunity.Phone_test__c=leadrecord.MobilePhone;
        newOpportunity.Phone_3_Home_Personal__c=leadrecord.Phone;
        newOpportunity.Phone_2_Business__c=leadrecord.Phone_Business__c;    
        newOpportunity.Application_ID__c=leadRecord.LQBloanNumber__c; 
        newOpportunity.Area_of_interest__c = leadRecord.Area_of_interest__c;
        newOpportunity.preferred_branch__c = leadRecord.preferred_branch__c; 
        newOpportunity.notes__c = leadRecord.notes__c;*/
        newOpportunity.LeadSource = LeadRecord.LeadSource;
        newOpportunity.Created_from_Lead__c = true;
        		SaveOpp();        	
       			PageReference pg=new PageReference('/'+newOpportunity.Id);
        		return pg;        	    	        
       
  	}//end method
    
   
  public void SaveOpp(){
  		//try{
        	insert newOpportunity;
        //}	
        //catch(DMLexception ex){
        //	system.debug('The following error occurred while saving the opportunity: '+ ex);
        //}
        		                         
        leadrecord.status='Converted';        
        
        //leadrecord.convertedOppid__c=newOpportunity.id;  
        //do not assign to converted leads Q because of reporting
        leadrecord.ownerid=UserInfo.getUserId();
        	
        try{
        	update leadrecord;
        }	
        catch(DMLexception ex){
        	system.debug('The following error occurred while updating the lead: '+ ex);
        }
  	
  }
}