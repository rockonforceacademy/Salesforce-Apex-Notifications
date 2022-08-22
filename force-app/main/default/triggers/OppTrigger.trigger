trigger OppTrigger on Opportunity (after insert, after update) {

    List<Opportunity> oppList = new List<Opportunity>();
    
    if (Trigger.old != null){
        for(Opportunity opp : Trigger.new) {
        
            Opportunity oppOld = (Opportunity)Trigger.oldMap.get(opp.Id);
            Opportunity oppNew = (Opportunity)Trigger.newMap.get(opp.Id);
            if (oppOld.Amount != oppNew.Amount || oppOld.StageName != oppNew.StageName || oppOld.Type != oppNew.Type) {
                oppList.add(oppNew);
            }
            //this.checkAccountFiscalInformation(acc);
        }
        ClientPotentialNotification.RetrieveOpp(oppList);
        } else {
            ClientPotentialNotification.RetrieveOpp(Trigger.new);
        }
}
