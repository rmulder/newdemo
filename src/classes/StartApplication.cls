public with sharing class StartApplication {
    public User loggedInUser{get;set;}
    public String userId;
    public StartApplication() {
        userId=UserInfo.getUserId();
        loggedInUser=[select id,Channel__c,Name,Location__c,Profile.Name,Email from User where Id=:userId];
    }
    
    public PageReference postDetails() {
        PageReference p=null;
        String appId = null;
        try {
            // Creating XML of data from User fields to post it to ProductPage Url
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null,'SERVICE', null);
            xmlW.writeAttribute(null,null,'version','1.0');

            // CreatedBy related to User and Branch details
            // CreatedBYUserId attribute
            if(loggedInUser.Id!=null){
                xmlW.writeStartElement(null,'CreatedByUserId',null);
                    xmlW.writeAttribute(null,null,'id','8');
                    xmlW.writeCharacters(loggedInUser.Id);
                xmlW.writeEndElement(); //Close Logged In User Id
            }

            // CreatdByBranch attribute
            if(loggedInUser.Location__c!=null){
                xmlW.writeStartElement(null,'CreatedByBranch',null);
                    xmlW.writeAttribute(null,null,'id','9');
                    xmlW.writeCharacters(loggedInUser.Location__c);
                xmlW.writeEndElement(); //Close Branch
            }

            // CreatedByChannel attribute
            if(loggedInUser.Channel__c!=null){
                xmlW.writeStartElement(null,'CreatedByChannel',null);
                    xmlW.writeAttribute(null,null,'id','10');
                    xmlW.writeCharacters(loggedInUser.Channel__c);
                xmlW.writeEndElement(); //Close Channel
            }

            // Created Email Attribute
            if(loggedInUser.Email!=null){
                xmlW.writeStartElement(null,'CreatedEmailAddress',null);
                    xmlW.writeAttribute(null,null,'id','28');
                    xmlW.writeCharacters(loggedInUser.Email);
                xmlW.writeEndElement(); //Close Created Email Attribute
            }

            // Current type of fields
            // Current User attribute
            if(loggedInUser.Id!=null){
                xmlW.writeStartElement(null,'CurrentPerson',null);
                    xmlW.writeAttribute(null,null,'id','11');
                    xmlW.writeCharacters(loggedInUser.Id);
                xmlW.writeEndElement(); //Close Current User ID
            }          

            // Current Branch attribute
            if(loggedInUser.Location__c!=null){
                xmlW.writeStartElement(null,'CurrentBranch',null);
                    xmlW.writeAttribute(null,null,'id','12');
                    xmlW.writeCharacters(loggedInUser.Location__c);
                xmlW.writeEndElement(); //Close Current Branch
            }          

            // Current Channel attribute
            if(loggedInUser.Channel__c!=null){
                xmlW.writeStartElement(null,'CurrentChannel',null);
                    xmlW.writeAttribute(null,null,'id','13');
                    xmlW.writeCharacters(loggedInUser.Channel__c);
                xmlW.writeEndElement(); //Close Current Channel
            }

            // Current Email Attribute
            if(loggedInUser.Email!=null){
                xmlW.writeStartElement(null,'CurrentEmailAddress',null);
                    xmlW.writeAttribute(null,null,'id','29');
                    xmlW.writeCharacters(loggedInUser.Email);
                xmlW.writeEndElement(); //Close Current Email Attribute
            }

            // Application Status  attribute
            xmlW.writeStartElement(null,'ApplicationStatus',null);
                xmlW.writeAttribute(null,null,'id','18');
                xmlW.writeCharacters('Open');
            xmlW.writeEndElement(); //Close Application Status
    
            xmlW.writeEndElement(); //Close SERVICE
            xmlW.writeEndDocument(); //Close XML document
            system.debug('The site url is '+SiteUrl__c.getOrgDefaults().Url__c);
            String xmlStringxmlRes = xmlW.getXmlString();
            System.debug('The XML :'+xmlW.getXmlString());     
            xmlW.close();
            // Makking HTTP request call
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setEndpoint(SiteUrl__c.getOrgDefaults().Url__c+'ProductPage');
            req.setMethod('POST');            
            req.setBody('xmldata='+xmlStringxmlRes);
            System.debug('The xml request is '+xmlStringxmlRes);
    
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');  
            res = http.send(req);
            system.debug('the response for the http call is: '+ res);            
            System.debug('The xml response is '+res.getBody());
            // Getting the xml resonse into string
            String resp=res.getBody();
            appId = resp.substring(resp.indexOf('id=')+3,resp.indexOf(');')-1);
            system.debug('Application Id is '+appId);
            p = new PageReference(SiteUrl__c.getOrgDefaults().Url__c+'ProductPage?id='+appId);
        } catch(Exception e) {
            system.debug('The error is '+e.getMessage()+' and line number is '+e.getLineNumber());
            String s = OfflineApplicationExceptionHandling.createAPplication();
            p = new PageReference(SiteUrl__c.getOrgDefaults().Url__c+'ProductPage?id='+s);
        }
        
        return p;
    }
}