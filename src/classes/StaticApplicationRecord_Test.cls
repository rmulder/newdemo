global with sharing class StaticApplicationRecord_Test {
	global static List<sObject> createApplicationRecord(){
		Application__c app=new Application__c();
        CryptoHelper.setAppToken(app);
        app.Product__c=Product_Names_Mapping__c.getValues('Checking').Product_Name__c;
        app.Sub_Product__c=Test_Class_Product_Names__c.getValues('CheckingSubProduct2').Client_Product_Name__c;
/*        app.First_Name__c='Test';
        app.Last_Name__c='Class';*/
        app.First_Name__c='Test';
        app.Last_Name__c = 'Test';
        app.Email_Address__c = 'abc@terafinainc.com';

        try{
        	insert app;
        }
        catch(Exception e){
        	system.debug('The error in creating Application record in Static Test record is '+e.getMessage());
        }
        Employment_Information__c emp=new Employment_Information__c();
        Identity_Information__c iden=new Identity_Information__c();
        About_Account__c acc=new About_Account__c();
        Application2__c app2=new Application2__c();
        Application_Activity__c appAcc = new Application_Activity__c();
        if(app.Id!=null){
        	emp.Application__c=app.Id;
        	iden.Application__c=app.Id;
        	acc.Application__c=app.Id;
        	app2.Application__c=app.Id;
        	appAcc.Application__c=app.Id;
        }
        
        insert emp;
        iden.Date_of_Birth__c = '01/01/1980';
        iden.SSN_Prime__c = '666777888';
        iden.SSN_Last_Four_PA__c = '7888';
        insert iden;
        insert acc;
        insert app2;
        insert appAcc;
        List<sObject> objects=new List<sObject>();
        objects.add(app);
        objects.add(emp);
        objects.add(iden);
        objects.add(acc);
        objects.add(app2);
        objects.add(appAcc);
        return objects;
	}

}