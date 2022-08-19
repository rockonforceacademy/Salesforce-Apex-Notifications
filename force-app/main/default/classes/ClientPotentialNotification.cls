public with sharing class ClientPotentialNotification {
                        
    // Update TopClient field and notify users involved
    public static void RetrieveOpp(List<Opportunity> triggerResult){

        List<Opportunity> oppList = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE ID IN :triggerResult];

        List<Opportunity> updateOppList = new List<Opportunity>();

        for (Opportunity opp : oppList){
            
            if (opp.Amount < 10000){
                opp.TopClient__c = 'Good';
            } else if(10000 <= opp.Amount && opp.Amount < 100000){
                opp.TopClient__c = 'Very Good';        
            } else if (opp.Amount > 100000) {
                opp.TopClient__c = 'Excellent';
            } 
            updateOppList.add(opp);
            
            if (opp.StageName == 'Negotiation/Review' && opp.Amount > 10000 && opp.Type == 'New Customer'){
                Send(String.ValueOf(opp.OwnerId),
                     String.ValueOf(opp.Id),
                     String.ValueOf(opp.Owner.Name));
            }
        }

        update updateOppList;

    }

    //Send notification to OpportunityOwner and SystemAdministrators
    public static void Send (String OppOwnerId, String OppId, String OppOwnerName){
         
        Set<String> SetOppOwnerId = new Set<String>();
        SetOppOwnerId.add(OppOwnerId);
        
        CustomNotificationApexTest.notifyUsers(SetOppOwnerId,OppId,OppOwnerName);
         
        List<User> ListUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND (Id != :OppOwnerId)];

        for (User us : ListUser){
            Set<String> userSysAdminId = new Set<String>();
            userSysAdminId.add(String.ValueOf(us.Id));
            String userSysAdminName = String.ValueOf(us.Name);
            
            CustomNotificationApexTest.notifyUsers(userSysAdminId,OppId,userSysAdminName);
        }
    }
}