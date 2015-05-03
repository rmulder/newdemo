public with sharing class CodeTestUtility {

	public List<DataWrapper> dataWrapperList{get;set;}
	Map<String, List<DataWrapper>> pageFieldsMap{get; set;}

    public CodeTestUtility() {
        
    }

    public String jsonCreator(String id, String pageName){

    	pageFieldsMap = new Map<String, List<DataWrapper>>();
        String jsonString = null;
        //id = 'a0917000001GyLI';
        Map<String,String> sectionValueMap = new Map<String,String>();

        Set<String> requiredFieldset;
        Set<String> nonRequiredFieldset;

		//Querying the Application Object to Get the Product and all the Cross-sell Offers.
        Application__c app = [SELECT Id, Product__c, Sub_Product__c, Primary_Offer__c, Second_Offer__c, Third_Offer__c, Password__c, Login__c FROM Application__c WHERE Id = :id];
        
        //Querying All the Field Logic records for the given Product(INcluding Cross-Sells) and the Page
        List<Field_Logic_New__c> fieldLogicList = [Select Field_Name__c, IsDisplayed__c, IsRequired__c, Label__c,Section_Type__c, Datatype__c, sObject__c, Page_Type__c FROM Field_Logic_New__c WHERE Section_Type__c != null AND Field_Name__c != null AND Page_Type__c != null AND Page_Type__c INCLUDES (:pageName) AND (Sub_Products__c = :app.Sub_Product__c OR Sub_Products__c = :app.Primary_Offer__c OR Sub_Products__c = : app.Second_Offer__c OR Sub_Products__c = : app.Third_Offer__c) LIMIT 50000];// ID 1 = a0N17000000z7ahEAA and ID 2 = a0N17000000z92YEAQ
        
        List<Field_Logic_New__c> fieldDetailsList = [SELECT Id, Field_Name__c, sObject__c, Column_Width__c, Datatype__c, Label__c, Supported_Datatype__c, Picklist_Values__c FROM Field_Logic_New__c WHERE RecordType.name = 'Field Details'];
        List<Field_Logic_New__c> sectionOrder = [SELECT Id, Page_Type__c, Section_Type__c, Order__c FROM Field_Logic_New__c WHERE RecordType.name = 'Section Order' AND Page_Type__c INCLUDES (:pageName) ORDER BY Order__c];
        List<Field_Logic_New__c> pageLabels = [SELECT Id, Page_Name__c, Value__c, Label_Name__c FROM Field_Logic_New__c WHERE RecordType.name = 'Page Labels' AND Page_Type__c INCLUDES (:pageName)];
        List<Field_Logic_New__c> sectionTypeLabels = [SELECT Id,Value__c, Section_Type__c FROM Field_Logic_New__c WHERE RecordType.name = 'Section Labels'];
        
        System.debug('The values of the list is '+fieldLogicList);
        System.debug('The size of the list is '+fieldLogicList.size());

        Set<String> sectionNames = new Set<String>();

        // iterating over all the field logic records to get a SET<Section Names>
        for(Field_Logic_New__c flRecord : fieldLogicList){
        	if(flRecord.Section_Type__c != null){
        		List<String> sectionNameList = flRecord.Section_Type__c.split(';');
        		for(String secName : sectionNameList){
        			if(secName.contains(pageName)){
        				sectionNames.add(secName);
        			}
        		}
        	}
        }
        System.debug('The set of section names is '+sectionNames);

        //Iterating through all the Set(unique) of section names to get a set of Required and Non-Required fields
        for(String sectionName : sectionNames) {

        	requiredFieldset = new Set<String>();
        	nonRequiredFieldset = new Set<String>();
        	dataWrapperList = new List<DataWrapper>();

        	for(Field_Logic_New__c fl : fieldLogicList){
        		if(fl.Section_Type__c.contains(sectionName)){
        			if(fl.IsRequired__c == true){
        				requiredFieldset.add(fl.Field_Name__c);
        			} else {
        				nonRequiredFieldset.add(fl.Field_Name__c);
        			}
        		}
        	}

        	for(String reqField : requiredFieldset) {

        		// Building the DataWrapper class for all the Required Fields
        		for(Field_Logic_New__c fieldDetail : fieldDetailsList){
        			if(fieldDetail.Field_Name__c == reqField){
        			    List<String> plValues = new List<String>();
        			    if(fieldDetail.Supported_Datatype__c == 'select'){
        			        plValues =  fieldDetail.Picklist_Values__c.split(';');
        			        dataWrapperList.add(new DataWrapper(fieldDetail.sObject__c+'.'+fieldDetail.Field_Name__c, true, fieldDetail.Supported_Datatype__c, fieldDetail.Label__c, Integer.valueOf(fieldDetail.Column_Width__c),plValues));
        			    } else {
        			        dataWrapperList.add(new DataWrapper(fieldDetail.sObject__c+'.'+fieldDetail.Field_Name__c, true, fieldDetail.Supported_Datatype__c, fieldDetail.Label__c, Integer.valueOf(fieldDetail.Column_Width__c),plValues));
        			    }  
        			}
        		}

        		if(nonRequiredFieldset.contains(reqField)){
        			nonRequiredFieldset.remove(reqField);
        		}
        	}

        	System.debug('The Required fieldSet is '+requiredFieldset);
        	System.debug('The NON-Required fieldSet is '+nonRequiredFieldset);

        	// Building the DataWrapper class for all the NON-Required Fields
        	for(String nonReqField : nonRequiredFieldset){
        		for(Field_Logic_New__c fieldDetail1 : fieldDetailsList){
        		    if(fieldDetail1.Field_Name__c == nonReqField){
        		        List<String> pl1Values = new List<String>();
        		          if(fieldDetail1.Supported_Datatype__c == 'select'){
        		              pl1Values =  fieldDetail1.Picklist_Values__c.split(';');
        		              dataWrapperList.add(new DataWrapper(fieldDetail1.sObject__c+'.'+fieldDetail1.Field_Name__c, true, fieldDetail1.Supported_Datatype__c, fieldDetail1.Label__c, Integer.valueOf(fieldDetail1.Column_Width__c),pl1Values));
        		          } else {
        		              dataWrapperList.add(new DataWrapper(fieldDetail1.sObject__c+'.'+fieldDetail1.Field_Name__c, true, fieldDetail1.Supported_Datatype__c, fieldDetail1.Label__c, Integer.valueOf(fieldDetail1.Column_Width__c),pl1Values));
        		          }
        		    }
        		}
        	}

        	pageFieldsMap.put(sectionName,dataWrapperList);

        }

        System.debug('The pageFieldsMap is '+pageFieldsMap);

        //Getting the value of each section Type in a MAP
        for(Field_Logic_New__c secTypeLabel : sectionTypeLabels){
        	sectionValueMap.put(secTypeLabel.Section_Type__c,secTypeLabel.Value__c);
        }
        System.debug('The sectionValueMap is '+sectionValueMap);


        JSONGenerator gen = JSON.createGenerator(true);//instantiation of the generator
        gen.writeStartObject(); // Writes the starting marker of a JSON object '{'

	        //Contsructing JSON for the pageLabels:
	        gen.writeFieldName('labels');
	        gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
	        	gen.writeStartObject();
	        		gen.writeFieldName('PageLabels');
	        		gen.writeStartObject();
	        			for(Field_Logic_New__c pageLabel : pageLabels){
	        				if(pageLabel.Label_Name__c != null && pageLabel.Value__c != null){
	        					gen.writeObjectField( pageLabel.Label_Name__c, pageLabel.Value__c);	
	        				}	
	        			}
	        		gen.writeEndObject();	
	        	gen.writeEndObject();
	        gen.writeEndArray();//Writes the End marker of a JSON array (']').
	        //gen.writeString(',');//Writes the specified string value, In this case a ',' after the end array

	        if(pageName.contains('GetStartedPage')){
    	        //Contsructing JSON for the pageFields:
    	        gen.writeFieldName('login-fields');
    	        gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
    		        	gen.writeStartObject();
    		        		gen.writeStringField('template', '<hr /><div><strong>Please enter your username and password</strong></div>');
    		        	gen.writeEndObject();
    		        	gen.writeStartObject();
    		        		gen.writeStringField('type', 'multiField');
    		        		gen.writeFieldName('templateOptions');
    		        		gen.writeStartObject();
    		        			gen.writeFieldName('fields');
    		        			gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
 	
    			        				gen.writeStartObject();
    			        					gen.writeStringField('type','inupt');
    			        					gen.writeStringField('key','Application__c.Login__c');
    			        					gen.writeFieldName('templateOptions');
    			        					gen.writeStartObject();
    			        					    gen.writeObjectField('label', 'Username');
    			        					    gen.writeNumberField('width', 6);
    			        					    gen.writeBooleanField('required', true);
    			        					gen.writeEndObject();
    			        				gen.writeEndObject();

    			        				gen.writeString(',');//Writes the specified string value, In this case a ',' after the end array	
    			        			
    			        				gen.writeStartObject();
    			        					gen.writeStringField('type','inupt');
    			        					gen.writeStringField('key','Application__c.Password__c');
    			        					gen.writeFieldName('templateOptions');
    			        					gen.writeStartObject();
    			        					    gen.writeObjectField('label', 'Password');
    			        					    gen.writeNumberField('width', 6);
    			        					    gen.writeBooleanField('required', true);
    			        					gen.writeEndObject();
    			        				gen.writeEndObject();

    		        			gen.writeEndArray();//Writes the End marker of a JSON array (']').
    		        		gen.writeEndObject();
    		        	gen.writeEndObject();	
    	        gen.writeEndArray();//Writes the End marker of a JSON array (']').
    	        //gen.writeString(',');//Writes the specified string value, In this case a ',' after the end array
	        }

	        //Contsructing JSON for the pageFields:
	        gen.writeFieldName('fields');
	        gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
		        for(String sectionLabel : sectionNames){
		        	gen.writeStartObject();
		        		system.debug('sectionValueMap.get(sectionLabel) is '+ sectionValueMap.get(sectionLabel));
		        		if(sectionValueMap.get(sectionLabel) != null){
		        			gen.writeStringField('template', '<hr /><div><strong>'+sectionValueMap.get(sectionLabel)+'<br/></strong></div>');	
		        		}
		        	gen.writeEndObject();
		        	List<DataWrapper> pageFieldsList = pageFieldsMap.get(sectionLabel);
		        	gen.writeStartObject();
		        		gen.writeStringField('type', 'multiField');
		        		gen.writeFieldName('templateOptions');
		        		gen.writeStartObject();
		        			gen.writeFieldName('fields');
		        			gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
			        			for(DataWrapper pageFieldsGroup : pageFieldsList){
			        				if(pageFieldsGroup.dataType != null && pageFieldsGroup.key != null && pageFieldsGroup.fieldLabel != null && pageFieldsGroup.fieldWidth != null){
			        					gen.writeStartObject();
			        						//gen.writeStringField('type',pageFieldsGroup.dataType);
			        						gen.writeStringField('type','input');
			        						gen.writeStringField('key',pageFieldsGroup.key);
			        						gen.writeFieldName('templateOptions');
			        						gen.writeStartObject();
			        						    gen.writeObjectField('label', pageFieldsGroup.fieldLabel);
			        						    //Adding the picklist value for picklist fields
			        						    if (pageFieldsGroup.dataType == 'select') {
			        						        gen.writeFieldName('options');
			        						        gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
			        						        for (String pickListValue : pageFieldsGroup.picklistValues) {
			        						            gen.writeStartObject();
			        						                gen.writeStringField('name',pickListValue);
			        						                gen.writeStringField('Value',pickListValue);
			        						            gen.writeEndObject();    
			        						        }
			        						        gen.writeEndArray();//Writes the End marker of a JSON array (']').
			        						    }
			        						    gen.writeNumberField('width', pageFieldsGroup.fieldWidth);
			        						    gen.writeBooleanField('required', pageFieldsGroup.isRequired);
			        						gen.writeEndObject();
			        					gen.writeEndObject();
			        				}
			        			}
		        			gen.writeEndArray();//Writes the End marker of a JSON array (']').
		        		gen.writeEndObject();
		        	gen.writeEndObject();	
		        }
	        gen.writeEndArray();//Writes the End marker of a JSON array (']').
        gen.writeEndObject();

        jsonString = gen.getAsString();

        /*if(fieldLogicList.size() > 0){  
            JSONGenerator gen = JSON.createGenerator(true);//instantiation of the generator
            gen.writeStartObject(); // Writes the starting marker of a JSON object '{'
            gen.writeFieldName('allInfo');
            gen.writeStartArray();//Writes the starting marker of a JSON array ('[').
            for(Field_Logic_New__c f: fieldLogicList){
                gen.writeStartObject();
                gen.writeStringField('template', f.Section_Type__c);
                gen.writeEndObject();    
                for(Field_Logic_New__c fl : fieldLogicList){
                    gen.writeStartObject();
                    gen.writeStringField('type', 'multiField');
                    gen.writeFieldName('templateOptions');
                    gen.writeStartObject();
                    gen.writeFieldName('fields');
                    gen.writeStartArray();
                    for(Field_Logic_New__c fllist :fieldLogicList){
                        gen.writeStartObject();
                        gen.writeStringField('key', fllist.sObject__c+'.'+fllist.Field_Name__c);
                        gen.writeStringField('type', fllist.Datatype__c);
                        gen.writeFieldName('templateOptions');
                        gen.writeStartObject();
                        gen.writeObjectField('label', fllist.Label__c);
                        gen.writeObjectField('pageName', fllist.Page_Type__c);
                        gen.writeEndObject();
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();         
                    gen.writeEndObject();
                    gen.writeEndObject();
                }
            }
            gen.writeEndArray(); 
            gen.writeEndObject();
            jsonString = gen.getAsString();
        }*/
        return jsonString;
    }

    public class DataWrapper{
        public String key;
        public Boolean isRequired;
        public String dataType;
        public String fieldLabel;
        public Integer fieldWidth;
        public List<String> picklistValues;

        public DataWrapper(String fieldKey, Boolean isReq, String type, String label, Integer width, List<String> pklstValues){
            key = fieldKey;
            isRequired = isReq;
            dataType = type;
            fieldLabel = label;
            fieldWidth = width;
            picklistValues = pklstValues;
        }
    }

}