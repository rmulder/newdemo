global with sharing class DSP {
    global static final String APPLICATION_OBJECT = 'Application__c';
    global static final String APPLICATION2_OBJECT = 'Application2__c';
    global static final String EMPLOYMENT_OBJECT = 'Employment_Information__c';
    global static final String IDENTITY_OBJECT = 'Identity_Information__c';
    global static final String ABOUT_ACCOUNT_OBJECT = 'About_Account__c';
    global static final String APPLICATION_ACTIVITY_OBJECT = 'Application_Activity__c';
    global static final String CROSS_SELL_LOGIC_OBJECT = 'Cross_Sell_Logic__c';
    global static final String CUSTOMER_OBJECT = 'Customer__c';
    global static final String DOCUSIGN_CONFIG_OBJECT = 'Docusign_Config__c';
    global static final String APPLICATION_CONFIGURATION_OBJECT = 'Application_Configuration__c';

    global static final String INDEX_PAGE = 'IndexPage';
    global static final String GET_STARTED_PAGE = 'GetStartedPage';
    global static final String CROSS_SELL_PAGE = 'CrossSellPage';
    global static final String PERSONAL_INFO_PAGE = 'PersonalInfoPage';
    global static final String EMPLOYMENT_PAGE = 'EmploymentPage';
    global static final String IDENTITY_PAGE = 'IdentityPage';
    global static final String ACCOUNT_DETAILS_PAGE = 'AccountDetailsPage';
    global static final String PURCHASE_DETAILS_PAGE = 'PurchaseDetailsPage';
    global static final String PROPERTY_DETAILS_PAGE = 'PropertyDetailsPage';
    global static final String DECLARATIONS_PAGE = 'DeclarationsPage';
    global static final String REVIEW_SUBMIT_PAGE = 'ReviewSubmitPage';
    global static final String VERIFY_IDENTITY_PAGE = 'VerifyIdentityPage';
    global static final String CONFIRMATION_PAGE = 'ConfirmationPage';
    global static final String THANK_YOU_PAGE = 'ThankYouPage';
    global static final String STATUS_PORTAL_PAGE = 'StatusPortalPage';
    global static final String SESSION_EXPIRED_PAGE = 'SessionExpiredPage';
    global static final String SAVE_FOR_LATER_PAGE = 'SaveForLaterPage';
    global static final String SCHEDULE_PAGE = 'SchedulePage';
    global static final String APP_RETRIEVAL_PAGE = 'AppRetrievalPage';
    global static final String APP_STATUS_PAGE = 'AppStatusPage';
    global static final String UPDATE_PAGE = 'UpdatePage'; 

    global static final String IP_LOOKUP_URL = 'http://freegeoip.net/xml/';    

    public String id{get; set;}
    public String ut{get; set;}
    public String frame{get; set;}
    public String referer{get; set;}
    public String product{get; set;}
    public String subproduct{get; set;}
    public String channel{get; set;}
    public String location{get; set;}
    public String support_phone_number{get; set;}
    public String orgName{get; set;}
    public String hostUrl{get; set;}
    public String path{get; set;}
    public String enable_google_analytics{get; set;}
    public String google_tag_id_terafina{get; set;}
    public String google_tag_id_client{get; set;}
    public String appId{get; set;}
    global String appResourceJSON{get; set;}
    global String pageJSONData{get; set;}
    global static String NAMESPACE{get; set;}
    global String currentPage{get; set;}

    global String appFieldsUrl{get; set;}
    global String Theme{get; set;}
    global String ApplicationCode{get; set;}


    public DSP() {
        system.debug('entered the constructor');
        Cookie c_id = null;
        appId = ApexPages.currentPage().getParameters().get('id');
        Logger.inputSource('DSP Class', appId);
        if (appId != null && appId.length() > 0) {
            c_id = ApexPages.currentPage().getCookies().get('id');
            c_id = new Cookie('id',appId,null,-1,true);
            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{c_id});
        }

        appFieldsUrl = '/servlet/servlet.FileDownload?file=';
        List<Document> docList = [SELECT id,name,body FROM Document WHERE name = :Application_Configuration__c.getInstance().app_fields_staticresource__c];
        if (docList.size() > 0) {
            appFieldsUrl = URL.getSalesforceBaseUrl().toExternalForm()+appFieldsUrl+docList[0].id;
        }
        List<StaticResource> resourceList =[SELECT Name, NameSpacePrefix, SystemModStamp FROM StaticResource where name = :Application_Configuration__c.getInstance().Theme__c];
        if (resourceList.size() > 0) {
            String ns = resourceList[0].NameSpacePrefix;
            Theme = '/resource/'+resourceList[0].SystemModStamp.getTime() + '/' + (ns != null && ns != '' ? ns + '__' : '') + Application_Configuration__c.getInstance().Theme__c;
            ApplicationCode ='/resource/'+resourceList[0].SystemModStamp.getTime() + '/' + (ns != null && ns != '' ? ns + '__' : '') + Application_Configuration__c.getInstance().Application_Code__c;
            System.debug('Theme Path is '+ Theme);
            System.debug('ApplicationCode Path is '+ ApplicationCode);
        }

        hostUrl = URL.getSalesforceBaseUrl().getHost();
        system.debug('host url is ' + hostUrl);
        path = URL.getCurrentRequestUrl().toExternalForm().split('/')[3].trim();
        system.debug('path url is ' + path);
        c_id = ApexPages.currentPage().getCookies().get('id');
        Cookie c_ut = ApexPages.currentPage().getCookies().get('ut');
        Cookie c_fr = ApexPages.currentPage().getCookies().get('fr');
        this.referer = '';
        if (c_id != null) {
            this.id = String.valueOf(c_id.getValue());
            if (c_ut != null) {
                this.ut = String.valueOf(c_ut.getValue());
            }
            if (c_fr != null) {
                this.frame = String.valueOf(c_fr.getValue());
            }

            Application__c app = [SELECT Product__c, Sub_Product__c, Current_Channel__c, Support_Phone_Number__c, Application_Page__c FROM Application__c where id=:id];
            this.orgName = UserInfo.getOrganizationName();
            if (app != null) {
                this.product = app.product__c;
                this.subproduct = app.sub_product__c;
                this.channel = app.Current_Channel__c;
                this.support_phone_number = app.support_phone_number__c;
            } else {
                this.product = '';
                this.subproduct = '';
                this.channel = '';
                this.support_phone_number = '';
            }

            Google_Tags__c gt = Google_Tags__c.getOrgDefaults();
            this.enable_google_analytics = String.valueOf(gt.Enable_Google_Analytics__c);
            this.google_tag_id_terafina = String.valueOf(gt.Google_Tag_ID_Terafina__c);
            this.google_tag_id_client = String.valueOf(gt.Google_Tag_ID_Client__c);
            
            //this.appResourceJSON = setAppResource(id);
            this.currentPage = app.Application_Page__c;
            //this.pageJSONData = getPageFields(id, app.Application_Page__c);
            this.pageJSONData = '{}';
            
            //system.debug('resource id is: '+this.resourceFileId);

            //Now, remove the cookies:
            //c_id = new Cookie('id',null,null,0,true);
            //c_ut = new Cookie('ut',null,null,0,true);
            //ApexPages.currentPage().setCookies(new Cookie[]{c_id,c_ut});
            String userId = UserInfo.getUserId();
            User loggedInUser = [SELECT id,Location__c FROM User WHERE Id=:userId];
            this.location = '';
            if (app.Current_Channel__c == 'Online') {
                this.location = findLocation();
            } else {
                if (loggedInUser != null) {
                    this.location = loggedInUser.Location__c;
                }
            }
        } else {
            //this.referer = ApexPages.currentPage().getHeaders().get('Referer');
            this.id = '';
            this.ut = '';
        }
    }

    global String setAppResource(Id id) {
        system.debug('entered setAppResource method and the id received is: '+ id);
        String resFilename = id;
        String jsonString = '';
        try {
            JSONGenerator generator = JSON.createGenerator(true);
            JSONGenerator generator2 = JSON.createGenerator(true);

            generator.writeStartObject();
            RequiredFieldsUtility rfu = new RequiredFieldsUtility();
            Set<String> requiredFields = rfu.fieldsRequiredAre(id);
            Set<String> displayedFields = rfu.fieldsDisplayedAre(id);
            for (String fn : requiredFields) {
                generator.writeStringField(fn.toLowerCase(), 'true');
            }
            generator.writeEndObject();
            jsonString = 'DSP.models.RequiredFields = ' + generator.getAsString() + ';\n';

            generator2.writeStartObject();
            List<Field_Logic_New__c> fieldList = [SELECT Field_Name__c, Label__c FROM Field_Logic_New__c WHERE RecordType.name != 'Page Labels' AND Field_Name__c in :displayedFields];
            system.debug('the size of the set is: '+ fieldList.size());
            Map<String,Field_Logic_New__c> fieldMap = new Map<String,Field_Logic_New__c>();
            for (Field_Logic_New__c fl : fieldList) {
                fieldMap.put(fl.Field_Name__c,fl);
            }
            List<Field_Logic_New__c> fList = fieldMap.values();
            for (Field_Logic_New__c fl : fList) {
                generator2.writeStringField(fl.Field_Name__c.toLowerCase(), (fl.Label__c == null) ? '' : fl.Label__c);
            }

            generator2.writeEndObject();
            jsonString = jsonString + '\ndelete DSP.models.DisplayedFields;\nDSP.models.DisplayedFields = ' + generator2.getAsString() + ';\n';
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            Logger.writeAllLogs();
            system.debug('The error is ' + e.getMessage());
        }

        return jsonString;
    }

    global String setNewResource(String id) {
        system.debug('the id is '+id);
        String resourceName = id;
        String jsonNewString;
        try {
                /*List<Field_Logic_New__c> flList = [Select Field_Name__c, Label__c, Datatype__c, sObject__c, Page_Type__c FROM Field_Logic_New__c WHERE RecordType.name = 'Field Logic' LIMIT 50000];
                system.debug('the list size is '+flList.size());
                Map<String,Field_Logic_New__c> fieldMap = new Map<String,Field_Logic_New__c>();
                for (Field_Logic_New__c fl : flList) {
                    fieldMap.put(fl.Datatype__c,fl);
                    fieldMap.put(fl.Field_Name__c,fl);
                    fieldMap.put(fl.Label__c,fl);
                }
                JSONGenerator gen = JSON.createGenerator(true);
                List<Field_Logic_New__c> fList = fieldMap.values();
                for (Field_Logic_New__c fl : fList) {
                    gen.writeStartObject(); //Start the object data
                    gen.writeStringField('type', fl.Datatype__c);
                    gen.writeStringField('key', fl.Field_Name__c);
                    gen.writeFieldName('templateOptions');
                    gen.writeStartObject();
                    gen.writeStringField('label', fl.Label__c);
                    gen.writeEndObject();
                    gen.writeEndObject(); // End of the object data 
                }
                jsonNewString = jsonNewString + gen.getAsString();*/
                
                /*gen.writeStartObject(); //Start the object data
                gen.writeStringField('type', );
                gen.writeFieldName('templateOptions');
                gen.writeStartObject();
                gen.writeFieldName('fields');
                gen.writeStartArray();
                gen.writeStartObject();
                gen.writeStringField('type', 'input');
                gen.writeStringField('key', 'firstName');
                gen.writeFieldName('templateOptions');
                gen.writeStartObject();
                gen.writeStringField('label', 'First Name');
                gen.writeEndObject();
                gen.writeEndObject();
                gen.writeStartObject();
                gen.writeStringField('type', 'input');
                gen.writeStringField('key', 'lastName');
                gen.writeFieldName('templateOptions');
                gen.writeStartObject();
                gen.writeStringField('label', 'Last Name');
                gen.writeEndObject();
                gen.writeEndObject();
                gen.writeEndArray();
                gen.writeEndObject();
                gen.writeEndObject(); // End of the object data*/
                //system.debug('jsondata is'+jsonNewString);

            } catch(Exception e) {
                system.debug('the error is '+e.getMessage()+' , '+e.getLineNumber());
            }
    return jsonNewString;
    }

    @RemoteAction
    global static String getPageFieldsJSON(Map<String,String> data, String pageName) {
        String json;
        json = getPageFields(data.get('id'), pageName);
        return json;
    }

    global class DataWrapper{
        public String key;
        public Boolean isRequired;
        public String dataType;
        public String fieldLabel;
        public Integer fieldWidth;
        public List<String> picklistValues;

        global DataWrapper(String fieldKey, Boolean isReq, String type, String label, Integer width, List<String> pklstValues) {
            key = fieldKey;
            isRequired = isReq;
            dataType = type;
            fieldLabel = label;
            fieldWidth = width;
            picklistValues = pklstValues;
        }
    }

    global static String getPageFields(String id, String pageName) {

        /*String jsonString = null;
        Application__c app = [SELECT Id, Product__c, Sub_Product__c FROM Application__c WHERE Id = :id];//Additionally, we will also add the "pageName" fields in the query that will give the current page name
        
        List<Field_Logic_New__c> fieldLogicList = [Select Field_Name__c, IsDisplayed__c, IsRequired__c, Label__c, Page_Type__c FROM Field_Logic_New__c WHERE RecordType.name = 'Field Logic' AND Product__c = :app.Product__c AND Sub_Products__c =: app.Sub_Product__c AND Field_Name__c != null AND Label__c != null AND Page_Type__c != null AND Page_Type__c INCLUDES (:pageName) LIMIT 50000];
        System.debug('The size of the list is '+fieldLogicList.size());
        if (fieldLogicList.size() > 0) {  
           JSONGenerator gen = JSON.createGenerator(true);//instantiation of the generator
           gen.writeStartObject(); // Writes the starting marker of a JSON object '{'
           gen.writeFieldName('fields');
           gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
           for (Field_Logic_New__c fl : fieldLogicList) {
               gen.writeStartObject();
                   //gen.writeStringField('key', fl.sObject__c+'.'+fl.Field_Name__c);
                   gen.writeStringField('type', 'input');
                   gen.writeStringField('key', 'Application__c.'+fl.Field_Name__c);
                   //gen.writeStringField('type', fl.Datatype__c);
                   gen.writeFieldName('templateOptions');
                   gen.writeStartObject();
                       gen.writeObjectField('label', fl.Label__c);
                       gen.writeNumberField('width', 6);
                       gen.writeBooleanField('required', fl.IsRequired__c);
                   gen.writeEndObject();
               gen.writeEndObject();
           } 
           gen.writeEndArray(); 
           gen.writeEndObject();
           jsonString = gen.getAsString();
           System.debug('The JSON is '+jsonString);
        }

        return jsonString;

        // Here is the sample JSON String:
        
        {
          "allInfo" : [ {
            "key" : "Application__c.Monthly_Payment_J__c",
            "type" : "CURRENCY(0)",
            "templateOptions" : {
              "label" : "$",
              "pageName" : "PersonalInfoPage",
              "isDisplayed" : true,
              "isRequired" : true
            }
          }, {
            "key" : "Application__c.CL_Product_Comments_Only__c",
            "type" : "TEXTAREA(32768)",
            "templateOptions" : {
              "label" : "Notes",
              "pageName" : "CrossSellPage",
              "isDisplayed" : true,
              "isRequired" : true
            }
          } ]
        }
        */

        System.debug('The application id is '+ id);
        System.debug('The application pageName is '+ pageName);
        List<DataWrapper> dataWrapperList;
        Map<String, List<DataWrapper>> pageFieldsMap = new Map<String, List<DataWrapper>>();

        String jsonString = null;
        Map<String,String> sectionValueMap = new Map<String,String>();

        Set<String> requiredFieldset;
        Set<String> nonRequiredFieldset;

        //Querying the Application Object to Get the Product and all the Cross-sell Offers.
        Application__c app = [SELECT Id, Product__c, Sub_Product__c, Primary_Offer__c, Second_Offer__c, Third_Offer__c, Password__c, Login__c FROM Application__c WHERE Id = :id];
        
        //Querying All the Field Logic records for the given Product(INcluding Cross-Sells) and the Page
        List<Field_Logic_New__c> fieldLogicList = [Select Field_Name__c, IsDisplayed__c, IsRequired__c, Label__c,Section_Type__c, Datatype__c, sObject__c, Page_Type__c FROM Field_Logic_New__c WHERE Section_Type__c != null AND Field_Name__c != null AND Page_Type__c != null AND IsDisplayed__c = true AND Page_Type__c INCLUDES (:pageName) AND (Sub_Products__c = :app.Sub_Product__c OR Sub_Products__c = :app.Primary_Offer__c OR Sub_Products__c = : app.Second_Offer__c OR Sub_Products__c = : app.Third_Offer__c) LIMIT 50000];// ID 1 = a0N17000000z7ahEAA and ID 2 = a0N17000000z92YEAQ
        
        List<Field_Logic_New__c> fieldDetailsList = [SELECT Id, Field_Name__c, sObject__c, Column_Width__c, Datatype__c, Label__c, Supported_Datatype__c, Picklist_Values__c FROM Field_Logic_New__c WHERE RecordType.name = 'Field Details'];
        List<Field_Logic_New__c> sectionOrder = [SELECT Id, Page_Type__c, Section_Type__c, Order__c FROM Field_Logic_New__c WHERE RecordType.name = 'Section Order' AND Page_Type__c INCLUDES (:pageName) ORDER BY Order__c];
        List<Field_Logic_New__c> pageLabels = [SELECT Id, Page_Name__c, Value__c, Label_Name__c FROM Field_Logic_New__c WHERE RecordType.name = 'Page Labels' AND Page_Type__c INCLUDES (:pageName)];
        List<Field_Logic_New__c> sectionTypeLabels = [SELECT Id,Value__c, Section_Type__c FROM Field_Logic_New__c WHERE RecordType.name = 'Section Labels'];
        
        System.debug('The values of the list is '+fieldLogicList);
        System.debug('The size of the list is '+fieldLogicList.size());

        Set<String> sectionNames = new Set<String>();

        // iterating over all the field logic records to get a SET<Section Names>
        for (Field_Logic_New__c flRecord : fieldLogicList) {
            if (flRecord.Section_Type__c != null) {
                List<String> sectionNameList = flRecord.Section_Type__c.split(';');
                for (String secName : sectionNameList) {
                    if (secName.contains(pageName)) {
                        sectionNames.add(secName);
                    }
                }
            }
        }
        System.debug('The set of section names is '+sectionNames);

        //Iterating through all the Set(unique) of section names to get a set of Required and Non-Required fields
        for (String sectionName : sectionNames) {

            requiredFieldset = new Set<String>();
            nonRequiredFieldset = new Set<String>();
            dataWrapperList = new List<DataWrapper>();

            for (Field_Logic_New__c fl : fieldLogicList) {
                if (fl.Section_Type__c.contains(sectionName)) {
                    if (fl.IsRequired__c == true) {
                        requiredFieldset.add(fl.Field_Name__c);
                    } else {
                        nonRequiredFieldset.add(fl.Field_Name__c);
                    }
                }
            }

            for (String reqField : requiredFieldset) {

                // Building the DataWrapper class for all the Required Fields
                for (Field_Logic_New__c fieldDetail : fieldDetailsList) {
                    if (fieldDetail.Field_Name__c == reqField) {
                        List<String> plValues = new List<String>();
                        if (fieldDetail.Supported_Datatype__c == 'select') {
                            plValues =  fieldDetail.Picklist_Values__c.split(';');
                            dataWrapperList.add(new DataWrapper(fieldDetail.sObject__c+'.'+fieldDetail.Field_Name__c, true, fieldDetail.Supported_Datatype__c, fieldDetail.Label__c, Integer.valueOf(fieldDetail.Column_Width__c),plValues));
                        } else {
                            dataWrapperList.add(new DataWrapper(fieldDetail.sObject__c+'.'+fieldDetail.Field_Name__c, true, fieldDetail.Supported_Datatype__c, fieldDetail.Label__c, Integer.valueOf(fieldDetail.Column_Width__c),plValues));
                        }  
                    }
                }

                if (nonRequiredFieldset.contains(reqField)) {
                    nonRequiredFieldset.remove(reqField);
                }
            }

            System.debug('The Required fieldSet is '+requiredFieldset);
            System.debug('The NON-Required fieldSet is '+nonRequiredFieldset);

            // Building the DataWrapper class for all the NON-Required Fields
            for (String nonReqField : nonRequiredFieldset) {
                for (Field_Logic_New__c fieldDetail1 : fieldDetailsList) {
                    if (fieldDetail1.Field_Name__c == nonReqField) {
                        List<String> pl1Values = new List<String>();
                          if (fieldDetail1.Supported_Datatype__c == 'select') {
                              pl1Values =  fieldDetail1.Picklist_Values__c.split(';');
                              dataWrapperList.add(new DataWrapper(fieldDetail1.sObject__c+'.'+fieldDetail1.Field_Name__c, true, fieldDetail1.Supported_Datatype__c, fieldDetail1.Label__c, Integer.valueOf(fieldDetail1.Column_Width__c),pl1Values));
                          } else {
                              dataWrapperList.add(new DataWrapper(fieldDetail1.sObject__c+'.'+fieldDetail1.Field_Name__c, true, fieldDetail1.Supported_Datatype__c, fieldDetail1.Label__c, Integer.valueOf(fieldDetail1.Column_Width__c),pl1Values));
                          }
                    }
                }
            }

            pageFieldsMap.put(sectionName,dataWrapperList);
            System.debug('The pageField Map is '+pageFieldsMap);

        }

        //Getting the value of each section Type in a MAP
        for (Field_Logic_New__c secTypeLabel : sectionTypeLabels) {
            sectionValueMap.put(secTypeLabel.Section_Type__c,secTypeLabel.Value__c);
        }


        JSONGenerator gen = JSON.createGenerator(true);//instantiation of the generator
        gen.writeStartObject(); // Writes the starting marker of a JSON object '{'

            //Contsructing JSON for the pageLabels:
            gen.writeFieldName('labels');
            gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
                gen.writeStartObject();
                    gen.writeFieldName('PageLabels');
                    gen.writeStartObject();
                        for (Field_Logic_New__c pageLabel : pageLabels) {
                            if (pageLabel.Label_Name__c != null && pageLabel.Value__c != null) {
                                gen.writeObjectField( pageLabel.Label_Name__c, pageLabel.Value__c); 
                            }   
                        }
                    gen.writeEndObject();   
                gen.writeEndObject();
            gen.writeEndArray();//Writes the End marker of a JSON array (']').
            //gen.writeString(',');//Writes the specified string value, In this case a ',' after the end array

            if (pageName.contains('GetStartedPage')) {
                //Contsructing JSON for the pageFields:
                gen.writeFieldName('login-fields');
                gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
                        gen.writeStartObject();
                            gen.writeStringField('template', '<hr /><div><strong>Please enter your username and password</strong></div>');
                        gen.writeEndObject();
                        gen.writeStartObject();
                            gen.writeStringField('type', 'multiField');
                            gen.writeFieldName('templateOptions');
                            gen.writeStartObject();
                                gen.writeFieldName('fields');
                                gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
    
                                        gen.writeStartObject();
                                            gen.writeStringField('type','input');
                                            gen.writeStringField('key','Application__c.Login__c');
                                            gen.writeFieldName('templateOptions');
                                            gen.writeStartObject();
                                                gen.writeObjectField('label', 'Username');
                                                gen.writeNumberField('width', 6);
                                                gen.writeBooleanField('required', true);
                                            gen.writeEndObject();
                                        gen.writeEndObject();
                                        gen.writeStartObject();
                                            gen.writeStringField('type','input');
                                            gen.writeStringField('key','Application__c.Password__c');
                                            gen.writeFieldName('templateOptions');
                                            gen.writeStartObject();
                                                gen.writeObjectField('label', 'Password');
                                                gen.writeNumberField('width', 6);
                                                gen.writeBooleanField('required', true);
                                            gen.writeEndObject();
                                        gen.writeEndObject();

                                gen.writeEndArray();//Writes the End marker of a JSON array (']').
                            gen.writeEndObject();
                        gen.writeEndObject();   
                gen.writeEndArray();//Writes the End marker of a JSON array (']').
                //gen.writeString(',');//Writes the specified string value, In this case a ',' after the end array
            }

            //Contsructing JSON for the pageFields:
            gen.writeFieldName('fields');
            gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
                for (String sectionLabel : sectionNames) {
                    if (sectionValueMap.get(sectionLabel) != null) {
                        gen.writeStartObject();
                        gen.writeStringField('template', '<hr /><div><strong>'+sectionValueMap.get(sectionLabel)+'<br/></strong></div>');   
                        gen.writeEndObject();
                    }
                    List<DataWrapper> pageFieldsList = pageFieldsMap.get(sectionLabel);
                    gen.writeStartObject();
                        gen.writeStringField('type', 'multiField');
                        gen.writeFieldName('templateOptions');
                        gen.writeStartObject();
                            gen.writeFieldName('fields');
                            gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
                                for (DataWrapper pageFieldsGroup : pageFieldsList) {
                                    if (pageFieldsGroup.dataType != null && pageFieldsGroup.key != null && pageFieldsGroup.fieldLabel != null && pageFieldsGroup.fieldWidth != null) {
                                        gen.writeStartObject();
                                            gen.writeStringField('type',pageFieldsGroup.dataType);
                                            gen.writeStringField('key',pageFieldsGroup.key);
                                            gen.writeFieldName('templateOptions');
                                            gen.writeStartObject();
                                                gen.writeObjectField('label', pageFieldsGroup.fieldLabel);
                                                //Adding the picklist value for picklist fields
                                                if (pageFieldsGroup.dataType == 'select') {
                                                    gen.writeFieldName('options');
                                                    gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
                                                    for (String pickListValue : pageFieldsGroup.picklistValues) {
                                                        gen.writeStartObject();
                                                            gen.writeStringField('name',pickListValue);
                                                            gen.writeStringField('value',pickListValue);
                                                        gen.writeEndObject();    
                                                    }
                                                    gen.writeEndArray();//Writes the End marker of a JSON array (']').
                                                }
                                                gen.writeNumberField('width', pageFieldsGroup.fieldWidth);
                                                gen.writeBooleanField('required', pageFieldsGroup.isRequired);
                                            gen.writeEndObject();
                                        gen.writeEndObject();
                                    }
                                }
                            gen.writeEndArray();//Writes the End marker of a JSON array (']').
                        gen.writeEndObject();
                    gen.writeEndObject();   
                }
            gen.writeEndArray();//Writes the End marker of a JSON array (']').
        gen.writeEndObject();

        jsonString = gen.getAsString();
        System.debug('The output json string is '+jsonString);
        return jsonString;
    }


    global String findLocation() {
        //Get the users IP address
        String ipAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        Boolean lookupLocation = true;
        String xmlResponse;
        String latitude;
        String longitude;
        String city;
        String state;
        String location = '';
 
        /*First check to see if user has existing cookie with current IP address. Rather than 
        create 3 seperate cookies for IP, lat, and long I put these all in one cookie comma
        seperated: "245.547.54.45,45.4575,-124.4575,<city>,<state>" There is probably no advantage, it may 
        even make this more complicated but it at least demos a different way to use cookies*/
 
        //First check to see if cookie exists
        Map<String,Cookie> cookies = ApexPages.currentPage().getCookies();
        if (cookies.size() > 0) {
            if (cookies.get('ipLocation') != null) { 
                List<String> cookieValues = cookies.get('ipLocation').getValue().split(',');
                //List will contain [IP Address, Latitude, Longitude]
 
                /*Check to see if user has the same IP address as the cookie. If same there
                is no need to look up the location again*/
                if (ipAddress == cookieValues[0]) {
                    latitude = cookieValues[1];
                    longitude = cookieValues[2];
                    location = cookieValues[3] + ', ' + cookieValues[4];
                    lookupLocation = false;
                }
            }
        }
 
        /*If there were no cookies found or the current user's IP address did not match 
        that of the cookie we need to look up location of users IP address */
        if (lookupLocation == true) {
            Application_Configuration__c ac = Application_Configuration__c.getOrgDefaults();
            if (ac.Enable_IP_Lookup__c != true) {
                return location;
            }
            //Build HTTP request
            //Instantiate a new http object
            Http h = new Http();
 
            //Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ac.IP_Lookup_URL__c + ipAddress);
            req.setMethod('GET');
 
            /*We are also setting a timeout, if we are doing this callout on page load we don't want 
            this to prevent page from loading if IP server is down*/
            req.setTimeout(3000);
 
            //Send the request / call webservice
            HttpResponse res;
            Boolean calloutSuccess = true;
            try {
                res = h.send(req);
            } catch (Exception e) {
                //Ghetto error handling but better than nothing
                return e.getMessage();
                //calloutSuccess = false;
            }
 
            if (calloutSuccess == true) {
                if (ac.IP_Lookup_Data_Type__c == 'XML') {
                    //Inspect the response, use the XmlStreamReader so we don't have to parse response
                    xmlResponse = res.getBody();
                    XmlStreamReader reader = res.getXmlStreamReader();
                    Map<String,String> responseValues = new Map<String,String>();
     
                    try {
                        while (reader.hasNext()) {
                            System.debug('Event Type:' + reader.getEventType());
                            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                                String key = reader.getLocalName();
                                reader.next();
                                if (reader.getEventType() == XmlTag.CHARACTERS) {
                                    responseValues.put(key,reader.getText());
                                }
                            }
                            reader.next();
                        }
                    } catch(exception e) {
                        system.debug(e.getMessage());
                    }
     
                    //Set the latitude and longitude   
                    latitude = responseValues.get(ac.IP_Field_Latitude__c);// '47.482877';
                    longitude = responseValues.get(ac.IP_Field_Longitude__c);// '-122.217066';
                    city = responseValues.get(ac.IP_Field_City__c);// 'San Jose';
                    state = responseValues.get(ac.IP_Field_State__c);// 'CA';
                    location = city + ', ' + state;
                }
 
                /*Next we want to create a cookies so we dont have to make unecessary callouts
                in the future*/
 
                List<Cookie> newCookies = new List<Cookie>();
                newCookies.add(new Cookie('ipLocation',ipAddress+','+latitude+','+longitude+','+city+','+state,null,15552000,false));
                ApexPages.currentPage().setCookies(newCookies);
            }
        }

        return location;
    }
    
    @RemoteAction
    global static Map<String,sObject> callDocusign(String appId, String currentChannel) {
        Map<String,sObject> data = new Map<String, sObject>();
        Logger.inputSource('Review Submit Page',appid);
        try {
            Application_Configuration__c ac = Application_Configuration__c.getInstance();
            if (currentChannel != 'Call Center') {
                Type t = Type.forName(ac.Docusign_Class_OB__c);
                SignInterface instance = (SignInterface)t.newInstance();
                String url = instance.main(appId);
                data.put('docusign-url', DspUtility.getMessageObject(url));
            } else{
                Type t = Type.forName(ac.Docusign_Class_CC__c);
                SignInterface instance = (SignInterface)t.newInstance();
                String mssg = instance.main(appId);
                data.put('debug-server-errors', DspUtility.getMessageObject(mssg));
                Logger.addMessage('Result of docusign email sent to the customer for reviewing the disclosures: '+ mssg, system.now().format());                        
            }            
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            Logger.writeAllLogs();
            data.put('debug-server-errors', DspUtility.getMessageObject(e.getMessage()));
            data.put('server-errors-stack-trace', DspUtility.getMessageObject(e.getStackTraceString()));
        } 

        return data;
    }

    @RemoteAction
    global static Map<String,sObject> userLogin(Map<String,String> data) {
        //Map<String,String> appData = data.clone();
        Map<String,sObject> appData = new Map<String,sObject>();
        Id id = data.get('id');
        Logger.inputSource('Get Started Page - User Login',id);                        
        if (id != null) {
            try {
                ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'DSP'];
                if (ac.NameSpacePrefix != null) {
                    NAMESPACE = ac.NameSpacePrefix + '__';
                } else {
                    NAMESPACE = '';
                }
                String login = data.get('Contact.login__c');
                String password = data.get('Contact.password__c');
                //String enc_password = CryptoHelper.encrypt(password);
                appData.put('password', DspUtility.getMessageObject(password));

                List<Customer__c> c = [SELECT Cell_Phone_Number__c,City__c,Company__c,Country__c,Date_Of_Birth__c,Email_Address__c,First_Name__c,Id,Last_Name__c,Middle_Name__c,Password__c,Person_Identifier__c,Phone_Number__c,SSN__c,State__c,Street_Address_1__c,Street_Address_2__c,Username__c,Zip_Code__c FROM Customer__c WHERE Username__c = :login];
                if (c.size() > 0) {
                    //String dec_password = CryptoHelper.decrypt(c.Password__c);
                    //appData.put('decrypted-password', dec_password);
                    if (c[0].Password__c == password) {
                        Application__c app = null;
                        Employment_Information__c emp = null;
                        Identity_Information__c iden = null;
                        app = [SELECT id, application_page__c, application_status__c, first_name__c, last_name__c, middle_name__c, primary_phone_number__c, email_address__c,Customer__c FROM Application__c where id=:id];
                        iden = [SELECT id, Date_of_Birth__c, SSN_Prime__c, Social_Security_Number__c FROM Identity_Information__c where Application__c =:id];
                        emp = [SELECT id, Employer__c FROM Employment_Information__c where Application__c =:id];
                        app.Application_Page__c = CROSS_SELL_PAGE;
                        app.First_Name__c = c[0].First_Name__c;
                        app.Middle_Name__c = c[0].Middle_Name__c;
                        app.Last_Name__c = c[0].Last_Name__c;
                        app.Primary_Phone_Number__c = c[0].Phone_Number__c;
                        app.Secondary_Phone_Number__c = c[0].Cell_Phone_Number__c;
                        app.Email_Address__c = c[0].Email_Address__c;
                        app.Street_Address_1__c = c[0].Street_Address_1__c;
                        app.Street_Address_2__c = c[0].Street_Address_2__c;
                        app.City__c = c[0].City__c;
                        app.State__c = c[0].State__c;
                        app.Zip_Code__c = c[0].Zip_Code__c;
                        app.Person_Number__c = c[0].Person_Identifier__c;
                        app.Customer__c = c[0].id;         
                        if (Application__c.SObjectType.getDescribe().isUpdateable()) {update app;}
                        iden.SSN_Prime__c = c[0].SSN__c;
                        iden.Date_of_Birth__c = c[0].Date_Of_Birth__c;
                        if (Identity_Information__c.SObjectType.getDescribe().isUpdateable()) {update iden;}
                        emp.Employer__c = c[0].Company__c;
                        if (Employment_Information__c.SObjectType.getDescribe().isUpdateable()) {update emp;}
                        //appData = DSPUtilityExtension.getData(appData, app, false);
                        appData.put('appRecord',(sObject)app);
                        //appData.put('server-errors', 'Requested User found!');
                        Logger.addMessage('Requested user found',system.now().format());                        
        
                    } else {
                        appData.put('server-errors', DspUtility.getMessageObject('Requested User not found'));
                        Logger.addMessage('Requested user not found',system.now().format());
                    }
                } else {
                    appData.put('server-errors', DspUtility.getMessageObject('Invalid User Name or Password'));
                    Logger.addMessage('Requested user not found',system.now().format());
                }
            } catch(Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                Logger.writeAllLogs();
                appData.put('debug-server-errors', DspUtility.getMessageObject(e.getMessage()));
                appData.put('server-errors-stack-trace', DspUtility.getMessageObject(e.getStackTraceString()));
            } 
            Logger.writeAllLogs();
            return appData;
        } else {
            return null; //user token is expired/invalid or app id is invalid
        }
    }

    @RemoteAction
    global static boolean saveCardValue(Map<String,String> data) {
        Id id = data.get('id');
        String ut = data.get('ut');
        if (CryptoHelper.userTokenIsValid(id, ut)) {
            try {
                String cv = data.get('cardSelected');
                system.debug('card selected is ' + cv);
                Application__c a = [select id, Card_Design__c from Application__c where id=:id];
                Field_Logic_New__c fln1 = [select id, Label_Name__c, Value__c from Field_Logic_New__c where  Label_Name__c = 'Card_Design_Card_1' LIMIT 1];
                Field_Logic_New__c fln2 = [select id, Label_Name__c, Value__c from Field_Logic_New__c where  Label_Name__c = 'Card_Design_Card_2' LIMIT 1];
                if (cv == 'firstCard') {
                    a.Card_Design__c=fln1.Value__c;//'Standard Platinum Rewards';
                } else {
                    a.Card_Design__c=fln2.Value__c;//'HP Garage';
                }
                if (Application__c.SObjectType.getDescribe().isUpdateable()) {update a;}
                return true;
            } catch (exception e) {
                return false;
            }
        } else {
            return false; //user token is expired/invalid or app id is invalid
        }
    }

    @RemoteAction
    global static List<String> bringVehicleMakes(String vehicleYearSelected) {
        List<String> distinctMakes = new List<String>();
        try {
            if (vehicleYearSelected != null) {
                List<CollateralInfo__c> collateralList=[select id,Make__c from CollateralInfo__c where year__c=:vehicleYearSelected ORDER BY Make__c ASC];
                if (collateralList.size() > 0) {
                    Set<String> collateralSet = new Set<String>(); // set to contain distict makes
                    for (Integer i = 0; i< collateralList.size(); i++) {
                        collateralSet.add(collateralList[i].Make__c); 
                    }
                    for (String s:collateralSet) { distinctMakes.add(s); }
                    distinctMakes.sort();
                }
            }
            return distinctMakes; 
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error :' + e.getMessage()));      
        }
        return null;
    }

    @RemoteAction
    global static List<String> bringVehicleModels(String vehicleYear, String vehicleMakeSelected) {
        List<String> distinctModels = new List<String>();
        try {
            if (vehicleMakeSelected!=null && vehicleYear!=null) {
                List<CollateralInfo__c> collateralList=[select id,Make__c,Model__c from CollateralInfo__c where year__c=:vehicleYear AND Make__c=:vehicleMakeSelected ORDER BY Model__c];
                if (collateralList.size()>0) {
                    Set<String> collateralSet = new Set<String>(); // set to contain distict models
                    for (Integer i = 0; i< collateralList.size(); i++) {
                        collateralSet.add(collateralList[i].Model__c); 
                    }
                    for (String s:collateralSet) { distinctModels.add(s); }
                    distinctModels.sort();
                }
            }
            return distinctModels;
        } catch(Exception e) {
            system.debug('The error is '+e.getMessage());
        }
         
        return null;
    }
    
    @RemoteAction
    global static List<String> bringVehicleSubModels(String vehicleYear, String vehicleMakeSelected, String vehicleModelSelected) {
        List<String> distinctSubModels = new List<String>();
        try {
            if (vehicleModelSelected!=null && vehicleYear!=null && vehicleMakeSelected!=null) {
                List<CollateralInfo__c> collateralList=[select id,Make__c,Model__c,SubModel__c from CollateralInfo__c where year__c=:vehicleYear AND Make__c=:vehicleMakeSelected AND Model__c=:vehicleModelSelected ORDER BY SubModel__c];
                if (collateralList.size()>0) {
                    Set<String> collateralSet = new Set<String>(); // set to contain distict models
                    for (Integer i = 0; i< collateralList.size(); i++) {
                        collateralSet.add(collateralList[i].SubModel__c); 
                    }
                    for (String s:collateralSet) { distinctSubModels.add(s); }
                    distinctSubModels.sort();
                }
            }
            return distinctSubModels;
        } catch(Exception e) {
            system.debug('The error is '+e.getMessage());
        }

        return null;
    }

    // Generic method used to verify dollar deposit amount
    @RemoteAction
    global static Map<String,sObject> validateDollarAmount(Map<String,String> tdata) {
        Map<String,sObject> appData = new Map<String,sObject>();
        Map<String,String> data = tdata.clone();
        Id id = data.get('id');
        Logger.inputSource('Account Details Page - validateDollarAmount RemoteAction',id);
        if (CryptoHelper.userTokenIsValid(id, data.get('ut'))) {
            try {
                String field = data.get('field');
                String requestedAmount = data.get('requested_amount').replaceAll(',', '');
                Application__c app = null;
                List<TermAutoLoans__c> termList = null, errorTermsList = null;
                Deposit_Amount_Validation__c dv=null;
                String errMsg = null;
                if (requestedAmount != null) {
                    Decimal dec = Decimal.valueOf(requestedAmount.trim());
                    system.debug('Decimal value is '+dec);
                    if (field == 'dollar_amount_external_chk__c') {
                        app = [SELECT Type_of_Checking__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_of_Checking__c.split(' - ',2).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_external_sav__c') {
                        app = [SELECT Type_of_Savings__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_of_Savings__c.split(' - ',2).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_external_cert__c') {
                        app = [SELECT Type_of_Certificates__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_of_Certificates__c.split(' - ',3).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_external_bus_chk__c') {
                        app = [SELECT Type_Of_Business_Checking__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_Of_Business_Checking__c.split(' - ',2).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_external_bus_sav__c') {
                        app = [SELECT Type_Of_Business_Savings__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_Of_Business_Savings__c.split(' - ',2).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_external_bus_cds__c') {
                        app = [SELECT Type_Of_Business_CDs__c from Application__c where id=:id];
                        dv = Deposit_Amount_Validation__c.getValues(app.Type_Of_Business_CDs__c.split(' - ',2).get(1));
                        system.debug('Custom setting for Checking is '+dv);
                    } else if (field == 'dollar_amount_busichk_check__c' || field =='dollar_amount_chk_check__c' || field == 'dollar_amount_busisav_check__c' || field =='dollar_amount_sav_check__c' || field == 'dollar_amount_busicds_check__c' || field =='dollar_amount_cert_check__c') {
                        dv = Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                        system.debug('Custom setting for Check is '+dv);
                    } else if (field == 'dollar_amount_busichk_cash__c' || field == 'dollar_amount_chk_cash__c' || field == 'dollar_amount_busisav_cash__c' || field == 'dollar_amount_sav_cash__c' || field == 'dollar_amount_busicds_cash__c' || field == 'dollar_amount_cert_cash__c') {
                        dv = Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                        system.debug('Custom setting for Check is '+dv);
                    }

                    if (dv != null) {
                        if (dv.Minimum_Amount__c!=null && dv.Maximum_Amount__c!=null) {
                            if (dec < dv.Minimum_Amount__c || dec > dv.Maximum_Amount__c) {
                               //data.put('error_' + field, 'Please enter an amount between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                               appData.put('error_' + field, DspUtility.getMessageObject('Please enter an amount between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c));
                            }
                        }
                    } else {
                        Logger.addMessage('Dollar amount validation values are not available', system.now().format());
                        /*data.put('error_' + field, 'dollar validation values are not available!');
                        data.put('debug-server-errors', 'field:' + field);*/
                        appData.put('error_' + field, DspUtility.getMessageObject('dollar validation values are not available!'));
                        appData.put('debug-server-errors', DspUtility.getMessageObject('field:' + field));
                    }
                }
            } catch(Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                Logger.writeAllLogs();
                //data.put('debug-server-errors', e.getMessage());
                appData.put('debug-server-errors', DspUtility.getMessageObject(e.getMessage()));
            }
        } else {
            return null; // token is invalid or expired
        }
        //return data
        return appData;
    }

    // Generic method used to display terms based on the amount requested
    @RemoteAction
    global static Map<String,sObject> getTerms(Map<String,String> tdata) {
        Map<String,sObject> appData = new Map<String,sObject>();
        Map<String,String> data = tdata.clone();
        Id id = data.get('id');
        Logger.inputSource('Account Details Page - getTerms RemoteAction',id);
        if (CryptoHelper.userTokenIsValid(id, data.get('ut'))) {
            try {
                String field = data.get('field');
                String requestedAmount = data.get('requested_amount').replaceAll(',', '');
                Application__c app = null;
                List<TermAutoLoans__c> termList = null, errorTermsList = null;
                String errMsg = null;
                if (requestedAmount != null) {
                    Decimal dec=Decimal.valueOf(requestedAmount.trim());
                    if (field == 'requested_loan_amount_vehicleloans__c') {
                        app = [SELECT Type_of_Vehicle_Loans__c from Application__c where id=:id];
                        errorTermsList = [select id,Term__c,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where SubProduct__c=:app.Type_of_Vehicle_Loans__c];
                        if (errorTermsList.size() > 0) {
                            //system.debug('Terms record is '+errorTermsList.get(0));
                            if (dec < errorTermsList.get(0).Minimum_Loan_Amount__c || dec > errorTermsList.get(0).Maximum_Loan_Amount__c) {
                                //system.debug('Entered vehicle loan amount is less than minimum value or greater than naximum value');
                                errMsg = 'Please enter Vehicle Loan Amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                            }
                        }        
                        termList=[select id,Term__c,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where  SubProduct__c=:app.Type_of_Vehicle_Loans__c  AND Range_1__c<=:dec AND Range_2__c>=:dec];
                    } else if (field == 'requested_loan_amount_personalloans__c' || field == 'requested_credit_limit_personalloans__c') {
                        app = [SELECT Type_of_Personal_Loans__c from Application__c where id=:id];
                        errorTermsList=[select id,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where SubProduct__c=:app.Type_of_Personal_Loans__c];
                        if (errorTermsList.size()>0) {
                            if (dec < errorTermsList.get(0).Minimum_Loan_Amount__c || dec > errorTermsList.get(0).Maximum_Loan_Amount__c) {
                                if (field == 'requested_loan_amount_personalloans__c') {
                                    system.debug('Entered personal loan amount is less than minimum value or greater than naximum value');
                                    errMsg = 'Please enter loan amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                                } else {
                                   system.debug('Entered invalid amount for personal line of credit');
                                   errMsg = 'Please enter amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                                }
                            }
                        }
                        if (field == 'requested_loan_amount_personalloans__c') {
                            termList=[select id,Term__c,SubProduct__c,Name from TermAutoLoans__c where  SubProduct__c=:app.Type_of_Personal_Loans__c AND Range_1__c<=:dec AND Range_2__c>=:dec];
                        }
                    } else if (field == 'requested_loan_amount_businessloans__c') {
                        app = [SELECT Type_Of_Business_Loans__c from Application__c where id=:id];
                        errorTermsList=[select id,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where SubProduct__c=:app.Type_Of_Business_Loans__c];
                        if (errorTermsList.size()>0) {
                            if (dec < errorTermsList.get(0).Minimum_Loan_Amount__c || dec > errorTermsList.get(0).Maximum_Loan_Amount__c) {
                                if (field == 'requested_loan_amount_businessloans__c') {
                                    system.debug('Entered personal loan amount is less than minimum value or greater than naximum value');
                                    errMsg = 'Please enter loan amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                                } else {
                                   system.debug('Entered invalid amount for personal line of credit');
                                   errMsg = 'Please enter amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                                }
                            }
                        }
                        if (field == 'requested_loan_amount_businessloans__c') {
                            termList=[select id,Term__c,SubProduct__c,Name from TermAutoLoans__c where  SubProduct__c=:app.Type_Of_Business_Loans__c AND Range_1__c<=:dec AND Range_2__c>=:dec];
                        }
                    } else if (field == 'requested_credit_limit_ccards__c') {
                        app = [SELECT Type_of_Credit_Cards__c from Application__c where id=:id];
                        errorTermsList = [select id,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where  SubProduct__c=:app.Type_of_Credit_Cards__c];
                        if (errorTermsList.size()>0) {
                            if (dec < errorTermsList.get(0).Minimum_Loan_Amount__c || dec > errorTermsList.get(0).Maximum_Loan_Amount__c) {
                                errMsg = 'Please enter amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                            }
                        }
                    } else if (field == 'requested_credit_limit_bus_ccards__c') {
                        app = [SELECT Type_Of_Business_Credit_Cards__c from Application__c where id=:id];
                        errorTermsList = [select id,SubProduct__c,Minimum_Loan_Amount__c,Maximum_Loan_Amount__c from TermAutoLoans__c where  SubProduct__c=:app.Type_Of_Business_Credit_Cards__c];
                        if (errorTermsList.size()>0) {
                            if (dec < errorTermsList.get(0).Minimum_Loan_Amount__c || dec > errorTermsList.get(0).Maximum_Loan_Amount__c) {
                                errMsg = 'Please enter amount between $'+errorTermsList.get(0).Minimum_Loan_Amount__c+' and $'+errorTermsList.get(0).Maximum_Loan_Amount__c;
                            }
                        }
                    }

                    if (termList != null && termList.size() > 0) {
                        //data.put('termList', termList.get(0).Term__c);
                        appData.put('termList', DspUtility.getMessageObject(termList.get(0).Term__c));
                    }
                    if (errMsg != null) {
                        Logger.addMessage('Term values for the given amount are not available', system.now().format());
                        //data.put('error_' + field, errMsg);
                        appData.put('error_' + field, DspUtility.getMessageObject(errMsg));
                    }
                }  
            } catch(Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                //data.put('debug-server-errors', e.getMessage());
                appData.put('debug-server-errors', DspUtility.getMessageObject(e.getMessage()));
            }
        } else {
            return null; // token is invalid or expired
        }
        Logger.writeAllLogs();                
        //return data;
        return appData;
    }

    @RemoteAction
    global static boolean expireSession(Map<String,String> data) {
        Id id = data.get('id');
        Logger.inputSource('Session expired page',id);
        Logger.addMessage('Session has expired', system.now().format());
        Logger.writeAllLogs();
        System.debug('expireSession - id = ' + id);
        Application__c app = [SELECT id, User_Token_Expires__c FROM Application__c where id=:id];
        CryptoHelper.expireToken(app);
        if (Application__c.SObjectType.getDescribe().isUpdateable()) {
            update app;
        }
        return true;
    }

    @RemoteAction
    global static List<String> productList(ID appId) {
        Logger.inputSource('productList RemotAction',appId);
        try {
            List<String> allProducts = new List<String>();
            List<String> products = new List<String>();
            Schema.DescribeFieldResult fieldResult = Cross_Sell_Logic__c.Products__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for (Schema.PicklistEntry f : ple) {
                allProducts.add(f.getLabel());
                system.debug('Products are '+f.getLabel());
            }
            
            Application__c app = [Select id,Product__c,Sub_Product__c from Application__c WHERE id = :appId];
            if (app.Product__c.contains('Business')) {
                for (String sbp : allProducts) {
                    if (sbp.contains('Business')) {
                        products.add(sbp);
                    }
                }
                return products;
            } else {
                for (String p : allProducts) {
                    if (!p.contains('Business')) {
                        products.add(p);
                    }
                }
                return products;
            }
        } catch (exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            Logger.writeAllLogs();
            return null;
        }     
    }

    @RemoteAction
    global static List<String> subProductList(ID appId) {
        Logger.inputSource('subProductList RemotAction',appId);
        try {    
            List<String> distinctProducts = new List<String>();
            List<String> products = new List<String>();
            List<String> allProducts = new List<String>();
            List<String> productList = new List<String>();
            List<Cross_Sell_Logic__c> subproducts = null;
            Schema.DescribeFieldResult fieldResult = Cross_Sell_Logic__c.Products__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for (Schema.PicklistEntry f : ple) {
                allProducts.add(f.getLabel());
                system.debug('Products are '+f.getLabel());
            }

            Application__c app = [Select id,Product__c,Sub_Product__c from Application__c WHERE id = :appId];
            if (app.Product__c.contains('Business')) {
                for (String sbp : allProducts) {
                    if (sbp.contains('Business')) {
                        products.add(sbp);
                    }
                }
            } else {
                for (String p : allProducts) {
                    if (!p.contains('Business')) {
                        products.add(p);
                    }
                }
            }

            for (String prod : products) {
              //prod.getLabel()
                //options.add(new SelectOption(f.getLabel(), f.getValue()));
                subproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:prod];
                for (Cross_Sell_Logic__c a :subproducts) {
                    productList.add(a.Products__c + '_' + a.Sub_Products__c);
                    system.debug('Sub Products are '+a.Sub_Products__c);
                }
            }

            Set<String> productSet  = new Set<String>(); // set to contain distict products
            for (Integer i = 0; i< productList.size(); i++) {
                productSet.add(productList[i]); 
            }
            for (String s:productSet) { distinctProducts.add(s); }
            //distinctProducts.sort();
            
            return distinctProducts;
        } catch (exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            Logger.writeAllLogs();
            return null;    
        }
    }

    @RemoteAction
    global static List<State_Details__c> getCountiesByState(String state) {
        List<State_Details__c> counties = new List<State_Details__c>();
        //List<State_Details__c> allCounties = State_Details__c.getall().values();
        try {
            counties = [SELECT Name, State_Code__c, County_Name__c FROM State_Details__c WHERE State_Code__c =:state];
            counties.sort();
/*
            for (State_Details__c county : allCounties) {
                if (county.State_Code__c == state) {
                    counties.add(county);
                }
            }
            */
        } catch (Exception e) {
            system.debug('The error is '+e.getMessage());
        }

        return counties;
    }

    @RemoteAction
    global static Map<String,sObject> handleRequest(Map<String,String> tdata, String pageName) {
        system.debug(LoggingLevel.Info,'***data:' + tdata + pageName);
        Map<String,String> data = tdata.clone();
        Id id = data.get('id');
        Logger.inputSource(pageName,id);
        String ut = data.get('ut');
        data.remove('id');
        data.remove('ut');
        if (CryptoHelper.userTokenIsValid(id, ut) || (pageName == INDEX_PAGE || pageName == APP_RETRIEVAL_PAGE || pageName == APP_STATUS_PAGE)) {
            ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'DSP'];
            if (ac.NameSpacePrefix != null) {
                NAMESPACE = ac.NameSpacePrefix + '__';
            } else {
                NAMESPACE = '';
            }
            system.debug('Namespace is '+NAMESPACE);
            Map<String,sObject> appData = new Map<String, sObject>();
            try {
                Application__c app = null, tmp = null;
                Application2__c app2 = null;
                Employment_Information__c emp = null;
                Identity_Information__c iden = null;
                About_Account__c acc = null;
                Application_Activity__c appact = new Application_Activity__c();
                Cross_Sell_Logic__c cross = null;
                List<Cross_Sell_Logic__c> crossList = null;
                Docusign_Config__c doc = null;
                Application_Configuration__c appconfig = null;
               
                Customer__c customer = null;
                Map<String,sObject> appObjects = new Map<String,sObject>();
                Utility u = new Utility(); 
                Set<String> fieldsToDisplay = u.fieldsToRender(id); // gets selected fields in to 'fieldsToDisplay' Set.
                system.debug('size of the fieldsToRender method is:' + fieldsToDisplay.size());
                Boolean debug = (data.get('debug') == 'true');
                Boolean post = (data.get('post') == 'true');
                Boolean previous = (data.get('previous') == 'true');
                Boolean schedule = (data.get('schedule') == 'true');
                data.remove('debug');
                data.remove('post');
                data.remove('previous');
                data.remove('schedule');
                //system.debug('Selected Fields from Util-->' + fieldsToDisplay);
                appconfig = Application_Configuration__c.getOrgDefaults();
                if (pageName == 'GetAllApplicationFields') {
                    return DSPUtilityExtension.getAllFields(data, APPLICATION_OBJECT);
                } else if (pageName == 'GetAllApplication2Fields') {
                    return DSPUtilityExtension.getAllFields(data, APPLICATION2_OBJECT);
                } else if (pageName == 'GetAllCrossSellFields') {
                    return DSPUtilityExtension.getAllFields(data, CROSS_SELL_LOGIC_OBJECT);
                } else {
                    tmp = [SELECT id,application_page__c,save_for_later__c,Appointment_Location__c,Appointment_Datetime__c,Assisted_Application__c,Current_Channel__c,IP_Address__c FROM Application__c where id=:id];
                    if (pageName == INDEX_PAGE) {
                        Logger.addMessage('On the DSP page', system.now().format());
                        app = [SELECT id,application_page__c,Current_Channel__c,Assisted_Application__c,support_phone_number__c,product__c,sub_product__c,application_status__c,primary_offer__c,second_offer__c,third_offer__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                    } else if (pageName == APP_RETRIEVAL_PAGE) {
                        if (post) {
                            app = [SELECT id,Current_Branch_Name__c,Current_Channel__c,Assisted_Application__c,Current_Person__c,Current_Timestamp__c,Current_User_Email_Address__c,application_status__c,application_page__c,last_name__c,email_address__c,User_Token__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                            iden = [SELECT date_of_birth__c,SSN_Last_Four_PA__c from Identity_Information__c where Application__c =:id];
                            appData = DSPUtilityExtension.retrieveApp(data, app, iden);
                            /*Cookie ut_c = ApexPages.currentPage().getCookies().get('ut');
                            ut_c = new Cookie('ut',appData.get('ut'),null,-1,true);
                            // Set the new cookie for the page
                            ApexPages.currentPage().setCookies(new Cookie[]{ut_c});*/
                            Logger.addMessage('Posting data to App retrieval page', system.now().format());
                        } else {
                            app = [SELECT id,Current_Channel__c,Assisted_Application__c,application_status__c,application_page__c,Appointment_Location__c,Appointment_Datetime__c FROM Application__c where id=:id];
                            if (app.application_status__c != 'Submitted') {
                                app.Ownerid = system.userInfo.getUserId();
                                update app;
                            }

                            //appData = DSPUtilityExtension.getData(appData, app, false);  // *Removing the old logic of returning a Map<String,String>*
                            appData.put('appRecord',(sObject)app);
                            if (app.application_status__c == 'Submitted') {
                                PageReference p = new PageReference(SiteUrl__c.getOrgDefaults().Url__c+'appStatus');
                                p.getParameters().put('id', id);
                                //appData.put('redirect-url', p.getUrl()); // *Removing the old logic of returning a Map<String,String>*
                                appData.put('redirect-url', DspUtility.getMessageObject(p.getUrl()));
                                return appData;
                            }
                            appData = DSPUtilityExtension.getFieldOptions(appData, id);
                            Logger.addMessage('Getting data from App retrieval page', system.now().format());
                        }
                        return appData;
                    } else if (pageName == APP_STATUS_PAGE) {
                        if (post) {
                            app = [SELECT id,Current_Person__c,Current_Timestamp__c,application_status__c,application_page__c,last_name__c,User_Token__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                            iden = [SELECT date_of_birth__c,SSN_Last_Four_PA__c from Identity_Information__c where Application__c =:id];
                            appData = DSPUtilityExtension.appStatus(data, app, iden);
                            Logger.addMessage('Posting data to App status page', system.now().format());
                        } else {
                            app = [SELECT id,Current_Channel__c,Assisted_Application__c,application_status__c FROM Application__c where id=:id];
                            //appData = DSPUtilityExtension.getData(appData, app, false); // *Removing the old logic of returning a Map<String,String>*
                            appData.put('appRecord',(sObject)app);
                            appData = DSPUtilityExtension.getFieldOptions(appData, id);
                            Logger.addMessage('Getting data from App status page', system.now().format());
                        }
                        return appData;
                    } else if (pageName == GET_STARTED_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Disclosure1__c,Disclosure2__c,Disclosure3__c,Disclosure4__c,Disclosure5__c,Disclosure6__c,Disclosure7__c,Disclosure8__c,Disclosure9__c,Disclosure10__c,Disclosure11__c,Disclosure12__c,Disclosure13__c,Disclosure14__c,Disclosure15__c,Disclosure16__c,Disclosure17__c,Disclosure18__c,Disclosure19__c,Disclosure20__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,first_name__c,last_name__c,primary_phone_number__c,email_address__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        if (post) {
                            crossList = [SELECT primary_offer__c, secondary_offer__c, third_offer__c, primary_offer_text__c, secondary_offer_text__c, third_offer_text__c, primary_offer_textarea__c, primary_offer_textarea2__c, primary_offer_textarea3__c, primary_offer_textarea4__c, primary_offer_textarea5__c, secondary_offer_textarea__c, secondary_offer_textarea2__c, secondary_offer_textarea3__c, secondary_offer_textarea4__c, secondary_offer_textarea5__c, third_offer_textarea__c, third_offer_textarea2__c, third_offer_textarea3__c, third_offer_textarea4__c, third_offer_textarea5__c FROM Cross_Sell_Logic__c WHERE Products__c=:app.product__c AND Sub_Products__c=:app.sub_product__c LIMIT 1];
                            if (crossList.size() > 0) {
                                cross = crossList.get(0);
                            }
                        }
                    } else if (pageName == CROSS_SELL_PAGE) {
                        if (post) {
                            app = [SELECT id,Cross_Sell_1_Product__c,Cross_Sell_2_Product__c,Cross_Sell_3_Product__c,Created_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,person_number__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,product__c,sub_product__c,type_of_checking__c,type_of_certificates__c,type_of_credit_cards__c,type_of_investments__c,type_of_mortgage_loan__c,type_of_mortgage_short_application__c,type_of_savings__c,type_of_vehicle_loans__c,current_channel__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c from Application__c where id=:id];
                        } else {
                            app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Created_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,person_number__c,support_phone_number__c,product__c,sub_product__c,application_status__c,primary_offer__c,second_offer__c,third_offer__c,current_channel__c,Appointment_Location__c,Appointment_Datetime__c FROM Application__c where id=:id];
                        }
                        crossList = [SELECT primary_offer__c, secondary_offer__c, third_offer__c, primary_offer_text__c, secondary_offer_text__c, third_offer_text__c, primary_offer_textarea__c, primary_offer_textarea2__c, primary_offer_textarea3__c, primary_offer_textarea4__c, primary_offer_textarea5__c, secondary_offer_textarea__c, secondary_offer_textarea2__c, secondary_offer_textarea3__c, secondary_offer_textarea4__c, secondary_offer_textarea5__c, third_offer_textarea__c, third_offer_textarea2__c, third_offer_textarea3__c, third_offer_textarea4__c, third_offer_textarea5__c FROM Cross_Sell_Logic__c WHERE Products__c=:app.product__c AND Sub_Products__c=:app.sub_product__c LIMIT 1];
                        if (crossList.size() > 0) {
                            cross = crossList.get(0);
                        }
                        acc = [Select Id,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Certificate_Account_Number__c,Certificate_Product_Description__c,Name,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c,What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c where Application__c =:id];
                    } else if (pageName == PERSONAL_INFO_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,promo_code__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,save_for_later__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,first_name__c,last_name__c,middle_name__c,suffix__c,street_address_1__c,street_address_2__c,city__c,state__c,zip_code__c,housing_status__c,monthly_payment__c,years__c,months__c,street_address_1_prev__c,street_address_2_prev__c,city_prev__c,state_prev__c,zip_code_prev__c,marital_status__c,primary_phone_number__c,secondary_phone_number__c,email_address__c,first_joint_applicant__c,first_name_j__c,middle_name_j__c,last_name_j__c,suffix_j__c,street_address_j__c,street_address_2_j__c,city_j__c,state_j__c,zip_code_j__c,housing_status_j__c,monthly_payment_j__c,years_j__c,months_j__c,street_address_1_jp__c,street_address_2_jp__c,city_jp__c,state_jp__c,zip_code_jp__c,marital_status_j__c,relationship_to_primary_applicant_j1__c,primary_phone_number_j__c,secondary_phone_number_j__c,email_address_j__c,first_name_j2__c,middle_name_j2__c,last_name_j2__c,suffix_j2__c,street_address_1_j2__c,street_address_2_j2__c,city_j2__c,state_j2__c,zip_code_j2__c,housing_status_j2__c,monthly_payment_j2__c,years_j2__c,months_j2__c,street_address_1_jp2__c,street_address_2_jp2__c,city_jp2__c,state_jp2__c,zip_code_jp2__c,marital_status_j2__c,relationship_to_primary_applicant_j2__c,primary_phone_number_j2__c,secondary_phone_number_j2__c,email_address_j2__c,first_name_j3__c,middle_name_j3__c,last_name_j3__c,suffix_j3__c,street_address_1_j3__c,street_address_2_j3__c,city_j3__c,state_j3__c,zip_code_j3__c,housing_status_j3__c,monthly_payment_j3__c,years_j3__c,months_j3__c,street_address_1_jp3__c,street_address_2_jp3__c,city_jp3__c,state_jp3__c,zip_code_jp3__c,marital_status_j3__c,relationship_to_primary_applicant_j3__c,primary_phone_number_j3__c,secondary_phone_number_jp3__c,email_address_j3__c,second_joint_applicant__c,third_joint_applicant__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                    } else if (pageName == EMPLOYMENT_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,first_name__c,last_name__c,first_name_j__c,last_name_j__c,first_name_j2__c,last_name_j2__c,first_name_j3__c,last_name_j3__c,first_joint_applicant__c,second_joint_applicant__c,third_joint_applicant__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        emp = [Select Id,Name,Employment_Status__c, Application__c, Company_List__c, Other_Income2_J2__c, Other_Income2_J3__c, Other_Income2__c, Other_Income3_J2__c, Other_Income3_J3__c, Other_Income3__c, Other_Income4_J2__c, Other_Income4_J3__c, Other_Income4__c, Other_Income5_J2__c, Other_Income5_J3__c, Other_Income5__c, Other_Income_2__c, Other_Income_3__c, Other_Income_4__c, Other_Income_5__c, Other_Income_J2__c, Other_Income_J3__c, Other_Income_Picklist1_J1__c, Other_Income_Picklist1_J2__c, Other_Income_Picklist1_J3__c, Other_Income_Picklist2_J1__c, Other_Income_Picklist2_J2__c, Other_Income_Picklist2_J3__c, Other_Income_Picklist2__c, Other_Income_Picklist3_J1__c, Other_Income_Picklist3_J2__c, Other_Income_Picklist3_J3__c, Other_Income_Picklist3__c, Other_Income_Picklist4_J1__c, Other_Income_Picklist4_J2__c, Other_Income_Picklist4_J3__c, Other_Income_Picklist4__c, Other_Income_Picklist5_J1__c, Other_Income_Picklist5_J2__c, Other_Income_Picklist5_J3__c, Other_Income_Picklist5__c, Other_Income_Picklist__c, Other_Income__c, Employer_J1__c, Employer_J2__c, Employer_J3__c, Employer_JP1__c, Employer_JP2__c, Employer_JP3__c, Employer_P__c, Employer__c, Employment_Status_J1__c, Employment_Status_J2__c, Employment_Status_J3__c, Other_Income2_J1__c, Other_Income3_J1__c, Other_Income4_J1__c, Other_Income5_J1__c, Other_Income_J1__c, Prior_Occupation_J1__c, Prior_Occupation_J2__c, Prior_Occupation_J3__c, Prior_Occupation__c, Occupation_J1__c, Occupation_J2__c, Occupation_J3__c, Occupation_JP1__c, Occupation_JP2__c, Occupation_JP3__c, Occupation_P__c, Occupation__c, Years_Emp__c, Years_EmpJ1__c, Years_EmpJ2__c, Years_EmpJ3__c, Months_Emp__c, Months_EmpJ1__c, Months_EmpJ2__c, Months_EmpJ3__c, How_do_you_like_to_become_member__c, How_do_you_like_to_become_member_J2__c, How_do_you_like_to_become_member_J3__c, Annual_Income__c, Annual_Income_J1__c, Annual_Income_J3__c, Annual_Income_J2__c, How_do_you_like_to_become_member_J1__c FROM Employment_Information__c where Application__c =:id];
                    } else if (pageName == IDENTITY_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,first_name__c,last_name__c,first_name_j__c,last_name_j__c,first_name_j2__c,last_name_j2__c,first_name_j3__c,last_name_j3__c,first_joint_applicant__c,second_joint_applicant__c,third_joint_applicant__c,Flow_Control__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        iden = [Select Id,Name,State_Issued__c, State_Issued_J1__c, State_Issued_J2__c, State_Issued_J3__c, Country_of_Citizenship_J1__c, Country_of_Citizenship_J2__c, Country_of_Citizenship_J3__c, Country_of_Citizenship__c, Date_of_Birth_J1__c, Date_of_Birth_J2__c, Date_of_Birth_J3__c, Date_of_Birth__c, Citizenship_J1__c, Citizenship_J2__c, Citizenship_J3__c, Citizenship__c, SSN_J1__c, SSN_J2__c, SSN_J3__c, SSN_Prime__c, Expiry_Date_J1__c, Expiry_Date_J2__c, Expiry_Date_J3__c, Expiry_Date__c, ID_NUmber_J3__c, ID_Number_J1__c, ID_Number_J2__c, ID_Number__c, ID_Type_J1__c, ID_Type_J2__c, ID_Type_J3__c, ID_Type__c, Identity_Number_J1__c, Identity_Number_J2__c, Identity_Number_J3__c, Identity_Number_Primary__c, Issue_Date_J1__c, Issue_Date_J2__c, Issue_Date_J3__c, Issue_Date__c, Application__c, Social_Security_Number_J1__c, Social_Security_Number_J2__c, Social_Security_Number_J3__c, Social_Security_Number__c FROM Identity_Information__c where Application__c =:id ];
                    } else if (pageName == ACCOUNT_DETAILS_PAGE) {
                        app = [Select Id,type_of_home_equity__c,Customer__c,Assisted_Application__c,current_channel__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,Name, ATM_Card__c, Application_Page__c, Application_Status__c,  Bill_Pay__c,  support_phone_number__c, Card_Design__c, Check_Order__c, City_J2__c, City_J3__c, City_JP2__c, City_JP3__c, City_JP__c, City_J__c, City_Prev__c, City__c, Contact_Policy__c, County__c, DIIS_ID__c, Date__c, Debt_Safe_Protection__c, Describe_Improvements__c, Do_you_like_to_become_a_Member_P__c,  E_Statements__c, Electronic_Transfer_Authorization__c, Email_Address_J2__c, Email_Address_J3__c, Email_Address_J__c, Email_Address__c, First_Joint_Applicant__c, First_Name_J2__c, First_Name_J3__c, First_Name_J__c, First_Name__c, FullName_J2__c, FullName_J3__c, FullName_J__c, Full_Name_PA__c,  Gap_Insurance__c,  Housing_Status_J2__c, Housing_Status_J3__c, Housing_Status_J__c, Housing_Status__c, IP_Address__c, ISD_Disclosure__c, Last_Name_J2__c, Last_Name_J3__c, Last_Name_J__c, Last_Name__c,  LockOut__c, Main_Seg_Code_J1__c, Main_Seg_Code_J2__c, Main_Seg_Code_J3__c, Main_Seg_Code_PA__c, Main_Seg_Code__c, Marital_Status_J2__c, Marital_Status_J3__c, Marital_Status_J__c, Marital_Status__c, Mechanical_Break_down_Protection__c,  Middle_Name_J2__c, Middle_Name_J3__c, Middle_Name_J__c, Middle_Name__c, Monthly_Payment_J2__c, Monthly_Payment_J3__c, Monthly_Payment_J__c, Monthly_Payment__c, Months_J2__c, Months_J3__c, Months_J__c, Months__c, Number_of_Products__c, OOWQ_A1__c, OOWQ_A1options__c, OOWQ_A2__c, OOWQ_A2options__c, OOWQ_A3__c, OOWQ_A3options__c, OOWQ_A4__c, OOWQ_A4options__c, OOWQ_Q1__c, OOWQ_Q2__c, OOWQ_Q3__c, OOWQ_Q4__c, Online_Banking_Enrollment__c, Overdraft_Protection__c, Ownership__c, Person_Number__c, Primary_Offer__c, Primary_Phone_Number_J2__c, Primary_Phone_Number_J3__c, Primary_Phone_Number_J__c, Primary_Phone_Number__c, Product__c, Relationship_to_Primary_Applicant_J1__c, Relationship_to_Primary_Applicant_J2__c, Relationship_to_Primary_Applicant_J3__c, Relationship_to_Primary_Applicant_JP__c, Save_For_Later__c, Second_Joint_Applicant__c, Second_Offer__c, Secondary_Phone_Number_J2__c, Secondary_Phone_Number_JP3__c, Secondary_Phone_Number_J__c, Secondary_Phone_Number__c, State_J2__c, State_J3__c, State_JP2__c, State_JP3__c, State_JP__c, State_J__c, State_Prev__c, State__c, Street_Address_1_J2__c, Street_Address_1_J3__c, Street_Address_1_JP2__c, Street_Address_1_JP3__c, Street_Address_1_JP__c, Street_Address_1_Prev__c, Street_Address_1__c, Street_Address_2_J2__c, Street_Address_2_J3__c, Street_Address_2_JP2__c, Street_Address_2_JP3__c, Street_Address_2_JP__c, Street_Address_2_J__c, Street_Address_2_Prev__c, Street_Address_2__c, Street_Address_J__c, Sub_Product__c, Suffix_J2__c, Suffix_J3__c, Suffix_J__c, Suffix__c, Third_Joint_Applicant__c, Third_Offer__c,  Type_of_Certificates__c, Type_of_Checking__c, Type_of_Credit_Cards__c, Type_of_Investments__c, Type_of_Mortgage_Loan__c, Type_of_Mortgage_Short_Application__c, Type_of_Personal_Loans__c, Type_of_Savings__c, Type_of_Vehicle_Loans__c, US_Patriot_Act__c, Week_day_Timings__c, Week_end_Timings__c, Years_J2__c, Years_J3__c, Years_J__c, Years__c, Zip_Code_J2__c, Zip_Code_J3__c, Zip_Code_JP2__c, Zip_Code_JP3__c, Zip_Code_JP__c, Zip_Code_J__c, Zip_Code_Prev__c, Zip_Code__c, eDeposit__c, Rate__c, User_Token_Expires__c, User_Token__c,Verify_Identity__c,Flow_Control__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        acc = [Select Id,CHK_Funding_Amount_From_Internal_Account__c,SAV_Funding_Amount_From_Internal_Account__c, CERT_Funding_Amt_From_Internal_Account__c,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,CC_Account_Holder_Name__c ,CC_Account_Number__c, CC_Account_Type__c, CC_Payment_Method__c, CC_Routing_Number__c, PL_Account_Holder_Name__c ,PL_Account_Number__c, PL_Account_Type__c, PL_Payment_Method__c, PL_Routing_Number__c, VL_Account_Holder_Name__c, VL_Account_Number__c , VL_Account_Type__c, VL_Payment_Method__c, VL_Routing_Number__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,hmda_info_pa__c, hmda_ethinicity_pa__c, hmda_sex_pa__c, hmda_race_pa__c,hmda_info_j1__c, hmda_ethinicity_j1__c, hmda_sex_j1__c, hmda_race_j1__c,hmda_info_j2__c, hmda_ethinicity_j2__c, hmda_sex_j2__c, hmda_race_j2__c,hmda_info_j3__c, hmda_ethinicity_j3__c, hmda_sex_j3__c, hmda_race_j3__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Name,Certificate_Account_Number__c,Certificate_Product_Description__c,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c, What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c where Application__c =:id];
                        if (data.get('About_Account__c.hmda_info_pa__c') == null) {data.put('About_Account__c.hmda_info_pa__c', 'false');}
                        if (data.get('About_Account__c.hmda_info_j1__c') == null) {data.put('About_Account__c.hmda_info_j1__c', 'false');}
                        if (data.get('About_Account__c.hmda_info_j2__c') == null) {data.put('About_Account__c.hmda_info_j2__c', 'false');}
                        if (data.get('About_Account__c.hmda_info_j3__c') == null) {data.put('About_Account__c.hmda_info_j3__c', 'false');}
                        if (app.Person_Number__c != null) {
                            customer = [SELECT id FROM Customer__c WHERE id = :app.Customer__c];
                        }
                    } else if (pageName == PURCHASE_DETAILS_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,first_name__c,last_name__c,middle_name__c,suffix__c,first_joint_applicant__c ,second_joint_applicant__c,third_joint_applicant__c,Flow_Control__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        acc = [Select Id,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Certificate_Account_Number__c,Certificate_Product_Description__c,Name,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c, What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c where Application__c =:id];
                    } else if (pageName == PROPERTY_DETAILS_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,first_name__c,last_name__c,middle_name__c,suffix__c,first_joint_applicant__c ,second_joint_applicant__c,third_joint_applicant__c,street_address_1__c,street_address_2__c,city__c,state__c,county__c,zip_code__c,Flow_Control__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        acc = [Select Id,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Name,Certificate_Account_Number__c,Certificate_Product_Description__c,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c, What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c where Application__c =:id];
                    } else if (pageName == DECLARATIONS_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,full_name_pa__c,fullname_j__c,fullname_j2__c,fullname_j3__c,first_joint_applicant__c,second_joint_applicant__c,third_joint_applicant__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        app2 = [SELECT id, application_status__c, qa_primapp__c, qa_explanation_primapp__c, qb_primapp__c, qb_explanation_primapp__c, qc_primapp__c, qc_explanation_primapp__c, qd_primapp__c, qd_explanation_primapp__c, qe_primapp__c, qe_explanation_primapp__c, qf_primapp__c, qf_explanation_primapp__c, qg_primapp__c, qg_explanation_primapp__c, qh_primapp__c, qh_explanation_primapp__c, qi_primapp__c, qi_explanation_primapp__c, qj_primapp__c, qk_primapp__c, qk_2_primapp__c, ql_primapp__c, qm_primapp__c, qm_type_of_property_primapp__c, qm_title_held_primapp__c, hmda_info_pa__c, hmda_ethinicity_pa__c, hmda_sex_pa__c, hmda_race_pa__c, qa_jp1__c, qa_explanation_jp1__c, qb_jp1__c, qb_explanation_jp1__c, qc_jp1__c, qc_explanation_jp1__c, qd_jp1__c, qd_explanation_jp1__c, qe_jp1__c, qe_explanation_jp1__c, qf_jp1__c, qf_explanation_jp1__c, qg_jp1__c, qg_explanation_jp1__c, qh_jp1__c, qh_explanation_jp1__c, qi_jp1__c, qi_explanation_jp1__c, qj_jp1__c, qk_jp1__c, qk_2_jp1__c, ql_jp1__c, qm_jp1__c, qm_type_of_property_jp1__c, qm_title_held_jp1__c, hmda_info_j1__c, hmda_ethinicity_j1__c, hmda_sex_j1__c, hmda_race_j1__c, qa_jp2__c, qa_explanation_jp2__c, qb_jp2__c, qb_explanation_jp2__c, qc_jp2__c, qc_explanation_jp2__c, qd_jp2__c, qd_explanation_jp2__c, qe_jp2__c, qe_explanation_jp2__c, qf_jp2__c, qf_explanation_jp2__c, qg_jp2__c, qg_explanation_jp2__c, qh_jp2__c, qh_explanation_jp2__c, qi_jp2__c, qi_explanation_jp2__c, qj_jp2__c, qk_jp2__c, qk_2_jp2__c, ql_jp2__c, qm_jp2__c, qm_type_of_property_jp2__c, qm_title_held_jp2__c, hmda_info_j2__c, hmda_ethinicity_j2__c, hmda_sex_j2__c, hmda_race_j2__c, qa_jp3__c, qa_explanation_jp3__c, qb_jp3__c, qb_explanation_jp3__c, qc_jp3__c, qc_explanation_jp3__c, qd_jp3__c, qd_explanation_jp3__c, qe_jp3__c, qe_explanation_jp3__c, qf_jp3__c, qf_explanation_jp3__c, qg_jp3__c, qg_explanation_jp3__c, qh_jp3__c, qh_explanation_jp3__c, qi_jp3__c, qi_explanation_jp3__c, qj_jp3__c, qk_jp3__c, qk_2_jp3__c, ql_jp3__c, qm_jp3__c, qm_type_of_property_jp3__c, qm_title_held_jp3__c, hmda_info_j3__c, hmda_ethinicity_j3__c, hmda_sex_j3__c, hmda_race_j3__c FROM Application2__c WHERE Application__c =:id LIMIT 1];
                        if (data.get('Application2__c.hmda_info_pa__c') == null) {data.put('Application2__c.hmda_info_pa__c', 'false');}
                        if (data.get('Application2__c.hmda_info_j1__c') == null) {data.put('Application2__c.hmda_info_j1__c', 'false');}
                        if (data.get('Application2__c.hmda_info_j2__c') == null) {data.put('Application2__c.hmda_info_j2__c', 'false');}
                        if (data.get('Application2__c.hmda_info_j3__c') == null) {data.put('Application2__c.hmda_info_j3__c', 'false');}
                    } else if (pageName == REVIEW_SUBMIT_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Disclosure1__c,Disclosure2__c,Disclosure3__c,Disclosure4__c,Disclosure5__c,Disclosure6__c,Disclosure7__c,Disclosure8__c,Disclosure9__c,Disclosure10__c,Disclosure11__c,Disclosure12__c,Disclosure13__c,Disclosure14__c,Disclosure15__c,Disclosure16__c,Disclosure17__c,Disclosure18__c,Disclosure19__c,Disclosure20__c,Assisted_Application__c,Created_Branch_Name__c,Created_Channel__c,Created_Person__c,Created_Timestamp__c,Created_User_Email_Address__c,Current_Branch_Name__c,Current_Channel__c,Current_Person__c,Current_Timestamp__c,Current_User_Email_Address__c,Submitted_Branch_Name__c,Submitted_Channel__c,Submitted_Person__c,Submitted_Timestamp__c,Submitted_User_Email_Address__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,flow_control__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,full_name_pa__c,first_name__c,middle_name__c,last_name__c,street_address_1__c,street_address_2__c,city__c,state__c,zip_code__c,housing_status__c,monthly_payment__c,years__c,months__c,marital_status__c,street_address_1_prev__c,street_address_2_prev__c,city_prev__c,state_prev__c,zip_code_prev__c,primary_phone_number__c,secondary_phone_number__c,email_address__c,fullname_j__c,first_name_j__c,middle_name_j__c,last_name_j__c,street_address_j__c,street_address_2_j__c,city_j__c,state_j__c,zip_code_j__c,housing_status_j__c,monthly_payment_j__c,years_j__c,months_j__c,marital_status_j__c,relationship_to_primary_applicant_j1__c,street_address_1_jp__c,street_address_2_jp__c,city_jp__c,state_jp__c,zip_code_jp__c,primary_phone_number_j__c,secondary_phone_number_j__c,email_address_j__c,fullname_j2__c,first_name_j2__c,middle_name_j2__c,last_name_j2__c,street_address_1_j2__c,street_address_2_j2__c,city_j2__c,state_j2__c,zip_code_j2__c,housing_status_j2__c,monthly_payment_j2__c,years_j2__c,months_j2__c,marital_status_j2__c,relationship_to_primary_applicant_j2__c,street_address_1_jp2__c,street_address_2_jp2__c,city_jp2__c,state_jp2__c,zip_code_jp2__c,primary_phone_number_j2__c,secondary_phone_number_j2__c,email_address_j2__c,fullname_j3__c,first_name_j3__c,middle_name_j3__c,last_name_j3__c,street_address_1_j3__c,street_address_2_j3__c,city_j3__c,state_j3__c,zip_code_j3__c,housing_status_j3__c,monthly_payment_j3__c,years_j3__c,months_j3__c,marital_status_j3__c,relationship_to_primary_applicant_j3__c,street_address_1_jp3__c,street_address_2_jp3__c,city_jp3__c,state_jp3__c,zip_code_jp3__c,primary_phone_number_j3__c,secondary_phone_number_jp3__c,email_address_j3__c,first_joint_applicant__c,second_joint_applicant__c,third_joint_applicant__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        acc = [Select Id,CHK_Funding_Amount_From_Internal_Account__c,SAV_Funding_Amount_From_Internal_Account__c, CERT_Funding_Amt_From_Internal_Account__c,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Name,Certificate_Account_Number__c,Certificate_Product_Description__c,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c, What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c where Application__c =:id];
                        emp = [Select Id,Name,Employment_Status__c, Application__c, Company_List__c, Other_Income2_J2__c, Other_Income2_J3__c, Other_Income2__c, Other_Income3_J2__c, Other_Income3_J3__c, Other_Income3__c, Other_Income4_J2__c, Other_Income4_J3__c, Other_Income4__c, Other_Income5_J2__c, Other_Income5_J3__c, Other_Income5__c, Other_Income_2__c, Other_Income_3__c, Other_Income_4__c, Other_Income_5__c, Other_Income_J2__c, Other_Income_J3__c, Other_Income_Picklist1_J1__c, Other_Income_Picklist1_J2__c, Other_Income_Picklist1_J3__c, Other_Income_Picklist2_J1__c, Other_Income_Picklist2_J2__c, Other_Income_Picklist2_J3__c, Other_Income_Picklist2__c, Other_Income_Picklist3_J1__c, Other_Income_Picklist3_J2__c, Other_Income_Picklist3_J3__c, Other_Income_Picklist3__c, Other_Income_Picklist4_J1__c, Other_Income_Picklist4_J2__c, Other_Income_Picklist4_J3__c, Other_Income_Picklist4__c, Other_Income_Picklist5_J1__c, Other_Income_Picklist5_J2__c, Other_Income_Picklist5_J3__c, Other_Income_Picklist5__c, Other_Income_Picklist__c, Other_Income__c, Employer_J1__c, Employer_J2__c, Employer_J3__c, Employer_JP1__c, Employer_JP2__c, Employer_JP3__c, Employer_P__c, Employer__c, Employment_Status_J1__c, Employment_Status_J2__c, Employment_Status_J3__c, Other_Income2_J1__c, Other_Income3_J1__c, Other_Income4_J1__c, Other_Income5_J1__c, Other_Income_J1__c, Prior_Occupation_J1__c, Prior_Occupation_J2__c, Prior_Occupation_J3__c, Prior_Occupation__c, Occupation_J1__c, Occupation_J2__c, Occupation_J3__c, Occupation_JP1__c, Occupation_JP2__c, Occupation_JP3__c, Occupation_P__c, Occupation__c, Years_Emp__c, Years_EmpJ1__c, Years_EmpJ2__c, Years_EmpJ3__c, Months_Emp__c, Months_EmpJ1__c, Months_EmpJ2__c, Months_EmpJ3__c, How_do_you_like_to_become_member__c, How_do_you_like_to_become_member_J2__c, How_do_you_like_to_become_member_J3__c, Annual_Income__c, Annual_Income_J1__c, Annual_Income_J3__c, Annual_Income_J2__c, How_do_you_like_to_become_member_J1__c FROM Employment_Information__c where Application__c =:id];
                        iden = [Select Id,Name,State_Issued__c, State_Issued_J1__c, State_Issued_J2__c, State_Issued_J3__c, Country_of_Citizenship_J1__c, Country_of_Citizenship_J2__c, Country_of_Citizenship_J3__c, Country_of_Citizenship__c, Date_of_Birth_J1__c, Date_of_Birth_J2__c, Date_of_Birth_J3__c, Date_of_Birth__c, Citizenship_J1__c, Citizenship_J2__c, Citizenship_J3__c, Citizenship__c, SSN_J1__c, SSN_J2__c, SSN_J3__c, SSN_Prime__c, Expiry_Date_J1__c, Expiry_Date_J2__c, Expiry_Date_J3__c, Expiry_Date__c, ID_NUmber_J3__c, ID_Number_J1__c, ID_Number_J2__c, ID_Number__c, ID_Type_J1__c, ID_Type_J2__c, ID_Type_J3__c, ID_Type__c, Identity_Number_J1__c, Identity_Number_J2__c, Identity_Number_J3__c, Identity_Number_Primary__c, Issue_Date_J1__c, Issue_Date_J2__c, Issue_Date_J3__c, Issue_Date__c, Application__c, Social_Security_Number_J1__c, Social_Security_Number_J2__c, Social_Security_Number_J3__c, Social_Security_Number__c FROM Identity_Information__c where Application__c =:id];
                        doc = [Select Name,AccountID__c,IntegratorKey__c,Password__c,Switch_ON_OFF__c,Username__c from Docusign_Config__c where Name = 'cred'];
                        //appact = [Select Id,Application__c,Branch__c,Channel__c,Name__c,Action__c,Activity_Time__c from Application_Activity__c where Application__c = :id ];
                    } else if (pageName == VERIFY_IDENTITY_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                    } else if (pageName == CONFIRMATION_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,application_page__c,Card_Design__c,Overdraft_Protection__c,Check_Order__c,Online_Banking_Enrollment__c,Bill_Pay__c,eDeposit__c,E_Statements__c,Gap_Insurance__c,Debt_Safe_Protection__c,Mechanical_Break_down_Protection__c,ATM_Card__c,Visa_CashPlus_Check_Card__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,email_address__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                        app2 = [SELECT ErrorNum__c,PricingResult_Rate__c from Application2__c where Application__c = :id];
                    } else if (pageName == THANK_YOU_PAGE) {
                        app = [SELECT id,type_of_mortgage_loan__c,type_of_home_equity__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c where id=:id];
                    } else if (pageName == SAVE_FOR_LATER_PAGE || pageName == SCHEDULE_PAGE) {
                        app = [SELECT id,App_Scheduled__c,Current_Channel__c,Assisted_Application__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,application_page__c, application_status__c,product__c, first_name__c,last_name__c, email_address__c, save_for_later__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c from Application__c where id=:id];
                        iden = [SELECT date_of_birth__c,SSN_Prime__c From Identity_Information__c where Application__c =:id];
                    }
                }

                if (app != null) { CryptoHelper.refreshToken(app); }
                appObjects.put(APPLICATION_OBJECT, app);
                appObjects.put(APPLICATION2_OBJECT, app2);
                appObjects.put(EMPLOYMENT_OBJECT, emp);
                appObjects.put(IDENTITY_OBJECT, iden);
                appObjects.put(CROSS_SELL_LOGIC_OBJECT, cross);
                appObjects.put(ABOUT_ACCOUNT_OBJECT, acc);
                appObjects.put(APPLICATION_ACTIVITY_OBJECT, appact);
        
                appObjects.put(CUSTOMER_OBJECT, customer);
                appObjects.put(DOCUSIGN_CONFIG_OBJECT,doc);
                appObjects.put(APPLICATION_CONFIGURATION_OBJECT,appconfig);
                if (post || previous) {
                    if (post) {
                        appObjects = DSPUtilityExtension.processData(data, pageName, fieldsToDisplay, appObjects);
                    } else { //schedule 
                        appObjects = DSPUtilityExtension.previousPage(data, pageName, fieldsToDisplay, appObjects);
                    }
                    if (app != null && app.Application_Page__c != null) {
                        tmp.Application_Page__c = app.Application_Page__c;
                    }
                    //appData = DSPUtilityExtension.getData(appData, tmp, false);// *Removing the old logic of returning a Map<String,String>*
                    appData.put('appRecord',(sObject)tmp);
                    if (pageName == CROSS_SELL_PAGE) {
                        appData = DSPUtilityExtension.getFieldOptions(appData, id);
                    }
                } else {
                    if (schedule) {
                        appObjects = DSPUtilityExtension.schedulePage(data, pageName, fieldsToDisplay, appObjects);
                    }
                    appData = DSPUtilityExtension.getData(appData, appObjects, (pageName == REVIEW_SUBMIT_PAGE) ? false : true);
                }

                if (debug) {
                    /*appData.put('namespace', NAMESPACE);
                    appData.put('fieldsToDisplay', String.join(new List<String>(fieldsToDisplay), ', ').toLowerCase());*/
                    appData.put('namespace', DspUtility.getMessageObject(NAMESPACE));
                    appData.put('fieldsToDisplay', DspUtility.getMessageObject(String.join(new List<String>(fieldsToDisplay), ';')));
                }
                appData = DSPUtilityExtension.getPageVars(appData, pageName, fieldsToDisplay, appObjects);
                app = (Application__c)appObjects.get(DSP.APPLICATION_OBJECT);

                appData.put('pageFields', DspUtility.getMessageObject(getPageFields(id, app.Application_Page__c)));

                List<Apexpages.Message> msgsList = ApexPages.getMessages();
                String msgs = '';
                for (Apexpages.Message m: msgsList) {
                    msgs += m.getDetail() + '\n';
                }
                if (msgs != '') { appData.put('server-errors', DspUtility.getMessageObject(msgs)); } 
                System.Debug('End of handleRequest');
            } catch(Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                Logger.writeAllLogs();
                system.debug('The error is ' + DspUtility.getMessageObject(e.getMessage()));
                appData.put('debug-server-errors', DspUtility.getMessageObject(e.getMessage()));
                appData.put('server-errors-stack-trace', DspUtility.getMessageObject(e.getStackTraceString()));
            } 
            logger.writeAllLogs();
            System.Debug('Returning appData');
            return appData;
        } else {
            System.Debug('Returning null!');
            return null; //user token is expired/invalid or app id is invalid
        }
    }

}