trigger AggregateTimeCardHours on TimeCard__c (after delete, after insert, after undelete, after update) {
	set<Id> projectIdlist = new set<Id>();
	list<TimeCard__c> tclist = new list<TimeCard__c>();
	
	if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
		for(TimeCard__c tc:trigger.new){
			projectIdlist.add(tc.Project__c);
			tclist.add(tc);
		}
	}
	
	if(trigger.isDelete){
		for(TimeCard__c tc:trigger.old){
			projectIdlist.add(tc.Project__c);
			tclist.add(tc);
		}
	}
	
	if(projectIdlist != null && projectIdlist.size()>0){
		
		map<Id, double> projectMap = new map<Id, double> ();
		
		for(AggregateResult q : [SELECT Sum(Hours_Worked__c),  Project__c FROM TimeCard__c where Project__c =: projectIdlist group by Project__c]){
		
			projectMap.put((Id) q.get('Project__c'), (Double) q.get('expr0'));
		
		}
		
		list<Project__c> projecttobeupdated = new list<Project__c>();
		for(Project__c p: [select Id, Number_of_Hours__c from Project__c where Id =: projectIdlist ]){
		
			p.Number_of_Hours__c = projectMap.get(p.Id);
			projecttobeupdated.add(p);
		}
		
		update projecttobeupdated;
		
		 
		
	
	}
	
}