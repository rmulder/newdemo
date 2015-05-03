global with sharing class IndexUtilityExtension {

    public static Map<String,sObject> setData(Map<String,String> tmpData, Map<String,sObject> appObjects) {
        Map<String,sObject> rtnObjects = appObjects.clone();
        Map<String,String> appData = new Map<String,String>();
        Map<String,String> app2Data = new Map<String,String>();
        Map<String,String> empData = new Map<String,String>();
        Map<String,String> idenData = new Map<String,String>();
        Map<String,String> accData = new Map<String,String>();
        Map<String,String> appactData = new Map<String,String>();
        Map<String,String> docData = new Map<String,String>();
        Map<String,String> appconfigData = new Map<String,String>();

        Map<String, Schema.SObjectField>fieldMap = null;
        String fieldLabel = null;
        Schema.DisplayType fielddataType = null;
        List<String> keyParts = null;
        sObject obj = null;

        try {
            for (String fn : tmpData.keySet()) {
                if (fn.indexOf('.') != -1) {
                    keyParts = fn.split('\\.'); 
                    if (fn.indexOf(Index.APPLICATION_OBJECT) != -1) {
                        appData.put(keyParts[1], tmpData.get(fn));
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Key:' + fn + '; Data:' + String.valueOf(tmpData.get(fn))));      
                    } else if (fn.indexOf(Index.APPLICATION2_OBJECT) != -1) {
                        app2Data.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.EMPLOYMENT_OBJECT) != -1) {
                        empData.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.IDENTITY_OBJECT) != -1) {
                        idenData.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.ABOUT_ACCOUNT_OBJECT) != -1) {
                        accData.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.APPLICATION_ACTIVITY_OBJECT) != -1) {
                        appactData.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.DOCUSIGN_CONFIG_OBJECT) != -1) {
                        docData.put(keyParts[1], tmpData.get(fn));
                    } else if (fn.indexOf(Index.APPLICATION_CONFIGURATION_OBJECT) != -1) {
                        appconfigData.put(keyParts[1], tmpData.get(fn));
                    }
                } else {
                    appData.put(fn, tmpData.get(fn));
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Key:' + fn + '; Data:' + String.valueOf(tmpData.get(fn))));      
                }
            }

            for (String key : appObjects.keySet()) {
                obj = appObjects.get(key);
                if (obj != null) {
                    try {
                        if (key == Index.APPLICATION_OBJECT) {
                            if (appData.size() > 0) {
                                rtnObjects.put(Index.APPLICATION_OBJECT, (Application__c)setData(appData, (Application__c)obj));    
                            }
                        } else if (key == Index.APPLICATION2_OBJECT) {
                            if (app2Data.size() > 0) {
                                rtnObjects.put(Index.APPLICATION2_OBJECT, (Application2__c)setData(app2Data, (Application2__c)obj));    
                            }
                        } else if (key == Index.EMPLOYMENT_OBJECT) {
                            if (empData.size() > 0) {
                                rtnObjects.put(Index.EMPLOYMENT_OBJECT, (Employment_Information__c)setData(empData, (Employment_Information__c)obj));    
                            }
                        } else if (key == Index.IDENTITY_OBJECT) {
                            if (idenData.size() > 0) {
                                rtnObjects.put(Index.IDENTITY_OBJECT, (Identity_Information__c)setData(idenData, (Identity_Information__c)obj));    
                            }
                        } else if (key == Index.ABOUT_ACCOUNT_OBJECT) {
                            if (accData.size() > 0) {
                                rtnObjects.put(Index.ABOUT_ACCOUNT_OBJECT, (About_Account__c)setData(accData, (About_Account__c)obj));    
                            }
                        } else if (key == Index.APPLICATION_ACTIVITY_OBJECT) {
                            if (appactData.size() > 0) {
                                rtnObjects.put(Index.APPLICATION_ACTIVITY_OBJECT, (Application_Activity__c)setData(accData, (Application_Activity__c)obj));    
                            }
                        }  else if (key == Index.DOCUSIGN_CONFIG_OBJECT) {
                            if (docData.size() > 0) {
                                rtnObjects.put(Index.DOCUSIGN_CONFIG_OBJECT, (Docusign_Config__c)setData(docData, (Docusign_Config__c)obj));    
                            }  
                        }   else if (key == Index.APPLICATION_CONFIGURATION_OBJECT) {
                            if (appconfigData.size() > 0) {
                                rtnObjects.put(Index.APPLICATION_CONFIGURATION_OBJECT, (Application_Configuration__c)setData(appconfigData, (Application_Configuration__c)obj));    
                            }  
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Key:' + key + ': ' + String.valueOf(appData.keySet())));      
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
                    }
                } else {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Object is null for Key:' + key));      
                }  
            }
        } catch (Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Field: ' + fn  + ': type: ' + fielddataType + ':' + e.getMessage()));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
        }
        return rtnObjects;
    }

    public static sObject setData(Map<String,String> appData, sObject obj) {
        try {
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            String fieldLabel = null;
            Schema.DisplayType fielddataType = null;
            for (String fn : appData.keySet()) {
                if (fieldMap.get(fn) != null) {
                    fielddataType = fieldMap.get(fn).getDescribe().getType();
                    if (fielddataType != null && fielddataType == Schema.DisplayType.Boolean) {
                        obj.put(fn, Boolean.valueOf(appData.get(fn)));
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.Currency) {
                        String i = appData.get(fn), s = null;
                        i = i.replace(',', '');
                        if (i != null && i.trim() != '') {
                            s = (Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
                            s = s.substring(0,s.length()-1);
                            s = s.replace(',', '');
                            obj.put(fn, Decimal.valueOf(s));
                        }
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.Double) {
                        String val = appData.get(fn);
                        if (val != '') {
                            obj.put(fn, Double.valueOf(appData.get(fn)));
                        }
                    } else if (fielddataType != null && fielddataType == Schema.DisplayType.DateTime){
                        String dt = appData.get(fn);
                        if (dt != null & dt != '') {
                            obj.put(fn, DateTime.valueOf(appData.get(fn)));
                        }
                    } else {
                        obj.put(fn, String.escapeSingleQuotes(String.valueOf(appData.get(fn))));
                    }
                }
            }
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            appData.put('debug-server-errors', e.getMessage());
            appData.put('server-errors-stack-trace', e.getStackTraceString()); 
        }
        
        return obj;
    }

    public static Map<String,String> getData(Map<String,String> appData, Map<String,sObject> appObjects, Boolean buildPickListData) {
        try {
            sObject obj = null;
            for (String key : appObjects.keySet()) {
                obj = appObjects.get(key);
                if (obj != null) {
                    if (key == Index.APPLICATION_OBJECT) {
                        appData = getData(appData, (Application__c)obj, buildPickListData);
                    } else if (key == Index.APPLICATION2_OBJECT) {
                        appData = getData(appData, (Application2__c)obj, buildPickListData);
                    } else if (key == Index.EMPLOYMENT_OBJECT) {
                        appData = getData(appData, (Employment_Information__c)obj, buildPickListData);
                    } else if (key == Index.IDENTITY_OBJECT) {
                        appData = getData(appData, (Identity_Information__c)obj, buildPickListData);
                    } else if (key == Index.CROSS_SELL_LOGIC_OBJECT) {
                        appData = getData(appData, (Cross_Sell_Logic__c)obj, buildPickListData);
                    } else if (key == Index.ABOUT_ACCOUNT_OBJECT) {
                        appData = getData(appData, (About_Account__c)obj, buildPickListData);
                    } else if (key == Index.APPLICATION_ACTIVITY_OBJECT) {
                        appData = getData(appData, (Application_Activity__c)obj, buildPickListData);
                    } else if (key == Index.DOCUSIGN_CONFIG_OBJECT) {
                        appData = getData(appData, (Docusign_Config__c)obj, buildPickListData);
                    } else if (key == Index.APPLICATION_CONFIGURATION_OBJECT) {
                        appData = getData(appData, (Application_Configuration__c)obj, buildPickListData);
                    }
                }
            }
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            //appData.put('debug-server-errors', e.getMessage());
            //appData.put('server-errors-stack-trace', e.getStackTraceString());
        }

        return appData;
    }

    public static Map<String,String> getData(Map<String,String> appData, sObject obj, Boolean buildPickListData) {
        if (obj != null) {
            // Serialize our Sobject into JSON
            String s = JSON.serialize(obj);
            // Deserialize it back into a key/value map
            Map<String,Object> obj1 = (Map<String,Object>) JSON.deserializeUntyped(s);
            // Build a set containing the fields present on our SObject
            Set<String> fieldsPresent = obj1.keyset().clone();
            // Salesforce always adds an extra 'attributes' key to SObjects
            // when you do JSON stuff, so let's get rid of that.
            fieldsPresent.remove('attributes');
            //System.debug(fieldsPresent);
            for (String fn : fieldsPresent) {
                try {
                    appData.put(obj.getSobjectType() + '.' + fn.toLowerCase(), String.valueOf(obj.get(fn)));
                } catch (Exception e) {
                    Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'getData(): Field: ' + fn  + ':' + e.getMessage()));      
                    //appData.put(obj.getSobjectType() + '.' + fn, e.getMessage());    
                    //appData.put('debug-server-errors', e.getMessage());
                    //appData.put('server-errors-stack-trace', e.getStackTraceString());
                }
            }
        }
 
        return appData;
    }


    public static Map<String,String> getFieldOptions(Map<String,String> appData, Id id) {
        try{
            RequiredFieldsUtility rfu = new RequiredFieldsUtility();
            Set<String> requiredFields = rfu.fieldsRequiredAre(id);
            Set<String> displayedFields = rfu.fieldsDisplayedAre(id);
            for (String fn : requiredFields) {
                appData.put('RequiredFields.' + fn.toLowerCase(), 'true');
            }

            List<Field_Logic_New__c> fieldList = [SELECT Field_Name__c, Label__c FROM Field_Logic_New__c WHERE RecordType.name != 'Page Labels' AND Field_Name__c in :displayedFields];
            system.debug('the size of the set is: '+ fieldList.size());
            for (Field_Logic_New__c fl : fieldList) {
                appData.put('DisplayedFields.' + fl.Field_Name__c.toLowerCase(), (fl.Label__c == null) ? '' : fl.Label__c);                        
            }
        } catch (QueryException e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());                        
        }

        return appData;
    }

    public static Map<String,String> getAllFields(Map<String,String> data, String objectName) {
        sObject app;
        Map<String,String> appData;
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        try {
            String query = 'SELECT ' + String.join(new List<String>(objectFields.keySet()), ', ') + ' FROM ' + objectName
                    + ' WHERE id = \'' + String.escapeSingleQuotes(data.get('id')) + '\' LIMIT 1';
            app = database.query(query);
            if (objectName == Index.APPLICATION_OBJECT) {CryptoHelper.refreshToken((Application__c)app);}
            appData = new Map<String, String>();
            appData = getData(appData, app, true);
            appData.put('query', query);
            
        } catch (QueryException e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            //perform exception handling
            appData.put('debug-server-errors', e.getMessage());
            appData.put('server-errors-stack-trace', e.getStackTraceString());
        }
        return appData;
    }

    public static Map<String,String> retrieveApp(Map<String,String> data, Application__c app, Identity_Information__c iden) {
        Logger.addMessage('Retrieving Application', system.now().format());
        Map<String,String> appData = new Map<String,String>();
        try {
            if (data.get('last_name__c') == app.last_name__c && data.get('date_of_birth__c') == iden.date_of_birth__c && 
                    data.get('email_address__c') == app.email_address__c && data.get('ssn_last_four_pa__c') == iden.SSN_Last_Four_PA__c) {
                app.Current_Channel__c='Online'; 
                app.Current_timestamp__c =system.now();
                app.Current_Person__c = system.userInfo.getUserId();
                app.Ownerid = system.userInfo.getUserId();
                app.Current_Branch_Name__c = '';
                app.Current_User_Email_Address__c = '';
                app.Application_Page__c = Index.PERSONAL_INFO_PAGE;
                Application_Activity__c appact = new Application_Activity__c ();
                CryptoHelper.refreshToken(app);
                if (Application__c.SObjectType.getDescribe().isUpdateable()) {update app;}
                appact.Application__c= app.Id;
                appact.Branch__c = app.Current_Branch_Name__c;
                appact.Channel__c = app.Current_Channel__c;
                appact.Name__c = app.Current_Person__c;
                appact.Action__c = 'Resumed the Application';
                appact.Activity_Time__c = system.now();
                if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {insert appact;}
                
                appData = getData(appData, app, false);
                if (app != null) { 
                    String userToken = CryptoHelper.decrypt(app.User_Token__c); 
                    appData.put('ut', userToken);
                }
            } else {
                Logger.addMessage('RetrieveApp : Cannot find a matching record for the data entered', system.now().format());
                appData.put('server-errors','Cannot find a matching record for the data entered.');
                //appData.put('debug-server-errors','Cannot find the record:' + data.get('last_name__c') + ': ' + app.last_name__c + '; ' + data.get('date_of_birth__c') + ': ' + iden.date_of_birth__c + '; ' + data.get('email_address__c') + ': ' + app.email_address__c + '; ' + data.get('ssn_last_four_pa__c') + ': ' + iden.SSN_Last_Four_PA__c);
            }
        } catch (Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            //RMM: need a place to put server errors - data gets overwritten!
            appData.put('debug-server-errors', e.getMessage());
            appData.put('server-errors-stack-trace', e.getStackTraceString());
        }

        return appData;
    }

    public static Map<String,String> appStatus(Map<String,String> data, Application__c app, Identity_Information__c iden) {
        Logger.addMessage('App Status', system.now().format());
        Map<String,String> appData = new Map<String,String>();
        try {
            String userToken = CryptoHelper.decrypt(app.User_Token__c); 
            if (data.get('last_name__c') == app.last_name__c && data.get('date_of_birth__c') == iden.date_of_birth__c && 
                    data.get('ssn_last_four_pa__c') == iden.SSN_Last_Four_PA__c) {

                app.Application_Page__c = 'StatusPortalPage';
            } else {
                Logger.addMessage('App Status : Cannot find a matching record for the data entered', system.now().format());
                appData.put('server-errors','Cannot find a matching record for the data entered.');
                appData.put('debug-server-errors','Cannot find the record:' + data.get('last_name__c') + ': ' + app.last_name__c + '; ' + data.get('date_of_birth__c') + ': ' + iden.date_of_birth__c + '; ' +  data.get('ssn_last_four_pa__c') + ': ' + iden.SSN_Last_Four_PA__c);
            }
        } catch (Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            system.debug('The error is ' + e.getMessage());
            //RMM: need a place to put server errors - data gets overwritten!
            appData.put('debug-server-errors', e.getMessage());
            appData.put('server-errors-stack-trace', e.getStackTraceString());
        }

        return appData;
    }

    public static Map<String,sObject> schedulePage(Map<String,String> data, String pageName, Set<String> fieldsToDisplay, Map<String,sObject> appObjects) {
        try {
            appObjects = setData(data, appObjects);
            Application__c app = (Application__c)appObjects.get(Index.APPLICATION_OBJECT);
            Application2__c app2 = (Application2__c)appObjects.get(Index.APPLICATION2_OBJECT);
            Employment_Information__c emp = (Employment_Information__c)appObjects.get(Index.EMPLOYMENT_OBJECT);
            Identity_Information__c iden = (Identity_Information__c)appObjects.get(Index.IDENTITY_OBJECT);
            About_Account__c acc = (About_Account__c)appObjects.get(Index.ABOUT_ACCOUNT_OBJECT);
            
            if (app != null) {
                if (Application__c.SObjectType.getDescribe().isUpdateable()) {update app;}
            }
            if (emp != null && Employment_Information__c.SObjectType.getDescribe().isUpdateable()) {update emp;}
            if (iden != null && Identity_Information__c.SObjectType.getDescribe().isUpdateable()) {update iden;}
            if (acc != null && About_Account__c.SObjectType.getDescribe().isUpdateable()) {update acc;}


            appObjects.put(Index.APPLICATION_OBJECT, (Application__c)app);    
            appObjects.put(Index.APPLICATION2_OBJECT, (Application2__c)app2);    
            appObjects.put(Index.EMPLOYMENT_OBJECT, (Employment_Information__c)emp);    
            appObjects.put(Index.IDENTITY_OBJECT, (Identity_Information__c)iden);    
            appObjects.put(Index.ABOUT_ACCOUNT_OBJECT, (About_Account__c)acc);
            Logger.addMessage('Scheduled an appointment', system.now().format());
            
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
        }


        return appObjects;
    }
    
    public static Map<String,sObject> previousPage(Map<String,String> data, String pageName, Set<String> fieldsToDisplay, Map<String,sObject> appObjects) {
        Logger.addMessage('Navigating to the previous page', system.now().format());
        try {
            appObjects = setData(data, appObjects);
            Application__c app = (Application__c)appObjects.get(Index.APPLICATION_OBJECT);
            Application2__c app2 = (Application2__c)appObjects.get(Index.APPLICATION2_OBJECT);
            Employment_Information__c emp = (Employment_Information__c)appObjects.get(Index.EMPLOYMENT_OBJECT);
            Identity_Information__c iden = (Identity_Information__c)appObjects.get(Index.IDENTITY_OBJECT);
            About_Account__c acc = (About_Account__c)appObjects.get(Index.ABOUT_ACCOUNT_OBJECT);
            system.debug('page name in utility is: '+pageName);
            if (app != null) {
                if (pageName == Index.PERSONAL_INFO_PAGE) {
                    app.Application_Page__c = Index.CROSS_SELL_PAGE;            
                } else if (pageName == Index.EMPLOYMENT_PAGE) {
                    app.Application_Page__c = Index.PERSONAL_INFO_PAGE;            
                } else if (pageName == Index.IDENTITY_PAGE) {
                    system.debug('previous from identity to employment: '+pageName);
                    app.Application_Page__c = Index.EMPLOYMENT_PAGE;            
                } else if (pageName == Index.ACCOUNT_DETAILS_PAGE) {
                    app.Application_Page__c = Index.IDENTITY_PAGE;            
                } else if (pageName == Index.PURCHASE_DETAILS_PAGE) {
                    if (app.Flow_Control__c == 'Identity to PurchaseDetails') {
                        app.Application_Page__c = Index.IDENTITY_PAGE;
                    } else if (app.Flow_Control__c == 'Identity to AccountDetails to Purchasedetails') {
                        app.Application_Page__c = Index.ACCOUNT_DETAILS_PAGE;
                    }
                } else if (pageName == Index.PROPERTY_DETAILS_PAGE) {
                    app.Application_Page__c = Index.PURCHASE_DETAILS_PAGE;            
                } else if (pageName == Index.DECLARATIONS_PAGE) {
                    app.Application_Page__c = Index.PROPERTY_DETAILS_PAGE;            
                } else if (pageName == Index.REVIEW_SUBMIT_PAGE) {
                    if (app.Flow_Control__c == 'Identity to AccountDetails to Purchasedetails' || app.Flow_Control__c == 'Identity to PurchaseDetails') {
                        app.Application_Page__c = Index.DECLARATIONS_PAGE;            
                    } else if (app.Flow_Control__c == 'Identity to AccountDetails to ReviewSubmit') {
                        app.Application_Page__c = Index.ACCOUNT_DETAILS_PAGE;
                    }            
                } else if (pageName == Index.CONFIRMATION_PAGE) {
                    app.Application_Page__c = Index.REVIEW_SUBMIT_PAGE;            
                }
                if (Application__c.SObjectType.getDescribe().isUpdateable()) {update app;}
            }
            if (emp != null && Employment_Information__c.SObjectType.getDescribe().isUpdateable()) {update emp;}
            if (iden != null && Identity_Information__c.SObjectType.getDescribe().isUpdateable()) {update iden;}
            if (acc != null && About_Account__c.SObjectType.getDescribe().isUpdateable()) {update acc;}


            appObjects.put(Index.APPLICATION_OBJECT, (Application__c)app);    
            appObjects.put(Index.APPLICATION2_OBJECT, (Application2__c)app2);    
            appObjects.put(Index.EMPLOYMENT_OBJECT, (Employment_Information__c)emp);    
            appObjects.put(Index.IDENTITY_OBJECT, (Identity_Information__c)iden);    
            appObjects.put(Index.ABOUT_ACCOUNT_OBJECT, (About_Account__c)acc);
            
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
        }
          
        return appObjects;
    }
    
    public static void emailSending(Application__c app) {
        try {
            ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'Index'];
            String NAMESPACE = '';
            if (ac.NameSpacePrefix != null) {
                NAMESPACE = ac.NameSpacePrefix + '__';
            }
            String hostUrl = URL.getSalesforceBaseUrl().toExternalForm();
            String path = 'apex/'+NAMESPACE;
            String[] toAddresses = new String[] {app.Email_Address__c}; 
            EmailTemplate et=[Select id from EmailTemplate where name=:'Confirmation Email'];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toaddresses);
            email.setTemplateId(et.id);
            email.setTargetObjectId(UserInfo.getUserId());
            email.setWhatId(app.Id);
            email.setSaveAsActivity(false);
            // sending email
            Messaging.SendEmailResult [] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            System.debug('******email result***********'+r);
            Logger.addMessage('Sent email to the customer', system.now().format());
        } catch(Exception e) {
            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            system.debug('Error in sending email is '+e.getMessage());
        }
    }

    public static Map<String,sObject> processData(Map<String,String> data, String pageName, Set<String> fieldsToDisplay, Map<String,sObject> appObjects) {
        Logger.addMessage('Processing Input App Data',system.now().format());
        try {
            appObjects = setData(data, appObjects);
            Application__c app = (Application__c)appObjects.get(Index.APPLICATION_OBJECT);
            Application2__c app2 = (Application2__c)appObjects.get(Index.APPLICATION2_OBJECT);
            Employment_Information__c emp = (Employment_Information__c)appObjects.get(Index.EMPLOYMENT_OBJECT);
            Identity_Information__c iden = (Identity_Information__c)appObjects.get(Index.IDENTITY_OBJECT);
            About_Account__c acc = (About_Account__c)appObjects.get(Index.ABOUT_ACCOUNT_OBJECT);
            Application_Activity__c appact = (Application_Activity__c)appObjects.get(Index.APPLICATION_ACTIVITY_OBJECT);
            Cross_Sell_Logic__c cross = (Cross_Sell_Logic__c)appObjects.get(Index.CROSS_SELL_LOGIC_OBJECT);
            Application_Configuration__c appconfig = (Application_Configuration__c)appObjects.get(Index.APPLICATION_CONFIGURATION_OBJECT);
            if (IndexValidationExtension.isDataValid(app, pageName, app2, emp, iden, acc)) {
                if (pageName == Index.GET_STARTED_PAGE) {
                    app.Application_Status__c = 'Open';
                    if (cross == null || (cross.Primary_Offer__c==null && cross.Secondary_Offer__c==null && cross.Third_Offer__c==null)) {
                        app.Application_Page__c = Index.PERSONAL_INFO_PAGE;            
                    } else {
                        app.Application_Page__c = Index.CROSS_SELL_PAGE;            
                    }
                } else if (pageName == Index.CROSS_SELL_PAGE) {
                    system.debug('Before number of products is' + app.Number_of_Products__c);
                    if (data.get(Index.NAMESPACE + Index.APPLICATION_OBJECT + '.primary_offer__c') == null) {
                        app.Primary_Offer__c = null;    
                    }
                    if (data.get(Index.NAMESPACE + Index.APPLICATION_OBJECT + '.second_offer__c') == null) {
                        app.Second_Offer__c = null;    
                    }
                    if (data.get(Index.NAMESPACE + Index.APPLICATION_OBJECT + '.third_offer__c') == null) {
                        app.Third_Offer__c = null;    
                    }

                    Integer i = 0;
                    // To update type of BusinessChecking product selected
                    if (app.Product__c.contains(Product_Names_Mapping__c.getValues('Business').Product_Name__c)) {
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                            app.Type_Of_Business_Checking__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                            app.Type_Of_Business_Checking__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                            app.Type_Of_Business_Checking__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessChecking').Product_Name__c)) {
                            app.Type_Of_Business_Checking__c = app.Third_Offer__c;
                        } else {
                            app.Type_Of_Business_Checking__c = null;
                        }
                        if (app.Type_Of_Business_Checking__c != null) {
                            i = i+1;
                        }

                        // To update Type of BusinessSavings Product selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                            app.Type_Of_Business_Savings__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                            app.Type_Of_Business_Savings__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                            app.Type_Of_Business_Savings__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessSavings').Product_Name__c)) {
                            app.Type_Of_Business_Savings__c = app.Third_Offer__c;
                        } else {
                            app.Type_Of_Business_Savings__c = null;
                        }
                        if (app.Type_Of_Business_Savings__c != null) {
                            i = i+1;
                        }

                        // To update type of BusinessCDs product selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                            app.Type_Of_Business_CDs__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                            app.Type_Of_Business_CDs__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                            app.Type_Of_Business_CDs__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCDs').Product_Name__c)) {
                            app.Type_Of_Business_CDs__c = app.Third_Offer__c;
                        } else {
                            app.Type_Of_Business_CDs__c = null;
                        }
                        if (app.Type_Of_Business_CDs__c != null) {
                            i = i+1;
                        }

                        // To update type of BusinessCreditCards selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                            app.Type_Of_Business_Credit_Cards__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                            app.Type_Of_Business_Credit_Cards__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                            app.Type_Of_Business_Credit_Cards__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessCreditCards').Product_Name__c)) {
                            app.Type_Of_Business_Credit_Cards__c = app.Third_Offer__c;
                        } else {
                            app.Type_Of_Business_Credit_Cards__c = null;
                        }
                        if (app.Type_Of_Business_Credit_Cards__c != null) {
                            i = i+1;
                        }

                        // To update type of BusinessLoans selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                            app.Type_Of_Business_Loans__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                            app.Type_Of_Business_Loans__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                            app.Type_Of_Business_Loans__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('BusinessLoans').Product_Name__c)) {
                            app.Type_Of_Business_Loans__c = app.Third_Offer__c;
                        } else {
                            app.Type_Of_Business_Loans__c = null;
                        }
                        if (app.Type_Of_Business_Loans__c != null) {
                            i=i+1;
                        }

                    } else {
                        // to update type of Checking Product Selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                            app.Type_of_Checking__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                            app.Type_of_Checking__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                            app.Type_of_Checking__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c)) {
                            app.Type_of_Checking__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Checking__c = null;
                        }
                        if (app.Type_of_Checking__c != null) {
                            i = i+1;
                        }

                        // To update Type of Savings Product selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                            app.Type_of_Savings__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                            app.Type_of_Savings__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                            app.Type_of_Savings__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                            app.Type_of_Savings__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Savings__c = null;
                        }
                        if (app.Type_of_Savings__c != null) {
                            i = i+1;
                        }

                        // To update type of Certificates product selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                            app.Type_of_Certificates__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                            app.Type_of_Certificates__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                            app.Type_of_Certificates__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('Certificates').Product_Name__c)) {
                            app.Type_of_Certificates__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Certificates__c = null;
                        }
                        if (app.Type_of_Certificates__c != null) {
                            i = i+1;
                        }

                        // To update type of Credit Cards selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                            app.Type_of_Credit_Cards__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                            app.Type_of_Credit_Cards__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                            app.Type_of_Credit_Cards__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('CreditCards').Product_Name__c)) {
                            app.Type_of_Credit_Cards__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Credit_Cards__c = null;
                        }
                        if (app.Type_of_Credit_Cards__c != null) {
                            i = i+1;
                        }

                        // To update type of Vehicle Loans selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                            app.Type_of_Vehicle_Loans__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                            app.Type_of_Vehicle_Loans__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                            app.Type_of_Vehicle_Loans__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('VehicleLoans').Product_Name__c)) {
                            app.Type_of_Vehicle_Loans__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Vehicle_Loans__c = null;
                        }
                        if (app.Type_of_Vehicle_Loans__c != null) {
                            i=i+1;
                        }

                        // To update type of Personal Loan selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                            app.Type_of_Personal_Loans__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                            app.Type_of_Personal_Loans__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                            app.Type_of_Personal_Loans__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('PersonalLoans').Product_Name__c)) {
                            app.Type_of_Personal_Loans__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Personal_Loans__c = null;
                        }
                        if (app.Type_of_Personal_Loans__c != null) {
                            i = i+1;
                        }

                        // To update type of Mortgage Loan product selected
                        if (app.Sub_Product__c != null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                            app.Type_of_Mortgage_Loan__c = app.Sub_Product__c;
                        } else if (app.Primary_Offer__c != null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                            app.Type_of_Mortgage_Loan__c = app.Primary_Offer__c;
                        } else if (app.Second_Offer__c != null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                            app.Type_of_Mortgage_Loan__c = app.Second_Offer__c;
                        } else if (app.Third_Offer__c != null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeLoan').Product_Name__c)) {
                            app.Type_of_Mortgage_Loan__c = app.Third_Offer__c;
                        } else {
                            app.Type_of_Mortgage_Loan__c = null;
                        }
                        if (app.Type_of_Mortgage_Loan__c != null) {
                            i = i+1;
                        }
                                    
                        // To update type of Home Equity product selected
                        if (app.Sub_Product__c!=null && app.Sub_Product__c.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                            app.Type_Of_Home_Equity__c=app.Sub_Product__c;
                        } else if (app.Primary_Offer__c!=null && app.Primary_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                            app.Type_Of_Home_Equity__c=app.Primary_Offer__c;
                        } else if (app.Second_Offer__c!=null && app.Second_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                            app.Type_Of_Home_Equity__c=app.Second_Offer__c;
                        } else if (app.Third_Offer__c!=null && app.Third_Offer__c.contains(Product_Names_Mapping__c.getValues('HomeEquity').Product_Name__c)) {
                            app.Type_Of_Home_Equity__c=app.Third_Offer__c;
                        } else {
                            app.Type_Of_Home_Equity__c=null;
                        }
                        if (app.Type_Of_Home_Equity__c!=null) {
                            i=i+1;
                        }
                    }


                    app.Number_of_Products__c = i;
                    system.debug('after number of products is' + app.Number_of_Products__c); 
                    app.Application_Page__c = Index.PERSONAL_INFO_PAGE; 
                    
                    if (acc != null) {
                        if (app.Type_of_Checking__c == null) {
                            acc.Funding_Type_CHK__c = null;
                            acc.Account_type_FI_CHK__c = null;
                            acc.Select_Account_FI_CHK__c = null;
                            acc.CHK_Account_Number__c = null;
                            acc.Routing_Number_CHK__c = null;
                            acc.Account_Holder_Name_CHK__c = null;
                            acc.Dollar_Amount_Internal_CHK__c = null;
                            acc.Dollar_Amount_External_CHK__c = null;
                            acc.Financial_Institution_CHK__c=null;
                            acc.Disclosure_AccountDetails_chk__c = false;
                        }
                        if (app.Type_of_Savings__c == null) {      
                            acc.Funding_Type_SAV__c = null;
                            acc.Account_Type_FI_Sav__c = null;
                            acc.Select_Account_FI_SAV__c = null;
                            acc.SAV_Account_Number__c = null;
                            acc.Routing_Number_Sav__c = null;
                            acc.Account_Holder_Name_SAV__c = null;
                            acc.Dollar_Amount_Internal_SAV__c = null;
                            acc.Dollar_Amount_External_SAV__c = null;
                            acc.Disclosure_AccountDetails_SAV__c = false;
                            acc.Financial_Institution_SAV__c=null;
                        }
                        if (app.Type_of_Certificates__c == null) {      
                            acc.Funding_Type_CERT__c = null;
                            acc.Account_Type_FI_Cert__c = null;
                            acc.Select_Account_FI_CERT__c = null;
                            acc.CERT_Account_Number__c = null;
                            acc.Routing_Number_Cert__c = null;
                            acc.Account_Holder_Name_CERT__c = null;
                            acc.Dollar_Amount_Internal_CERT__c = null;
                            acc.Dollar_Amount_External_CERT__c = null;
                            acc.Disclosure_AccountDetails_CERT__c = false;
                            acc.Financial_Institution_Cert__c=null;
                        }
                                                
                        if (app.Type_of_Personal_Loans__c == null) {      
                            acc.Debt_Consolidation_Personal_Loan__c = null;
                            acc.OtherPurpose_PersonalLoans__c = null;
                            acc.Purpose_PersonalLoans__c = null;
                            acc.Requested_Credit_Limit_PersonalLoans__c = null;
                            acc.Requested_Loan_Amount_PersonalLoans__c = null;
                            acc.Term_Personalloans__c = null;
                        }
                        if (app.Type_of_Vehicle_Loans__c == null) {      
                            acc.Debt_Consolidation_Vehicle_LOan__c = null;
                            acc.OtherPurpose_VehicleLoans__c = null;
                            acc.Purpose_VehicleLoan__c = null;
                            acc.Requested_Loan_Amount_VehicleLoans__c = null;
                            acc.Term_VehicleLoans__c = null;
                            acc.Purpose_DebtConsolidation_VehicleLoan__c = null;
                            acc.Non_Auto_Vehicle_Make__c = null;
                            acc.Non_Auto_Vehicle_Mileage__c = null;
                            acc.Non_Auto_Vehicle_Model__c = null;
                            acc.Non_Auto_Vehicle_Sub_Model__c = null;
                            acc.Non_Auto_Vehicle_VIN__c = null;
                            acc.Non_Auto_Vehicle_Year__c = null;
                            acc.VehicleMake__c = null;
                            acc.VehicleMileage__c = null;
                            acc.VehicleModel__c = null;
                            acc.Vehicle_Sub_Model__c = null;
                            acc.VehicleYear__c = null;
                            acc.VIN__c = null;
                        }
                        if (app.Type_of_Credit_Cards__c!=null) {
                            acc.Requested_Credit_Limit_Ccards__c=null;
                            acc.Purpose_Ccards__c=null;
                            acc.Debt_Consolidation_Credit_Card__c=null;
                            acc.OtherPurpose_Ccards__c=null;
                        }                     
                    }

                    if(app.Primary_Offer__c != null) {
                        List<String> l1 = app.Primary_Offer__c.split('-', 10);
                        if(l1[0] != null) {
                            app.Cross_Sell_1_Product__c = l1[0].trim();
                        }
                    }

                    if(app.Second_Offer__c != null) {
                        List<String> l2 = app.Second_Offer__c.split('-', 10);
                        if(l2[0] != null) {
                            app.Cross_Sell_2_Product__c = l2[0].trim();
                        }
                    }

                    if(app.Third_Offer__c != null) {
                       List<String> l3 = app.Third_Offer__c.split('-', 10);
                       if(l3[0] != null) {
                           app.Cross_Sell_3_Product__c = l3[0].trim();
                       } 
                    }

                } else if (pageName == Index.PERSONAL_INFO_PAGE) {
                    app.Application_Page__c = Index.EMPLOYMENT_PAGE;            
                } else if (pageName == Index.EMPLOYMENT_PAGE) {
                    app.Application_Page__c = Index.IDENTITY_PAGE;            
                } else if (pageName == Index.IDENTITY_PAGE) {
                    system.debug('IN NEXT STEP flow control at Identity Details for Only mortgage' + app.Flow_Control__c);
                    if (app.Flow_Control__c == 'Identity to PurchaseDetails') {
                        app.Application_Page__c = Index.PURCHASE_DETAILS_PAGE;
                        system.debug('IN NEXT STEP flow control at Identity Details for mortgage and other' + app.Flow_Control__c);
                    } else if (app.Flow_Control__c == 'Identity to AccountDetails to Purchasedetails') {
                        app.Application_Page__c = Index.ACCOUNT_DETAILS_PAGE;
                        system.debug('IN NEXT STEP flow control at Identity Details for NO mortgage' + app.Flow_Control__c);
                    } else if (app.Flow_Control__c == 'Identity to AccountDetails to ReviewSubmit') {
                        app.Application_Page__c = Index.ACCOUNT_DETAILS_PAGE;
                    }
                } else if (pageName == Index.ACCOUNT_DETAILS_PAGE) {
                    system.debug('IN NEXT STEP flow control at account details for mortgage and others' + app.Flow_Control__c);
                    if (app.Flow_Control__c == 'Identity to AccountDetails to Purchasedetails') {
                        app.Application_Page__c = Index.PURCHASE_DETAILS_PAGE;            
                    } else {
                        system.debug('IN NEXT STEP flow control at account details for NO mortgage' + app.Flow_Control__c);
                        app.Application_Page__c = Index.REVIEW_SUBMIT_PAGE;
                    }   
                } else if (pageName == Index.PURCHASE_DETAILS_PAGE) {
                    app.Application_Page__c = Index.PROPERTY_DETAILS_PAGE;            
                } else if (pageName == Index.PROPERTY_DETAILS_PAGE) {
                    app.Application_Page__c = Index.DECLARATIONS_PAGE;            
                } else if (pageName == Index.DECLARATIONS_PAGE) {
                    app.Application_Page__c = Index.REVIEW_SUBMIT_PAGE;            
                    data.remove('id');
                    try {
                        if (app2 != null && Application2__c.SObjectType.getDescribe().isUpdateable()) {update app2;}
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                        system.debug('The error is ' + e.getMessage());
                        //RMM: need a place to put server errors - data gets overwritten!
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
                    }
                } else if (pageName == Index.REVIEW_SUBMIT_PAGE) {
                    app.Application_Page__c = Index.CONFIRMATION_PAGE;
                    // TODO: Whatever else needs to be done here before submitting an app! 
                    /*try{
                        if(appconfig.Docusign_Package_Installed__c == true && app.Current_Channel__c == 'Call Center'){
                            system.debug('alert a');
                            Type t = Type.forName(appconfig.Docusign_Class_CC__c);
                            SignInterface instance = (SignInterface)t.newInstance();
                            String mssg = instance.main(app.id);
                            Logger.addMessage('Result of docusign email sent to the customer for reviewing the disclosures: '+ mssg, system.now().format());                        
                        }
                    }
                    catch (Exception e) {
                        Logger.addMessage('Exception while emailing disclosures via Esign to the customer: '+ e + '; ' + e.getLineNumber(), system.now().format());
                        system.debug('The error is ' + e.getMessage());
                    } */
                    try {
                        system.debug('alert b');
                        app.Application_Status__c='Submitted';
                        //app.Abandoned__c=true;
                        app.Submitted_Person__c = app.Current_Person__c;
                        app.Submitted_Channel__c = app.Current_Channel__c;
                        app.Submitted_Timestamp__c = system.now();
                        app.Submitted_Branch_Name__c = app.Current_Branch_Name__c;
                        app.Submitted_User_Email_Address__c = app.Current_User_Email_Address__c;
                        
                        //User Tracking Info
                        appact.Application__c= app.Id;
                        appact.Channel__c = app.Current_Channel__c;
                        appact.Name__c = app.Current_Person__c;
                        appact.Action__c = 'Submitted the Application';
                        appact.Activity_Time__c = system.now();
                        if (Application_Activity__c.SObjectType.getDescribe().isCreateable()) {
                            try{
                                system.debug('alert c');
                                insert appact;
                                Logger.addMessage('Updated Application activity', system.now().format());
                            } catch(Exception e){
                                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                            }
                        }
                        emailSending(app); 
                    } catch(DMLException e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                        system.debug('DML Exception for future application status and verifyIdentity check update is '+e.getMessage());
                    }           
                } else if (pageName == Index.CONFIRMATION_PAGE) {
                    app.Application_Page__c = Index.THANK_YOU_PAGE;            
                    if (app.Application_Status__c != 'Submitted') {
                        app.Application_Status__c = 'Submitted';
                        app.Date__c = system.today();
                        CryptoHelper.expireToken(app);
                    }
                } else if (pageName == Index.SCHEDULE_PAGE) {
                    //Need to determine the logic for this page.
                    //IndexUtilityExtension.setAppData(data, app);
                    ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'Index'];
                    String NAMESPACE = '';
                    if (ac.NameSpacePrefix != null) {
                        NAMESPACE = ac.NameSpacePrefix + '__';
                    }
                    if (app.Application_Status__c != 'Scheduled') {
                        String[] toAddresses = new String[] {app.Email_Address__c}; 
                        String hostUrl = URL.getSalesforceBaseUrl().toExternalForm();
                        String path = 'apex/'+NAMESPACE+'index';
                        EmailTemplate et=[Select id from EmailTemplate where name=:'Scheduled Email'];
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(toaddresses);
                        email.setTemplateId(et.id);
                        email.setTargetObjectId(UserInfo.getUserId());
                        email.setWhatId(app.Id);
                        email.setSaveAsActivity(false);
                        Messaging.SendEmailResult [] r = null; 
                        // Sends the email
                        try {
                            r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                        } catch(Exception e) {
                            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                        }
                        System.debug('******email result***********'+r);
                        app.Application_Status__c = 'Scheduled';
                        app.App_Scheduled__c = true;
                    }
                } else if (pageName == Index.SAVE_FOR_LATER_PAGE) {
                    //IndexUtilityExtension.setAppData(data, app);
                    ApexClass ac = [SELECT NameSpacePrefix FROM ApexClass WHERE Name = 'Index'];
                    String NAMESPACE = '';
                    if (ac.NameSpacePrefix != null) {
                        NAMESPACE = ac.NameSpacePrefix + '__';
                    }
                    if (app.Save_For_Later__c == false) {
                        String[] toAddresses = new String[] {app.Email_Address__c}; 
                        String hostUrl = URL.getSalesforceBaseUrl().toExternalForm();
                        //String path = 'apex/'+NAMESPACE+'index';
                        String path;
                        String instance = URL.getCurrentRequestUrl().toExternalForm();
                        system.debug('intance'+instance);
                        system.debug('hosturl'+hosturl);
                        if(instance.contains('apex')){
                            path = URL.getCurrentRequestUrl().toExternalForm().split('/')[3].trim()+NAMESPACE+'index';
                        }else{
                            path = NAMESPACE+'index';
                        }
                        EmailTemplate et=[Select id from EmailTemplate where name=:'Save for later'];
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(toaddresses);
                        email.setTemplateId(et.id);
                        email.setTargetObjectId(UserInfo.getUserId());
                        email.setWhatId(app.Id);
                        email.setSaveAsActivity(false);
                        Messaging.SendEmailResult [] r = null; 
                        // Sends the email
                        try {
                            r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                        } catch(Exception e) {
                            Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
                        }
                        System.debug('******email result***********'+r);
                        System.debug('*******save for later checked*********'+app.Save_for_Later__c);  
                        app.Save_For_Later__c = true;
                        app.Application_Status__c = 'Save for Later';
                        System.debug('*******save for later checked changed*********'+app.Save_for_Later__c);
                        Logger.addMessage('Save for later checked', system.now().format());
                    }
                }

                if (Application__c.SObjectType.getDescribe().isUpdateable()) {
                    try{
                        update app;
                    } catch (exception e){
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (emp != null && Employment_Information__c.SObjectType.getDescribe().isUpdateable()) {
                    try{
                        update emp;
                    } catch (exception e){
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (iden != null && Identity_Information__c.SObjectType.getDescribe().isUpdateable()) {
                    try{
                        update iden;
                    } catch (exception e){
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (acc != null && About_Account__c.SObjectType.getDescribe().isUpdateable()) {
                    try{
                        update acc;
                    } catch (exception e){
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                
                appObjects.put(Index.APPLICATION_OBJECT, (Application__c)app);    
                appObjects.put(Index.APPLICATION2_OBJECT, (Application2__c)app2);    
                appObjects.put(Index.EMPLOYMENT_OBJECT, (Employment_Information__c)emp);    
                appObjects.put(Index.IDENTITY_OBJECT, (Identity_Information__c)iden);    
                appObjects.put(Index.ABOUT_ACCOUNT_OBJECT, (About_Account__c)acc); 
                appObjects.put(Index.APPLICATION_ACTIVITY_OBJECT, (Application_Activity__c)appact);    
            }
        } catch(Exception e) {
            Logger.addMessage('Exception while processing input data: '+ e + '; ' + e.getLineNumber(), system.now().format());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:' + e.getMessage()));      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Stack Trace:' + e.getStackTraceString()));      
        }
        
        system.debug('The app Object is '+ appObjects);
        return appObjects;
    }

    public static Map<String,String> getPageVars(Map<String,String> appData, String pageName, Set<String> fieldsToDisplay, Map<String,sObject> appObjects) {
        Application__c app = (Application__c)appObjects.get(Index.APPLICATION_OBJECT);
        Application2__c app2 = (Application2__c)appObjects.get(Index.APPLICATION2_OBJECT);
        Employment_Information__c emp = (Employment_Information__c)appObjects.get(Index.EMPLOYMENT_OBJECT);
        Identity_Information__c iden = (Identity_Information__c)appObjects.get(Index.IDENTITY_OBJECT);
        About_Account__c acc = (About_Account__c)appObjects.get(Index.ABOUT_ACCOUNT_OBJECT);
        Cross_Sell_Logic__c cross = (Cross_Sell_Logic__c)appObjects.get(Index.CROSS_SELL_LOGIC_OBJECT);
        Application_Configuration__c appconfig = (Application_Configuration__c)appObjects.get(Index.APPLICATION_CONFIGURATION_OBJECT);
        
        Customer__c customer = (Customer__c)appObjects.get(Index.CUSTOMER_OBJECT);

        if (pageName == Index.GET_STARTED_PAGE) {
        } else if (pageName == Index.CROSS_SELL_PAGE) {
        } else if (pageName == Index.EMPLOYMENT_PAGE) {
        } else if (pageName == Index.PERSONAL_INFO_PAGE) {
        } else if (pageName == Index.ACCOUNT_DETAILS_PAGE) {
            try {
                List<Customer_Account__c> cusAccount = new List<Customer_Account__c>();
                if (customer != null) {
                    cusAccount = [SELECT id,Account_Number__c,Balance__c,Product__c,Sub_Product__c FROM Customer_Account__c WHERE Customer__c = :customer.id];
                }
                Boolean submitted = false;
                if (app.Sub_Product__c.contains('Checking')) {
                    if (acc.Funding_Type_CHK__c != null && acc.Funding_Type_CHK__c != '') {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Savings')) {
                    if (acc.Funding_Type_SAV__c != null && acc.Funding_Type_SAV__c != '') {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Certificates')) {
                    if (acc.Funding_Type_CERT__c != null && acc.Funding_Type_CERT__c != '') {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Credit Cards')) {
                    if (acc.requested_credit_limit_ccards__c != null) {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Vehicle Loans')) {
                    if (acc.requested_loan_amount_vehicleloans__c != null) {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Personal Loans')) {
                    if (acc.requested_loan_amount_personalloans__c != null) {submitted = true;}   
                } else if (app.Sub_Product__c.contains('Investments')) {
                    if (acc.area_of_interest__c != null && acc.area_of_interest__c != '') {submitted = true;}   
                } else if (app.Product__c == 'Mortgage Loan' || app.Product__c == 'Home Equity') {
                    if (acc.what_type_of_loan_are_you_applying_for__c != null && acc.what_type_of_loan_are_you_applying_for__c != '') {submitted = true;}   
                }
                appData.put('PageVars.AccountDetailsPageSubmitted', (submitted)?'true':'false');
                appData.put('PageVars.MortgageInterestSection', (fieldsToDisplay.contains('Mortgage Interest Section'))?'true':'false');
                if (app.Type_of_Checking__c != null) { 
                    appData.put('PageVars.Type_of_Checking__c', app.Type_of_Checking__c);
                    List<String> fundingTypeCheckingListValues = new List<String>();
                    Set<String> fundingTypeChkSet = new Set<String>();
                    List<String> fundingFromInternalCheckingListValues = new List<String>();
                    List<string> listOfInternalAccountsCHK = new List<String>();
                    
                    try {
                        if (app.Person_Number__c != null) {                
                            for (Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsCHK.add(internalAcc);
                                    fundingTypeChkSet.add('Internal Accounts_Internal Accounts');
                                }    
                            }
                            for (String ia : listOfInternalAccountsCHK) {
                                fundingFromInternalCheckingListValues.add(ia);
                            }
                            for (String ftype : fundingTypeChkSet) {
                                fundingTypeCheckingListValues.add(ftype);
                            }
                            appData.put('SelectOptions.select_account_fi_chk__c',String.join(fundingFromInternalCheckingListValues,';'));  
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                    fundingTypeCheckingListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_chk__c', String.join(fundingTypeCheckingListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {                  
                            fundingTypeCheckingListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_chk__c', String.join(fundingTypeCheckingListValues, ';'));
                            fundingTypeCheckingListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_chk__c', String.join(fundingTypeCheckingListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (app.Type_of_Savings__c != null) { 
                    List<String>fundingTypeSavingsListValues = new List<String>();
                    Set<String> fundingTypeSavSet = new Set<String>();
                    List<String>fundingFromInternalSavingsListValues = new List<String>();
                    List<string> listOfInternalAccountsSAV = new List<String>();
                    try {
                        if (app.Person_Number__c != null) {                
                            for(Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsSAV.add(internalAcc);
                                    fundingTypeSavSet.add('Internal Accounts_Internal Accounts');
                                }    
                            }
                            for(String ia : listOfInternalAccountsSAV) {
                                //fundingFromInternalSavingsListValues.add(ia+'_'+ia);
                                fundingFromInternalSavingsListValues.add(ia);
                            }
                            for(String savFtype : fundingTypeSavSet) {
                                fundingTypeSavingsListValues.add(savFtype);
                            }
                            appData.put('SelectOptions.select_account_fi_sav__c',String.join(fundingFromInternalSavingsListValues,';'));  
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }

                    fundingTypeSavingsListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_sav__c', String.join(fundingTypeSavingsListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {
                            fundingTypeSavingsListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_sav__c', String.join(fundingTypeSavingsListValues, ';'));
                            fundingTypeSavingsListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_sav__c', String.join(fundingTypeSavingsListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (app.Type_of_Certificates__c != null) { 
                    List<String>fundingTypeCertificatesListValues = new List<String>();
                    Set<String> fundingTypeCertSet = new Set<String>();
                    List<String>fundingFromInternalCertificatesListValues = new List<String>();
                    List<string> listOfInternalAccountsCERT = new List<String>();
                    try {
                        if (app.Person_Number__c != null) {                
                            for (Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsCERT.add(internalAcc);
                                    fundingTypeCertSet.add('Internal Accounts_Internal Accounts');
                                }    
                            }
                            for (String ia : listOfInternalAccountsCERT) {
                                fundingFromInternalCertificatesListValues.add(ia);
                            }
                            for (String certFtype : fundingTypeCertSet) {
                                fundingTypeCertificatesListValues.add(certFtype);
                            }
                            appData.put('SelectOptions.select_account_fi_cert__c',String.join(fundingFromInternalCertificatesListValues,';'));  
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                    fundingTypeCertificatesListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_cert__c', String.join(fundingTypeCertificatesListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {       
                            fundingTypeCertificatesListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_cert__c', String.join(fundingTypeCertificatesListValues, ';'));
                            fundingTypeCertificatesListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_cert__c', String.join(fundingTypeCertificatesListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (app.Type_Of_Business_Checking__c != null) { 
                    appData.put('PageVars.Type_Of_Business_Checking__c', app.Type_Of_Business_Checking__c);
                    List<String>fundingTypeBusCheckingListValues = new List<String>();
                    Set<String> fundingTypeBusChkSet = new Set<String>();
                    List<String>fundingFromInternalBusCheckingListValues = new List<String>();
                    List<string> listOfInternalAccountsBusCHK = new List<String>();
                    try {
                        if (app.Person_Number__c != null) {
                            for (Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {                                 
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsBusCHK.add(internalAcc);
                                    fundingTypeBusChkSet.add('Internal Accounts_Internal Accounts');
                                }
                            }
                            for (String ia : listOfInternalAccountsBusCHK) {
                                fundingFromInternalBusCheckingListValues.add(ia);
                            }
                            for (String busChkFtype : fundingTypeBusChkSet) {
                                fundingTypeBusCheckingListValues.add(busChkFtype);
                            }
                            appData.put('SelectOptions.select_account_fi_bus_chk__c',String.join(fundingFromInternalBusCheckingListValues,';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                    fundingTypeBusCheckingListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_bus_chk__c', String.join(fundingTypeBusCheckingListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {
                            fundingTypeBusCheckingListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_bus_chk__c', String.join(fundingTypeBusCheckingListValues, ';'));
                            fundingTypeBusCheckingListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_bus_chk__c', String.join(fundingTypeBusCheckingListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (app.Type_Of_Business_Savings__c != null) { 
                    List<String>fundingTypeBusSavingsListValues = new List<String>();
                    Set<String> fundingTypeBusSavSet = new Set<String>();
                    List<String>fundingFromInternalBusSavingsListValues = new List<String>();
                    List<string> listOfInternalAccountsBusSAV = new List<String>();
                    try {
                        if (app.Person_Number__c != null) {
                            for(Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {                 
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsBusSAV.add(internalAcc);
                                    fundingTypeBusSavSet.add('Internal Accounts_Internal Accounts');
                                }
                            }
                            for(String ia : listOfInternalAccountsBusSAV) {
                                fundingFromInternalBusSavingsListValues.add(ia);
                            }
                            for(String busSavFtype : fundingTypeBusSavSet) {
                                fundingTypeBusSavingsListValues.add(busSavFtype);
                            }
                            appData.put('SelectOptions.select_account_fi_bus_sav__c',String.join(fundingFromInternalBusSavingsListValues,';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }

                    fundingTypeBusSavingsListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_bus_sav__c', String.join(fundingTypeBusSavingsListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {
                            fundingTypeBusSavingsListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_bus_sav__c', String.join(fundingTypeBusSavingsListValues, ';'));
                            fundingTypeBusSavingsListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_bus_sav__c', String.join(fundingTypeBusSavingsListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }
                if (app.Type_Of_Business_CDs__c != null) { 
                    List<String>fundingTypeBusCdsListValues = new List<String>();
                    Set<String> fundingTypeBusCertSet = new Set<String>();
                    List<String>fundingFromInternalBusCdsListValues = new List<String>();
                    List<string> listOfInternalAccountsBusCERT = new List<String>();
                    try {
                        if (app.Person_Number__c != null) {
                            for (Customer_Account__c ca : cusAccount) {
                                if (ca.Product__c.contains(Product_Names_Mapping__c.getValues('Checking').Product_Name__c) || ca.Product__c.contains(Product_Names_Mapping__c.getValues('Savings').Product_Name__c)) {
                                    Integer i = ca.Account_Number__c.length() - 4;
                                    String accNumberLastFour = ca.Account_Number__c.subString(i);
                                    String internalAccPH = ca.Product__c+'-'+accNumberLastFour+' Avail. Bal. $'+ca.Balance__c;
                                    String internalAcc = internalAccPH+'@'+ca.Account_Number__c+'_'+internalAccPH;
                                    listOfInternalAccountsBusCERT.add(internalAcc);
                                    fundingTypeBusCertSet.add('Internal Accounts_Internal Accounts');
                                }
                            }
                            for (String ia : listOfInternalAccountsBusCERT) {
                                fundingFromInternalBusCdsListValues.add(ia);
                            }
                            for (String busCertFtype : fundingTypeBusCertSet) {
                                fundingTypeBusCdsListValues.add(busCertFtype);
                            }
                            appData.put('SelectOptions.select_account_fi_bus_cds__c',String.join(fundingFromInternalBusCdsListValues,';')); 
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                    fundingTypeBusCdsListValues.add('Add External Accounts_Add External Accounts');
                    appData.put('SelectOptions.funding_type_bus_cds__c', String.join(fundingTypeBusCdsListValues, ';'));
                    try {
                        if (app.Current_Channel__c != 'Online') {
                            fundingTypeBusCdsListValues.add('Cash_Cash');
                            appData.put('SelectOptions.funding_type_bus_cds__c', String.join(fundingTypeBusCdsListValues, ';'));
                            fundingTypeBusCdsListValues.add('Check_Check');
                            appData.put('SelectOptions.funding_type_bus_cds__c', String.join(fundingTypeBusCdsListValues, ';'));
                        }
                    } catch (Exception e) {
                        Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                    }
                }                
            } catch (Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                appData.put('debug-server-errors', e.getMessage());
                appData.put('server-errors-stack-trace', e.getStackTraceString());
            }
        } else if (pageName == Index.REVIEW_SUBMIT_PAGE) {
            try {
                if (app.Years__c >= 2 || app.Years__c == null) {} else {
                    appData.put('DisplayFields.displayStreetAddress1PrevPrimary', 'true');
                }
                if (app.Years_J__c >= 2 || app.Years_J__c == null) {} else {
                    appData.put('DisplayFields.displayStreetAddress1Prevjoint1', 'true');
                }
                if (app.Years_J2__c >= 2 || app.Years_J2__c == null) {} else {
                    appData.put('DisplayFields.displayStreetAddress1Prevjoint2', 'true');
                }
                if (app.Years_J3__c >= 2 || app.Years_J3__c == null) {} else {
                    appData.put('DisplayFields.displayStreetAddress1Prevjoint3', 'true');
                }
                if (emp.Years_Emp__c >= 2 || emp.Years_Emp__c == null) {} else {
                    appData.put('DisplayFields.dispPrevEmplyerPrim', 'true');
                }
                if (emp.Years_EmpJ1__c >= 2 || emp.Years_EmpJ1__c == null) {} else {
                    appData.put('DisplayFields.dispPrevEmplyerJ1', 'true');
                }
                if (emp.Years_EmpJ2__c >= 2 || emp.Years_EmpJ2__c == null) {} else {
                    appData.put('DisplayFields.dispPrevEmplyerJ2', 'true');
                }
                if (emp.Years_EmpJ3__c >= 2 || emp.Years_EmpJ3__c == null) {} else {
                    appData.put('DisplayFields.dispPrevEmplyerJ3', 'true');
                }
                if (acc.Funding_Type_CHK__c == 'Add External Accounts') {
                    appData.put('DisplayFields.dispDollarChkExternal', 'true');
                } else {
                    appData.put('DisplayFields.dispDollarChkInternal', 'true');
                }
                if (acc.Funding_Type_SAV__c == 'Add External Accounts') {
                    appData.put('DisplayFields.dispDollarSavExternal', 'true');
                } else {
                    appData.put('DisplayFields.dispDollarSavInternal', 'true');
                }
                if (acc.Funding_Type_CERT__c == 'Add External Accounts') {
                    appData.put('DisplayFields.dispDollarCertExternal', 'true');
                } else {
                    appData.put('DisplayFields.dispDollarCertInternal', 'true');
                }
                if (acc.Property_Type__c == 'High-rise Condo ( 5 or more Stories)' || acc.Property_Type__c == 'Low-rise Condo (1-4 Stories)') {
                    appData.put('DisplayFields.dispHOA', 'true');
                }
                if (acc.Occupancy__c == 'Investment') {
                    appData.put('DisplayFields.dispEstGrossRentalIncome', 'true');
                }
                if (acc.HE_Property_Type__c == 'High-rise Condo ( 5 or more Stories)' || acc.Property_Type__c == 'Low-rise Condo (1-4 Stories)') {
                    appData.put('DisplayFields.dispHEHOA', 'true');
                }
                if (acc.Purpose_Of_Loan__c == 'Refinance Cashout' || acc.Purpose_Of_Loan__c == 'Refi Rate/Term') {
                    appData.put('DisplayFields.dispHLPurposeRefi', 'true');
                }
                if (acc.Purpose_Of_Loan__c == 'Purchase') {
                    appData.put('DisplayFields.dispHLPurposePurchase', 'true');
                }                
                if (acc.HE_Occupancy__c == 'Investment') {
                    appData.put('DisplayFields.dispHEEstGrossRentalIncome', 'true');
                }
                if (acc.Mortgage_Applied_For__c == 'Other') {
                    appData.put('DisplayFields.dispMortgageTypeOther', 'true');
                }
                if (acc.Purpose_Of_Loan__c == 'Other') {
                    appData.put('DisplayFields.dispOtherpurpose', 'true');
                }
                if (acc.Options__c != 'Unknown Address') {
                    appData.put('DisplayFields.dispProperty', 'true');
                }
                if (acc.Purpose_Ccards__c == 'Other') {
                    appData.put('DisplayFields.dispOtherPurposeCcards', 'true');
                }
                if (acc.Purpose_Ccards__c == 'Debt Consolidation') {
                    appData.put('DisplayFields.dispDebtConsolidationCcards', 'true');
                }
                if (acc.Purpose_PersonalLoans__c == 'Other Purpose') {
                    appData.put('DisplayFields.dispOtherPurposePersonalLoans', 'true');
                }
                if (acc.Purpose_PersonalLoans__c == 'Debt Consolidation') {
                    appData.put('DisplayFields.dispDebtConsolidationPersonalLoan', 'true');
                }
                if (acc.Purpose_VehicleLoan__c == 'Other Purpose') {
                    appData.put('DisplayFields.dispOtherPurposeVehicleLoans', 'true');
                }
                if (emp.Employment_Status__c == 'Full Time' || emp.Employment_Status__c == 'Contractor' || emp.Employment_Status__c == 'Self Employed') {
                    if (fieldsToDisplay.contains('Employer__c')) {
                        appData.put('DisplayFields.employerPrimary', 'true');
                    }
                    if (fieldsToDisplay.contains('Occupation__c')) {
                        appData.put('DisplayFields.occupationPrimary', 'true');
                    }
                }
                if (fieldsToDisplay.contains('Prior_Occupation__c') && (emp.Employment_Status__c == 'Retired' || emp.Employment_Status__c == 'Unemployed')) {
                    appData.put('DisplayFields.priorOccupationPrimary', 'true');
                }
                if (emp.Employment_Status_J1__c == 'Full Time' || emp.Employment_Status_J1__c == 'Contractor' || emp.Employment_Status_J1__c == 'Self Employed') {
                    appData.put('DisplayFields.dispEmployernOccupation1joint', 'true');
                }
                if (fieldsToDisplay.contains('Prior_Occupation_J__c') && (emp.Employment_Status_J1__c == 'Retired' || emp.Employment_Status_J1__c == 'Unemployed')) {
                    appData.put('DisplayFields.priorOccupationFirstjoint', 'true');
                }
                if (emp.Employment_Status_J2__c == 'Full Time' || emp.Employment_Status_J2__c == 'Contractor' || emp.Employment_Status_J2__c == 'Self Employed') {
                    appData.put('DisplayFields.dispEmployernOccupation2joint', 'true');
                }
                if (fieldsToDisplay.contains('Prior_Occupation_J2__c') && (emp.Employment_Status_J2__c == 'Retired' || emp.Employment_Status_J2__c == 'Unemployed')) {
                    appData.put('DisplayFields.priorOccupationSecondjoint', 'true');
                }
                if (emp.Employment_Status_J3__c == 'Full Time' || emp.Employment_Status_J3__c == 'Contractor' || emp.Employment_Status_J3__c == 'Self Employed') {
                    appData.put('DisplayFields.dispEmployernOccupation3joint', 'true');
                }
                if (fieldsToDisplay.contains('Prior_Occupation_J3__c') && (emp.Employment_Status_J3__c == 'Retired' || emp.Employment_Status_J3__c == 'Unemployed')) {
                    appData.put('DisplayFields.priorOccupationThirdjoint', 'true');
                }

                //Additional Methods
                if (fieldsToDisplay.contains('Country_of_Citizenship__c') && iden.Citizenship__c != 'US Citizen') {
                    appData.put('DisplayFields.countryOfCitizenshipPrimary', 'true');
                }
                if (fieldsToDisplay.contains('OIAU_Q1_J1__c') && app.First_Joint_Applicant__c == true) {
                    appData.put('DisplayFields.OIAU_J1', 'true');
                }
                if (acc.Purpose_Of_Loan__c == 'Refinance Cashout' || acc.Purpose_Of_Loan__c =='Refi Rate/Term'|| acc.Purpose_Of_Loan__c =='FHA Streamline Refi') {
                    appData.put('DisplayFields.RefinanceLoan', 'true');
                }
                if (fieldsToDisplay.contains('Mortgage_Applied_For__c') && app.First_Joint_Applicant__c == true) {
                    appData.put('DisplayFields.declarationFirstJoint', 'true');
                }
                if (fieldsToDisplay.contains('OIAU_Q1_J1__c') && app.First_Joint_Applicant__c == true) {
                    appData.put('DisplayFields.OIAU_J1', 'true');
                }
                if (fieldsToDisplay.contains('Country_of_Citizenship__c') && iden.Citizenship__c != 'US Citizen') {
                    appData.put('DisplayFields.countryOfCitizenshipPrimary', 'true');
                }
                if (iden.Citizenship_J1__c != 'US Citizen') {
                    appData.put('DisplayFields.countryOfCitizenshipFirstJoint', 'true');
                }
                if (iden.Citizenship_J2__c != 'US Citizen') {
                    appData.put('DisplayFields.countryOfCitizenshipSecondJoint', 'true');
                }
                if (iden.Citizenship_J3__c != 'US Citizen') {
                    appData.put('DisplayFields.countryOfCitizenshipThirdJoint', 'true');
                }
                if (emp.Other_Income_Picklist2__c != null && emp.Other_Income_Picklist2__c != '') {
                    appData.put('DisplayFields.dispOtherIncome2', 'true');
                }
                if (emp.Other_Income_Picklist3__c != null && emp.Other_Income_Picklist3__c != '') {
                    appData.put('DisplayFields.dispOtherIncome3', 'true');
                }
                if (emp.Other_Income_Picklist4__c != null && emp.Other_Income_Picklist4__c != '') {
                    appData.put('DisplayFields.dispOtherIncome4', 'true');
                }
                if (emp.Other_Income_Picklist5__c != null && emp.Other_Income_Picklist5__c != '') {
                    appData.put('DisplayFields.dispOtherIncome5', 'true');
                }
                if (emp.Other_Income_Picklist1_J1__c != null && emp.Other_Income_Picklist1_J1__c != '') {
                    appData.put('DisplayFields.otherIncome1Joint1', 'true');
                }
                if (emp.Other_Income_Picklist2_J1__c != null && emp.Other_Income_Picklist2_J1__c != '') {
                    appData.put('DisplayFields.dispOtherIncome2Joint1', 'true');
                }
                if (emp.Other_Income_Picklist3_J1__c != null && emp.Other_Income_Picklist3_J1__c != '') {
                    appData.put('DisplayFields.dispOtherIncome3Joint1', 'true');
                }
                if (emp.Other_Income_Picklist4_J1__c != null && emp.Other_Income_Picklist4_J1__c != '') {
                    appData.put('DisplayFields.dispOtherIncome4Joint1', 'true');
                }
                if (emp.Other_Income_Picklist5_J1__c != null && emp.Other_Income_Picklist5_J1__c != '') {
                    appData.put('DisplayFields.dispOtherIncome5Joint1', 'true');
                }
                if (emp.Other_Income_Picklist1_J2__c != null && emp.Other_Income_Picklist1_J2__c != '') {
                    appData.put('DisplayFields.otherIncome1Joint2', 'true');
                }
                if (emp.Other_Income_Picklist2_J2__c != null && emp.Other_Income_Picklist2_J2__c != '') {
                    appData.put('DisplayFields.dispOtherIncome2Joint2', 'true');
                }
                if (emp.Other_Income_Picklist3_J2__c != null && emp.Other_Income_Picklist3_J2__c != '') {
                    appData.put('DisplayFields.dispOtherIncome3Joint2', 'true');
                }
                if (emp.Other_Income_Picklist4_J2__c != null && emp.Other_Income_Picklist4_J2__c != '') {
                    appData.put('DisplayFields.dispOtherIncome4Joint2', 'true');
                }
                if (emp.Other_Income_Picklist5_J2__c != null && emp.Other_Income_Picklist5_J2__c != '') {
                    appData.put('DisplayFields.dispOtherIncome5Joint2', 'true');
                }
                if (emp.Other_Income_Picklist1_J3__c != null && emp.Other_Income_Picklist1_J3__c != '') {
                    appData.put('DisplayFields.otherIncome1Joint3', 'true');
                }
                if (emp.Other_Income_Picklist2_J3__c != null && emp.Other_Income_Picklist2_J3__c != '') {
                    appData.put('DisplayFields.dispOtherIncome2Joint3', 'true');
                }
                if (emp.Other_Income_Picklist3_J3__c != null && emp.Other_Income_Picklist3_J3__c != '') {
                    appData.put('DisplayFields.dispOtherIncome3Joint3', 'true');
                }
                if (emp.Other_Income_Picklist4_J3__c != null && emp.Other_Income_Picklist4_J3__c != '') {
                    appData.put('DisplayFields.dispOtherIncome4Joint3', 'true');
                }
                if (emp.Other_Income_Picklist5_J3__c != null && emp.Other_Income_Picklist5_J3__c != '') {
                    appData.put('DisplayFields.dispOtherIncome5Joint3', 'true');
                }

                // Stripping the entire Account number from the 'Select_account_fi_' fields for SMALL Business and diplaying using DisplayFields
                if(acc.select_account_fi_bus_chk__c != null){
                    String selectedBusChkAcc = acc.select_account_fi_bus_chk__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedbuschkacc', selectedBusChkAcc);
                }
                if(acc.select_account_fi_bus_sav__c != null){
                    String selectedBusSavAcc = acc.select_account_fi_bus_sav__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedbussavacc', selectedBusSavAcc);
                }
                if(acc.select_account_fi_bus_cds__c != null){
                    String selectedBusCertAcc = acc.select_account_fi_bus_cds__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedbuscertacc', selectedBusCertAcc);
                }
                // Stripping the entire Account number from the 'Select_account_fi_' fields and diplaying using DisplayFields
                if(acc.Select_Account_FI_CHK__c != null){
                    String selectedChkAcc = acc.Select_Account_FI_CHK__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedchkacc', selectedChkAcc);
                }
                if(acc.Select_Account_FI_SAV__c != null){
                    String selectedSavAcc = acc.Select_Account_FI_SAV__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedsavacc', selectedSavAcc);
                }
                if(acc.Select_Account_FI_CERT__c != null){
                    String selectedCertAcc = acc.Select_Account_FI_CERT__c.substringBefore('@');
                    appData.put('DisplayFields.dispselectedcertacc', selectedCertAcc);
                }
                
                List<Disclosure__c> dis1 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure1').Disclosure_Label__c];
                List<Attachment> att1 = new List<Attachment>();
                if (dis1.size() > 0) {
                    att1 = dis1[0].Attachments;
                }
                List<Disclosure__c> dis2 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure2').Disclosure_Label__c];
                List<Attachment> att2 = new List<Attachment>();
                if (dis2.size() > 0) {
                    att2 = dis2[0].Attachments;
                }
                List<Disclosure__c> dis3 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure3').Disclosure_Label__c];
                List<Attachment> att3 = new List<Attachment>();
                if (dis3.size() > 0) {
                    att3 = dis3[0].Attachments;
                }
                List<Disclosure__c> dis4 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure4').Disclosure_Label__c];
                List<Attachment> att4 = new List<Attachment>();
                if (dis4.size() > 0) {
                    att4 = dis4[0].Attachments;
                }
                List<Disclosure__c> dis5 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure5').Disclosure_Label__c];
                List<Attachment> att5 = new List<Attachment>();
                if (dis5.size() > 0) {
                    att5 = dis5[0].Attachments;
                }
                List<Disclosure__c> dis6 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure6').Disclosure_Label__c];
                List<Attachment> att6 = new List<Attachment>();
                if (dis6.size() > 0) {
                    att6 = dis6[0].Attachments;
                }
                List<Disclosure__c> dis7 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure7').Disclosure_Label__c];
                List<Attachment> att7 = new List<Attachment>();
                if (dis7.size() > 0) {
                    att7 = dis7[0].Attachments;
                }
                List<Disclosure__c> dis8 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure8').Disclosure_Label__c];
                List<Attachment> att8 = new List<Attachment>();
                if (dis8.size() > 0) {
                    att8 = dis8[0].Attachments;
                }
                List<Disclosure__c> dis9 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure9').Disclosure_Label__c];
                List<Attachment> att9 = new List<Attachment>();
                if (dis9.size() > 0) {
                    att9 = dis9[0].Attachments;
                }
                List<Disclosure__c> dis10 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure10').Disclosure_Label__c];
                List<Attachment> att10 = new List<Attachment>();
                if (dis10.size() > 0) {
                    att10 = dis10[0].Attachments;
                }
                List<Disclosure__c> dis11 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure11').Disclosure_Label__c];
                List<Attachment> att11 = new List<Attachment>();
                if (dis11.size() > 0) {
                    att11 = dis11[0].Attachments;
                }
                List<Disclosure__c> dis12 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure12').Disclosure_Label__c];
                List<Attachment> att12 = new List<Attachment>();
                if (dis12.size() > 0) {
                    att12 = dis12[0].Attachments;
                }
                List<Disclosure__c> dis13 = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues('Disclosure13').Disclosure_Label__c];
                List<Attachment> att13 = new List<Attachment>();
                if (dis13.size() > 0) {
                    att13 = dis13[0].Attachments;
                }               

                if (att1.size()>0) {
                    appData.put('PageVars.discUrl1', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att1.get(0).id);  
                }
                if (att2.size()>0) {
                    appData.put('PageVars.discUrl2', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att2.get(0).id);
                }
                if (att3.size()>0) {
                    appData.put('PageVars.discUrl3', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att3.get(0).id);
                }
                if (att4.size()>0) {
                    appData.put('PageVars.discUrl4', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att4.get(0).id);
                }
                if (att5.size()>0) {
                    appData.put('PageVars.discUrl5', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att5.get(0).id);    
                }
                if (att6.size()>0) {
                    appData.put('PageVars.discUrl6', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att6.get(0).id);    
                }
                if (att7.size()>0) {
                    appData.put('PageVars.discUrl7', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att7.get(0).id);    
                }
                if (att8.size()>0) {
                    appData.put('PageVars.discUrl8', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att8.get(0).id);    
                }
                if (att9.size()>0) {
                    appData.put('PageVars.discUrl9', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att9.get(0).id);    
                }
                if (att10.size()>0) {
                    appData.put('PageVars.discUrl10', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att10.get(0).id);    
                }
                if (att11.size()>0) {
                    appData.put('PageVars.discUrl11', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att11.get(0).id);    
                }
                if (att12.size()>0) {
                    appData.put('PageVars.discUrl12', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att12.get(0).id);    
                }
                if (att13.size()>0) {
                    appData.put('PageVars.discUrl13', URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+att13.get(0).id);    
                }
                               

            } catch (Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                appData.put('debug-server-errors', e.getMessage());
                appData.put('server-errors-stack-trace', e.getStackTraceString());
            }
        } else if (pageName == Index.CONFIRMATION_PAGE) {
            try {
                String ConfirmText = '';
                ConfirmText = Confirmation__c.getInstance().Sample_Text__c;
                
                appData.put('PageVars.ConfirmText', ConfirmText);
                if (app2.ErrorNum__c == '0' && (app.Product__c == 'Checking' || app.Product__c == 'Savings' || app.Product__c == 'Certificates' || app.Product__c == 'Vehicle Loans' || app.Product__c == 'Credit Cards' || app.Product__c == 'Personal Loans' )) {
                    appData.put('PageVars.ConditionsApply', Confirmation__c.getInstance().Conditions_apply__c);
                }
                if (app.Product__c == 'Mortgage Loan') {
                    appData.put('PageVars.displayRate', app2.PricingResult_Rate__c);
                }
                
            } catch (Exception e) {
                Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
                appData.put('debug-server-errors', e.getMessage());
                appData.put('server-errors-stack-trace', e.getStackTraceString());
            }
        } 

        return appData;
    }

} // end of class