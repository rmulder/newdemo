public with sharing class MergePDF {
	public MergePDF() {
		
	}
	public static void combinePDF(){
		List<Attachment> attachments = new List<Attachment>();
		List<Disclosure__c> disclosure = [SELECT Id,Name FROM Disclosure__c];
		List<StaticResource> dis1 = [SELECT Body from StaticResource where Name = 'Dummy_Disc1'];
		List<StaticResource> dis2 = [SELECT Body from StaticResource where Name = 'Dummy_Disc2'];
		if(disclosure.size() > 0){
		    for(Disclosure__c disc : disclosure){
		        if(disc.name == 'Dummy'){
		            //String body = 'This is a PlaceHolder for the Disclosure';
		            //PageReference p = page.DisclosurePlaceholder;
		            Attachment attach = new Attachment();
		            attach.ParentId = disc.Id;  
		            attach.Name = disc.Name+'.pdf';  
		            //attach.Body = Blob.toPdf(body);
		            //attach.Body = p.getContent();
		            attach.ContentType = 'application/pdf';
		            Blob pdfBody = null;
		            String finalBody = '';
		            Integer n = 0;
		            for(StaticResource sr : [SELECT Body from StaticResource where Name LIKE 'Dummy%']){
		                n = n+1;
		                String doc_header = '\n\n--BOUNDARY\n' + 'Content-Type: application/pdf\n' + 'Content-Disposition: file; filename=\'' + String.valueOf(n) + '\'; documentid='+ String.valueOf(n) + '\n' + '\n';
		                
		                // no trailing padding on header by adding ' ' before the last "\n\n" characters
		                String doc_headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(doc_header+'\n\n'));
		                
		                //this ensures no trailing "=" padding
		                while (doc_headerEncoded.endsWith('=')) {
		                    doc_header+=' ';
		                    system.debug('The header if ends with = : ' +doc_header);
		                    doc_headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(doc_header+'\n\n'));
		                    system.debug('The header encoded if ends with = ; ' +doc_headerEncoded);
		                }

		                String boundary = '__boundary__xxx';
		                String footer = '\n--'+boundary+'--';
		                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		                while(footerEncoded.endsWith('='))
		                {
		                 footer+=' ';
		                 footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer+'\n\n'));
		                }

		                String encoded_body = EncodingUtil.base64Encode(sr.Body);
		                String last4Bytes = encoded_body.subString(encoded_body.length()-4,encoded_body.length());
		                if(last4Bytes.endsWith('==')){
		                	system.debug('The Last four has ==');
		                    last4Bytes = last4Bytes.subString(0,2)+'oK';
		                    finalBody = finalBody + (doc_headerEncoded + encoded_body.subString(0,encoded_body.length()-4) + last4Bytes + footerEncoded);
		                    //finalBody = finalBody + encoded_body.subString(0,encoded_body.length()-4) + last4Bytes;    
		                } else if(last4Bytes.endsWith('=')){
		                    last4Bytes = last4Bytes.subString(0,3)+'K';
		                    system.debug('The Last four has =');
		                    finalBody = finalBody + (doc_headerEncoded + encoded_body.subString(0,encoded_body.length()-4) + last4Bytes + footerEncoded);
		                    //finalBody = finalBody + encoded_body.subString(0,encoded_body.length()-4) + last4Bytes;
		                    system.debug('The final body of the disclosure '+n+'is #### '+encoded_body.subString(0,encoded_body.length()-4) + last4Bytes);
		                    if(n==2){
		                        system.debug('The final body is #### '+finalBody);
		                    }
		                    
		                } else {
		                    finalBody = finalBody + (doc_headerEncoded + encoded_body + footerEncoded);
		                    //finalBody = finalBody + encoded_body;
		                }
		            }
		            
		            //String S1 = EncodingUtil.base64Encode(dis1[0].Body);
		            //String S2 = EncodingUtil.base64Encode(dis2[0].Body);
					//String sf = att1.body.toString() + att2.body.toString();         
		            //String S = S1+S2;
		            
		            system.debug('Before the Body the final body is #### '+finalBody);
		            Blob b = EncodingUtil.base64Decode(finalBody);
		            //Blob b1 = EncodingUtil.base64Decode(S1);
		            //Blob b2 = EncodingUtil.base64Decode(S2);
		            //Blob bf = Blob.toPdf(sf);
		            attach.Body = b;
		            attachments.add(attach);
		        }
		    }
		    insert attachments;
		}
	}

}