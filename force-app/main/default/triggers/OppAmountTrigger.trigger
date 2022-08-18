trigger OppAmountTrigger on Opportunity (after insert, after update) {
    ClientPotentialNotification.RetrieveOpp(Trigger.new);
}