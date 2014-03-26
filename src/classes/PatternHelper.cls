/**
 * Convenience wrapper for Blacklist filter processing
 * Author: Quinton Wall - qwall@salesforce.com
 */
public class PatternHelper
{
    public String regexValue {set; get;}
    public Pattern p {set; get;}
    public String substitutionValue {set; get;}
    public boolean preventPostOnMatch {set; get;}
    public boolean silentlyDeletePost {set; get;}
    public boolean sendToSpamBox {set; get;}
    public Blacklisted_Word__c blacklistedWord {set; get;}
    public String origPostBody {set; get;}
    public Id spamboxUserId {get; set;}
    public String postCreatedById {set; get;}

    public PatternHelper(Blacklisted_Word__c bwc)
    {
        regexValue = bwc.RegexValue__c;
        p = Pattern.compile(bwc.RegexValue__c);
        substitutionValue =  bwc.Substitution__c;
        preventPostOnMatch = bwc.Prevent_Post_on_Breach__c;
        //sendToSpamBox = bwc.Send_to_Spambox_User__c;
       // spamboxUserId = bwc.Spambox_User__c;
        blacklistedWord = bwc;
     
    }

}