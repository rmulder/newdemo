public with sharing class PrintApplication {

	Public String appId{get; set;}
	Public String id{get; set;}
	Public String ut{get; set;}
	Public String appPage{get; set;}
	Public Application__c app{get; set;}
	Public List<About_Account__c> aboutAcc{get; set;}
	Public String aboutAccId{get; set;}


	public PrintApplication(ApexPages.StandardController controller) {
		appId=ApexPages.currentPage().getParameters().get('id');
		this.app = (Application__c)controller.getrecord();
		app = [SELECT id,Application_Page__c FROM Application__c WHERE id = :appId];
		aboutAcc = new List<About_Account__c>();
		aboutAcc = [SELECT id,Application__c FROM About_Account__c WHERE Application__c = :app.Id];
		if(aboutAcc.size() > 0){
			aboutAccId = aboutAcc[0].id;
		} else {
			aboutAccId = null;
		}

	}

}