/**
 * Blacklist filter delegate contains all of the logic to implement keyword filtering
 * based on the value of the Blacklisted_Word__c or Custom_Expression__c field.
 * Author: qwall@salesforce.com
 */
public class BlacklistFilterDelegate
{
    public static Integer FEED_POST = 1;
    public static Integer FEED_COMMENT = 2;
    public static Integer USER_STATUS = 3;
    
    List<PatternHelper> patterns {set; get;} 
    Map<Id, PatternHelper> matchedPosts {set; get;}
    
    public BlacklistFilterDelegate()
    {
         patterns = new List<PatternHelper>();
         matchedPosts = new Map<Id, PatternHelper>(); 
         preparePatterns();
    }
    
    private void preparePatterns()
    {
         //fetch the blacklisted words
        List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                            Add_to_Compliance_Audit__c, Custom_Expression__c,
                                            Prevent_Post_on_Breach__c
                                         from Blacklisted_Word__c where is_Active__c = true];
    
        for(Blacklisted_Word__c bwc : bwWords)
        {
            patterns.add(new PatternHelper(bwc));
        }
        
    }
    
    /**
     * Given a list of FeedItems, filter them against the blacklisted words
     */
    public List<FeedItem> filterFeedItems(List<FeedItem> fi)
    {
        return filterBody(fi);
    }
    
    /**
     * Given a list of FeedComments, filter them against the blacklisted words
     */
    public List<FeedComment> filterFeedComments(List<FeedComment> fc)
    {
        return filterBody(fc);
    }
    
    /**
     * Given a list of Users, filter them against the blacklisted words
     */
    public List<User> filterUserStatus(List<User> users)
    {
        return filterBody(users);
    }
    
    /**
     * This is where the heavy lifting happens and matching is performed.
     * Use convenience methods filterFeedPosts, filterFeedComments, and filterUserStatus to return the 
     * correctly casted Lists
     */
    private List<SObject> filterBody(List<SObject> sobjs)
    {
        List<SObject> updatedSobjs = new List<SObject>();
        
         Matcher m;
        String body = null;
    
         for (SOBject f : sobjs)
         {
                boolean preventPost = false;
                
                if(f instanceOf FeedItem)
                    body = ((FeedItem)f).Body;
                else if(f instanceOf FeedComment)
                    body = ((FeedComment)f).CommentBody;
                else if( f instanceOf User)
                    body = ((User)f).CurrentStatus;
                
                boolean foundMatch = false;
                String strOld = '';
                
                for(PatternHelper ph : patterns)
                {
                       foundMatch = false;
                      
                      if(body == null) // 2/12: QW - handle file/link posts with no body
                          body = '';
                          
                       strOld = body;
                       body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                      
                          // 2/17: QW - fixed bug where strLength could be the same as a substituted pattern
                          //            resulting in an incorrect no match
                        if(strOld.compareTo(body) != 0)
                           foundMatch = true;
                      
                       if(foundMatch)
                       {
                          if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                          {
                              if(f instanceOf FeedItem)
                              {
                                     ph.origPostBody = ((FeedItem)f).Body;
                                     ph.postCreatedById = ((FeedItem)f).createdById;
                              }
                              else if(f instanceOf FeedComment)
                              {
                                     ph.origPostBody = ((FeedComment)f).CommentBody;
                                     ph.postCreatedById = ((FeedComment)f).createdById;
                              }
                              else if(f instanceOf User)
                              {
                                     ph.origPostBody = ((User)f).CurrentStatus;
                                     ph.postCreatedById = ((User)f).id;
                              }
                                    
                              matchedPosts.put(ph.blacklistedWord.id, ph);
                             
                          }
                           //only need to set one message per breach
                              if(ph.preventPostOnMatch)
                                  preventPost = true;
                                  
                       }
                 }
                 
                if(preventPost)   //note: should we display the blacklisted word to inform user of what they did?
                    f.addError('Post prevented due to use of a blacklisted word.');
                else
                {
                    if(f instanceOf FeedItem)
                    {
                        //apex doesn't seem to like this sort of casting...
                        //((FeedItem)f).Body = body; 
                        FeedItem fi = (FeedItem)f;
                        fi.Body = body;
                        updatedSobjs.add(fi);
                    }
                    else if(f instanceOf FeedComment)
                    {
                        //((FeedComment)f).CommentBody = body;
                        FeedComment fc = (FeedComment)f;
                        fc.CommentBody = body;
                        updatedSobjs.add(fc);
                         
                    }
                    else if(f instanceOf User)
                    {
                        //((FeedComment)f).CommentBody = body;
                        User u = (User)f;
                        u.CurrentStatus = body;
                        updatedSobjs.add(u);
                         
                    }
                }
 
         }
         
         doAudit();
         
         return updatedSobjs;
    }
    
    /**
     * If a blacklisted word is flagged as save to audit, lets write it to the blacklist audit list.
     */
    private void doAudit()
    {
        
        List< Blacklist_Audit__c> audits = new List<Blacklist_Audit__c>();
        Blacklist_Audit__c blaudit = null;
        
        for(PatternHelper p : matchedPosts.values())
        {
            
            //check for audit actions
            if(p.blacklistedWord.Add_to_Compliance_Audit__c)
            {
               blaudit = new Blacklist_Audit__c();
               blaudit.Breached_By__c = p.postCreatedById;
               blaudit.Unscrubbed_Post__c = p.origPostBody;
             
               if(p.blacklistedWord.Custom_Expression__c != NULL)
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Custom_Expression__c;
               else
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Word__c;
             
               audits.add(blaudit);
            }
            
            //check for notifier actions
            //TODO
        }
        
        if(!audits.isEmpty())
            insert audits;      
    }
}