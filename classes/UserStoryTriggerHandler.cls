public class UserStoryTriggerHandler {
    public static void updateEpicTotals(List<UserStory__c> newList, Map<Id, UserStory__c> oldMap) {
        // Collect all Epic Ids that need recalculation
        Set<Id> epicIds = new Set<Id>();
        for (UserStory__c us : newList) {
            if (us.Epic__c != null) epicIds.add(us.Epic__c);
            if (oldMap != null && oldMap.containsKey(us.Id)) {
                UserStory__c oldUs = oldMap.get(us.Id);
                if (oldUs.Epic__c != null && oldUs.Epic__c != us.Epic__c) {
                    system.debug('Removed User story '+us+ ' from epic '+ oldUs.Epic__c); 
                    epicIds.add(oldUs.Epic__c);
                }
            }
        }
        // For deletes, oldMap is null, so just use newList (which is Trigger.old)
        if (oldMap == null) {
            for (UserStory__c us : newList) {
                if (us.Epic__c != null) epicIds.add(us.Epic__c);
            }
        }
        
        if (epicIds.isEmpty()) return;
        
        // Query all User Stories for these Epics
        Map<Id, List<UserStory__c>> epicToStories = new Map<Id, List<UserStory__c>>();
        for (UserStory__c us : [
            SELECT Id, Epic__c, Points__c,Story_review_by_business__c
            FROM UserStory__c
            WHERE Epic__c IN :epicIds
        ]) {
            if (!epicToStories.containsKey(us.Epic__c)) {
                epicToStories.put(us.Epic__c, new List<UserStory__c>());
            }
            epicToStories.get(us.Epic__c).add(us);
            system.debug('epicToStories Map => '+epicToStories);
        }
        
        List<Epic__c> epicsToUpdate = new List<Epic__c>();
        for (Id epicId : epicIds) {
            List<UserStory__c> stories = epicToStories.get(epicId);
            system.debug('stories Linked to Epic '+stories);
            if (stories == null || stories.isEmpty()){
                epicsToUpdate.add(new Epic__c(
                    Id = epicId,
                    TotalPoints__c = 0,
                    TotalCalPoints__c = 0
                ));
            }
            else{
                Decimal totalPoints = 0;
                Decimal totalCalPoints = 0;
                for (UserStory__c us : stories) {
                    totalPoints += (us.Points__c == null ? 0 : us.Points__c);
                    system.debug('totalPoints '+totalPoints);
                    // Replace this with your actual criteria
                    if (us.Story_review_by_business__c) {
                        totalCalPoints += (us.Points__c == null ? 0 : us.Points__c);
                        system.debug('totalCalPoints '+totalCalPoints);
                    }
                }
                epicsToUpdate.add(new Epic__c(
                    Id = epicId,
                    TotalPoints__c = totalPoints,
                    TotalCalPoints__c = totalCalPoints
                ));
                system.debug('epicsToUpdate '+epicsToUpdate);
                
            }
        }
        if (!epicsToUpdate.isEmpty()) {
            update epicsToUpdate;
        }
        rollupToParentEpics(epicIds);
    }
    /*public static void rollupToParentEpics(Set<Id> childEpicIds){
system.debug('Inside rollupToParentEpics method');
List<Epic__c> childEpics = [Select id,ParentEpic__c,TotalCalPoints__c,TotalPoints__c from Epic__c where id in:childEpicIds and ParentEpic__c != Null];
system.debug('childEpics '+childEpics);
Map<Id,List<Epic__c>> parentToChildren = new Map<Id,List<Epic__c>>();

for (Epic__c child : childEpics) {
if (!parentToChildren.containsKey(child.ParentEpic__c)) {
parentToChildren.put(child.ParentEpic__c, new List<Epic__c>());
}
parentToChildren.get(child.ParentEpic__c).add(child);
}
system.debug('parentToChildren '+parentToChildren);
List<Epic__c> parentUpdates = new List<Epic__c>();
for(Id parentId :parentToChildren.keyset()){

Decimal totalPoints = 0;
Decimal totalCalPoints = 0;
for (Epic__c child : parentToChildren.get(parentId)) {
totalPoints += (child.TotalPoints__c == null ? 0 : child.TotalPoints__c);
totalCalPoints += (child.TotalCalPoints__c == null ? 0 : child.TotalCalPoints__c);
}
system.debug('parentId '+parentId);
system.debug('totalPoints '+totalPoints);
system.debug('totalCalPoints '+totalCalPoints);
parentUpdates.add(new Epic__c(
Id = parentId,
TotalPoints__c = totalPoints,
TotalCalPoints__c = totalCalPoints
));   
}
if (!parentUpdates.isEmpty()) {
update parentUpdates;
}   
}*/
    public static void rollupToParentEpics(Set<Id> childEpicIds){
        
        System.debug('Inside rollupToParentEpics method');
        
        // Step 1: Get parent Epic IDs from the updated child Epics
        Set<Id> parentEpicIds = new Set<Id>();
        List<Epic__c> childEpics = [
            SELECT Id, ParentEpic__c
            FROM Epic__c
            WHERE Id IN :childEpicIds AND ParentEpic__c != null
        ];
        for (Epic__c child : childEpics) {
            parentEpicIds.add(child.ParentEpic__c);
        }
        
        if (parentEpicIds.isEmpty()) return;
        
        // Step 2: Get all child Epics of those parent Epics
        List<Epic__c> allChildren = [
            SELECT Id, ParentEpic__c, TotalPoints__c, TotalCalPoints__c
            FROM Epic__c
            WHERE ParentEpic__c IN :parentEpicIds
        ];
        
        // Step 3: Aggregate totals for each parent Epic
        Map<Id, List<Epic__c>> parentToChildren = new Map<Id, List<Epic__c>>();
        for (Epic__c child : allChildren) {
            if (!parentToChildren.containsKey(child.ParentEpic__c)) {
                parentToChildren.put(child.ParentEpic__c, new List<Epic__c>());
            }
            parentToChildren.get(child.ParentEpic__c).add(child);
        }
        
        List<Epic__c> parentUpdates = new List<Epic__c>();
        for (Id parentId : parentToChildren.keySet()) {
            Decimal totalPoints = 0;
            Decimal totalCalPoints = 0;
            for (Epic__c child : parentToChildren.get(parentId)) {
                totalPoints += (child.TotalPoints__c == null ? 0 : child.TotalPoints__c);
                totalCalPoints += (child.TotalCalPoints__c == null ? 0 : child.TotalCalPoints__c);
            }
            parentUpdates.add(new Epic__c(
                Id = parentId,
                TotalPoints__c = totalPoints,
                TotalCalPoints__c = totalCalPoints
            ));	
        }
        
        if (!parentUpdates.isEmpty()) {
            update parentUpdates;
        }
    }
    
}