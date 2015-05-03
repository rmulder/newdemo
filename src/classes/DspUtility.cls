public with sharing class DspUtility {

	public DspUtility() {
		
	}

	public static sObject getMessageObject(String msg) {
	    Note n = new Note();
	    n.Body = msg;
	    return (sObject)n;
	}

    public static Map<String,sObject> getServerMessages(Map<String,sObject> data) {
        List<Apexpages.Message> msgsList = ApexPages.getMessages();
        Note n = new Note();
        String msgs = '';
        for (Apexpages.Message m: msgsList) {
            msgs += m.getDetail() + '\n';
        }
        if (msgs != '') {
        	n.Body = msgs;
            data.put('server-errors', (sObject)n);
        }
        return data;
	}
}