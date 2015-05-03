global class CreateFieldLogicRecords implements Database.Batchable<sObject> {
	
	String query;
	
	global CreateFieldLogicRecords() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		query = 'SELECT id,Product__c,Sub_Products__c,Field_Name__c,Label__c FROM Field_Logic_New__c';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<String> products = new List<String>();
		Schema.DescribeFieldResult fieldResult = Cross_Sell_Logic__c.Products__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		List<Field_Logic_New__c> listOfFieldLogicReocrds = new List<Field_Logic_New__c>();

		for (Schema.PicklistEntry f : ple) {
			products.add(f.getLabel());
			system.debug('Products are '+f.getLabel());
		}

		for(sObject s : scope){
			Field_Logic_New__c fl = (Field_Logic_New__c)s;
			if( fl.Product__c=='Checking' && (!fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> checkingsubproducts = null;
				checkingsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : checkingsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}

			} else if( fl.Product__c=='Savings' && (!fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> savingsubproducts = null;
				savingsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : savingsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}
			} else if ( fl.Product__c=='Certificates' && (!fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> certsubproducts = null;
				certsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : certsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}
			} else if ( fl.Product__c=='Credit Cards' && (!fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> cCardssubproducts = null;
				cCardssubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : cCardssubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}
			} else if ( fl.Product__c=='Personal Loans' && (!fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> plsubproducts = null;
				plsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : plsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Vehicle Loans' && (!fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('HMDA_') && !fl.Field_Name__c.contains('fi_name') && !fl.Field_Name__c.contains('type_of_asset') && !fl.Field_Name__c.contains('value_of_balance') && !fl.Field_Name__c.contains('Qa') && !fl.Field_Name__c.contains('Qb') && !fl.Field_Name__c.contains('Qc') && !fl.Field_Name__c.contains('Qd') && !fl.Field_Name__c.contains('Qe') && !fl.Field_Name__c.contains('Qf') && !fl.Field_Name__c.contains('Qg') && !fl.Field_Name__c.contains('Qh') && !fl.Field_Name__c.contains('Qi') && !fl.Field_Name__c.contains('Qj') && !fl.Field_Name__c.contains('Qk') && !fl.Field_Name__c.contains('Ql') && !fl.Field_Name__c.contains('Qm') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> vlsubproducts = null;
				vlsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : vlsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Home Equity' && (!fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('MRT_') && !fl.Field_Name__c.contains('mrt_') && !fl.Field_Name__c.contains('HL_') && !fl.Field_Name__c.contains('hl_') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> hesubproducts = null;
				hesubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : hesubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Home Loan' && (!fl.Field_Name__c.contains('CERT_') && !fl.Field_Name__c.contains('Cert_') && !fl.Field_Name__c.contains('cds_') && !fl.Field_Name__c.contains('CD_') && !fl.Field_Name__c.contains('SAV_') && !fl.Field_Name__c.contains('Sav_') && !fl.Field_Name__c.contains('sav_') && !fl.Field_Name__c.contains('CHK_') && !fl.Field_Name__c.contains('Chk_') && !fl.Field_Name__c.contains('chk_') && !fl.Field_Name__c.contains('Ccard_') && !fl.Field_Name__c.contains('CC_') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CCards_') && !fl.Field_Name__c.contains('VehicleLoan_') && !fl.Field_Name__c.contains('Vehicle') && !fl.Field_Name__c.contains('HE_') && !fl.Field_Name__c.contains('he_') && !fl.Field_Name__c.contains('VL_') && !fl.Field_Name__c.contains('VIN') && !fl.Field_Name__c.contains('PeronalLoan_') && !fl.Field_Name__c.contains('PL_') && !fl.Field_Name__c.contains('Business') && !fl.Field_Name__c.contains('business') && !fl.Field_Name__c.contains('bus_') && !fl.Field_Name__c.contains('BUSAA_') && !fl.Field_Name__c.contains('BUSICDS_') && !fl.Field_Name__c.contains('BUSICHK_') && !fl.Field_Name__c.contains('sb_lc_') ) ) {
				List<Cross_Sell_Logic__c> hlsubproducts = null;
				hlsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : hlsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Business Checking' && (fl.Field_Name__c.contains('Business') || fl.Field_Name__c.contains('business') || fl.Field_Name__c.contains('bus') || fl.Field_Name__c.contains('Bus') || fl.Field_Name__c.contains('BUS') || fl.Field_Name__c.contains('BUSAA_') ) && (!fl.Field_Name__c.contains('SAV') && !fl.Field_Name__c.contains('Sav') && !fl.Field_Name__c.contains('sav') && !fl.Field_Name__c.contains('CDS') && !fl.Field_Name__c.contains('Cds') && !fl.Field_Name__c.contains('cds') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('Ccards') && !fl.Field_Name__c.contains('ccards') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('ccard') && !fl.Field_Name__c.contains('Ccard') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> buschksubproducts = null;
				buschksubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : buschksubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Business Savings' && (fl.Field_Name__c.contains('sb_lc') || fl.Field_Name__c.contains('Business') || fl.Field_Name__c.contains('business') || fl.Field_Name__c.contains('bus') || fl.Field_Name__c.contains('Bus') || fl.Field_Name__c.contains('BUS') || fl.Field_Name__c.contains('BUSAA_') ) && (!fl.Field_Name__c.contains('CHK') && !fl.Field_Name__c.contains('Chk') && !fl.Field_Name__c.contains('chk') && !fl.Field_Name__c.contains('CDS') && !fl.Field_Name__c.contains('Cds') && !fl.Field_Name__c.contains('cds') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('Ccards') && !fl.Field_Name__c.contains('ccards') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('ccard') && !fl.Field_Name__c.contains('Ccard') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> bussavsubproducts = null;
				bussavsubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : bussavsubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Business CDs' && (fl.Field_Name__c.contains('sb_lc') || fl.Field_Name__c.contains('Business') || fl.Field_Name__c.contains('business') || fl.Field_Name__c.contains('bus') || fl.Field_Name__c.contains('Bus') || fl.Field_Name__c.contains('BUS') || fl.Field_Name__c.contains('BUSAA_') ) && (!fl.Field_Name__c.contains('CHK') && !fl.Field_Name__c.contains('Chk') && !fl.Field_Name__c.contains('chk') && !fl.Field_Name__c.contains('SAV') && !fl.Field_Name__c.contains('Sav') && !fl.Field_Name__c.contains('sav') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('Ccards') && !fl.Field_Name__c.contains('ccards') && !fl.Field_Name__c.contains('ccard') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('Ccard') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> buscdssubproducts = null;
				buscdssubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : buscdssubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Business Credit Cards' && (fl.Field_Name__c.contains('sb_lc') || fl.Field_Name__c.contains('Business') || fl.Field_Name__c.contains('business') || fl.Field_Name__c.contains('bus') || fl.Field_Name__c.contains('Bus') || fl.Field_Name__c.contains('BUS') || fl.Field_Name__c.contains('BUSAA_') ) && (!fl.Field_Name__c.contains('CHK') && !fl.Field_Name__c.contains('Chk') && !fl.Field_Name__c.contains('chk') && !fl.Field_Name__c.contains('SAV') && !fl.Field_Name__c.contains('Sav') && !fl.Field_Name__c.contains('sav') && !fl.Field_Name__c.contains('Loan') && !fl.Field_Name__c.contains('loan') && !fl.Field_Name__c.contains('LOAN') && !fl.Field_Name__c.contains('CDS') && !fl.Field_Name__c.contains('Cds') && !fl.Field_Name__c.contains('cds') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ) {
				List<Cross_Sell_Logic__c> busccardssubproducts = null;
				busccardssubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : busccardssubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			} else if ( fl.Product__c=='Business Loans' && (fl.Field_Name__c.contains('sb_lc') || fl.Field_Name__c.contains('Business') || fl.Field_Name__c.contains('business') || fl.Field_Name__c.contains('bus') || fl.Field_Name__c.contains('Bus') || fl.Field_Name__c.contains('BUS') || fl.Field_Name__c.contains('BUSAA_') ) && (!fl.Field_Name__c.contains('CHK') && !fl.Field_Name__c.contains('Chk') && !fl.Field_Name__c.contains('chk') && !fl.Field_Name__c.contains('SAV') && !fl.Field_Name__c.contains('Sav') && !fl.Field_Name__c.contains('sav') && !fl.Field_Name__c.contains('Ccards') && !fl.Field_Name__c.contains('ccards') && !fl.Field_Name__c.contains('ccard') && !fl.Field_Name__c.contains('Ccard') && !fl.Field_Name__c.contains('Credit') && !fl.Field_Name__c.contains('credit') && !fl.Field_Name__c.contains('CREDIT') && !fl.Field_Name__c.contains('CDS') && !fl.Field_Name__c.contains('Cds') && !fl.Field_Name__c.contains('cds') && !fl.Field_Name__c.contains('options__c') && !fl.Field_Name__c.contains('street_address_1_aboutaccount__c') && !fl.Field_Name__c.contains('street_address_2_aboutaccount__c') && !fl.Field_Name__c.contains('city_aboutaccount__c') && !fl.Field_Name__c.contains('state_aboutaccount__c') && !fl.Field_Name__c.contains('zip_code_account__c') && !fl.Field_Name__c.contains('county_aboutaccount__c') && !fl.Field_Name__c.contains('year_built__c') && !fl.Field_Name__c.contains('property_current_residence__c') && !fl.Field_Name__c.contains('property_type__c') && !fl.Field_Name__c.contains('number_of_units__c') && !fl.Field_Name__c.contains('occupancy__c') && !fl.Field_Name__c.contains('estimated_gross_rental_income__c') && !fl.Field_Name__c.contains('hoa_dues__c') && !fl.Field_Name__c.contains('mortgage_applied_for__c') && !fl.Field_Name__c.contains('purpose_of_loan__c') && !fl.Field_Name__c.contains('mortgagetype_other__c') && !fl.Field_Name__c.contains('purchase_p__c') && !fl.Field_Name__c.contains('down_payment__c') && !fl.Field_Name__c.contains('total_loan_amount__c') && !fl.Field_Name__c.contains('monthly__c') && !fl.Field_Name__c.contains('monthly_insurance__c') && !fl.Field_Name__c.contains('discount_pt_buy_down_2__c') && !fl.Field_Name__c.contains('program_description_2__c') ) ){
				List<Cross_Sell_Logic__c> busloanssubproducts = null;
				busloanssubproducts = [SELECT Products__c, Sub_Products__c FROM Cross_Sell_Logic__c WHERE Products__c=:fl.Product__c];
				for(Cross_Sell_Logic__c csl : busloanssubproducts){
					Field_Logic_New__c flrecord = new Field_Logic_New__c();
					flrecord.Product__c = fl.Product__c;
					flrecord.Sub_Products__c = csl.Sub_Products__c;
					flrecord.Field_Name__c = fl.Field_Name__c;
					flrecord.Label__c = fl.Label__c;
					flrecord.IsDisplayed__c = true;
					flrecord.IsRequired__c = true;

					listOfFieldLogicReocrds.add(flrecord);
				}				
			}	
		}

		insert listOfFieldLogicReocrds;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}