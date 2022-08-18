public with sharing class ClientPotentialNotification {
                        
    // Metodo para atualizar o field TopClient e setar a notificacao para os envolvidos
    public static List<Opportunity> RetrieveOpp(List<Opportunity> oppList){
        
        for (integer i = 0; oppList.size() < i ; i++){
            
            if (oppList[i].Amount < 10000){
                oppList[i].TopClient__c = 'Good';
            } else if(1000 <= oppList[i].Amount && oppList[i].Amount < 100000){
                oppList[i].TopClient__c = 'Very Good';                
            } else {
                oppList[i].TopClient__c = 'Excellent';
            }
        }
    
        update oppList;
    
        for (integer i = 0; oppList.size() < i ; i++){
            if (oppList[i].StageName == 'Negotiation\Review' && oppList[i].Amount == 10000 && oppList[i].Type == 'New Customer'){
                Send(String.ValueOf(oppList[i].OwnerId),
                     String.ValueOf(oppList[i].Id),
                     String.ValueOf(oppList[i].Owner.Name));
            }
        }
    
        return oppList;
    }

    //Metodo para enviar a notificação para o Dono da Oportunidade e para todos os usuarios
    //com o profile de System Administrator
    public static void Send (String OppOwnerId, String OppId, String OppOwnerName){
         
        Set<String> SetOppOwnerId = new Set<String>();
        SetOppOwnerId.add(OppOwnerId);
         
        List<User> ListUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'];
         
        Set<String> SysAdmIds = new Set<String>();
        
        for (integer i = 0; ListUser.size() < i ; i++){
                SysAdmIds.add(String.ValueOf(ListUser[i].Id));
        }
             
        CustomNotificationApexTest.notifyUsers(SetOppOwnerId,OppId,OppOwnerName);
        
        for (User us : ListUser){
            Set<String> userSysAdminId = new Set<String>();
            userSysAdminId.add(String.ValueOf(us.Id));
            String userSysAdminName = String.ValueOf(us.Name);
            
            CustomNotificationApexTest.notifyUsers(userSysAdminId,OppId,userSysAdminName);
        }
    }
}
