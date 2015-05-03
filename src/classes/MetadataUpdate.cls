public with sharing class MetadataUpdate {
	
    public MetadataUpdate(ApexPages.StandardSetController controller) {

    }


    public MetadataUpdate(ApexPages.StandardController controller) {

    }


	/*public static MetadataService.MetadataPort createService() { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        system.debug('Session : ' +service);
        return service; 
    }*/
	
	public static JSONGenerator getObjectFields(sObject obj, JSONGenerator generator) {
        String objectName = null;
        if (obj != null) {
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            objectName = String.valueOf(obj.getSobjectType());
            for (String fn : fieldMap.keySet()) {
                try { generator.writeStringField(fn.toLowerCase(), objectName); } catch (Exception e) {}
            }
        }
 
        return generator;
    }

    public static JSONGenerator getPickListFields(sObject obj, JSONGenerator generator) {
        Schema.DisplayType fielddataType = null;
        List<Schema.PicklistEntry> pick_list_values = null;
        List<String> options = null;
        if (obj != null) {
            Map<String, Schema.SObjectField>fieldMap = obj.getSobjectType().getDescribe().fields.getMap();
            for (String fn : fieldMap.keySet()) {
                fielddataType = fieldMap.get(fn).getDescribe().getType();
                try {
                    if (fielddataType == Schema.DisplayType.Picklist) {
                        pick_list_values = fieldMap.get(fn).getDescribe().getPickListValues();
                        options = new List<String>();
                        if (pick_list_values != null && pick_list_values.size() > 0) {
                            for (Schema.PicklistEntry a : pick_list_values) {options.add(a.getLabel() + '_' + a.getValue());}
                            //appData.put('SelectOptions.' + fn, String.join(options, ';'));
                            generator.writeStringField(fn.toLowerCase(), String.join(options, ';'));
                        }
                    }
                } catch (Exception e) {}
            }
        }
 
        return generator;
    }

    Public PageReference Meta(){

    	String sessionId = UserInfo.getSessionId();
    	MetadataUpdate(sessionId);
    	Schema.DescribeSObjectResult result = Field_Logic_New__c.SObjectType.getDescribe();
    	return new PageReference('/' +result.getKeyPrefix() +'/o');
    	//return new PageReference('/a0N/o');
    } 

    @future(callout=true)
	public static void MetadataUpdate(String sessionId) {
			
		String resFilename = 'app_fields';
        String resFilename2 = 'new_app_fields';
        StaticResource sr = [SELECT NameSpacePrefix FROM StaticResource WHERE Name = 'app_fields'];
        if(sr.NameSpacePrefix != null){
            resFilename = sr.NameSpacePrefix+'__'+resFilename;
            //resFilename2 = sr.NameSpacePrefix+'__'+resFilename2;
        }    
        String jsonString;

        
        try {

            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
	        service.SessionHeader = new MetadataService.SessionHeader_element();
	        service.SessionHeader.sessionId = sessionId;
	        system.debug('Session : ' +service);
            MetadataService.StaticResource staticResource = new MetadataService.StaticResource();
            staticResource.fullName = resFilename;
            staticResource.contentType = 'text';
            staticResource.cacheControl = 'public';
            MetadataService.StaticResource staticResource2 = new MetadataService.StaticResource();
            staticResource2.fullName = resFilename2;
            staticResource2.contentType = 'text';
            staticResource2.cacheControl = 'public';
            List<Document> resList = [select id, name, body from Document where name ='app_f'];
            MetadataService.Document appDoc = new MetadataService.Document();
            appDoc.fullname = 'app_f';
            appDoc.public_x = true;
            appDoc.name ='app_f';   
            appDoc.internalUseOnly =false;
            JSONGenerator generator = JSON.createGenerator(true);
            JSONGenerator generator2 = JSON.createGenerator(true);
            JSONGenerator generator3 = JSON.createGenerator(true);

            List<Field_Logic_New__c> fieldList2 = [SELECT Label_Name__c, Value__c FROM Field_Logic_New__c WHERE RecordType.name = 'Page Labels'];
            generator.writeStartObject();
            for (Field_Logic_New__c fl2 : fieldList2) {
                generator.writeStringField(fl2.Label_Name__c.toLowerCase(), fl2.Value__c);
            }

            generator.writeEndObject();
            jsonString = 'DSP.models = DSP.models || {};\n\nDSP.models.PageLabels = ' + generator.getAsString() + ';\n';

            jsonString += '\nDSP.models.ObjectFields = ';
            generator2.writeStartObject();

            Cross_Sell_Logic__c cross = null;
            Application__c app = [SELECT Disclosure1__c,Disclosure2__c,Disclosure3__c,Disclosure4__c,Disclosure5__c,Disclosure6__c,Disclosure7__c,Disclosure8__c,Disclosure9__c,Disclosure10__c,Disclosure11__c,Disclosure12__c,Disclosure13__c,Disclosure14__c,Disclosure15__c,Disclosure16__c,Disclosure17__c,Disclosure18__c,Disclosure19__c,Disclosure20__c,Assisted_Application__c,Created_Branch_Name__c,Created_Channel__c,Created_Person__c,Created_Timestamp__c,Created_User_Email_Address__c,Current_Branch_Name__c,Current_Channel__c,Current_Person__c,Current_Timestamp__c,Current_User_Email_Address__c,Submitted_Branch_Name__c,Submitted_Channel__c,Submitted_Person__c,Submitted_Timestamp__c,Submitted_User_Email_Address__c,Type_Of_Business_Checking__c,Type_Of_Business_Savings__c,Type_Of_Business_CDs__c,Type_Of_Business_Credit_Cards__c,Type_Of_Business_Loans__c,Business_City__c,Business_EIN_TIN__c,Business_Legal_Name__c,Business_Phone_Number__c,Business_registration_State__c,Business_State__c,Business_Street_Address_1__c,Business_Street_Address_2__c,Business_Type__c,Business_Zip_Code__c,Nature_Of_Business__c,NAICS_Code__c,Estimated_Annual_Sales_Revenue__c,Main_Product_Special_Handling_Code_Value__c,Main_Product_Special_Handling_Code__c,Primary_Offer_Special_Handling_CodeValue__c,Primary_Offer_Special_Handling_Code__c,Second_Offer_Special_Handling_Code_Value__c,Second_Offer_Special_Handling_Code__c,Third_Offer_Special_Handling_Code_Value__c,Third_Offer_Special_Handling_Code__c,Debt_Safe_Protection_Option_Credits__c,Debt_Safe_Protection_Option_Loans__c,Mechanical_Break_Down_Protection_CS__c,Include_in_Loan_Amount_MBP__c,MBP_Amount_of_Policy__c,Gap_Protection_CS__c,Include_in_Loan_Amount_GP__c,CL_Product_Comments_Only__c,flow_control__c,application_page__c,support_phone_number__c,product__c,sub_product__c,application_status__c,number_of_products__c,primary_offer__c,second_offer__c,third_offer__c,full_name_pa__c,first_name__c,middle_name__c,last_name__c,street_address_1__c,street_address_2__c,city__c,state__c,zip_code__c,housing_status__c,monthly_payment__c,years__c,months__c,marital_status__c,street_address_1_prev__c,street_address_2_prev__c,city_prev__c,state_prev__c,zip_code_prev__c,primary_phone_number__c,secondary_phone_number__c,email_address__c,fullname_j__c,first_name_j__c,middle_name_j__c,last_name_j__c,street_address_j__c,street_address_2_j__c,city_j__c,state_j__c,zip_code_j__c,housing_status_j__c,monthly_payment_j__c,years_j__c,months_j__c,marital_status_j__c,relationship_to_primary_applicant_j1__c,street_address_1_jp__c,street_address_2_jp__c,city_jp__c,state_jp__c,zip_code_jp__c,primary_phone_number_j__c,secondary_phone_number_j__c,email_address_j__c,fullname_j2__c,first_name_j2__c,middle_name_j2__c,last_name_j2__c,street_address_1_j2__c,street_address_2_j2__c,city_j2__c,state_j2__c,zip_code_j2__c,housing_status_j2__c,monthly_payment_j2__c,years_j2__c,months_j2__c,marital_status_j2__c,relationship_to_primary_applicant_j2__c,street_address_1_jp2__c,street_address_2_jp2__c,city_jp2__c,state_jp2__c,zip_code_jp2__c,primary_phone_number_j2__c,secondary_phone_number_j2__c,email_address_j2__c,fullname_j3__c,first_name_j3__c,middle_name_j3__c,last_name_j3__c,street_address_1_j3__c,street_address_2_j3__c,city_j3__c,state_j3__c,zip_code_j3__c,housing_status_j3__c,monthly_payment_j3__c,years_j3__c,months_j3__c,marital_status_j3__c,relationship_to_primary_applicant_j3__c,street_address_1_jp3__c,street_address_2_jp3__c,city_jp3__c,state_jp3__c,zip_code_jp3__c,primary_phone_number_j3__c,secondary_phone_number_jp3__c,email_address_j3__c,first_joint_applicant__c,second_joint_applicant__c,third_joint_applicant__c,Appointment_Location__c,Appointment_Datetime__c,device_orientation__c,device_pixel_ratio__c,device_type__c FROM Application__c LIMIT 1];
            Application2__c app2 = [SELECT application_status__c, qa_primapp__c, qa_explanation_primapp__c, qb_primapp__c, qb_explanation_primapp__c, qc_primapp__c, qc_explanation_primapp__c, qd_primapp__c, qd_explanation_primapp__c, qe_primapp__c, qe_explanation_primapp__c, qf_primapp__c, qf_explanation_primapp__c, qg_primapp__c, qg_explanation_primapp__c, qh_primapp__c, qh_explanation_primapp__c, qi_primapp__c, qi_explanation_primapp__c, qj_primapp__c, qk_primapp__c, qk_2_primapp__c, ql_primapp__c, qm_primapp__c, qm_type_of_property_primapp__c, qm_title_held_primapp__c, hmda_info_pa__c, hmda_ethinicity_pa__c, hmda_sex_pa__c, hmda_race_pa__c, qa_jp1__c, qa_explanation_jp1__c, qb_jp1__c, qb_explanation_jp1__c, qc_jp1__c, qc_explanation_jp1__c, qd_jp1__c, qd_explanation_jp1__c, qe_jp1__c, qe_explanation_jp1__c, qf_jp1__c, qf_explanation_jp1__c, qg_jp1__c, qg_explanation_jp1__c, qh_jp1__c, qh_explanation_jp1__c, qi_jp1__c, qi_explanation_jp1__c, qj_jp1__c, qk_jp1__c, qk_2_jp1__c, ql_jp1__c, qm_jp1__c, qm_type_of_property_jp1__c, qm_title_held_jp1__c, hmda_info_j1__c, hmda_ethinicity_j1__c, hmda_sex_j1__c, hmda_race_j1__c, qa_jp2__c, qa_explanation_jp2__c, qb_jp2__c, qb_explanation_jp2__c, qc_jp2__c, qc_explanation_jp2__c, qd_jp2__c, qd_explanation_jp2__c, qe_jp2__c, qe_explanation_jp2__c, qf_jp2__c, qf_explanation_jp2__c, qg_jp2__c, qg_explanation_jp2__c, qh_jp2__c, qh_explanation_jp2__c, qi_jp2__c, qi_explanation_jp2__c, qj_jp2__c, qk_jp2__c, qk_2_jp2__c, ql_jp2__c, qm_jp2__c, qm_type_of_property_jp2__c, qm_title_held_jp2__c, hmda_info_j2__c, hmda_ethinicity_j2__c, hmda_sex_j2__c, hmda_race_j2__c, qa_jp3__c, qa_explanation_jp3__c, qb_jp3__c, qb_explanation_jp3__c, qc_jp3__c, qc_explanation_jp3__c, qd_jp3__c, qd_explanation_jp3__c, qe_jp3__c, qe_explanation_jp3__c, qf_jp3__c, qf_explanation_jp3__c, qg_jp3__c, qg_explanation_jp3__c, qh_jp3__c, qh_explanation_jp3__c, qi_jp3__c, qi_explanation_jp3__c, qj_jp3__c, qk_jp3__c, qk_2_jp3__c, ql_jp3__c, qm_jp3__c, qm_type_of_property_jp3__c, qm_title_held_jp3__c, hmda_info_j3__c, hmda_ethinicity_j3__c, hmda_sex_j3__c, hmda_race_j3__c FROM Application2__c LIMIT 1];
            List<Cross_Sell_Logic__c> crossList = [SELECT primary_offer__c, secondary_offer__c, third_offer__c, primary_offer_text__c, secondary_offer_text__c, third_offer_text__c, primary_offer_textarea__c, primary_offer_textarea2__c, primary_offer_textarea3__c, primary_offer_textarea4__c, primary_offer_textarea5__c, secondary_offer_textarea__c, secondary_offer_textarea2__c, secondary_offer_textarea3__c, secondary_offer_textarea4__c, secondary_offer_textarea5__c, third_offer_textarea__c, third_offer_textarea2__c, third_offer_textarea3__c, third_offer_textarea4__c, third_offer_textarea5__c FROM Cross_Sell_Logic__c WHERE Products__c=:app.product__c AND Sub_Products__c=:app.sub_product__c LIMIT 1];
            if (crossList.size() > 0) {
                cross = crossList.get(0);
            }
            About_Account__c acc = [Select CHK_Funding_Amount_From_Internal_Account__c,SAV_Funding_Amount_From_Internal_Account__c, CERT_Funding_Amt_From_Internal_Account__c,CHK_Check_Routing_Number__c,CHK_Check_Account_Number__c,Dollar_Amount_CHK_Check__c,SAV_Check_Routing_Number__c,SAV_Check_Account_Number__c,Dollar_Amount_SAV_Check__c,CERT_Check_Routing_Number__c,CERT_Check_Account_Number__c,Dollar_Amount_CERT_Check__c,BUSICHK_Check_Routing_Number__c,BUSICHK_Check_Account_Number__c,Dollar_Amount_BUSICHK_Check__c,BUSISAV_Check_Routing_Number__c,BUSISAV_Check_Account_Number__c,Dollar_Amount_BUSISAV_Check__c,BUSICDS_Check_Routing_Number__c,BUSICDS_Check_Account_Number__c,Dollar_Amount_BUSICDS_Check__c,Dollar_Amount_BUSISAV_Cash__c,Dollar_Amount_BUSICHK_Cash__c,Dollar_Amount_BUSICDS_Cash__c,Dollar_Amount_CHK_Cash__c,Dollar_Amount_SAV_Cash__c,Dollar_Amount_CERT_Cash__c,sb_lc_balance_owned_5__c,sb_lc_desc_5__c,sb_lc_monthy_payment_5__c,sb_lc_type_5__c,sb_lc_balance_owned_4__c,sb_lc_desc_4__c,sb_lc_monthy_payment_4__c,sb_lc_type_4__c,sb_lc_balance_owned_3__c,sb_lc_desc_3__c,sb_lc_monthy_payment_3__c,sb_lc_type_3__c,sb_lc_balance_owned_2__c,sb_lc_desc_2__c,sb_lc_monthy_payment_2__c,sb_lc_type_2__c,sb_lc_balance_owned_1__c,sb_lc_desc_1__c,sb_lc_monthy_payment_1__c,sb_lc_type_1__c,sb_lc_fin_inst_name_1__c,sb_lc_account_number_1__c,sb_lc_account_type_1__c,sb_lc_approx_Bal_1__c,sb_lc_fin_inst_name_2__c,sb_lc_account_number_2__c,sb_lc_account_type_2__c,sb_lc_approx_Bal_2__c,sb_lc_fin_inst_name_3__c,sb_lc_account_number_3__c,sb_lc_account_type_3__c,sb_lc_approx_Bal_3__c,sb_lc_fin_inst_name_4__c,sb_lc_account_number_4__c,sb_lc_account_type_4__c,sb_lc_approx_Bal_4__c,sb_lc_fin_inst_name_5__c,sb_lc_account_number_5__c,sb_lc_account_type_5__c,sb_lc_approx_Bal_5__c,sb_lc_sc_desc_1__c,sb_lc_market_value_1__c,sb_lc_shares_bond_1__c,sb_lc_sc_desc_2__c,sb_lc_market_value_2__c,sb_lc_shares_bond_2__c,sb_lc_sc_desc_3__c,sb_lc_market_value_3__c,sb_lc_shares_bond_3__c,sb_lc_sc_desc_4__c,sb_lc_market_value_4__c,sb_lc_shares_bond_4__c,sb_lc_sc_desc_5__c,sb_lc_market_value_5__c,sb_lc_shares_bond_5__c,busaa_1__c,busaa_country__c,busaa_state__c,busaa_2__c,busaa_3__c,busaa_3a__c,busaa_4__c,busaa_4a__c,busaa_5__c,busaa_6a__c,busaa_6b__c,busaa_6c__c,busaa_7__c,busaa_8__c,busaa_9__c,busaa_10__c,busaa_10a__c,requested_loan_amount_businessloans__c,term_businessloans__c,purpose_businessloans__c,otherpurpose_businessloans__c,debt_consolidation_business_loan__c,requested_credit_limit_Bus_ccards__c,purpose_bus_ccards__c,otherpurpose_bus_ccards__c,debt_consolidation_bus_credit_card__c,Dollar_Amount_Internal_Bus_CHK__c,Dollar_Amount_Internal_Bus_SAV__c,Dollar_Amount_Internal_Bus_CERT__c,Funding_Type_BUS_CHK__c,select_account_fi_bus_chk__c,financial_institution_bus_chk__c,routing_number_bus_chk__c,account_type_fi_bus_chk__c,bus_chk_account_number__c,dollar_amount_external_bus_chk__c,disclosure_accountdetails_bus_chk__c,funding_type_bus_sav__c,select_account_fi_bus_sav__c,financial_institution_bus_sav__c,routing_number_bus_sav__c,account_type_fi_bus_sav__c,bus_sav_account_number__c,dollar_amount_external_bus_sav__c,disclosure_accountdetails_bus_sav__c,funding_type_bus_cds__c,select_account_fi_bus_cds__c,financial_institution_bus_cds__c,routing_number_bus_cds__c,account_type_fi_bus_cds__c,bus_cds_account_number__c,dollar_amount_external_bus_cds__c,disclosure_accountdetails_bus_cds__c,property_current_residence__c,HL_Requested_Loan_Amount__c,MRT_Estimated_Home_Value__c,MRT_Balance_of_Existing_Mortgage__c,HE_Balance_of_Existing_Mortgage__c,HE_City__c,HE_County_c__c,HE_Down_Payment__c,HE_Estimated_Gross_Rental_Income__c,HE_Estimated_Home_Value__c,HE_HOA_Dues__c,HE_Monthly_Insurance__c,HE_Monthly_Taxes__c,HE_No_of_Units__c,HE_Occupancy__c,HE_Program_Description__c,HE_Program_Value__c,HE_Property_Type__c,HE_Purchase_Price__c,HE_Purpose__c,HE_Requested_Loan_Amount__c,HE_State__c,HE_Street_Address_1__c,HE_Street_Address_2__c,HE_Total_Loan_Amount__c,HE_Type_of_Mortgage__c,HE_Year__c,HE_Zip_Code__c,Name,Certificate_Account_Number__c,Certificate_Product_Description__c,Account_Holder_Name_CERT__c, Account_Holder_Name_CHK__c, Account_Holder_Name_SAV__c, Account_Type_FI_Cert__c, Account_Type_FI_Sav__c, Account_type_FI_CHK__c, Area_of_Interest__c, City_AboutAccount__c, City_Branch__c, County_AboutAccount__c, County__c, Debt_Consolidation_Credit_Card__c, Debt_Consolidation_Personal_Loan__c, Debt_Consolidation_Vehicle_LOan__c, Disclosure_AccountDetails_CERT__c, Disclosure_AccountDetails_SAV__c, Disclosure_AccountDetails_chk__c,Dollar_Amount_External_CERT__c, Dollar_Amount_External_CHK__c, Dollar_Amount_External_SAV__c, Down_Payment__c, Estimated_Gross_Rental_Income__c, FI_Name1__c, FI_Name2__c, FI_Name3__c, FI_Name4__c, FI_Name5__c, FI_Name6__c, Financial_Institution_CERT__c, Financial_Institution_CHK__c, Financial_Institution_SAV__c, Funding_Type_CERT__c, Funding_Type_CHK__c, Funding_Type_SAV__c, HOA_Dues__c, Monthly_Insurance__c, Monthly__c, Mortgage_Applied_For__c, No_of_shares__c, Non_Auto_Vehicle_Make__c, Non_Auto_Vehicle_Mileage__c, Non_Auto_Vehicle_Model__c, Non_Auto_Vehicle_Sub_Model__c, Non_Auto_Vehicle_VIN__c, Non_Auto_Vehicle_Year__c, NumOfShares_1__c, NumOfShares_2__c, NumOfShares_3__c, NumOfShares_4__c, NumOfShares_5__c, Number_of_Units__c, Occupancy__c, Options__c, OtherPurpose_Ccards__c, OtherPurpose_PersonalLoans__c, OtherPurpose_VehicleLoans__c, Ownership__c, Person_Number__c,Property_Type__c, Purchase_P__c, Purpose_Ccards__c, Purpose_DebtConsolidation_VehicleLoan__c, Purpose_Of_Loan__c, Purpose_PersonalLoans__c, Purpose_VehicleLoan__c, Relationship_to_Primary_Applicant_J1__c, Requested_Credit_Limit_Ccards__c, Requested_Credit_Limit_PersonalLoans__c, Requested_Loan_Amount_PersonalLoans__c, Requested_Loan_Amount_VehicleLoans__c, Routing_Number_CHK__c, Routing_Number_Cert__c, Routing_Number_Sav__c, Select_Account_FI_CERT__c, Select_Account_FI_CHK__c, Select_Account_FI_Ccards__c, Select_Account_FI_SAV__c, State_AboutAccount__c, State_Branch__c, Stock_Symbol_1__c, Stock_Symbol_2__c, Stock_Symbol_3__c, Stock_Symbol_4__c, Stock_Symbol_5__c, Stock_Symbols__c, Street_Address_1_AboutAccount__c, Street_Address_2_AboutAccount__c, Suffix__c, Term_Personalloans__c, Term_VehicleLoans__c, Total_Loan_Amount__c, Type_of_Asset2__c, Type_of_Asset3__c, Type_of_Asset4__c, Type_of_Asset5__c, Type_of_Asset6__c, Type_of_Asset__c, VIN__c, Value_or_Balance2__c, Value_or_Balance3__c, Value_or_Balance4__c, Value_or_Balance5__c, Value_or_Balance6__c, Value_or_Balance__c, VehicleMake__c, VehicleMileage__c, VehicleModel__c, VehicleYear__c, Vehicle_Sub_Model__c, Year_Built__c, Zip_Code_Account__c, Street_Address_1__c, Application__c, MortgageType_Other__c, MortgagePurchasePurpose_Other__c, Program_Description_2__c, Discount_Pt_Buy_down_2__c, City__c, State__c, Street_Address_2__c, Zip_Code__c, What_type_of_Loan_are_you_applying_for__c, CHK_Account_Number__c, Dollar_Amount_Internal_CHK__c, Dollar_Amount_Internal_SAV__c, SAV_Account_Number__c, Dollar_Amount_Internal_CERT__c, OIAU_Q1_Explanation_J1__c, OIAU_Q1_Explanation_J2__c, OIAU_Q1_Explanation_J3__c, OIAU_Q1_Explanation_PA__c, OIAU_Q1_J1__c, OIAU_Q1_J2__c, OIAU_Q1_J3__c, OIAU_Q1_PA__c, OIAU_Q2_Explanation_J1__c, OIAU_Q2_Explanation_J2__c, OIAU_Q2_Explanation_J3__c, OIAU_Q2_Explanation_PA__c, OIAU_Q2_J1__c, OIAU_Q2_J2__c, OIAU_Q2_J3__c, OIAU_Q2_PA__c, OIAU_Q3_Explanation_J1__c, OIAU_Q3_Explanation_J2__c, OIAU_Q3_Explanation_J3__c, OIAU_Q3_Explanation_PA__c, OIAU_Q3_J1__c, OIAU_Q3_J2__c, OIAU_Q3_J3__c, OIAU_Q3_PA__c, CERT_Account_Number__c FROM About_Account__c LIMIT 1];
            Employment_Information__c emp = [Select Name,Employment_Status__c, Application__c, Company_List__c, Other_Income2_J2__c, Other_Income2_J3__c, Other_Income2__c, Other_Income3_J2__c, Other_Income3_J3__c, Other_Income3__c, Other_Income4_J2__c, Other_Income4_J3__c, Other_Income4__c, Other_Income5_J2__c, Other_Income5_J3__c, Other_Income5__c, Other_Income_2__c, Other_Income_3__c, Other_Income_4__c, Other_Income_5__c, Other_Income_J2__c, Other_Income_J3__c, Other_Income_Picklist1_J1__c, Other_Income_Picklist1_J2__c, Other_Income_Picklist1_J3__c, Other_Income_Picklist2_J1__c, Other_Income_Picklist2_J2__c, Other_Income_Picklist2_J3__c, Other_Income_Picklist2__c, Other_Income_Picklist3_J1__c, Other_Income_Picklist3_J2__c, Other_Income_Picklist3_J3__c, Other_Income_Picklist3__c, Other_Income_Picklist4_J1__c, Other_Income_Picklist4_J2__c, Other_Income_Picklist4_J3__c, Other_Income_Picklist4__c, Other_Income_Picklist5_J1__c, Other_Income_Picklist5_J2__c, Other_Income_Picklist5_J3__c, Other_Income_Picklist5__c, Other_Income_Picklist__c, Other_Income__c, Employer_J1__c, Employer_J2__c, Employer_J3__c, Employer_JP1__c, Employer_JP2__c, Employer_JP3__c, Employer_P__c, Employer__c, Employment_Status_J1__c, Employment_Status_J2__c, Employment_Status_J3__c, Other_Income2_J1__c, Other_Income3_J1__c, Other_Income4_J1__c, Other_Income5_J1__c, Other_Income_J1__c, Prior_Occupation_J1__c, Prior_Occupation_J2__c, Prior_Occupation_J3__c, Prior_Occupation__c, Occupation_J1__c, Occupation_J2__c, Occupation_J3__c, Occupation_JP1__c, Occupation_JP2__c, Occupation_JP3__c, Occupation_P__c, Occupation__c, Years_Emp__c, Years_EmpJ1__c, Years_EmpJ2__c, Years_EmpJ3__c, Months_Emp__c, Months_EmpJ1__c, Months_EmpJ2__c, Months_EmpJ3__c, How_do_you_like_to_become_member__c, How_do_you_like_to_become_member_J2__c, How_do_you_like_to_become_member_J3__c, Annual_Income__c, Annual_Income_J1__c, Annual_Income_J3__c, Annual_Income_J2__c, How_do_you_like_to_become_member_J1__c FROM Employment_Information__c LIMIT 1];
            Identity_Information__c iden = [Select Name,State_Issued__c, State_Issued_J1__c, State_Issued_J2__c, State_Issued_J3__c, Country_of_Citizenship_J1__c, Country_of_Citizenship_J2__c, Country_of_Citizenship_J3__c, Country_of_Citizenship__c, Date_of_Birth_J1__c, Date_of_Birth_J2__c, Date_of_Birth_J3__c, Date_of_Birth__c, Citizenship_J1__c, Citizenship_J2__c, Citizenship_J3__c, Citizenship__c, SSN_J1__c, SSN_J2__c, SSN_J3__c, SSN_Prime__c, Expiry_Date_J1__c, Expiry_Date_J2__c, Expiry_Date_J3__c, Expiry_Date__c, ID_NUmber_J3__c, ID_Number_J1__c, ID_Number_J2__c, ID_Number__c, ID_Type_J1__c, ID_Type_J2__c, ID_Type_J3__c, ID_Type__c, Identity_Number_J1__c, Identity_Number_J2__c, Identity_Number_J3__c, Identity_Number_Primary__c, Issue_Date_J1__c, Issue_Date_J2__c, Issue_Date_J3__c, Issue_Date__c, Application__c, Social_Security_Number_J1__c, Social_Security_Number_J2__c, Social_Security_Number_J3__c, Social_Security_Number__c FROM Identity_Information__c LIMIT 1];
            Docusign_Config__c doc = [Select Name,AccountID__c,IntegratorKey__c,Password__c,Switch_ON_OFF__c,Username__c from Docusign_Config__c where Name = 'cred'];

            generator2 = getObjectFields((About_Account__c)acc, generator2);
            generator2 = getObjectFields((Application__c)app, generator2);
            generator2 = getObjectFields((Application2__c)app2, generator2);
            generator2 = getObjectFields((Employment_Information__c)emp, generator2);
            generator2 = getObjectFields((Identity_Information__c)iden, generator2);
            generator2 = getObjectFields((Cross_Sell_Logic__c)cross, generator2);
            generator2 = getObjectFields((Docusign_Config__c)doc, generator2);

            generator2.writeEndObject();
            jsonString += generator2.getAsString() + ';\n';

            jsonString += '\nDSP.models.SelectOptions = ';
            generator3.writeStartObject();

            generator3 = getPickListFields((Application__c)app, generator3);
            generator3 = getPickListFields((Application2__c)app2, generator3);
            generator3 = getPickListFields((Employment_Information__c)emp, generator3);
            generator3 = getPickListFields((Identity_Information__c)iden, generator3);
            generator3 = getPickListFields((Cross_Sell_Logic__c)cross, generator3);
            generator3 = getPickListFields((About_Account__c)acc, generator3);

            generator3.writeEndObject();
            jsonString += generator3.getAsString() + ';\n';

            /*Attachment attach = new Attachment();
            List<Attachment> att = new List<Attachment>();
            List<App_Configuration__c> appCon = [SELECT id,name, (select id FROM Attachments) FROM App_Configuration__c WHERE name = :Application_Configuration__c.getInstance().app_fields_staticresource__c];
            system.debug('The size of app coniguration is '+ appCon.size());
            if(appCon.size() > 0){
                att = appCon[0].Attachments;
                if(att.size() > 0){
                    system.debug('Updating the existing new attachment for app Configuration');
                    String s1 = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
                    att[0].body = EncodingUtil.base64Decode(String.valueOf(s1));
                    update att[0];
                } else {
                    system.debug('Creating a new attachment for app Configuration');
                    attach.ParentId = appCon[0].Id;  
                    attach.Name = 'application_fields.txt';
                    attach.IsPrivate = false;
                    system.debug('The Json String is '+ jsonString);
                    String s2 = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
                    attach.Body = EncodingUtil.base64Decode(String.valueOf(s2));
                    insert attach;
                }
            }*/

            Document docs = new Document();
            Folder fold = new Folder();
            List<Document> docList = [SELECT id,name,body FROM Document WHERE name = :Application_Configuration__c.getInstance().app_fields_staticresource__c];
            List<Folder> folderList = [SELECT id,name FROM Folder WHERE name = :Application_Configuration__c.getInstance().App_Fields_Folder__c];
            if(docList.size() > 0){
                String s1 = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
                docList[0].body = EncodingUtil.base64Decode(String.valueOf(s1));
                Update docList[0];
            } else {
                docs.Name = Application_Configuration__c.getInstance().app_fields_staticresource__c;
                docs.DeveloperName = Application_Configuration__c.getInstance().app_fields_staticresource__c;
                String s2 = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
                docs.Body = EncodingUtil.base64Decode(String.valueOf(s2));
                docs.ContentType = 'text/plain';
                docs.Type = 'txt';
                docs.IsPublic = true;
                if(folderList.size() > 0){
                   docs.FolderId =  folderList[0].id;
                }   
                insert docs;
                system.debug('The new document is '+ docs);
            }
            /*staticResource.content = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
            staticResource2.content = EncodingUtil.base64Encode(Blob.valueOf(jsonString));
            if (resList.size() > 0) { //update
                system.debug('inside if');
                MetadataService.SaveResult[] results2 = service.updateMetadata(new List<MetadataService.Metadata> { appDoc });    
                system.debug('update list');
                if(Application_Configuration__c.getInstance().app_fields_staticresource__c == 'app_fields'){
                    MetadataService.SaveResult[] results = service.updateMetadata(new List<MetadataService.Metadata> { staticResource });   
                } else {
                    List<StaticResource> resList2 = [select id, name, body from StaticResource where name ='new_app_fields'];
                    if(resList2.size() > 0){
                        MetadataService.SaveResult[] results = service.updateMetadata(new List<MetadataService.Metadata> { staticResource2 });
                    } else {
                        MetadataService.SaveResult[] results = service.createMetadata(new List<MetadataService.Metadata> { staticResource2 });
                    }
                }
                
            } else { //insert
                MetadataService.SaveResult[] results = service.createMetadata(new List<MetadataService.Metadata> { appDoc });
            }*/

        } catch(Exception e) {
            system.debug('The error is ' + e.getMessage());
        } 
	
	}
}