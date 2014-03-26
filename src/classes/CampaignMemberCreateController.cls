public class CampaignMemberCreateController{
public Campaign cam {get; set;}
public Id currentCampaignId {get; set;}
public CampaignMemberCreateController(ApexPages.StandardController stdController) {
    Campaign cam = (Campaign)stdController.getRecord();
    currentCampaignId  = ApexPages.currentPage().getParameters().get('id');
    }

public pagereference CreateCampaignMember(){
    list<Id> cIds = new list<Id>();
    for(CampaignMember cm : [select Id, ContactId from CampaignMember where CampaignId =: currentCampaignId]){
      cIds.add(cm.ContactId);
    }
    Contact c = [Select Id from Contact where not(Id In : cIds) limit 1];
    CampaignMember cm = new CampaignMember (CampaignId = currentCampaignId , ContactId = c.Id );
    insert cm;
    return null;
    } 
}