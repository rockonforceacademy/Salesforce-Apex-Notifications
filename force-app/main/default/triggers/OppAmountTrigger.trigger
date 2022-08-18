trigger OppAmountTrigger on Opportunity (after update) {
    List<Opportunity> Opp = Trigger.new;
    ClientPotentialNotification.RetrieveOpp(Opp[0].AccountId);
}