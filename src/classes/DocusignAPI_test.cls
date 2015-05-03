@isTest
public class DocusignAPI_test{
	
	public static testMethod void test_method_one()
    {           
    	Test.setMock(WebServiceMock.class, new DocusignAPI_Mock_Test()); 
		DocusignAPI da = new DocusignAPI();
        DocusignAPI.EnvelopeInformation a  = new DocusignAPI.EnvelopeInformation();
        DocusignAPI.ArrayOfTemplateReference b  = new DocusignAPI.ArrayOfTemplateReference();
        DocusignAPI.Reminders c  = new DocusignAPI.Reminders();
        DocusignAPI.ArrayOfInlineTemplate d  = new DocusignAPI.ArrayOfInlineTemplate();
        DocusignAPI.SSN9Information e  = new DocusignAPI.SSN9Information();
        DocusignAPI.ArrayOfCustomField f  = new DocusignAPI.ArrayOfCustomField();
		DocusignAPI.Attachment j  = new DocusignAPI.Attachment();
        DocusignAPI.SSN9InformationInput k  = new DocusignAPI.SSN9InformationInput();
        DocusignAPI.FormDataXfdfField l  = new DocusignAPI.FormDataXfdfField();
        DocusignAPI.CreateEnvelopeFromTemplatesAndForms_element m  = new DocusignAPI.CreateEnvelopeFromTemplatesAndForms_element();
        DocusignAPI.TemplateReferenceFieldDataDataValue n  = new DocusignAPI.TemplateReferenceFieldDataDataValue();
        DocusignAPI.TemplateReference o  = new DocusignAPI.TemplateReference();
        DocusignAPI.CreateEnvelopeFromTemplates_element p  = new DocusignAPI.CreateEnvelopeFromTemplates_element();
        DocusignAPI.SendEnvelope_element q  = new DocusignAPI.SendEnvelope_element();
		DocusignAPI.ArrayOfAttachment r  = new DocusignAPI.ArrayOfAttachment();
        DocusignAPI.RecipientPhoneAuthentication s  = new DocusignAPI.RecipientPhoneAuthentication();        
        DocusignAPI.DocumentStatus t  = new DocusignAPI.DocumentStatus();
        DocusignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element u  = new DocusignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element();
        DocusignAPI.InlineTemplate v  = new DocusignAPI.InlineTemplate();
        DocusignAPI.Tab w  = new DocusignAPI.Tab();
        DocusignAPI.RecipientStatusEsignAgreementInformation x  = new DocusignAPI.RecipientStatusEsignAgreementInformation();
        DocusignAPI.ArrayOfRecipient1 z  = new DocusignAPI.ArrayOfRecipient1();
        DocusignAPI.CompositeTemplate a1  = new DocusignAPI.CompositeTemplate();
        DocusignAPI.Recipient a2  = new DocusignAPI.Recipient();
        DocusignAPI.ArrayOfFormDataXfdfField a3  = new DocusignAPI.ArrayOfFormDataXfdfField();
        DocusignAPI.CreateEnvelopeResponse_element a4  = new DocusignAPI.CreateEnvelopeResponse_element();
        DocusignAPI.EventResult a5 = new DocusignAPI.EventResult();
        DocusignAPI.SSN4Information a6  = new DocusignAPI.SSN4Information();
        DocusignAPI.DOBInformationInput a7  = new DocusignAPI.DOBInformationInput();
		DocusignAPI.Expirations a8  = new DocusignAPI.Expirations();
        DocusignAPI.CustomField a9  = new DocusignAPI.CustomField();
        DocusignAPI.ArrayOfTemplateReferenceRoleAssignment b1  = new DocusignAPI.ArrayOfTemplateReferenceRoleAssignment();
        DocusignAPI.RequestRecipientFaxToken_element b2  = new DocusignAPI.RequestRecipientFaxToken_element();
        DocusignAPI.ArrayOfString b3  = new DocusignAPI.ArrayOfString();
        DocusignAPI.TemplateReferenceFieldData b4  = new DocusignAPI.TemplateReferenceFieldData();
        DocusignAPI.Notification b5 = new DocusignAPI.Notification();
        DocusignAPI.ArrayOfTabStatus b6  = new DocusignAPI.ArrayOfTabStatus();
        DocusignAPI.FormDataXfdf b7  = new DocusignAPI.FormDataXfdf();
		DocusignAPI.ArrayOfDocument b8  = new DocusignAPI.ArrayOfDocument();
        DocusignAPI.RequestRecipientTokenAuthenticationAssertion b9  = new DocusignAPI.RequestRecipientTokenAuthenticationAssertion();
        DocusignAPI.RecipientCaptiveInfo c1  = new DocusignAPI.RecipientCaptiveInfo();
        DocusignAPI.RequestSenderToken_element c2  = new DocusignAPI.RequestSenderToken_element();
        DocusignAPI.CreateEnvelopeFromTemplatesResponse_element c3  = new DocusignAPI.CreateEnvelopeFromTemplatesResponse_element();
        DocusignAPI.DOBInformation c4  = new DocusignAPI.DOBInformation();
        DocusignAPI.ArrayOfString1 c5 = new DocusignAPI.ArrayOfString1();
        DocusignAPI.CreateAndSendEnvelope_element c6  = new DocusignAPI.CreateAndSendEnvelope_element();
        DocusignAPI.AddressInformationInput c7  = new DocusignAPI.AddressInformationInput();
		DocusignAPI.ArrayOfMatchBox c8  = new DocusignAPI.ArrayOfMatchBox();
        DocusignAPI.TemplateReferenceRoleAssignment c9  = new DocusignAPI.TemplateReferenceRoleAssignment();
        DocusignAPI.RequestRecipientToken_element d1  = new DocusignAPI.RequestRecipientToken_element();
        DocusignAPI.ArrayOfDocumentStatus d2  = new DocusignAPI.ArrayOfDocumentStatus();
        DocusignAPI.RequestRecipientTokenClientURLs d3  = new DocusignAPI.RequestRecipientTokenClientURLs();
        DocusignAPI.AuthenticationStatus d4  = new DocusignAPI.AuthenticationStatus();
        DocusignAPI.ArrayOfEnvelopeEvent d5 = new DocusignAPI.ArrayOfEnvelopeEvent();
        DocusignAPI.ArrayOfCompositeTemplate d6  = new DocusignAPI.ArrayOfCompositeTemplate();
        DocusignAPI.SendEnvelopeResponse_element d7  = new DocusignAPI.SendEnvelopeResponse_element();
		DocusignAPI.SSN4InformationInput d8  = new DocusignAPI.SSN4InformationInput();
        DocusignAPI.IDCheckInformation d9  = new DocusignAPI.IDCheckInformation();
        DocusignAPI.RecipientStatus e1  = new DocusignAPI.RecipientStatus();
        DocusignAPI.ServerTemplate e2  = new DocusignAPI.ServerTemplate();
        DocusignAPI.ArrayOfServerTemplate e3  = new DocusignAPI.ArrayOfServerTemplate();
        DocusignAPI.RequestSenderTokenResponse_element e4  = new DocusignAPI.RequestSenderTokenResponse_element();
        DocusignAPI.IDCheckInformationInput e5 = new DocusignAPI.IDCheckInformationInput();
        DocusignAPI.Document e6  = new DocusignAPI.Document();
        DocusignAPI.EventNotification e7  = new DocusignAPI.EventNotification();
		DocusignAPI.ArrayOfRecipient e8  = new DocusignAPI.ArrayOfRecipient();
        DocusignAPI.Envelope e9  = new DocusignAPI.Envelope();
        DocusignAPI.FormData f1  = new DocusignAPI.FormData();
        DocusignAPI.ArrayOfTab f2  = new DocusignAPI.ArrayOfTab();
        DocusignAPI.TabStatus f3  = new DocusignAPI.TabStatus();
        DocusignAPI.VaultingOptions f4  = new DocusignAPI.VaultingOptions();
        DocusignAPI.ArrayOfRecipientStatus f5 = new DocusignAPI.ArrayOfRecipientStatus();
        DocusignAPI.EnvelopeEvent f6  = new DocusignAPI.EnvelopeEvent();
        DocusignAPI.AddressInformation f7  = new DocusignAPI.AddressInformation();
		DocusignAPI.CreateEnvelope_element f8  = new DocusignAPI.CreateEnvelope_element();
        DocusignAPI.AnchorTab f9  = new DocusignAPI.AnchorTab();
        DocusignAPI.VaultingDetails g1  = new DocusignAPI.VaultingDetails();
        DocusignAPI.MatchBox g2  = new DocusignAPI.MatchBox();
        DocusignAPI.PDFMetaDataTemplate g3  = new DocusignAPI.PDFMetaDataTemplate();
        DocusignAPI.CreateAndSendEnvelopeResponse_element g4  = new DocusignAPI.CreateAndSendEnvelopeResponse_element();
        DocusignAPI.RecipientSignatureInfo g5 = new DocusignAPI.RecipientSignatureInfo();
        DocusignAPI.ArrayOfTemplateReferenceFieldDataDataValue g6  = new DocusignAPI.ArrayOfTemplateReferenceFieldDataDataValue();
        DocusignAPI.RequestRecipientTokenResponse_element g7  = new DocusignAPI.RequestRecipientTokenResponse_element();
		DocusignAPI.APIServiceSoap g8  = new DocusignAPI.APIServiceSoap();
		
		DocusignAPI.EnvelopeStatus y2 = new DocusignAPI.EnvelopeStatus();
		y2 = g8.CreateAndSendEnvelope(e9);

		DocusignAPI.EnvelopeStatus y4 = new DocusignAPI.EnvelopeStatus();
		y4 = g8.SendEnvelope('abc','abc');	

		DocusignAPI.EnvelopeStatus y5 = new DocusignAPI.EnvelopeStatus();
		y5 = g8.CreateEnvelope(e9);

        String s1 = g8.RequestSenderToken('test', 'test', 'test');

        system.assertEquals('Mock Response', s1);
            
    }
	
}