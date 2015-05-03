@isTest
global class DocusignAPI_Mock_Test implements WebServiceMock {
	
	global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType)
    {           
    	DocusignAPI.RequestSenderTokenResponse_element dr = new DocusignAPI.RequestSenderTokenResponse_element();
    	dr.RequestSenderTokenResult = 'Mock Response';
    	if(request instanceof DocusignAPI.RequestRecipientToken_element)
			response.put('response_x', new DocusignAPI.RequestRecipientTokenResponse_element());
		else if(request instanceof DocusignAPI.CreateEnvelopeFromTemplates_element)
			response.put('response_x', new DocusignAPI.CreateEnvelopeFromTemplatesResponse_element());
		else if(request instanceof DocusignAPI.CreateAndSendEnvelope_element)
			response.put('response_x', new DocusignAPI.CreateAndSendEnvelopeResponse_element());
		else if(request instanceof DocusignAPI.CreateEnvelopeFromTemplatesAndForms_element)
			response.put('response_x', new DocusignAPI.CreateEnvelopeFromTemplatesAndFormsResponse_element());
		else if(request instanceof DocusignAPI.SendEnvelope_element)
			response.put('response_x', new DocusignAPI.SendEnvelopeResponse_element()); 
		else if(request instanceof DocusignAPI.CreateEnvelope_element)
			response.put('response_x', new DocusignAPI.CreateEnvelopeResponse_element());
		else if(request instanceof DocusignAPI.RequestSenderToken_element)			
			response.put('response_x', dr);
			
		            
    }
	
}