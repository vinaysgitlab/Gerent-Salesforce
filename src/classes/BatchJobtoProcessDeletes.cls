global class BatchJobtoProcessDeletes implements Database.Batchable<sObject> {
	
	global final string query;
	
	global BatchJobtoProcessDeletes(String q){
	
		query = q;
	}
	
	global Database.Querylocator Start(Database.BatchableContext BC){
		// pass the query string to the batabase object
		return Database.getQueryLocator(query);
	}
	
	
	global void execute(Database.BatchableContext BC, List<sObject> Scope){
		// IN THIS Example we will just delte the record but you can implement any complex logic in here to process the records passedd by start method
	
		delete scope;
	
	}
	
	global void finish(Database.BatchableContext BC){

	// post processing operations like sending email
	
	AsyncApexJob a = [SELECT Id, MethodName, JobItemsProcessed, ApexClassId, CompletedDate, CreatedById, CreatedDate, NumberOfErrors, JobType, Status, ExtendedStatus, TotalJobItems FROM AsyncApexJob where Id=: BC.getJobId()];
	
	Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
	string[] toAddress = new String[]{};
	toAddress.add('vkanuganti@gerentllc.com');
	email.setToAddresses(toAddress);
	email.setSubject('Apex Batch Job : ' + a.MethodName + ' - Status: ' + a.Status);
	email.setPlainTextBody('The batch Apex job processed with total number of items: ' + a.TotalJobItems + ' - JobItemsProcessed - ' +a.JobItemsProcessed + ' - with number of errors - ' + a.NumberOfErrors);
	
	Messaging.sendEmail(new Messaging.Singleemailmessage[] {email});	
	
	}
	
	
}