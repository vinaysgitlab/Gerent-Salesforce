global with sharing class TermsOfUseController {

    private static Id currentUserId {get;set;}
    public static User currentUser {get;set;}
    
    public TermsOfUseController (ApexPages.StandardController controller) {
        currentUserId = UserInfo.getUserId();
        currentUser = [SELECT Id, Name, Accepted_Terms_of_Use__c FROM User WHERE Id = :currentUserId ];
    }

    public TermsOfUseController () {
        currentUserId = UserInfo.getUserId();
        currentUser = [SELECT Id, Name, Accepted_Terms_of_Use__c FROM User WHERE Id = :currentUserId ];
    }

    
    // Code we will invoke on page load.
    public PageReference autoRun() {
        System.debug('currentUser: ' + currentUser) ;
        if (currentUser != null) {
            String isRedirect = ApexPages.currentPage().getParameters().get('isRedirect');

            
            if (isRedirect != null && isRedirect == 'true' && currentUser.Accepted_Terms_of_Use__c ) {
                //Redirect to Chatter
                return getPageReference('/_ui/core/chatter/ui/ChatterPage');
            } 
        }
         return null;
     }
    
    private static PageReference getPageReference(String path) {
        PageReference pageRef = new PageReference(path);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    @RemoteAction
    global static void toggleHideTermsOfUse(Boolean hideTermsOfUse) { 
        User usr = [SELECT Id, Name, Accepted_Terms_of_Use__c FROM User WHERE Id = :UserInfo.getUserId()];
        usr.Accepted_Terms_of_Use__c = hideTermsOfUse;
        update usr ;
    }
    
    webService static Boolean hasAcceptedTermsOfUse() { 
        User usr = [SELECT Id, Name, Accepted_Terms_of_Use__c FROM User WHERE Id = :UserInfo.getUserId() ];
        return usr.Accepted_Terms_of_Use__c ;
    }
    
    public PageReference continueToChatter() {
        PageReference pageRef = null ;
        Boolean isChatterRedirectEnabled = false ;
        Redirect_To_Chatter__c redirectToChatter = Redirect_To_Chatter__c.getValues('Terms Of Use') ;
        if(redirectToChatter != null) 
            isChatterRedirectEnabled = redirectToChatter.Is_Chatter_Redirect_Enabled__c;
            
        if(isChatterRedirectEnabled) 
            pageRef = getPageReference('/_ui/core/chatter/ui/ChatterPage');
        else {
            pageRef = getPageReference('/home/home.jsp');
        }
        return pageRef ;
     }
}