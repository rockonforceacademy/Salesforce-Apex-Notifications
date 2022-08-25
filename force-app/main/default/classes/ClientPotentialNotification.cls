public with sharing class ClientPotentialNotification {
    // Update TopClient field and notify users involved
    public static boolean UpdateTopClientAndNotify(List<Opportunity> triggerResult){
        boolean flag = null;
        
        //Retrieve records in Trigger.New so they can be written (after-triggers lock the data as Read-Only)
        List<Opportunity> oppList = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE ID IN :triggerResult];

        //Update TopClient field and notify users involved
        List<Opportunity> updateOppList = new List<Opportunity>();
        for (Opportunity opp : oppList){
            //Update TopClient field
            if (opp.Amount < 10000){
                opp.TopClient__c = 'Good';
            } else if(10000 <= opp.Amount && opp.Amount < 100000){
                opp.TopClient__c = 'Very Good';        
            } else if (opp.Amount > 100000) {
                opp.TopClient__c = 'Excellent';
            } 
            updateOppList.add(opp);
            
            //Notify users involved
            if (opp.StageName == 'Negotiation/Review' && opp.Amount > 10000 && opp.Type == 'New Customer'){
                SendNotification(opp.OwnerId, opp.Id, opp.Owner.Name);
                flag = true;        
            } else {
                flag = false;
            }
        }

        //Update records 
        update updateOppList;
        System.debug(flag);
        return flag;
    }

    //Send notification to OpportunityOwner and SystemAdministrators
    public static void SendNotification (String oppOwnerId, String oppId, String oppOwnerName){
        
        //Notify OpportunityOwner        
        Set<String> setOppOwnerId = new Set<String>();
        setOppOwnerId.add(oppOwnerId);
        CustomNotificationApexTest.notifyUsers(setOppOwnerId,oppId,oppOwnerName);
         
        //Notify SystemAdministrator if different from Opportunity Owner
        List<User> listUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND (Id != :oppOwnerId)];
            for (User us : listUser){
            Set<String> userSysAdminId = new Set<String>();
            userSysAdminId.add(String.ValueOf(us.Id));
            String userSysAdminName = String.ValueOf(us.Name);
            
            CustomNotificationApexTest.notifyUsers(userSysAdminId,oppId,userSysAdminName);                   
        }   
    }    
}