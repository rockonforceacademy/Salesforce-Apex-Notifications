public with sharing class ClientPotentialNotification {
        
        //coloquei o Id direto na query abaixo pq não tava pegando, mas era pra ser AcId
        public static List<Opportunity> RetrieveOpp(String AcId){
            List<Opportunity> OppList =[SELECT Name, OwnerId, StageName, Amount, Type
                                         FROM Opportunity 
                                         WHERE Account.Id = '0018Z00002hkcywQAA'];          

        for (integer i = 0; OppList.size() < i ; i++){
                                
            String ClientPot = null;                
            if (OppList[i].Amount < 10000){
                ClientPot = 'Good';
                OppList[i].TopClient__c = ClientPot;
            } else {
                if (1000 <= OppList[i].Amount && OppList[i].Amount < 100000){
                    ClientPot = 'Very Good';
                    OppList[i].TopClient__c = ClientPot;
                } else {
                    ClientPot = 'Excellent';
                    OppList[i].TopClient__c = ClientPot;
                }
            }
        }

        update OppList;
        
        for (integer i = 0; OppList.size() < i ; i++){
        if (OppList[i].StageName == 'Negotiation\Review' && OppList[i].Amount == 10000 && OppList[i].Type == 'New Customer'){
                OpportunityNotification.Send(String.ValueOf(OppList[i].OwnerId),
                                             String.ValueOf(OppList[i].Id),
                                             String.ValueOf(OppList[i].Owner.Name));
            }
        }
            return OppList;
        }
}
