public with sharing class SelectServiceRequestController {

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
    public static Boolean dispProdList{get; set;}
    public List<ServiceWrapperClass> serviceWrapperClassList{get; set;}

    public Boolean choiceParam{get; set;}
    public String servicetypeParam{get; set;}
    public String selectedOneNDoneReq{get; set;}

    public String xmlString{get; set;}
    public transient Dom.Document xmlData;
    public Dom.XMLNode address;

    public String serviceId{get; set;}
    public Service__c serviceApp{get; set;}
    public Service__c servApp{get; set;}

    public String searchText{get; set;}

    public SelectServiceRequestController() {
        Cookie s_id = null;
        //Fetching the service Id from the URL
        serviceId = ApexPages.currentPage().getParameters().get('id');
        if (serviceId != null && serviceId.length() > 0) {
            s_id = ApexPages.currentPage().getCookies().get('svcId');
            s_id = new Cookie('svcId',serviceId,null,-1,true);
            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{s_id});
        }

        s_id = ApexPages.currentPage().getCookies().get('svcId');
        if (s_id != null) {
            serviceId = String.valueOf(s_id.getValue());
        }
        if (serviceId != null) {
            servApp = [SELECT Id,Current_Channel__c,One_N_Done__c FROM Service__c WHERE Id = :serviceId];
        }

        filteredServiceList = new List<Service_Type__c>();
        filteredServiceSet = new Set<Service_Type__c>();

        if (servApp != null) {
            oneNdoneServiceType = [SELECT id,Name,Available_in_Channel__c,One_Step_Service__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = true AND Available_in_Channel__c includes (:servApp.Current_Channel__c)];
        
            serviceWrapperClassList = new List<ServiceWrapperClass>();
            for (Service_Type__c stype : oneNdoneServiceType) {
                serviceWrapperClassList.add(new ServiceWrapperClass(stype.Name,false,stype.Short_Description__c,stype.Long_Description__c));
            }

            serviceTypesList = [SELECT Id,Name,Keywords__c,Available_in_Channel__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false AND Available_in_Channel__c includes (:servApp.Current_Channel__c)];
        }

        //Fetching the XML code
        this.xmlString = ApexPages.currentPage().getParameters().get('xmldata');
        this.xmlData = new DOM.Document();
        system.debug('xmlData is:' + this.xmlString);
        if (this.xmlString != null) {
            this.xmlData.load(this.xmlString);
        }
    }


    public List<SelectOption> getServiceRequest() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','None'));
        List<Service_Type__c> servicesTypeList = [SELECT Id,Name,Total_SLA__c,Number_of_Steps__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false];
        for (Service_Type__c st : servicesTypeList) {
            options.add(new SelectOption(st.Name, st.Name));
        }

        return options;
    }

    @RemoteAction
    public static List<SelectOption> fetchProduct(String filteredServiceRequestName){

        if (filteredServiceRequestName == null || filteredServiceRequestName == 'None') {

            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','None'));

            return options;
        }else{
            Set<String> productSet = new Set<String>();
            List<SelectOption> options = new List<SelectOption>();
            List<Service_Type__c> serType = [SELECT id,Name FROM Service_Type__c WHERE Name = :filteredServiceRequestName];
            if (serType.size() > 0) {
                List<Service_Product__c> productList = new List<Service_Product__c>();
                productList = [SELECT id,Product__c,Sub_Product__c,Service_Type__c FROM Service_Product__c WHERE Service_Type__c = :serType[0].Id];
                if (productList.size() > 0) {
                    options.add(new SelectOption('None','None'));
                    for (Service_Product__c spp : productList) {
                       productSet.add(spp.Product__c); 
                    }
                    for (String s : productSet) {
                        options.add(new SelectOption(s,s));
                    }
                } else {
                    options.add(new SelectOption('None','None'));
                }
            }
            return options;
        }
    }

    @RemoteAction
    public static List<SelectOption> fetchSubProduct(String productResult, String filteredServiceRequestName){

        System.debug('The Value of PRoduct Result inside getSubProduct is '+ productResult);
        System.debug('The Value of the name inside getSubProduct is '+ filteredServiceRequestName);
        if (productResult==null || productResult=='None' || productResult=='') {

            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','None'));

            return options;
        } else {

            List<SelectOption> options = new List<SelectOption>();
            List<Service_Type__c> serType = [SELECT id,Name FROM Service_Type__c WHERE Name = :filteredServiceRequestName];
            system.debug('The Value of is '+serType[0].Id);
            if (serType.size() > 0) {
                List<Service_Product__c> subproductList = new List<Service_Product__c>();
                subproductList = [SELECT id,Product__c,Sub_Product__c,Service_Type__c FROM Service_Product__c WHERE Service_Type__c = :serType[0].Id AND Product__c = :productResult];
                for (Service_Product__c spsp : subproductList) {
                    options.add(new SelectOption(spsp.Sub_Product__c,spsp.Sub_Product__c));    
                }
            }
            productResult = productResult;
            return options;
        }
    }


    public List<SelectOption> getProduct() {
        if (filteredServiceRequestName == null || filteredServiceRequestName == 'None') {

            list<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','None'));

            return options;

        } else {
            productSet = new Set<String>();
            list<SelectOption> options = new List<SelectOption>();
            List<Service_Type__c> serType = [SELECT id,Name FROM Service_Type__c WHERE Name = :filteredServiceRequestName];
            if (serType.size() > 0) {
                productList = [SELECT id,Product__c,Sub_Product__c,Service_Type__c FROM Service_Product__c WHERE Service_Type__c = :serType[0].Id];
                if (productList.size() > 0) {
                    options.add(new SelectOption('None','None'));
                    for (Service_Product__c spp : productList) {
                       productSet.add(spp.Product__c); 
                    }
                    for (String s : productSet) {
                        options.add(new SelectOption(s,s));
                    }
                } else {
                    options.add(new SelectOption('None','None'));
                }
            }
            return options;
        }
    }

    public List<SelectOption> getSubProduct() {
        System.debug('The Value of PRoduct Result inside getSubProduct is '+ productResult);
        if (productResult==null || productResult=='None' || productResult=='') {

            list<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','None'));

            return options;
        } else {

            List<SelectOption> options = new List<SelectOption>();
            List<Service_Type__c> serType = [SELECT id,Name FROM Service_Type__c WHERE Name = :filteredServiceRequestName];
            if (serType.size() > 0) {
                subproductList = [SELECT id,Product__c,Sub_Product__c,Service_Type__c FROM Service_Product__c WHERE Service_Type__c = :serType[0].Id AND Product__c = :productResult];
                for (Service_Product__c spsp : subproductList) {
                    options.add(new SelectOption(spsp.Sub_Product__c,spsp.Sub_Product__c));    
                }
            }
            return options;
        }
    }

    public Boolean getdispServiceResult() {
        if (filteredServiceList.size() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public void selectRequest() {
        system.debug('The value of choiceParam is'+choiceParam);
        system.debug('The value of chooseRequest is'+chooseRequest);
        selectedOneNDoneReq = String.valueOf(ApexPages.currentPage().getParameters().get('selServRequest'));
        system.debug('The value of str is'+selectedOneNDoneReq);
        //dispProdList = false;
    }

    //Wrapper class for fetching the Service Type Name and Choice(Boolean)
    public class ServiceWrapperClass {
        public String serviceName{get;set;}
        public Boolean serviceChoice{get;set;}
        public String shortDesc{get; set;}
        public String longDesc{get; set;}

        public ServiceWrapperClass(String sn,Boolean sc,String sd,String ld) {
            serviceName=sn;
            serviceChoice=sc;
            shortDesc=sd;
            longDesc=ld;
        }
    } // End of wrapper class


    public PageReference startfilteredServiceRequest() {

        //dispProdList = true;
        filteredServiceRequestName = String.valueOf(ApexPages.currentPage().getParameters().get('fsr'));
        System.debug('The value of Service Request is ## '+ filteredServiceRequestName);

        productResult = null;
        SubProductResult = null;
        if (selectedOneNDoneReq != null) {
            selectedOneNDoneReq = null;
        }
        
        return null;
    }

    public PageReference startServiceReq() {
        String prodName = Apexpages.currentpage().getparameters().get('prodnameParam');
        String subprodName=Apexpages.currentpage().getparameters().get('subprodnameParam');
        system.debug('the prodName is '+prodName);
        system.debug('the subprodName is '+subprodName);
        
        if (filteredServiceRequestName == null && selectedOneNDoneReq == null) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please Select a Service Request'));
            return null;
        } else {
            if (serviceId == null) {
                system.debug('The Value of prodcut '+productResult);
                system.debug('The valus of subproduct '+SubProductResult);
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
                insert serviceForm;

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceForm.id);
                p.setRedirect(true);
                return p;
            } else {
                serviceApp = [SELECT Product__c,Sub_Product__c,Service_Request__c,One_N_Done__c FROM Service__c WHERE id = :serviceId];
                system.debug('The Value of prodcut'+productResult);
                system.debug('The valus of subproduct'+SubProductResult);
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

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceApp.id);
                p.setRedirect(true);
                return p;
            }
        }

    }

    @RemoteAction
    public static PageReference saveNStartService(String serviceId, String filteredServiceRequestName,String selectedOneNDoneReq,String productResult, String SubProductResult) {

        if (filteredServiceRequestName == null && selectedOneNDoneReq == null) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please Select a Service Request'));
            return null;
        } else {
            if (serviceId == null) {
                system.debug('The Value of prodcut '+productResult);
                system.debug('The valus of subproduct '+SubProductResult);
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
                insert serviceForm;

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceForm.id);
                p.setRedirect(true);
                return p;
            } else {
                Service__c serviceApp = [SELECT Product__c,Sub_Product__c,Service_Request__c,One_N_Done__c FROM Service__c WHERE id = :serviceId];
                system.debug('The Value of prodcut'+productResult);
                system.debug('The valus of subproduct'+SubProductResult);
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

                // Redirecting to the ServiceApp Page by Passing the Serice ID in the URL
                PageReference p = Page.ServiceApp;
                p.getParameters().put('id',serviceApp.id);
                p.setRedirect(true);
                return p;
            }
        }

    }

    public void searchRequest() {

        filteredServiceList = new List<Service_Type__c>();
        filteredServiceSet = new Set<Service_Type__c>();

        if (searchText != null && searchText != '') {
            System.debug('The search text is ######### '+ searchText);
            String searchTextLower = searchText.toLowerCase();
            system.debug('The Search text in lower case is ######'+searchTextLower);
            List<Service_Type__c> allserviceTypes = [SELECT Id,Name,Keywords__c,Available_in_Channel__c,Short_Description__c,Long_Description__c FROM Service_Type__c WHERE One_Step_Service__c = false AND Available_in_Channel__c includes (:servApp.Current_Channel__c)];
            for (Service_Type__c allST : allserviceTypes) {
                if (allST.Keywords__c != null) {
                    List<String> kWordList = allST.Keywords__c.split('#');
                    // removing the first element from the list as it is an empty string
                    kWordList.remove(0);
                    System.debug('The Keywords list is + #########'+kWordList);
                    for (String kWord : kWordList) {
                        System.debug('The keyword is ######'+kWord);
                        String kWordLower = kWord.toLowerCase();
                        System.debug('The Keyword in Lower case is ####'+kWordLower);
                        if (searchTextLower.contains(kWordLower)) {
                            filteredServiceSet.add(allST);
                        }
                    }
                }    
            }
            // Adding all the elements from Set to List
            filteredServiceList.addAll(filteredServiceSet);
            if (filteredServiceList.size() == 0) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Sorry! system could not find you a match. If possible, please try to elaborate your search text or reach our 24 hours call center at 1-844-837-2346'));
            }
            System.debug('The filtered service Type List is '+ filteredServiceList);
        } else {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please type in your concerns in the text box below!!'));
        }
        searchText = null;
    }

    public PageReference generateServiceApp() {
        
        PageReference p = null;
        Service__c servicePrefill = new Service__c();

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
            if (xmlString.contains('caseId')) {
                servicePrefill.Case__c = address.getChildElement('caseId', null).getText();    
            }
            if (xmlString.contains('ssn')) {
                servicePrefill.Social_Security_Number__c = address.getChildElement('ssn', null).getText();    
            }
            if (xmlString.contains('dob')) {
                servicePrefill.Date_Of_Birth__c = address.getChildElement('dob', null).getText();    
            }
            //updating the Address Information for a customer 
            if (xmlString.contains('customersStreetAddress1')) {
                servicePrefill.Field5__c = address.getChildElement('customersStreetAddress1', null).getText();    
            }
            if (xmlString.contains('customersStreetAddress2')) {
                servicePrefill.Field6__c = address.getChildElement('customersStreetAddress2', null).getText();    
            }
            if (xmlString.contains('customersCity')) {
                servicePrefill.Field7__c = address.getChildElement('customersCity', null).getText();    
            }
            if (xmlString.contains('customersState')) {
                servicePrefill.Field8__c = address.getChildElement('customersState', null).getText();    
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

            //ServiceCryptoHelper.setAppToken(servicePrefill);

            if (Service__c.SObjectType.getDescribe().isCreateable()) {
                insert servicePrefill;
            }

            p = Page.ServiceApp;
            p.getParameters().put('id',servicePrefill.Id);
        }

        return p;
    }
}