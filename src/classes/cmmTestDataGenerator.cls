/**
* Class used to generate test Data
*/
public class cmmTestDataGenerator{
    
    public static void createTestData(){
        
        List<Campaign> camps = [ Select Id from Campaign limit 1000 ];
        delete camps;
        
        // Create Campaign and Account Test Records
        Campaign testCampaign   = new Campaign( name='cmm_test_campaign', status='planned', IsActive = true );
        Account testAccount     = new Account( name='cmm_test_account' );
        
        insert testCampaign;
        insert testAccount;
                
        // Define Lists for Contact Lead and Campaign Member Test Records
        Contact[] testContactList   = new Contact[]{};
        Lead[] testLeadList         = new Lead[]{};
        CampaignMember[] testCampaignMemberList = new CampaignMember[]{};
        
        // Query for newly created Test Campaign and Account
        testCampaign    = [ select id, name, status from Campaign where name = 'cmm_test_campaign' order by name desc limit 1 ];
        testAccount     = [ select id, name from Account where name = 'cmm_test_account' ];

        // Create 15 Test Contacts
        for( Integer i = 0; i < 15; i++ ){
            testContactList.add( new Contact( lastname='cmm_test_contact_' + i, accountId = testAccount.Id ) );
        }
        insert testContactList;
        
        // Create 15 Test Leads
        for( Integer i = 0; i < 15; i++ ){
            testLeadList.add( new Lead( lastname = 'cmm_test_lead_' + i, company='cmm_test_company_' + i ) );
        }       
        insert testLeadList;
        
        // Query for newly created Test Contacts and Leads
        testContactList = [ select id, name from Contact where name like 'cmm_test_contact_%' order by name ];
        testLeadList    = [ select id, name from Lead where name like 'cmm_test_lead_%' order by name ];
        
        // Assign Test Contacts to Test Campaign
        for( Integer x = 0; x < testContactList.size(); x++ ){
            testCampaignMemberList.add( new CampaignMember(
                campaignId  = testCampaign.Id,
                contactId   = testContactList[x].Id, 
                status      = 'sent')
            );
        }
        
        // Assign Test Leads to Test Campaign
        for( Integer y = 0; y < testLeadList.size(); y++ ){
            testCampaignMemberList.add( new CampaignMember(
                campaignId  = testCampaign.Id,
                leadId      = testleadList[y].Id,
                status      = 'sent')
            );
        }       
        
        // Insert List of Test Campaign Members
        insert testCampaignMemberList;
    }       
    
    public static void createTestDataWithoutMembers(){
        
        List<Campaign> camps = [ Select Id from Campaign limit 1000 ];
        delete camps;
        
        // Create Campaign and Account Test Records
        Campaign testCampaign   = new Campaign( name='cmm_test_campaign', status='planned', IsActive = true );
        Account testAccount     = new Account( name='cmm_test_account' );
        
        insert testCampaign;
        insert testAccount;
                
        // Define Lists for Contact Lead and Campaign Member Test Records
        Contact[] testContactList   = new Contact[]{};
        Lead[] testLeadList         = new Lead[]{};
        CampaignMember[] testCampaignMemberList = new CampaignMember[]{};
        
        // Query for newly created Test Campaign and Account
        testCampaign    = [ select id, name, status from campaign where name = 'cmm_test_campaign' order by name desc limit 1 ];
        testAccount     = [ select id, name from account where name = 'cmm_test_account' ];

        // Create 15 Test Contacts
        for( Integer i = 0; i < 15; i++ ){
            testContactList.add( new Contact( lastname='cmm_test_contact_' + i, accountId = testAccount.Id ) );
        }
        insert testContactList;
        
        // Create 15 Test Leads
        for( Integer i = 0; i < 15; i++ ){
            testLeadList.add( new Lead( lastname = 'cmm_test_lead_' + i, company='cmm_test_company_' + i ) );
        }       
        insert testLeadList;
        
        // Query for newly created Test Contacts and Leads
        testContactList = [ select id, name from contact where name like 'cmm_test_contact_%' order by name ];
        testLeadList    = [ select id, name from lead where name like 'cmm_test_lead_%' order by name ];
        
    }       
}