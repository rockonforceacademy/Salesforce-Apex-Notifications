trigger OppAmountTrigger on Opportunity (after insert, after update) {

    if (Trigger.old != Trigger.new){
        ClientPotentialNotification.RetrieveOpp(Trigger.new);
    }
}