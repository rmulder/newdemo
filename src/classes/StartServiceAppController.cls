public with sharing class StartServiceAppController {

public String customerID{get; set;}
public String caseId{get; set;}
public String spa{get; set;}
public Customer__c customer{get; set;}
public User loggedInUser{get; set;}

    public StartServiceAppController(ApexPages.StandardController controller) {
    	customerID = ApexPages.currentPage().getParameters().get('id');
        caseId = ApexPages.currentPage().getParameters().get('caseID');
        spa = ApexPages.currentPage().getParameters().get('spa');
    	customer = [SELECT id,First_Name__c,Middle_Name__c,Last_Name__c,Phone_Number__c,Cell_Phone_Number__c,Email_Address__c,Street_Address_1__c,Street_Address_2__c,City__c,State__c,Zip_Code__c,Person_Identifier__c,SSN__c,Date_Of_Birth__c,Company__c FROM Customer__c WHERE id = :customerID];
    	loggedInUser = [select id,Channel__c,Name,Email,Location__c,Profile.Name from User where Id=:UserInfo.getUserId()];
    }

    public PageReference createServiceApp(){

    	PageReference p = null;
    	String servID = null;
    	
    	if(customerID != null){
    		// Creating XML of data from User fields to post it to ProductPage Url
    		Xmlstreamwriter xmlW = new Xmlstreamwriter();
    		xmlW.writeStartDocument('utf-8','1.0');
    		xmlW.writeStartElement(null,'SERVICE', null);
    		xmlW.writeAttribute(null,null,'version','1.0');

    		// Prefilling the Customer information by passing the following attributes through the XML.
    		if(customer.First_Name__c!=null){
    		    xmlW.writeStartElement(null,'firstName',null);
    		        xmlW.writeAttribute(null,null,'id','1');
    		        xmlW.writeCharacters(customer.First_Name__c);
    		    xmlW.writeEndElement();
    		}
    		if(customer.Last_Name__c!=null){
    		    xmlW.writeStartElement(null,'lastName',null);
    		        xmlW.writeAttribute(null,null,'id','2');
    		        xmlW.writeCharacters(customer.Last_Name__c);
    		    xmlW.writeEndElement();
    		}
    		if(customer.Email_Address__c!=null){
    		    xmlW.writeStartElement(null,'emailAddress',null);
    		        xmlW.writeAttribute(null,null,'id','3');
    		        xmlW.writeCharacters(customer.Email_Address__c);
    		    xmlW.writeEndElement(); 
    		}
    		if(customer.Phone_Number__c!=null){
    		    xmlW.writeStartElement(null,'phoneNumber',null);
    		        xmlW.writeAttribute(null,null,'id','4');
    		        xmlW.writeCharacters(customer.Phone_Number__c);
    		    xmlW.writeEndElement();
    		}

    		// Passing the Customer ID so that Service can be appended as a child to the Customer
    		if(customerID!=null){
    		    xmlW.writeStartElement(null,'customersID',null);
    		        xmlW.writeAttribute(null,null,'id','5');
    		        xmlW.writeCharacters(customerID);
    		    xmlW.writeEndElement();
    		}

            if(caseId!=null){
                xmlW.writeStartElement(null,'caseId',null);
                    xmlW.writeAttribute(null,null,'id','21');
                    xmlW.writeCharacters(caseId);
                xmlW.writeEndElement();
            }

    		// Capturing the CREATED BY and CURRENT User/Channel/Branch details.
    		if(loggedInUser.Id!=null){
    		    xmlW.writeStartElement(null,'CreatedByUserId',null);
    		        xmlW.writeAttribute(null,null,'id','6');
    		        xmlW.writeCharacters(loggedInUser.Id);
    		    xmlW.writeEndElement(); //Close Logged In User Id
    		}
    		// CreatdByBranch attribute
    		if(loggedInUser.Location__c!=null){
    		    xmlW.writeStartElement(null,'CreatedByBranch',null);
    		        xmlW.writeAttribute(null,null,'id','7');
    		        xmlW.writeCharacters(loggedInUser.Location__c);
    		    xmlW.writeEndElement(); //Close Branch
    		}
    		// CreatedByChannel attribute
    		if(loggedInUser.Channel__c!=null){
    		    xmlW.writeStartElement(null,'CreatedByChannel',null);
    		        xmlW.writeAttribute(null,null,'id','8');
    		        xmlW.writeCharacters(loggedInUser.Channel__c);
    		    xmlW.writeEndElement(); //Close Channel
    		}
    		// Created Email Attribute
    		if(loggedInUser.Email!=null){
    		    xmlW.writeStartElement(null,'CreatedEmailAddress',null);
    		        xmlW.writeAttribute(null,null,'id','9');
    		        xmlW.writeCharacters(loggedInUser.Email);
    		    xmlW.writeEndElement(); //Close Created Email Attribute
    		}
    		// Current type of fields
    		// Current User attribute
    		if(loggedInUser.Id!=null){
    		    xmlW.writeStartElement(null,'CurrentPerson',null);
    		        xmlW.writeAttribute(null,null,'id','10');
    		        xmlW.writeCharacters(loggedInUser.Id);
    		    xmlW.writeEndElement(); //Close Current User ID
    		}          
    		// Current Branch attribute
    		if(loggedInUser.Location__c!=null){
    		    xmlW.writeStartElement(null,'CurrentBranch',null);
    		        xmlW.writeAttribute(null,null,'id','11');
    		        xmlW.writeCharacters(loggedInUser.Location__c);
    		    xmlW.writeEndElement(); //Close Current Branch
    		}          
    		// Current Channel attribute
    		if(loggedInUser.Channel__c!=null){
    		    xmlW.writeStartElement(null,'CurrentChannel',null);
    		        xmlW.writeAttribute(null,null,'id','12');
    		        xmlW.writeCharacters(loggedInUser.Channel__c);
    		    xmlW.writeEndElement(); //Close Current Channel
    		}
    		// Current Email Attribute
    		if(loggedInUser.Email!=null){
    		    xmlW.writeStartElement(null,'CurrentEmailAddress',null);
    		        xmlW.writeAttribute(null,null,'id','13');
    		        xmlW.writeCharacters(loggedInUser.Email);
    		    xmlW.writeEndElement(); //Close Current Email Attribute
    		}
            // Prefilling customser's address information
            if(customer.Street_Address_1__c!=null){
                xmlW.writeStartElement(null,'customersStreetAddress1',null);
                    xmlW.writeAttribute(null,null,'id','14');
                    xmlW.writeCharacters(customer.Street_Address_1__c);
                xmlW.writeEndElement(); //Close customers street address1
            }
            if(customer.Street_Address_2__c!=null){
                xmlW.writeStartElement(null,'customersStreetAddress2',null);
                    xmlW.writeAttribute(null,null,'id','15');
                    xmlW.writeCharacters(customer.Street_Address_2__c);
                xmlW.writeEndElement(); //Close customers street address2
            } 
            if(customer.City__c!=null){
                xmlW.writeStartElement(null,'customersCity',null);
                    xmlW.writeAttribute(null,null,'id','16');
                    xmlW.writeCharacters(customer.City__c);
                xmlW.writeEndElement(); //Close customers city
            } 
            if(customer.State__c!=null){
                xmlW.writeStartElement(null,'customersState',null);
                    xmlW.writeAttribute(null,null,'id','17');
                    xmlW.writeCharacters(customer.State__c);
                xmlW.writeEndElement(); //Close customers state
            } 
            if(customer.Zip_Code__c!=null){
                xmlW.writeStartElement(null,'customersZipCode',null);
                    xmlW.writeAttribute(null,null,'id','18');
                    xmlW.writeCharacters(customer.Zip_Code__c);
                xmlW.writeEndElement(); //Close customers zipcode
            }

            // Additional member information
            if(customer.SSN__c!=null){
                xmlW.writeStartElement(null,'ssn',null);
                    xmlW.writeAttribute(null,null,'id','19');
                    xmlW.writeCharacters(customer.SSN__c);
                xmlW.writeEndElement();
            }
            if(customer.Date_Of_Birth__c!=null){
                xmlW.writeStartElement(null,'dob',null);
                    xmlW.writeAttribute(null,null,'id','20');
                    xmlW.writeCharacters(customer.Date_Of_Birth__c);
                xmlW.writeEndElement();
            }       
   		
    		xmlW.writeEndElement(); //Close SERVICE
    		xmlW.writeEndDocument(); //Close XML document
    		system.debug('The site url is '+Service_Configuration__c.getOrgDefaults().Siteurl__c);
    		String xmlStringxmlRes = xmlW.getXmlString();
    		System.debug('The XML :'+xmlW.getXmlString());     
    		xmlW.close();

    		// Making HTTP request call
    		HttpRequest req = new HttpRequest();
    		HttpResponse res = new HttpResponse();
    		Http http = new Http();
    		req.setEndpoint(Service_Configuration__c.getOrgDefaults().Siteurl__c+'SelectServiceRequest');
    		req.setMethod('POST');            
    		req.setBody('xmldata='+xmlStringxmlRes);
    		System.debug('The xml request is '+xmlStringxmlRes);
    		
    		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
    		res = http.send(req);
    		System.debug('the response for the http call is: '+ res);            
    		System.debug('The xml response is '+res.getBody());
    		// Getting the xml resonse into string
    		String resp=res.getBody();
    		System.debug('The body of the response is '+ resp);
    		servID = resp.substring(resp.indexOf('id=')+3,resp.indexOf(');')-1);
    		system.debug('The Service ID is ########## '+servID);
    		system.debug('Application Id is '+servID);
            Service__c service = [SELECT Id, User_Token__c FROM Service__c WHERE Id=:servId];
            ServiceCryptoHelper.setAppToken(service);
            update service;
            String userToken = ServiceCryptoHelper.decrypt(service.User_Token__c);

            Cookie sid = ApexPages.currentPage().getCookies().get('svcId');
            Cookie sut = ApexPages.currentPage().getCookies().get('sut');
            sid = new Cookie('svcId',servID,null,-1,true);
            sut = new Cookie('sut',userToken,null,-1,true);
            System.debug('sut:' + sut);
            System.debug('userToken:' + userToken);
            System.debug('User_Token__c:' + service.User_Token__c);

            // Set the new cookie for the page
            ApexPages.currentPage().setCookies(new Cookie[]{sid,sut});
            if (spa != null && spa == '1') {
                p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'forms?id='+servID+'&page=');
                p.setRedirect(true);
            } else {
                p = new PageReference(Service_Configuration__c.getOrgDefaults().Siteurl__c+'SelectServiceRequest?id='+servID);
            }
    		/*p = Page.SelectServiceRequest;
            p.getParameters().put('id',servID);*/
    	}
    	return p;
    }
}