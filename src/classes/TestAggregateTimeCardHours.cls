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
private class TestAggregateTimeCardHours {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Project__c p = new Project__c(Name='Project Alpha',Status__c='Open');
        
       	insert p;
       	
       	list<user> ulist = [select Id,Name from User where isActive = True limit 2];
       	User u1 = uList[0];
       	User u2 = uList[1];
        
        list<Timecard__c> tlist = new list<TimeCard__c>();
        
        for(integer i=0;i<=1; i++){
        	TimeCard__c t = new TimeCard__c(Project__c=p.Id,Consultant_Name__c=ulist[i].Id,Hours_Worked__c= 10);
        	tlist.add(t);
        }
        
        Test.startTest();
        
        insert tlist;
        
        Test.stopTest();
        
        system.assertEquals([select Number_of_Hours__c from Project__c where Id=: p.Id].Number_of_Hours__c, 20);
        
        delete tlist[0];
        
        system.assertEquals([select Number_of_Hours__c from Project__c where Id=: p.Id].Number_of_Hours__c, 10);
              
    }
}