global class RequiredFieldsUtility {

    global static List<Field_Logic_New__c> requiredFieldList;
    global static List<Field_Logic_New__c> displayedFieldList;

    global static Set<String> requiredFields;
    global static Set<String> displayedFields;

    global RequiredFieldsUtility() {
    }

    global Set<String> fieldsRequiredAre(String appId) {
        requiredFields = new Set<String>();
        requiredFieldList = new List<Field_Logic_New__c>();
        Application__c newApp = [select Product__c, Sub_Product__c,Primary_Offer__c,Second_Offer__c,Third_Offer__c from Application__c where Id =: appId];
        system.debug('newApplication.Product__c------------------------'+newApp.Product__c);
        system.debug('newApplication.Sub_Product__c------------------------'+newApp.Sub_Product__c);

        requiredFieldsAvaliable(newApp.Product__c,newApp.Sub_Product__c);
        system.debug('Required Fields are-------------------'+requiredFieldList);
        requiredFieldsSet(requiredFieldList);
        system.debug('Required Fields are-------------------'+requiredFieldList);

        //requiredFieldsAvaliable(newApp.Product__c,'All');  
        //requiredFieldsSet(requiredFieldList); 
        List<Cross_Sell_Logic__c> mp = new  List<Cross_Sell_Logic__c>();  
        String productOffer;

        if (newApp.Primary_Offer__c != '' && newApp.Primary_Offer__c != null && newApp.Primary_Offer__c != 'N/A' ) {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Primary_Offer__c];            
            productOffer= mp[0].Products__c;
            //requiredFieldsAvaliable(productOffer,'All');  
            //requiredFieldsSet(requiredFieldList); 
            requiredFieldsAvaliable(productOffer, newApp.Primary_Offer__c);  
            requiredFieldsSet(requiredFieldList);
        }

        if (newApp.Second_Offer__c != '' && newApp.Second_Offer__c != null && newApp.Second_Offer__c != 'N/A' ) {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Second_Offer__c];            
            productOffer= mp[0].Products__c;
            //requiredFieldsAvaliable(productOffer,'All');  
            //requiredFieldsSet(requiredFieldList); 
            requiredFieldsAvaliable(productOffer, newApp.Second_Offer__c);  
            requiredFieldsSet(requiredFieldList); 
        }

        if (newApp.Third_Offer__c != '' && newApp.Third_Offer__c != null && newApp.Third_Offer__c != 'N/A') {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Third_Offer__c];            
            productOffer= mp[0].Products__c;
            //requiredFieldsAvaliable(productOffer,'All');  
            //requiredFieldsSet(requiredFieldList); 
            requiredFieldsAvaliable(productOffer, newApp.Third_Offer__c);  
            requiredFieldsSet(requiredFieldList); 
        }

        return requiredFields;
    }

    global Set<String> fieldsDisplayedAre(String appId) {
        displayedFields = new Set<String>();
        displayedFieldList = new List<Field_Logic_New__c>();
        Application__c newApp = [select Product__c, Sub_Product__c,Primary_Offer__c,Second_Offer__c,Third_Offer__c from Application__c where Id =: appId];
        system.debug('newApplication.Product__c------------------------'+newApp.Product__c);
        system.debug('newApplication.Sub_Product__c------------------------'+newApp.Sub_Product__c);

        displayedFieldsAvaliable(newApp.Product__c,newApp.Sub_Product__c);
        system.debug('Required Fields are-------------------'+displayedFieldList);
        displayedFieldsSet(displayedFieldList);
        system.debug('Required Fields are-------------------'+displayedFieldList);

        //displayedFieldsAvaliable(newApp.Product__c,'All');  
        //displayedFieldsSet(displayedFieldList); 
        List<Cross_Sell_Logic__c> mp = new  List<Cross_Sell_Logic__c>();  
        String productOffer;

        if (newApp.Primary_Offer__c != '' && newApp.Primary_Offer__c != null && newApp.Primary_Offer__c != 'N/A' ) {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Primary_Offer__c];            
            productOffer= mp[0].Products__c;
            //displayedFieldsAvaliable(productOffer,'All');  
            //displayedFieldsSet(displayedFieldList); 
            displayedFieldsAvaliable(productOffer, newApp.Primary_Offer__c);  
            displayedFieldsSet(displayedFieldList);
        }

        if (newApp.Second_Offer__c != '' && newApp.Second_Offer__c != null && newApp.Second_Offer__c != 'N/A' ) {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Second_Offer__c];            
            productOffer= mp[0].Products__c;
            //displayedFieldsAvaliable(productOffer,'All');  
            //displayedFieldsSet(displayedFieldList); 
            displayedFieldsAvaliable(productOffer, newApp.Second_Offer__c);  
            displayedFieldsSet(displayedFieldList); 
        }

        if (newApp.Third_Offer__c != '' && newApp.Third_Offer__c != null && newApp.Third_Offer__c != 'N/A') {
            mp = [SELECT Products__c,ID FROM Cross_Sell_Logic__c WHERE Sub_Products__c =: newApp.Third_Offer__c];            
            productOffer= mp[0].Products__c;
            //displayedFieldsAvaliable(productOffer,'All');  
            //displayedFieldsSet(displayedFieldList); 
            displayedFieldsAvaliable(productOffer, newApp.Third_Offer__c);  
            displayedFieldsSet(displayedFieldList); 
        }

        return displayedFields;
    }

/*
    global List<Field_Logic_New__c> displayFieldsMap(Set<String> displayedFieldsSet) {
        List<Field_Logic_New__c> fieldList = [SELECT Field_Name__c, Label__c FROM Field_Logic_New__c WHERE Field_Name__c in :displayedFieldsSet];
        for (Field_Logic_New__c fl : fieldList) {
            appData.put('FieldLogic.' + fl.Field_Name__c, fl.Label__c);
        }
    }
*/
    global void requiredFieldsAvaliable(String Product, String SubProduct) {
        if (Product != null && Product != '' && SubProduct != null && SubProduct != '') {
            requiredFieldList= [SELECT Field_Name__c FROM Field_Logic_New__c WHERE Sub_Products__c =:SubProduct  AND Product__c =:Product AND IsRequired__c=True];
        }
    }
    
    global void displayedFieldsAvaliable(String Product, String SubProduct) {
        if (Product != null && Product != '' && SubProduct != null && SubProduct != '') {
            displayedFieldList= [SELECT Field_Name__c FROM Field_Logic_New__c WHERE Sub_Products__c =:SubProduct  AND Product__c =:Product AND IsDisplayed__c=True];
        }
    }
    
    global void requiredFieldsSet( List<Field_Logic_New__c> fLogic){
        for (Field_Logic_New__c fl : fLogic) {
            string str= fl.Field_Name__c;
            system.debug('str-------------------'+str);
            requiredFields.add(str);
        }
    }

    global void displayedFieldsSet( List<Field_Logic_New__c> fLogic){
        for (Field_Logic_New__c fl : fLogic) {
            string str= fl.Field_Name__c;
            system.debug('str-------------------'+str);
            displayedFields.add(str);
        }
    }

}