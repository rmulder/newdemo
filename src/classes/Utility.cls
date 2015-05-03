global class Utility{
global static List<Field_Logic_New__c> fieldsAvailable;
global static set<String> selectedFields;
    
    global set<String> fieldsToRender(ID newAppId){
    fieldsAvailable= new List<Field_Logic_New__c>();
    selectedFields= new set<string>();
        //if (newAppId != '' && newAppId != null){
        
            Application__c newApplication = [select Product__c, Sub_Product__c,Primary_Offer__c,Second_Offer__c,Third_Offer__c from Application__c where Id =: newAppId];
              
              system.debug('newApplication.Product__c------------------------'+newApplication.Product__c);
               system.debug('newApplication.Sub_Product__c------------------------'+newApplication.Sub_Product__c);
            
             fieldsAvaliableList(newApplication.Product__c,newApplication.Sub_Product__c);
            
             system.debug('fieldsAvailable-------------------'+fieldsAvailable);
            
             selectedFieldsSet(fieldsAvailable);
            
             system.debug('fieldsAvailable-------------------'+fieldsAvailable);
             
             fieldsAvaliableList(newApplication.Product__c,'All');  
            
            selectedFieldsSet(fieldsAvailable); 
            List<Cross_Sell_Logic__c> mp = new  List<Cross_Sell_Logic__c>();  
            String productOffer;
            
            if(newApplication.Primary_Offer__c != '' && newApplication.Primary_Offer__c!= null && newApplication.Primary_Offer__c != 'N/A' ){
           
            mp= [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApplication.Primary_Offer__c];            
            productOffer= mp[0].Products__c;
            
            fieldsAvaliableList(productOffer,'All');  
            selectedFieldsSet(fieldsAvailable); 
            
            fieldsAvaliableList(productOffer,newApplication.Primary_Offer__c);  
            selectedFieldsSet(fieldsAvailable);
            }
            
           if(newApplication.Second_Offer__c != '' && newApplication.Second_Offer__c!= null && newApplication.Second_Offer__c != 'N/A' ){
            mp= [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApplication.Second_Offer__c];            
            productOffer= mp[0].Products__c;
            fieldsAvaliableList(productOffer,'All');  
            selectedFieldsSet(fieldsAvailable); 
            fieldsAvaliableList(productOffer,newApplication.Second_Offer__c);  
            selectedFieldsSet(fieldsAvailable); 
            }
            
            if(newApplication.Third_Offer__c != '' && newApplication.Third_Offer__c!= null && newApplication.Third_Offer__c != 'N/A'){
            mp= [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApplication.Third_Offer__c];            
            productOffer= mp[0].Products__c;
            fieldsAvaliableList(productOffer,'All');  
            selectedFieldsSet(fieldsAvailable); 
            fieldsAvaliableList(productOffer,newApplication.Third_Offer__c);  
            selectedFieldsSet(fieldsAvailable); 
            }
            
            system.debug('selectedFields---------------------'+selectedFields);
            return selectedFields;
       // }
       //return null;
    }
    
    
    global void selectedFieldsSet( List<Field_Logic_New__c> fla){
        for(Field_Logic_New__c fl : fla){
            string s= fl.Field_Name__c;
            system.debug('s-------------------'+s);
            selectedFields.add(s);
        }
    }  
    
    
    global void fieldsAvaliableList(String Product, String SubProduct){
    
    if(Product != null && Product != '' && SubProduct != null && SubProduct != '')
    fieldsAvailable= [SELECT Field_Name__c FROM Field_Logic_New__c WHERE Sub_Products__c =:SubProduct  AND Product__c =:Product AND IsDisplayed__c=true];
    }
    
}