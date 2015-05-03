global with sharing class IndexValidationExtension {

    global static Boolean isDataValid(Application__c app, String pageName, Application2__c app2, Employment_Information__c emp, Identity_Information__c iden, About_Account__c acc) {
        //new signature: isDataValid(String pageName, Map<String,sObject> appObjects)
        Boolean valid = true;
        ApexPages.Message msg = null;
        RequiredFieldsUtility rfu = new RequiredFieldsUtility();
        Utility u=new Utility();
        Set<String> fieldsToDisplay=u.fieldsToRender(app.Id);
        ValidationUtilityClass v = new ValidationUtilityClass();
        Set<String> fieldsRequired = rfu.fieldsRequiredAre(app.id);
        system.debug('Everything successful');
        

        //RMM: Modify the signature to pass in an sObjects array: Map<String,sObject> appObjects
        //then pull them off like this:
        //Application__c app = (Application__c)appObjects.get(APPLICATION_OBJECT);
        if (pageName == Index.GET_STARTED_PAGE) {
            if (app.email_address__c.length() > 0) {
                Integer atLastIndex = app.email_address__c.lastIndexOf('@');
                Integer dotLastIndex = app.email_address__c.lastIndexOf('.');
                if (atLastIndex < 1 || dotLastIndex < atLastIndex + 2 || dotLastIndex + 2 >= app.email_address__c.length()) {
                    valid = false;
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please enter a valid email address'); 
                    ApexPages.addMessage(msg);
                }
            }
          
            if (app.primary_phone_number__c == null || app.primary_phone_number__c == '')  {
                valid = false;
                msg = new ApexPages.Message(ApexPages.Severity.Error, 'Phone number cannot be blank'); 
                ApexPages.addMessage(msg);
            } 
          
            if (app.primary_phone_number__c.length() > 0) {
                Boolean checkPrimaryPhone = pattern.matches('[a-zA-Z]+', app.primary_phone_number__c);
                if (checkPrimaryPhone == true) {                
                    valid = false;                                      
                    msg = new ApexPages.Message(ApexPages.Severity.Error, 'Phone Number should only contain numbers');          
                    ApexPages.addMessage(msg);      
                }
            }
        } else if (pageName == Index.PERSONAL_INFO_PAGE) {
            if (fieldsRequired.contains('First_Name__c') && v.validateRequiredFields(app.First_Name__c,'First Name') ) {
                system.debug('checked First Name');
                valid=false;
            }
            if (fieldsRequired.contains('Last_Name__c') && v.validateRequiredFields(app.Last_Name__c,'Last Name')) {
                system.debug('checked Last Name');
                valid=false;
            }
            if (fieldsRequired.contains('Street_Address_1__c') && v.validateRequiredFields(app.Street_Address_1__c,'Street Address 1')) {
                system.debug('checked Street Address 1');
                valid=false;
            }

            if (fieldsRequired.contains('Street_Address_1__c') && app.Street_Address_1__c != null) {
            //if (app.Street_Address_1__c != null) {
                if (app.Street_Address_1__c.contains('P.O.Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('PO Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('P O Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('P. O Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('po box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('p o box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('p.o box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('p. o box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('Po Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('P o Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('P.o Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                } else if (app.Street_Address_1__c.contains('P. o Box')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please do not enter P.O Box Address '));
                    system.debug('No PO Box');
                    valid=false;
                }
            }
            if (fieldsRequired.contains('City__c') && v.validateRequiredFields(app.City__c,'City')) {
                valid=false;
            }
            // It checks if the Zip code is entered, and if entered, checks for the valid Zip Code
            if (fieldsRequired.contains('Zip_Code__c') && v.validateRequiredFields(app.Zip_Code__c,'Zip Code')) {
                valid=false;
            }
            if (fieldsRequired.contains('Zip_Code__c') && v.validateZip(app.Zip_Code__c)) {
                valid=false;
            }  
             
             // This checks if Years lived is entered or not, if yes then checks if years is less than 2, Previous address fields are filled or not
            if (fieldsRequired.contains('Years__c') && v.validateRequiredFields(String.valueOf(app.Years__c),'Years')) {
                valid=false;
            }
            
            if (app.Years__c<2) {
                system.debug('Years is less than 2');
                if (fieldsRequired.contains('Street_Address_1_Prev__c') && v.validateRequiredFields(app.Street_Address_1_Prev__c,'Previous Street Address 1')) {
                     valid=false;
                }
                if (fieldsRequired.contains('City_Prev__c') && v.validateRequiredFields(app.City_Prev__c,'Previous Address City')) {
                     valid=false;
                }
                if (fieldsRequired.contains('State_Prev__c') && v.validateRequiredFields(app.State_Prev__c,'Previous Address State')) {
                     valid=false;
                }
                if (fieldsRequired.contains('Zip_Code_Prev__c') && v.validateRequiredFields(app.Zip_Code_Prev__c,'Previous Address Zip Code')) {
                     valid=false;
                }
                if (v.validateZip(app.Zip_Code_Prev__c)) {
                    valid=false;
                }
            }
            if (fieldsRequired.contains('Primary_Phone_Number__c') && v.validateRequiredFields(app.Primary_Phone_Number__c,'Phone Number')) {
                system.debug('checked Phone Number');
                valid=false;
            }
            if (fieldsRequired.contains('Primary_Phone_Number__c') && v.validatePhone(app.Primary_Phone_Number__c)) {
                valid=false;
            }
            if (fieldsRequired.contains('Secondary_Phone_Number__c') && v.validateRequiredFields(app.Secondary_Phone_Number__c,'Work Phone')) {
                system.debug('checked Phone Number');
                valid=false;
            }
            if (app.Secondary_Phone_Number__c!=null) {
                system.debug('Validating Phone Number');
            }
            if (fieldsRequired.contains('Secondary_Phone_Number__c') && v.validatePhone(app.Secondary_Phone_Number__c)) {
                valid=false;
            }
            if (fieldsRequired.contains('Email_Address__c') && v.validateRequiredFields(app.Email_Address__c,'Email')) {
                system.debug('checked Email Address');
                valid=false;
            }
            if(fieldsRequired.contains('Email_Address__c') && v.validateEmail(app.Email_Address__c)){
                system.debug('Enter valid email');
                valid=false;
            }
            
            if (app.first_joint_applicant__c == true) {
                if (fieldsRequired.contains('First_Name_J__c') && v.validateRequiredFields(app.First_Name_J__c,'First Name') ) {
                    system.debug('checked First Name');
                    valid=false;
                }
           
                if (fieldsRequired.contains('Last_Name_J__c') && v.validateRequiredFields(app.Last_Name_J__c,'Last Name')) {
                    system.debug('checked Last Name');
                    valid=false;
                }
                if (fieldsRequired.contains('Street_Address_J__c') && v.validateRequiredFields(app.Street_Address_J__c,'Street Address 1')) {
                                   system.debug('checked Street Address 1');
                    valid=false;
                }
                if (fieldsRequired.contains('City_J__c') && v.validateRequiredFields(app.City_J__c,'City')) {
                    valid=false;
                }
                // It checks if the Zip code is entered, and if entered, checks for the valid Zip Code
                if (fieldsRequired.contains('Zip_Code_J__c') && v.validateRequiredFields(app.Zip_Code_J__c,'Zip Code')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Zip_Code_J__c') && v.validateZip(app.Zip_Code_J__c)) {
                    valid=false;
                }  
                 
                 // This checks if Years lived is entered or not, if yes then checks if years is less than 2, Previous address fields are filled or not
                if (fieldsRequired.contains('Years_J__c') && v.validateRequiredFields(String.valueOf(app.Years_J__c),'Years')) {
                    valid=false;
                }
                if (app.Years_J__c<2) {
                    system.debug('Years is less than 2');
                    if (fieldsRequired.contains('Street_Address_1_JP__c') && v.validateRequiredFields(app.Street_Address_1_JP__c,'Previous Street Address 1')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('City_JP__c') && v.validateRequiredFields(app.City_JP__c,'Previous Address City')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('State_JP__c') && v.validateRequiredFields(app.State_JP__c,'Previous Address State')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_JP__c') && v.validateRequiredFields(app.Zip_Code_JP__c,'Previous Address Zip Code')) {
                         valid=false;
                    }
                    if (v.validateZip(app.Zip_Code_JP__c)) {
                        valid=false;
                    }
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J__c') && v.validateRequiredFields(app.Primary_Phone_Number_J__c,'Phone Number')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J__c') && v.validatePhone(app.Primary_Phone_Number_J__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_J__c') && v.validateRequiredFields(app.Secondary_Phone_Number_J__c,'Work Phone')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (app.Secondary_Phone_Number_J__c!=null) {
                    system.debug('Validating Phone Number');
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_J__c') && v.validatePhone(app.Secondary_Phone_Number_J__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Email_Address_J__c') && v.validateRequiredFields(app.Email_Address_J__c,'Email')) {
                    system.debug('checked Email Address');
                    valid=false;
                }
                if(fieldsRequired.contains('Email_Address_J__c') && v.validateEmail(app.Email_Address_J__c)){
                system.debug('Enter valid email');
                valid=false;
            }
            }

            // Second Joint Applicant 
            if (app.Second_joint_applicant__c == true) {
                if (fieldsRequired.contains('First_Name_J2__c') && v.validateRequiredFields(app.First_Name_J2__c,'First Name') ) {
                    system.debug('checked First Name');
                    valid=false;
                }
                if (fieldsRequired.contains('Last_Name_J2__c') && v.validateRequiredFields(app.Last_Name_J2__c,'Last Name')) {
                    system.debug('checked Last Name');
                    valid=false;
                }
                if (fieldsRequired.contains('Street_Address_1_J2__c') && v.validateRequiredFields(app.Street_Address_1_J2__c,'Street Address 1')) {
                    system.debug('checked Street Address 1');
                    valid=false;
                }
                if (fieldsRequired.contains('City_J2__c') && v.validateRequiredFields(app.City_J2__c,'City')) {
                    valid=false;
                }
                // It checks if the Zip code is entered, and if entered, checks for the valid Zip Code
                if (fieldsRequired.contains('Zip_Code_J2__c') && v.validateRequiredFields(app.Zip_Code_J2__c,'Zip Code')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Zip_Code_J2__c') && v.validateZip(app.Zip_Code_J2__c)) {
                    valid=false;
                }  
                 
                 // This checks if Years lived is entered or not, if yes then checks if years is less than 2, Previous address fields are filled or not
                if (fieldsRequired.contains('Years_J2__c') && v.validateRequiredFields(String.valueOf(app.Years_J2__c),'Years')) {
                    valid=false;
                }
                
                if (app.Years_J2__c<2) {
                    system.debug('Years is less than 2');
                    if (fieldsRequired.contains('Street_Address_1_JP2__c') && v.validateRequiredFields(app.Street_Address_1_JP2__c,'Previous Street Address 1')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('City_JP2__c') && v.validateRequiredFields(app.City_JP2__c,'Previous Address City')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('State_JP2__c') && v.validateRequiredFields(app.State_JP2__c,'Previous Address State')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_JP2__c') && v.validateRequiredFields(app.Zip_Code_JP2__c,'Previous Address Zip Code')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_JP2__c') && v.validateZip(app.Zip_Code_JP2__c)) {
                        valid=false;
                    }
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J2__c') && v.validateRequiredFields(app.Primary_Phone_Number_J2__c,'Phone Number')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J2__c') && v.validatePhone(app.Primary_Phone_Number_J2__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_J2__c') && v.validateRequiredFields(app.Secondary_Phone_Number_J2__c,'Work Phone')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (app.Secondary_Phone_Number_J2__c!=null) {
                    system.debug('Validating Phone Number');
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_J2__c') && v.validatePhone(app.Secondary_Phone_Number_J2__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Email_Address_J2__c') && v.validateRequiredFields(app.Email_Address_J2__c,'Email')) {
                    system.debug('checked Email Address');
                    valid=false;
                }
                if(fieldsRequired.contains('Email_Address_J2__c') && v.validateEmail(app.Email_Address_J2__c)){
                system.debug('Enter valid email');
                valid=false;
            }
            }
          
            // Third joint applicant
            if (app.Third_joint_applicant__c == true) {
                if (fieldsRequired.contains('First_Name_J3__c') && v.validateRequiredFields(app.First_Name_J3__c,'First Name') ) {
                    system.debug('checked First Name');
                    valid=false;
                }
                if (fieldsRequired.contains('Last_Name_J3__c') && v.validateRequiredFields(app.Last_Name_J3__c,'Last Name')) {
                    system.debug('checked Last Name');
                    valid=false;
                }
                if (fieldsRequired.contains('Street_Address_1_J3__c') && v.validateRequiredFields(app.Street_Address_1_J3__c,'Street Address 1')) {
                    system.debug('checked Street Address 1');
                    valid=false;
                }
                /*if (fieldsRequired.contains('Street_Address_2__c') && v.validateRequiredFields(app.Street_Address_2__c,'Street Address 2')) {
                    system.debug('checked Street Address 2');
                    valid=false;
                }*/
                if (fieldsRequired.contains('City_J3__c') && v.validateRequiredFields(app.City_J3__c,'City')) {
                    valid=false;
                }
                // It checks if the Zip code is entered, and if entered, checks for the valid Zip Code
                if (fieldsRequired.contains('Zip_Code_J3__c') && v.validateRequiredFields(app.Zip_Code_J3__c,'Zip Code')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Zip_Code_J3__c') && v.validateZip(app.Zip_Code_J3__c)) {
                    valid=false;
                }  
                 // This checks if Years lived is entered or not, if yes then checks if years is less than 2, Previous address fields are filled or not
                if (fieldsRequired.contains('Years_J3__c') && v.validateRequiredFields(String.valueOf(app.Years_J3__c),'Years')) {
                    valid=false;
                }
                if (app.Years_J3__c<2) {
                    system.debug('Years is less than 2');
                    if (fieldsRequired.contains('Street_Address_1_JP3__c') && v.validateRequiredFields(app.Street_Address_1_JP3__c,'Previous Street Address 1')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('City_JP3__c') && v.validateRequiredFields(app.City_JP3__c,'Previous Address City')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('State_JP3__c') && v.validateRequiredFields(app.State_JP3__c,'Previous Address State')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_JP3__c') && v.validateRequiredFields(app.Zip_Code_JP3__c,'Previous Address Zip Code')) {
                         valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_JP3__c') && v.validateZip(app.Zip_Code_JP3__c)) {
                        valid=false;
                    }
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J3__c') && v.validateRequiredFields(app.Primary_Phone_Number_J3__c,'Phone Number')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (fieldsRequired.contains('Primary_Phone_Number_J3__c') && v.validatePhone(app.Primary_Phone_Number_J3__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_JP3__c') && v.validateRequiredFields(app.Secondary_Phone_Number_JP3__c,'Work Phone')) {
                    system.debug('checked Phone Number');
                    valid=false;
                }
                if (app.Secondary_Phone_Number_JP3__c!=null) {
                    system.debug('Validating Phone Number');
                }
                if (fieldsRequired.contains('Secondary_Phone_Number_JP3__c') && v.validatePhone(app.Secondary_Phone_Number_JP3__c)) {
                    valid=false;
                }
                if (fieldsRequired.contains('Email_Address_J3__c') && v.validateRequiredFields(app.Email_Address_J3__c,'Email')) {
                    system.debug('checked Email Address');
                    valid=false;
                }
                if(fieldsRequired.contains('Email_Address_J3__c') && v.validateEmail(app.Email_Address_J3__c)){
                system.debug('Enter valid email');
                valid=false;
            }
            }
        } else if (pageName == Index.EMPLOYMENT_PAGE) {
            if (fieldsRequired.contains('Employment_Status__c') && v.validateRequiredFields(emp.employment_status__c, 'Employment Status')) {
                valid = false;                                      
            }
            if (emp.employment_status__c != 'Retired' && emp.employment_status__c != 'Unemployed') {
                if (fieldsRequired.contains('Years_Emp__c') && v.validateNumberRequiredFields(emp.years_emp__c, 'Employment Years')) {
                    valid = false;                                      
                }
            }
            if (emp.employment_status__c != 'Retired' && emp.employment_status__c != 'Unemployed') {
                if (fieldsRequired.contains('Employer__c') && v.validateRequiredFields(emp.employer__c, 'Employment Years')) {
                    valid = false;                                      
                }
            }
            if (emp.employment_status__c != 'Retired' && emp.employment_status__c != 'Unemployed') {
                if (fieldsRequired.contains('Occupation__c') && v.validateRequiredFields(emp.occupation__c, 'Employment Years')) {
                    valid = false;                                      
                }
            }
            if (emp.employment_status__c == 'Retired' || emp.employment_status__c == 'Unemployed') {
                if (fieldsRequired.contains('Prior_Occupation__c') && v.validateRequiredFields(emp.prior_occupation__c, 'Prior Occupation field')) {
                    valid = false;                                      
                }
            }
            if (fieldsRequired.contains('Annual_Income__c') && v.validateCurrencyRequiredFields(emp.annual_income__c, 'Annual Income')) {
                valid = false;                                      
            }
            if (app.first_joint_applicant__c == true) {
                if (fieldsRequired.contains('Employment_Status_J1__c') && v.validateRequiredFields(emp.employment_status_J1__c, ' Joint Applicant 1 Employment Status')) {
                    valid = false;                                      
                }
                if (emp.employment_status_J1__c != 'Retired' && emp.employment_status_J1__c != 'Unemployed') {
                    if (fieldsRequired.contains('Years_EmpJ1__c') && v.validateNumberRequiredFields(emp.years_empJ1__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J1__c != 'Retired' && emp.employment_status_J1__c != 'Unemployed') {
                    if (fieldsRequired.contains('Occupation_J1__c') && v.validateRequiredFields(emp.occupation_J1__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J1__c != 'Retired' && emp.employment_status_J1__c != 'Unemployed') {
                    if (fieldsRequired.contains('Employer_J1__c') && v.validateRequiredFields(emp.employer_J1__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J1__c == 'Retired' || emp.employment_status_J1__c == 'Unemployed') {
                    if (fieldsRequired.contains('Prior_Occupation_J1_c') && v.validateRequiredFields(emp.prior_occupation_J1__c, 'Prior Occupation field')) {
                        valid = false;                                      
                    }
                }
                if (fieldsRequired.contains('Annual_Income_J1__c') && v.validateCurrencyRequiredFields(emp.annual_income_J1__c, 'Annual Income')) {
                    valid = false;                                      
                }
            }
            if (app.second_joint_applicant__c == true) {
              
                if (fieldsRequired.contains('Employment_Status_J2__c') && v.validateRequiredFields(emp.employment_status_J2__c, 'Joint Applicant 2 Employment Status')) {
                    valid = false;                                      
                }
                if (emp.employment_status_J2__c != 'Retired' && emp.employment_status_J2__c != 'Unemployed') {
                    if (fieldsRequired.contains('Years_EmpJ2__c') && v.validateNumberRequiredFields(emp.years_empJ2__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J2__c != 'Retired' && emp.employment_status_J2__c != 'Unemployed') {
                    if (fieldsRequired.contains('Occupation_J2__c') && v.validateRequiredFields(emp.occupation_J2__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J2__c != 'Retired' && emp.employment_status_J2__c != 'Unemployed') {
                    if (fieldsRequired.contains('Employer_J2__c') && v.validateRequiredFields(emp.employer_J2__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J2__c == 'Retired' || emp.employment_status_J2__c == 'Unemployed') {
                    if (fieldsRequired.contains('Prior_Occupation_J2_c') && v.validateRequiredFields(emp.prior_occupation_J2__c, 'Prior Occupation field')) {
                        valid = false;                                      
                    }
                }
                if (fieldsRequired.contains('Annual_Income_J2__c') && v.validateCurrencyRequiredFields(emp.annual_income_J2__c, 'Annual Income')) {
                    valid = false;                                      
                }
            }
            if (app.third_joint_applicant__c == true) {
                if (fieldsRequired.contains('Employment_Status_J3__c') && v.validateRequiredFields(emp.employment_status_J3__c, 'Joint Applicant 3 Employment Status')) {
                    valid = false;                                      
                }
                if (emp.employment_status_J3__c != 'Retired' && emp.employment_status_J3__c != 'Unemployed') {
                    if (fieldsRequired.contains('Years_EmpJ3__c') && v.validateNumberRequiredFields(emp.years_empJ3__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J3__c != 'Retired' && emp.employment_status_J3__c != 'Unemployed') {
                    if (fieldsRequired.contains('Occupation_J3__c') && v.validateRequiredFields(emp.occupation_J3__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J3__c != 'Retired' && emp.employment_status_J3__c != 'Unemployed') {
                    if (fieldsRequired.contains('Employer_J3__c') && v.validateRequiredFields(emp.employer_J3__c, 'Employment Years')) {
                        valid = false;                                      
                    }
                }
                if (emp.employment_status_J3__c == 'Retired' || emp.employment_status_J3__c == 'Unemployed') {
                    if (fieldsRequired.contains('Prior_Occupation_J3_c') && v.validateRequiredFields(emp.prior_occupation_J3__c, 'Prior Occupation field')) {
                        valid = false;                                      
                    }
                }
                if (fieldsRequired.contains('Annual_Income_J3__c') && v.validateCurrencyRequiredFields(emp.annual_income_J3__c, 'Annual Income')) {
                    valid = false;                                      
                }
            }
        } else if (pageName == Index.IDENTITY_PAGE) {
            if (fieldsRequired.contains('Identity_Number_Primary__c') && v.validateRequiredFields(iden.identity_number_primary__c,'ID Number')) {
                valid = false;                                      
            }
            if (fieldsRequired.contains('Expiry_Date__c') && v.validateRequiredFields(iden.expiry_date__c,'Expiry Date')) {
                valid = false;                                      
            }
            if (fieldsRequired.contains('SSN_Prime__c') && v.validateRequiredFields(iden.ssn_prime__c,'SSN')) {
                valid = false;                                      
            }
            if (fieldsRequired.contains('Date_Of_Birth__c') && v.validateRequiredFields(iden.date_of_birth__c,'Date of Birth')) {
                valid = false;                                      
            }
            if (app.first_joint_applicant__c == true) {
                if (fieldsRequired.contains('Identity_Number_J1__c') && v.validateRequiredFields(iden.identity_number_J1__c,'ID Number')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Expiry_Date_J1__c') && v.validateRequiredFields(iden.expiry_date_J1__c,'Expiry Date')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('SSN_J1__c') && v.validateRequiredFields(iden.ssn_J1__c,'SSN')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Date_Of_Birth_J1__c') && v.validateRequiredFields(iden.date_of_birth_J1__c,'Date of Birth')) {
                    valid = false;                                      
                }
            }
            if (app.second_joint_applicant__c == true) {
                if (fieldsRequired.contains('Identity_Number_J2__c') && v.validateRequiredFields(iden.identity_number_J2__c,'ID Number')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Expiry_Date_J2__c') && v.validateRequiredFields(iden.expiry_date_J2__c,'Expiry Date')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('SSN_J2__c') && v.validateRequiredFields(iden.ssn_J2__c,'SSN')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Date_Of_Birth_J2__c') && v.validateRequiredFields(iden.date_of_birth_J2__c,'Date of Birth')) {
                    valid = false;                                      
                }
            }
            if (app.third_joint_applicant__c == true) {
                if (fieldsRequired.contains('Identity_Number_J3__c') && v.validateRequiredFields(iden.identity_number_J3__c,'ID Number')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Expiry_Date_J3__c') && v.validateRequiredFields(iden.expiry_date_J3__c,'Expiry Date')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('SSN_J3__c') && v.validateRequiredFields(iden.ssn_J3__c,'SSN')) {
                    valid = false;                                      
                }
                if (fieldsRequired.contains('Date_Of_Birth_J3__c') && v.validateRequiredFields(iden.date_of_birth_J3__c,'Date of Birth')) {
                    valid = false;                                      
                }
            }
        } else if (pageName == Index.ACCOUNT_DETAILS_PAGE) {
            Customer__c customer = null;
            List<Customer_Account__c> cusAccount = new List<Customer_Account__c>();
            if (app.Customer__c != null) {
                customer = [SELECT id FROM Customer__c WHERE id = :app.Customer__c];
            }
            if (customer != null) {
                cusAccount = [SELECT id,Account_Number__c,Balance__c,Product__c,Sub_Product__c FROM Customer_Account__c WHERE Customer__c = :customer.id];
            }
            system.debug('Came to validate Account Details');
            if (fieldsRequired.contains('Account_Holder_Name_CHK__c')) {
                if (fieldsRequired.contains('Funding_Type_CHK__c') && v.validateRequiredFields(acc.funding_type_chk__c,'Funding Type for Checking Account')) {
                    system.debug('Came to check funding type for checking');
                    valid=false;
                }
                if (acc.funding_type_chk__c == 'Add External Accounts') {
                    if (fieldsRequired.contains('Financial_Institution_CHK__c') && v.validateRequiredFields(acc.Financial_Institution_CHK__c,'Bank Name for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('Dollar_Amount_External_CHK__c') && v.validateCurrencyRequiredFields(acc.Dollar_Amount_External_CHK__c,'Dollar Amount for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('Routing_Number_CHK__c') && v.validateRequiredFields(acc.Routing_Number_CHK__c,'Routing Number for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('Routing_Number_CHK__c') && v.validateRoutingNumber(acc.Routing_Number_CHK__c,'Routing Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    } 
                    if (fieldsRequired.contains('Account_type_FI_CHK__c') && v.validateRequiredFields(acc.Account_type_FI_CHK__c,'Account Type for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CHK_Account_Number__c') && v.validateRequiredFields(acc.CHK_Account_Number__c,'Account Number for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CHK_Account_Number__c') && v.validateAccountNumber(acc.CHK_Account_Number__c,'Account Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('Disclosure_AccountDetails_chk__c') && v.validateCheckBoxRequiredFields(acc.Disclosure_AccountDetails_chk__c,'Checking Account Disclosure')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues(app.Type_of_Checking__c.split('-',2).get(1));
                    if (dv != null) {
                        system.debug('Maximum value for CHecking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for CHecking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for CHecking is '+acc.Dollar_Amount_External_CHK__c);
                        if (acc.Dollar_Amount_External_CHK__c>dv.Maximum_Amount__c || acc.Dollar_Amount_External_CHK__c<dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_CHK__c == 'Internal Accounts'){
                    if (fieldsRequired.contains('Select_Account_FI_CHK__c') && v.validateRequiredFields(acc.select_account_fi_chk__c,'Funding Account for Checking Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('CHK_Funding_Amount_From_Internal_Account__c') && v.validateCurrencyRequiredFields(acc.chk_funding_amount_from_internal_account__c,'Dollar Amount for Checking Account')) {
                        valid=false;
                    }
                    system.debug('terafina account selected is '+acc.select_account_fi_chk__c);
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.Select_Account_FI_CHK__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.CHK_Funding_Amount_From_Internal_Account__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                } else if(acc.Funding_Type_CHK__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for Checking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Checking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Checking is '+acc.Dollar_Amount_CHK_Cash__c);
                        if (acc.Dollar_Amount_CHK_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_CHK_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_CHK__c == 'Check') {
                    if (fieldsRequired.contains('CHK_Check_Routing_Number__c') && v.validateRequiredFields(acc.CHK_Check_Routing_Number__c,'Routing Number for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CHK_Check_Routing_Number__c') && v.validateRoutingNumber(acc.CHK_Check_Routing_Number__c,'Routing Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CHK_Check_Account_Number__c') && v.validateRequiredFields(acc.CHK_Check_Account_Number__c,'Account Number for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CHK_Check_Account_Number__c') && v.validateAccountNumber(acc.CHK_Check_Account_Number__c,'Account Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for Checking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Checking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Checking is '+acc.Dollar_Amount_CHK_Check__c);
                        if (acc.Dollar_Amount_CHK_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_CHK_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }
            }
            // validation for SMALL BUSINESS CHECKING PRODUCT
            if (app.Type_Of_Business_Checking__c != null) {
                if (fieldsRequired.contains('Funding_Type_BUS_CHK__c') && v.validateRequiredFields(acc.Funding_Type_BUS_CHK__c,'Funding Type for Checking Account')) {
                    system.debug('Came to check funding type for checking');
                    valid=false;
                }
                if (acc.Funding_Type_BUS_CHK__c == 'Add External Accounts') {
                    if (fieldsRequired.contains('financial_institution_bus_chk__c') && v.validateRequiredFields(acc.financial_institution_bus_chk__c,'Bank Name for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('dollar_amount_external_bus_chk__c') && v.validateCurrencyRequiredFields(acc.dollar_amount_external_bus_chk__c,'Dollar Amount for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('routing_number_bus_chk__c') && v.validateRequiredFields(acc.routing_number_bus_chk__c,'Routing Number for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('routing_number_bus_chk__c') && v.validateRoutingNumber(acc.routing_number_bus_chk__c,'Routing Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    } 
                    if (fieldsRequired.contains('account_type_fi_bus_chk__c') && v.validateRequiredFields(acc.account_type_fi_bus_chk__c,'Account Type for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('bus_chk_account_number__c') && v.validateRequiredFields(acc.bus_chk_account_number__c,'Account Number for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('bus_chk_account_number__c') && v.validateAccountNumber(acc.bus_chk_account_number__c,'Account Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('disclosure_accountdetails_bus_chk__c') && v.validateCheckBoxRequiredFields(acc.disclosure_accountdetails_bus_chk__c,'Checking Account Disclosure')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues(app.Type_Of_Business_Checking__c.split('-',2).get(1));
                    if (dv != null) {
                        system.debug('Maximum value for CHecking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for CHecking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for CHecking is '+acc.dollar_amount_external_bus_chk__c);
                        if (acc.dollar_amount_external_bus_chk__c>dv.Maximum_Amount__c || acc.dollar_amount_external_bus_chk__c<dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_BUS_CHK__c == 'Internal Accounts') {
                    if (fieldsRequired.contains('select_account_fi_bus_chk__c') && v.validateRequiredFields(acc.select_account_fi_bus_chk__c,'Funding Account for Checking Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Dollar_Amount_Internal_Bus_CHK__c') && v.validateCurrencyRequiredFields(acc.Dollar_Amount_Internal_Bus_CHK__c,'Dollar Amount for Checking Account')) {
                        valid=false;
                    }
                    system.debug('terafina account selected is '+acc.select_account_fi_bus_chk__c);
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.select_account_fi_bus_chk__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.Dollar_Amount_Internal_Bus_CHK__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                } else if(acc.Funding_Type_BUS_CHK__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for CHecking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for CHecking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for CHecking is '+acc.Dollar_Amount_BUSICHK_Cash__c);
                        if (acc.Dollar_Amount_BUSICHK_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSICHK_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_BUS_CHK__c == 'Check') {
                    if (fieldsRequired.contains('BUSICHK_Check_Routing_Number__c') && v.validateRequiredFields(acc.BUSICHK_Check_Routing_Number__c,'Routing Number for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICHK_Check_Routing_Number__c') && v.validateRoutingNumber(acc.BUSICHK_Check_Routing_Number__c,'Routing Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICHK_Check_Account_Number__c') && v.validateRequiredFields(acc.BUSICHK_Check_Account_Number__c,'Account Number for funding Checking Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICHK_Check_Account_Number__c') && v.validateAccountNumber(acc.BUSICHK_Check_Account_Number__c,'Account Number in Funding Info for Checking Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for CHecking is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for CHecking is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for CHecking is '+acc.Dollar_Amount_BUSICHK_Check__c);
                        if (acc.Dollar_Amount_BUSICHK_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSICHK_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Checking Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }
            }    
                
            // Funding Info for Savings Account
            if (fieldsRequired.contains('Account_Holder_Name_SAV__c')) {
                if (fieldsRequired.contains('Funding_Type_SAV__c') && v.validateRequiredFields(acc.funding_type_sav__c,'Funding Type for Savings Account')) {
                    valid=false; 
                }  
                if (acc.funding_type_sav__c == 'Add External Accounts') {
                    if (fieldsRequired.contains('Financial_Institution_SAV__c') && v.validateRequiredFields(acc.financial_institution_sav__c,'Bank Name')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Routing_Number_Sav__c') && v.validateRequiredFields(acc.routing_number_sav__c,'Routing Number')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Routing_Number_Sav__c') && v.validateRoutingNumber(acc.routing_number_sav__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;
                    } 
                    if (fieldsRequired.contains('Account_Type_FI_Sav__c') && v.validateRequiredFields(acc.account_type_fi_sav__c,'Account Type')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('SAV_Account_Number__c') && v.validateRequiredFields(acc.sav_account_number__c,'Account Number for funding Savings Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('SAV_Account_Number__c') && v.validateAccountNumber(acc.sav_account_number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;
                    }                              
                                   
                    if (fieldsRequired.contains('Dollar_Amount_External_SAV__c') && v.validateCurrencyRequiredFields(acc.dollar_amount_external_sav__c,'Savings Amount')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Disclosure_AccountDetails_SAV__c') && v.validateCheckBoxRequiredFields(acc.disclosure_accountdetails_sav__c,'Savings Account Disclosure')) {
                        valid=false;
                    }
                } else if(acc.Funding_Type_SAV__c == 'Internal Accounts'){
                    if (fieldsRequired.contains('Select_Account_FI_SAV__c') && v.validateRequiredFields(acc.select_account_fi_sav__c,'Internal Funding Account  for Savings Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('SAV_Funding_Amount_From_Internal_Account__c') && v.validateCurrencyRequiredFields(acc.sav_funding_amount_from_internal_account__c,'Savings Amount')) {
                        valid=false;
                    }
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.Select_Account_FI_SAV__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.SAV_Funding_Amount_From_Internal_Account__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                } else if(acc.Funding_Type_SAV__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_SAV_Cash__c);
                        if (acc.Dollar_Amount_SAV_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_SAV_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_SAV__c == 'Check') {
                    if (fieldsRequired.contains('SAV_Check_Routing_Number__c') && v.validateRequiredFields(acc.SAV_Check_Routing_Number__c,'Routing Number for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('SAV_Check_Routing_Number__c') && v.validateRoutingNumber(acc.SAV_Check_Routing_Number__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('SAV_Check_Account_Number__c') && v.validateRequiredFields(acc.SAV_Check_Account_Number__c,'Account Number for funding Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('SAV_Check_Account_Number__c') && v.validateAccountNumber(acc.SAV_Check_Account_Number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_SAV_Check__c);
                        if (acc.Dollar_Amount_SAV_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_SAV_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }   
            } // End of fields validation for Savings account funding info

            //Field validation for Small Business Savings Products
            if (app.Type_Of_Business_Savings__c != null) {
                if (fieldsRequired.contains('funding_type_bus_sav__c') && v.validateRequiredFields(acc.funding_type_bus_sav__c,'Funding Type for Savings Account')) {
                    valid=false; 
                }  
                if (acc.funding_type_bus_sav__c == 'Add External Accounts') {
                    if (fieldsRequired.contains('financial_institution_bus_sav__c') && v.validateRequiredFields(acc.financial_institution_bus_sav__c,'Bank Name')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('routing_number_bus_sav__c') && v.validateRequiredFields(acc.routing_number_bus_sav__c,'Routing Number')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('routing_number_bus_sav__c') && v.validateRoutingNumber(acc.routing_number_bus_sav__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;
                    } 
                    if (fieldsRequired.contains('account_type_fi_bus_sav__c') && v.validateRequiredFields(acc.account_type_fi_bus_sav__c,'Account Type')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('bus_sav_account_number__c') && v.validateRequiredFields(acc.bus_sav_account_number__c,'Account Number for funding Savings Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('bus_sav_account_number__c') && v.validateAccountNumber(acc.bus_sav_account_number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;
                    }                              
                                   
                    if (fieldsRequired.contains('dollar_amount_external_bus_sav__c') && v.validateCurrencyRequiredFields(acc.dollar_amount_external_bus_sav__c,'Savings Amount')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('disclosure_accountdetails_bus_sav__c') && v.validateCheckBoxRequiredFields(acc.disclosure_accountdetails_bus_sav__c,'Savings Account Disclosure')) {
                        valid=false;
                    }
                }  else if(acc.Funding_Type_BUS_SAV__c == 'Internal Accounts') {
                    if (fieldsRequired.contains('select_account_fi_bus_sav__c') && v.validateRequiredFields(acc.select_account_fi_bus_sav__c,'Funding Account for Checking Account')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Dollar_Amount_Internal_Bus_SAV__c') && v.validateCurrencyRequiredFields(acc.Dollar_Amount_Internal_Bus_SAV__c,'Dollar Amount for Checking Account')) {
                        valid=false;
                    }
                    system.debug('terafina account selected is '+acc.select_account_fi_bus_sav__c);
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.select_account_fi_bus_sav__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.Dollar_Amount_Internal_Bus_SAV__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                } else if(acc.Funding_Type_BUS_SAV__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_BUSISAV_Cash__c);
                        if (acc.Dollar_Amount_BUSISAV_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSISAV_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_BUS_SAV__c == 'Check') {
                    if (fieldsRequired.contains('BUSISAV_Check_Routing_Number__c') && v.validateRequiredFields(acc.BUSISAV_Check_Routing_Number__c,'Routing Number for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSISAV_Check_Routing_Number__c') && v.validateRoutingNumber(acc.BUSISAV_Check_Routing_Number__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSISAV_Check_Account_Number__c') && v.validateRequiredFields(acc.BUSISAV_Check_Account_Number__c,'Account Number for funding Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSISAV_Check_Account_Number__c') && v.validateAccountNumber(acc.BUSISAV_Check_Account_Number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_BUSISAV_Check__c);
                        if (acc.Dollar_Amount_BUSISAV_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSISAV_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }  
            }
            // End of Field validation for Small Business Savings Products

            // Fields validation for funding info of Certificates          
            if (fieldsToDisplay.contains('Account_Holder_Name_CERT__c')) {
                if (fieldsRequired.contains('Funding_Type_CERT__c') && v.validateRequiredFields(acc.Funding_Type_CERT__c,'Funding Type for Certificates')) {
                    valid=false;
                }  
                if (acc.Funding_Type_CERT__c=='Add External Accounts') {
                    if (fieldsRequired.contains('Financial_Institution_CERT__c') && v.validateRequiredFields(acc.Financial_Institution_CERT__c,'Certififcates Bank Name')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('Routing_Number_Cert__c') && v.validateRequiredFields(acc.Routing_Number_Cert__c,'Certififcates Routing Number')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('Routing_Number_Cert__c') && v.validateRoutingNumber(acc.Routing_Number_Cert__c,'Routing Number in Funding Info for Certificates')) {
                               valid=false;
                    } 
                    if (fieldsRequired.contains('Account_Type_FI_Cert__c') && v.validateRequiredFields(acc.Account_Type_FI_Cert__c,'Certififcates Account Type')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('CERT_Account_Number__c') && v.validateRequiredFields(acc.CERT_Account_Number__c,'Certififcates Account Number')) {
                       valid=false;
                    } 
                    if (fieldsRequired.contains('CERT_Account_Number__c') && v.validateAccountNumber(acc.CERT_Account_Number__c,'Account Number in Funding Info for Certificates')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('Dollar_Amount_External_CERT__c') && v.validateCurrencyRequiredFields(acc.Dollar_Amount_External_CERT__c,'Certificate Amount')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('Disclosure_AccountDetails_CERT__c') && v.validateCheckBoxRequiredFields(acc.Disclosure_AccountDetails_CERT__c,'Certificate Disclosure')) {
                       valid=false;
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues(app.Type_of_Certificates__c.split('-',5).get(1));
                    if (dv != null) {
                        if (acc.Dollar_Amount_External_Cert__c>dv.Maximum_Amount__c || acc.Dollar_Amount_External_Cert__c<dv.Minimum_Amount__c) {
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Funding Dollar amount in Certificates must be equal to $500');
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if (acc.Funding_Type_CERT__c=='Internal Accounts') {
                    if (fieldsRequired.contains('Select_Account_FI_CERT__c') && v.validateRequiredFields(acc.Select_Account_FI_CERT__c,'Internal Funding Account for Certificates')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('CERT_Funding_Amt_From_Internal_Account__c') && v.validateCurrencyRequiredFields(acc.CERT_Funding_Amt_From_Internal_Account__c,'Certificate Amount')) {
                        valid=false;
                    }
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.Select_Account_FI_CERT__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.CERT_Funding_Amt_From_Internal_Account__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                } else if(acc.Funding_Type_CERT__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_CERT_Cash__c);
                        if (acc.Dollar_Amount_CERT_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_CERT_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_CERT__c == 'Check') {
                    if (fieldsRequired.contains('CERT_Check_Routing_Number__c') && v.validateRequiredFields(acc.CERT_Check_Routing_Number__c,'Routing Number for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CERT_Check_Routing_Number__c') && v.validateRoutingNumber(acc.CERT_Check_Routing_Number__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CERT_Check_Account_Number__c') && v.validateRequiredFields(acc.CERT_Check_Account_Number__c,'Account Number for funding Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('CERT_Check_Account_Number__c') && v.validateAccountNumber(acc.CERT_Check_Account_Number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_CERT_Check__c);
                        if (acc.Dollar_Amount_CERT_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_CERT_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }
            } // end of validation certificates funding info 

            //Field Validation for Small business CDs product
            if (app.Type_Of_Business_CDs__c!=null) {
                if (fieldsRequired.contains('funding_type_bus_cds__c') && v.validateRequiredFields(acc.funding_type_bus_cds__c,'Funding Type for Certificates')) {
                    valid=false;
                }  
                if (acc.funding_type_bus_cds__c=='Add External Accounts') {
                    if (fieldsRequired.contains('financial_institution_bus_cds__c') && v.validateRequiredFields(acc.financial_institution_bus_cds__c,'Certififcates Bank Name')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('routing_number_bus_cds__c') && v.validateRequiredFields(acc.routing_number_bus_cds__c,'Certififcates Routing Number')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('routing_number_bus_cds__c') && v.validateRoutingNumber(acc.routing_number_bus_cds__c,'Routing Number in Funding Info for Certificates')) {
                               valid=false;
                    } 
                    if (fieldsRequired.contains('account_type_fi_bus_cds__c') && v.validateRequiredFields(acc.account_type_fi_bus_cds__c,'Certififcates Account Type')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('bus_cds_account_number__c') && v.validateRequiredFields(acc.bus_cds_account_number__c,'Certififcates Account Number')) {
                       valid=false;
                    } 
                    if (fieldsRequired.contains('bus_cds_account_number__c') && v.validateAccountNumber(acc.bus_cds_account_number__c,'Account Number in Funding Info for Certificates')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('dollar_amount_external_bus_cds__c') && v.validateCurrencyRequiredFields(acc.dollar_amount_external_bus_cds__c,'Certificate Amount')) {
                       valid=false;
                    }
                    if (fieldsRequired.contains('disclosure_accountdetails_bus_cds__c') && v.validateCheckBoxRequiredFields(acc.disclosure_accountdetails_bus_cds__c,'Certificate Disclosure')) {
                       valid=false;
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues(app.Type_Of_Business_CDs__c.split('-',5).get(1));
                    if (dv != null) {
                        if (acc.dollar_amount_external_bus_cds__c>dv.Maximum_Amount__c || acc.dollar_amount_external_bus_cds__c<dv.Minimum_Amount__c) {
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Funding Dollar amount in Certificates must be equal to $500');
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if (acc.funding_type_bus_cds__c=='Internal Accounts') {
                    if (fieldsRequired.contains('select_account_fi_bus_cds__c') && v.validateRequiredFields(acc.select_account_fi_bus_cds__c,'Internal Funding Account for Certificates')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Dollar_Amount_Internal_Bus_CERT__c') && v.validateCurrencyRequiredFields(acc.Dollar_Amount_Internal_Bus_CERT__c,'Certificate Amount')) {
                        valid=false;
                    }
                    for(Customer_Account__c ca : cusAccount){
                        if(acc.select_account_fi_bus_cds__c.contains(String.valueOf(ca.Account_Number__c))){
                            if(acc.Dollar_Amount_Internal_Bus_CERT__c > ca.Balance__c){
                                valid=false;                                
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please enter an amount that is less than your balance i.e. $'+ ca.Balance__c);
                                ApexPages.addMessage(msg);    
                            }
                        }
                    }
                 } else if(acc.Funding_Type_BUS_CDS__c == 'Cash') {
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Cash');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_BUSICDS_Cash__c);
                        if (acc.Dollar_Amount_BUSICDS_Cash__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSICDS_Cash__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Savings Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                } else if(acc.Funding_Type_BUS_CDS__c == 'Check') {
                    if (fieldsRequired.contains('BUSICDS_Check_Routing_Number__c') && v.validateRequiredFields(acc.BUSICDS_Check_Routing_Number__c,'Routing Number for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICDS_Check_Routing_Number__c') && v.validateRoutingNumber(acc.BUSICDS_Check_Routing_Number__c,'Routing Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICDS_Check_Account_Number__c') && v.validateRequiredFields(acc.BUSICDS_Check_Account_Number__c,'Account Number for funding Savings Account')) {
                        valid=false;                                
                    }
                    if (fieldsRequired.contains('BUSICDS_Check_Account_Number__c') && v.validateAccountNumber(acc.BUSICDS_Check_Account_Number__c,'Account Number in Funding Info for Savings Account')) {
                        valid=false;                                
                    }
                    Deposit_Amount_Validation__c dv=Deposit_Amount_Validation__c.getValues('Dollar Validation Check');
                    if (dv != null) {
                        system.debug('Maximum value for Savings is '+dv.Maximum_Amount__c);
                        system.debug('Minimum value for Savings is '+dv.Minimum_Amount__c);
                        system.debug('Enetred value for Savings is '+acc.Dollar_Amount_BUSICDS_Check__c);
                        if (acc.Dollar_Amount_BUSICDS_Check__c>dv.Maximum_Amount__c || acc.Dollar_Amount_BUSICDS_Check__c <dv.Minimum_Amount__c) {
                            valid=false;                                
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Dollar Amount in Certificate Account should be between $'+dv.Minimum_Amount__c+' and $'+dv.Maximum_Amount__c);
                            ApexPages.addMessage(msg);
                        } 
                    }
                }    
            }
            // End of Field Validation for Small business CDs product
             
            // Loan Info for Vehicle Loan
            if (fieldsToDisplay.contains('Requested_Loan_Amount_VehicleLoans__c')) { 
                system.debug('Came to validate Vehicle loans');   
                if( fieldsRequired.contains('Requested_Loan_Amount_VehicleLoans__c') && v.validateCurrencyRequiredFields(acc.Requested_Loan_Amount_VehicleLoans__c,'Vehicle Loan Amount')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Term_VehicleLoans__c') && v.validateNumberRequiredFields(acc.Term_VehicleLoans__c,'Term for Vehicle Loans')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Purpose_VehicleLoan__c') && v.validateRequiredFields(acc.Purpose_VehicleLoan__c,'Purpose in Vehicle Loan section')) {
                    valid=false;
                }
                if (acc.Purpose_VehicleLoan__c=='Other' && v.validateRequiredFields(acc.OtherPurpose_VehicleLoans__c,'If you have other purpose,other Purpose in Vehicle Loan section')) {
                    valid=false;
                }

                if (!validateVehiclePurposeVechicleCollateral(acc,fieldsRequired,fieldsToDisplay)) {
                    valid=false;
                }
            }  // end if validation of vehicle Loan fields  
              
            // Loan Info for Personal Loan
            if (fieldsToDisplay.contains('Requested_Loan_Amount_PersonalLoans__c')) {
                if (fieldsRequired.contains('Requested_Loan_Amount_PersonalLoans__c') && v.validateCurrencyRequiredFields(acc.Requested_Loan_Amount_PersonalLoans__c,'Personal Loan Amount')) {
                    valid=false;
                }
                system.debug('Personal term is '+fieldsRequired.contains('Term_Personalloans__c'));
                if (fieldsRequired.contains('Term_Personalloans__c') && v.validateNumberRequiredFields(acc.Term_Personalloans__c,'Term for Personal Loans')) {
                    system.debug('came to check personal select');
                    valid=false;
                }
                if (fieldsRequired.contains('Purpose_PersonalLoans__c')&& v.validateRequiredFields(acc.Purpose_PersonalLoans__c, 'Purpose for Personal Loans')) {
                    valid=false;
                }
                if (acc.Purpose_PersonalLoans__c=='Debt Consolidation' && v.validateRequiredFields(acc.Debt_Consolidation_Personal_Loan__c,'Debt Consolidation Purpose for Personal Loan')) {
                    valid=false;
                }
                if (acc.Purpose_PersonalLoans__c=='Other' && v.validateRequiredFields(acc.OtherPurpose_PersonalLoans__c,'If you have other purpose,other Purpose in Personal Loan section')) {
                    valid=false;
                }
            } // end of validation of personal loan fields
              
            // Loan Info for Personal Loan -Personal Line of Credit             
            if (fieldsToDisplay.contains('Requested_Credit_Limit_PersonalLoans__c')) {
                if (fieldsRequired.contains('Requested_Credit_Limit_PersonalLoans__c') && v.validateCurrencyRequiredFields(acc.Requested_Credit_Limit_PersonalLoans__c,'Personal Credit Limit Amount')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Purpose_PersonalLoans__c')&& v.validateRequiredFields(acc.Purpose_PersonalLoans__c, 'Purpose for Personal Loans')) {
                    valid=false;
                }
                if (acc.Purpose_PersonalLoans__c=='Debt Consolidation' && v.validateRequiredFields(acc.Debt_Consolidation_Personal_Loan__c,'Debt Consolidation Purpose for Personal Loan')) {
                    valid=false;
                }
                if (acc.Purpose_PersonalLoans__c=='Other' && v.validateRequiredFields(acc.OtherPurpose_PersonalLoans__c,'If you have other purpose,other Purpose in Personal Loan section')) {
                    valid=false;
                }
            } // end of validation of personal line of credit fields
             
            //Loan Info Validation for Small Business Loans section
            if (app.Type_Of_Business_Loans__c!=null) {
                if (fieldsRequired.contains('requested_loan_amount_businessloans__c') && v.validateCurrencyRequiredFields(acc.requested_loan_amount_businessloans__c,'Personal Loan Amount')) {
                    valid=false;
                }
                system.debug('Personal term is '+fieldsRequired.contains('Term_Personalloans__c'));
                if (fieldsRequired.contains('term_businessloans__c') && v.validateNumberRequiredFields(acc.term_businessloans__c,'Term for Personal Loans')) {
                    system.debug('came to check personal select');
                    valid=false;
                }
                if (fieldsRequired.contains('purpose_businessloans__c')&& v.validateRequiredFields(acc.purpose_businessloans__c, 'Purpose for Personal Loans')) {
                    valid=false;
                }
                if (acc.purpose_businessloans__c=='Debt Consolidation' && v.validateRequiredFields(acc.debt_consolidation_business_loan__c,'Debt Consolidation Purpose for Personal Loan')) {
                    valid=false;
                }
                if (acc.purpose_businessloans__c=='Other' && v.validateRequiredFields(acc.otherpurpose_businessloans__c,'If you have other purpose,other Purpose in Personal Loan section')) {
                    valid=false;
                }
            }
            //End of Loan Info Validation for Small Business Loans section

            //Loan info for Credit Card 
            if (fieldsToDisplay.contains('Requested_Credit_Limit_Ccards__c')) {  
                if (fieldsRequired.contains('Requested_Credit_Limit_Ccards__c') && v.validateCurrencyRequiredFields(acc.Requested_Credit_Limit_Ccards__c,'Credit Amount')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Purpose_Ccards__c') && v.validateRequiredFields(acc.Purpose_Ccards__c,'Purpose in Credit Card section')) {
                    valid=false;
                }
                if (acc.Purpose_Ccards__c=='Other' && v.validateRequiredFields(acc.OtherPurpose_Ccards__c,'If you have other purpose,other Purpose in Credit Card section')) {
                    valid=false;
                }
                if (acc.Purpose_Ccards__c=='Debt Consolidation' && v.validateRequiredFields(acc.Debt_Consolidation_Credit_Card__c,'Debt Consolidation Purpose for Credit Cards')) {
                    valid=false;
                } 
            }  // end of validation of Credit card funding fields

            // Loan Info Validation for Small Business credit card
            if (app.Type_Of_Business_Credit_Cards__c!=null) {  
                if (fieldsRequired.contains('requested_credit_limit_Bus_ccards__c') && v.validateCurrencyRequiredFields(acc.requested_credit_limit_Bus_ccards__c,'Credit Amount')) {
                    valid=false;
                }
                if (fieldsRequired.contains('purpose_bus_ccards__c') && v.validateRequiredFields(acc.purpose_bus_ccards__c,'Purpose in Credit Card section')) {
                    valid=false;
                }
                if (acc.purpose_bus_ccards__c=='Other' && v.validateRequiredFields(acc.otherpurpose_bus_ccards__c,'If you have other purpose,other Purpose in Credit Card section')) {
                    valid=false;
                }
                if (acc.purpose_bus_ccards__c=='Debt Consolidation' && v.validateRequiredFields(acc.debt_consolidation_bus_credit_card__c,'Debt Consolidation Purpose for Credit Cards')) {
                    valid=false;
                } 
            }
            //End of Loan Info Validation for Small Business credit card              
              
            // Stock Collateral
            if (fieldsToDisplay.contains('Stock_Symbols__c')) {
                if (fieldsRequired.contains('Stock_Symbols__c') && v.validateRequiredFields(acc.Stock_Symbol_1__c,'Stock Symbol')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Stock_Symbols__c') && v.validateNumberRequiredFields(acc.NumOfShares_1__c,'Number of Stock Shares')) {
                    valid=false;
                }
            }
               
            // Other Information Primary Applicant
            if (fieldsToDisplay.contains('OIAU_Q1_PA__c')) {
                if (acc.OIAU_Q1_PA__c==true && v.validateRequiredFields(acc.OIAU_Q1_Explanation_PA__c,'Other information question 1 Primary applicant')) {
                    valid=false;
                }
                if (acc.OIAU_Q2_PA__c==true && v.validateRequiredFields(acc.OIAU_Q2_Explanation_PA__c,'Other information question 2 Primary applicant')) {
                    valid=false;
                }
                if (acc.OIAU_Q3_PA__c==true && v.validateRequiredFields(acc.OIAU_Q3_Explanation_PA__c,'Other information question 3 Primary applicant')) {
                    valid=false;
                }
            }   
            //  Other Information Joint  Applicant 1
            if (fieldsToDisplay.contains('OIAU_Q1_J1__c') && app.First_Joint_Applicant__c==true) {
                if (acc.OIAU_Q1_J1__c==true && v.validateRequiredFields(acc.OIAU_Q1_Explanation_J1__c,'Other information question 1 joint applicant 1')) {
                    valid=false;
                }
                if (acc.OIAU_Q2_J1__c==true && v.validateRequiredFields(acc.OIAU_Q2_Explanation_J1__c,'Other information question 2 Joint applicant 1')) {
                    valid=false;
                }
                if (acc.OIAU_Q3_J1__c==true && v.validateRequiredFields(acc.OIAU_Q3_Explanation_J1__c,'Other information question 3 Joint applicant 1')) {
                    valid=false;
                }
            }
            //  Other Information Joint  Applicant 2
            if (fieldsToDisplay.contains('OIAU_Q1_J2__c') && app.Second_Joint_Applicant__c==true) {
                if (acc.OIAU_Q1_J2__c==true && v.validateRequiredFields(acc.OIAU_Q1_Explanation_J2__c,'Other information question 1 Joint applicant 2')) {
                    valid=false;
                }
                if (acc.OIAU_Q2_J2__c==true && v.validateRequiredFields(acc.OIAU_Q2_Explanation_J2__c,'Other information question 2 Joint applicant 2')) {
                    valid=false;
                }
                if (acc.OIAU_Q3_J2__c==true && v.validateRequiredFields(acc.OIAU_Q3_Explanation_J2__c,'Other information question 3 Joint applicant 2')) {
                    valid=false;
                }
            } 

            //  Other Information Joint  Applicant 3
            if (fieldsToDisplay.contains('OIAU_Q1_J3__c') && app.Third_Joint_Applicant__c==true) {
                if (acc.OIAU_Q1_J3__c==true && v.validateRequiredFields(acc.OIAU_Q1_Explanation_J3__c,'Other information question 1 Joint applicant 3')) {
                    valid=false;
                }
                if (acc.OIAU_Q2_J3__c==true && v.validateRequiredFields(acc.OIAU_Q2_Explanation_J3__c,'Other information question 2 Joint applicant 3')) {
                    valid=false;
                }
                if (acc.OIAU_Q3_J3__c==true && v.validateRequiredFields(acc.OIAU_Q3_Explanation_J3__c,'Other information question 3 Joint applicant 3')) {
                    valid=false;
                }
            }
            Integer chkFundingAmt = 0;
            Integer savFundingAmt = 0;
            Integer certFundingAmt = 0;
            Integer totalAmount = 0;
            if(acc.CHK_Funding_Amount_From_Internal_Account__c != null){
                chkFundingAmt = Integer.valueOf(acc.CHK_Funding_Amount_From_Internal_Account__c);
            }
            if(acc.SAV_Funding_Amount_From_Internal_Account__c != null){
                savFundingAmt = Integer.valueOf(acc.SAV_Funding_Amount_From_Internal_Account__c);
            }  
            if(acc.CERT_Funding_Amt_From_Internal_Account__c != null){
                certFundingAmt = Integer.valueOf(acc.CERT_Funding_Amt_From_Internal_Account__c);
            }
            totalAmount = chkFundingAmt+savFundingAmt+certFundingAmt;
            for(Customer_Account__c ca : cusAccount){
                if( (acc.Select_Account_FI_CHK__c != null && ca.Account_Number__c == acc.Select_Account_FI_CHK__c.substringAfter('@')) && (acc.Select_Account_FI_SAV__c != null && ca.Account_Number__c == acc.Select_Account_FI_SAV__c.substringAfter('@')) && (acc.Select_Account_FI_CERT__c != null && ca.Account_Number__c == acc.Select_Account_FI_CERT__c.substringAfter('@')) ){
                    if(totalAmount > Integer.valueOf(ca.Balance__c)){
                        valid=false;
                        msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                        ApexPages.addMessage(msg);
                    }
                } else if( (acc.Select_Account_FI_CHK__c != null && ca.Account_Number__c == acc.Select_Account_FI_CHK__c.substringAfter('@')) && (acc.Select_Account_FI_SAV__c != null && ca.Account_Number__c == acc.Select_Account_FI_SAV__c.substringAfter('@')) && ( (acc.Select_Account_FI_CERT__c != null && ca.Account_Number__c != acc.Select_Account_FI_CERT__c.substringAfter('@')) || acc.Select_Account_FI_CERT__c == null) ){
                    if( (chkFundingAmt+savFundingAmt) > Integer.valueOf(ca.Balance__c)){
                        valid=false;
                        msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                        ApexPages.addMessage(msg);
                    }    
                } else if( (acc.Select_Account_FI_CHK__c != null && ca.Account_Number__c == acc.Select_Account_FI_CHK__c.substringAfter('@')) && (acc.Select_Account_FI_CERT__c != null && ca.Account_Number__c == acc.Select_Account_FI_CERT__c.substringAfter('@')) && ( (acc.Select_Account_FI_SAV__c != null && ca.Account_Number__c != acc.Select_Account_FI_SAV__c.substringAfter('@')) || acc.Select_Account_FI_SAV__c == null ) ){
                    if( (chkFundingAmt+certFundingAmt) > Integer.valueOf(ca.Balance__c)){
                        valid=false;
                        msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                        ApexPages.addMessage(msg);                        
                    }
                } else if( ( (acc.Select_Account_FI_CHK__c != null && ca.Account_Number__c != acc.Select_Account_FI_CHK__c.substringAfter('@')) || acc.Select_Account_FI_CHK__c == null) && (acc.Select_Account_FI_CERT__c != null && ca.Account_Number__c == acc.Select_Account_FI_CERT__c.substringAfter('@')) && (acc.Select_Account_FI_SAV__c != null && ca.Account_Number__c == acc.Select_Account_FI_SAV__c.substringAfter('@')) ){
                    if( (savFundingAmt+certFundingAmt) > Integer.valueOf(ca.Balance__c)){
                        valid=false;
                        msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                        ApexPages.addMessage(msg);                           
                    }
                }
            }
            if (app.Product__c.contains(Product_Names_Mapping__c.getValues('Business').Product_Name__c)) {
                Integer busChkFundingAmt = 0;
                Integer busSavFundingAmt = 0;
                Integer busCertFundingAmt = 0;
                Integer busTotalAmount = 0;
                if(acc.dollar_amount_internal_bus_chk__c != null){
                    busChkFundingAmt = Integer.valueOf(acc.dollar_amount_internal_bus_chk__c);
                }
                if(acc.dollar_amount_internal_bus_sav__c != null){
                    busSavFundingAmt = Integer.valueOf(acc.dollar_amount_internal_bus_sav__c);
                }  
                if(acc.dollar_amount_internal_bus_cert__c != null){
                    busCertFundingAmt = Integer.valueOf(acc.dollar_amount_internal_bus_cert__c);
                }
                busTotalAmount = busChkFundingAmt+busSavFundingAmt+busCertFundingAmt;
                for(Customer_Account__c ca : cusAccount){
                    if( (acc.select_account_fi_bus_chk__c != null && ca.Account_Number__c == acc.select_account_fi_bus_chk__c.substringAfter('@')) && (acc.select_account_fi_bus_sav__c != null && ca.Account_Number__c == acc.select_account_fi_bus_sav__c.substringAfter('@')) && (acc.select_account_fi_bus_cds__c != null && ca.Account_Number__c == acc.select_account_fi_bus_cds__c.substringAfter('@')) ){
                        if(busTotalAmount > Integer.valueOf(ca.Balance__c)){
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                            ApexPages.addMessage(msg);
                        }
                    } else if( (acc.select_account_fi_bus_chk__c != null && ca.Account_Number__c == acc.select_account_fi_bus_chk__c.substringAfter('@')) && (acc.select_account_fi_bus_sav__c != null && ca.Account_Number__c == acc.select_account_fi_bus_sav__c.substringAfter('@')) && ( (acc.select_account_fi_bus_cds__c != null && ca.Account_Number__c != acc.select_account_fi_bus_cds__c.substringAfter('@')) || acc.select_account_fi_bus_cds__c == null) ){
                        if( (busChkFundingAmt+busSavFundingAmt) > Integer.valueOf(ca.Balance__c)){
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                            ApexPages.addMessage(msg);
                        }    
                    } else if( (acc.select_account_fi_bus_chk__c != null && ca.Account_Number__c == acc.select_account_fi_bus_chk__c.substringAfter('@')) && (acc.select_account_fi_bus_cds__c != null && ca.Account_Number__c == acc.select_account_fi_bus_cds__c.substringAfter('@')) && ( (acc.select_account_fi_bus_sav__c != null && ca.Account_Number__c != acc.select_account_fi_bus_sav__c.substringAfter('@')) || acc.select_account_fi_bus_sav__c == null ) ){
                        if( (busChkFundingAmt+busCertFundingAmt) > Integer.valueOf(ca.Balance__c)){
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                            ApexPages.addMessage(msg);                        
                        }
                    } else if( ( (acc.select_account_fi_bus_chk__c != null && ca.Account_Number__c != acc.select_account_fi_bus_chk__c.substringAfter('@')) || acc.select_account_fi_bus_chk__c == null) && (acc.select_account_fi_bus_cds__c != null && ca.Account_Number__c == acc.select_account_fi_bus_cds__c.substringAfter('@')) && (acc.select_account_fi_bus_sav__c != null && ca.Account_Number__c == acc.select_account_fi_bus_sav__c.substringAfter('@')) ){
                        if( (busSavFundingAmt+busCertFundingAmt) > Integer.valueOf(ca.Balance__c)){
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'The total funding amount can not be greater than your available balance');
                            ApexPages.addMessage(msg);                           
                        }
                    }
                }
            }
        } else if (pageName == Index.PURCHASE_DETAILS_PAGE) {
            if(fieldsRequired.contains('Mortgage_Applied_For__c') && v.validateRequiredFields(acc.Mortgage_Applied_For__c,'Type of Mortgage')){
                valid=false;
            }
        
            if( acc.Mortgage_Applied_For__c == 'Other' ){
                if(fieldsRequired.contains('MortgageType_Other__c') && v.validateRequiredFields(acc.MortgageType_Other__c,'Other Type')){
                    valid=false;
                }  
            }
            
            if(fieldsRequired.contains('Purpose_Of_Loan__c') && v.validateRequiredFields(acc.Purpose_Of_Loan__c,'Purpose of Loan')){
                 valid=false;
            }
            
            if(acc.Purpose_Of_Loan__c == 'Other'){
                if(fieldsRequired.contains('MortgagePurchasePurpose_Other__c') && v.validateRequiredFields(acc.MortgagePurchasePurpose_Other__c,'Other purpose')){
                    valid=false;
                }
            }
            
            if(acc.Purpose_Of_Loan__c == 'Refi Rate/Term' || acc.Purpose_Of_Loan__c == 'Refinance Cashout'){
                if(fieldsRequired.contains('MRT_Estimated_Home_Value__c') && v.validateCurrencyRequiredFields(acc.MRT_Estimated_Home_Value__c,'Mortgage-Estimated Home Value')){
                    valid=false;
                }
                if(fieldsRequired.contains('MRT_Balance_of_Existing_Mortgage__c') && v.validateCurrencyRequiredFields(acc.MRT_Balance_of_Existing_Mortgage__c,'Mortagage Balance of Existing Mortgage')){
                    valid=false;
                }
                if(fieldsRequired.contains('HL_Requested_Loan_Amount__c') && v.validateCurrencyRequiredFields(acc.HL_Requested_Loan_Amount__c,'Mortgage-Requested Loan Amount')){
                    valid=false;
                }
            } else{
                if(fieldsRequired.contains('Purchase_P__c') && v.validateCurrencyRequiredFields(acc.Purchase_P__c,'Purchase Price')){
                valid=false;
                }
                if(fieldsRequired.contains('Down_Payment__c') && v.validateCurrencyRequiredFields(acc.Down_Payment__c,'Down Payment')){
                    valid=false;
                }
                if(fieldsRequired.contains('Total_Loan_Amount__c') && v.validateCurrencyRequiredFields(acc.Total_Loan_Amount__c,'Total Loan Amount')){
                    valid=false;
                }
            }
            if(fieldsRequired.contains('Program_Description_2__c') && v.validateRequiredFields(acc.Program_Description_2__c,'Program Description')){
                valid=false;
            }
            if(fieldsRequired.contains('Discount_Pt_Buy_Down_2__c') && v.validateRequiredFields(acc.Discount_Pt_Buy_Down_2__c,'Discount Point/Buy Down')){
                valid=false;
            }
            
             
            if(fieldsRequired.contains('HE_Purpose__c') && v.validateRequiredFields(acc.HE_Purpose__c,'Purpose of Loan')){
                 valid=false;
            }
           
            
            if( acc.HE_Purpose__c == 'Purchase' ){
                if(fieldsRequired.contains('HE_Down_Payment__c') && v.validateCurrencyRequiredFields(acc.HE_Down_Payment__c,'HE-Down Payment')){
                    valid=false;
                }
                if(fieldsRequired.contains('HE_Purchase_Price__c') && v.validateCurrencyRequiredFields(acc.HE_Purchase_Price__c,'HE-Purchase Price')){
                    valid=false;
                }
                if(fieldsRequired.contains('HE_Total_Loan_Amount__c') && v.validateCurrencyRequiredFields(acc.HE_Total_Loan_Amount__c,'HE-Total Loan Amount')){
                    valid=false;
                }
            }else{ 
                if(fieldsRequired.contains('HE_Balance_of_Existing_Mortgage__c') && v.validateCurrencyRequiredFields(acc.HE_Balance_of_Existing_Mortgage__c,'Balance of Existing Mortgage')){
                    valid=false;
                }
                if(fieldsRequired.contains('HE_Estimated_Home_Value__c') && v.validateCurrencyRequiredFields(acc.HE_Estimated_Home_Value__c,'Est. Home Value')){
                    valid=false;
                }
                 if(fieldsRequired.contains('HE_Requested_Loan_Amount__c') && v.validateCurrencyRequiredFields(acc.HE_Requested_Loan_Amount__c,'Requested Loan Amount')){
                valid=false;
                }
            }
            if(fieldsRequired.contains('HE_Program_Description__c') && v.validateRequiredFields(acc.HE_Program_Description__c,'Home Equity Program Description')){
                valid=true;
            }
        } else if (pageName == Index.PROPERTY_DETAILS_PAGE) {
            if(app.Type_of_Mortgage_Loan__c != null){
                if (acc.Options__c=='New Address' || acc.Options__c=='Current Address') {
                    if (fieldsRequired.contains('Year_Built__c') && v.validateNumberRequiredFields(acc.Year_Built__c,'Year built')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Street_Address_1_AboutAccount__c') && v.validateRequiredFields(acc.Street_Address_1_AboutAccount__c,'Street Address 1')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('City_AboutAccount__c') && v.validateRequiredFields(acc.City_AboutAccount__c,'City')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('State_AboutAccount__c') && v.validateRequiredFields(acc.State_AboutAccount__c,'State')) {
                        valid=false;
                    }
                    if (fieldsRequired.contains('Zip_Code_Account__c') && v.validateNumberRequiredFields(acc.Zip_Code_Account__c,'Zipcode')) {
                        valid=false;
                    }
                }
                if (fieldsRequired.contains('Property_Type__c') && v.validateRequiredFields(acc.Property_Type__c,'Property Type')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Number_of_Units__c') && v.validateRequiredFields(acc.Number_of_Units__c,'Number of Units')) {
                    valid=false;
                }
                if (fieldsRequired.contains('Occupancy__c') && v.validateRequiredFields(acc.Occupancy__c,'Occupancy')) {
                    valid=false;
                }
                if (acc.Occupancy__c == 'Investment') {
                    if (fieldsRequired.contains('Estimated_Gross_Rental_Income__c') && v.validateCurrencyRequiredFields(acc.Estimated_Gross_Rental_Income__c,'Estimated Gross Rental Income')) {
                        valid=false;
                    }
                }
                if (acc.Property_Type__c == 'High-rise Condo ( 5 or more Stories)' || acc.Property_Type__c == 'Low-rise Condo (1-4 Stories)') {
                    if (fieldsRequired.contains('HOA_Dues__c') && v.validateCurrencyRequiredFields(acc.HOA_Dues__c,'HOA Dues')) {
                        valid=false;
                    }
                }
            }
            if(app.Type_Of_Home_Equity__c != null){
                if(fieldsRequired.contains('HE_Street_Address_1__c') && v.validateRequiredFields(acc.HE_Street_Address_1__c,'Street Address 1')){
                   valid=false;
                }
                if(fieldsRequired.contains('HE_City__c') && v.validateRequiredFields(acc.HE_City__c,'City')){
                   valid=false;
                }
                if(fieldsRequired.contains('HE_State__c') && v.validateRequiredFields(acc.HE_State__c,'State')){
                   valid=false;
                }
                if(fieldsRequired.contains('HE_Zip_Code__c') && v.validateRequiredFields(acc.HE_Zip_Code__c,'Zipcode')){
                   valid=false;
                }
                
                if(fieldsRequired.contains('HE_Property_Type__c') && v.validateRequiredFields(acc.HE_Property_Type__c,'Property Type')){
                        valid=false;
                }
                if(fieldsRequired.contains('HE_No_of_Units__c') && v.validateRequiredFields(acc.HE_No_of_Units__c,'Number of Units')){
                    valid=false;
                }
                if(fieldsRequired.contains('HE_Occupancy__c') && v.validateRequiredFields(acc.HE_Occupancy__c,'HE Occupancy')){
                    valid=false;
                }
                 if(acc.HE_Occupancy__c == 'Investment'){
                    if(fieldsRequired.contains('HE_Estimated_Gross_Rental_Income__c') && v.validateCurrencyRequiredFields(acc.HE_Estimated_Gross_Rental_Income__c,'Estimated Gross Rental Income')){ 
                        valid=false;
                    }
                }
                if(acc.HE_Property_Type__c == 'High-rise Condo ( 5 or more Stories)' || acc.HE_Property_Type__c == 'Low-rise Condo (1-4 Stories)'){
                    if(fieldsRequired.contains('HE_HOA_Dues__c') && v.validateCurrencyRequiredFields(acc.HE_HOA_Dues__c,'HOA Dues')){   
                        valid=false;
                    }
                }
            }
        } else if (pageName == Index.DECLARATIONS_PAGE) {
            if (app2.Qa_PrimApp__c==true && v.validateRequiredFields(app2.Qa_Explanation_PrimApp__c,'Explanation for Question a for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qb_PrimApp__c==true && v.validateRequiredFields(app2.Qb_Explanation_PrimApp__c,'Explanation for Question b for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qc_PrimApp__c==true && v.validateRequiredFields(app2.Qc_Explanation_PrimApp__c,'Explanation for Question c for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qd_PrimApp__c==true && v.validateRequiredFields(app2.Qd_Explanation_PrimApp__c,'Explanation for Question d for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qe_PrimApp__c==true && v.validateRequiredFields(app2.Qe_Explanation_PrimApp__c,'Explanation for Question e for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qf_PrimApp__c==true && v.validateRequiredFields(app2.Qf_Explanation_PrimApp__c,'Explanation for Question f for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qg_PrimApp__c==true && v.validateRequiredFields(app2.Qg_Explanation_PrimApp__c,'Explanation for Question g for Primary Applicant')) {
                valid=false;
            }
            if (app2.Qh_PrimApp__c==true && v.validateRequiredFields(app2.Qh_Explanation_PrimApp__c,'Explanation for Question h for Primary Applicant')) {
                valid=false;
            }
          //if (app.Sub_Product__c=='Home Equity-Flexity Line of Credit') {  
                if (app2.HMDA_Info_PA__c==false) {
                    if ((fieldsRequired.contains('HMDA_Ethinicity_PA__c') && app2.HMDA_Ethinicity_PA__c==null) || (fieldsRequired.contains('HMDA_Sex_PA__c') && app2.HMDA_Sex_PA__c==null)) {
                        msg=new ApexPages.Message(ApexPages.Severity.Error,'Please select your ethnicity and gender or just check the “I do not wish to furnish this information” box for Primary Applicant');
                        ApexPages.addMessage(msg);
                        valid=false;
                    }
                }
           //}
            if (app.First_Joint_Applicant__c == true) {
                if (app2.Qa_JP1__c==true && v.validateRequiredFields(app2.Qa_Explanation_JP1__c,'Explanation for Question a for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qb_JP1__c==true && v.validateRequiredFields(app2.Qb_Explanation_JP1__c,'Explanation for Question b for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qc_JP1__c==true && v.validateRequiredFields(app2.Qc_Explanation_JP1__c,'Explanation for Question c for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qd_JP1__c==true && v.validateRequiredFields(app2.Qd_Explanation_JP1__c,'Explanation for Question d for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qe_JP1__c==true && v.validateRequiredFields(app2.Qe_Explanation_JP1__c,'Explanation for Question e for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qf_JP1__c==true && v.validateRequiredFields(app2.Qf_Explanation_JP1__c,'Explanation for Question f for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qg_JP1__c==true && v.validateRequiredFields(app2.Qg_Explanation_JP1__c,'Explanation for Question g for Joint Applicant 1')) {
                    valid=false;
                }
                if (app2.Qh_JP1__c==true && v.validateRequiredFields(app2.Qh_Explanation_JP1__c,'Explanation for Question h for Joint Applicant 1')) {
                    valid=false;
                }
                //if (getEthnicityRaceRenderedPA()) {  
                        if (app2.HMDA_Info_J1__c==false) {
                            if ((fieldsRequired.contains('HMDA_Ethinicity_J1__c') && app2.HMDA_Ethinicity_J1__c==null) || (fieldsRequired.contains('HMDA_Sex_J1__c') && app2.HMDA_Sex_J1__c==null)) {
                                valid=false;
                                msg=new ApexPages.Message(ApexPages.Severity.Error,'Please select your ethnicity and gender or just check the “I do not wish to furnish this information” box for Joint Applicant 1');
                                ApexPages.addMessage(msg);
                            }
                        }
                //}
            }  
            if (app.Second_Joint_Applicant__c == true) {
                if (app2.Qa_JP2__c==true && v.validateRequiredFields(app2.Qa_Explanation_JP2__c,'Explanation for Question a for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qb_JP2__c==true && v.validateRequiredFields(app2.Qb_Explanation_JP2__c,'Explanation for Question b for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qc_JP2__c==true && v.validateRequiredFields(app2.Qc_Explanation_JP2__c,'Explanation for Question c for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qd_JP2__c==true && v.validateRequiredFields(app2.Qd_Explanation_JP2__c,'Explanation for Question d for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qe_JP2__c==true && v.validateRequiredFields(app2.Qe_Explanation_JP2__c,'Explanation for Question e for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qf_JP2__c==true && v.validateRequiredFields(app2.Qf_Explanation_JP2__c,'Explanation for Question f for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qg_JP2__c==true && v.validateRequiredFields(app2.Qg_Explanation_JP2__c,'Explanation for Question g for Joint Applicant 2')) {
                    valid=false;
                }
                if (app2.Qh_JP2__c==true && v.validateRequiredFields(app2.Qh_Explanation_JP2__c,'Explanation for Question h for Joint Applicant 2')) {
                    valid=false;
                }
               //if (getEthnicityRaceRenderedPA()) {  
                    if (app2.HMDA_Info_J2__c==false) {
                        if ((fieldsRequired.contains('HMDA_Ethinicity_J2__c') && app2.HMDA_Ethinicity_J2__c==null) || (fieldsRequired.contains('HMDA_Sex_J2__c') && app2.HMDA_Sex_J2__c==null)) {
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Please select your ethnicity and gender or just check the “I do not wish to furnish this information” box for Joint Applicant 2');
                            ApexPages.addMessage(msg);
                        }
                        
                    }
                //}
            }   
            if (app.Third_Joint_Applicant__c == true) {
                if (app2.Qa_JP3__c==true && v.validateRequiredFields(app2.Qa_Explanation_JP3__c,'Explanation for Question a for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qb_JP3__c==true && v.validateRequiredFields(app2.Qb_Explanation_JP3__c,'Explanation for Question b for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qc_JP3__c==true && v.validateRequiredFields(app2.Qc_Explanation_JP3__c,'Explanation for Question c for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qd_JP3__c==true && v.validateRequiredFields(app2.Qd_Explanation_JP3__c,'Explanation for Question d for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qe_JP3__c==true && v.validateRequiredFields(app2.Qe_Explanation_JP3__c,'Explanation for Question e for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qf_JP3__c==true && v.validateRequiredFields(app2.Qf_Explanation_JP3__c,'Explanation for Question f for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qg_JP3__c==true && v.validateRequiredFields(app2.Qg_Explanation_JP3__c,'Explanation for Question g for Joint Applicant 3')) {
                    valid=false;
                }
                if (app2.Qh_JP3__c==true && v.validateRequiredFields(app2.Qh_Explanation_JP3__c,'Explanation for Question h for Joint Applicant 3')) {
                    valid=false;
                }
                //if (getEthnicityRaceRenderedPA()) {  
                    if (app2.HMDA_Info_J3__c==false) {
                        if ((fieldsRequired.contains('HMDA_Ethinicity_J3__c') && app2.HMDA_Ethinicity_J3__c==null) || (fieldsRequired.contains('HMDA_Sex_J3__c') && app2.HMDA_Sex_J3__c==null)) {
                            valid=false;
                            msg=new ApexPages.Message(ApexPages.Severity.Error,'Please select your ethnicity and gender or just check the “I do not wish to furnish this information” box for Joint Applicant 3');
                            ApexPages.addMessage(msg);
                        }
                    }
                //}    
            }
        } else if (pageName == Index.REVIEW_SUBMIT_PAGE) {
            if(app.current_channel__c == 'Online'){
                if (fieldsRequired.contains('Disclosure6__c') && v.validateCheckBoxRequiredFields(app.Disclosure6__c,'W-9 checkbox')) {
                    valid=false;
                }
            }
            if (fieldsRequired.contains('Disclosure1__c') && v.validateCheckBoxRequiredFields(app.Disclosure1__c,'E-Sign Consent checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure13__c') && v.validateCheckBoxRequiredFields(app.Disclosure13__c,'GLBA Privacy Policy checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure7__c') && v.validateCheckBoxRequiredFields(app.Disclosure7__c,'Truth in Savings checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure9__c') && v.validateCheckBoxRequiredFields(app.Disclosure9__c,'Handbook on ARMs checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure5__c') && v.validateCheckBoxRequiredFields(app.Disclosure5__c,'Authorization checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure8__c') && v.validateCheckBoxRequiredFields(app.Disclosure8__c,'CD - Truth in Savings checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure10__c') && v.validateCheckBoxRequiredFields(app.Disclosure10__c,'ARM Program Disclosure checkbox')) {
                valid=false;
            }
            if (fieldsRequired.contains('Disclosure4__c') && v.validateCheckBoxRequiredFields(app.Disclosure4__c,'Lien on Shares Authorization checkbox')) {
                valid=false;
            }
             if (fieldsRequired.contains('Disclosure3__c') && v.validateCheckBoxRequiredFields(app.Disclosure3__c,'Visa Disclosure checkbox')) {
                valid=false;
            }
             if (fieldsRequired.contains('Disclosure2__c') && v.validateCheckBoxRequiredFields(app.Disclosure2__c,'Membership Agreement checkbox')) {
                valid=false;
            }
        } else if (pageName == Index.VERIFY_IDENTITY_PAGE) {

        } else if (pageName == Index.CONFIRMATION_PAGE) {
        }
        system.debug('Valid is '+valid);
        return valid;           
    }
    
    global static  Boolean validateVehiclePurposeVechicleCollateral(About_Account__c acc, Set<String> fieldsRequired, Set<String> fieldsToDisplay) {
        ValidationUtilityClass v = new ValidationUtilityClass();
        ApexPages.Message vehicleCollateralMessage = null;
        system.debug('Came to Validate Purpose of Vehicle Loans for Vehicle collateral');
        Boolean validPurposeVehicleLoan = true;          

        if (fieldsRequired.contains('VIN__c')){
            system.debug('chekcing for auto collateral fields');
            if (fieldsRequired.contains('VIN__c') && v.validateRequiredFields(acc.VIN__c,'Vehicle VIN in Vehicle Collateral')) {
                system.debug('Auto VIN does not exist');
                validPurposeVehicleLoan=false;    
            }
            if (fieldsRequired.contains('VehicleYear__c') && v.validateRequiredFields(acc.VehicleYear__c,'Vehicle Year in Vehicle Collateral ')) {
                system.debug('Auto Year does not exist');
                validPurposeVehicleLoan=false;
            }
            if (fieldsRequired.contains('VehicleMake__c') && v.validateRequiredFields(acc.VehicleMake__c,'Vehicle Make in Vehicle Collateral ')) {
                system.debug('Auto Make does not exist');
                validPurposeVehicleLoan=false;
            }
            if (fieldsRequired.contains('VehicleModel__c') && v.validateRequiredFields(acc.VehicleModel__c,'Vehicle Model in Vehicle Collateral ')) {
                system.debug('Auto Model does not exist');
                validPurposeVehicleLoan=false;
            }
            if (fieldsRequired.contains('Vehicle_Sub_Model__c') && v.validateRequiredFields(acc.Vehicle_Sub_Model__c,'Vehicle SubModel in Vehicle Collateral ')) {
                system.debug('Auto SubModel does not exist');
                validPurposeVehicleLoan=false;
            }

            if (fieldsRequired.contains('VehicleMileage__c') && v.validateNumberRequiredFields(acc.VehicleMileage__c,'Vehicle Mileage in Vehicle Collateral')) {
                system.debug('Auto Mileage does not exist');
                validPurposeVehicleLoan=false;    
            } 
        } else if (fieldsRequired.contains('Non_Auto_Vehicle_VIN__c')){
            system.debug('chekcing for non-auto collateral fields');
            if (fieldsRequired.contains('Non_Auto_Vehicle_Mileage__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_VIN__c,'VIN in Vehicle Collateral')) {
                system.debug('Non-Auto VIN does not exist');
                validPurposeVehicleLoan=false;    
            }
            if (fieldsRequired.contains('Non_Auto_Vehicle_Year__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_Year__c,'Vehicle Year in Vehicle Collateral')) {
                system.debug('Non-Auto Year does not exist');
                validPurposeVehicleLoan=false;    
            } 
            if (fieldsRequired.contains('Non_Auto_Vehicle_Make__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_Make__c,'Vehicle Make in Vehicle Collateral')) {
                system.debug('Non-Auto Make does not exist');
                validPurposeVehicleLoan=false;    
            }
            if (fieldsRequired.contains('Non_Auto_Vehicle_Model__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_Model__c,'Vehicle Model in Vehicle Collateral')) {
                system.debug('Non-Auto Make does not exist');
                validPurposeVehicleLoan=false;    
            }
            if (fieldsRequired.contains('Non_Auto_Vehicle_Sub_Model__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_Sub_Model__c,'Vehicle Sub Model in Vehicle Collateral')) {
                system.debug('Non-Auto Model does not exist');
                validPurposeVehicleLoan=false;    
            }
            if (fieldsRequired.contains('Non_Auto_Vehicle_Mileage__c') && v.validateRequiredFields(acc.Non_Auto_Vehicle_Mileage__c,'Vehicle Mileage in Vehicle Collateral')) {
                system.debug('Non-Auto Sub-Model does not exist');
                validPurposeVehicleLoan=false;
            }  
        }

        system.debug('validPurposeVehicleLoan is '+validPurposeVehicleLoan);
        return validPurposeVehicleLoan;    
     }
} // end of class