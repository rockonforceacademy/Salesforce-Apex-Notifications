@isTest 
    private class ClientPotentialNotificationTest {
        
        @isTest static void Amount1to10k(){

            Opportunity oppAmount1to10k = new Opportunity();
             
            oppAmount1to10k.Name = 'oppAmount1to10k';
            oppAmount1to10k.CloseDate = Date.Today();
            oppAmount1to10k.StageName = 'Negotiation/Review';
            oppAmount1to10k.Amount = 5000;
            
            Insert oppAmount1to10k;
            
            List<Opportunity> listOppAmount1to10k = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'oppAmount1to10k'];
            System.AssertEquals(listOppAmount1to10k[0].TopClient__c, 'Good');
        }               
        
        @isTest static void Amount10kto100k(){

            Opportunity oppAmount10kto100k = new Opportunity();
             
            oppAmount10kto100k.Name = 'oppAmount10kto100k';
            oppAmount10kto100k.CloseDate = Date.Today();
            oppAmount10kto100k.StageName = 'Negotiation/Review';
            oppAmount10kto100k.Amount = 50000;
            
            Insert oppAmount10kto100k;
            
            List<Opportunity> listOppAmount10kto100k = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'oppAmount10kto100k'];
            System.AssertEquals(listOppAmount10kto100k[0].TopClient__c, 'Very Good');
        }          
        
        @isTest static void Amount100kAbove(){

            Opportunity oppAmount100kAbove = new Opportunity();
             
            oppAmount100kAbove.Name = 'oppAmount100kAbove';
            oppAmount100kAbove.CloseDate = Date.Today();
            oppAmount100kAbove.StageName = 'Negotiation/Review';
            oppAmount100kAbove.Amount = 500000;
            
            Insert oppAmount100kAbove;
            
            List<Opportunity> listOppAmount100kAbove = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'oppAmount100kAbove'];
            System.AssertEquals(listOppAmount100kAbove[0].TopClient__c, 'Excellent');
        }        

        @isTest static void AmountNull(){

            Opportunity oppAmountNull = new Opportunity();
             
            oppAmountNull.Name = 'oppAmount100kAbove';
            oppAmountNull.CloseDate = Date.Today();
            oppAmountNull.StageName = 'Negotiation/Review';
            oppAmountNull.Amount = null;
            
            Insert oppAmountNull;
            
            List<Opportunity> listOppAmountNull = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'oppAmountNull'];
            System.AssertEquals(listOppAmountNull[0].TopClient__c, null);
        }     
        
        @isTest static void NotifOk(){

            List<Opportunity> listOppNotifOk = new List<Opportunity>();
            Opportunity oppNotifOk = new Opportunity();

            oppNotifOk.Name = 'oppNotif';
            oppNotifOk.CloseDate = Date.Today();
            oppNotifOk.Type = 'New Customer';
            oppNotifOk.StageName = 'Negotiation/Review';
            oppNotifOk.Amount = 500000;

            listOppNotifOk.add(oppNotifOk);

            Try {
                ClientPotentialNotification.UpdateTopClientAndNotify(listOppNotifOk);
            } catch (Exception e) {
                System.AssertEquals(e.getMessage());                
            }            
        }

    }