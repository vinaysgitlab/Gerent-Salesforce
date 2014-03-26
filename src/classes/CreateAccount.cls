global class CreateAccount {
	
	webservice static String CreateAccountRecord(String aName, String OracleId){
	
		Account a = new Account();
		a.Name = aName;
		a.OracleId__c = OracleId;
		
		insert a;
		
		return a.Id;
		
	
	}

}