public with sharing class RunRemoveIsdisplayedController {

	public PageReference Run() {
        ID b1 = Database.executeBatch(new RemoveIsdisplayed(),5000);
        return null;
    }
}