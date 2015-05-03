global with sharing class DocuSignForService implements SignInterface{
            
    global String main(String serviceId){
        
        String envelopeId;
        String accountId;
        String userId;
        String password;
        String integratorsKey;
        String webServiceUrl = 'https://demo.docusign.net/api/3.0/dsapi.asmx';
        
        try{
            //Logger.inputSource('Docusign class',serviceId);
            Service__c service = [SELECT Id,One_N_Done__c,Service_Request__c,Current_Step__c,Field1__c,Field2__c,Field3__c,Field4__c,Docusign_EnvelopeID__c,Current_Channel__c from Service__c WHERE Id = :serviceId];

            Set<String> fieldsToDisplay = new Set<String>(); // This string is used to contain the fields received from Utility class.
            ServiceUtility u= new ServiceUtility(); 
            RequiredFieldsUtility rfu= new RequiredFieldsUtility();
            fieldsToDisplay = u.retfieldstoExternalCall(service.Service_Request__c,service.Current_Step__c,true);
            
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

            List<Disclosure_Names__c>  ddn = Disclosure_Names__c.getall().values();

            for(integer i=0; i < ddn.size(); i++){

                if(fieldsToDisplay.contains(ddn[i].Name+'__c')){
                	List<Service_Disclosure__C> disc = new List<Service_Disclosure__C>();
                	if(service.Current_Channel__c == 'Online'){
                		disc = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__C WHERE RecordType.name = 'Online-DocuSign' AND Name = :(Disclosure_Names__c.getValues(ddn[i].Name).Disclosure_Label__c + ' - DS')];
                	} else if(service.Current_Channel__c == 'Branch'){
                		disc = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__C WHERE RecordType.name = 'Branch-DocuSign' AND Name = :(Disclosure_Names__c.getValues(ddn[i].Name).Disclosure_Label__c + ' - DS')];
                	} else {
                		disc = [SELECT Id,name, (select id FROM Attachments) FROM Service_Disclosure__C WHERE RecordType.name = 'Call-Center-DocuSign' AND Name = :(Disclosure_Names__c.getValues(ddn[i].Name).Disclosure_Label__c + ' - DS')];
                	} 
                    List<Attachment> att = new List<Attachment>();
                    if (disc.size() > 0) {
                        att = disc[0].Attachments;
                    }
                    
                    if (att.size()>0) {
                        Attachment attach = [Select Name, body from Attachment where id = :att[0].id];
                        DocuSignAPI.Document DocNum = new DocuSignAPI.Document();
                        DocNum.ID = i+1;
                        String pdfName = ddn[i].Disclosure_Label__c;
                        Blob pdfBlob = attach.body; 
                        DocNum.pdfBytes = EncodingUtil.base64Encode(pdfBlob);
                        DocNum.Name = Disclosure_Names__c.getValues(ddn[i].Name).Disclosure_Label__c;
                        DocNum.FileExtension = 'pdf';
                        set_docs.add(DocNum);
                    }
                }              
            }        
            
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
            tab1.AnchorTabItem = new DocuSignAPI.AnchorTab();
            tab1.AnchorTabItem.AnchorTabString = 'By:';
            tab1.AnchorTabItem.XOffset=40;
            
            DocuSignAPI.Tab tab2 = new DocuSignAPI.Tab();
            tab2.Type_x = 'DateSigned';
            tab2.RecipientID = 1;
            tab2.DocumentID = 1;
            tab2.AnchorTabItem = new DocuSignAPI.AnchorTab();
            tab2.AnchorTabItem.AnchorTabString = 'Date Signed:';
            tab2.AnchorTabItem.XOffset=160;
            tab2.AnchorTabItem.YOffset= -10;
            
            envelope.Tabs = new DocuSignAPI.ArrayOfTab();
            envelope.Tabs.Tab = new DocuSignAPI.Tab[2];
            envelope.Tabs.Tab[0] = tab1;        
            envelope.Tabs.Tab[1] = tab2;        
            
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