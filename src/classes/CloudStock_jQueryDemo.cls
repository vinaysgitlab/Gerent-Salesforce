public class CloudStock_jQueryDemo {
	
	///////////////////////////////////////
	// This class supports the CloudStock_jQueryDemo VF page
	// for the CloudStock 2012 jQuery presentation
	// Created 20120312 AAB / Demand Chain Systems
	// email:  andyb@demandchainsystems.com
	///////////////////////////////////////
	
	public String strAccountId {get;set;}
	public String strAcctName {get;set;}
	public String strAcctWeb {get;set;}
	public String strAcctPhone {get;set;}
	
	//////////////////////////////
	// Constructors
	//////////////////////////////
	
	public CloudStock_jQueryDemo() { }
	
	//////////////////////////////
	// GETers
	//////////////////////////////
	
	public List<Account> getlstAccounts() {
		
		List<Account> lstAcct = new List<Account>([SELECT Id, Name, Website, Phone FROM Account ORDER BY LastModifiedDate DESC LIMIT 5]);
		
		return lstAcct;
		
	}
	
	//////////////////////////////
	// Action Methods
	//////////////////////////////
	
	public void doNothing() { }
	
	public void createAccount() {
		
		Account acctNew = new Account();
		acctNew.Name = strAcctName;
		acctNew.Website = strAcctWeb;
		acctNew.Phone = strAcctPhone;
		
		insert acctNew;
		
	}
	
	public void deleteAccount() {
		
		Account acctDel = new Account(Id=strAccountId);
		
		delete acctDel;
		
	}
	
	

}