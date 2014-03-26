/* Use case : By default the creating user is the owner of the record and get full access to the record
But if the owner is changed and the creating creating should still have access to the record & if the OWD on the object is private this trigger
creates a apex based sharing rule to the creating user of project when the owner is changed.*/

trigger ProjectAccesstoCreatingUser on Project__c (after update) {
	list<Id> projectIdlist = new list<Id>();
	list<Project__Share> newshareforCreatingUser = new list<Project__Share>();
	for(Project__c p: Trigger.New){
		if(trigger.oldMap.get(p.Id).OwnerId != p.OwnerId){
			Project__Share newps = new Project__Share();
			newps.ParentId = p.Id;
			newps.UserorGroupId = p.CreatedById;
			newps.AccessLevel='Edit';
			//newps.RowCause = 'CreatingUser';
			newshareforCreatingUser.add(newps);
		}
	}
	
	system.debug('>>>>---->Insert Sharing -- '+ newshareforCreatingUser);
	
	upsert newshareforCreatingUser;

}