trigger SSNLast4 on Identity_Information__c (before update) {

//Copy ssnlast4
   
   for(Identity_Information__c ss : trigger.new) {
     //Field that you want to be copied by other field keep those on left side
         try{
                if(ss.SSN_Prime__c!=null && (ss.SSN_Prime__c).length()>=4){
                    string temp= ss.SSN_Prime__c;
                    ss.SSN_Last_Four_PA__c=temp.substring((temp.length()-4),temp.length());
                } 
                if(ss.SSN_J1__c!=null && (ss.SSN_J1__c).length()>=4)
                {
                    string temp= ss.SSN_J1__c;
                    ss.SSN_Last_Four_J1__c=temp.substring((temp.length()-4),temp.length());
                } 
                if(ss.SSN_J2__c!=null && (ss.SSN_J2__c).length()>=4)
                {
                    string temp= ss.SSN_J2__c;
                    ss.SSN_Last_Four_J2__c=temp.substring((temp.length()-4),temp.length());
                } 
                if(ss.SSN_J3__c!=null && (ss.SSN_J3__c).length()>=4)
                {
                    string temp= ss.SSN_J3__c;
                    ss.SSN_Last_Four_J3__c=temp.substring((temp.length()-4),temp.length());
                } 
         }// end of try
         catch(Exception e){
              system.debug('The error in updating application with ssn last four field is '+e.getMessage());
         }
        
    }


}