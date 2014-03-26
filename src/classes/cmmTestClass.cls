/**
* Test Class
*/
@isTest private without sharing class cmmTestClass{
    
    static testMethod void testCampaignMembershipManager(){
        
        cmmCampaignMembershipManagerController aux = new cmmCampaignMembershipManagerController();
        Boolean anotherAux = aux.getNextButtonEnabled(); 
        aux.getCampaignMembers();
        
        // Call cmmTestDataGenerator class to create Test Data
        cmmTestDataGenerator.createTestData(); 
    
        Campaign testCampaign = [ select id, name, status from campaign where name = 'cmm_test_campaign' order by name desc limit 1 ];
    
        test.startTest();
        
        PageReference cmmCampaignMembershipManagerPage = Page.cmmCampaignMembershipManagerPage;
        Test.setCurrentPage( cmmCampaignMembershipManagerPage );
        ApexPages.currentPage().getParameters().put( 'selectedCampaign', testCampaign.id );
    
        // Instanciate Controller
        cmmCampaignMembershipManagerController controller = new cmmCampaignMembershipManagerController();
        
        // Call Methods
        String userLanguage = controller.getUserLanguage();
        List<SelectOption> campaigns = controller.getCampaigns();
        System.assert( campaigns.size() == 1 , 'Method returned : ' + campaigns.size() );
        
        controller.setSelectedCampaign( testCampaign.Id );
        
        String CampaignDescription = controller.getCampaignDescription();
        controller.doSearch();  
        List<cmmCampaignMembershipManagerController.myCampaignMember> members = controller.getCampaignMembers();
        System.assert( members.size() == 10 , 'Method returned : ' + members.size() );
        
        Boolean PreviousButtonEnabled   = controller.getPreviousButtonEnabled();
        Boolean NextButtonEnabled       = controller.getNextButtonEnabled();  
        System.assert( PreviousButtonEnabled == true );
        System.assert( NextButtonEnabled == false  );
        
        controller.recalculateSelected();
        controller.nextBtnClick();
        members = controller.getCampaignMembers();
        System.assert( members.size() == 10 , 'Method returned : ' + members.size() );
        
        Integer selectedRows = controller.getSelectedRows();
        
        controller.previousBtnClick();
        controller.getCampaignMembers();
        
        Integer pageSize        = controller.getPageSize();
        Integer pageNumber      = controller.getPageNumber();
        Integer totalPageNumber = controller.getTotalPageNumber();      
        
        controller.processSelected();
        controller.clearMessage();
        
        test.stopTest();
    }   
    
     static testMethod void testCampaignMembershipManagerWithoutMembers(){
        
        cmmCampaignMembershipManagerController aux = new cmmCampaignMembershipManagerController();
        Boolean anotherAux = aux.getNextButtonEnabled(); 
        aux.getCampaignMembers();
        
        // Call cmmTestDataGenerator class to create Test Data
        cmmTestDataGenerator.createTestDataWithoutMembers(); 
    
        Campaign testCampaign = [ select id, name, status from campaign where name = 'cmm_test_campaign' order by name desc limit 1 ];
    
        test.startTest();
        
        PageReference cmmCampaignMembershipManagerPage = Page.cmmCampaignMembershipManagerPage;
        Test.setCurrentPage( cmmCampaignMembershipManagerPage );
        ApexPages.currentPage().getParameters().put( 'selectedCampaign', testCampaign.id );
    
        // Instanciate Controller
        cmmCampaignMembershipManagerController controller = new cmmCampaignMembershipManagerController();
        
        // Call Methods
        String userLanguage = controller.getUserLanguage();
        List<SelectOption> campaigns = controller.getCampaigns();
        System.assert( campaigns.size() == 1 , 'Method returned : ' + campaigns.size() );
        
        controller.setSelectedCampaign( testCampaign.Id );
        
        String CampaignDescription = controller.getCampaignDescription();
        controller.doSearch();  
        
        Boolean PreviousButtonEnabled   = controller.getPreviousButtonEnabled();
        Boolean NextButtonEnabled       = controller.getNextButtonEnabled();  
        System.assert( PreviousButtonEnabled == true );
        System.assert( NextButtonEnabled == true  );
        
        controller.recalculateSelected();
        
        controller.processSelected();
        controller.clearMessage();
        
        test.stopTest();
    }   
}