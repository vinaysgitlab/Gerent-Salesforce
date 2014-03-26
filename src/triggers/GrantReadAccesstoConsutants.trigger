trigger GrantReadAccesstoConsutants on Project_Assigned__c (after insert, after update) {
    
    list<Id> projectIdlist = new list<Id>();
    list<Project__Share> newshareforConsultant = new list<Project__Share>();
    for(Project_Assigned__c pa: Trigger.New){
        Project__Share newps = new Project__Share();
        newps.ParentId = pa.Assigned_Project__c;
        newps.UserorGroupId = pa.Consultant_Name__c;
        newps.AccessLevel='Read';
        //newps.RowCause = 'CreatingUser';
        newshareforConsultant.add(newps);
    }
    
    system.debug('>>>>---->Insert Sharing -- '+ newshareforConsultant);
    
    upsert newshareforConsultant;
    

}