@isTest
public class StaticClass_Test {
	//public static boolean firstRun = false;
    public static testMethod void staticTest(){
    	Boolean b = StaticClass.afterCall();
    	system.assertequals(true,b);
    	
    	Boolean a = StaticClass.beforeCall();
    	system.assertequals(true,a);
    	
    }
}