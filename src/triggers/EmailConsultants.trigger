trigger EmailConsultants on Project__c (after update) {
	list<Id> projectIds = new list<Id>();
	
	for(Project__c p: trigger.new){
		if(trigger.oldMap.get(p.Id).Status__c != p.Status__c && p.Status__c == 'Closed'){
			projectIds.add(p.Id);
		}
	}
	
	if(projectIds != null && projectIds.size()>0){
	
		list<Project_Assigned__c> paList = [SELECT Id,Assigned_Project__c,Assigned_Project__r.Name, Consultant_Name__c,Consultant_Name__r.Email FROM Project_Assigned__c where Assigned_Project__c =: projectIds];
		
		if(paList != null && paList.size()>0 ){
			Messaging.Singleemailmessage[] emails = new Messaging.Singleemailmessage[]{};
			for(Project_Assigned__c pa : paList){
				if(pa.Consultant_Name__r.Email != null && pa.Consultant_Name__r.Email != ''){
					Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
					string[] toAddress = new String[]{};
					toAddress.add(pa.Consultant_Name__r.Email);
					email.setToAddresses(toAddress);
					email.setSubject('Project Closed : ' +pa.Assigned_Project__r.Name);
					email.setPlainTextBody('Project Closed :' + pa.Assigned_Project__r.Name);
					
					 emails.add(email);
				}
			}
			
			try{
				Messaging.Sendemailresult[] result = Messaging.sendEmail(emails); 
			}catch(Exception ex){
				system.debug('Error occured when sending email -- User'+ UserInfo.getUserId() );
			
			}
		
		}
	
	}
}