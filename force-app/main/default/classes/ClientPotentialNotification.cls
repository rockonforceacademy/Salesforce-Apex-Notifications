public with sharing class ClientPotentialNotification {
    // Update TopClient field and notify users involved
    public static void UpdateTopClientAndNotify(List<Opportunity> triggerResult){
        
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
                Send(opp.OwnerId, opp.Id, opp.Owner.Name);
            }
        }

        //Update records 
        update updateOppList;
    }

    //Send notification to OpportunityOwner and SystemAdministrators
    public static Boolean Send (String oppOwnerId, String oppId, String oppOwnerName){
        //Notify OpportunityOwner
        boolean flag;
        Set<String> setOppOwnerId = new Set<String>();
        setOppOwnerId.add(oppOwnerId);
        CustomNotificationApexTest.notifyUsers(setOppOwnerId,oppId,oppOwnerName);
         
        //Notify SystemAdministrator if different from Opportunity Owner
        List<User> listUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' AND (Id != :oppOwnerId)];
        Try{
            for (User us : listUser){
                Set<String> userSysAdminId = new Set<String>();
                userSysAdminId.add(String.ValueOf(us.Id));
                String userSysAdminName = String.ValueOf(us.Name);
                CustomNotificationApexTest.notifyUsers(userSysAdminId,oppId,userSysAdminName);            
            }
            flag = true;
            System.debug(flag);
            return flag;     
        } catch (Exception e) {
            System.debug('Não foi possível enviar a notificação: ' + e.getMessage());
            flag = false;
            System.debug(flag);
            return flag;        
        }   
    }    
}