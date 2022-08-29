trigger OppTrigger on Opportunity (before insert, before update) {

    List<Opportunity> oppList = new List<Opportunity>();

        // for(Opportunity opp : Trigger.new) {
        
        //     Opportunity oppOld = (Opportunity)Trigger.oldMap.get(opp.Id);
        //     Opportunity oppNew = (Opportunity)Trigger.newMap.get(opp.Id);
        //     if (oppOld.Amount != oppNew.Amount || oppOld.StageName != oppNew.StageName || oppOld.Type != oppNew.Type) {
        //         oppList.add(oppNew);
        //     }           
        // }

        // ClientPotentialNotification.updateTopClientAndNotify(oppList);

    if (Trigger.old != null){
        for(Opportunity opp : Trigger.new) {
        
            Opportunity oppOld = (Opportunity)Trigger.oldMap.get(opp.Id);
            Opportunity oppNew = (Opportunity)Trigger.newMap.get(opp.Id);
            if (oppOld.Amount != oppNew.Amount || oppOld.StageName != oppNew.StageName || oppOld.Type != oppNew.Type) {
                oppList.add(oppNew);
            }           
        }

        ClientPotentialNotification.updateTopClientAndNotify(oppList);
        } else {
            ClientPotentialNotification.updateTopClientAndNotify(Trigger.new);
        }
}