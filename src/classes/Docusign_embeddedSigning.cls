global class Docusign_embeddedSigning implements SignInterface{
    
    global String main(String appId) {
        
        Logger.inputSource('Docusign class',appId);
        Set<String> fieldsToDisplay = new Set<String>(); // This string is used to contain the fields received from Utility class.
        Utility u = new Utility(); 
        RequiredFieldsUtility rfu = new RequiredFieldsUtility();
        fieldsToDisplay = u.fieldsToRender(appId);

        String username = '';
        String password = '';
        String integratorKey = '';
                    
        Application__c app = [Select First_Name__c,Last_Name__c, Email_Address__c from Application__c where id = :appId];
        Docusign_Config__c cred = Docusign_Config__c.getOrgDefaults();        
        
        if (cred != NULL) {
            username = cred.Username__c;
            password = cred.Password__c;
            integratorKey = cred.IntegratorKey__c ;
        } 
        String recipientName = app.First_Name__c + ' ' + app.Last_Name__c;
        String recipientEmail = app.Email_Address__c;
        List<Disclosure_Names__c> ddn = [Select Name, Disclosure_Label__c from Disclosure_Names__c];

        // construct the DocuSign authentication header
        String authenticationHeader = 
            '<DocuSignCredentials>' + 
            '<Username>' + username + '</Username>' +
            '<Password>' + password + '</Password>' + 
            '<IntegratorKey>' + integratorKey + '</IntegratorKey>' + 
            '</DocuSignCredentials>';

        // additional variable declarations
        String baseURL = '';     // we will retrieve this through the Login API call
        String accountId = '';   // we will retrieve this through the Login API call
        String url = '';     // end-point for each api call
        String body = '';    // request body
        String response = '';    // response body
        integer status;  // response status
        HttpResponse res = null;
        String resBody;  // connection object used for each request

        //============================================================================
        // STEP 1 - Make the Login API call to retrieve your baseUrl and accountId
        //============================================================================

        url = 'https://demo.docusign.net/restapi/v2/login_information';
        body = '';  // no request body for the login call
        res = InitializeRequest(url, 'GET', body, authenticationHeader);
        status = res.getStatusCode();
        resBody = res.getBody();
        if (status != 200) { // 200 = OK
            return 'Failure at 200';
        }

        // obtain baseUrl and accountId values from response body
        baseURL = parseXMLBody(resBody, 'baseUrl');
        accountId = parseXMLBody(resBody, 'accountId');

        //============================================================================
        // STEP 2 - Signature Request from Document API Call
        //============================================================================

        url = baseURL + '/envelopes';   // append '/envelopes' to baseUrl for signature request call
        String docArray = '';
        String bodyEncoded = '';
        Integer n = 0; //number of documents

        for (integer i=0; i < ddn.size(); i++) {
            String DiscName_api = ddn[i].Name+'__c';
          if (fieldsToDisplay.contains(DiscName_api)) {
              List<Disclosure__c> disc = [SELECT Id,name, (select id FROM Attachments) FROM Disclosure__c WHERE Name = :(Disclosure_Names__c.getValues(ddn[i].Name).Disclosure_Label__c + ' - DS')];
              List<Attachment> att = new List<Attachment>();
              if (disc.size() > 0) {
                  att = disc[0].Attachments;
              }
            Blob pdfBlob = null;
            if (att.size()>0) {
       
              n = n + 1;
              Attachment attach = [Select Name, body from Attachment where id = :att[0].id];
              pdfBlob  = attach.body; 
              String pdfBytes = EncodingUtil.base64Encode(pdfBlob);
                  docArray = docArray + '<document>' + '<documentId>' + String.valueOf(n) + '</documentId>' + '<name>' + disc[0].Name + '</name>' + '</document>';
                  String doc_header = '\n\n--BOUNDARY\n' + 
                        'Content-Type: application/pdf\n' + 
                        'Content-Disposition: file; filename=\'' + disc[0].Name + '\'; documentid='+ String.valueOf(n) + '\n' + 
                        '\n';

                  // no trailing padding on header by adding ' ' before the last "\n\n" characters
                  String doc_headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(doc_header+'\n\n'));

                  //this ensures no trailing "=" padding
                  while (doc_headerEncoded.endsWith('=')) {
                        doc_header+=' ';
                        system.debug('The header if ends with = : ' +doc_header);
                        doc_headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(doc_header+'\n\n'));
                        system.debug('The header encoded if ends with = ; ' +doc_headerEncoded);
                   }

                  //base64 encoded body
                  String doc_bodyEncoded = EncodingUtil.base64Encode(pdfBlob);
                  String current_doc_bodyEncoded = doc_bodyEncoded;

                  //last encoded body bytes
                  String doc_last4Bytes = current_doc_bodyEncoded.substring(current_doc_bodyEncoded.length()-4,current_doc_bodyEncoded.length());
                  //if the last 4 bytes encoded base64 ends with the padding character (= or ==) then re-encode those bytes
                  //to ensure the padding is added only at the end of the body
                  if (doc_last4Bytes.endsWith('==')) {
                      // The '==' sequence indicates that the last group contained only one 8 bit byte
              // 8 digit binary representation of CR is 00001101
              // 8 digit binary representation of LF is 00001010
              // Stitch them together and then from the right split them into 6 bit chunks
              // 0000110100001010 becomes 0000 110100 001010
              // Note the first 4 bits 0000 are identical to the padding used to encode the
              // second original 6 bit chunk, this is handy it means we can hard code the response in
              // The decimal values of 110100 001010 are 52 10
              // The base64 mapping values of 52 10 are 0 K
              // See http://en.wikipedia.org/wiki/Base64 for base64 mapping table
              // Therefore, we replace == with 0K
              // Note: if using \n\n instead of \r\n replace == with 'oK'
                      doc_last4Bytes = doc_last4Bytes.substring(0, 2) + 'oK';
                      bodyEncoded = bodyEncoded + (doc_headerEncoded+current_doc_bodyEncoded.substring(0,current_doc_bodyEncoded.length()-4)+doc_last4bytes);
                  } else if(doc_last4Bytes.endsWith('=')) {
                      // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
                // We replace final 8 bit byte with a CR e.g. \r
                // 8 digit binary representation of CR is 00001101
                // Ignore the first 2 bits of 00 001101 they have already been used up as padding
                // for the existing data.
                // The Decimal value of 001101 is 13
                // The base64 value of 13 is N
                // Therefore, we replace = with N
                // Note: if using \n instead of \r replace = with 'K'
                      doc_last4Bytes = doc_last4Bytes.substring(0, 3) + 'K';
                      bodyEncoded = bodyEncoded + (doc_headerEncoded+current_doc_bodyEncoded.substring(0,current_doc_bodyEncoded.length()-4)+doc_last4bytes);
                  } else {
                      bodyEncoded = bodyEncoded + (doc_headerEncoded+doc_bodyEncoded);
                  }
                  system.debug('count is: '+ n);
                }
            }   
        }

        body = '<envelopeDefinition xmlns=\'https://www.docusign.com/restapi\'>' +
        '<status>sent</status>'+
        '<accountId>' + accountId + '</accountId>' +
        '<emailSubject>Please sign the Disclosures below</emailSubject>' +
        '<documents>' + docArray + '</documents>' +
                //add recipient(s)
                '<recipients>' +
                    '<signers>' +
                        '<signer>' +
                            '<recipientId>1</recipientId>' +
                            '<name>' + recipientName + '</name>' +
                            '<email>' + recipientEmail + '</email>' +   
                            '<clientUserId>1001</clientUserId>' +
                            '<tabs>' +
                                '<signHereTabs>' +
                                 '<signHere>' +
                                     '<anchorString>' + 'By:' + '</anchorString>'+
                                         '<anchorXOffset>' + '100' + '</anchorXOffset>'+
                                         '<anchorIgnoreIfNotPresent>' + 'false' + '</anchorIgnoreIfNotPresent>'+
                                         '<anchorUnits>Pixels</anchorUnits>'+
                                         '<tabLabel>SignHere</tabLabel>' + 
                 '<name>SignHere</name>' +
                                       
                                        '</signHere>' +
                                        '</signHereTabs>' +
                                        '<dateSignedTabs>' +
                                        '<dateSigned>' +
                                     '<anchorString>' + 'Date Signed:' + '</anchorString>'+
                                         '<anchorXOffset>' + '160' + '</anchorXOffset>'+
                                         '<anchorYOffset>' + '-10' + '</anchorYOffset>'+
                                         '<anchorIgnoreIfNotPresent>' + 'false' + '</anchorIgnoreIfNotPresent>'+
                                         '<anchorUnits>Pixels</anchorUnits>'+
                                         '<tabLabel>DateSigned</tabLabel>' + 
                 '<name>DateSigned</name>' +
                                       
                                        '</dateSigned>' +
                                        '</dateSignedTabs>' +
                            '</tabs>' +
                        '</signer>' +
                    '</signers>' +
                '</recipients>'+ 
        '</envelopeDefinition>';

        // start constructing the multipart/form-data request...
        String xmlBody = '\n\n--BOUNDARY\n' + 
        'Content-Type: application/xml\n' + 
        'Content-Disposition: form-data\n' + 
        '\n' + body;
        String footer = '\n' + '--BOUNDARY--\n\n';
        
        Blob bodyBlob;

        // no trailing padding on header by adding ' ' before the last "\n\n" characters
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(xmlBody + '\n\n'));
        
        //this ensures no trailing "=" padding
        while (headerEncoded.endsWith('=')) {
          xmlBody += ' ';
          headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(xmlBody + '\n\n'));
        }
     
        // base64 encoded footer
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        
        // Building BodyBlob to send the Http request
        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        
        if (bodyBlob.size()>3000000) {   
            system.debug('File size limit is 3 MBytes');
        }
        system.debug('content-length'+bodyBlob.size());

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('X-DocuSign-Authentication', authenticationHeader);
        req.setHeader('Content-Type', 'multipart/form-data; boundary=BOUNDARY');
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setBodyAsBlob(bodyBlob);
        req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
        res = http.send(req);
        status = res.getStatusCode();
        resBody = res.getBody();
        if (status != 201)  {// 201 = Created
          return 'Failure Connection';
        }

        // obtain envelope uri from response body 
        String uri = '';
        JSONParser parser = JSON.createParser(resBody);
      while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'uri')) {
          // Get the value.
          parser.nextToken();
          uri = parser.getText();
          break;                
          }
      }
        System.debug('uri is: '+uri);
        System.debug('token is '+uri.replace('/envelopes/', ''));

        
        //============================================================================
        // STEP 3 - Get the Embedded Signing View
        //============================================================================
        String destination = 'https://www.docusign.com';
        url = baseURL + uri + '/views/recipient';   // append envelope uri + 'views/recipient' to url 
        body = '<recipientViewRequest xmlns=\'https://www.docusign.com/restapi\'>'  +
        '<authenticationMethod>email</authenticationMethod>' + 
        '<email>' + recipientEmail + '</email>' + 
        '<returnUrl>'+ destination+'</returnUrl>' + 
        '<userName>' + recipientName + '</userName>' + 
        '<clientUserId>1001</clientUserId>' + 
        '</recipientViewRequest>';

        res = InitializeRequest(url, 'POST', body, authenticationHeader);
        status = res.getStatusCode();
        if (status != 201)  {// 201 = Created
            return 'Failure at 201';
        }
        resBody = res.getBody();
        String urlToken = parseXMLBody(resBody, 'url'); 
        system.debug('URL TOKEN' +urlToken);
        app.Docusign_EnvelopeID__c = uri.replace('/envelopes/','');
        update app;
        return urlToken; 
    } //end main()

    // --- HELPER FUNCTIONS ---
    global static HttpResponse InitializeRequest(String url, String method, String body, String httpAuthHeader) {
    HttpResponse res = null;
    try {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setEndpoint(url);
      req.setHeader('X-DocuSign-Authentication', httpAuthHeader);
      req.setHeader('Content-Type', 'application/xml');
      req.setHeader('Accept', 'application/xml');
      req.setMethod(method);

      if (method == 'POST') {
        req.setHeader('Content-Length', String.valueOf(body.length()));
        req.setbody(body);
      }
      res = http.send(req);
      system.debug('the response is:'+res);
      system.debug('the body of the response is:'+res.getBody());
    }
    catch (Exception e) {
      system.debug(e); // simple exception handling, please review it
    }

    return res;
    }

    global static String parseXMLBody(String body, String searchToken) {
    system.debug('Body : ' +body+ 'Token : ' +searchToken);
    String value = '';
    if (body!= '' && body!= NULL) {
      Dom.Document doc1 = new Dom.Document();
      doc1.load(body);
      Dom.XMLNode xroot1 = doc1.getrootelement();
      Dom.XMLNode[] xrec1 = xroot1.getchildelements(); //Get all Record Elements            
      for (Dom.XMLNode firstInnerChild : xrec1) { //Loop Through Records
        if (firstInnerChild.getname() == searchToken) {
          value = firstInnerChild.gettext();
          break;
        } else {
          Dom.XMLNode[] xrec2 = NULL;
          xrec2 = firstInnerChild.getchildelements();
          if (xrec2 != NULL) {
            for (Dom.XMLNode secondInnerChild : xrec2) {
              if (secondInnerChild.getname() == 'loginAccount') {
                for (Dom.XMLNode thirdInnerChild : secondInnerChild.getchildren()) {
                  if (thirdInnerChild.getname() == searchToken) {
                    system.debug('values is: '+ thirdInnerChild.gettext());
                    value = thirdInnerChild.gettext();
                  }
                  if (value != '') {
                    break;
                  }
                }
              }
              if (value != '') {
                break;
              }
            }
          }
        }
        if (value != '') {
          break;
        }
      }
    }

    return value;
  }
} // end class