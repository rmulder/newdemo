public with sharing class mobileShortFormController {
      public Application__c newApplication{get;set;}
      public Application2__c newApplication2{get;set;}
      public Employment_information__c emp{get;set;}
      public About_Account__c acc {get;set;}
      public Customer__c customer {get;set;}
      public Identity_information__c iden{get;set;}
      public Integer FundingAmount{get;set;}
      public Integer RequestLoan{get;set;}
      public Integer PurchaseLoan{get;set;}
      public Integer Creditlimit{get;set;}
      public String employer{get;set;}
      public String occupation{get;set;}
      public integer annualincome{get;set;}
      public String idnumber{get;set;}
      public String issuedate{get;set;}
      public string expdate{get;set;}
      public String socialsecuritynumber{get;set;}
      public String dateofbirth{get;set;}
      public String selected_state_issued{get;set;}
      public String selected_citizenship{get;set;}
      public String selected_idType{get;set;}
      public String selected_housingStatus{get;set;}
      public String vehiclemake{get;set;}
      public String vehiclemodel{get;set;}
      public String vehiclesubmodel{get;set;}
      public String vehiclevin{get;set;}
      public integer vehiclemileage{get;set;}
      public String accNum{get;set;}
      public String accType{get;set;}
      public String routingNum{get;set;}
      public integer DollarAmt{get;set;} 
      
      
      public String product{get;set;}
      public String subProduct{get;set;}
      public String id{get; set;}

      public Boolean fundingProd{get;set;} 
      public Boolean loanProd{get;set;}
      public Boolean creditProd{get;set;}
      public Boolean HLProd{get;set;}

      public string custId = null;    
        
      public mobileShortFormController(ApexPages.StandardController controller) {
          this.newApplication=(Application__c)controller.getRecord();
          product=ApexPages.currentPage().getParameters().get('Product');
          subProduct=ApexPages.currentPage().getParameters().get('SubProduct');
          id=ApexPages.currentPage().getParameters().get('id');
          newApplication = [SELECT id,Disclosure1__c,Type_Of_Business_CDs__c,Type_Of_Business_Checking__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Type_Of_Business_Savings__c,Type_Of_Home_Equity__c,Type_of_Certificates__c,Type_of_Checking__c,Type_of_Credit_Cards__c,Type_of_Investments__c,Type_of_Mortgage_Loan__c,Type_of_Mortgage_Short_Application__c,Type_of_Personal_Loans__c,Type_of_Savings__c,Type_of_Vehicle_Loans__c,First_Name__c, Last_Name__c,Email_Address__c,Primary_Phone_Number__c,Best_Time_To_Call__c,product__c, sub_product__c, Mobile_Submit__c, Application_Status__c, Current_Channel__c, Street_Address_2__c, Street_Address_1__c, City__c, State__c, Zip_Code__c, Housing_Status__c, Monthly_Payment__c, Customer__c FROM Application__c where id=:id];
          custId = newApplication.Customer__c;         
          newApplication2 = [select id, Application__c from Application2__c where Application__c =: newApplication.id];
          acc = [select id, VehicleMake__c, VehicleModel__c, Vehicle_Sub_Model__c, VIN__c, VehicleMileage__c, CHK_Account_Number__c, Account_type_FI_CHK__c, Routing_Number_CHK__c, Application__c,HE_Purchase_Price__c,Purchase_P__c,HE_Requested_Loan_Amount__c,HL_Requested_Loan_Amount__c,Requested_Credit_Limit_Ccards__c,Requested_Loan_Amount_PersonalLoans__c,Requested_Loan_Amount_VehicleLoans__c,Dollar_Amount_External_CERT__c,Dollar_Amount_External_CHK__c,Dollar_Amount_External_SAV__c from About_Account__c where Application__c =: newApplication.id];
          emp = [select id, Employer__c, Occupation__c, Annual_Income__c, Application__c from Employment_information__c where Application__c =: newApplication.id];
          employer = emp.Employer__c;
          if(custId != null){
            customer = [Select Name,Company__c from Customer__c where id = :custId];
            employer =  customer.Company__c;
          }
          iden = [select id, SSN_Last_Four_PA__c,ID_Type__c, ID_Number__c, Issue_Date__c, Expiry_Date__c, Social_Security_Number__c, Date_of_Birth__c, State_Issued__c, Citizenship__c, Application__c from Identity_information__c where Application__c =: newApplication.id];
          if(newApplication.Type_of_Checking__c!=null || newApplication.Type_of_Savings__c!=null || newApplication.Type_of_Certificates__c!=null){
            fundingProd = true;
          }
          if(newApplication.Type_of_Mortgage_Loan__c!=null || newApplication.Type_Of_Home_Equity__c!=null){
            loanProd = true;
            HLProd = true;
          }
          if(newApplication.Type_of_Personal_Loans__c!=null || newApplication.Type_of_Vehicle_Loans__c!=null){
            loanProd = true;
          }
          if(newApplication.Type_of_Credit_Cards__c!=null){
            creditProd = true;
          }
      }

      public List<SelectOption> getState_issued(){
          List<SelectOption> options = new List<SelectOption>();        
          Schema.DescribeFieldResult fieldResult = Identity_Information__c.State_Issued__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
          options.add(new SelectOption('State','State'));                   
          for( Schema.PicklistEntry f : ple)
          {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
          }       
          return options;
      }

      public boolean getannie(){
         if(custId == null){
             return true;
         }else{
             return false;
         }
      }

      public boolean getjacob(){
         if(custId == 'a0R1a000000HY55EAG'){
             return true;
         }else{
             return false;
         }
      }

      public boolean getjimmy(){
         system.debug('customer id is: '+ custId);
         if(custId == 'a0R1a000000HY4qEAG'){
             return true;
         }else{
             return false;
         }
      }

      public PageReference createApplication(){
          System.debug('Inside createApplication ');
          Logger.inputSource('mobileShortFormController - mobileShortFormController', newApplication.id);
            
          try{
              newApplication.Product__c=product;
              newApplication.Sub_Product__c=subProduct;
              newApplication.Mobile_Submit__c=true;
              newApplication.Application_Status__c='Approved';
              newApplication.Housing_Status__c = selected_housingStatus;
              
              //update Employer Information
              emp.Employer__c = employer;
              emp.Occupation__c = occupation;
              emp.Annual_Income__c = annualincome;

              //update Identity Information
              iden.ID_Number__c = idnumber;
              iden.Issue_Date__c = issuedate;
              iden.Expiry_Date__c = expdate;
              if(socialsecuritynumber != null){
                socialsecuritynumber = socialsecuritynumber.replaceAll('-', '');
                iden.Social_Security_Number__c = socialsecuritynumber;
                iden.SSN_Last_Four_PA__c = socialsecuritynumber.substring(5);
                system.debug('ssn is: '+socialsecuritynumber);
              }
              system.debug('iden ssn is: '+iden.Social_Security_Number__c);
              if(dateofbirth != null) iden.Date_of_Birth__c = dateofbirth;              
              iden.State_Issued__c = selected_state_issued;
              iden.Citizenship__c = selected_citizenship;
              iden.ID_Type__c = selected_idType;

              //update About Account object
              acc.Requested_Credit_Limit_Ccards__c = Creditlimit;
              acc.VehicleMake__c = vehiclemake;
              acc.VehicleModel__c = vehiclemodel;
              acc.Vehicle_Sub_Model__c = vehiclesubmodel;
              acc.VIN__c = vehiclevin;
              acc.VehicleMileage__c = vehiclemileage;

              acc.CHK_Account_Number__c = accNum;
              acc.Account_type_FI_CHK__c = accType;
              acc.Routing_Number_CHK__c = routingNum;
              acc.Dollar_Amount_External_CHK__c = DollarAmt;         
              

              if (Application__c.SObjectType.getDescribe().isUpdateable()) {
                  update newApplication;
              }
              if (Application2__c.SObjectType.getDescribe().isUpdateable()) {
                  update newApplication2;
              }
              if (About_Account__c.SObjectType.getDescribe().isUpdateable()) {
                  update acc;
              }
              if (Employment_information__c.SObjectType.getDescribe().isUpdateable()) {
                  update emp;
              }
              if (Identity_Information__c.SObjectType.getDescribe().isUpdateable()) {
                  update iden;
              } 


              String[] toAddresses = new String[] {newApplication.Email_Address__c};              
              EmailTemplate et=[Select id from EmailTemplate where name=:'Confirmation Email'];
              Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
              email.setToAddresses(toaddresses);
              email.setTemplateId(et.id);
              email.setTargetObjectId(UserInfo.getUserId());
              email.setWhatId(newApplication.Id);
              email.setSaveAsActivity(false);
              Messaging.SendEmailResult [] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
              System.debug('******email result***********'+r);
              
              return (new pagereference('/apex/thankyoufinal'));              

          }catch (exception e){
              Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
              Logger.writeAllLogs();
              return (new pagereference('/apex/thankyoufinal'));
          }
      }
}