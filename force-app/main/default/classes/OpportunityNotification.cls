public with sharing class OpportunityNotification {
    public static void Send (String OppOwnerId, String OppId, String OppOwnerName){
        Set<String> SetOppOwnerId = new Set<String>();
        SetOppOwnerId.add(OppOwnerId);

        List<Profile> ListSysAdmId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        String SysAdmId = String.ValueOf(ListSysAdmId[0].Id);
                
       //coloquei o Id direto na query abaixo pq não tava pegando, mas era pra ser SysAdmId
        List<User> ListUser = [SELECT Id FROM User WHERE ProfileId = '00e8Z000002DcniQAC'];
        //String UserSysAdmin = String.ValueOf(ListUser[0].Name);
        
        Set<String> recipientIds = new Set<String>();
        for (integer i = 0; ListUser.size() < i ; i++){
            recipientIds.add(String.ValueOf(ListUser[i].Id));
        }
                
        CustomNotificationApexTest.notifyUsers(SetOppOwnerId,OppId,OppOwnerName);
        CustomNotificationApexTest.notifyUsers(recipientIds,OppId,String.ValueOf(UserInfo.getName()));
    }
}