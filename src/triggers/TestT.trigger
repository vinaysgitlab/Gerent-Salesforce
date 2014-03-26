trigger TestT on TimeCard__c (after delete, after insert, after undelete, after update) { 

  //Limit the size of list by using Sets which do not contain duplicate elements
  set<Id> projectIdlist = new set<Id>();
 
  //When adding new payments or updating existing payments
  if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
    for(TimeCard__c tc:trigger.new){
			projectIdlist.add(tc.Project__c);
	}
  }
 
  //When deleting payments
  if(trigger.isDelete){
     for(TimeCard__c tc:trigger.old){
			projectIdlist.add(tc.Project__c);
	}
  }
 
  //Map will contain one project Id to one sum value
  map<Id,double> projectMap = new map<Id,double> ();
 
  //Produce a sum of Payments__c and add them to the map
  //use group by to have a single Opportunity Id with a single sum value
  for(AggregateResult q : [select Project__c,sum(Hours_Worked__c)
    from TimeCard__c where Project__c IN :projectIdlist group by Project__c]){
    	
      projectMap.put((Id)q.get('Project__c'),(Double)q.get('expr0'));
      
  }
 
  List<Project__c> projectsToUpdate = new List<Project__c>();
 
  //Run the for loop on Opportunity using the non-duplicate set of Opportunities Ids
  //Get the sum value from the map and create a list of Opportunities to update
  for(Project__c p : [Select Id, Number_of_Hours__c from Project__c where Id IN :projectIdlist]){
    Double TotalHours = projectMap.get(p.Id);
    p.Number_of_Hours__c = TotalHours;
    projectsToUpdate.add(p);
  }
 
  update projectsToUpdate;

}