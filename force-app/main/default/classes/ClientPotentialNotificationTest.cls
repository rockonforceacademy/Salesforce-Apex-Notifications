@isTest (SeeAllData=true)
    private class ClientPotentialNotificationTest {
        
        @isTest static void UpdateTopClientAndNotify_Amount1to10k_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 5000;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Good');
        }
        
        @isTest static void UpdateTopClientAndNotify_Amount10kto100k_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 50000;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Very Good');
        }          
        
        @isTest static void UpdateTopClientAndNotify_Amount100kAbove_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = 500000;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, 'Excellent');

        }        

        @isTest static void UpdateTopClientAndNotify_AmountNull_Test(){

            Opportunity opp = new Opportunity();
             
            opp.Name = 'opp';
            opp.CloseDate = Date.Today();
            opp.StageName = 'Negotiation/Review';
            opp.Amount = null;
            
            Insert opp;
            
            List<Opportunity> listOpp = [SELECT Id, TopClient__c FROM Opportunity WHERE Name = 'opp'];
            System.AssertEquals(listOpp[0].TopClient__c, null);
        }     

        @isTest static void UpdateTopClientAndNotify_NotifZeroFieldsOk_Test(){
            
            // List<Opportunity> listOpp = new List<Opportunity>();
            // Opportunity opp = new Opportunity();

            // opp.Name = 'oppNotif';
            // opp.CloseDate = Date.Today();
            // opp.Type = 'Existing Customer - Upgrade';
            // opp.StageName = 'Prospecting';
            // opp.Amount = 50;
            
            // listOpp.add(opp);

            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 0'];
            
            Boolean NotifReturn = ClientPotentialNotification.UpdateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }
                
        @isTest static void UpdateTopClientAndNotify_NotifOneFieldOk_Test(){
            
            // List<Opportunity> listOpp = new List<Opportunity>();
            // Opportunity opp = new Opportunity();

            // opp.Name = 'oppNotif';
            // opp.CloseDate = Date.Today();
            // opp.Type = 'New Customer';
            // opp.StageName = 'Prospecting';
            // opp.Amount = 50;
            
            // listOpp.add(opp);

            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 1'];
            
            Boolean NotifReturn = ClientPotentialNotification.UpdateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }
        
        @isTest static void UpdateTopClientAndNotify_NotifTwoFieldsOk_Test(){
            
            // List<Opportunity> listOpp = new List<Opportunity>();
            // Opportunity opp = new Opportunity();
            
            // opp.Name = 'oppNotif';
            // opp.CloseDate = Date.Today();
            // opp.Type = 'New Customer';
            // opp.StageName = 'Negotiation/Review';
            // opp.Amount = 50;
            
            // listOpp.add(opp);

            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 2'];
            
            Boolean NotifReturn = null;
            NotifReturn = ClientPotentialNotification.UpdateTopClientAndNotify(listOpp);
            System.AssertEquals(false, NotifReturn);
        }

        @isTest static void UpdateTopClientAndNotify_NotifThreeFieldsOk_Test(){
    
            // List<Opportunity> listOpp = new List<Opportunity>();
            // Opportunity opp = new Opportunity();
    
            // opp.Name = 'oppNotif';
            // opp.CloseDate = Date.Today();
            // opp.Type = 'New Customer';
            // opp.StageName = 'Negotiation/Review';
            // opp.Amount = 500000;
            // opp.OwnerId = '0058Z000008rKiOQAU';
            // opp.Id = '0068Z00001Z5VVQQA3';
    
            // listOpp.add(opp);
            
            List<Opportunity> listOpp = [SELECT Id, Amount, TopClient__c, OwnerId, Owner.Name, Type, StageName FROM Opportunity WHERE Name = 'teste 3'];
            
            Boolean NotifReturn = null;
            System.debug(listOpp);
            NotifReturn = ClientPotentialNotification.UpdateTopClientAndNotify(listOpp);
            System.debug(NotifReturn);
            System.AssertEquals(true, NotifReturn);    
        }

        @isTest static void UpdateTopClientAndNotify_SendNotification_Test(){

            Opportunity opp = new Opportunity();
    
            opp.OwnerId = '0058Z000008rKiOQAU';
            opp.Id = '0068Z00001Z5VVQQA3';
            // opp.Owner.Name = 'Vitor de Carvalho';
            
            Try{
                ClientPotentialNotification.SendNotification('0058Z000008rKiOQAU', '0068Z00001Z5VVQQA3', 'Vitor de Carvalho');
            } catch (Exception e){
                System.debug('Erro ao enviar a notificação: ' + e.getMessage());
            }
        }
    }