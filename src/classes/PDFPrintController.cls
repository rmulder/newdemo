public with sharing class PDFPrintController {
	
    public Employment_Information__c emp{get; set;}
    public String empId{get; set;}
    public List<Id> PDFIds;
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public PDFPrintController(ApexPages.StandardController stdController) {
        this.emp = (Employment_Information__c)stdController.getRecord();
        empId = ApexPages.currentPage().getParameters().get('id');
       }
    public List<Id> PDF {
        get {
            if(PDFIds == null) {
                PDFIds = new List<Id>();
                for(Attachment att : [select Id from Attachment where ParentId = :emp.Id]) {
                    PDFIds.Add(att.Id);
                }
            }
                             
            return PDFIds;
        }
    }

    public Integer totalPdf {
        get {
            return pdf.size();
        }
    }
    
}