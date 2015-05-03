global with sharing class AppDisclosures {

	global Set<String> disclosureFields = new Set<String>();

	global AppDisclosures() {
		
	}

	global void attachAppDisclosures(String appId){
		try{

			List<Employment_Information__c> empList = [SELECT id FROM Employment_Information__c WHERE Application__c = :appId];
			List<Attachment> attachments = new List<Attachment>();
			List<Attachment> att = new List<Attachment>();
			Utility u = new Utility();

			// This gives us the set of fields for a given applcation 
			Set<String> fieldsToDisplay = u.fieldsToRender(appId);

			// From a fieldset we are creating a set of all the Disclosure Names
			List<Schema.FieldSetMember> fieldsetMembers = Schema.SObjectType.Application__c.fieldSets.getMap().get('All_Disclosures').getFields();
			for(Schema.FieldSetMember f : fieldsetMembers){
			    if(f != null){
		    		if(f.getFieldPath()!= null){
		        		disclosureFields.add(String.valueOf(f.getFieldPath()));
		    		}
			    }
			}

			for(String s : fieldsToDisplay){
				if(disclosureFields.contains(s)){
					s = s.substring(0,s.length()-3);
					List<Disclosure__c> disc = [SELECT Id,name  FROM Disclosure__c WHERE Name = :Disclosure_Names__c.getValues(s).Disclosure_Label__c];
					
					if(disc.size() > 0){
						att = [SELECT Id,Name,Body FROM Attachment WHERE ParentId = :disc[0].id];
					}
					if(att.size() > 0){
						Attachment attach = new Attachment();
						if(empList.size() > 0){
							if(empList[0].id != null){
								attach.ParentId = empList[0].id;
							}
						}
						//attach.ParentId = appId;  
						//attach.Name = att[0].Name;
						attach.Name = s;
						attach.ContentType = 'application/pdf'; 
						attach.Body = att[0].Body;
						attachments.add(attach);
					}
				}
			}
			insert attachments;

		} catch(Exception e){
			System.debug('The error in the attachAppDisclosures method of the AppDisclosures class is '+ e);
		}
	}

	global void deleteAppDisclosures(String appId){
		try{
			Set<String> discNameList = new Set<String>();
			List<Disclosure_Names__c>  discNames = Disclosure_Names__c.getall().values();
			for(Disclosure_Names__c d : discNames){
				if(d.Name != null){
					discNameList.add(d.Name);				
				}
			}

			List<Attachment> delAttachments = new List<Attachment>();

			List<Employment_Information__c> emp = [SELECT id FROM Employment_Information__c WHERE Application__c = :appId];
			if(emp.size() > 0){
				if(emp[0].id != null){
					List<Attachment> empAtt = [Select id,Name,Body FROM Attachment WHERE ParentId = :emp[0].id];
					for(Attachment a : empAtt){
						if(a.name != null){
							if(discNameList.contains(a.name)){
								delAttachments.add(a);
							}
						}
					}
					delete delAttachments;
				}
			}

		} catch(Exception e){
			system.debug('The error in the deleteAppDisclosures method of the AppDisclosures class is '+e);
		}
	}	
}