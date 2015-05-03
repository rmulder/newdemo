global with sharing class JSRemotingBasicsController {
    public JSRemotingBasicsController() {
    }
     
    @RemoteAction
    public static String doGetText() {
        return 'Hey, we got a response!';
    }
}