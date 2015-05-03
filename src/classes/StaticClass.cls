public with sharing class StaticClass {
	public static boolean firstRun;
	public static boolean afterCall(){
		firstRun = true;
		return firstRun;
	}
	public static boolean beforeCall(){
		return firstrun;
	}
}