/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class StartApplication_Test {

    static void testData(){
        Crypt__c c = new Crypt__c();
        c.Key__c='7h5EJk6sVmIev/MYVO1sCg==';
        insert c;
        
        // Sireurl custom settings
        SiteUrl__c s = new SiteUrl__c();
        s.Url__c = 'https://terafinainc-developer-edition.na15.force.com/';
        insert s;
    }

    static testMethod void myUnitTest() {
         testData();
         Profile p = [select id,Name from Profile where Name='System Administrator'];
          
         User u = new User(FirstName='Test',LastName='Ganesh',ProfileId=p.Id,Email='ganesh.chedella@terafinainc.com',Username='ganesh@terafina.test',Location__c='Cupertino - CA',Channel__c='Online',EmailEncodingKey='ISO-8859-1',Alias='tuser',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',LanguageLocaleKey='en_US');
                             
         insert u;
         system.runAs(u){
            
             StartApplication sa = new StartApplication();
             sa.postDetails();
         }

         System.assertEquals('Test',u.FirstName);
         
    }

    static testMethod void offLineExceptionHandlingTest() {
        //OfflineApplicationExceptionHandling
    }
}