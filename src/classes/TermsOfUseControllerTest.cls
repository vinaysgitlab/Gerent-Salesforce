/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TermsOfUseControllerTest {

    static testMethod void autoRunNoRedirectTest() {
        User usr = testUtils.createTestUserNotAcceptedTermsOfUse();
        System.debug('User: ' + usr);
        System.runAs(usr){
            ApexPages.currentPage().getParameters().put('isRedirect','true');
            TermsOfUseController controller = new TermsOfUseController ();
            PageReference pageRef = controller.autoRun();
            System.assert(pageRef == null);
        }
    }
    
    static testMethod void autoRunIsRedirectAcceptedTermsTest() {
        User usr = testUtils.createTestUserHasAcceptedTermsOfUse();
        System.debug('[autoRunIsRedirectAcceptedTermsTest]: User: ' + usr);
        System.runAs(usr){
            ApexPages.currentPage().getParameters().put('isRedirect','true');
            TermsOfUseController controller = new TermsOfUseController ();
            PageReference pageRef = controller.autoRun();
            System.assert(pageRef.getUrl().endsWith('/_ui/core/chatter/ui/ChatterPage') );
        }
    }    
    
    static testMethod void autoRunIsNotRedirectTest() {
        User usr = testUtils.createTestUserNotAcceptedTermsOfUse();
        System.debug('User: ' + usr);
        System.runAs(usr){
            ApexPages.currentPage().getParameters().put('isRedirect','false');
            TermsOfUseController controller = new TermsOfUseController ();
            PageReference pageRef = controller.autoRun();
            System.assert(pageRef == null);
        }
    }
    
    
    static testMethod void autoRunIsNotRedirectAcceptedTermsTest() {
        User usr = testUtils.createTestUserHasAcceptedTermsOfUse();
        System.debug('User: ' + usr);
        System.runAs(usr){
            ApexPages.currentPage().getParameters().put('isRedirect','false');
            TermsOfUseController controller = new TermsOfUseController ();
            PageReference pageRef = controller.autoRun();
            System.assert(pageRef == null);
        }
    }           
    
    static testMethod void continueToTest() {
        TermsOfUseController controller = new TermsOfUseController ();
        PageReference pageRef = controller.continueToChatter();
        Boolean isChatterRedirectEnabled = false ;
        Redirect_To_Chatter__c redirectToChatter = Redirect_To_Chatter__c.getValues('Terms Of Use') ;
        if(redirectToChatter != null) {
            isChatterRedirectEnabled = redirectToChatter.Is_Chatter_Redirect_Enabled__c;
        }
        
        if(isChatterRedirectEnabled) 
            System.assert(pageRef.getUrl().endsWith('/_ui/core/chatter/ui/ChatterPage') );
        else {
            System.assert(pageRef.getUrl().endsWith('/home/home.jsp') );            
        }        
    }
    
    static testMethod void toggleHideTermsOfUseTest() {
        User usr = testUtils.createTestUserNotAcceptedTermsOfUse();
        Id userId = usr.Id; 
        System.runAs(usr){
            TermsOfUseController controller = new TermsOfUseController ();
            TermsOfUseController.toggleHideTermsOfUse(true);
            usr =  [SELECT Id, Name, Accepted_Terms_of_Use__c FROM User WHERE Id = :userId];
            System.assert(usr.Accepted_Terms_of_Use__c);
        }
    }
    
    static testMethod void BarkTermsOfUseStandardControllerTest() {
        User usr = testUtils.createTestUserNotAcceptedTermsOfUse();
        System.runAs(usr){
            TermsOfUseController controller = new TermsOfUseController (new ApexPages.StandardController(usr));
        }
    }
}