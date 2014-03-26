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
public class testUtils {
	public static final String USER_PROFILE_NAME = 'Standard User';
	
	/* We do this darned near everywhere. */
	public static User createTestUserNotAcceptedTermsOfUse() {
		User usr = createUser();
		usr.Accepted_Terms_of_Use__c = false;
		update usr;
		return usr;
	}
	
		/* We do this darned near everywhere. */
	public static User createTestUserHasAcceptedTermsOfUse() {
		User usr = createUser();
		usr.Accepted_Terms_of_Use__c = true;
		update usr;
		return usr;
	}
	
    public static User createUser(){
      Profile profile = [Select Id From Profile Where Name=:USER_PROFILE_NAME];
      User user = new User(
        FirstName = 'Bruce',
        LastName = 'Wayne',
        Alias = 'Batman',
        email = 'bruce.wayne@zynga.com',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US',
        emailencodingkey = 'UTF-8',
        timezonesidkey = 'America/Chicago',
        username = 'bruce.wayne@wayneenterprises.com',
        ProfileId = profile.Id,
        CurrentStatus = 'Testing Current Status',
        isActive = true
      );
      insert user;
      return user;	
    }

	/* 11-02-2011 JTL Returns a List of users, pass in the integer from your calling class
	 *	** How to Use, Users is defined as a list  **
	 *	Users = testUtils.createListofUser(3);
	 *		testuser = Users[0];
	 *		testuser2 = Users[1];
	 *  	testuser3 = Users[2];	
	 *********************************************************/
    public static List<User> createListofUser(Integer intgr){
    	List<User> usr = new List<User>();
	    for(Integer i = 0; i< intgr; i++){
			Profile profile = [Select Id From Profile Where Name=:USER_PROFILE_NAME];
		    User user = new User(
		    FirstName = 'Hunter'+ i,
		    LastName = 'Thompson',
		    Alias = 'HST',
		    email = i+'HST@zynga.com',
		    languagelocalekey = 'en_US',
		    localesidkey = 'en_US',
		    emailencodingkey = 'UTF-8',
		    timezonesidkey = 'America/Chicago',
		    username = 'HST@gonzo.com' + i,
		    ProfileId = profile.Id,
		    CurrentStatus = 'Testing Current Status',
		    isActive = true
			);
	      
	      usr.add(user);	      	
		}
		insert usr;
    	return usr;
    }
}