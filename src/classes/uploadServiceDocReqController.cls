public with sharing class uploadServiceDocReqController {
public String serviceDocReqID{get; set;}
public Attachment attach{get; set;}
    public uploadServiceDocReqController(ApexPages.StandardController controller) {
        serviceDocReqID = ApexPages.currentPage().getParameters().get('id');
        attach = new Attachment();
    }
    
    public Pagereference upLoad(){
        attach.ParentId = serviceDocReqID;
        try {
			insert attach;
        } catch (DMLException e) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
			return null;
        } finally {
          	attach = new Attachment(); 
        }

        /*List<Service_Document_Request__c> serviceDocReqList = [SELECT id,service__c FROM Service_Document_Request__c WHERE Id =:serviceDocReqID];
        if(serviceDocReqList.size() > 0){
        	Service__c serv = [SELECT id,Name FROM Service__c WHERE Id =:serviceDocReqList[0].service__c];
        	ApexPages.StandardController sc = new ApexPages.standardController(serv);
        	ServiceAppController serviceApp = new ServiceAppController(sc);
        	serviceApp.uploadDoc(serviceDocReqList[0].service__c);
        }*/
        return null;
    }
}