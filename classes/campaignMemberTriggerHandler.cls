Public class campaignMemberTriggerHandler{
    public static void preventMultipleActiveCampaigns(List<CampaignMember> newCampaignMemberList){
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,CampaignMember> memberMap = new Map<Id,CampaignMember>();
        for(CampaignMember c: newCampaignMemberList){
            if(c.campaignId != null && c.ContactId != null){
                contactIdSet.add(c.ContactId);
                memberMap.put(c.Id,c);
            }}
            if(contactIdSet.isEmpty()) return;
            List<Contact> allContacts =[Select id,AccountId from Contact where id in: ContactIdset]; 
            Map<Id,Id> contactAccountMap = new Map<Id,Id>();
            for(Contact C: allContacts){
                contactAccountMap.put(C.id, C.AccountId);
            }
            Set<Id> accountIds = new Set<Id>();
            accountIds.addAll(contactAccountMap.values());
            
            List<CampaignMember> existingMembers = [select id from CampaignMember where ContactId in (Select id from Contact where AccountId in:accountIds)];
            Set<Id> CampaignIds =new Set<Id>();
            for(CampaignMember cm:existingMembers ){
                CampaignIds.add(cm.campaignId);
            }
            
            List<Campaign> activeCampaigns = [Select id,isActive from Campaign where isActive=true and id in:CampaignIds];
            Map<Id, Boolean> campaignActiveMap = new Map<Id, Boolean>();
            for(campaign c: activeCampaigns){
                campaignActiveMap.put(c.Id,c.isActive);
            }
            Map<Id,Set<Id>> accountToActiveCampaigns = new Map<Id,Set<Id>>();
            
            for(CampaignMember cm: newCampaignMemberList){
                Id contactId = cm.contactId;
                Id AccountId = contactAccountMap.get(contactId);
                if(AccountId!= null && campaignActiveMap.get(cm.campaignId)){
                    if(!accountToActiveCampaigns.containsKey(AccountId)){
                        accountToActiveCampaigns.put(AccountId, new Set<Id>());
                    }
                    accountToActiveCampaigns.get(AccountId).add(cm.campaignId);
                }
            }
            
            for (CampaignMember cm : newCampaignMemberList) {
                Id contactId = cm.ContactId;
                Id accountId = contactAccountMap.get(contactId);
                if (accountId != null && campaignActiveMap.get(cm.CampaignId)) {
                    Set<Id> activeCamp = accountToActiveCampaigns.get(accountId);
                    if (activeCamp != null && !activeCamp.contains(cm.CampaignId)) {
                        cm.addError('This Account already has a Contact in another active Campaign.');
                    }
                }
            }
            
    }}