public with sharing class UploadFromDB {

    public id response { get; set; }

    public void Upload() {

        
                Customer__c c = [SELECT id, First_Name__c, Middle_Name__c, Last_Name__c, Phone_Number__c, Cell_Phone_Number__c, Email_Address__c, Street_Address_1__c, Street_Address_2__c, City__c, State__c, Zip_Code__c, Person_Identifier__c, SSN__c, Date_Of_Birth__c, Company__c FROM Customer__c WHERE id = 'a0R1a000000HY4qEAG'];
                

        
       
    }    
        
        
    

}