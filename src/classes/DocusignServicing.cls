global with sharing class DocusignServicing {
	global String main(String ServiceId){
        
        String envelopeId;
        String accountId;
        String userId;
        String password;
        String integratorsKey;
        String webServiceUrl = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
        
        try{
           /* Logger.inputSource('Docusign class',appId);
            Set<String> fieldsToDisplay = new Set<String>(); // This string is used to contain the fields received from Utility class.
            Utility u= new Utility(); 
            RequiredFieldsUtility rfu= new RequiredFieldsUtility();
            fieldsToDisplay = u.fieldsToRender(appId);*/
            
            Service__c  service = [Select Field1__c,Field2__c, Field3__c, Field4__c, Amount__c, Account_Number__c, Member_Number__c, Merchant__c, Date_of_Debit__c, Docusign_EnvelopeID__c, Statement_Type__c, Other_Statement_Type__c from Service__c where id =: ServiceId];

            List<DocuSignAPI.Document> set_docs = new List<DocuSignAPI.Document>();
            
            Docusign_Config__c cred = Docusign_Config__c.getOrgDefaults();        
            if(cred!= NULL){
                accountId = cred.AccountID__c;
                userId = cred.Username__c;
                password = cred.Password__c;
                integratorsKey = cred.IntegratorKey__c ;
            }    
                    
            DocuSignAPI.APIServiceSoap dsApiSend = new DocuSignAPI.APIServiceSoap();
            dsApiSend.endpoint_x = webServiceUrl;

            //Set Authentication
            String auth = '<DocuSignCredentials><Username>'+ userId +'</Username><Password>' + password + '</Password><IntegratorKey>' + integratorsKey + '</IntegratorKey></DocuSignCredentials>';
            System.debug('Setting authentication to: ' + auth);
                
            dsApiSend.inputHttpHeaders_x = new Map<String, String>();
            dsApiSend.inputHttpHeaders_x.put('X-DocuSign-Authentication', auth);

            DocuSignAPI.Envelope envelope = new DocuSignAPI.Envelope();
            envelope.Subject = 'Please Sign this Disclosure';
            envelope.EmailBlurb = 'Dear ' + service.Field1__c + ', ' + 'This is my new eSignature service,'+ 'it allows me to get your signoff without having to fax, ' + 'scan, retype, refile and wait forever';
            envelope.AccountId  = accountId; 

            /*List<Disclosure_Names__c>  ddn = Disclosure_Names__c.getall().values();

            for(integer i=0; i < ddn.size(); i++){*/

                //if(fieldsToDisplay.contains(ddn[i].Name+'__c')){

                    List<Disclosure__c> disc = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :'PatelCo - DS'];
                    system.debug('Disclosure incoming'+disc);
                    List<Attachment> att = new List<Attachment>();
                    if (disc.size() > 0) {
                        att = disc[0].Attachments;
                    }
                    
                    if (att.size()>0) {
                        Attachment attach = [Select Name, body from Attachment where id = :att[0].id];
                        DocuSignAPI.Document DocNum = new DocuSignAPI.Document();
                        DocNum.ID = 1;
                        String pdfName = 'PatelCo';
                        Blob pdfBlob = attach.body; 
                        DocNum.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
                        DocNum.Name = 'PatelCo';
                        DocNum.FileExtension = 'pdf';
                        set_docs.add(DocNum);
                    }
               // }              
            //}        
            
            system.debug('The number of documents is: '+set_docs.size());
            envelope.Documents = new DocuSignAPI.ArrayOfDocument();
            envelope.Documents.Document = new DocuSignAPI.Document[set_docs.size()];
            for(integer i = 0;i<set_docs.size();i++){
              envelope.Documents.Document[i] = set_docs[i];
            }

                            
            DocuSignAPI.Recipient recipient1 = new DocuSignAPI.Recipient();
            recipient1.ID = 1;
            recipient1.Type_x = 'Signer';
            recipient1.RoutingOrder = 1;
            recipient1.Email = service.Field3__c;
            recipient1.UserName = service.Field1__c + ' ' + service.Field2__c; 
            
            recipient1.RequireIDLookup = false; 
                   
            envelope.Recipients = new DocuSignAPI.ArrayOfRecipient();
            envelope.Recipients.Recipient = new DocuSignAPI.Recipient[1];
            envelope.Recipients.Recipient[0] = recipient1;
            
            DocuSignAPI.Tab tab1 = new DocuSignAPI.Tab();
            tab1.Type_x = 'SignHere';
            tab1.RecipientID = 1;
            tab1.DocumentID = 1;
            tab1.PageNumber = 1;
            tab1.XPosition = 60;
            tab1.YPosition = 550;
            tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
            /*tab1.AnchorTabItem.AnchorTabString = 'Signature';*/
            tab1.AnchorTabItem.XOffset= 60;
            tab1.AnchorTabItem.YOffset= 590;


            DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
            tab2.Type_x = 'DateSigned';
            tab2.RecipientID = 1;
            tab2.DocumentID = 1;
            tab2.PageNumber = 1;
            tab2.XPosition = 300;
            tab2.YPosition = 590;
            tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
            /*tab2.AnchorTabItem.AnchorTabString = 'Date';*/
            tab2.AnchorTabItem.XOffset= 300;
            tab2.AnchorTabItem.YOffset= 590;
            
            DocuSignAPI.Tab tab3 = new DocuSignAPI.Tab();
            tab3.Type_x = 'FullName';
            tab3.RecipientID = 1;
            tab3.DocumentID = 1;
            tab3.PageNumber = 1;
            tab3.Value = service.Field1__c+' '+service.Field2__c;
            tab3.XPosition = 60;
            tab3.YPosition = 135;

            DocuSignAPI.Tab tab4 = new DocuSignAPI.Tab();
            tab4.Type_x = 'Custom';
            tab4.CustomTabType = 'Text';
            tab4.Name = 'Member Number';
            tab4.CustomTabLocked = true;
            tab4.RecipientID = 1;
            tab4.DocumentID = 1;
            tab4.PageNumber = 1;
            tab4.Value = service.Member_Number__c;
            tab4.XPosition = 300;
            tab4.YPosition = 135;

            DocuSignAPI.Tab tab5 = new DocuSignAPI.Tab();
            tab5.Type_x = 'Custom';
            tab5.CustomTabType = 'Text';
            tab5.Name = 'Date of Debit';
            tab5.CustomTabLocked = true;
            tab5.RecipientID = 1;
            tab5.DocumentID = 1;
            tab5.PageNumber = 1;
            tab5.Value = service.Date_of_Debit__c;
            tab5.XPosition = 455;
            tab5.YPosition = 135;

            DocuSignAPI.Tab tab6 = new DocuSignAPI.Tab();
            tab6.Type_x = 'Custom';
            tab6.CustomTabType = 'Text';
            tab6.Name = 'Amount';
            tab6.CustomTabLocked = true;
            tab6.RecipientID = 1;
            tab6.DocumentID = 1;
            tab6.PageNumber = 1;
            tab6.Value = string.valueOf(service.Amount__c);
            tab6.XPosition = 60;
            tab6.YPosition = 160;

            DocuSignAPI.Tab tab7 = new DocuSignAPI.Tab();
            tab7.Type_x = 'Custom';
            tab7.CustomTabType = 'Text';
            tab7.Name = 'Merchant';
            tab7.CustomTabLocked = true;
            tab7.RecipientID = 1;
            tab7.DocumentID = 1;
            tab7.PageNumber = 1;
            tab7.Value = service.Merchant__c;
            tab7.XPosition = 280;
            tab7.YPosition = 160;

            DocuSignAPI.Tab tab8 = new DocuSignAPI.Tab();
            tab8.Type_x = 'Custom';
            tab8.CustomTabType = 'Text';
            tab8.Name = 'Phone Number';
            tab8.CustomTabLocked = true;
            tab8.RecipientID = 1;
            tab8.DocumentID = 1;
            tab8.PageNumber = 1;
            tab8.Value = service.Field4__c;
            tab8.XPosition = 450;
            tab8.YPosition = 590;

            DocuSignAPI.Tab tab9 = new DocuSignAPI.Tab();
            tab9.Type_x = 'Custom';
            tab9.CustomTabType = 'Text';
            tab9.Name = 'Account #';
            tab9.CustomTabLocked = true;
            tab9.RecipientID = 1;
            tab9.DocumentID = 1;
            tab9.PageNumber = 1;
            tab9.Value = service.Account_Number__c;
            tab9.XPosition = 83;
            tab9.YPosition = 727;

            DocuSignAPI.Tab tab10 = new DocuSignAPI.Tab();
            tab10.Type_x = 'Custom';
            tab10.CustomTabType = 'Checkbox';
            tab10.CustomTabLocked = true;
            tab10.RecipientID = 1;
            tab10.DocumentID = 1;
            tab10.PageNumber = 1;
            /*I did not authorize the party listed above to debit my account.
            I revoked the authorization I had given to the party to debit my account before the debit was initiated.
            My account was debited before the date I authorized.
            My account was debited for an amount different than I authorized.
            My check was improperly processed electronically.
            Other*/
            if(service.Statement_Type__c == 'I did not authorize the party listed above to debit my account.'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 268;
            }else if(service.Statement_Type__c == 'I revoked the authorization I had given to the party to debit my account before the debit was initiated.'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 290;
            }else if(service.Statement_Type__c == 'My account was debited before the date I authorized.'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 312;
            }else if(service.Statement_Type__c == 'My account was debited for an amount different than I authorized.'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 334;
            }else if(service.Statement_Type__c == 'My check was improperly processed electronically.'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 356;
            }else if(service.Statement_Type__c == 'Other'){
                tab10.Value = 'x';
                tab10.XPosition = 31;
                tab10.YPosition = 378;
            }

            DocuSignAPI.Tab tab11 = new DocuSignAPI.Tab();
            tab11.Type_x = 'Custom';
            tab11.CustomTabType = 'Text';
            tab11.Name = 'Other Info';
            tab11.CustomTabLocked = true;
            tab11.RecipientID = 1;
            tab11.DocumentID = 1;
            tab11.PageNumber = 1;
            tab11.Value = service.Other_Statement_Type__c;
            tab11.XPosition = 150;
            tab11.YPosition = 375;

            envelope.Tabs = new DocuSignAPI.ArrayOfTab();
            envelope.Tabs.Tab = new DocuSignAPI.Tab[11];
            envelope.Tabs.Tab[0] = tab1;        
            envelope.Tabs.Tab[1] = tab2;
            envelope.Tabs.Tab[2] = tab3; 
            envelope.Tabs.Tab[3] = tab4;
            envelope.Tabs.Tab[4] = tab5;
            envelope.Tabs.Tab[5] = tab6;
            envelope.Tabs.Tab[6] = tab7;
            envelope.Tabs.Tab[7] = tab8;
            envelope.Tabs.Tab[8] = tab9;
            envelope.Tabs.Tab[9] = tab10;
            envelope.Tabs.Tab[10] = tab11;
            
            
            
            System.debug('Calling the API');
            String mssg;
            try {
                if(!Test.isRunningTest()){
                    //Logger.addMessage('Making API call',system.now().format());
                    DocuSignAPI.EnvelopeStatus es = dsApiSend.CreateAndSendEnvelope(envelope);
                    service.Docusign_EnvelopeID__c  = es.EnvelopeID;
                }
                update service;
                mssg = 'Success';
            } catch ( CalloutException e) {
                System.debug('Exception - ' + e.getMessage());
                mssg = 'Failed';
                //Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            }
            //Logger.writeAllLogs();
            return mssg;
        }
        Catch(exception e){
            //Logger.addMessage('Exception: '+ e + '; ' + e.getLineNumber(), system.now().format());
            //Logger.writeAllLogs();
            return 'Failed';
        }
     }
}