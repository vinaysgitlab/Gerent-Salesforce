/**
*  CMM Campaign Membership Manager
*  Copyright (c) 2009, Marcel Will, Sales Engineering, Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
public with sharing class cmmCampaignMembershipManagerController{
    
    private List<myCampaignMember>  campaignMemberList { get; set; }   
    private List<myCampaignMember>  CampaignMembers;            
    private List<myCampaignMember>  pageCampaignMemberList;          
    private List<CampaignMember>    deleteCampaignMembers;      
    private Map<Id, CampaignMember> selectedCampaignMembersMap;
    
    private String  selectedCampaign;
    private String  CampaignDescription;
    private String  userName;
    private String  userLanguage;
    private Integer pageNumber;
    private Integer pageSize;
    private integer totalPageNumber;
    private Integer selectedRows; 
    
    public Boolean selectAllCheckbox        { get; set; }
    public String  messageTitle             { get; set; }
    public String  messageDetail            { get; set; }
    public String  messageSeverity          { get; set; }
    transient public Boolean messageShow    { get; set; }
    
    /**
    * constructor
    */
    public cmmCampaignMembershipManagerController(){
        
        this.CampaignMembers            = new List<myCampaignMember>{};
        this.pageCampaignMemberList     = new List<myCampaignMember>{}; 
        this.deleteCampaignMembers      = new List<CampaignMember>();
        this.selectedCampaignMembersMap = new Map<Id, CampaignMember>();
        
        this.userName       = UserInfo.getUserId();
        this.userLanguage   = UserInfo.getLanguage();
        
        this.pageNumber         = 0;
        this.totalPageNumber    = 0;
        this.selectedRows       = 0;
        this.pageSize           = 10;
    }
    
    /**
    * Getter method to retrieve the user language
    * @return userLanguage
    */
    public String getUserLanguage(){
        return userLanguage.Substring( 0, 2 );
    }
    
    /**
    * Getter Method to retrieve the current page number
    * @return pageNumber
    */
    public Integer getPageNumber(){
        return pageNumber;
    }
    
    /**
    * Getter method to retrieve the page size
    * @return pageSize
    */
    public Integer getPageSize(){
        return pageSize;
    }
    
    /**
    * Getter method to enable previous button
    * @return Boolean
    */
    public Boolean getPreviousButtonEnabled(){
        return !( pageNumber > 1 );
    }
    
    /**
    * Getter method to enable Next button
    * @return Boolean
    */
    public Boolean getNextButtonEnabled(){
        if( campaignMemberList == null ){
            return true;
        }else{
            return ( ( pageNumber * pageSize ) >= campaignMemberList.size() );
        }
    }
    
    /**
    * Getter method to retrieve total page number
    * @return totalPageNumber
    */
    public Integer getTotalPageNumber(){
        
        totalPageNumber = campaignMemberList.size() / pageSize;
        Integer mod     = campaignMemberList.size() - ( totalPageNumber * pageSize );
        
        if( mod > 0 ){
            totalPageNumber++;
        }
        
        return totalPageNumber;
    }
    
    /**
    * Getter method to retrieve Campaign member list
    * @return List<myCampaignMember>
    */
    public List<myCampaignMember> getCampaignMembers(){
        
        if( pageCampaignMemberList.Size() > 0 ){
            return pageCampaignMemberList;
        }else{
            return null;
        }
    }   
    
    /**
    * Getter to retrieve the number of selected rows
    * @return selectedRows
    */
    public Integer getSelectedRows(){
        return this.selectedRows;
    }
    
    /**
    * Recalculate Number of selected items in Grid
    * @return null
    */
    public Integer recalculateSelected(){
        selectedRows = selectedCampaignMembersMap.size();
        return null;
    }
    
    /**
    * Bind data to paged list for displaying on VF page
    * @param newPageIndex
    */
    private void BindData( Integer newPageIndex ){
        
        try{

            Transient Integer counter   = 0;
            Transient Integer min       = 0;
            Transient Integer max       = 0;
            
            if( newPageIndex > PageNumber ){
                min = pageNumber * pageSize;
                max = newPageIndex * pageSize;
            }else{
                max = newPageIndex * pageSize;
                min = max - pageSize;
            }
            
            CampaignMembers.clear();
            pageCampaignMemberList.clear();
            
            for( myCampaignMember cm: CampaignMemberList ){
                counter++;
                if( counter > min && counter <= max ){
                    pageCampaignMemberList.add( cm );
                }
            }
            pageNumber = newPageIndex;
            if( pageCampaignMemberList == null || pageCampaignMemberList.size() <= 0 ){
                messageTitle        = 'CMM_No_data';
                messageDetail       = 'CMM_No_data_available';
                messageSeverity     = 'info';
                messageShow         = true;
            }
        }catch( Exception ex ){
            messageTitle    = ex.getMessage();
            messageDetail   = ex.getMessage();
            messageSeverity = 'fatal';
            messageShow     = true;
        }
    }
    
    /**
    * Search for all Campaign Members of a selected campaign and put them into a list of <myCamapaignMember>
    * @return PageReference
    */
    public PageReference DoSearch(){
        
        this.campaignMemberList = new List<myCampaignMember>();
        this.pageCampaignMemberList.clear();
        
        for( CampaignMember cm: [ Select Id, LeadId, Lead.Company, Lead.Email, Lead.FirstName, Lead.LastName, Lead.OwnerId, Lead.City, ContactId, 
                                    Contact.Account.Name, Contact.Email, Contact.FirstName, Contact.LastName, Contact.OwnerId, Contact.MailingCity, Status 
                                    from CampaignMember 
                                    WHERE CampaignId =: selectedCampaign AND ( Contact.OwnerID =: userName OR Lead.OwnerID =: userName ) 
                                    ORDER BY Lead.LastName, Contact.LastName ] ){
                                        
            this.campaignMemberList.add( new MyCampaignMember( cm ) );
        }
        
        this.BindData( 1 );
        this.selectedRows = 0;
        
        return null;
    }   
    
    /**
    * Action method on next button
    * @return PageReference
    */
    public PageReference nextBtnClick(){
        
        clearMessage();
        updateSelectedList();       
        BindData( pageNumber + 1 );
        
        return null;
    }
    
    /**
    * Action method on previous button
    * @return PageReference
    */
    public PageReference previousBtnClick(){
        
        clearMessage();
        updateSelectedList();       
        BindData( pageNumber -1 );
        
        return null;
    }
    
    /**
    * This method clears the message on the visual force page.
    * @return PageReference
    */
    public pageReference clearMessage(){
        this.messageShow = false;
        return null;
    }
    
    /**
    * Get Campaign Description for selected Campaign to show on VF page     
    * @return CampaignDescription
    */                
    public String getCampaignDescription(){
        
        CampaignDescription = 'CMM_Select_Campaign';
        
        if( selectedCampaign != null ){
            Campaign myCampaign = [ select id, description from Campaign where id =: selectedCampaign ];
            CampaignDescription = myCampaign.Description;
        }
        
        return CampaignDescription;
    }

    /**
    * Update list of selected records for processing 
    */ 
    public void updateSelectedList(){
        List<myCampaignMember> members = this.getCampaignMembers();
        if( members != null ){
            for( myCampaignMember mcMember : getCampaignMembers() ){
                if( mcMember.selected == true ){
                    selectedCampaignMembersMap.put( mcMember.campmem.id, mcMember.campmem );
                }else{
                    selectedCampaignMembersMap.remove( mcMember.campmem.id );
                }
            }
            
            selectedRows = selectedCampaignMembersMap.size();
        }
    }

    /**
    * Delete selected campaign members
    * @return PageReference
    */
    public PageReference processSelected(){
        
        updateSelectedList();
        deleteCampaignMembers.clear();
        deleteCampaignMembers = selectedCampaignMembersMap.values();
        
        try{
            if( deleteCampaignMembers.size() > 0 ){
                delete deleteCampaignMembers;
                messageTitle    = 'CMM_Successful';
                messageDetail   = deleteCampaignMembers.size() + ' ' + 'CMM_Successfully_removed';
                messageSeverity = 'confirm';
                messageShow = true;
            }
            else{
                messageTitle    = 'CMM_Error';
                messageDetail   = 'Please select at least one member';
                messageSeverity = 'fatal';
                messageShow = true;
            }
        }catch( DmlException e ){
            messageTitle    = 'CMM_Error';
            messageDetail   = e.getMessage();
            messageSeverity = 'fatal';
        }finally{
            messageShow = true;
        }
        
        campaignMemberList.clear();
        selectedCampaignMembersMap.clear();
        selectedRows = 0;
        DoSearch(); 
        
        return null;
    }

    /**
    * Get list of all Campaigns with Status equals to "Planned" and with Active equals to "true"
    * @return List<SelectOption>
    */
    public List<SelectOption> getCampaigns(){
        
        List<SelectOption> options  = new List<SelectOption>();
        List<Campaign> cList        = new List<Campaign>();
        
        try {
            cList = [ SELECT Id, Name, Description FROM Campaign WHERE Status = 'Planned' AND IsActive = true ORDER BY Name ];
            for( Campaign c: cList ){
                options.add( new SelectOption( c.Id, c.Name ) );
            }
            
            if( cList == null || cList.size() <= 0 ){
                // Show Info Message that no records have been found
                messageTitle    = 'CMM_No_data';
                messageDetail   = 'CMM_No_Campaign';
                messageSeverity = 'info';
                messageShow     = true;
                
                return null;    
            }else{
                return options;
            }        
        }catch( Exception ex ){
           // Show error Message with severity FATAL
           // messageTitle  = 'CMM_Error';
           // messageDetail     = ex.getMessage();
           //messageSeverity = 'fatal';
           //messageShow    = true;
           return null;
        } 
    }
    
    /**
    * Getter method to retreieve the selected campaing
    * @return selectedCampaign
    */
    public String getSelectedCampaign(){
        return this.selectedCampaign;
    }
    
    /**
    * Setter method to set te selected Campaign
    * @param selectedCampaign
    */
    public void setSelectedCampaign( String selectedCampaign ){
        this.selectedCampaign = selectedCampaign;
    }     
    
    /**
    * Inner Class 
    * myCampaignMember to extend CampaignMember object with selected field (checkbox, boolean)
    */
    public class myCampaignMember{
        
        public CampaignMember campmem   { get; set; }
        public Boolean selected         { get; set; }
        
        /**
        * Constructor
        */
        public myCampaignMember( CampaignMember cm ){
            this.campmem    = cm;
            this.selected   = false;
        }
    } 
}