global class SchedulableforBatchJobtoProcessdelete implements Schedulable{
	
	global void execute(SchedulableContext sc){
		String query = 'SELECT Id, Name,Order_Status__c FROM Order__c where Order_Status__c= \'Cancelled\'';
		BatchJobtoProcessDeletes batchapextest = new BatchJobtoProcessDeletes(query);
		Id batchprocessId = Database.executeBatch(batchapextest);
	
	}

}