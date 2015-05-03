public with sharing class ServiceValidationUtility {

	public ServiceValidationUtility(ApexPages.StandardController controller) {

	}
	public ServiceValidationUtility(){
		      
	}

	// This method checks if the required field is null or blank, and will display error message on the page . errorFieldName is the parameter which comes from Page to display the particular fields error message
	public Boolean validateRequiredFields(String fieldValue,String errorFieldName){
		ApexPages.Message msg=null;
		system.debug('Checked the value of '+errorFieldName);
		  if(String.isEmpty(fieldValue)){
		      msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter '+errorFieldName);
		      ApexPages.addMessage(msg);
		      return true;
		  }
		  return false;
	}

	//This method is used to vaidate Phone Numbers. Just call this method by passing phone number a parameter
	public Boolean validatePhone(String ph){
		ApexPages.Message msg=null;
		if(ph!=null && ph.length()>0 ){
		  Boolean checkPrimaryPhone = pattern.matches('[a-zA-Z]+',ph);
		  if(checkPrimaryPhone==true){
		      msg=new ApexPages.Message(ApexPages.Severity.Error,'Only Numbers are allowed in Phone Number field');
		      ApexPages.addMessage(msg);
		      return true;
		  }
		  if(ph!=null && ph.length()>0 && ph.length()!=14){
		      msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter ten numbers in Phone Number field');
		      ApexPages.addMessage(msg);
		      return true;
		  }
		}

		return false;
	}

	public Boolean validatePhoneField(String ph){
		ApexPages.Message msg=null;
		Boolean bool = false;

		if(String.isEmpty(ph)){
			msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter Phone Number');
			ApexPages.addMessage(msg);
			bool = true;
		} else if(ph!=null && ph!='' && ph.length()>0 ){
			Boolean checkPrimaryPhone = pattern.matches('[a-zA-Z]+',ph);
			if(checkPrimaryPhone==true){
			    msg=new ApexPages.Message(ApexPages.Severity.Error,'Only Numbers are allowed in Phone Number field');
			    ApexPages.addMessage(msg);
			    bool = true;
			}

			/*Checking for the pattern: (999) 999-9999*/
			Pattern p1 = Pattern.compile('\\(\\d{3}\\) \\d{3}-\\d{4}');
	        Matcher pm1 = p1.matcher(ph);
	        /*Checking for the pattern: 999-999-9999*/
	        Pattern p2 = Pattern.compile('\\d{3}-\\d{3}-\\d{4}');
	        Matcher pm2 = p2.matcher(ph);
	        if(!(pm1.matches() || pm2.matches())){
			    msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter a valid phone number');
			    ApexPages.addMessage(msg);
			    bool = true;
			}

			/*Checking for the number of digits in a phone number*/
			Integer len = ph.length();
            Integer count = 0;
            for(integer i=0; i<len; i++){
                if(pattern.matches('[0-9]+',ph.substring(i,i+1))){
                    count++;
                }
            }
            if(count != 10){
                msg=new ApexPages.Message(ApexPages.Severity.Error,'A phone number cannot contain more than 10 ditis.');
			    ApexPages.addMessage(msg);
			    bool = true;
            }
		}
		return bool;
	}
	  
	  //This method is used to validate the Email address if proper format is enetered
	public Boolean validateEmail(String em){
		ApexPages.Message msg=null;
		if(em!=null && em.length()>0 ){ 
			if(!em.contains('@') || !em.contains('.')) {
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter valid Email address');
				ApexPages.addMessage(msg);
				return true;
			}
			Integer atLastIndex = em.lastIndexOf('@');
			Integer dotLastIndex = em.lastIndexOf('.');
			if(atLastIndex < 1 || dotLastIndex < atLastIndex + 2 || dotLastIndex + 2 >= em.length() ) {
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter valid Email address');
				ApexPages.addMessage(msg);
				return true;
		    }
		}   
		return false;
	}

	public Boolean validateEmailField(String em){

		Boolean bool = false;
		ApexPages.Message msg = null;

		if(String.isEmpty(em)){
			msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter valid Email address');
			ApexPages.addMessage(msg);
			bool=true;
		} else if(em!=null && em!='' && em.length()>0){
			if(!em.contains('@') || !em.contains('.')) {
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter valid Email address');
				ApexPages.addMessage(msg);
				bool = true;
			}
			Integer atLastIndex = em.lastIndexOf('@');
			Integer dotLastIndex = em.lastIndexOf('.');
			if(atLastIndex < 1 || dotLastIndex < atLastIndex + 2 || dotLastIndex + 2 >= em.length() ) {
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter valid Email address');
				ApexPages.addMessage(msg);
				bool = true;
		    }
		}
		return bool;
	}
	  
	// This method checks if valid  Zip code is entered in terms of only numbers eneterd and only five numbers
	public Boolean validateZip(String zip){
	ApexPages.Message msg=null;

	if(zip!=null && zip.length()>0){
	     Boolean zipCheck=pattern.matches('[a-zA-Z]+',zip);
	    if(zipCheck==true){
	      msg=new ApexPages.Message(ApexPages.Severity.Error,'Only Numbers are allowed in Zip code');
	      ApexPages.addMessage(msg);
	      return true;
	    }
	    if(zip!=null &&zip.length()>0 && zip.length()!=5){
	      msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter 5 numbers in Zip code');
	      ApexPages.addMessage(msg);
	      return true;
	    }
	}
	return false;
	}

	public Boolean validateZipField(String zip){
		
		Boolean bool = false;
		ApexPages.Message msg = null;

		if(String.isEmpty(zip)){
			msg = new ApexPages.Message(ApexPages.Severity.Error,'Please Enter a Zip Code');
			ApexPages.addMessage(msg);
			bool = true;
		} else if(zip != null || zip != '' || zip.length() > 0){
			Boolean zipCheck=pattern.matches('[a-zA-Z]+',zip);
			if(zipCheck==true){
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Only Numbers are allowed in Zip code');
				ApexPages.addMessage(msg);
				bool = true;
			}
			if(zip.length()!=5){
				msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter 5 numberical digits in all the Zip-Code fields below');
				ApexPages.addMessage(msg);
				bool = true;
			}
		}
		return bool;
	} 
	  
	public Boolean validateCurrencyRequiredFields(Decimal dec,String errorFieldName){
		ApexPages.Message msg=null;
	  	if(String.isEmpty(String.valueOf(dec))){
        	msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter '+errorFieldName);
          	ApexPages.addMessage(msg);
          	return true;
	  	}
	  	return false; 
	}

	public Boolean validateNumberRequiredFields(Decimal num,String errorFieldName){
		ApexPages.Message msg=null;
		if(String.isEmpty(String.valueOf(num))){
		      msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter '+errorFieldName);
		      ApexPages.addMessage(msg);
		      return true;
		}
	 	return false; 
	}

	public Boolean validateCheckBoxRequiredFields(Boolean fieldValue,String errorFieldName){
		ApexPages.Message msg=null;

		if(fieldValue!=true){
			msg=new ApexPages.Message(ApexPages.Severity.Error,'Please check '+errorFieldName);
			ApexPages.addMessage(msg);
			return true;
	  	}

		return false;
	}
	
	public Boolean validateRoutingNumber(String routingNumber,String errorFieldName){
	    ApexPages.Message msg=null;
	    if(routingNumber!=null && routingNumber.length()>0){
	        Boolean validRoutingNumber=pattern.matches('[a-zA-Z]+',routingNumber);
	        if(validRoutingNumber==true){
	            msg=new ApexPages.Message(ApexPages.Severity.Error,errorFieldName+' should contain only numbers');
	            ApexPages.addMessage(msg);
	            return true;
	        }
	        if(!validRoutingNumber && routingNumber.length()!=9){
	            msg=new ApexPages.Message(ApexPages.Severity.Error,errorFieldName+' should be exactly nine numbers');
	            ApexPages.addMessage(msg);
	            return true;
	        }
	    }
	    return false;
	}
	
	public Boolean validateAccountNumber(String accountNumber,String errorFieldName){
	    ApexPages.Message msg=null;
	    if(accountNumber!=null && accountNumber.length()>0){
	        Boolean validAccountNumber=pattern.matches('[a-zA-Z0-9]+',accountNumber);
	        if(validAccountNumber==false){
	            msg=new ApexPages.Message(ApexPages.Severity.Error,errorFieldName+' should contain only numbers');
	            ApexPages.addMessage(msg);
	            return true;
	        }
	    } 
	  return false;     
	}

	public Boolean validateDisclosures(Boolean disc,String errorFieldName){
	    ApexPages.Message msg=null;
	    if(disc == false){
	        msg=new ApexPages.Message(ApexPages.Severity.Error,'Please accept the '+ errorFieldName +' disclosure.');
            ApexPages.addMessage(msg);
        	return true;	    
	    } 
	  return false;     
	}


}