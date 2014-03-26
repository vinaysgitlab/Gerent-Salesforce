@isTest(SeeAllData=false)
private class CloudStock_jQueryDemo_UnitTest {

	////////////////////////////////
	// This test class covers the SF Cloudstock 2012 jQuery demo
	////////////////////////////////

    static testMethod void testController() {
        
		// Instanciate Controller
		CloudStock_jQueryDemo clsDemo = new CloudStock_jQueryDemo();
		
		// Begin Test Scope
		test.startTest();
		
		// Call Account GETer
		List<Account> lstAccounts = clsDemo.getlstAccounts();
		
		// Call doNothing Method
		clsDemo.doNothing();
		
		// Call Account Create Method
		clsDemo.strAcctName = 'Test Account';
		clsDemo.strAcctWeb = 'http://www.andyboettcher.com';
		clsDemo.strAcctPhone = '(555) 555-1234';
		clsDemo.createAccount();
		
		// Call Account Deletion Method
		Account acct = [SELECT Id FROM Account WHERE Name = 'Test Account'];
		clsDemo.strAccountId = acct.Id;
		clsDemo.deleteAccount();
		

    }
}