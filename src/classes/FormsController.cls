@RestResource(urlMapping='/forms/*')
global with sharing class FormsController {

    public List<Service_Product__c> productList{get; set;}
    public List<Service_Product__c> subproductList{get; set;}
    public List<Service_Product__c> serviceRequestList{get; set;}
    public List<Service_Type__c> oneNdoneServiceType{get; set;}
    public List<Service_Type__c> filteredServiceList{get; set;}
    public List<Service_Type__c> serviceTypesList{get; set;}
    public Set<Service_Type__c> filteredServiceSet{get; set;}
    public String filteredServiceRequestName{get; set;}
    public String productResult{get;set;}
    public String SubProductResult{get;set;}
    public String ServiceReqResult{get; set;}
    public Set<String> productSet;
    public static Boolean chooseRequest{get; set;}

    public Boolean choiceParam{get; set;}
    public String servicetypeParam{get; set;}
    public String selectedOneNDoneReq{get; set;}

    public String xmlString{get; set;}
    public transient Dom.Document xmlData;
    public Dom.XMLNode address;

    public String serviceId{get; set;}
    public String serviceUt{get; set;}
    public String serviceUserToken{get; set;}
    public Service__c serviceApp{get; set;}
    public Service_Type__c serviceType{get; set;}
    public List<Service_Document_Request__c> serviceDocumentList{get; set;}

    public String searchText{get; set;}

    // declaring variables to display page labels on the page
    public List<Service_Field_Logic__c> pageLabelList{get; set;}
    public Map<String, String> pageLabelMap{get; set;}
    public String pageLabelString{get; set;}
    public String pageLabelJSON{get; set;}
    public String getCurrentChannel{get; set;}
    public String oneStepServiceTypesJSON{get; set;}
    public String multiStepServiceTypesJSON{get; set;}
    public String serviceAppJSON{get; set;}
    public String serviceTypeJSON{get; set;}
    public String serviceDocumentJSON{get; set;}
    public String picklistValuesJSON{get;set;}
    public String saveForLaterRedirectURLValue{get; set;}
    public String submittedRedirectURLValue{get; set;}
    public String timeoutRedirectURLValue{get; set;}
    public Integer idleDurationValue{get; set;}
    public Integer warningDurationValue{get; set;}
    public String siteUrl{get; set;}
    
    public FormsController() {
        Cookie s_id = null;
        this.siteUrl = Service_Configuration__c.getOrgDefaults().Siteurl__c;

        //Fetching the service Id from the URL
        serviceId = ApexPages.currentPage().getParameters().get('id');
        if (serviceId != null && serviceId.length() > 0) {
            s_id = ApexPages.currentPage().getCookies().get('svcId');
            s_id = new Cookie('svcId',serviceId,null,-1,true);
 
            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{s_id});
        }
        s_id = ApexPages.currentPage().getCookies().get('svcId');
        Cookie s_ut = ApexPages.currentPage().getCookies().get('sut');
        if (s_id != null) {
            serviceId = String.valueOf(s_id.getValue());
            if (serviceId != null) {
                serviceApp = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Status__c,Current_Channel__c,Current_Timestamp__c,Current_Person__c,Current_Branch_Name__c,Current_User_Email_Address__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c FROM Service__c WHERE Id = :serviceId];
                if(serviceApp.Current_Channel__c != null){
                   getCurrentChannel =  serviceApp.Current_Channel__c;
                }
                if (serviceApp.Current_Channel__c != 'Online') {
                    submittedRedirectURLValue = Service_Configuration__c.getOrgDefaults().Instance_URL__c+serviceApp.Customer__c;
                    saveForLaterRedirectURLValue = Service_Configuration__c.getOrgDefaults().Instance_URL__c+serviceApp.Customer__c;
                } else {
                    submittedRedirectURLValue = Service_Configuration__c.getOrgDefaults().Siteurl__c+'thankyoufinal';
                    saveForLaterRedirectURLValue = Service_Configuration__c.getOrgDefaults().web_link__c;
                }
                serviceAppJSON = JSON.serialize(serviceApp);
                serviceUserToken = ServiceCryptoHelper.decrypt(serviceApp.User_Token__c);
                String userToken = ServiceCryptoHelper.decrypt(serviceApp.User_Token__c);
                this.serviceUt = userToken;
                s_ut = new Cookie('sut',userToken,null,-1,true);
                ApexPages.currentPage().setCookies(new Cookie[]{s_ut});
            }

            if (s_ut != null) {
                //this.serviceUt = String.valueOf(s_ut.getValue());
            }

        } else {
            if (serviceId == null) {
                //this.serviceId = '';
                //this.serviceUt = '';
            }
        }
        FormsLogger.inputSource('FormsController Class', serviceId);
        filteredServiceList = new List<Service_Type__c>();
        filteredServiceSet = new Set<Service_Type__c>();

        if (serviceApp != null) {
            oneNdoneServiceType = [SELECT id,Name,Keywords__c,Available_in_Channel__c,One_Step_Service__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = true AND Available_in_Channel__c includes (:serviceApp.Current_Channel__c)];
            oneStepServiceTypesJSON = JSON.serialize(oneNdoneServiceType);
            serviceTypesList = [SELECT Id,Name,Keywords__c,Available_in_Channel__c,One_Step_Service__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false AND Available_in_Channel__c includes (:serviceApp.Current_Channel__c)];
            multiStepServiceTypesJSON = JSON.serialize(serviceTypesList);
            if (serviceApp.Service_Request__c != null) {
                List<Service_Type__c> serType = [SELECT id,Name,Keywords__c,Available_in_Channel__c,One_Step_Service__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE Name = :serviceApp.Service_Request__c];
                if (serType.size() > 0) {
                    serviceType = serType[0];
                }
            }
            serviceTypeJSON = JSON.serialize(serviceType);
            serviceDocumentList = [SELECT id,Type__c,Status__c,Service__c,(SELECT id,Name FROM Attachments) FROM Service_Document_Request__c WHERE Service__c =:serviceId];
            serviceDocumentJSON = JSON.serialize(serviceDocumentList);
        }

        pageLabelMap = new Map<String, String>();  
        //pageLabelList = [SELECT Page_Label_Name__c, Page_Label_Value__c, Step_Number__c, Service_Request__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Notes' AND Service_Request__c = :serviceApp.Service_Request__c];
        pageLabelList = [SELECT Page_Label_Name__c, Page_Label_Value__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Labels'];
        for (Service_Field_Logic__c sfl : pageLabelList) {
            pageLabelMap.put(sfl.Page_Label_Name__c,sfl.Page_Label_Value__c);
        }
        pageLabelJSON = JSON.serialize(pageLabelMap);

        //Fetching the XML code
        this.xmlString = ApexPages.currentPage().getParameters().get('xmldata');
        this.xmlData = new DOM.Document();
        system.debug('xmlData is:' + this.xmlString);
        if (this.xmlString != null) {
            this.xmlData.load(this.xmlString);
        }
        picklistValuesJSON = getPickListValues(serviceApp);

        idleDurationValue = Integer.valueOf(Service_Configuration__c.getOrgDefaults().Timeout_Seconds__c);
        System.debug('The value of idleDurationValue is '+idleDurationValue);
        warningDurationValue = Integer.valueOf(Service_Configuration__c.getOrgDefaults().Popup_Seconds__c);
        System.debug('The value of warningDurationValue is '+warningDurationValue);

        timeoutRedirectURLValue = Service_Configuration__c.getOrgDefaults().web_link__c;
    }


    public PageReference checkForRedirect() {
        PageReference p = null;
        try{
            String page = ApexPages.currentPage().getParameters().get('page');
            System.debug('The page is :'+page);
            System.debug('The current url is :'+URL.getCurrentRequestUrl().toExternalForm());
            if (page != null) {
                p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c + 'forms#/' + page);
                ServiceCryptoHelper.refreshToken(serviceApp);
                p.setRedirect(true);
            } else {
                if (!ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
                    p = new PageReference(Service_Configuration__c.getOrgDefaults().web_link__c);
                    p.setRedirect(true);
                }
            }
        } catch(exception e){
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs();
        }
        return p;
    }

    Public String setServiceResource(String channel) {
        String jsonString = '';
        try {
            JSONGenerator gen1 = JSON.createGenerator(true);
            JSONGenerator gen2 = JSON.createGenerator(true);
            
            gen1.writeStartObject();
            List<Service_Type__c> onestepST = [SELECT Id,Name,Available_in_Channel__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = true AND Available_in_Channel__c includes (:channel)];
            
            for (Service_Type__c st: onestepST ) {
                gen1.writeStringField('id', st.id);
                gen1.writeStringField('Name', st.Name);
                gen1.writeStringField('Short Description', st.Short_Description__c);
                gen1.writeStringField('Long Description', st.Long_Description__c);
            }            
            gen1.writeEndObject();
            jsonString = 'SVC.config.oneStepServiceTypes = ' + gen1.getAsString() + ';\n';
            

            gen2.writeStartObject();
            List<Service_Type__c> multistepST = [SELECT Id,Name,Total_SLA__c,Number_of_Steps__c,Keywords__c,Available_in_Channel__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false AND Available_in_Channel__c includes (:channel)];
            for (Service_Type__c st: multistepST) {
                gen2.writeStringField('id', st.id);
                gen2.writeStringField('Name', st.Name);
                gen2.writeNumberField('SLA', st.Total_SLA__c);
                gen2.writeNumberField('Steps', st.Number_of_Steps__c);
                gen2.writeStringField('Keywords', st.Keywords__c);
                gen2.writeStringField('Short Description', st.Short_Description__c);
                gen2.writeStringField('Long Description', st.Long_Description__c);    
            }
            gen2.writeEndObject();
            jsonString = jsonString + '\nSVC.config.multiStepServiceTypes = ' + gen2.getAsString() + ';\n';   
            system.debug('the generated Json string is: '+ jsonString);        


        } catch(Exception e) {
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs();
        }

        return jsonString;
    }

    @RemoteAction
    public static Map<String,List<Schema.PicklistEntry>> getPickListValues(Map<String,String> serviceData) {
        Map<String,List<Schema.PicklistEntry>> data = new Map<String,List<Schema.PicklistEntry>>();
        String serviceId = serviceData.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = serviceData.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c serviceRecord; 
        Schema.DisplayType fielddataType = null;
        List<Schema.PicklistEntry> pick_list_values = null;
        List<String> options = null;
        Map<String,List<String>> allPicklistValues = new Map<String,List<String>>();
        FormsLogger.inputSource('FormsController Class', serviceId);
        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try {
                serviceRecord = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :serviceId];
                if (serviceRecord != null) {
                    String s = JSON.serialize(serviceRecord);
                    // Deserialize it back into a key/value map
                    Map<String,Object> obj1 = (Map<String,Object>) JSON.deserializeUntyped(s);
                    // Build a set containing the fields present on our SObject
                    Set<String> fieldsPresent = obj1.keyset().clone();
                    // Salesforce always adds an extra 'attributes' key to SObjects
                    // when you do JSON stuff, so let's get rid of that.
                    fieldsPresent.remove('attributes');
                    /*
                    for(String fn:fieldsPresent) {
                        system.debug('each of the fields are: '+ fn);
                        if (fn == obj.Field8__c) {
                            system.debug('state field present');
                        }
                    } */

                    Map<String, Schema.SObjectField>fieldMap = serviceRecord.getSobjectType().getDescribe().fields.getMap();
                    //for (String fn : fieldsPresent) {
                    for (String fn : fieldMap.keySet()) {
                        fielddataType = fieldMap.get(fn).getDescribe().getType();
                        try {
                            if (fielddataType == Schema.DisplayType.Picklist) {
                                pick_list_values = fieldMap.get(fn).getDescribe().getPickListValues();
                                data.put(fn, pick_list_values);
                                /*
                                options = new List<String>();
                                if (pick_list_values != null && pick_list_values.size() > 0) {
                                    for (Schema.PicklistEntry a : pick_list_values) {
                                        options.add(a.getValue());
                                    }
                                }
                                */
                            }
                        } catch (Exception e) {
                            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                            FormsLogger.writeAllLogs();
                        }
                    }
                }
            } catch (Exception e) {
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs();
            }
        }
        return data;
    }

    public static String getPickListValues(sObject obj) {
        /*String s = JSON.serialize(obj);
        // Deserialize it back into a key/value map
        Map<String,Object> obj1 = (Map<String,Object>) JSON.deserializeUntyped(s);
        // Build a set containing the fields present on our SObject
        Set<String> fieldsPresent = obj1.keyset().clone();
        // Salesforce always adds an extra 'attributes' key to SObjects
        // when you do JSON stuff, so let's get rid of that.
        for(String fn:fieldsPresent) {
            system.debug('each of the fields are: '+ fn);
            if (fn == obj.Field8__c) {
                system.debug('state field present');
            }
        } 
        fieldsPresent.remove('attributes');*/
           
        String jsonString = '';
        Schema.DisplayType fielddataType = null;
        List<Schema.PicklistEntry> pick_list_values = null;
        List<String> options = null;
        Map<String,List<String>> allPicklistValues = new Map<String,List<String>>();

        if (obj != null) {
            JSONGenerator generator = JSON.createGenerator(true);
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            generator.writeStartObject();
            for (String fn : fieldMap.keySet()) {
                fielddataType = fieldMap.get(fn).getDescribe().getType();
                try {
                    if (fielddataType == Schema.DisplayType.Picklist) {
                        pick_list_values = fieldMap.get(fn).getDescribe().getPickListValues();
                        options = new List<String>();
                        if (pick_list_values != null && pick_list_values.size() > 0) {
                            for (Schema.PicklistEntry a : pick_list_values) {
                                options.add(a.getValue());
                            }
                            generator.writeStringField(fn, String.join(options, ','));
                        }
                    }
                } catch (Exception e) {
                    FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                    FormsLogger.writeAllLogs();
                }
            }

            generator.writeEndObject();
            jsonString += generator.getAsString();
        }
 
        return jsonString;
    }


    @RemoteAction
    public static Map<String,sObject> retrieveService(Map<String,String> data) {
        system.debug('Inside retreive service method');
        Map<String,sObject> servData = new Map<String,sObject>();
        String userToken = null;
        ID sID = data.get('serviceId');
        FormsLogger.inputSource('FormsController Class', sID);
        Service__c service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Status__c,Current_Channel__c,Current_Timestamp__c,Current_Person__c,Current_Branch_Name__c,Current_User_Email_Address__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
        try {
            String lastName = data.get('lastName');
            String dob = data.get('dob');
            String email = data.get('email');
            String ssn = data.get('ssn');
            String ssnLastFour = '';

            if (service.Social_Security_Number__c != null) {
                ssnLastFour = service.Social_Security_Number__c.subString(service.Social_Security_Number__c.length()-4,service.Social_Security_Number__c.length());
            }
            if (lastName == service.Field2__c && dob == service.Date_Of_Birth__c && email.toLowerCase() == service.Field3__c.toLowerCase()  && ssn == ssnLastFour) {
                if (service.Status__c == 'Open' || service.Status__c == 'Save For Later') {
                    service.Status__c = 'Open';
                    service.Current_Channel__c = 'Online';
                    service.Current_Timestamp__c = System.now();
                    service.Current_Person__c = system.userInfo.getUserId();
                    service.Current_Branch_Name__c = '';
                    service.Current_User_Email_Address__c = '';
                    service.Current_Step__c = '1';
                    ServiceCryptoHelper.refreshToken(service);
                    update service;
                } else {
                    ServiceCryptoHelper.refreshToken(service);
                    system.debug('Into the else condition');
                    //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Incorrect data for this service application. Please re-check the information you entered'));
                }
                //service = fetchServiceRecord(data);
                userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);
            } else {
                system.debug('values do not match');
                String msg = '';
                //msg = 'Expected lastName:' + service.Field2__c + '- received lastName:' + lastName + '; Expected dob:' + service.Date_Of_Birth__c + '- received dob:' + dob + '; Expected email:' +service.Field3__c.toLowerCase() + '- received email:' + email.toLowerCase() + '; Expected ssn:' + ssnLastFour + '- received ssn:' + ssn;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Cannot find the record. Please re-check the information you entered. ' + msg));
            }
        } catch (Exception e) {
            servData.put('debug-server-errors', ServiceUtility.getMessageObject(e.getMessage()));
            servData.put('server-errors-stack-trace', ServiceUtility.getMessageObject(e.getStackTraceString()));
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }

        servData.put('serviceRecord', (sObject)service);
        ServiceUtility.getServerMessages(servData);
        servData.put('serviceUt', ServiceUtility.getMessageObject(userToken));
        return servData;        
    }


    @RemoteAction
    public static List<Service_Type__c> oneStepServiceTypes(Map<String,String> data) {
        String channel = data.get('channel');
        return [SELECT Id,Name,Available_in_Channel__c,One_Step_Service__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = true AND Available_in_Channel__c includes (:channel)];
    }

    @RemoteAction
    public static List<Service_Type__c> multiStepServiceTypes(Map<String,String> data) {
        String channel = data.get('channel');
        return [SELECT Id,Name,Total_SLA__c,Number_of_Steps__c,Keywords__c,Available_in_Channel__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false AND Available_in_Channel__c includes (:channel)];
    }

    @RemoteAction
    public static List<Service_Product__c> getProductList(Map<String,String> data) {
        List<Service_Product__c> productList = null;        
        String filteredServiceRequestName = data.get('filteredServiceRequestName');            
        if (filteredServiceRequestName == null || filteredServiceRequestName == 'None') {
        } 
        else {
            Set<String> productSet = new Set<String>();
            List<Service_Type__c> serType = [SELECT id,Name FROM Service_Type__c WHERE Name = :filteredServiceRequestName];
            if (serType.size() > 0) {
                productList = [SELECT id,Product__c,Sub_Product__c,Service_Type__c FROM Service_Product__c WHERE Service_Type__c = :serType[0].Id];
                if (productList.size() > 0) {
                    for (Service_Product__c spp : productList) {
                       productSet.add(spp.Product__c); 
                    }
                }
            }
        }
        return productList;
    }

    public PageReference startServiceReq() {

        if (filteredServiceRequestName == null && selectedOneNDoneReq == null) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please Select a Service Request'));
            return null;
        } else {
            if (serviceId == null) {
                Service__c serviceForm = new Service__c();
                if (selectedOneNDoneReq == null) {
                    if (productResult != 'None') {
                        serviceForm.Product__c = productResult;
                    }
                    if (SubProductResult != 'None') {
                        serviceForm.Sub_Product__c = SubProductResult;
                    }
                    serviceForm.Service_Request__c = filteredServiceRequestName;
                } else {
                    /*serviceForm.Product__c = 'None';
                    serviceForm.Sub_Product__c = 'None';*/
                    serviceForm.Service_Request__c = selectedOneNDoneReq;
                }

                serviceForm.Current_Step__c = '1';
                try{
                    insert serviceForm;
                } catch(exception e){
                    FormsLogger.inputSource('FormsController Class', serviceForm.id);
                    FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                    FormsLogger.writeAllLogs();
                }               

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceForm.id);
                p.setRedirect(true);
                return p;
            } else {
                try{
                    serviceApp = [SELECT Product__c,Sub_Product__c,Service_Request__c,One_N_Done__c FROM Service__c WHERE id = :serviceId];
                    if (selectedOneNDoneReq == null) {
                        if (productResult != 'None') {
                            serviceApp.Product__c = productResult;
                        }
                        if (SubProductResult != 'None') {
                            serviceApp.Sub_Product__c = SubProductResult;
                        }   
                        serviceApp.Service_Request__c = filteredServiceRequestName;
                    } else {
                        /*serviceApp.Product__c = 'None';
                        serviceApp.Sub_Product__c = 'None';*/
                        serviceApp.Service_Request__c = selectedOneNDoneReq;
                    }
                    serviceApp.Current_Step__c = '1';
                    update serviceApp;
                } catch(exception e){
                    FormsLogger.inputSource('FormsController Class', serviceId);
                    FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                    FormsLogger.writeAllLogs();                    
                }

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceApp.id);
                p.setRedirect(true);
                return p;                
            }
        }

    }

    public PageReference generateServiceApp() {
        PageReference p = null;
        Service__c servicePrefill = new Service__c();
        try{
            if (xmlString != null) {
                system.debug('The XML exists #####'+xmlString);
                address = xmlData.getRootElement();

                // Updating the prefill information for Customer from XML
                if (xmlString.contains('firstName')) {
                    servicePrefill.Field1__c = address.getChildElement('firstName', null).getText();    
                } 
                if (xmlString.contains('lastName')) {
                    servicePrefill.Field2__c = address.getChildElement('lastName', null).getText();    
                }  
                if (xmlString.contains('phoneNumber')) {
                    servicePrefill.Field3__c = address.getChildElement('emailAddress', null).getText();    
                }   
                if (xmlString.contains('emailAddress')) {
                    servicePrefill.Field4__c = address.getChildElement('phoneNumber', null).getText();    
                } 
                if (xmlString.contains('customersID')) {
                    servicePrefill.Customer__c = address.getChildElement('customersID', null).getText();    
                }
                // Updating the Created user/type/channel information
                if (xmlString.contains('CreatedByUserId')) {
                    servicePrefill.Created_Person__c = address.getChildElement('CreatedByUserId', null).getText();
                    servicePrefill.Ownerid = address.getChildElement('CreatedByUserId', null).getText();
                }
                if (xmlString.contains('CreatedByBranch')) {
                    servicePrefill.Created_Branch_Name__c  = address.getChildElement('CreatedByBranch', null).getText(); 
                }  
                if (xmlString.contains('CreatedByChannel')) {
                    servicePrefill.Created_Channel__c = address.getChildElement('CreatedByChannel', null).getText();    
                }  
                if (xmlString.contains('CreatedEmailAddress')) {
                    servicePrefill.Created_User_Email_Address__c = address.getChildElement('CreatedEmailAddress', null).getText();
                }              
                // Updating the current user/type/channel information
                if (xmlString.contains('CurrentPerson')) {
                    servicePrefill.Current_Person__c = address.getChildElement('CurrentPerson', null).getText(); 
                }            
                if (xmlString.contains('CurrentBranch')) {
                    servicePrefill.Current_Branch_Name__c = address.getChildElement('CurrentBranch', null).getText();
                }
                if (xmlString.contains('CurrentChannel')) {
                    servicePrefill.Current_Channel__c = address.getChildElement('CurrentChannel', null).getText();
                }
                if (xmlString.contains('CurrentEmailAddress')) {
                    servicePrefill.Current_User_Email_Address__c = address.getChildElement('CurrentEmailAddress', null).getText();
                }
                //Updating the Current and Created Timestamps
                servicePrefill.Current_Timestamp__c = System.now();
                servicePrefill.Created_Timestamp__c = System.now();
                servicePrefill.Status__c = 'Open';

                if (Service__c.SObjectType.getDescribe().isCreateable()) {
                    insert servicePrefill;
                }

                p = Page.ServiceApp;
                p.getParameters().put('id',servicePrefill.Id);
            }
        } catch(exception e){
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return p;
    }

    @RemoteAction
    public static Map<String,sObject> saveNStartRequest(Map<String,String> serviceDataMap) {
        Service__c serviceRecord = null;
        Map<String,sObject> servData = new Map<String,sObject>();

        List<Service_Field_Logic__c> pageNotesList = new List<Service_Field_Logic__c>();
        String pageNotesJson = null;

        Map<String,String> data = serviceDataMap.clone();
        String serviceId = data.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = data.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;

        Service_Type__c servType = [SELECT Id,Name,One_Step_Service__c FROM Service_Type__c WHERE Name = :serviceDataMap.get('Service_Request__c')];
        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try {
                if (serviceDataMap != null) {
                    serviceId = serviceDataMap.get('serviceId');
                    //String sut = serviceDataMap.get('sut');
                    if (serviceId != null) {
                        System.debug(LoggingLevel.Error,'The received MAP is '+serviceDataMap);
                        System.debug(LoggingLevel.Error,'The Service ID from the map is '+serviceId);
                        serviceRecord = [SELECT Current_Step__c, Product__c,User_Token__c,Sub_Product__c,Service_Request__c,One_N_Done__c FROM Service__c WHERE id = :serviceId];     
                        if (servType != null) {
                            serviceRecord.One_N_Done__c = servType.One_Step_Service__c;
                        }
                        serviceRecord.Service_Request__c = serviceDataMap.get('Service_Request__c');
                        serviceRecord.Product__c = serviceDataMap.get('Product__c');
                        serviceRecord.Sub_Product__c = serviceDataMap.get('Sub_Product__c');
                        if (serviceRecord.Current_Step__c == null || !(Integer.valueOf(serviceRecord.Current_Step__c) > 1)) {
                            serviceRecord.Current_Step__c = '1';
                        }
                        update serviceRecord;
                        ServiceCryptoHelper.refreshToken(serviceRecord);
                        userToken = ServiceCryptoHelper.decrypt(serviceRecord.User_Token__c);

                        System.debug('The updated Service record is '+serviceRecord);
                        serviceRecord = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,Status__c,Current_Channel__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :serviceId];
                        pageNotesList = [SELECT Page_Label_Name__c, Page_Label_Value__c, Step_Number__c, Service_Request__c, Field_Name__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Notes' AND Service_Request__c = :serviceRecord.Service_Request__c AND Step_Number__c = :serviceRecord.Current_Step__c ORDER BY Page_Label_Name__c];
                    } else {
                        serviceRecord = new Service__c();
                        if (servType != null) {
                            serviceRecord.One_N_Done__c = servType.One_Step_Service__c;
                        }
                        serviceRecord.Service_Request__c = serviceDataMap.get('Service_Request__c');
                        serviceRecord.Product__c = serviceDataMap.get('Product__c');
                        serviceRecord.Sub_Product__c = serviceDataMap.get('Sub_Product__c');
                        serviceRecord.Current_Step__c = '1';
                        insert serviceRecord;
                        System.debug(LoggingLevel.Error,'The created Service record is '+serviceRecord);
                    }
                }
            } catch (Exception e) {
                FormsLogger.inputSource('FormsController Class', serviceId);
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }

            pageNotesJson = JSON.serialize(pageNotesList);
            servData.put('pageNotes', ServiceUtility.getMessageObject(pageNotesJson));
            servData.put('serviceRecord', (sObject)serviceRecord);
            servData.put('serviceUt',ServiceUtility.getMessageObject(userToken));
            ServiceUtility.getServerMessages(servData); 
        } else{
            servData.put('server-errors', ServiceUtility.getMessageObject('Your session has expired due to inactivity.'));
        }   
        return servData;
    }

    @RemoteAction
    public static List<Note> fetchNotes(Map<String,String> serviceDataMap) {
        List<Note> notes = null;
        try {
            if (serviceDataMap != null) {
                Id serviceId = serviceDataMap.get('serviceId');
                if (serviceId != null) {
                    notes = [SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Note WHERE ParentId = :serviceId];
                }
            }
        } catch (Exception e) {
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return notes;
    }

    @RemoteAction
    public static Service__c fetchServiceRecord(Map<String,String> serviceDataMap) {
        Service__c serviceRecord;
        Id serviceId;
        try{
            if (serviceDataMap != null) {
                serviceId = serviceDataMap.get('serviceId');
                String serviceUt = serviceDataMap.get('serviceUt');
                if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
                    serviceRecord = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :serviceId];
                }
            }
        } catch(exception e){
            FormsLogger.inputSource('FormsController Class', serviceId);
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return serviceRecord;
    }

    @RemoteAction
    public static Set<String> fetchDisplayFields(Map<String,String> serviceDataMap) {
        Set<String> fieldsToDisplay = new Set<String>();
        Id serviceId;
        try{
            if (serviceDataMap != null) {
                serviceId = serviceDataMap.get('serviceId');
                System.debug('The received service id fetchDisplayFields is '+serviceId);
                ServiceUtility su= new ServiceUtility();
                if (serviceId != null) {
                    fieldsToDisplay = su.fieldsToRender(serviceId);
                }
                System.debug('The fields to render are '+fieldsToDisplay);
                System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());
            }
        } catch(exception e){
            FormsLogger.inputSource('FormsController Class', serviceId);
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return fieldsToDisplay;
    }

    @RemoteAction
    public static Set<String> fetchRequiredFields(Map<String,String> serviceDataMap) {
        Set<String> requiredServiceFields = new Set<String>();
        Id serviceId;
        try{
            if (serviceDataMap != null) {
                serviceId = serviceDataMap.get('serviceId');
                ServiceUtility su= new ServiceUtility();
                if (serviceId != null) {
                   requiredServiceFields = su.requiredFields(serviceId); 
                }
                System.debug('The required fields are '+requiredServiceFields);
                System.debug('The size of required fields list is  '+requiredServiceFields.size());
            }
        } catch(exception e){
            FormsLogger.inputSource('FormsController Class', serviceId);
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return requiredServiceFields;
    }

    @RemoteAction
    public static Map<String,Set<String>> fetchEverything(Map<String,String> serviceDataMap) {
        
        Map<String,Set<String>> everyThingMap = new Map<String,Set<String>>();
        Id serviceId;
        try{
            Set<String> fieldsToDisplay = new Set<String>();
            Set<String> requiredServiceFields = new Set<String>();
            System.debug('The ServiceDataMap is '+serviceDataMap);
            if (serviceDataMap != null) {
                serviceId = serviceDataMap.get('serviceId');
                System.debug('The received service id fetchDisplayFields is '+serviceId);
                ServiceUtility su= new ServiceUtility();
                if (serviceId != null) {
                    fieldsToDisplay = su.fieldsToRender(serviceId);
                    requiredServiceFields = su.requiredFields(serviceId);
                }
                System.debug('The fields to render are '+fieldsToDisplay);
                System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());

                System.debug('The required fields are '+requiredServiceFields);
                System.debug('The size of required fields list is  '+requiredServiceFields.size());
            }

            everyThingMap.put('fieldsToDisplay',fieldsToDisplay);
            everyThingMap.put('requiredServiceFields',requiredServiceFields);

            Set<String> disclosureList = new Set<String>();
            // variable to hold the URL of the disclosures
            String disclosure1Url;
            String disclosure2Url;
            String disclosure3Url;
            String disclosure4Url;
            String disclosure5Url;
            String disclosure6Url;
            String disclosure7Url;
            String disclosure8Url;
            String disclosure9Url;
            String disclosure10Url;

            String currentChannel = serviceDataMap.get('channel');
            System.debug('The current Channel is '+currentChannel);
            List<Service_Disclosure__c> dis1 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure1').Disclosure_Label__c];
             List<Attachment> att1 = new List<Attachment>();
             if (dis1.size() > 0) {
                 att1 = dis1[0].Attachments;
                 if (att1.size()>0) {
                     disclosure1Url = 'disclosure1Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att1.get(0).id;
                     disclosureList.add(disclosure1Url);
                 }
             }
             List<Service_Disclosure__c> dis2 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure2').Disclosure_Label__c];
             List<Attachment> att2 = new List<Attachment>();
             if (dis2.size() > 0) {
                 att2 = dis2[0].Attachments;
                 if (att2.size()>0) {
                     disclosure2Url = 'disclosure2Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att2.get(0).id;
                     disclosureList.add(disclosure2Url);
                 }
             }
             List<Service_Disclosure__c> dis3 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure3').Disclosure_Label__c];
             List<Attachment> att3 = new List<Attachment>();
             if (dis3.size() > 0) {
                 att3 = dis3[0].Attachments;
                 if (att3.size()>0) {
                     disclosure3Url = 'disclosure3Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att3.get(0).id;
                     disclosureList.add(disclosure3Url);
                 }
             }
             List<Service_Disclosure__c> dis4 = [SELECT Id,Name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure4').Disclosure_Label__c];
             List<Attachment> att4 = new List<Attachment>();
             if (dis4.size() > 0) {
                 att4 = dis4[0].Attachments;
                 if (att4.size()>0) {
                     disclosure4Url = 'disclosure4Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att4.get(0).id;
                     disclosureList.add(disclosure4Url);
                 }
             }
             /* List<Service_Disclosure__c> dis5 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure5').Disclosure_Label__c];
             List<Attachment> att5 = new List<Attachment>();
             if (dis5.size() > 0) {
                 att5 = dis5[0].Attachments;
                 if (att5.size()>0) {
                     disclosure5Url = 'disclosure5Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att5.get(0).id;
                     disclosureList.add(disclosure5Url);
                 }
             }
             List<Service_Disclosure__c> dis6 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure6').Disclosure_Label__c];
             List<Attachment> att6 = new List<Attachment>();
             if (dis6.size() > 0) {
                 att6 = dis6[0].Attachments;
                 if (att6.size()>0) {
                     disclosure6Url = 'disclosure6Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att6.get(0).id;
                     disclosureList.add(disclosure6Url);
                 }
             }
             List<Service_Disclosure__c> dis7 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure7').Disclosure_Label__c];
             List<Attachment> att7 = new List<Attachment>();
             if (dis7.size() > 0) {
                 att7 = dis7[0].Attachments;
                 if (att7.size()>0) {
                     disclosure7Url = 'disclosure7Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att7.get(0).id;
                     disclosureList.add(disclosure7Url);
                 }
             }
             List<Service_Disclosure__c> dis8 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure8').Disclosure_Label__c];
             List<Attachment> att8 = new List<Attachment>();
             if (dis8.size() > 0) {
                 att8 = dis8[0].Attachments;
                 if (att8.size()>0) {
                     disclosure8Url = 'disclosure8Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att8.get(0).id;
                     disclosureList.add(disclosure8Url);
                 }
             }
             List<Service_Disclosure__c> dis9 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure9').Disclosure_Label__c];
             List<Attachment> att9 = new List<Attachment>();
             if (dis9.size() > 0) {
                 att9 = dis9[0].Attachments;
                 if (att9.size()>0) {
                     disclosure9Url = 'disclosure9Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att9.get(0).id;
                     disclosureList.add(disclosure9Url);
                 }
             }
             List<Service_Disclosure__c> dis10 = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__c WHERE RecordType.name = :currentChannel AND Name = :Disclosure_Names__c.getValues('Service_Disclosure10').Disclosure_Label__c];
             List<Attachment> att10 = new List<Attachment>();
             if (dis10.size() > 0) {
                 att10 = dis10[0].Attachments;
                 if (att10.size()>0) {
                     disclosure10Url = 'disclosure10Url;'+URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att10.get(0).id;
                     disclosureList.add(disclosure10Url);
                 }
             }*/
            everyThingMap.put('disclosureList',disclosureList);
        } catch(exception e){
            FormsLogger.inputSource('FormsController Class', serviceId);
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }
        return everyThingMap;
    }


    public static Boolean validateForm(Set<String> requiredServiceFields, ServiceValidationUtility svu, Service__c service) {
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Service__c').getDescribe().fields.getMap();
        system.debug('in the validate form method.');
        Boolean b = false;
        try{
            if (requiredServiceFields.contains('Field1__c') && svu.validateRequiredFields(service.Field1__c,fieldMap.get('Field1__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Field3__c') && svu.validateRequiredFields(service.Field3__c,fieldMap.get('Field3__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Loan_Number__c') && svu.validateAccountNumber(service.Loan_Number__c,fieldMap.get('Loan_Number__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Amount_of_GAP_MBP__c') && svu.validateCurrencyRequiredFields(service.Amount_of_GAP_MBP__c,fieldMap.get('Amount_of_GAP_MBP__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Field7__c') && svu.validateRequiredFields(service.Field7__c,fieldMap.get('Field7__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Date_Of_Birth__c') && svu.validateRequiredFields(service.Date_Of_Birth__c,fieldMap.get('Date_Of_Birth__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Delivery_City__c') && svu.validateRequiredFields(service.Delivery_City__c,fieldMap.get('Delivery_City__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Delivery_State__c') && svu.validateRequiredFields(service.Delivery_State__c,fieldMap.get('Delivery_State__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Delivery_Street_Address_1__c') && svu.validateRequiredFields(service.Delivery_Street_Address_1__c,fieldMap.get('Delivery_Street_Address_1__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Delivery_Street_Address_2__c') && svu.validateRequiredFields(service.Delivery_Street_Address_2__c,fieldMap.get('Delivery_Street_Address_2__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Delivery_Zip_Code__c') && svu.validateZipField(service.Delivery_Zip_Code__c)) {
                b = true;
            }

            if (requiredServiceFields.contains('DMV_City__c') && svu.validateRequiredFields(service.DMV_City__c,fieldMap.get('DMV_City__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('DMV_State__c') && svu.validateRequiredFields(service.DMV_State__c,fieldMap.get('DMV_State__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('DMV_Street_Address_1__c') && svu.validateRequiredFields(service.DMV_Street_Address_1__c,fieldMap.get('DMV_Street_Address_1__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('DMV_Street_Address_2__c') && svu.validateRequiredFields(service.DMV_Street_Address_2__c,fieldMap.get('DMV_Street_Address_2__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('DMV_Zip_Code__c') && svu.validateZipField(service.DMV_Zip_Code__c)) {
                b = true;
            }

            if (requiredServiceFields.contains('Field2__c') && svu.validateRequiredFields(service.Field2__c,fieldMap.get('Field2__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Field4__c') && svu.validatePhoneField(service.Field4__c)) {
                b = true;
            }

            if (requiredServiceFields.contains('Purpose_of_Request__c') && svu.validateRequiredFields(service.Purpose_of_Request__c,fieldMap.get('Purpose_of_Request__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Social_Security_Number__c') && svu.validateRequiredFields(service.Social_Security_Number__c,fieldMap.get('Social_Security_Number__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Field5__c') && svu.validateRequiredFields(service.Field5__c,fieldMap.get('Field5__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Field6__c') && svu.validateRequiredFields(service.Field6__c,fieldMap.get('Field6__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Title_Release_Instructions__c') && svu.validateRequiredFields(service.Title_Release_Instructions__c,fieldMap.get('Title_Release_Instructions__c').getDescribe().getLabel())) {
                b = true;
            }

            if (requiredServiceFields.contains('Service_Disclosure1__c') && svu.validateDisclosures(service.Service_Disclosure1__c,Disclosure_Names__c.getValues('Service_Disclosure1').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure2__c') && svu.validateDisclosures(service.Service_Disclosure2__c,Disclosure_Names__c.getValues('Service_Disclosure2').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure3__c') && svu.validateDisclosures(service.Service_Disclosure3__c,Disclosure_Names__c.getValues('Service_Disclosure3').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure4__c') && svu.validateDisclosures(service.Service_Disclosure4__c,Disclosure_Names__c.getValues('Service_Disclosure4').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure5__c') && svu.validateDisclosures(service.Service_Disclosure5__c,Disclosure_Names__c.getValues('Service_Disclosure5').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure6__c') && svu.validateDisclosures(service.Service_Disclosure6__c,Disclosure_Names__c.getValues('Service_Disclosure6').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure7__c') && svu.validateDisclosures(service.Service_Disclosure7__c,Disclosure_Names__c.getValues('Service_Disclosure7').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure8__c') && svu.validateDisclosures(service.Service_Disclosure8__c,Disclosure_Names__c.getValues('Service_Disclosure8').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure9__c') && svu.validateDisclosures(service.Service_Disclosure9__c,Disclosure_Names__c.getValues('Service_Disclosure9').Disclosure_Label__c)) {
                b = true;
            }
            if (requiredServiceFields.contains('Service_Disclosure10__c') && svu.validateDisclosures(service.Service_Disclosure10__c,Disclosure_Names__c.getValues('Service_Disclosure10').Disclosure_Label__c)) {
                b = true;
            }
        } catch(exception e){
            FormsLogger.inputSource('FormsController Class', service.id);
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        }        

        return b;
    }

    public static Map<String,String> removeUnwantedFields(Map<String,String> data) {
        data.remove('Total_SLA__c');
        data.remove('Total_Steps__c');
        data.remove('Name');
        data.remove('Notes');
        data.remove('Service_Close_Date__c');
        data.remove('Submitted_Timestamp__c');
        data.remove('Current_Timestamp__c');
        data.remove('Created_Timestamp__c');
        data.remove('attributes');
        return data;
    }

    @RemoteAction
    public static Map<String,sObject> nextStep(Map<String,String> tmpData) {
        Map<String,String> serviceDataMap = tmpData.clone();

        List<Service_Field_Logic__c> pageNotesList = new List<Service_Field_Logic__c>();
        String pageNotesJson = null;

        Map<String,sObject> data = new Map<String,sObject>();
        String serviceId = serviceDataMap.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = serviceDataMap.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c service;
        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try {
                if (serviceDataMap != null) {
                    Id sID = serviceDataMap.get('serviceId');
                    removeUnwantedFields(serviceDataMap);
                    system.debug('in the next step');
                    List<Service_Progress__c> serviceProgress;
                    ServiceValidationUtility svu;
                    Set<String> fieldsToDisplay;
                    Set<String> requiredServiceFields;
                    fieldsToDisplay = new Set<String>();
                    ServiceUtility su = new ServiceUtility();
                    fieldsToDisplay = su.fieldsToRender(sID);
                    System.debug('The fields to render are '+fieldsToDisplay);
                    System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());
                    requiredServiceFields = su.requiredFields(sID);
                    System.debug('The required fields are '+requiredServiceFields);
                    System.debug('The size of required fields list is  '+requiredServiceFields.size());
                    svu = new ServiceValidationUtility();
                    service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,Status__c,User_Token__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
                    ServiceUtility.setData(serviceDataMap, (Service__c)service);

                    if (!validateForm(requiredServiceFields, svu, service)) {
                        Integer i = Integer.valueOf(service.Current_Step__c);
                        i = i+1;
                        if (Integer.valueof(service.Total_Steps__c) > i || Integer.valueof(service.Total_Steps__c) == i) {
                            service.Current_Step__c = String.Valueof(i);
                        }
                        update service;
                        pageNotesList = [SELECT Page_Label_Name__c, Page_Label_Value__c, Step_Number__c, Service_Request__c, Field_Name__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Notes' AND Service_Request__c = :service.Service_Request__c AND Step_Number__c = :service.Current_Step__c ORDER BY Page_Label_Name__c];
                        ServiceCryptoHelper.refreshToken(service);
                        userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);
                        data.put('serviceRecord', (sObject)service);

                        fieldsToDisplay = su.fieldsToRender(sID);
                        requiredServiceFields = su.requiredFields(sID);
                        data.put('fieldsToDisplay', ServiceUtility.getMessageObject(String.join(new List<String>(fieldsToDisplay), ';')));
                        data.put('requiredServiceFields', ServiceUtility.getMessageObject(String.join(new List<String>(requiredServiceFields), ';')));
                    }
                    pageNotesJson = JSON.serialize(pageNotesList);
                    data.put('pageNotes', ServiceUtility.getMessageObject(pageNotesJson));
                }

                ServiceUtility.getServerMessages(data);    
            } catch (Exception e) {
                data.put('debug-server-errors', ServiceUtility.getMessageObject(e.getMessage()));
                data.put('server-errors-stack-trace', ServiceUtility.getMessageObject(e.getStackTraceString()));
                FormsLogger.inputSource('FormsController Class', serviceId);
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }
        } else {
            System.debug('The user token is not valid on Next Click');
            data.put('server-errors', ServiceUtility.getMessageObject('Your session has expired due to inactivity.'));
        }

        return data;
    }

    @RemoteAction
    public static Map<String,sObject> previousStep(Map<String,String> tmpData) {
        Map<String,String> serviceDataMap = tmpData.clone();

        List<Service_Field_Logic__c> pageNotesList = new List<Service_Field_Logic__c>();
        String pageNotesJson = null;

        Map<String,sObject> data = new Map<String,sObject>();
        String serviceId = serviceDataMap.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = serviceDataMap.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c service;

        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try{
                if (serviceDataMap != null) {
                    Id sID = serviceDataMap.get('serviceId');
                    removeUnwantedFields(serviceDataMap);
                    service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
                    ServiceUtility.setData(serviceDataMap, (Service__c)service);

                    Integer i = Integer.valueOf(service.Current_Step__c);
                    i = i-1;
                    if (i != null && i > 0) {
                        service.Current_Step__c = String.Valueof(i);
                    }
                    update service;
                    pageNotesList = [SELECT Page_Label_Name__c, Page_Label_Value__c, Step_Number__c, Service_Request__c, Field_Name__c FROM Service_Field_Logic__c WHERE RecordType.name = 'Page Notes' AND Service_Request__c = :service.Service_Request__c AND Step_Number__c = :service.Current_Step__c ORDER BY Page_Label_Name__c];
                    ServiceCryptoHelper.refreshToken(service);
                    userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);
                    data.put('serviceRecord', (sObject)service);

                    Set<String> fieldsToDisplay;
                    Set<String> requiredServiceFields;
                    fieldsToDisplay = new Set<String>();
                    ServiceUtility su = new ServiceUtility();
                    fieldsToDisplay = su.fieldsToRender(sID);
                    fieldsToDisplay = su.fieldsToRender(sID);
                    requiredServiceFields = su.requiredFields(sID);
                    data.put('fieldsToDisplay', ServiceUtility.getMessageObject(String.join(new List<String>(fieldsToDisplay), ';')));
                    data.put('requiredServiceFields', ServiceUtility.getMessageObject(String.join(new List<String>(requiredServiceFields), ';')));
                    pageNotesJson = JSON.serialize(pageNotesList);
                    data.put('pageNotes', ServiceUtility.getMessageObject(pageNotesJson));
                }

                data.put('serviceUt', ServiceUtility.getMessageObject(userToken));
                ServiceUtility.getServerMessages(data);
            } catch(Exception e) {
                data.put('debug-server-errors', ServiceUtility.getMessageObject(e.getMessage()));
                data.put('server-errors-stack-trace', ServiceUtility.getMessageObject(e.getStackTraceString()));
                FormsLogger.inputSource('FormsController Class', serviceId);
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }
        } else {
           data.put('server-errors', ServiceUtility.getMessageObject('Your session has expired due to inactivity.')); 
        }
        return data;
    }

    @RemoteAction
    public static Map<String,String> saveForLater(Map<String,String> serviceDataMap) {
        system.debug('save for later incoming data: '+serviceDataMap);
        Map<String,String> data = serviceDataMap.clone();
        String serviceId = data.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = data.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c service;
        FormsLogger.inputSource('FormsController Class', serviceId);
        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try{
                if (serviceDataMap != null) {
                    removeUnwantedFields(data);
                    Id sID = serviceDataMap.get('serviceId');                    
                    service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,Account_Number__c,Account_Type__c,One_N_Done__c,User_Token__c,Current_Channel__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c FROM Service__c WHERE Id = :sID];
                    try {
                        ServiceUtility.setData(data, (Service__c)service);
                    } catch(Exception e) {
                        system.debug('Exception while saving all the service app data. The exception is: '+e.getMessage());
                        Service.Field2__c = data.get('Field2__c');
                        Service.Field3__c = data.get('Field3__c');
                        Service.Date_Of_Birth__c = data.get('Date_Of_Birth__c');
                        if (!data.get('Social_Security_Number__c').Contains('X')) {
                            Service.Social_Security_Number__c = data.get('Social_Security_Number__c');
                        }
                    }
                    
                    String[] toAddresses = new String[] {data.get('Field3__c')}; 
                    EmailTemplate et=[Select id from EmailTemplate where name=:'Save For Later - Service'];
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
                        FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                        FormsLogger.writeAllLogs(); 
                    }

                    Service.Status__c = 'Save For Later';
                    update Service;
                    userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);
                }

                //data.put('serviceUt', ServiceUtility.getMessageObject(userToken));
                data.put('serviceUt',userToken);
                ServiceUtility.getServerMessages(data); 

            } catch(Exception e) {
                data.put('debug-server-errors', e.getMessage());
                data.put('server-errors-stack-trace', e.getStackTraceString());
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }

        } else {
            data.put('server-errors', 'Your session has expired due to inactivity.'); 
        }
   
        return data;
    }

    @RemoteAction
    public static Map<String,String> submitRequest(Map<String,String> serviceDataMap) {
        Map<String,String> data = serviceDataMap.clone();
        String serviceId = data.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = data.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c service;
        FormsLogger.inputSource('FormsController Class', serviceId);

        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try {
                if (serviceDataMap != null) {
                    removeUnwantedFields(data);
                    Id sID = serviceDataMap.get('serviceId');
                    List<Service_Progress__c> serviceProgress;
                    ServiceValidationUtility svu;
                    Set<String> fieldsToDisplay;
                    Set<String> requiredServiceFields;
                    fieldsToDisplay = new Set<String>();
                    ServiceUtility su = new ServiceUtility();
                    fieldsToDisplay = su.fieldsToRender(sID);
                    System.debug('The fields to render are '+fieldsToDisplay);
                    System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());
                    requiredServiceFields = su.requiredFields(sID);
                    System.debug('The required fields are '+requiredServiceFields);
                    System.debug('The size of required fields list is  '+requiredServiceFields.size());
                    FormsLogger.inputSource('FormsController Class', serviceId);                               
                    svu = new ServiceValidationUtility();
                    service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,One_N_Done__c,User_Token__c,Current_Person__c,Current_Branch_Name__c,Current_User_Email_Address__c,Submitted_Channel__c,Submitted_User_Email_Address__c,Submitted_Branch_Name__c,Submitted_Person__c,Submitted_Timestamp__c,Current_Channel__c,Status__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c FROM Service__c WHERE Id = :sID];

                    ServiceUtility.setData(data, (Service__c)service);

                    if (validateForm(requiredServiceFields, svu, service)) {
                        /*
                        List<Apexpages.Message> msgsList = ApexPages.getMessages();
                        String msgs = '';
                        for (Apexpages.Message m: msgsList) {
                            msgs += m.getDetail() + '\n';
                        }
                        if (msgs != '') {
                            data.put('server-errors', msgs);
                        }*/
                    } else {
                        List<Service_Progress__c> updateServiceProgressList = new List<Service_Progress__c>();
                        serviceProgress = [SELECT id,Step_Number__c,Step_Completed_Timestamp__c,Completed__c,Customer_Email_Address__c FROM Service_Progress__c WHERE Service__c =:sID];
                        System.debug('The list of service progress records identified are :'+serviceProgress);
                        for (Service_Progress__c serviceProg : serviceProgress) {
                            if (serviceProg.Step_Number__c != null) {
                                if (service.Current_Step__c == serviceProg.Step_Number__c) {
                                    serviceProg.Completed__c = true;
                                    serviceProg.Step_Completed_Timestamp__c = System.now();
                                    serviceProg.Customer_Email_Address__c = Service.Field3__c;
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

                        if (service.Current_Channel__c == 'Call Center') {
                            DocuSignForService dfs = new DocuSignForService();
                            String msg = dfs.main(sID);
                            System.debug('The Message from DocuSignForService Class is '+msg);
                        }

                        String[] toAddresses = new String[] {Service.Field3__c};
                        if (Service.One_N_Done__c == true) {
                            EmailTemplate et=[Select id from EmailTemplate where name=:'Submit Service Request - OneNDone'];
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
                                data.put('debug-server-errors', e.getMessage());
                                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                                FormsLogger.writeAllLogs();
                            }
                        }
                        else {
                            EmailTemplate et=[Select id from EmailTemplate where name=:'Submit Service Request - Multi-Step'];                            
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
                                data.put('debug-server-errors', e.getMessage());
                                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                                FormsLogger.writeAllLogs();
                            }

                        }
                        if (Service__c.SObjectType.getDescribe().isUpdateable()) {
                            update service;
                        }
                        userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);

                        ServiceUtility.getData(data, (Service__c)service, true);

                        //update service;
                        
                        if (Service_Progress__c.SObjectType.getDescribe().isUpdateable()) {
                            update updateServiceProgressList;
                        }

                        if (service.Customer__c != null) {
                            /*PageReference p = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+service.Customer__c);*/
                            PageReference p = new PageReference(Application_Configuration__c.getOrgDefaults().Instance_URL__c+service.Customer__c);
                            p.setRedirect(false);
                            //return p;
                        } else {
                            PageReference p = Page.thankyoufinal;
                            p.setRedirect(false);
                            //return p;
                        }
                    }
                }
                data.put('serviceUt',userToken);
                ServiceUtility.getServerMessages(data);
                system.debug('service request is '+service.Service_Request__c);
                if(service.Service_Request__c == 'ACH Dispute'){
                    Docusigncallout(serviceId);
                }
            } catch(Exception e) {
                data.put('debug-server-errors', e.getMessage());
                data.put('server-errors-stack-trace', e.getStackTraceString());
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }
        } else {
            data.put('server-errors', 'Your session has expired due to inactivity.');
        }            
        return data;
    }


    @future(callout = true)
    Public Static void Docusigncallout(String serviceId){
        system.debug('Future Call out service Id'+serviceId);
        DocusignServicing ds = new DocusignServicing();
        ds.main(serviceId);
        system.debug('Docusign call has been made');
    }


    @RemoteAction
    public static Map<String,sObject> saveNAbort(Map<String,String> tmpData) {
        Map<String,String> serviceDataMap = tmpData.clone();
        Map<String,sObject> data = new Map<String,sObject>();
        String serviceId = serviceDataMap.get('serviceId');
        System.debug('The serviceId is '+serviceId);
        String serviceUt = serviceDataMap.get('serviceUt');
        System.debug('The serviceUt is '+serviceUt);
        String userToken;
        Service__c service;
        if (ServiceCryptoHelper.userTokenIsValid(serviceId, serviceUt)) {
            try {
                if (serviceDataMap != null) {
                    Id sID = serviceDataMap.get('serviceId');
                    removeUnwantedFields(serviceDataMap);
                    system.debug('in the saveNAbort method');
                    List<Service_Progress__c> serviceProgress;
                    ServiceValidationUtility svu;
                    Set<String> fieldsToDisplay;
                    Set<String> requiredServiceFields;
                    fieldsToDisplay = new Set<String>();
                    ServiceUtility su = new ServiceUtility();
                    fieldsToDisplay = su.fieldsToRender(sID);
                    System.debug('The fields to render are '+fieldsToDisplay);
                    System.debug('The size of displyed fields list is  '+fieldsToDisplay.size());
                    requiredServiceFields = su.requiredFields(sID);
                    System.debug('The required fields are '+requiredServiceFields);
                    System.debug('The size of required fields list is  '+requiredServiceFields.size());
                    svu = new ServiceValidationUtility();
                    service = [SELECT Id,Statement_Type__c,Other_Statement_Type__c,Date_of_Debit__c,Transaction_Code__c,Type_Of_Activity__c,Other_Activity_Type__c,ID_Verification__c,Other_ID_Type__c,Verification_Check_List__c,Balance_Inquiry__c,Change_Type__c,Card_Types__c,Product_Type__c,Type_Of_Card_Loss__c,Transaction_Type__c,Member_Number__c,Loss_Reported_To_Police__c,Police_Report_Number__c,Date__c,Merchant__c,Amount__c,Marriage_Date__c,New_Last_Name__c,One_N_Done__c,Status__c,User_Token__c,Name,Loan_Number__c,Amount_of_GAP_MBP__c,Delivery_Street_Address_1__c,Delivery_Street_Address_2__c,Delivery_City__c,Delivery_State__c,Delivery_Zip_Code__c,Purpose_of_Request__c,DMV_Street_Address_1__c,DMV_Street_Address_2__c,DMV_City__c,DMV_State__c,DMV_Zip_Code__c,Title_Release_Instructions__c,Date_Of_Birth__c,Social_Security_Number__c,Customer__c,Current_Step__c,Service_Request__c,Product__c,Sub_Product__c,Total_Steps__c,Total_SLA__c,Service_Close_Date__c,Field1__c,Field2__c,Field3__c,Field4__c,Field5__c,Field6__c,Field7__c,Field8__c,Service_Disclosure1__c,Service_Disclosure2__c,Service_Disclosure3__c,Service_Disclosure4__c,Service_Disclosure5__c,Service_Disclosure6__c,Service_Disclosure7__c,Service_Disclosure8__c,Service_Disclosure9__c,Service_Disclosure10__c, (SELECT Id,Title,Body,IsDeleted,IsPrivate,OwnerId,CreatedDate,Owner.Name,Owner.CommunityNickname FROM Notes) FROM Service__c WHERE Id = :sID];
                    ServiceUtility.setData(serviceDataMap, (Service__c)service);

                    //if (!validateForm(requiredServiceFields, svu, service)) {
                        update service;
                        //ServiceCryptoHelper.refreshToken(service);
                        //Expiring the user token when SaveNAbort buttons are clicked
                        ServiceCryptoHelper.expireToken(service);
                        userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);
                        data.put('serviceRecord', (sObject)service);

                        fieldsToDisplay = su.fieldsToRender(sID);
                        requiredServiceFields = su.requiredFields(sID);
                        data.put('fieldsToDisplay', ServiceUtility.getMessageObject(String.join(new List<String>(fieldsToDisplay), ';')));
                        data.put('requiredServiceFields', ServiceUtility.getMessageObject(String.join(new List<String>(requiredServiceFields), ';')));
                    //}
                }

                ServiceUtility.getServerMessages(data);    
            } catch (Exception e) {
                data.put('debug-server-errors', ServiceUtility.getMessageObject(e.getMessage()));
                data.put('server-errors-stack-trace', ServiceUtility.getMessageObject(e.getStackTraceString()));
                FormsLogger.inputSource('FormsController Class', serviceId);
                FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
                FormsLogger.writeAllLogs(); 
            }
        } else {
            System.debug('The user token is not valid on Next Click');
            data.put('server-errors', ServiceUtility.getMessageObject('Your session has expired due to inactivity.'));
        }

        return data;
    }    

    @HttpPost
    global static String uploadDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        String parentId = req.params.get('parentId');
        String attachmentName = req.params.get('attachmentName');
        String attachmentId = req.params.get('attachmentId');
        Blob attachmentBody = req.requestBody; 

        if (parentId != null) {
            Service_Document_Request__c docReq = [SELECT Id, Name FROM Service_Document_Request__c WHERE Id=:parentId];
            if (docReq != null) {
                if (attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    //TODO: Should we not just overwrite the body?
                    String newBody = '';
                    if (att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += attachmentBody;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    if (attachmentId == null) {
                        att.Name = attachmentName;
                        att.parentId = docReq.Id;
                    }
                    if (Attachment.SObjectType.getDescribe().isUpdateable() && Attachment.SObjectType.getDescribe().isCreateable()) {
                        upsert att;
                    }
                    return att.Id;
                } else {
                    return 'Attachment Body was null';
                }
            } else {
                return 'Document Request record could not be found';
            }
        } else {
            return 'Document Request Id was null';
        }
    }

    @RemoteAction
    public static String uploadAttachment(String docReqId, String attachmentBody, String attachmentName, String attachmentId) {
        System.debug('Inside uploadAttachment method');
        System.debug('The doc ID is '+docReqId);
        System.debug('The attachmentBody is '+attachmentBody);
        System.debug('The attachmentName is '+attachmentName);
        System.debug('The attachmentId is '+attachmentId);
        if (docReqId != null) {
            Service_Document_Request__c docReq = [SELECT Id, Name FROM Service_Document_Request__c WHERE Id=:docReqId];
            if (docReq != null) {
                if (attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    String newBody = '';
                    if (att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    newBody += attachmentBody;
                    att.Body = EncodingUtil.base64Decode(newBody);
                    if (attachmentId == null) {
                        att.Name = attachmentName;
                        att.parentId = docReq.Id;
                    }
                    if (Attachment.SObjectType.getDescribe().isUpdateable() && Attachment.SObjectType.getDescribe().isCreateable()) {
                        upsert att;
                    }
                    return att.Id;
                } else {
                    return 'Attachment Body was null';
                }
            } else {
                return 'Document Request record could not be found';
            }
        } else {
            return 'Document Request Id was null';
        }
    }

    private static Attachment getAttachment(String attId) {
        List<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attId];
        if (attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }

    @RemoteAction
    public static String deleteAttachments(String attachmentId) {
        Attachment att = getAttachment(attachmentId);
        if (att != null) {
            if (Attachment.SObjectType.getDescribe().isDeletable()) {
                delete att;
            }
            return 'Deleted';
        } else {
            return 'Attachment could not be found';
        }
    }

    @RemoteAction
    public static Map<String,String> deleteAttachment(Map<String,String> serviceDataMap) {
        Map<String,String> data = serviceDataMap.clone();
        if (serviceDataMap != null) {
            Id sID = serviceDataMap.get('serviceId');
            String dParam = serviceDataMap.get('dParam');
            system.debug('The service request document id is '+dParam);

            List<Attachment> delAttachList = new List<Attachment>();
            List<Attachment> a = [SELECT id,Name FROM Attachment WHERE id =:dParam];
            if (a.size() > 0) {
                delAttachList.add(a[0]);
            }
            delete delAttachList;
        }
        return data;
    }

/*
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

*/
    @RemoteAction
    public static Map<String,String> addNote(Map<String,String> serviceDataMap) {
        Map<String,String> data = serviceDataMap.clone();
        if (serviceDataMap != null) {
            try {
                Id sID = serviceDataMap.get('serviceId');
                String noteTitle = serviceDataMap.get('noteTitle');
                String noteDetails = serviceDataMap.get('noteDetails');
                Note n = new Note();
                n.ParentId = sID;
                n.Title = noteTitle;
                n.Body = noteDetails;
                if(n.Title != null && n.Title != ''){
                   insert n; 
                }
                //n = [SELECT Id, Title, Body, CreatedDate, OwnerId, Owner.Name FROM Note WHERE Id=:n.id];
                //ServiceUtility.getData(data, (Note)n, false);
            } catch(Exception e) {
                data.put('debug-server-errors', e.getMessage());
                data.put('server-errors-stack-trace', e.getStackTraceString()); 
            }

        }

        ServiceUtility.getServerMessages(data);    
        return data;
    }

    @RemoteAction
    global static Map<String,String> callDocusignForSigning(Map<String,String> serviceDataMap) {
        Map<String,String> data = new Map<String, String>();
        String serviceId = serviceDataMap.get('serviceId');
        String currentChannel = serviceDataMap.get('channel');
        FormsLogger.inputSource('FormsController Class', serviceId);
        try {
            if (currentChannel != 'Call Center') {
                DocuSignForService_Signing dss = new DocuSignForService_Signing();
                String url = dss.main(serviceId);
                System.debug('The docusign url is '+ url);
                data.put('docusign-url', url);
            } else {
                DocuSignForService ds = new DocuSignForService();
                String mssg = ds.main(serviceId);
                data.put('debug-server-errors', mssg);                       
            }            
        } catch (Exception e) {
            data.put('debug-server-errors', e.getMessage());
            data.put('server-errors-stack-trace', e.getStackTraceString());
            FormsLogger.addMessage('Exception: '+ e + '; ' + e.getStackTraceString(), system.now());
            FormsLogger.writeAllLogs(); 
        } 

        return data;
    }

    @remoteAction
    global static String extendExpiration(Map<String,String> serviceDataMap) {
        //lookup the user's token and reset it
        String token;
        Map<String,String> data = new Map<String, String>();
        String serviceId = serviceDataMap.get('serviceId');
        Service__c serv =[Select Id,Field1__c,One_N_Done__c,User_Token__c from Service__c where Id=:serviceId];
        if (serv.User_Token__c != null) {
            token = serv.User_Token__c;
        }
        ServiceCryptoHelper.refreshToken(serv);
        return 'refreshToken' + token;
    }
}