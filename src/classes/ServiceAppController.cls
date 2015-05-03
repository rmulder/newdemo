public with sharing class ServiceAppController {

public Id sID{get; set;}
public Set<String> fieldsToDisplay;
public Set<String> requiredServiceFields;
public Boolean dispButton{get; set;}
public Boolean dispPrevButton{get; set;}
public Service__c service{get; set;}
public List<Service_Progress__c> serviceProgress;
public List<Service_Type__c> oneNdoneServiceType{get; set;}
public Attachment attach{get; set;}
public String serDocReqid{get; set;}

//Parameters to capture the attachment id and pass from Page to Controller
public String cParam{get; set;}
public String dParam{get; set;}

// get; set; variables/parameters to capture the values of Note title and Details from page to controller
public String noteTitle{get; set;}
public String noteDetails{get; set;}
public String noteTitleParam{get; set;}
public String noteDetailsParam{get; set;}

public Blob fileBody{get; set;}
public String fileName{get; set;}

// declaring variables to display page labels on the page
public List<Service_Field_Logic__c> pageLabelList{get; set;}
public Map<String, String> pageLabelMap{get; set;}

// variable to hold the URL of the disclosures
public String disclosure1Url{get;set;}
public String disclosure2Url{get;set;}
public String disclosure3Url{get;set;}
public String disclosure4Url{get;set;}
/*public String disclosure5Url{get;set;}
public String disclosure6Url{get;set;}
public String disclosure7Url{get;set;}
public String disclosure8Url{get;set;}
public String disclosure9Url{get;set;}
public String disclosure10Url{get;set;}*/

//Save for later Value Holders
public String lastNameSFLvalueHolder{get; set;}
public String emailSFLvalueHolder{get; set;}
public String dobSFLvalueHolder{get; set;}
public String ssnSFLvalueHolder{get; set;}

public ServiceValidationUtility svu;


public List<Service_Document_Request__c> serviceDocumentList{get; set;}

    public ServiceAppController(ApexPages.StandardController controller) {
    

	    sID = ApexPages.currentPage().getParameters().get('id');
	    
	    this.Service = (Service__c)controller.getrecord();
        if(sID != null){
	       Service = [SELECT Id,Current_User_Email_Address__c,Current_Branch_Name__c,Current_channel__c,Submitted_Timestamp__c,Submitted_Person__c,Submitted_Branch_Name__c,Submitted_User_Email_Address__c,Submitted_Channel__c,Current_Person__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
        }

        if(service.Field2__c != null){
            lastNameSFLvalueHolder = service.Field2__c;
        }
        if(service.Field3__c != null){
            emailSFLvalueHolder = service.Field3__c;
        }
        if(service.Date_Of_Birth__c != null){
            dobSFLvalueHolder = service.Date_Of_Birth__c;
        }
        if(service.Social_Security_Number__c != null){
            ssnSFLvalueHolder = service.Social_Security_Number__c;
        }

	    if(Integer.valueof(service.Total_Steps__c) > Integer.valueof(service.Current_Step__c)){
	    	dispButton = true;
	    } else {
	    	dispButton = false;
	    }

        if(Integer.valueof(service.Current_Step__c) == 1 ){
            dispPrevButton = false;
        } else {
            dispPrevButton = true;
        }

	    fieldsToDisplay = new Set<String>();
	    ServiceUtility su= new ServiceUtility();
	    fieldsToDisplay = su.fieldsToRender(sID);
        System.debug('The fields to render are '+fieldsToDisplay);
        System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());
        requiredServiceFields = su.requiredFields(sID);
        System.debug('The required fields are '+requiredServiceFields);
        System.debug('The size of required fields list is  '+requiredServiceFields.size());
        svu = new ServiceValidationUtility();

        pageLabelMap = new Map<String, String>();  
        pageLabelList = [SELECT Page_Label_Name__c,Page_Label_Value__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Labels'];
        for(Service_Field_Logic__c sfl : pageLabelList){
            pageLabelMap.put(sfl.Page_Label_Name__c,sfl.Page_Label_Value__c);
        }

        oneNdoneServiceType = [SELECT id,Name,Available_in_Channel__c,One_Step_Service__c FROM Service_Type__c WHERE One_Step_Service__c = true AND Name = :Service.Service_Request__c];

        attach = new Attachment();
        serviceDocumentList = [SELECT id,Type__c,Status__c,Service__c,(SELECT id,Name FROM Attachments) FROM Service_Document_Request__c WHERE Service__c =:sID];
        system.debug('The size of serviceDocumentList is'+serviceDocumentList.size());

       List<Service_Disclosure__c> dis1 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure1').Disclosure_Label__c];
        List<Attachment> att1 = new List<Attachment>();
        if (dis1.size() > 0) {
            att1 = dis1[0].Attachments;
            if (att1.size()>0){
                disclosure1Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att1.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis2 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure2').Disclosure_Label__c];
        List<Attachment> att2 = new List<Attachment>();
        if (dis2.size() > 0) {
            att2 = dis2[0].Attachments;
            if (att2.size()>0){
                disclosure2Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att2.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis3 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure3').Disclosure_Label__c];
        List<Attachment> att3 = new List<Attachment>();
        if (dis3.size() > 0) {
            att3 = dis3[0].Attachments;
            if (att3.size()>0){
                disclosure3Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att3.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis4 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure4').Disclosure_Label__c];
        List<Attachment> att4 = new List<Attachment>();
        if (dis4.size() > 0) {
            att4 = dis4[0].Attachments;
            if (att4.size()>0){
                disclosure4Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att4.get(0).id;
            }
        }
        /* List<Service_Disclosure__c> dis5 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure5').Disclosure_Label__c];
        List<Attachment> att5 = new List<Attachment>();
        if (dis5.size() > 0) {
            att5 = dis5[0].Attachments;
            if (att5.size()>0){
                disclosure5Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att5.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis6 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure6').Disclosure_Label__c];
        List<Attachment> att6 = new List<Attachment>();
        if (dis6.size() > 0) {
            att6 = dis6[0].Attachments;
            if (att6.size()>0){
                disclosure6Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att6.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis7 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure7').Disclosure_Label__c];
        List<Attachment> att7 = new List<Attachment>();
        if (dis7.size() > 0) {
            att7 = dis7[0].Attachments;
            if (att7.size()>0){
                disclosure7Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att7.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis8 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure8').Disclosure_Label__c];
        List<Attachment> att8 = new List<Attachment>();
        if (dis8.size() > 0) {
            att8 = dis8[0].Attachments;
            if (att8.size()>0){
                disclosure8Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att8.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis9 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure9').Disclosure_Label__c];
        List<Attachment> att9 = new List<Attachment>();
        if (dis9.size() > 0) {
            att9 = dis9[0].Attachments;
            if (att9.size()>0){
                disclosure9Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att9.get(0).id;
            }
        }
        List<Service_Disclosure__c> dis10 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :Service.Current_channel__c AND Name = :Disclosure_Names__c.getValues('Service_Disclosure10').Disclosure_Label__c];
        List<Attachment> att10 = new List<Attachment>();
        if (dis10.size() > 0) {
            att10 = dis10[0].Attachments;
            if (att10.size()>0){
                disclosure10Url = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att10.get(0).id;
            }
        }*/

	}
    
    public Boolean getpersonalInfo(){
        if(fieldsToDisplay.contains('PersonalInfoSection')){return true;} else {return false;}
    }
    public Boolean getdispField1(){
        if(fieldsToDisplay.contains('Field1__c')){return true;} else {return false;}
    }
    public Boolean getdispField2(){
        if(fieldsToDisplay.contains('Field2__c')){return true;} else {return false;}
    }
    public Boolean getdispField3(){
        if(fieldsToDisplay.contains('Field3__c')){return true;} else {return false;}
    }        
    public Boolean getdispField4(){
        if(fieldsToDisplay.contains('Field4__c')){return true;} else {return false;}
    }
    public Boolean getdispSSN(){
        if(fieldsToDisplay.contains('Social_Security_Number__c')){return true;} else {return false;}
    }
    public Boolean getdispField5(){
        if(fieldsToDisplay.contains('Field5__c')){return true;} else {return false;}
    }
    public Boolean getdispField6(){
        if(fieldsToDisplay.contains('Field6__c')){return true;} else {return false;}
    }
    public Boolean getdispField7(){
        if(fieldsToDisplay.contains('Field7__c')){return true;} else {return false;}
    }
    public Boolean getdispField8(){
        if(fieldsToDisplay.contains('Field8__c')){return true;} else {return false;}
    }
    public Boolean getdispLoanNumber(){
        if(fieldsToDisplay.contains('Loan_Number__c')){return true;} else {return false;}
    }
    public Boolean getdispAmtGAPMBP(){
        if(fieldsToDisplay.contains('Amount_of_GAP_MBP__c')){return true;} else {return false;}
    }
    public Boolean getdispDeliStreet1(){
        if(fieldsToDisplay.contains('Delivery_Street_Address_1__c')){return true;} else {return false;}
    }
    public Boolean getdispDeliStreet2(){
        if(fieldsToDisplay.contains('Delivery_Street_Address_2__c')){return true;} else {return false;}
    }
    public Boolean getdispDeliCity(){
        if(fieldsToDisplay.contains('Delivery_City__c')){return true;} else {return false;}
    }
    public Boolean getdispDeliState(){
        if(fieldsToDisplay.contains('Delivery_State__c')){return true;} else {return false;}
    }
    public Boolean getdispDeliZipCode(){
        if(fieldsToDisplay.contains('Delivery_Zip_Code__c')){return true;} else {return false;}
    }
    public Boolean getdispPurposeOfReq(){
        if(fieldsToDisplay.contains('Purpose_of_Request__c')){return true;} else {return false;}
    }
    public Boolean getdispDMVStreet1(){
        if(fieldsToDisplay.contains('DMV_Street_Address_1__c')){return true;} else {return false;}
    }
    public Boolean getdispDMVStreet2(){
        if(fieldsToDisplay.contains('DMV_Street_Address_2__c')){return true;} else {return false;}
    }
    public Boolean getdispDMVCity(){
        if(fieldsToDisplay.contains('DMV_City__c')){return true;} else {return false;}
    }
    public Boolean getdispDMVState(){
        if(fieldsToDisplay.contains('DMV_State__c')){return true;} else {return false;}
    }
    public Boolean getdispDMVZipcode(){
        if(fieldsToDisplay.contains('DMV_Zip_Code__c')){return true;} else {return false;}
    }
    public Boolean getdispTitleRelInstruction(){
        if(fieldsToDisplay.contains('Title_Release_Instructions__c')){return true;} else {return false;}
    }

    public Boolean getdispServiceDocRequest(){
        if(serviceDocumentList.size() > 0){
            return true;
        } else {
            return false;
        }
    }

    // Displaying the disclosures based on field logic
    public Boolean getdispDisclosure1(){
        if(fieldsToDisplay.contains('Service_Disclosure1__c')){return true;} else {return false;}
    }
    public Boolean getdispDisclosure2(){
        if(fieldsToDisplay.contains('Service_Disclosure2__c')){return true;} else {return false;}
    }
    public Boolean getdispDisclosure3(){
        if(fieldsToDisplay.contains('Service_Disclosure3__c')){return true;} else {return false;}
    }        
    public Boolean getdispDisclosure4(){
        if(fieldsToDisplay.contains('Service_Disclosure4__c')){return true;} else {return false;}
    }

    public Boolean getdispNotes(){
        if(Service.Notes.size() > 0){
            return true;
        } else {
            return false;
        }
    }

    public Boolean getrenderStatusPosrtal(){
        if(Service.Status__c == 'Open' || Service.Status__c == 'Save For Later'){
            return true;
        } else {
            return false;
        }
    }

    public Boolean getdispSaveForLaterButton(){
        if(oneNdoneServiceType.size() > 0){
            return false;
        } else {
            return true;
        }
    }

    public Boolean validateForm(){
        Boolean b = false;

        if(requiredServiceFields.contains('Field1__c') && svu.validateRequiredFields(Service.Field1__c,'First Name')){
            b = true;
        }

        if(requiredServiceFields.contains('Field3__c') && svu.validateRequiredFields(Service.Field3__c,'Email Address')){
            b = true;
        }

        if(requiredServiceFields.contains('Field4__c') && svu.validatePhoneField(Service.Field4__c)){
            b = true;
        }

        if(requiredServiceFields.contains('Date_Of_Birth__c') && svu.validateRequiredFields(Service.Date_Of_Birth__c,'Date Of Birth')){
            b = true;
        }

        if(requiredServiceFields.contains('Loan_Number__c') && svu.validateRequiredFields(Service.Loan_Number__c,'Loan Number')){
            b = true;
        }

        if(requiredServiceFields.contains('Delivery_Zip_Code__c') && svu.validateZipField(Service.Delivery_Zip_Code__c)){
            b = true;
        }
        return b;
    }

    public PageReference nextStep(){

        if(validateForm()){
            return null;
        } else {
            Integer i = Integer.valueOf(service.Current_Step__c);
            i = i+1;
            if(Integer.valueof(service.Total_Steps__c) > i || Integer.valueof(service.Total_Steps__c) == i){
                service.Current_Step__c = String.Valueof(i);
            }
           update service;
        
            PageReference p = Page.ServiceApp;
            p.getParameters().put('id',sID);
            p.setRedirect(true);
            return p;
        }
	
    }

    public PageReference previousStep(){


        Integer i = Integer.valueOf(service.Current_Step__c);
        i = i-1;
        if(i != null && i > 0){
            service.Current_Step__c = String.Valueof(i);
        }


        update service;

        PageReference p = Page.ServiceApp;
        p.getParameters().put('id',sID);
        p.setRedirect(true);
        return p;
    }

    public PageReference saveForLater(){

        PageReference p = null;

        System.debug('The New value of Last name is '+ lastNameSFLvalueHolder);
        Service.Field2__c = lastNameSFLvalueHolder;
        Service.Field3__c = emailSFLvalueHolder;
        Service.Date_Of_Birth__c = dobSFLvalueHolder;
        if(!ssnSFLvalueHolder.Contains('X')){
            Service.Social_Security_Number__c = ssnSFLvalueHolder;
        }

        String[] toAddresses = new String[] {emailSFLvalueHolder}; 
        EmailTemplate et=[Select id from EmailTemplate where name=:'Service Save For Later'];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(toAddresses);
        email.setTemplateId(et.id);
        email.setTargetObjectId(UserInfo.getUserId());
        email.setWhatId(service.Id);
        email.setSaveAsActivity(false);
        Messaging.SendEmailResult [] r = null;

        try {
            r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        } catch(Exception e) {
            System.debug('The error while sending an email '+e);
        }

        Service.Status__c = 'Save For Later';
        Update Service;
        p = new PageReference('http://www.terafinainc.com/');
        return p;
    }

    public PageReference submitRequest(){

        if(validateForm()){
            return null;
        } else {
            List<Service_Progress__c> updateServiceProgressList = new List<Service_Progress__c>();
            serviceProgress = [SELECT id,Last_Performed_By__c,Step_Number__c,Step_Completed_Timestamp__c,Completed__c,Customer_Email_Address__c FROM Service_Progress__c WHERE Service__c =:sID];
            for(Service_Progress__c serviceProg : serviceProgress){
                if(serviceProg.Step_Number__c != null){
                    if(service.Current_Step__c == serviceProg.Step_Number__c){
                        serviceProg.Completed__c = true;
                        serviceProg.Step_Completed_Timestamp__c = System.now();
                        serviceProg.Customer_Email_Address__c = Service.Field3__c;
                        serviceProg.Last_Performed_By__c = Service.Current_Person__c;
                        updateServiceProgressList.add(serviceProg);
                    }
                }
            }
            //service.Service_Close_Date__c = System.now();
            service.Status__c = 'Submitted';

            //Setting the Submitted information for Service 
            service.Submitted_Timestamp__c = system.now();
            service.Submitted_Person__c = service.Current_Person__c;
            service.Submitted_Branch_Name__c = service.Current_Branch_Name__c;
            service.Submitted_User_Email_Address__c=service.Current_User_Email_Address__c;
            service.Submitted_Channel__c = service.Current_Channel__c;

            DocuSignForService dfs = new DocuSignForService();
            String msg = dfs.main(sID);
            System.debug('The Message from DocuSignForService Class is '+msg);

            String[] toAddresses = new String[] {Service.Field3__c}; 
            EmailTemplate et=[Select id from EmailTemplate where name=:'Submitted Service Request'];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toAddresses);
            email.setTemplateId(et.id);
            email.setTargetObjectId(UserInfo.getUserId());
            email.setWhatId(service.Id);
            email.setSaveAsActivity(false);
            Messaging.SendEmailResult [] r = null;

            try {
                r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            } catch(Exception e) {
                System.debug('The error while sending an email '+e);
            }
            update service;
            
            update updateServiceProgressList;

            if(service.Customer__c != null){
                /*PageReference p = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+service.Customer__c);*/
                PageReference p = new PageReference(Application_Configuration__c.getOrgDefaults().Instance_URL__c+service.Customer__c);
                p.setRedirect(false);
                return p;
            } else {
                PageReference p = Page.thankyoufinal;
                p.setRedirect(false);
                return p;
            }
        }
    }

    public PageReference uploadDoc(){ 
        String cParam = Apexpages.currentPage().getParameters().get('serDocReqid');
        String fileName = Apexpages.currentPage().getParameters().get('nameParam');
        //fileBody = Apexpages.currentPage().getParameters().get('bodyParam');
        system.debug('The Service Doc.Request id is '+cParam);
        system.debug('The Attachment Name is '+fileName);
        system.debug('The Attachment body is '+fileBody);
        //attach = new Attachment();
        system.debug('the file body is '+fileBody);
        system.debug('The file body from Attach.body is '+ attach.Body);
        attach.Body = fileBody;
        system.debug('the file Name is '+fileName);
        attach.Name = fileName;
        attach.ParentId = cParam;
        insert attach;
        //return null;

        //String serviceID = servID;
        PageReference p = Page.ServiceApp;
        p.getParameters().put('id',sID);
        p.setRedirect(true);
        return p;
        return null;
    }

    public PageReference deleteAttachment(){

        system.debug('The service request document id is '+dParam);

        List<Attachment> delAttachList = new List<Attachment>();
        List<Attachment> a = [SELECT id,Name FROM Attachment WHERE id =:dParam];
        if(a.size() > 0){
            delAttachList.add(a[0]);
        }
        delete delAttachList;

        //return null;
        PageReference p = Page.ServiceApp;
        p.getParameters().put('id',sID);
        p.setRedirect(true);
        return p;
    }

    public PageReference addNote(){
        Note n = new Note();
        n.ParentId = sID;
        n.Title = noteTitle;
        n.Body = noteDetails;
        System.debug('The inserting note is '+n);
        insert n;


        PageReference p = Page.ServiceApp;
        p.getParameters().put('id',sID);
        p.setRedirect(true);
        System.debug('Returning p '+p);
        return p;
    }

}