global class Installer implements InstallHandler {

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///// ***** Loading Data into Custom objects post Installation  *****//////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// Loading data into the Collateral Info Object post installation
		@future(callout=true)
		global static void collateraInfoDatainsert1(){
			List<StaticResource> collateralInfoStaticResource_1 = new List<StaticResource>();
			if(Test.isRunningTest()){
				collateralInfoStaticResource_1 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_For_TestClass'];
			} else {
				collateralInfoStaticResource_1 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_1'];
			}	
			if(collateralInfoStaticResource_1.size() > 0){
				if(collateralInfoStaticResource_1[0] != null){
					transient List<CollateralInfo__c> collateralInfo1 = (List<CollateralInfo__c>) JSON.deserialize(collateralInfoStaticResource_1[0].Body.toString(), List<CollateralInfo__c>.class);
					try{
						insert collateralInfo1;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}	
			}
		}			
		@future(callout=true)
		global static void collateraInfoDatainsert2(){
			List<StaticResource> collateralInfoStaticResource_2 = new List<StaticResource>();
			if(Test.isRunningTest()){
				collateralInfoStaticResource_2 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_For_TestClass'];
			} else {
				collateralInfoStaticResource_2 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_2'];
			}
			if(collateralInfoStaticResource_2.size() > 0){
				if(collateralInfoStaticResource_2[0] != null){
					transient List<CollateralInfo__c> collateralInfo2 = (List<CollateralInfo__c>) JSON.deserialize(collateralInfoStaticResource_2[0].Body.toString(), List<CollateralInfo__c>.class);
					try{
						insert collateralInfo2;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}	
			}
		}
		@future(callout=true)
		global static void collateraInfoDatainsert3(){
			List<StaticResource> collateralInfoStaticResource_3 = new List<StaticResource>();
			if(Test.isRunningTest()){
				collateralInfoStaticResource_3 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_For_TestClass'];
			} else {
				collateralInfoStaticResource_3 = [select Body from StaticResource where Name = 'CollateralInfo_PostInstall_3'];
			}			
			if(collateralInfoStaticResource_3.size() > 0){
				if(collateralInfoStaticResource_3[0] != null){
					transient List<CollateralInfo__c> collateralInfo3 = (List<CollateralInfo__c>) JSON.deserialize(collateralInfoStaticResource_3[0].Body.toString(), List<CollateralInfo__c>.class);
					try{
						insert collateralInfo3;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}	
			}
		}	

		// Loading data into the Cross Sell Logic Info Object post installation
		@future(callout=true)
		global static void crossSellDatainsert(){
			List<StaticResource> crossSellLogicStaticResource = [select Body from StaticResource where Name = 'CrossSell_Logic_PostInstall'];
			if(crossSellLogicStaticResource.size() > 0){
				if(crossSellLogicStaticResource[0] != null){
					transient List<Cross_Sell_Logic__c> crossSellLogic = (List<Cross_Sell_Logic__c>) JSON.deserialize(crossSellLogicStaticResource[0].Body.toString(), List<Cross_Sell_Logic__c>.class);
					try{
						insert crossSellLogic;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}
			
		// Loading data into the Customer Object post installation
		@future(callout=true)
		global static void customerDatainsert(){
			List<StaticResource> customerStaticResource = [select Body from StaticResource where Name = 'Customer_PostInstall'];
			if(customerStaticResource.size() > 0){
				if(customerStaticResource[0] != null){
					transient List<Customer__c> cust = (List<Customer__c>) JSON.deserialize(customerStaticResource[0].Body.toString(), List<Customer__c>.class);
					try{
						insert cust;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}		

		// Loading data into the Disclosure Object post installation
		@future(callout=true)
		global static void disclosureDatainsert(){
			List<StaticResource> disclosureResource = [select Body from StaticResource where Name = 'Disclosures_PostInstall'];
			if(disclosureResource.size() > 0){
				if(disclosureResource[0] != null){
					transient List<Disclosure__c> disc = (List<Disclosure__c>) JSON.deserialize(disclosureResource[0].Body.toString(), List<Disclosure__c>.class);
					try{
						insert disc;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			///// ***** Creating and Attaching Sample attachments for the Disclosures  *****//////
			////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			List<Attachment> attachments = new List<Attachment>();
			List<Disclosure__c> disclosure = [SELECT Id,Name FROM Disclosure__c];
			List<StaticResource> dis = [SELECT Body from StaticResource where Name = 'DisclosurePlaceholder'];
			List<StaticResource> disDS = [SELECT Body from StaticResource where Name = 'DisclosurePlaceholder_DS'];
			if(disclosure.size() > 0){
			    for(Disclosure__c disc : disclosure){
			        if(!disc.name.contains('- DS')){
			            //PageReference p = page.DisclosurePlaceholder;
			            Attachment attach = new Attachment();
			            attach.ParentId = disc.Id;  
			            attach.Name = disc.Name+'.pdf';
			            attach.IsPrivate = false;
			            if(Test.isRunningTest()){
			                attach.Body = Blob.valueOf('Attachment Body for Test Class');
			            } else {
			            	if(dis.size() > 0){
			            		if(dis[0] != null){
			            			attach.Body = dis[0].Body;
			            		} else {
			            			attach.Body = Blob.valueOf('Disclosure Placeholder');
			            		}
		            		} else {
		            			attach.Body = Blob.valueOf('Disclosure Placeholder');
		            		}
			            }  
			            attachments.add(attach);
			        } else{
			            Attachment attach = new Attachment();
			            attach.ParentId = disc.Id;  
			            attach.Name = disc.Name+'.pdf'; 
			            attach.IsPrivate = false; 
			            if(Test.isRunningTest()){
			                attach.Body = Blob.valueOf('Attachment Body for Test Class');
			            } else {
			            	if(disDS.size() > 0){
			            		if(disDS[0] != null){
			            			attach.Body = disDS[0].Body;
			            		} else {
			            			attach.Body = Blob.valueOf('Disclosure Placeholder');
			            		}
			            	} else {
			            		attach.Body = Blob.valueOf('Disclosure Placeholder');
			            	}      
			            }
			            attachments.add(attach);
			        }
			    }
			    try{
			        insert attachments;
			    } catch(Exception e){
			        system.debug('The exception error message is '+e);
			    }   
			}
		}
			
		// Loading data into the Existing Accounts Object post installation
		@future(callout=true)
		global static void existCustDatainsert(){
			List<StaticResource> existingAccountsResource = [select Body from StaticResource where Name = 'ExistingAccounts_PostInstall'];
			if(existingAccountsResource.size() > 0){
				if(existingAccountsResource[0] != null){
					transient List<Existing_Account__c> existAccounts = (List<Existing_Account__c>) JSON.deserialize(existingAccountsResource[0].Body.toString(), List<Existing_Account__c>.class);
					try{
						insert existAccounts;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}	

		// Loading data into the Customer Accounts Object post installation
		@future(callout=true)
		global static void cusAccountDatainsert(){
			List<StaticResource> customerAccountsStaticResource = [select Body from StaticResource where Name = 'CustomerAccounts_PostInstall'];
			if(customerAccountsStaticResource.size() > 0){
				if(customerAccountsStaticResource[0] != null){
					transient List<Customer_Account__c> cusAccounts = (List<Customer_Account__c>) JSON.deserialize(customerAccountsStaticResource[0].Body.toString(), List<Customer_Account__c>.class);
					try{
						insert cusAccounts;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
		}
			
		// Loading data into the Field Logic Object post installation
		@future(callout=true)
		global static void fieldLogicDatainsert1(){
			List<StaticResource> fieldLogicStaticResource_1 = new List<StaticResource>();
			if(Test.isRunningTest()){
				fieldLogicStaticResource_1 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_For_TestClass'];
			} else {
				fieldLogicStaticResource_1 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_1'];
			}
			transient List<Field_Logic_New__c> fl1 = new List<Field_Logic_New__c>();
			if(fieldLogicStaticResource_1.size() > 0){
				if(fieldLogicStaticResource_1[0] != null){
					for( Field_Logic_New__c flog : (List<Field_Logic_New__c>) JSON.deserialize(fieldLogicStaticResource_1[0].Body.toString(), List<Field_Logic_New__c>.class)){
						fl1.add(flog);
					}
					try{
						insert fl1;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}
		@future(callout=true)
		global static void fieldLogicDatainsert2(){
			List<StaticResource> fieldLogicStaticResource_2 = new List<StaticResource>();
			if(Test.isRunningTest()){
				fieldLogicStaticResource_2 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_For_TestClass'];
			} else {
				fieldLogicStaticResource_2 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_2'];
			}
			if(fieldLogicStaticResource_2.size() > 0){
				if(fieldLogicStaticResource_2[0] != null){
					transient List<Field_Logic_New__c> fl2 = (List<Field_Logic_New__c>) JSON.deserialize(fieldLogicStaticResource_2[0].Body.toString(), List<Field_Logic_New__c>.class);
					try{
						insert fl2;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}				
				}
			}
		}
		@future(callout=true)
		global static void fieldLogicDatainsert3(){
			List<StaticResource> fieldLogicStaticResource_3 = new List<StaticResource>();
			if(Test.isRunningTest()){
				fieldLogicStaticResource_3 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_For_TestClass'];
			} else {
				fieldLogicStaticResource_3 = [select Body from StaticResource where Name = 'FieldLogic_PostInstall_3'];
			}		
			if(fieldLogicStaticResource_3.size() > 0){
				if(fieldLogicStaticResource_3[0] != null){
					transient List<Field_Logic_New__c> fl3 = (List<Field_Logic_New__c>) JSON.deserialize(fieldLogicStaticResource_3[0].Body.toString(), List<Field_Logic_New__c>.class);
					try{
						insert fl3;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}	

		// Loading data into the Seg Emaployer Code Object post installation
		@future(callout=true)
		global static void segEmpCodeDatainsert(){	
			List<StaticResource> segEmployerCodeStaticResource = [select Body from StaticResource where Name = 'Seg_Emaployer_Code_PostInstall'];
			if(segEmployerCodeStaticResource.size() > 0){
				if(segEmployerCodeStaticResource[0] != null){
					transient List<Seg_Employer_Codes__c> sec = (List<Seg_Employer_Codes__c>) JSON.deserialize(segEmployerCodeStaticResource[0].Body.toString(), List<Seg_Employer_Codes__c>.class);
					try{
						insert sec;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}
			
		// Loading data into the Term Auto Loan Object post installation
		@future(callout=true)
		global static void termAutoLoanDatainsert(){
			List<StaticResource> termAutoLoanStaticResource = [select Body from StaticResource where Name = 'TermAutoLoan_PostInstall'];
			if(termAutoLoanStaticResource.size() > 0){
				if(termAutoLoanStaticResource[0] != null){
					transient List<TermAutoLoans__c> tal = (List<TermAutoLoans__c>) JSON.deserialize(termAutoLoanStaticResource[0].Body.toString(), List<TermAutoLoans__c>.class);
					try{
						insert tal;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
		}	

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///// ***** Loading Data into Custom settings post Installation  *****//////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		@future(callout=true)
		global static void customsettingDatainsert(){
			// Loading data into the Application Config custom setting post installation
			List<StaticResource> applicationConfigStaticResource = [select Body from StaticResource where Name = 'ApplicationConfiguration_PostInstall'];
			if(applicationConfigStaticResource.size() > 0){
				if(applicationConfigStaticResource[0] != null){
					transient List<Application_Configuration__c> appConfig = (List<Application_Configuration__c>) JSON.deserialize(applicationConfigStaticResource[0].Body.toString(), List<Application_Configuration__c>.class);
					try{
						insert appConfig;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the Confirmation Custom Setting post installation
			List<StaticResource> confirmationStaticResource = [select Body from StaticResource where Name = 'Confirmation_PostInstall'];
			if(confirmationStaticResource.size() > 0){
				if(confirmationStaticResource[0] != null){
					transient List<Confirmation__c> confirm = (List<Confirmation__c>) JSON.deserialize(confirmationStaticResource[0].Body.toString(), List<Confirmation__c>.class);
					try{
						insert confirm;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the Deposit Amount Validation custom settings post installation
			List<StaticResource> depositAmtValidationStaticResource = [select Body from StaticResource where Name = 'DepositAmountValidation_PostInstall'];
			if(depositAmtValidationStaticResource.size() > 0){
				if(depositAmtValidationStaticResource[0] != null){
					transient List<Deposit_Amount_Validation__c> dav = (List<Deposit_Amount_Validation__c>) JSON.deserialize(depositAmtValidationStaticResource[0].Body.toString(), List<Deposit_Amount_Validation__c>.class);
					try{
						insert dav;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
			// Loading data into the Disclosure Names Custom setting post installation
			List<StaticResource> disclosureNamesStaticResource = [select Body from StaticResource where Name = 'DisclosureNames_PostInstall'];
			if(disclosureNamesStaticResource.size() > 0){
				if(disclosureNamesStaticResource[0] != null){
					transient List<Disclosure_Names__c> discNames = (List<Disclosure_Names__c>) JSON.deserialize(disclosureNamesStaticResource[0].Body.toString(), List<Disclosure_Names__c>.class);
					try{
						insert discNames;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the Docusign Config Custom setting post installation
			List<StaticResource> docusignConfigStaticResource = [select Body from StaticResource where Name = 'Docusign_Config_PostInstall'];
			if(docusignConfigStaticResource.size() > 0){
				if(docusignConfigStaticResource[0] != null){
					transient List<Docusign_Config__c> docuSignConfig = (List<Docusign_Config__c>) JSON.deserialize(docusignConfigStaticResource[0].Body.toString(), List<Docusign_Config__c>.class);
					try{
						insert docuSignConfig;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the DSP Status post installation
			List<StaticResource> dspStatucStaticResource = [select Body from StaticResource where Name = 'DSP_status_PostInstall'];
			if(dspStatucStaticResource.size() > 0){
				if(dspStatucStaticResource[0] != null){
					transient List<DSP_Status__c> dspStat = (List<DSP_Status__c>) JSON.deserialize(dspStatucStaticResource[0].Body.toString(), List<DSP_Status__c>.class);
					try{
						insert dspStat;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the Google Tags post installation
			List<StaticResource> googleTagsStaticResource = [select Body from StaticResource where Name = 'Google_Tags_PostInstall'];
			if(googleTagsStaticResource.size() > 0){
				if(googleTagsStaticResource[0] != null){
					transient List<Google_Tags__c> googleTag = (List<Google_Tags__c>) JSON.deserialize(googleTagsStaticResource[0].Body.toString(), List<Google_Tags__c>.class);
					try{
						insert googleTag;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the Product codes Custom setting post installation
			List<StaticResource> productcodesStaticResource = [select Body from StaticResource where Name = 'Product_codes_PostInstall'];
			if(productcodesStaticResource.size() > 0){
				if(productcodesStaticResource[0] != null){
					transient List<Product_Codes__c> prdCodes = (List<Product_Codes__c>) JSON.deserialize(productcodesStaticResource[0].Body.toString(), List<Product_Codes__c>.class);
					try{
						insert prdCodes;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}					
				}
			}
			// Loading data into the Product Names Mapping Custom Settings post installation
			List<StaticResource> productCodesMappingStaticResource = [select Body from StaticResource where Name = 'ProductNamesMappind_PostInstall'];
			if(productCodesMappingStaticResource.size() > 0){
				if(productCodesMappingStaticResource[0] != null){
					transient List<Product_Names_Mapping__c> prdNamesMap = (List<Product_Names_Mapping__c>) JSON.deserialize(productCodesMappingStaticResource[0].Body.toString(), List<Product_Names_Mapping__c>.class);
					try{
						insert prdNamesMap;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
			// Loading data into the test class Product names custom setings post installation
			List<StaticResource> testClassProductNamesStaticResource = [select Body from StaticResource where Name = 'TestClassProductNames_PostInstall'];
			if(testClassProductNamesStaticResource.size() > 0){
				if(testClassProductNamesStaticResource[0] != null){
					transient List<Test_Class_Product_Names__c> testClassPrdtNames = (List<Test_Class_Product_Names__c>) JSON.deserialize(testClassProductNamesStaticResource[0].Body.toString(), List<Test_Class_Product_Names__c>.class);
					try{
						insert testClassPrdtNames;
					} catch(Exception e){
						system.debug('The exception error message is '+e);
					}
				}
			}
		}
			

    global void onInstall(InstallContext context) {

    	// If installing for the first time, setup data.
    	if (context.previousVersion() == null) {

    		//Calling the genMasterKey method in CryptoHelper to generate the key in Crypto__c custom settings
    		CryptoHelper.genMasterKey();
    		collateraInfoDatainsert1();
    		collateraInfoDatainsert2();
    		collateraInfoDatainsert3();
    		crossSellDatainsert();
    		customerDatainsert();
    		disclosureDatainsert();
    		existCustDatainsert();
    		cusAccountDatainsert();
    		fieldLogicDatainsert1();
    		fieldLogicDatainsert2();
    		fieldLogicDatainsert3();
    		segEmpCodeDatainsert();
    		termAutoLoanDatainsert();
    		customsettingDatainsert();
    	}
    }

}